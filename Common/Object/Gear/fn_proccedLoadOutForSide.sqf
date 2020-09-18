//--------------------------fn_proccedLoadOutForSide------------------------------------------------------------------------//
//																															//
//	Filtering load out array for current side (where executing).													        //
//  Params: _gear as array of LoadOut (geting with insruction "getUnitLoadout".			  							 		//
//  Return: _result as array of two arrays: _resultGear (excludes baned stuff) and _excludes (an array of the baned stuff). //
//																															//
//--------------------------fn_proccedLoadOutForSide------------------------------------------------------------------------//

params [["_gear", []], ["_upgradeLevel", -1], ["_role", "1"]];
private ["_result", "_resultGear", "_excludes", "_itmeRole"];

_result = [];
_resultGear = [];
_excludes = [];

checkItem = {
	params [["_class", ""]];
	private ["_res", "_item"];
	
	_res = "";	
	_item = missionNamespace getVariable [format["wf_%1",_class], []];

	if(_upgradeLevel > -1 && ((count _item) > 0)) then {
		if((_item # 0) # 0 > _upgradeLevel) then {
			_item = [];
		};
	};
	
	if(_role != "1") then {
		_itmeRole = (_item # 0) # 2;
		if(_itmeRole != _role && _itmeRole != "") then {
			_item = [];
		};
	};
		
	if(_item isEqualTo []) then {
		if(_class != "") then {
			_excludes pushBackUnique _class;
		};
	} else {
		_res = _class;			
	};
	
	_res;
};

proceedWeaps = {
	params[["_items", []]];
	private["_result", "_item", "_subres", "_weap"];
	
	_result = [];
	
	{
		_weap = "";
		_isPrimeWeap = true;
		
		if(_forEachIndex > 0) then { _isPrimeWeap = false; };
		
		_subres = [];
		{
			_item = "";
			switch(_forEachIndex) do {
				case 0 : { _item = _x call checkItem; _weap = _item; };
				case 1 : { 
							if(_weap != "") then {
								_item = [];
								{
									_item pushBack (_x call checkItem);
								} forEach _x;
							} else {
								_item = ["","","",""];
							};
						 };					 
				case 2 : { 
							if(_weap != "") then {
								_item = [];
								{
									_item pushBack (_x call checkItem);
								} forEach _x;
							} else {
								if(_isPrimeWeap) then {
									_item = ["", ""];
								} else {
									_item = [""];
								};
							};
						 };
			};
			
			_subres pushBack _item;
		} forEach _x;
		_result pushBack _subres;
	} forEach _items;
	
	_result;
};

proceedPack = {
	params[["_items", []]];
	private["_result", "_item", "_subres"];
	
	_result = [];
	
	{
		_subres = [];		
		
		_item = (_x # 0) call checkItem;		
		_subres pushBack _item;
		
		if(_item != "") then {
			_item = []; //--Contant of pack--
			{
				if((_x call checkItem) != "") then {
					_item pushBack _x;
				};
			} forEach (_x # 1);
		} else {
			_item = [];
		};
		
		_subres pushBack _item;
		
		_result pushBack _subres;
	} forEach _items;
	
	_result;
};

proceedBaseItems = {
	params[["_items", []]];
	private["_result", "_item"];
	
	_result = [];
	
	{	
		_item = _x call checkItem;
		_result pushBack _item;		
	} forEach _items;
	
	_result;
};

{
	switch(_forEachIndex) do {
		case 0: { _resultGear pushBack ([_gear # _forEachIndex] call proceedWeaps); }; 		//--Weapons--
		case 1: { _resultGear pushBack ([_gear # _forEachIndex] call proceedPack); };  		//--Clothes--
		case 2: { _resultGear pushBack ([_gear # _forEachIndex] call proceedBaseItems);	};  //--Helmet and goggles
		case 3: { 
					_subRes = [];					
					_subRes pushBack ([(_gear # _forEachIndex) # 0] call proceedBaseItems);		//--Binocular and night vision
					_subRes pushBack ([(_gear # _forEachIndex) # 1] call proceedBaseItems);		//--Base items
					_resultGear pushBack _subRes;
				};
	};
} forEach _gear;

_result pushBack _resultGear;
_result pushBack _excludes;

_result;