private ['_coinCategories','_coinItemArray','_curId','_d','_defenseCategories','_defenseCosts','_defenseDescriptions','_defenses','_emptyStructures','_extra','_fix','_i','_indexCategory','_structureCosts','_structureDescriptions','_structures','_updateDefenses','_updateStructures'];
params ["_area", "_isHQdeployed", "_coin", ["_extra", ""]];

//--- Define the CoIn placement method.
missionNamespace setVariable ["WF_C_STRUCTURES_PLACEMENT_METHOD", {
    Private["_i","_factory","_sorted","_walls","_factories","_area","_lx","_ly","_type","_p","_entities"];
    _itemcategory = _this # 0;	
    _preview = _this # 1;
    _color = _this # 2;
    _eside = if (WF_Client_SideJoined == west) then {east} else {west};
    _affected = [];
	_affected append (missionNamespace getVariable Format["WF_%1STRUCTURENAMES",WF_Client_SideJoinedText]);
    _area = [_preview,((WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] Call WFCO_FNC_GetClosestEntity2;

    if(_area getVariable 'avail' <= 0) then { _color = _colorRed };
    if (surfaceIsWater(position _preview)) then { _color = _colorRed };

	_radius = 55;
    
	if ({(typeOf _preview) == _x || _preview isKindOf _x} count _affected != 0) then {
        Private["_building","_sort","_strs","_lax","_lay"];
        _strs = ((position _preview) nearEntities [
			["Land","LandVehicle","Motorcycle","Tank","Man",
			"Air","Ship","Car","Helicopter","Static","ThingEffect","Thing",
			"ThingEffectLight","StaticWeapon","Plane","Strategic","Building",
			"NonStrategic","Wreck","Site_F","Module_F","Logic","Church","House",
			"HouseBase","Church_F","House_F","Ruins","Wall"], 
		_radius]) - [_preview];
		_strs1 = nearestTerrainObjects [_preview, 
			["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "BUNKER", "FORTRESS", 
			"FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "QUAY", "FUELSTATION", 
			"HOSPITAL", "FENCE", "WALL", "BUSSTOP", "TRANSMITTER", "RUIN", 
			"TOURISM", "WATERTOWER", "ROCK", "ROCKS", "POWER LINES", "POWERSOLAR",
			"POWERWAVE", "POWERWIND", "SHIPWRECK"], _radius];
		_strs = _strs + _strs1;		
        if (count _strs == 0) exitWith {};
        _sort = [_preview,_strs] Call WFCO_FNC_SortByDistance;
        _building = _sort select 0;
        _lax=((boundingBox _building) select 1) select 0;
        _lay=((boundingBox _building) select 1) select 1;		
        if(_preview distance _building < (25  + (_lax max _lay))) then {
            _color = _colorRed
        } else{
            _color = _colorGreen
        };
    };	

    if (_itemcategory == 2) then {
        _color = _colorGreen;
        _walls = _preview nearEntities [[typeOf _preview],2];

        if(count _walls > 1) then {_color = _colorRed} else{_color = _colorGreen};
        if(count (nearestObjects [_preview, missionNamespace getVariable (Format["WF_%1DEFENSENAMES",WF_Client_SideJoined]),((((boundingbox _preview) select 1) select 0) max (((boundingbox _preview) select 1) select 1)) max 2] - [_preview]) > 0) then {_color = _colorRed} else{_color = _colorGreen};
        _entities = (position _preview) nearEntities [['Man','Car','Motorcycle','Tank','Air','Ship'],12];
        if ((count _entities > 0) && {side _x != WF_Client_SideJoined} count _entities !=0) then {_color = _colorRed};
        _factories = _preview nearEntities [["house", "Man", "Air", "Car", "Motorcycle", "Tank"],35];
        if (count _factories == 0) exitWith {};
        _sorted = [_preview,_factories] Call WFCO_FNC_SortByDistance;
        _factory = _sorted select 0;
        _type=typeOf _factory;
        _lx=((boundingbox _factory) select 1) select 0;
        _ly=((boundingbox _factory) select 1) select 1;		

        _p=12;

        if(_preview distance _factory < _p*(_lx min _ly)) then { _color = _colorRed };
    } else {
        private ["_objects","_sideEfacs","_object"];
        _sideEfacs = if (side commanderTeam == west) then {east} else {west};
		_preobjects = _preview nearEntities [[],85];
		_objects = [];
		
		_objects = (_preobjects select { (typeOf _x) in (missionNamespace getVariable Format["WF_%1STRUCTURENAMES",WF_Client_SideJoinedText]) });
        if (count _objects > 0) then {
            if (side (_objects select 0) == _sideEfacs && _preview distance (_objects select 0) < 10)then {_color = _colorRed};
        };
    };

    if (_itemcategory == 3) then {
        Private["_camos"];
        _color = _colorGreen;
        _camos = _preview nearEntities [[typeOf _preview],85];
        if(count _camos > 1) then {
            _color = _colorRed
        } else{_color = _colorGreen};
    };

    if (typeOf _preview == "Sign_Danger" && !isNull ([_preview,((WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] Call WFCO_FNC_GetClosestEntity2)) then {
        _color = _colorRed;
        hintsilent "Minefields are not allowed at base!";
    };

    if ((typeOf _preview) isKindOf "StaticWeapon") then { _color = _colorGreen; };

    if ((typeOf _preview) iskindOf "Warfare_HQ_base_unfolded") then {
        Private ["_town","_townside","_eArea"];
        _town = [_preview] Call WFCO_FNC_GetClosestLocation;
        _townside =  (_town getVariable "sideID") Call WFCO_FNC_GetSideFromID;
        _eArea = [_preview,((_eside) Call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] Call WFCO_FNC_GetClosestEntity3;
        if!(isNil "_townside")then{
            if ((_preview distance _town < 600 && _townside != WF_Client_SideJoined) || !isNull _eArea) then {
                _color = _colorRed;
                 hintSilent parseText "<t color='#fb0808'> You have entered a restricted area ! Impossible to build here! </t>";
            };
        };
    };

    if(!((typeOf _preview) iskindOf "Warfare_HQ_base_unfolded"))then{
        _current_side  = side commanderTeam;
        _opposite_side = east;

        if(_current_side == west)then{
            _opposite_side = east;
        } else{
            _opposite_side = west;
        };

        _detected = (_area nearEntities [["Man","Car","Motorcycle","Tank","Air","Ship"], missionNamespace getVariable "WF_C_BASE_AREA_RANGE"]) unitsBelowHeight 20;
        {
            if(_itemcategory !=0 && side _x == _opposite_side)exitwith{
                _color = _colorRed;
                hintSilent parseText "<t color='#fb0808'> Enemies are detected near your base! </t>";
            };

        }foreach _detected;
    };

    _color
}];

_coin setVariable ["BIS_COIN_areasize", _area];
_coin setVariable ["BIS_COIN_fundsDescription",["$"]];
if (_extra == "") then {
	_coin setVariable ["BIS_COIN_funds",[(WF_Client_SideJoined) Call WFCO_FNC_GetSideSupply, Call WFCL_FNC_GetPlayerFunds]];
	_coin setVariable ["BIS_COIN_fundsDescription",["S ","$ "]];
};

_defenses = [];
_defenseCosts = [];
_defenseDescriptions = [];
_defenseCategories = [];

_structures = [(missionNamespace getVariable Format["WF_%1STRUCTURENAMES",WF_Client_SideJoinedText]) # 0];
_structureCosts = [(missionNamespace getVariable Format["WF_%1STRUCTURECOSTS",WF_Client_SideJoinedText]) # 0];
_structureDescriptions = [(missionNamespace getVariable Format["WF_%1STRUCTUREDESCRIPTIONS",WF_Client_SideJoinedText]) # 0];

_i = 0;

_updateStructures = false;
_updateDefenses = false;
_emptyStructures = false;

if (_isHQdeployed && _extra == "") then {_i = 1;_updateStructures = true; _updateDefenses = true};
if (_extra == "REPAIR") then {_updateDefenses = true; _emptyStructures = true;_coin setVariable ["BIS_COIN_funds",Call WFCL_FNC_GetPlayerFunds]};

if (_updateStructures) then {
	_structures = missionNamespace getVariable Format["WF_%1STRUCTURENAMES",WF_Client_SideJoinedText];
	_structureCosts = missionNamespace getVariable Format["WF_%1STRUCTURECOSTS",WF_Client_SideJoinedText];
	_structureDescriptions = missionNamespace getVariable Format["WF_%1STRUCTUREDESCRIPTIONS",WF_Client_SideJoinedText];
};

if (_updateDefenses) then {
	_defenses = missionNamespace getVariable Format["WF_%1DEFENSENAMES",WF_Client_SideJoinedText];
	{
		_d = missionNamespace getVariable _x;		
		if !(isNil '_d') then {
			_defenseCosts pushBack (_d select QUERYUNITPRICE);
			_defenseDescriptions pushBack ((_d select QUERYUNITLABEL));
			_defenseCategories pushBack ((_d select QUERYUNITFACTORY));
		};
	} forEach _defenses;
};

if (_emptyStructures) then {
	_structures = [];
	_structureCosts = [];
	_structureDescriptions = [];
};

_indexCategory=0;
_coinCategories = [];
_coinItemArray = [];
if (count _structures > 0) then {_coinCategories = _coinCategories + [localize "strwfbase"];_indexCategory =_indexCategory +1;};
if (count _defenses > 0) then {
    if (_extra == "REPAIR") then {_coinCategories = []};
    _coinCategories pushBack (localize "str_m04t37_0");
    _coinCategories pushBack (localize "STR_WF_Fortification");
    _coinCategories pushBack (localize "STR_WF_Strategic");
    _coinCategories pushBack (localize "STR_WF_Ammo");
};

for [{_i=_i}, {_i<count _structures}, {_i = _i+1}] do {
  _coinItemArray pushBack ([_structures select _i,0,[0, _structureCosts select _i], (_structureDescriptions select _i)]);
};

_fix = 1;
if (_extra == "REPAIR") then {_coinItemArray = [];_indexCategory=0;_fix = 0};

for '_i' from 0 to count(_defenses)-1 do {	
	_curId = _indexCategory;
	
	switch (_defenseCategories select _i) do {
		case "Fortification": {_curId = _indexCategory + 1};
		case "Strategic": {_curId = _indexCategory + 2};
		case "Ammo": {_curId = _indexCategory + 3};
	};
    _coinItemArray pushBack ([_defenses select _i,_curId,[_fix, _defenseCosts select _i], _defenseDescriptions select _i]);
};

_coin setVariable ["BIS_COIN_categories",_coinCategories]; 
_coin setVariable ["BIS_COIN_items",_coinItemArray];

//--- Logic ID
if (isnil "BIS_coin_lastID") then {BIS_coin_lastID = -1};
BIS_coin_lastID = BIS_coin_lastID + 1;
call compile format ["BIS_coin_%1 = _coin; _coin setvehiclevarname 'BIS_coin_%1';",BIS_coin_lastID];

_coin setVariable ["BIS_COIN_ID",BIS_coin_lastID];

//--- Temporary variables
_coin setVariable ["BIS_COIN_params",[]];