#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"

#define DEFAULT_MATERIAL "\a3\data_f\default.rvmat"
#define DEFAULT_TEXTURE "#(rgb,8,8,3)color(0,0,0,0)"
#define FADE_DELAY	0.15

disableserialization;

private _fullVersion = missionnamespace getvariable ["BIS_fnc_arsenal_fullArsenal", false]; // INCLUDE IDENTITY
private _broadcastUpdates = isMultiplayer && _fullVersion;
private _mode = param [0, "Open", [displaynull, ""]];
private _confirmAction = param [2, false];
_this = param [1, []];

private _fnc_getFaceConfig =
{
	private _faces = missionnamespace getvariable ["BIS_fnc_arsenal_faces", [[],[]]];
	private _faceIndex = _faces select 0 findIf { _this == _x };
	if (_faceIndex > -1) exitWith { _faces select 1 select _faceIndex };
	configNull
};

private _fnc_arrayFlatten = {
    private ["_res", "_fnc"];
    _res = [];
    _fnc = {
        {
            if (typeName _x isEqualTo "ARRAY") then [
                {_x call _fnc; false},
                {
                    if(_x != "") then {
                        _res pushBack _x;
                        false
                    }
                }
            ];
        } count _this;
    };
    _this call _fnc;
    _res
};

private _fnc_setUnitInsignia =
{
	params ["_unit", "_insignia", ["_global", false]];

	private _index = getArray (configFile >> "CfgVehicles" >> getText (configFile >> "CfgWeapons" >> uniform _unit >> "ItemInfo" >> "uniformClass") >> "hiddenSelections") findIf { _x == "insignia" };
	private _materialArray = [_index, getText (configfile >> "CfgUnitInsignia" >> _insignia >> "material") call {[_this, DEFAULT_MATERIAL] select (_this isEqualTo "")}];
	private _textureArray = [_index, getText (configfile >> "CfgUnitInsignia" >> _insignia >> "texture") call {[_this, DEFAULT_TEXTURE] select (_this isEqualTo "")}];

	_unit setVariable ["BIS_fnc_setUnitInsignia_class", [_insignia, nil] select (_insignia isEqualTo ""), true];

	if (_global) exitWith
	{
		_unit setObjectMaterialGlobal _materialArray;
		_unit setObjectTextureGlobal _textureArray;
	};

	_unit setObjectMaterial _materialArray;
	_unit setObjectTexture _textureArray;
};

private _fnc_arrayToLower = {
    private ["_array","_index"];

    _array = +_this;
    _tolower = [];

    {_tolower pushBack (toLower _x)} forEach _array;

    _tolower
};

private _fnc_getUnitInsignia  = { _this getVariable ["BIS_fnc_setUnitInsignia_class", ""] };

#define IDCS_LEFT\
	IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,\
	IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,\
	IDC_RSCDISPLAYARSENAL_TAB_HANDGUN,\
	IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,\
	IDC_RSCDISPLAYARSENAL_TAB_VEST,\
	IDC_RSCDISPLAYARSENAL_TAB_BACKPACK,\
	IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR,\
	IDC_RSCDISPLAYARSENAL_TAB_GOGGLES,\
	IDC_RSCDISPLAYARSENAL_TAB_NVGS,\
	IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,\
	IDC_RSCDISPLAYARSENAL_TAB_MAP,\
	IDC_RSCDISPLAYARSENAL_TAB_GPS,\
	IDC_RSCDISPLAYARSENAL_TAB_RADIO,\
	IDC_RSCDISPLAYARSENAL_TAB_COMPASS,\
	IDC_RSCDISPLAYARSENAL_TAB_WATCH

#define IDCS_RIGHT\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC\

#define IDCS	[IDCS_LEFT,IDCS_RIGHT]

#define INITTYPES\
		private _types = [];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,["Uniform"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_VEST,["Vest"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_BACKPACK,["Backpack"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR,["Headgear"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_GOGGLES,["Glasses"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_NVGS,["NVGoggles"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,["Binocular","LaserDesignator"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,["AssaultRifle","MachineGun","SniperRifle","Shotgun","Rifle","SubmachineGun"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,["Launcher","MissileLauncher","RocketLauncher"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_HANDGUN,["Handgun"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_MAP,["Map"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_GPS,["GPS","UAVTerminal"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_RADIO,["Radio"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_COMPASS,["Compass"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_WATCH,["Watch"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,[/*"Grenade","SmokeShell"*/]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,[/*"Mine","MineBounding","MineDirectional"*/]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC,["FirstAidKit","Medikit","MineDetector","Toolkit"]];

#define GETVIRTUALCARGO\
	private _virtualItemCargo =\
		(missionnamespace call bis_fnc_getVirtualItemCargo) +\
		(_cargo call bis_fnc_getVirtualItemCargo) +\
		items _center +\
		assigneditems _center +\
		primaryweaponitems _center +\
		secondaryweaponitems _center +\
		handgunitems _center +\
		[uniform _center,vest _center,headgear _center,goggles _center];\
	private _virtualWeaponCargo = [];\
	{\
		_weapon = _x call bis_fnc_baseWeapon;\
		_virtualWeaponCargo set [count _virtualWeaponCargo,_weapon];\
		{\
			private ["_item"];\
			_item = gettext (_x >> "item");\
			if !(_item in _virtualItemCargo) then {_virtualItemCargo set [count _virtualItemCargo,_item];};\
		} foreach ((configfile >> "cfgweapons" >> _x >> "linkeditems") call bis_fnc_returnchildren);\
	} foreach ((missionnamespace call bis_fnc_getVirtualWeaponCargo) + (_cargo call bis_fnc_getVirtualWeaponCargo) + weapons _center + [binocular _center]);\
	private _virtualMagazineCargo = (missionnamespace call bis_fnc_getVirtualMagazineCargo) + (_cargo call bis_fnc_getVirtualMagazineCargo) + magazines _center;\
	private _virtualBackpackCargo = (missionnamespace call bis_fnc_getVirtualBackpackCargo) + (_cargo call bis_fnc_getVirtualBackpackCargo) + [backpack _center];

#define STATS_WEAPONS\
	["reloadtime","dispersion","maxzeroing","hit","mass","initSpeed"],\
	[true,true,false,true,false,false]

#define STATS_EQUIPMENT\
	["passthrough","armor","maximumLoad","mass"],\
	[false,false,false,false]

#define ADDBINOCULARSMAG\
	_magazines = getarray (configfile >> "cfgweapons" >> _item >> "magazines");\
	if (count _magazines > 0) then {_center addmagazine (_magazines select 0);};

#define CONDITION(ITEMLIST)	(_fullVersion || {"%ALL" in ITEMLIST} || { ITEMLIST findIf {_item == _x} > -1 })
#define ERROR if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};

//--- Function to get item DLC. Don't use item itself, but the first addon in which it's defined. SOme items are re-defined in mods.
#define GETDLC\
	{\
		private _dlc = "";\
		private _addons = configsourceaddonlist _this;\
		if (count _addons > 0) then {\
			private _mods = configsourcemodlist (configfile >> "CfgPatches" >> _addons select 0);\
			if (count _mods > 0) then {\
				_dlc = _mods select 0;\
			};\
		};\
		_dlc\
	}


#define ADDMODICON\
	{\
		private _dlcName = _this call GETDLC;\
		if (_dlcName != "") then {\
			_ctrlList lbsetpictureright [_lbAdd,(modParams [_dlcName,["logo"]]) param [0,""]];\
		};\
	};

//--- Defautl mod list for sorting
#define MODLIST ["","curator","kart","heli","mark","expansion","expansionpremium"]

#define CAM_DIS_MAX	7

//--- 7erra defines
#include "..\gui\scripts\idcs.inc"
#define SELF TER_fnc_shop
#define STRSELF #SELF
#define MONEYGREEN [0.13,0.42,0.16,1]
#define INF "∞"
#define COL_PIC 0
#define COL_NAME 1
#define COL_COUNT 2
#define COL_PRICE 3
#define COL_STARTCOUNT 4

#define COL_DATA_CLASS 0
#define COL_DATA_COUNT 0
#define COL_DATA_STARTCOUNT 1

_fnc_CurAdd = {
	params ["_item"];
	private _addCur = [TER_VASS_changedItems, tolower _item] call BIS_fnc_findInPairs;
	_addCur = if (_addCur == -1) then {0} else {TER_VASS_changedItems#_addCur#1};
	_addCur
};

_fnc_stringReplace = {
    params["_str", "_find", "_replace"];

    private _return = "";
    private _len = count _find;
    private _pos = _str find _find;

    while {(_pos != -1) && (count _str > 0)} do {
        _return = _return + (_str select [0, _pos]) + _replace;

        _str = (_str select [_pos+_len]);
        _pos = _str find _find;
    };
    _return + _str;
};

_fnc_getEquipment = {
    private _target = player;
    //--- Uniform, Vest and backpack
    _uniform = toLower(uniform _target);
    _uniform_items = (uniformItems _target) call _fnc_arrayToLower;
    _vest = toLower(vest _target);
    _vest_items = (vestItems _target) call _fnc_arrayToLower;
    _backpack = toLower(backpack _target);
    _backpack_items = (backpackItems _target) call _fnc_arrayToLower;

    //--- Weapons
    _primary = toLower(primaryWeapon _target);
    _primary_accessories = (primaryWeaponItems _target) call _fnc_arrayToLower;
    _secondary = toLower(secondaryWeapon _target);
    _secondary_accessories = (secondaryWeaponItems _target) call _fnc_arrayToLower;
    _handgun = toLower(handgunWeapon _target);
    _handgun_accessories = (handgunItems _target) call _fnc_arrayToLower;

    //--- Currently loaded magazines
    _primary_current_magazine = (primaryWeaponMagazine _target) call _fnc_arrayToLower;
    _secondary_current_magazine = (secondaryWeaponMagazine _target) call _fnc_arrayToLower;
    _handgun_current_magazine = (handgunMagazine _target) call _fnc_arrayToLower;

    //--- Accessories
    _headgear = toLower(headgear _target);
    _goggles = toLower(goggles _target);

    _binomag = "";
    {
        if ((_x select 0) isEqualTo binocular _target) exitWith {
            _binomag = (_x select 4) param [0, ""];
        };
    } forEach weaponsitems _target;

    //--- Items
    _allitems = ((assignedItems _target) call _fnc_arrayToLower) - [_headgear, _goggles];
    _items = [["", ["",""]], ["", "", "", "", ""]];

    {
        _slot = switch (getText(configFile >> 'CfgWeapons' >> _x >> 'simulation')) do {
            case "NVGoggles": {[0,0]};
            case "Binocular": {[0,1]};
            case "ItemMap": {[1,0]};
            case "ItemGPS": {[1,1]};
            case "ItemRadio": {[1,2]};
            case "ItemCompass": {[1,3]};
            case "ItemWatch": {[1,4]};
            default {[-1]};
        };
        if ((_slot select 0) isEqualTo -1) then {
            if (getNumber(configFile >> 'CfgWeapons' >> _x >> 'ItemInfo' >> 'type') isEqualTo WF_SUBTYPE_UAVTERMINAL) then {_slot = [1,1]};
            if (getNumber(configFile >> 'CfgWeapons' >> _x >> 'useAsBinocular') isEqualTo 1 && getText(configFile >> 'CfgWeapons' >> _x >> 'simulation') isEqualTo "weapon") then {_slot = [0,1]};
        };
        if !(_slot select 0 isEqualTo -1) then {
            if (_slot isEqualTo [0,1]) then {
                ((_items select (_slot select 0)) select (_slot select 1)) set [0, _x];
                ((_items select (_slot select 0)) select (_slot select 1)) set [1, _binomag];
            } else {
                (_items select (_slot select 0)) set [(_slot select 1), _x];
            }
        };
    } forEach _allitems;
    _items = [[toLower ((_items select 0) select 0), ((_items select 0) select 1) call _fnc_arrayToLower] , (_items select 1) call _fnc_arrayToLower];

    //--- Return the preformated gear
    [
        [[_primary, _primary_accessories, _primary_current_magazine], [_secondary, _secondary_accessories, _secondary_current_magazine], [_handgun, _handgun_accessories, _handgun_current_magazine]],
        [[_uniform, _uniform_items], [_vest, _vest_items], [_backpack, _backpack_items]],
        [_headgear, _goggles],
        _items
    ]
};

_fnc_ArrayToLower = {
    private ["_array","_index"];

    _array = +_this;
    _tolower = [];

    {_tolower pushBack (toLower _x)} forEach _array;

    _tolower
};

_fnc_ArrayDiffers = {
    private ["_array1", "_array2", "_different", "_item"];
    _array1 = _this select 0;
    _array2 = _this select 1;

    _different = false;

    if (count _array1 != count _array2) then {
    	_different = true;
    } else {
    	{
    		_item = _x;
    		if (({_x == _item} count _array1) != ({_x == _item} count _array2)) exitWith { _different = true };
    	} forEach _array1;
    };
    _different
};

_fnc_EquipContainerBackpack = {
    params ["_unit", "_backpack", "_items"];
    private ["_added", "_count"];

    if !(backpack _unit isEqualTo _backpack) then { removeBackpack _unit };
    if (!(_backpack isEqualTo "") && backpack _unit isEqualTo "") then { _unit addBackpack _backpack };
    if !(backpack _unit isEqualTo "") then { clearAllItemsFromBackpack _unit };

    _added = [];
    {
    	_item = _x;
    	if !(_item isEqualTo "") then {
    		if !(_item in _added) then {
    			_added pushBack _item;
    			_count = {_x isEqualTo _item} count _items;

    			(unitBackPack _unit) addItemCargoGlobal [_item, _count];
    		};
    	};
    } forEach _items;
};

_fnc_EquipContainerVest = {
    params ["_unit", "_vest", "_items"];
    private ["_added", "_count"];

    if !(vest _unit isEqualTo "") then {removeVest _unit};
    if (!(_vest isEqualTo "") && vest _unit isEqualTo "") then { _unit addVest _vest };

    _added = [];
    {
    	_item = _x;
    	if !(_item isEqualTo "") then {
    		if !(_item in _added) then {
    			_added pushBack _item;
    			_count = {_x isEqualTo _item} count _items;

    			(vestContainer _unit) addItemCargoGlobal [_item, _count];
    		};
    	};
    } forEach _items;
};

_fnc_EquipContainerUniform = {
    params ["_unit", "_uniform", "_items"];
    private ["_added", "_count"];

    if !(uniform _unit isEqualTo "") then {removeUniform _unit};
    if (!(_uniform isEqualTo "") && uniform _unit isEqualTo "") then { _unit forceAddUniform _uniform };

    _added = [];
    {
    	_item = _x;
    	if !(_item isEqualTo "") then {
    		if !(_item in _added) then {
    			_added pushBack _item;
    			_count = {_x isEqualTo _item} count _items;

    			(uniformContainer _unit) addItemCargoGlobal [_item, _count];
    		};
    	};
    } forEach _items;
};

_fnc_EquipUnit = {
    params["_unit", "_gear"];

    //--- ######## [Weapons check-in] ########
    //--- Primary
    _new = (_gear select 0) select 0;

    _item = _new select 0;

    _accessories = (_new select 1) call _fnc_ArrayToLower;
    _magazines = _new select 2;

    if (primaryWeapon _unit != _item && primaryWeapon _unit != "") then {_unit removeWeapon (primaryWeapon _unit)};
    if (primaryWeapon _unit != _item && _item != "") then {_unit addWeapon _item};
    if (_item != "") then {

        {_unit removeMagazine _x} forEach magazines _unit;
        _unit removeWeapon _item;
        {
            _unit addMagazine _x;
        }foreach _magazines;
        _unit addWeapon _item;
    	_accessories_current = (primaryWeaponItems _unit) call _fnc_ArrayToLower;
    	{if (!(_x in _accessories) && (_x != "")) then {_unit removePrimaryWeaponItem _x}} forEach _accessories_current;
    	{if (!(_x in _accessories_current) && (_x != "")) then {_unit addPrimaryWeaponItem _x}} forEach (_accessories + _magazines);
    };

    //--- Secondary
    _new = (_gear select 0) select 1;
    _item = _new select 0;
    _accessories = (_new select 1) call _fnc_ArrayToLower;
    _magazines = _new select 2;

    if (secondaryWeapon _unit != _item && secondaryWeapon _unit != "") then {_unit removeWeapon (secondaryWeapon _unit)};
    if (secondaryWeapon _unit != _item && _item != "") then {_unit addWeapon _item};
    if (_item != "") then {
    	_accessories_current = (secondaryWeaponItems _unit) call _fnc_ArrayToLower;
    	{if (!(_x in _accessories) && (_x != "")) then {_unit removeSecondaryWeaponItem _x}} forEach _accessories_current;
    	{if (!(_x in _accessories_current) && (_x != "")) then {_unit addSecondaryWeaponItem _x}} forEach (_accessories + _magazines);
    };

    //--- Handgun
    _new = (_gear select 0) select 2;
    _item = _new select 0;
    _accessories = (_new select 1) call _fnc_ArrayToLower;
    _magazines = _new select 2;

    if (handgunWeapon _unit != _item && handgunWeapon _unit != "") then {_unit removeWeapon (handgunWeapon _unit)};
    if (handgunWeapon _unit != _item && _item != "") then {_unit addWeapon _item};
    if (_item != "") then {
    	_accessories_current = (handgunItems _unit) call _fnc_ArrayToLower;
    	{if (!(_x in _accessories) && (_x != "")) then {_unit removeHandgunItem _x}} forEach _accessories_current;
    	{if (!(_x in _accessories_current) && (_x != "")) then {_unit addHandgunItem _x}} forEach (_accessories + _magazines);
    };

    //--- Muzzle
    {
    	if !(_x isEqualTo "") exitWith {
    		_muzzles = getArray (configFile >> "CfgWeapons" >> _x >> "muzzles");
    		if !("this" in _muzzles) then {_unit selectWeapon (_muzzles select 0)} else {_unit selectWeapon _x};
    	};
    } forEach [primaryWeapon _unit, handgunWeapon _unit, secondaryWeapon _unit];

    //--- ######## [Equipment check-in] ########
    _new = _gear select 1;

    //--- Check if the containers are ok
    if (!((((_gear select 1) select 2) select 0) isEqualTo backpack _unit) || [((_gear select 1) select 2) select 1, backpackItems _unit] call _fnc_ArrayDiffers) then {
    	[_unit, ((_gear select 1) select 2) select 0, ((_gear select 1) select 2) select 1] call _fnc_EquipContainerBackpack;
    };
    if (!((((_gear select 1) select 1) select 0) isEqualTo vest _unit) || [((_gear select 1) select 1) select 1, vestItems _unit] call _fnc_ArrayDiffers) then {
    	[_unit, ((_gear select 1) select 1) select 0, ((_gear select 1) select 1) select 1] call _fnc_EquipContainerVest;
    };
    if (!((((_gear select 1) select 0) select 0) isEqualTo uniform _unit) || [((_gear select 1) select 0) select 1, uniformItems _unit] call _fnc_ArrayDiffers) then {
    	[_unit, ((_gear select 1) select 0) select 0, ((_gear select 1) select 0) select 1] call _fnc_EquipContainerUniform;
    };


    //--- ######## [Assigned items check-in] ########
    removeAllAssignedItems _unit; //--- Due to the lack of commands for some of them, we remove everything first aside from goggles and headgear
    _new = _gear select 2;

    _item = _new select 0;
    if !(_item isEqualTo headgear _unit) then {removeHeadgear _unit};
    if !(_item isEqualTo "") then {_unit addHeadgear _item};

    _item = _new select 1;
    if !(_item isEqualTo goggles _unit) then {removeGoggles _unit};
    if !(_item isEqualTo "") then {_unit addGoggles _item};

    { if !(_x isEqualTo "") then {_unit linkItem _x} } forEach ([((_gear select 3) select 0) select 0] + ((_gear select 3) select 1));

    //--- Binoculars are special, they can't be linked like the other items.
    if ((((_gear select 3) select 0) select 1) isEqualType []) then {
    	if !(((((_gear select 3) select 0) select 1) select 0) isEqualTo "") then {_unit addWeapon ((((_gear select 3) select 0) select 1) select 0)};
    	if !(((((_gear select 3) select 0) select 1) select 1) isEqualTo "") then {_unit addMagazine ((((_gear select 3) select 0) select 1) select 1)};
    } else {
    	if !((((_gear select 3) select 0) select 1) isEqualTo "") then {_unit addWeapon (((_gear select 3) select 0) select 1)};
    }
};

switch _mode do {
	case "postInit": {
	    [ missionNamespace, "arsenalClosed", {
        			["arsenalClosed",_this] call SELF;
        		}] call BIS_fnc_addScriptedEventHandler;
	};
	case "preInit":{
		//--- Init the system
		//--- Make all functions available in uiNamespace
		{
			_fnc = format ["TER_fnc_%1", configName _x];
			_file = format["Client\Player\GUI\GearMenu\fnc\fn_%1.sqf", configName _x];
			uiNamespace setVariable [_fnc, compile preprocessFileLineNumbers _file];
		} forEach ("true" configClasses (missionConfigFile >> "CfgFunctions" >> "TER" >> "VASS"));

		// ["Preload"] call BIS_fnc_arsenal;
		private ["_data"];
        INITTYPES
        _data = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];

        _configArray = (
            ("isclass _x" configclasses (configfile >> "cfgweapons")) +
            ("isclass _x" configclasses (configfile >> "cfgvehicles")) +
            ("isclass _x" configclasses (configfile >> "cfgglasses"))
        );

        {
            _class = _x;
            _className = configname _x;
            _scope = if (isnumber (_class >> "scopeArsenal")) then {getnumber (_class >> "scopeArsenal")} else {getnumber (_class >> "scope")};
            _isBase = if (isarray (_x >> "muzzles")) then {(_className call bis_fnc_baseWeapon == _className)} else {true}; //-- Check if base weapon (true for all entity types)
            if (_scope == 2 && {gettext (_class >> "model") != ""} && _isBase) then {
                private ["_weaponType","_weaponTypeCategory"];
                _weaponType = (_className call bis_fnc_itemType);
                _weaponTypeCategory = _weaponType select 0;
                if (_weaponTypeCategory != "VehicleWeapon") then {
                    private ["_weaponTypeSpecific","_weaponTypeID"];
                    _weaponTypeSpecific = _weaponType select 1;
                    _weaponTypeID = -1;
                    {
                        if (_weaponTypeSpecific in _x) exitwith {_weaponTypeID = _foreachindex;};
                    } foreach _types;
                    if (_weaponTypeID >= 0) then {
                        private ["_items"];
                        _items = _data select _weaponTypeID;
                        _items set [count _items,configname _class];
                    };
                };
            };
        } foreach _configArray;

        //--- Magazines - Put and Throw
        _magazinesThrowPut = [];
        {
            private ["_weapons","_tab","_magazines"];
            _weapon = _x select 0;
            _tab = _x select 1;
            _magazines = [];
            {
                {
                    private ["_mag"];
                    _mag = _x;
                    if ({_x == _mag} count _magazines == 0) then {
                        private ["_cfgMag"];
                        _magazines set [count _magazines,_mag];
                        _cfgMag = configfile >> "cfgmagazines" >> _mag;
                        if (getnumber (_cfgMag >> "scope") == 2 || getnumber (_cfgMag >> "scopeArsenal") == 2) then {
                            private ["_items"];
                            _items = _data select _tab;
                            _items pushback configname _cfgMag;
                            _magazinesThrowPut pushback tolower _mag;
                        };
                    };
                } foreach getarray (_x >> "magazines");
            } foreach ("isclass _x" configclasses (configfile >> "cfgweapons" >> _weapon));
        } foreach [
            ["throw",IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW],
            ["put",IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT]
        ];

        //--- Magazines
        {
            if (getnumber (_x >> "type") > 0 && {(getnumber (_x >> "scope") == 2 || getnumber (_x >> "scopeArsenal") == 2) && {!(tolower configname _x in _magazinesThrowPut)}}) then {
                private _items = _data select IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL;
                _items pushback configname _x;
            };
        } foreach ("isclass _x" configclasses (configfile >> "cfgmagazines"));

        missionnamespace setvariable ["bis_fnc_arsenal_data",_data];

		[ missionNamespace, "arsenalOpened", {
			["arsenalOpened",_this] call SELF;
		}] call BIS_fnc_addScriptedEventHandler;
	};
	case "arsenalClosed": {
	    WF_P_CurrentGear = (_center) call WFCO_FNC_GetUnitLoadout;
        WF_P_gearPurchased = true;
        missionNamespace setVariable ["wf_gear_lastpurchased", WF_P_CurrentGear];
        hudOn = true;
        shallResetDisplay = true;
        ctrlSetText[13020, "HUD ON"]
	};
	case "arsenalOpened":{
		if (isNil "TER_VASS_shopObject") exitWith {};
		_display = _this select 0;
		uiNamespace setVariable ["TER_VASS_changedItems",[]];
		//--- Arsenal was opened
		_display setVariable ["shop_loadoutStart",getUnitLoadout _center];
		_display setVariable ["shop_cost",0];
		_display displayAddEventHandler ["unLoad",{
			with uiNamespace do {["shopUnLoad",_this] call SELF};
		}];
		//--- Handle display
		_display displaySetEventHandler ["keydown",format ["with (uinamespace) do {['KeyDown',_this] call %1;};", STRSELF]];
		{
			_btnDisable = _display displayCtrl _x;
			_btnDisable ctrlEnable false;
			_btnDisable ctrlShow false;
			_btnDisable ctrlSetFade 1;
			_btnDisable ctrlCommit 0;
		} forEach [IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONIMPORT, IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONRANDOM];

		_ctrlButtonLoad = _display displayctrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONLOAD;
		_ctrlButtonLoad ctrlRemoveAllEventHandlers "buttonclick";
        _ctrlButtonLoad ctrladdeventhandler ["buttonclick",format ["with uinamespace do {['buttonLoad',[ctrlparent (_this select 0),'init']] call %1;};",STRSELF]];

		_ctrlButtonLoadTemplateOk = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONOK;
		_ctrlButtonLoadTemplateOk ctrlRemoveAllEventHandlers "buttonclick";
        _ctrlButtonLoadTemplateOk ctrladdeventhandler ["buttonclick",format ["with uinamespace do {['buttonTemplateOk',[ctrlparent (_this select 0),'init']] call %1;};",STRSELF]];

        _ctrlTemplateButtonDelete = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONDELETE;
        _ctrlTemplateButtonDelete ctrlRemoveAllEventHandlers "buttonclick";
        _ctrlTemplateButtonDelete ctrladdeventhandler ["buttonclick",format ["with uinamespace do {['buttonDelete',[ctrlparent (_this select 0),'init']] call %1;};",STRSELF]];

        _ctrlButtonExport = _display displayctrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONEXPORT;
        _ctrlButtonExport ctrlRemoveAllEventHandlers "buttonclick";
        _ctrlButtonExport ctrladdeventhandler ["buttonclick",format ["with uinamespace do {['buttonReload',[ctrlparent (_this select 0),'init']] call %1;};",STRSELF]];
        _ctrlButtonExport ctrlSetText "Reload";

		//--- New "BUY" button
		_ctrlButtonInterface = _display displayctrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONINTERFACE;
		_ctrlButtonInterface ctrlSetTooltip "Check purchases and leave shop";
		_ctrlButtonInterface ctrlSetEventHandler ["buttonclick",format ["with uinamespace do {['buttonBuy',[ctrlparent (_this select 0),'init']] call %1;};",STRSELF]];
		["costChange",[_display,[""]]] call SELF;
		_ctrlButtonInterface ctrlAddEventHandler ["MouseEnter",{
			with uiNamespace do {["buyMouse",[_this#0, +1]] call SELF};
		}];
		_ctrlButtonInterface ctrlAddEventHandler ["MouseExit",{
			with uiNamespace do {["buyMouse",[_this#0, -1]] call SELF};
		}];
		_wBtn =  2 * ((safezoneW - 1 * (((safezoneW / safezoneH) min 1.2) / 40)) * 0.1) - 0.1 * (((safezoneW / safezoneH) min 1.2) / 40);
		_ctrlButtonInterface ctrlSetPositionW _wBtn;
		_ctrlButtonInterface ctrlCommit 0;
		//--- New checkout controlsgroup
		_ctrlCheckout = _display ctrlCreate ["TER_VASS_RscCheckout", IDC_RSCDISPLAYCHECKOUT_CHECKOUT];
		_ctrlCheckout ctrlEnable false;

		//--- Control EHs
		_ctrlArrowLeft = _display displayctrl IDC_RSCDISPLAYARSENAL_ARROWLEFT;
		_ctrlArrowLeft ctrlSetEventHandler ["buttonclick","with uinamespace do {['buttonCargo',[ctrlparent (_this select 0),-1]] call TER_fnc_shop;};"];

		_ctrlArrowRight = _display displayctrl IDC_RSCDISPLAYARSENAL_ARROWRIGHT;
		_ctrlArrowRight ctrlSetEventHandler ["buttonclick","with uinamespace do {['buttonCargo',[ctrlparent (_this select 0),+1]] call TER_fnc_shop;};"];

		_sortValues = uinamespace getvariable ["ter_fnc_shop_sort",[]];
		{
			_idc = _x;
			_ctrlIcon = _display displayctrl (IDC_RSCDISPLAYARSENAL_ICON + _idc);
			_ctrlTab = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _idc);
			_mode = if (_idc in [IDCS_LEFT]) then {"TabSelectLeft"} else {"TabSelectRight"};
			{
				_x ctrlSetEventHandler ["buttonclick",format ["with uinamespace do {['%2',[ctrlparent (_this select 0),%1]] call %3;};",_idc,_mode,STRSELF]];
			} foreach [_ctrlIcon,_ctrlTab];

			_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _idc);
			_ctrlList ctrlSetEventHandler ["lbselchanged",format ["with uinamespace do {['SelectItem',[ctrlparent (_this select 0),(_this select 0),%1]] call %2;};",_idc,STRSELF]];

			//--- Add prices to the listboxes
			if (ctrltype _ctrlList == 102) then {
				// LNB
				_newColumn = _ctrlList lnbAddColumn 0.7;
				_newnewColumn = _ctrlList lnbAddColumn -1;
				_ctrlList lnbSetColumnsPos [0.07, 0.15, 0.6, 0.71];
				for "_row" from 0 to (lnbSize _ctrlList select 0) do {
					_item = _ctrlList lnbData [_row,0];
					_itemValues = [TER_VASS_shopObject, _item] call TER_fnc_getItemValues;
					_itemValues params ["", "_itemCost","_itemAmount"];
					_symbol = [str _itemAmount, INF] select (_itemAmount isEqualTo true);
					_ctrlList lnbSetText [[_row, _newColumn], format ["%1$", [_itemCost] call BIS_fnc_numberText]];
					_ctrlList lnbSetColor [[_row,_newColumn], MONEYGREEN];
				};
			} else {
				// LB
				for "_row" from 0 to (lbSize _ctrlList) do {
					if (_ctrlList lbPictureRight _row == "") then {
						_ctrlList lbSetPictureRight [_row,"\a3\ui_f\data\igui\cfg\targeting\empty_ca.paa"];
					};
					_item = _ctrlList lbData _row;
					if (_item != "") then {
						_itemValues = [TER_VASS_shopObject, _item] call TER_fnc_getItemValues;
						_itemValues params ["", "_itemCost","_itemAmount"];
						_curText = _ctrlList lbText _row;
						_text = [format ["%2", _itemAmount, _curText], _curText] select (_itemAmount isEqualTo true);
						_ctrlList lbSettext [_row, _text];
						_ctrlList lbSetTextRight [_row,format ["%1$", [_itemCost] call BIS_fnc_numberText]];
						_ctrlList lbSetColorRight [_row, MONEYGREEN];
						_ctrlList lbsetvalue [_row, _itemCost];
					} else {
						_ctrlList lbsetvalue [_row, -1e+6];
					};
				};
			};

			//--- Sort EH
			_sort = _sortValues param [_idc,0];
			_ctrlSort = _display displayctrl (IDC_RSCDISPLAYARSENAL_SORT + _idc);
			_ctrlSort ctrlSetEventHandler ["lbselchanged",format ["with uinamespace do {['lbSort',[_this,%1]] call %2;};",_idc, STRSELF]];
			lbClear _ctrlSort;
			{_ctrlSort lbAdd _x} forEach ["Name", "$ -> $$$", "$$$ -> $"];
			_ctrlSort lbsetcursel _sort;
			_sortValues set [_idc,_sort];

		} foreach IDCS;
		uinamespace setvariable ["ter_fnc_shop_sort",_sortValues];
        if (hudOn) then {
            hudOn = !hudOn;
            ctrlSetText[13020, "HUD OFF"];
        };
	};
	case "shopUnLoad":{
		params ["_display","_exitCode"];
		{_x setVariable ["TER_VASS_shopObject",nil]} forEach [missionnamespace, uiNamespace];
		TER_VASS_changedItems = nil;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		if (_exitCode != 1) then {
			_center setUnitLoadout (_display getVariable "shop_loadoutStart");
		};
	};
	case "buttonCargo": {
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_display = _this select 0;
		_add = _this select 1;

		_selected = -1;
		{
			_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
			if (ctrlenabled _ctrlList) exitwith {_selected = _x;};
		} foreach [IDCS_LEFT];

		_ctrlList = ctrlnull;
		_lbcursel = -1;
		{
			_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
			if (ctrlenabled _ctrlList) exitwith {_lbcursel = lbcursel _ctrlList;};
		} foreach [IDCS_RIGHT];
		_item = _ctrlList lnbdata [_lbcursel,0];
		if !(tolower _item in (TER_VASS_shopObject getVariable ["TER_VASS_cargo",[]])) exitWith {
			playSound "addItemFailed";
			["showMessage", [_display, "The shop does not have this item."]] call bis_fnc_arsenal;
		};
		_load = 0;
		_items = [uniformItems _center, vestItems _center, backpackitems _center] select (_selected - IDC_RSCDISPLAYARSENAL_TAB_UNIFORM);
		_mpCost = 0;
		_value = {_x == _item} count _items;
		_lnbData = _display displayCtrl IDC_RSCDISPLAYARSENAL_DATA;
		_addCur = [_item] call _fnc_CurAdd;
		_addMax = [TER_VASS_shopObject, _item, 2] call TER_fnc_getItemValues;
		_addAllowed = if (_addMax isEqualType true) then {_addMax} else {_addCur < _addMax};

		switch _selected do {
			case IDC_RSCDISPLAYARSENAL_TAB_UNIFORM: {
				if (_add > 0) then {
					if (_center canAddItemToUniform _item && _addAllowed) then {
						_mpCost = 1;
						_center additemtouniform _item;
					};
				} else {
					if (uniformItems _center findIf {tolower _x == _item} > -1) then {
						_mpCost = -1;
						_center removeItemFromUniform _item;
					};
				};
				_load = loaduniform _center;
				_items = uniformitems _center;
			};
			case IDC_RSCDISPLAYARSENAL_TAB_VEST: {
				if (_add > 0) then {
					if (_center canAddItemToVest _item && _addAllowed) then {
						_mpCost = 1;
						_center additemtovest _item;
					};
				} else {
					if (vestitems _center findIf {tolower _x == _item} > -1) then {
						_mpCost = -1;
						_center removeItemFromVest _item;
					};
				};
				_load = loadvest _center;
				_items = vestitems _center;
			};
			case IDC_RSCDISPLAYARSENAL_TAB_BACKPACK: {
				if (_add > 0) then {
					if (_center canAddItemToBackpack _item && _addAllowed) then {
						_mpCost = 1;
						_center addItemToBackpack _item;
					};//m
				} else {
					if (backpackitems _center findIf {tolower _x == _item} > -1) then {
						_mpCost = -1;
						_center removeitemfrombackpack _item;
					};//m
				};
				_load = loadbackpack _center;
				_items = backpackitems _center;
			};
		};
		["costChange",[_display, [_item], _mpCost]] call SELF;
		_ctrlList lnbsetvalue [[_lbcursel,COL_COUNT], _addCur +_mpCost];

		_ctrlLoadCargo = _display displayctrl IDC_RSCDISPLAYARSENAL_LOADCARGO;
		_ctrlLoadCargo progresssetposition _load;

		_value = {_x == _item} count _items;
		_text = if (_addMax isEqualType true) then {str _value} else {format ["%1|%2", _value, _addMax - _addCur - _mpCost]};
		_ctrlList lnbsettext [[_lbcursel,2], _text];

		["SelectItemRight",[_display,_ctrlList,_index]] call bis_fnc_arsenal;
	};

	case "TabSelectLeft": {
		_display = _this select 0;
		_index = _this select 1;

		{
			_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
			_ctrlList lbsetcursel -1;
			lbclear _ctrlList;
		} foreach [
			IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
			IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
			IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
			IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD
		];

		{
			_idc = _x;
			_active = _idc == _index;

			{
				_ctrlList = _display displayctrl (_x + _idc);
				_ctrlList ctrlenable _active;
				_ctrlList ctrlsetfade ([1,0] select _active);
				_ctrlList ctrlcommit FADE_DELAY;
			} foreach [IDC_RSCDISPLAYARSENAL_LIST,IDC_RSCDISPLAYARSENAL_LISTDISABLED,IDC_RSCDISPLAYARSENAL_SORT];

			_ctrlTab = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _idc);
			_ctrlTab ctrlenable !_active;

			if (_active) then {

				_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _idc);
			    if(_idc == IDC_RSCDISPLAYARSENAL_TAB_GOGGLES) then {
			        lbclear _ctrlList;

			        _lbAdd = _ctrlList lbadd format ["<%1>",localize "str_empty"];
                    _ctrlList lbsetvalue [_lbAdd,-1e+6];
                    _ctrlList lbSetPictureRight [_lbAdd,"\a3\ui_f\data\igui\cfg\targeting\empty_ca.paa"];

                    private _cargo = (TER_VASS_shopObject) getVariable ["TER_VASS_cargo",[]];
                    {
                        if (typeName _x == 'STRING') then {
                            _config = configFile >> 'CfgGlasses' >> _x;
                            if(isClass _config) then {
                                _itemCost = _cargo # (_forEachIndex + 1);
                                _itemAmount = _cargo # (_forEachIndex + 2);
                                private _displayName = gettext (_config >> "displayName");
                                private _data = str [_x,_itemAmount,_displayName];
                                _lbAdd = _ctrlList lbadd _displayName;
                                _ctrlList lbsetdata [_lbAdd,_x];
                                _ctrlList lbsetpicture [_lbAdd,gettext (_config >> "picture")];
                                _curText = _ctrlList lbText _lbAdd;
                                _text = [format ["%2", _itemAmount, _curText], _curText] select (_itemAmount isEqualTo true);
                                _ctrlList lbSettext [_lbAdd, _text];
                                _ctrlList lbSetTextRight [_lbAdd,format ["%1$", [_itemCost] call BIS_fnc_numberText]];
                                _ctrlList lbSetColorRight [_lbAdd, MONEYGREEN];
                                _ctrlList lbsetvalue [_lbAdd, _itemCost];
                                _ctrlList lbSetPictureRight [_lbAdd,"\a3\ui_f\data\igui\cfg\targeting\empty_ca.paa"];
                                (_config) call ADDMODICON;
                            }
                        }
                    } forEach _cargo;
			    };

				_ctrlLineTabLeft = _display displayctrl IDC_RSCDISPLAYARSENAL_LINETABLEFT;
				_ctrlLineTabLeft ctrlsetfade 0;
				_ctrlTabPos = ctrlposition _ctrlTab;
				_ctrlLineTabPosX = (_ctrlTabPos select 0) + (_ctrlTabPos select 2) - 0.01;
				_ctrlLineTabPosY = (_ctrlTabPos select 1);
				_ctrlLineTabLeft ctrlsetposition [
					safezoneX,
					_ctrlLineTabPosY,
					(ctrlposition _ctrlList select 0) - safezoneX,
					ctrlposition _ctrlTab select 3
				];
				_ctrlLineTabLeft ctrlcommit 0;
				ctrlsetfocus _ctrlList;
				['SelectItem',[_display,_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _idc),_idc]] call SELF;
			};

			_ctrlIcon = _display displayctrl (IDC_RSCDISPLAYARSENAL_ICON + _idc);
			_ctrlIcon ctrlshow _active;
			_ctrlIcon ctrlenable !_active;

			_ctrlIconBackground = _display displayctrl (IDC_RSCDISPLAYARSENAL_ICONBACKGROUND + _idc);
			_ctrlIconBackground ctrlshow _active;
		} foreach [IDCS_LEFT];

		{
			_ctrl = _display displayctrl _x;
			_ctrl ctrlsetfade 0;
			_ctrl ctrlcommit FADE_DELAY;
		} foreach [
			IDC_RSCDISPLAYARSENAL_LINETABLEFT,
			IDC_RSCDISPLAYARSENAL_FRAMELEFT,
			IDC_RSCDISPLAYARSENAL_BACKGROUNDLEFT
		];

		//--- Weapon attachments
		_showItems = _index in [IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,IDC_RSCDISPLAYARSENAL_TAB_HANDGUN];
		_fadeItems = [1,0] select _showItems;
		{
			_idc = _x;
			_ctrl = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _idc);
			_ctrl ctrlenable _showItems;
			_ctrl ctrlsetfade _fadeItems;
			_ctrl ctrlcommit 0;//FADE_DELAY;
			{
				_ctrl = _display displayctrl (_x + _idc);
				_ctrl ctrlenable _showItems;
				_ctrl ctrlsetfade _fadeItems;
				_ctrl ctrlcommit FADE_DELAY;
			} foreach [IDC_RSCDISPLAYARSENAL_LIST,IDC_RSCDISPLAYARSENAL_LISTDISABLED,IDC_RSCDISPLAYARSENAL_SORT];
		} foreach [
			IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
			IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
			IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
			IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD
		];
		if (_showItems) then {['TabSelectRight',[_display,IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC]] call SELF;};

		//--- Containers
		_showCargo = _index in [IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,IDC_RSCDISPLAYARSENAL_TAB_VEST,IDC_RSCDISPLAYARSENAL_TAB_BACKPACK];
		_fadeCargo = [1,0] select _showCargo;
		{
			_idc = _x;
			_ctrl = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _idc);
			_ctrl ctrlenable _showCargo;
			_ctrl ctrlsetfade _fadeCargo;
			_ctrl ctrlcommit 0;
			{
				_ctrlList = _display displayctrl (_x + _idc);
				_ctrlList ctrlenable _showCargo;
				_ctrlList ctrlsetfade _fadeCargo;
				_ctrlList ctrlcommit FADE_DELAY;
			} foreach [IDC_RSCDISPLAYARSENAL_LIST,IDC_RSCDISPLAYARSENAL_LISTDISABLED];
		} foreach [
			IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,
			IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,
			IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,
			IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,
			IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC
		];
		_ctrl = _display displayctrl IDC_RSCDISPLAYARSENAL_LOADCARGO;
		_ctrl ctrlsetfade _fadeCargo;
		_ctrl ctrlcommit FADE_DELAY;
		if (_showCargo) then {['TabSelectRight',[_display,IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG]] call SELF;};

		//--- Right sidebar
		_showRight = _showItems || _showCargo;
		_fadeRight = [1,0] select _showRight;
		{
			_ctrl = _display displayctrl _x;
			_ctrl ctrlsetfade _fadeRight;
			_ctrl ctrlcommit FADE_DELAY;
		} foreach [
			IDC_RSCDISPLAYARSENAL_LINETABRIGHT,
			IDC_RSCDISPLAYARSENAL_FRAMERIGHT,
			IDC_RSCDISPLAYARSENAL_BACKGROUNDRIGHT
		];
	};

	case "TabSelectRight": {
		_display = _this select 0;
		_index = _this select 1;
		_ctrFrameRight = _display displayctrl IDC_RSCDISPLAYARSENAL_FRAMERIGHT;
		_ctrBackgroundRight = _display displayctrl IDC_RSCDISPLAYARSENAL_BACKGROUNDRIGHT;
		{
			_idc = _x;
			_active = _idc == _index;

			{
				_ctrlList = _display displayctrl (_x + _idc);
				_ctrlList ctrlenable _active;
				_ctrlList ctrlsetfade ([1,0] select _active);
				_ctrlList ctrlcommit FADE_DELAY;
			} foreach [IDC_RSCDISPLAYARSENAL_LIST,IDC_RSCDISPLAYARSENAL_LISTDISABLED,IDC_RSCDISPLAYARSENAL_SORT];

			_ctrlTab = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _idc);
			_ctrlTab ctrlenable (!_active && ctrlfade _ctrlTab == 0);

			if (_active) then {
				_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _idc);
				_ctrlLineTabRight = _display displayctrl IDC_RSCDISPLAYARSENAL_LINETABRIGHT;
				_ctrlLineTabRight ctrlsetfade 0;
				_ctrlTabPos = ctrlposition _ctrlTab;
				_ctrlLineTabPosX = (ctrlposition _ctrlList select 0) + (ctrlposition _ctrlList select 2);
				_ctrlLineTabPosY = (_ctrlTabPos select 1);
				_ctrlLineTabRight ctrlsetposition [
					_ctrlLineTabPosX,
					_ctrlLineTabPosY,
					safezoneX + safezoneW - _ctrlLineTabPosX,
					ctrlposition _ctrlTab select 3
				];
				_ctrlLineTabRight ctrlcommit 0;
				ctrlsetfocus _ctrlList;

				_ctrlLoadCargo = _display displayctrl IDC_RSCDISPLAYARSENAL_LOADCARGO;
				_ctrlListPos = ctrlposition _ctrlList;
				_ctrlListPos set [3,(_ctrlListPos select 3) + (ctrlposition _ctrlLoadCargo select 3)];
				{
					_x ctrlsetposition _ctrlListPos;
					_x ctrlcommit 0;
				} foreach [_ctrFrameRight,_ctrBackgroundRight];

				if (
					_idc in [
						IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,
						IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,
						IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,
						IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,
						IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC
					]
				) then {
					//--- Update counts for all items in the list
					_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
					_selected = IDC_RSCDISPLAYARSENAL_TAB_UNIFORM;
					_itemsCurrent = switch true do {
						case (ctrlenabled (_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_UNIFORM))): {
							uniformitems _center
						};
						case (ctrlenabled (_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_VEST))): {
							_selected = IDC_RSCDISPLAYARSENAL_TAB_VEST;
							vestitems _center
						};
						case (ctrlenabled (_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_BACKPACK))): {
							_selected = IDC_RSCDISPLAYARSENAL_TAB_BACKPACK;
							backpackitems _center
						};
						default {[]};
					};
					for "_l" from 0 to (lbsize _ctrlList - 1) do {
						_class = _ctrlList lnbdata [_l,0];
						_itemMax = [TER_VASS_shopObject, _class, 2] call TER_fnc_getItemValues;

						_value =  {_x == _class} count _itemsCurrent;
						_addCur = [_class] call _fnc_CurAdd;
						_text = if (_itemMax isEqualType true) then {str _value} else {format ["%1|%2", _value, _itemMax - _addCur]};
						_ctrlList lnbsettext [[_l, COL_COUNT], _text];
					};
					["SelectItemRight",[_display,_ctrlList,_index]] call bis_fnc_arsenal;
				};
			};

			_ctrlIcon = _display displayctrl (IDC_RSCDISPLAYARSENAL_ICON + _idc);
			_ctrlIcon ctrlshow _active;
			_ctrlIcon ctrlenable (!_active && ctrlfade _ctrlTab == 0);

			_ctrlIconBackground = _display displayctrl (IDC_RSCDISPLAYARSENAL_ICONBACKGROUND + _idc);
			_ctrlIconBackground ctrlshow _active;
		} foreach [IDCS_RIGHT];
	};

	case "SelectItem": {
		private ["_ctrlList","_index","_cursel"];
		_display = _this select 0;
		_ctrlList = _this select 1;
		_index = _this select 2;
		_cursel = lbcursel _ctrlList;
		if (_cursel < 0) exitwith {};
		_item = if (ctrltype _ctrlList == 102) then {_ctrlList lnbdata [_cursel,0]} else {_ctrlList lbdata _cursel};
		private _center = missionnamespace getvariable ["BIS_fnc_arsenal_center",player];

		_ctrlListPrimaryWeapon = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON);
		_ctrlListSecondaryWeapon = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON);
		_ctrlListHandgun = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_HANDGUN);

		private _addedItems = [];
		private _removedItems = [];

		_loadout = getUnitLoadout _center;
		switch _index do
		{
			case IDC_RSCDISPLAYARSENAL_TAB_UNIFORM:
			{
				_removedItems pushBack uniform _center;
				if (_item == "") then {
					_removedItems append uniformItems _center;
					removeuniform _center;
				} else {
					_items = uniformitems _center;
					_removedItems append _items;
					_center forceadduniform _item;
					_addedItems = [_item];
					while {count uniformitems _center > 0} do {_center removeitemfromuniform (uniformitems _center select 0);}; //--- Remove default config contents
					{
						if (_center canAddItemToUniform _x) then {
							_center additemtouniform _x;
							_removedItems deleteAt (_removedItems find _x)};
					} foreach _items;
				};

				[_center, _center call _fnc_getUnitInsignia, false] call _fnc_setUnitInsignia;

			};
			case IDC_RSCDISPLAYARSENAL_TAB_VEST:
			{
				_removedItems pushBack vest _center;
				if (_item == "") then {
					_removedItems append vestItems _center;
					removevest _center;
				} else {
					_items = vestitems _center;
					_removedItems append _items;
					_center addvest _item;
					_addedItems = [_item];
					while {count vestitems _center > 0} do {_center removeitemfromvest (vestitems _center select 0);}; //--- Remove default config contents
					{
						if (_center canAddItemToVest _x) then {
							_center addItemToVest _x;
							_removedItems deleteAt (_removedItems find _x)};
					} foreach _items;
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_BACKPACK: {
				_items = backpackitems _center;
				_removedItems pushBack backpack _center;
				_removedItems append _items;
				removebackpack _center;
				if !(_item == "") then {
					_center addbackpack _item;
					_addedItems = [_item];
					while {count backpackitems _center > 0} do {_center removeitemfrombackpack (backpackitems _center select 0);}; //--- Remove default config contents
					{
						if (_center canAddItemToBackpack _x) then {
							_center addItemToBackpack _x;
							_removedItems deleteAt (_removedItems find _x)};
					} foreach _items;
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR: {
				_removedItems = [headgear _center];
				if (_item == "") then {
					removeheadgear _center;
				} else {
					_center addheadgear _item;
					_addedItems = [_item];
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_GOGGLES: {
				_removedItems = [goggles _center];
				if (_item == "") then {
					removegoggles _center;
				} else {
					_center addgoggles _item;
					_addedItems = [_item];
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_NVGS:{
				if (_item == "") then {
					_weapons = [];
					for "_l" from 0 to (lbsize _ctrlList) do {_weapons set [count _weapons,tolower (_ctrlList lbdata _l)];};
					{
						if (tolower _x in _weapons) then {_center removeweapon _x; _removedItems pushBack _x};
					} foreach (assigneditems _center);
				} else {
					_removedItems pushBack hmd _center;
					_center addweapon _item;
					_addedItems pushBack _item;
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS: {
			    if (typeName _item == "ARRAY") then { _item = _item # 0 };
				if (_item == "") then {
					_weapons = [];
					for "_l" from 0 to (lbsize _ctrlList) do {_weapons set [count _weapons,tolower (_ctrlList lbdata _l)];};
					{
						if (tolower _x in _weapons) then {_center removeweapon _x; _removedItems pushBack _x};
					} foreach (assigneditems _center);
				} else {
					_removedItems pushBack binocular _center;
					_center addweapon _item;
					_addedItems pushBack _item;
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON: {
				_isDifferentWeapon = (primaryweapon _center call bis_fnc_baseWeapon) != _item;
				if (_isDifferentWeapon) then {
					_removedItems pushBack primaryWeapon _center;
					_removedItems append (primaryweaponitems _center -[""]);
					_loadedMags = [_loadout#0 param [4,[]], _loadout#0 param [5,[]]];
					_loadedMags = _loadedMags select {_x param [1,0] > 0};
					if ({count _x > 0} count _loadedMags > 0) then {
						{
							_x params ["_class", "_count"];
							if (typeName _class == "ARRAY") then { _class = _class # 0 };
							if (_center canAdd _class) then {
								_center addMagazine [_class, _count];
							} else {
								_removedItems pushBack _class;
							};
						} forEach _loadedMags;
					};

					if (_item == "") then {
						_center removeweapon primaryweapon _center;
					} else {
						_compatibleItems = _item call bis_fnc_compatibleItems;
						_weaponAccessories = primaryweaponitems _center - [""];
						[_center,_item,0] call bis_fnc_addweapon;
						_addedItems pushBack _item;
						{
							_acc = _x;
							if ({_x == _acc} count _compatibleItems > 0) then {
								_center addprimaryweaponitem _acc;
								_removedItems deleteAt (_removedItems find _acc);
							};
						} foreach _weaponAccessories;
					};
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON: {
				_isDifferentWeapon = (secondaryweapon _center call bis_fnc_baseWeapon) != _item;
				if (_isDifferentWeapon) then {
					_removedItems pushBack secondaryweapon _center;
					_removedItems append (secondaryWeaponItems _center -[""]);
					_loadedMags = [_loadout#1 param [4,[]], _loadout#1 param [5,[]]];
					_loadedMags = _loadedMags select {_x param [1,0] > 0};
					if ({count _x > 0} count _loadedMags > 0) then {
						{
							_x params ["_class", "_count"];
							if (_center canAdd _class) then {
                                if (typeName _x == "ARRAY") then { _x = _x # 0 };
								_center addMagazine [_x, _count];
							} else {
								_removedItems pushBack _class;
							};
						} forEach _loadedMags;
					};

					if (_item == "") then {
						_center removeweapon secondaryweapon _center;
					} else {
						_compatibleItems = _item call bis_fnc_compatibleItems;
						_weaponAccessories = secondaryWeaponItems _center - [""];
						[_center,_item,0] call bis_fnc_addweapon;
						_addedItems pushBack _item;
						{
							_acc = _x;
							if ({_x == _acc} count _compatibleItems > 0) then {
								_center addSecondaryWeaponItem _acc;
								_removedItems deleteAt (_removedItems find _acc);
							};
						} foreach _weaponAccessories;
					};
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_HANDGUN: {
				_isDifferentWeapon = (handgunweapon _center call bis_fnc_baseWeapon) != _item;
				if (_isDifferentWeapon) then {
					_loadedMags = [_loadout#2 param [4,[]], _loadout#2 param [5,[]]];
					_loadedMags = _loadedMags select {_x param [1,0] > 0};
					if ({count _x > 0} count _loadedMags > 0) then {
						{
							_x params ["_class", "_count"];
							if (typeName _x == "ARRAY") then {
                                _x = _x # 0
                            };
							if (_center canAdd _class) then {
								_center addMagazine [_x, _count];
							} else {
								_removedItems pushBack _class;
							};
						} forEach _loadedMags;
					};

					if (_item == "") then {
						_removedItems pushBack handgunweapon _center;
						_removedItems append handgunItems _center;
						_center removeweapon handgunweapon _center;
					} else {
						_compatibleItems = _item call bis_fnc_compatibleItems;
						_weaponAccessories = handgunItems _center - [""];
						_removedItems append _weaponAccessories;
						[_center,_item,0] call bis_fnc_addweapon;
						_addedItems pushBack _item;
						{
							_acc = _x;
							if ({_x == _acc} count _compatibleItems > 0) then {
								_center addHandgunItem _acc;
								_removedItems deleteAt (_removedItems find _acc);
							};
						} foreach _weaponAccessories;
					};
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_MAP;
			case IDC_RSCDISPLAYARSENAL_TAB_GPS;
			case IDC_RSCDISPLAYARSENAL_TAB_RADIO;
			case IDC_RSCDISPLAYARSENAL_TAB_COMPASS;
			case IDC_RSCDISPLAYARSENAL_TAB_WATCH: {
				if (_item == "") then {
					_items = [];
					for "_l" from 0 to (lbsize _ctrlList) do {_items set [count _items,tolower (_ctrlList lbdata _l)];};
					{
						if (tolower _x in _items) then {_center unassignitem _x; _center removeitem _x; _removedItems pushBack _x;};
					} foreach (assigneditems _center);
				} else {
					if (!(tolower _item in (assigneditems _center apply {toLower _x}))) then {
						_removedItems = assigneditems _center;
						_center linkitem _item;
						_removedItems = _removedItems -assigneditems _center;
						_removedItems deleteAt (_removedItems find _item);
						_addedItems pushBack _item;
					};
				};
			};
			case IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC;
			case IDC_RSCDISPLAYARSENAL_TAB_ITEMACC;
			case IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE;
			case IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD: {
				_accIndex = [
					IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
					IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
					IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
					IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD
				] find _index;
				switch true do {
					case (ctrlenabled _ctrlListPrimaryWeapon): {
						_removedItems pushBack ((_center weaponAccessories primaryWeapon _center) select _accIndex);
						if (_item != "") then {
							_center addprimaryweaponitem _item;
							_addedItems pushBack _item;
						} else {
							_weaponAccessories = _center weaponaccessories primaryweapon _center;
							if (count _weaponAccessories > 0) then {
								_center removeprimaryweaponitem (_weaponAccessories select _accIndex);
							};
						};
						clearRadio;
					};
					case (ctrlenabled _ctrlListSecondaryWeapon): {
						_removedItems pushBack ((_center weaponAccessories secondaryweapon _center) select _accIndex);
						if (_item != "") then {
							_center addsecondaryweaponitem _item;
							_addedItems pushBack _item;
						} else {
							_weaponAccessories = _center weaponaccessories secondaryweapon _center;
							if (count _weaponAccessories > 0) then {_center removesecondaryweaponitem (_weaponAccessories select _accIndex);};
						};
					};
					case (ctrlenabled _ctrlListHandgun): {
						_removedItems pushBack ((_center weaponAccessories handgunweapon _center) select _accIndex);
						if (_item != "") then {
							_center addhandgunitem _item;
							_addedItems pushBack _item;
						} else {
							_weaponAccessories = _center weaponaccessories handgunweapon _center;
							if (count _weaponAccessories > 0) then {_center removehandgunitem (_weaponAccessories select _accIndex);};
						};
					};
				};
			};
		};
		["costChange",[_display,_addedItems,+1]] call SELF;
		["costChange",[_display,_removedItems,-1]] call SELF;

		//--- Container Cargo
		if (
			_index in [IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,IDC_RSCDISPLAYARSENAL_TAB_VEST,IDC_RSCDISPLAYARSENAL_TAB_BACKPACK]
			&&
			ctrlenabled (_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _index))
		) then {
			_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);
			GETVIRTUALCARGO

			_itemsCurrent = [];
			_load = 0;
			switch _index do {
				case IDC_RSCDISPLAYARSENAL_TAB_UNIFORM: {
					_itemsCurrent = uniformitems _center;
					_load = if (uniform _center == "") then {1} else {loaduniform _center};
				};
				case IDC_RSCDISPLAYARSENAL_TAB_VEST: {
					_itemsCurrent = vestitems _center;
					_load = if (vest _center == "") then {1} else {loadvest _center};
				};
				case IDC_RSCDISPLAYARSENAL_TAB_BACKPACK: {
					_itemsCurrent = backpackitems _center;
					_load = if (backpack _center == "") then {1} else {loadbackpack _center};
				};
				default {[]};
			};

			_ctrlLoadCargo = _display displayctrl IDC_RSCDISPLAYARSENAL_LOADCARGO;
			_ctrlLoadCargo progresssetposition _load;

			//--- Weapon magazines (based on current weapons)
			private ["_ctrlList"];
			_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG);
			_columns = count lnbGetColumnsPosition _ctrlList;
			lbclear _ctrlList;
			_magazines = [];
			{
				_cfgWeapon = configfile >> "cfgweapons" >> _x;
				{
					_cfgMuzzle = if (_x == "this") then {_cfgWeapon} else {_cfgWeapon >> _x};
					{
						private _item = _x;
						if (CONDITION(_virtualMagazineCargo)) then {
							_mag = tolower _item;
							_cfgMag = configfile >> "cfgmagazines" >> _mag;
							if (!(_mag in _magazines) && {getnumber (_cfgMag >> "scope") == 2 || getnumber (_cfgMag >> "scopeArsenal") == 2}) then {
								_magazines set [count _magazines,_mag];
								_value = {_x == _mag} count _itemsCurrent;
								_displayName = gettext (_cfgMag >> "displayName");
								([TER_VASS_shopObject, _mag] call TER_fnc_getItemValues) params ["","_itemCost","_itemMax"];
								_text = if (_itemMax isEqualType true) then {str _value} else { format ["%1|%2", _value, _itemMax - ([_mag] call _fnc_CurAdd)] };
								_lbAdd = _ctrlList lnbaddrow ["", _displayName, _text, format ["%1$", [_itemCost] call BIS_fnc_numberText]];
								_ctrlList lnbSetColor [[_lbAdd,3],MONEYGREEN];
								_ctrlList lnbsetdata [[_lbAdd,0],_mag];
								_ctrlList lnbsetvalue [[_lbAdd,0],getnumber (_cfgMag >> "mass")];
								_ctrlList lnbsetpicture [[_lbAdd,0],gettext (_cfgMag >> "picture")];
								_ctrlList lbsettooltip [_lbAdd * _columns,format ["%1\n%2",_displayName,_item]];
							};
						};
					} foreach getarray (_cfgMuzzle >> "magazines");
					// Magazine wells
					{
						// Find all entries inside magazine well
						{
							// Add all magazines from magazineWell sub class
							{
								private _item = _x;
								if (CONDITION(_virtualMagazineCargo)) then {
									_mag = tolower _item;
									_cfgMag = configfile >> "cfgmagazines" >> _mag;
									if (!(_mag in _magazines) && {getnumber (_cfgMag >> "scope") == 2 || getnumber (_cfgMag >> "scopeArsenal") == 2}) then {
										_magazines set [count _magazines,_mag];
										_value = {_x == _mag} count _itemsCurrent;
										_displayName = gettext (_cfgMag >> "displayName");
										([TER_VASS_shopObject, _mag] call TER_fnc_getItemValues) params ["","_itemCost","_itemMax"];
										_text = if (_itemMax isEqualType true) then {str _value} else { format ["%1|%2", _value, _itemMax - ([_mag] call _fnc_CurAdd)] };
										_lbAdd = _ctrlList lnbaddrow ["", _displayName, _text, format ["%1$", [_itemCost] call BIS_fnc_numberText]];
										_ctrlList lnbSetColor [[_lbAdd,3],MONEYGREEN];
										_ctrlList lnbsetdata [[_lbAdd,0],_mag];
										_ctrlList lnbsetvalue [[_lbAdd,0],getnumber (_cfgMag >> "mass")];
										_ctrlList lnbsetpicture [[_lbAdd,0],gettext (_cfgMag >> "picture")];
										_ctrlList lbsettooltip [_lbAdd * _columns,format ["%1\n%2",_displayName,_item]];
									};
								};
							}foreach (getArray _x);
						}foreach (configProperties [configFile >> "CfgMagazineWells" >> _x,"isarray _x"]);
					} foreach getarray (_cfgMuzzle >> "magazineWell");

				} foreach getarray (_cfgWeapon >> "muzzles");
			} foreach (weapons _center - ["Throw","Put"]);
			_ctrlList lbsetcursel (lbcursel _ctrlList max 0);

			//--- Update counts for all items in the list
			{
				_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
				if (ctrlenabled _ctrlList) then {
					for "_l" from 0 to (lbsize _ctrlList - 1) do {
						_class = _ctrlList lnbdata [_l,0];
						([TER_VASS_shopObject, _class] call TER_fnc_getItemValues) params ["","_itemCost","_itemMax"];
						_value =  {_x == _class} count _itemsCurrent;
						_text = if (_itemMax isEqualType true) then {str _value} else { format ["%1|%2", _value, _itemMax - ([_class] call _fnc_CurAdd)] };
						_ctrlList lnbsettext [[_l, COL_COUNT], _text];
					};
					["SelectItemRight",[_display,_ctrlList,_index]] call bis_fnc_arsenal;
				};
			} foreach [
				IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,
				IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,
				IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,
				IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,
				IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC
			];
		};

		//--- Weapon attachments
		_modList = MODLIST;
		if (
			_index in [IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,IDC_RSCDISPLAYARSENAL_TAB_HANDGUN]
			&&
			ctrlenabled (_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _index))
		) then {
			private ["_ctrlList"];

			_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);
			GETVIRTUALCARGO

			{
				_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
				lbclear _ctrlList;
				_ctrlList lbsetcursel -1;
			} foreach [
				IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD
			];

			//--- Attachments
			_compatibleItems = _item call bis_fnc_compatibleItems;
			{
				private ["_item"];
				_item = _x;

				_itemCfg = configfile >> "cfgweapons" >> _item;
				_scope = if (isnumber (_itemCfg >> "scopeArsenal")) then {getnumber (_itemCfg >> "scopeArsenal")} else {getnumber (_itemCfg >> "scope")};
			    ([TER_VASS_shopObject, _item] call TER_fnc_getItemValues) params ["","_itemCost","_itemMax"];

				if (_scope == 2 && _itemCost > 0) then {
					_type = _item call bis_fnc_itemType;
					_idcList = switch (_type select 1) do {
						case "AccessoryMuzzle": {IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE};
						case "AccessoryPointer": {IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_ITEMACC};
						case "AccessorySights": {IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC};
						case "AccessoryBipod": {IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD};
						default {-1};
					};
					_ctrlList = _display displayctrl _idcList;
					_lbAdd = _ctrlList lbadd gettext (_itemCfg >> "displayName");
					_ctrlList lbsetdata [_lbAdd,_item];
					_ctrlList lbsetvalue [_lbAdd, _itemCost];
					_ctrlList lbsetpicture [_lbAdd,gettext (_itemCfg >> "picture")];
					_ctrlList lbsettooltip [_lbAdd,format ["%1\n%2",gettext (_itemCfg >> "displayName"),_item]];
					_itemCfg call ADDMODICON;
					// /*MODDED
					if (_ctrlList lbPictureRight _lbAdd == "") then {
						_ctrlList lbSetPictureRight [_lbAdd,"\a3\ui_f\data\igui\cfg\targeting\empty_ca.paa"];
					};
					_ctrlList lbSetTextRight [_lbAdd,format ["%1$", [_itemCost] call BIS_fnc_numberText]];
					_ctrlList lbSetColorRight [_lbAdd, MONEYGREEN];
					// MODDED*/
				};
			} foreach _compatibleItems;

			//--- Magazines
			_weapon = switch true do {
				case (ctrlenabled _ctrlListPrimaryWeapon): {primaryweapon _center};
				case (ctrlenabled _ctrlListSecondaryWeapon): {secondaryweapon _center};
				case (ctrlenabled _ctrlListHandgun): {handgunweapon _center};
				default {""};
			};

			//--- Select current
			_weaponAccessories = _center weaponaccessories _weapon;
			{
				_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
				_lbAdd = _ctrlList lbadd format ["<%1>",localize "str_empty"];
				_ctrlList lbsetvalue [_lbAdd,-1e+6];
				lbsort _ctrlList;
				for "_l" from 0 to (lbsize _ctrlList - 1) do {
					_data = _ctrlList lbdata _l;
					if (_data != "" && {{_data == _x} count _weaponAccessories > 0}) exitwith {_ctrlList lbsetcursel _l;};
				};
				if (lbcursel _ctrlList < 0) then {_ctrlList lbsetcursel 0;};

				_ctrlSort = _display displayctrl (IDC_RSCDISPLAYARSENAL_SORT + _x);
				["lbSort",[[_ctrlSort,lbcursel _ctrlSort],_x]] call SELF;
			} foreach [
				IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD
			];
		};

		//--- Calculate load
		_ctrlLoad = _display displayctrl IDC_RSCDISPLAYARSENAL_LOAD;
		_ctrlLoad progresssetposition load _center;


		if (ctrlenabled _ctrlList) then
		{
			_itemCfg = switch _index do
			{
				case IDC_RSCDISPLAYARSENAL_TAB_BACKPACK:	{configfile >> "cfgvehicles" >> _item};
				case IDC_RSCDISPLAYARSENAL_TAB_GOGGLES:     { configfile >> "CfgGlasses" >> _item };
				case IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG;
				case IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL;
				case IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW;
				case IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT;
				case IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC:	{configfile >> "cfgmagazines" >> _item};
				default						{configfile >> "cfgweapons" >> _item};
			};

			if (BIS_fnc_arsenal_type == 0 || (BIS_fnc_arsenal_type == 1 && !is3DEN)) then
			{
				["ShowItemInfo",[_itemCfg]] call bis_fnc_arsenal;
				["ShowItemStats",[_itemCfg]] call bis_fnc_arsenal;

			};
		};
	};

	case "KeyDown":
	{
		_display = _this select 0;
		_key = _this select 1;
		_shift = _this select 2;
		_ctrl = _this select 3;
		_alt = _this select 4;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_return = false;
		_inTemplate = false;
		_ctrlCheckout = _display displayCtrl IDC_RSCDISPLAYCHECKOUT_CHECKOUT;
		_inCheckout = ctrlFade _ctrlCheckout == 0;

		switch true do {
			case (_key == DIK_ESCAPE): {
				if (_inCheckout) then {
					_ctrlCheckout ctrlsetfade 1;
					_ctrlCheckout ctrlcommit FADE_DELAY;
					_ctrlCheckout ctrlenable false;

					_ctrlMouseBlock = _display displayctrl IDC_RSCDISPLAYARSENAL_MOUSEBLOCK;
					_ctrlMouseBlock ctrlenable false;
				} else {
					if (_fullVersion) then {["buttonClose",[_display]] spawn bis_fnc_arsenal;} else {_display closedisplay 2;};
				};
				_return = true;
			};

			//--- Enter
			case (_key in [DIK_RETURN,DIK_NUMPADENTER]): {
				_ctrlTemplate = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_TEMPLATE;
				if (ctrlfade _ctrlTemplate == 0) then {
					if (BIS_fnc_arsenal_type == 0) then {
						["buttonTemplateOK",[_display]] spawn bis_fnc_arsenal;
					} else {
						["buttonTemplateOK",[_display]] spawn bis_fnc_garage;
					};
					_return = true;
				};
			};

			//--- Prevent opening the commanding menu
			case (_key == DIK_1);
			case (_key == DIK_2);
			case (_key == DIK_3);
			case (_key == DIK_4);
			case (_key == DIK_5);
			case (_key == DIK_1);
			case (_key == DIK_7);
			case (_key == DIK_8);
			case (_key == DIK_9);
			case (_key == DIK_0): {
				_return = true;
			};

			//--- Tab to browse tabs
			case (_key == DIK_TAB): {
				_idc = -1;
				{
					_ctrlTab = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _x);
					if !(ctrlenabled _ctrlTab) exitwith {_idc = _x;};
				} foreach [IDCS_LEFT];
				_idcCount = {!isnull (_display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _x))} count [IDCS_LEFT];
				_idc = if (_ctrl) then {(_idc - 1 + _idcCount) % _idcCount} else {(_idc + 1) % _idcCount};
				if (BIS_fnc_arsenal_type == 0) then {
					["TabSelectLeft",[_display,_idc]] call SELF;
				} else {
					["TabSelectLeft",[_display,_idc]] call bis_fnc_garage;
				};
				_return = true;
			};
			//--- Toggle interface
			case (_key == DIK_BACKSPACE && !_inTemplate): {
				['buttonInterface',[_display]] call bis_fnc_arsenal;
				_return = true;
			};

			//--- Acctime
			case (_key in (actionkeys "timeInc")): {
				if (acctime == 0) then {setacctime 1;};
				_return = true;
			};
			case (_key in (actionkeys "timeDec")): {
				if (acctime != 0) then {setacctime 0;};
				_return = true;

			};

			//--- Vision mode
			case (_key in (actionkeys "nightvision") && !_inTemplate): {
				_mode = missionnamespace getvariable ["BIS_fnc_arsenal_visionMode",0];
				_mode = (_mode + 1) % 2;
				missionnamespace setvariable ["BIS_fnc_arsenal_visionMode",_mode];
				switch _mode do {
					//--- Normal
					case 0: {
						camusenvg false;
						false setCamUseTi 0;
					};
					//--- NVG
					case 1: {
						camusenvg true;
						false setCamUseTi 0;
					};
					//--- TI
					default {
						camusenvg false;
						true setCamUseTi 0;
					};
				};
				playsound ["RscDisplayCurator_visionMode",true];
				_return = true;

			};
		};
		_return
	};

	case "lbSort": {
		private _input = _this select 0;
		private _idc = (_this select 1);

		private _display = ctrlparent (_input select 0);
		private _sort = _input select 1;
		private _ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _idc);
		private _cursel = lbcursel _ctrlList;
		private _selected = _ctrlList lbdata _cursel;
		switch _sort do {
			case 1: {lbSortByValue _ctrlList};
			case 2: {
				//--- First reverse and then sort the lb values
				for "_i" from 1 to (lbSize _ctrlList -1) do {
					_ctrlList lbSetValue [_i,(-1 * (_ctrlList lbValue _i))];
				};
				lbSortByValue _ctrlList;
				for "_i" from 1 to (lbSize _ctrlList -1) do {
					_ctrlList lbSetValue [_i,(-1 * (_ctrlList lbValue _i))];
				};
			};
			default {lbsort _ctrlList};
		};

		//--- Selected previously selected item (if there was one)
		if (_cursel >= 0) then {
			for '_i' from 0 to (lbsize _ctrlList - 1) do {
				if ((_ctrlList lbdata _i) == _selected) exitwith {_ctrlList lbsetcursel _i;};
			};
		};

		//--- Store sort type for persistent use
		_sortValues = uinamespace getvariable ["ter_fnc_shop_sort",[]];
		_sortValues set [_idc,_sort];
		uinamespace setvariable ["ter_fnc_shop_sort",_sortValues];
	};
    case "buttonLoad":{
        missionnamespace setVariable ["WF_start_player_loadout", call _fnc_getEquipment ];
        private _display = _this select 0;

        _ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
        lnbclear _ctrlTemplateValue;
        _data = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];
        _center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);

        for "_i" from 0 to (count _data - 1) step 2 do {
            _name = _data select _i;
            _inventory = _data select (_i + 1);

            _shallRemoveTemplate = false;
            _flatternIventory = (_inventory) call _fnc_arrayFlatten;

            {
                _loweredGearClassName = tolower _x;
                if(!(["default", (_loweredGearClassName)] call BIS_fnc_inString) &&
                        !(["male", (_loweredGearClassName)] call BIS_fnc_inString) &&
                            !(["wasp", (_loweredGearClassName)] call BIS_fnc_inString)) then {

                    if((parseNumber _x) == 0) then {
                        if(["_loaded", _loweredGearClassName] call BIS_fnc_inString) then {
                            _loweredGearClassName = [_loweredGearClassName, "_loaded", ""] call _fnc_stringReplace;
                            _flatternIventory set [_forEachIndex, _loweredGearClassName]
                        };

                        if !(_loweredGearClassName in (TER_VASS_shopObject getVariable ["TER_VASS_cargo",[]])) exitWith {
                            _shallRemoveTemplate = true
                        }
                    }
                }
            } forEach _flatternIventory;

            if!(_shallRemoveTemplate) then {
            _inventoryWeapons = [
                (_inventory select 5), //--- Binocular
                (_inventory select 6 select 0), //--- Primary weapon
                (_inventory select 7 select 0), //--- Secondary weapon
                (_inventory select 8 select 0) //--- Handgun
            ] - [""];
            _inventoryMagazines = (
                (_inventory select 0 select 1) + //--- Uniform
                (_inventory select 1 select 1) + //--- Vest
                (_inventory select 2 select 1) //--- Backpack items
            ) - [""];
            _inventoryItems = (
                [_inventory select 0 select 0] + (_inventory select 0 select 1) + //--- Uniform
                [_inventory select 1 select 0] + (_inventory select 1 select 1) + //--- Vest
                (_inventory select 2 select 1) + //--- Backpack items
                [_inventory select 3] + //--- Headgear
                [_inventory select 4] + //--- Goggles
                (_inventory select 6 select 1) + //--- Primary weapon items
                (_inventory select 7 select 1) + //--- Secondary weapon items
                (_inventory select 8 select 1) + //--- Handgun items
                (_inventory select 9) //--- Assigned items
            ) - [""];
            _inventoryBackpacks = [_inventory select 2 select 0] - [""];

            _lbAdd = _ctrlTemplateValue lnbaddrow [_name];
            _ctrlTemplateValue lnbsetpicture [[_lbAdd,1],gettext (configfile >> "cfgweapons" >> (_inventory select 6 select 0) >> "picture")];
            _ctrlTemplateValue lnbsetpicture [[_lbAdd,2],gettext (configfile >> "cfgweapons" >> (_inventory select 7 select 0) >> "picture")];
            _ctrlTemplateValue lnbsetpicture [[_lbAdd,3],gettext (configfile >> "cfgweapons" >> (_inventory select 8 select 0) >> "picture")];
            _ctrlTemplateValue lnbsetpicture [[_lbAdd,4],gettext (configfile >> "cfgweapons" >> (_inventory select 0 select 0) >> "picture")];
            _ctrlTemplateValue lnbsetpicture [[_lbAdd,5],gettext (configfile >> "cfgweapons" >> (_inventory select 1 select 0) >> "picture")];
            _ctrlTemplateValue lnbsetpicture [[_lbAdd,6],gettext (configfile >> "cfgvehicles" >> (_inventory select 2 select 0) >> "picture")];
            _ctrlTemplateValue lnbsetpicture [[_lbAdd,7],gettext (configfile >> "cfgweapons" >> (_inventory select 3) >> "picture")];
                _ctrlTemplateValue lnbsetpicture [[_lbAdd,8],gettext (configfile >> "cfgglasses" >> (_inventory select 4) >> "picture")]
            };

        _ctrlTemplateValue lnbsort [0,false];
        _ctrlTemplate = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_TEMPLATE;
        _ctrlTemplate ctrlsetfade 0;
        _ctrlTemplate ctrlcommit 0;
        _ctrlTemplate ctrlenable true;

        _ctrlMouseBlock = _display displayctrl IDC_RSCDISPLAYARSENAL_MOUSEBLOCK;
        _ctrlMouseBlock ctrlenable true;
        ctrlsetfocus _ctrlMouseBlock;

        {
            (_display displayctrl _x) ctrlsettext localize "str_disp_int_load";
        } foreach [IDC_RSCDISPLAYARSENAL_TEMPLATE_TITLE,IDC_RSCDISPLAYARSENAL_TEMPLATE_BUTTONOK];
        {
            _ctrl = _display displayctrl _x;
            _ctrl ctrlshow false;
            _ctrl ctrlenable false;
        } foreach [IDC_RSCDISPLAYARSENAL_TEMPLATE_TEXTNAME,IDC_RSCDISPLAYARSENAL_TEMPLATE_EDITNAME];

        _ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
        if (lnbcurselrow _ctrlTemplateValue < 0) then {_ctrlTemplateValue lnbsetcurselrow 0;};
            ctrlsetfocus _ctrlTemplateValue
                }
    };
    case "buttonReload":{
        _display = _this select 0;
        _center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
        private _dirtyAddedItemsArray = (missionnamespace getVariable "WF_loaded_inventory") call _fnc_arrayFlatten;
        private _dirtyRemovedItemsArray = (call _fnc_getEquipment) call _fnc_arrayFlatten;
        private _addedItems = [];
        private _removedItems = [];

        {
            if(typeName _x == "STRING") then {
                if(_x != "") then {
                    if(["_Loaded", (_x)] call BIS_fnc_inString) then {
                        _x = [_x, "_Loaded", ""] call _fnc_stringReplace;
                        _dirtyAddedItemsArray set [_forEachIndex, _x]
                    };

                    _itemValues = [TER_VASS_shopObject, _x] call TER_fnc_getItemValues;
                    _itemValues params ["", "_itemCost", "_itemAmount"];
                    if(_itemCost > 0) then { _addedItems pushBack _x }
                }
            }
        } forEach _dirtyAddedItemsArray;

        {
            if(typeName _x == "STRING") then {
                if(_x != "") then {

                    if(["_loaded", (toLower _x)] call BIS_fnc_inString) then {
                        _x = [toLower _x, "_loaded", ""] call _fnc_stringReplace;
                        _dirtyRemovedItemsArray set [_forEachIndex, _x]
                    };

                    _itemValues = [TER_VASS_shopObject, _x] call TER_fnc_getItemValues;
                    _itemValues params ["", "_itemCost", "_itemAmount"];
                    if(_itemCost > 0) then { _removedItems pushBack _x }
                }
            }
        } forEach _dirtyRemovedItemsArray;

        [_center, missionnamespace getVariable "WF_loaded_inventory"] call _fnc_EquipUnit;
        missionnamespace setVariable ["WF_loaded_inventory", call _fnc_getEquipment];
        ["costChange",[_display, _addedItems, +1]] call SELF;
        ["costChange",[_display, _removedItems, -1]] call SELF;
            };
    case "buttonDelete":{
        _display = _this select 0;
        _ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
        _center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
        _cursel = lnbcurselrow _ctrlTemplateValue;
        _name = _ctrlTemplateValue lnbtext [_cursel,0];
        [_center,[profilenamespace,_name],nil,true] call bis_fnc_saveInventory;
        _ctrlTemplateValue lnbDeleteRow _cursel;

        _ctrlTemplateValue lnbsetcurselrow (_cursel max (lbsize _ctrlTemplateValue - 1));
        _savedInventroyData = profilenamespace getvariable ["wf_bis_fnc_saveInventory_data", []];
        {
            if(count _x > 0) then {
                if((_x # 0) == _name) exitWith {
                    _savedInventroyData deleteAt _forEachIndex;
                    profilenamespace setvariable ["wf_bis_fnc_saveInventory_data", _savedInventroyData]
                }
        		}
        } forEach _savedInventroyData
        	};

	case "buttonTemplateOk":{

		_display = _this select 0;
		_ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
		_ctrlTemplateName = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_EDITNAME;
        _center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);

        if (ctrlenabled _ctrlTemplateName) then {

            //--- Save
            [
                _center,
                [profilenamespace,ctrltext _ctrlTemplateName],
                [
                    _center getvariable ["BIS_fnc_arsenal_face",face _center],
                    speaker _center,
                    _center call bis_fnc_getUnitInsignia
                ]
            ] call bis_fnc_saveInventory;

            _inventory = [];
            _saveName = '';
            _saveData = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];

            {
                if(_x isEqualType "STRING") then {
                    if(_x == ctrltext _ctrlTemplateName) exitWith {
                        _saveName = _x;
                        _inventory = _saveData select (_foreachindex + 1)
                    }
                };
            } forEach _saveData;

            if(_saveName != '' && count _inventory > 0) then {
                _savedInventroyData = profilenamespace getvariable ["wf_bis_fnc_saveInventory_data", []];
                _savedInventroyData pushBack ([_saveName, call _fnc_getEquipment]);
                profilenamespace setvariable ["wf_bis_fnc_saveInventory_data", _savedInventroyData]
            };
            _ctrlTemplate = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_TEMPLATE;
            _ctrlTemplate ctrlsetfade 1;
            _ctrlTemplate ctrlcommit 0;
            _ctrlTemplate ctrlenable false;
            _ctrlMouseBlock = _display displayctrl IDC_RSCDISPLAYARSENAL_MOUSEBLOCK;
            _ctrlMouseBlock ctrlenable false;
        } else {

            _inventory = [];
            if ((_ctrlTemplateValue lbvalue lnbcurselrow _ctrlTemplateValue) >= 0) then {

                _saveName = _ctrlTemplateValue lnbtext [lnbcurselrow _ctrlTemplateValue,0];
                _saveDataCustom = profilenamespace getvariable ["wf_bis_fnc_saveInventory_data",[]];
                {
                    if((_x # 0) isEqualType "STRING" && {(_x # 0) == _saveName})exitWith{
                        _inventory = _x # 1
                    };
                } forEach _saveDataCustom;

                if(count _inventory == 0) then {
                _saveData = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];
                {
                    if(_x isEqualType "STRING" && {_x == _saveName})exitWith{
                        _inventory = _saveData select (_foreachindex + 1)
                        }
                    } forEach _saveData
                }
            };

            private _dirtyAddedItemsArray = (_inventory) call _fnc_arrayFlatten;
            private _dirtyRemovedItemsArray = (missionnamespace getVariable "WF_start_player_loadout") call _fnc_arrayFlatten;
            private _addedItems = [];
            private _removedItems = [];

            {
                if(typeName _x == "STRING") then {
                    if(_x != "") then {

                        if(["_Loaded", (_x)] call BIS_fnc_inString) then {
                            _x = [_x, "_Loaded", ""] call _fnc_stringReplace;
                            _dirtyAddedItemsArray set [_forEachIndex, _x]
                        };

                        _itemValues = [TER_VASS_shopObject, _x] call TER_fnc_getItemValues;
                        _itemValues params ["", "_itemCost", "_itemAmount"];
                        if(_itemCost > 0) then { _addedItems pushBack _x }
                    }
                }
            } forEach _dirtyAddedItemsArray;

            {
                if(typeName _x == "STRING") then {
                    if(_x != "") then {

                        if(["_Loaded", (toLower _x)] call BIS_fnc_inString) then {
                            _x = [toLower _x, "_Loaded", ""] call _fnc_stringReplace;
                            _dirtyRemovedItemsArray set [_forEachIndex, _x]
                        };

                        _itemValues = [TER_VASS_shopObject, _x] call TER_fnc_getItemValues;
                        _itemValues params ["", "_itemCost", "_itemAmount"];
                        if(_itemCost > 0) then { _removedItems pushBack _x }
                    }
                }
            } forEach _dirtyRemovedItemsArray;
            [_center, _inventory] call _fnc_EquipUnit;
            ["costChange",[_display,_addedItems,+1]] call SELF;
            ["costChange",[_display,_removedItems,-1]] call SELF;
        }
	};
	case "buttonBuy":{
		_display = _this select 0;
		_ctrlCheckout = _display displayCtrl IDC_RSCDISPLAYCHECKOUT_CHECKOUT;
		["refresh",[_ctrlCheckout]] execVM "Client\Player\GUI\GearMenu\gui\scripts\RscDisplayCheckout.sqf";
	};
	case "buyMouse":{
		_ctrlButtonInterface = _this select 0;
		_display = ctrlParent _ctrlButtonInterface;
		_enter = _this#1 == 1;
		if (_enter) then {
			_ctrlButtonInterface ctrlSetText "CHECKOUT";
		} else {
			["costChange", [_display, [""]]] call SELF;
		};
	};

	case "costChange":{
		params ["_display",["_changedItems",[]],["_mp",1]];

        if(count _changedItems > 0) then {
            if(["_Loaded", (_changedItems # 0)] call BIS_fnc_inString) then {
                _changedItems set [0, [_changedItems # 0, "_Loaded", ""] call _fnc_stringReplace]
            }
        };

		if (count _changedItems == 0) exitWith {};
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_changedItems = _changedItems - [""];
		private _addCost = 0;
		if (count _changedItems != 0) then {
			_changedItems apply {_addCost = _addCost + _mp * ([TER_VASS_shopObject, _x, 1] call TER_fnc_getItemValues)};
		};
		_fncTparams = {
			// Okay story time. I was trying to figure out why the minus sign wasnt getting displayed even though every other symbol did. This was especially weird since the same code would work on another display and also worked just yesterday. I tried different approaches for nearly half an hour. End of the story: The resolution in windowed mode was so low that the "-" symbol didn't take up one single pixel in height... FML
			params ["_money", "_align"];
			_tMoney = [abs _money] call BIS_fnc_numberText;
			_tRed = "#FF0000";
			_tGreen = "#00FF00";
			_tWhite = "#FFFFFF";
			_tCond = _money < 0;
			_tColor = [_tGreen, _tRed] select _tCond;
			_tSign = ["+","-"] select _tCond;
			if (_money == 0) then {_tColor = _tWhite; _tSign = "";};
			_tReturn = format ["<t align='%1' color='%2'>%3%4$</t>", _align, _tColor, _tSign, _tMoney];
			_tReturn
		};
		//--- Funds
		_funds = with missionnamespace do {["getMoney",[_center]] call TER_fnc_VASShandler};
		_fundsText = [_funds, "left"] call _fncTparams;
		//--- Costs
		_cost = _display getVariable ["shop_cost",0];
		_cost = _cost + _addCost;
		_display setVariable ["shop_cost", _cost];
		_costText = [-_cost, "center"] call _fncTparams;
		//--- Difference
		_diff = _funds -_cost;
		_diffText = [_diff, "right"] call _fncTparams;

		_ctrlButtonInterface = _display displayCtrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONINTERFACE;
		_ctrlButtonInterface ctrlSetStructuredText parseText ([_fundsText,_costText,_diffText] joinString "");

		//--- Keep changed item array up to date
		{
			private _item = toLower _x;
			[TER_VASS_changedItems, _item, _mp] call BIS_fnc_addToPairs;
		} forEach _changedItems;
		TER_VASS_changedItems = TER_VASS_changedItems select {_x#1 != 0};
	};
};