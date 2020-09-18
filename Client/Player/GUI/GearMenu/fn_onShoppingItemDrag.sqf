//--- An item from the purchase list is being dragged around
_item = _this;

_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";
_idcs = [];
_idcs_red = [];

if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
    _tab = uiNamespace getVariable "wf_dialog_ui_gear_items_tab";

    _get = (_item) call WFCL_fnc_getItemAllowedSlots;
    _slots = _get select 0;
    _config_type = _get select 1;

    _translated = [[WF_SUBTYPE_UNIFORM, 77001, ((_gear select 1) select 0) select 0],[WF_SUBTYPE_VEST, 77002, ((_gear select 1) select 1) select 0],[WF_SUBTYPE_BACKPACK, 77003, ((_gear select 1) select 2) select 0]];

    //--- Determine where the item may be parked.
    switch (_config_type) do {
        case "CfgMagazines": {
            _gear_sub = _gear select 1;

            for '_i' from 0 to 2 do {
					if !(((_gear_sub select _i) select 0) isEqualTo "") then {
						_idcs pushBack (77001+_i); if (_tab isEqualTo _i) then {
							_idcs pushBack 77109
						}
					}
				};

            // current magazine
            //--- Is there a primary weapon?
            for '_i' from 0 to 2 do {
                _gear_sub = (_gear select 0) select _i;

                if (_gear_sub select 0 != "") then { //--- There is a weapon
                    _magazines = (getArray(configFile >> 'CfgWeapons' >> (_gear_sub select 0) >> 'magazines')) call WFCO_FNC_ArrayToLower;
                    _muzzle_class = (getArray (configFile >> "CfgWeapons" >> (_gear_sub select 0) >> "muzzles")) call WFCO_FNC_ArrayToLower;

                    _muzzle_magazines = nil;
                    if !(isNil {_muzzle_class}) then {
                        _muzzle_magazines = (getArray (configFile >> "CfgWeapons" >> (_gear_sub select 0) >> (_muzzle_class select 1) >> "magazines")) call WFCO_FNC_ArrayToLower
                    };

                    if (_item in _magazines) then {	_idcs pushBack (77901+_i) };
                    if (_item in _muzzle_magazines) then { _idcs pushBack (77992+_i) }
                };
            };
        };
        case "CfgGlasses": {
            _idcs = [77005];

            _gear = _gear select 1;

				for '_i' from 0 to 2 do {
					if !(((_gear select _i) select 0) isEqualTo "") then {
						_idcs pushBack (77001+_i); if (_tab isEqualTo _i) then {
							_idcs pushBack 77109
						}
					}
				};
        };
        case "CfgVehicles": {
            {
                for '_i' from 0 to count(_translated)-1 do {
						if (_x isEqualTo ((_translated select _i) select 0) && !(((_translated select _i) select 2) isEqualTo "")) then {_idcs pushBack ((_translated select _i) select 1); if (_tab isEqualTo _i) then {_idcs pushBack 77109}};
                };
            } forEach _slots;
				_idcs pushBack 77003;
        };
        case "CfgWeapons": {
            _type = getNumber(configFile >> _config_type >> _item >> "type");
            {
                for '_i' from 0 to count(_translated)-1 do {
						if (_x isEqualTo ((_translated select _i) select 0) && !(((_translated select _i) select 2) isEqualTo "")) then {_idcs pushBack ((_translated select _i) select 1); if (_tab isEqualTo _i) then {_idcs pushBack 77109}};
                };
            } forEach _slots;

            //--- Specific to item
            switch (true) do {
                case (_type in [WF_TYPE_RIFLE, WF_TYPE_RIFLE2H]): {_idcs pushBack 77013};
                case (_type isEqualTo WF_TYPE_LAUNCHER): {_idcs pushBack 77018};
                case (_type isEqualTo WF_TYPE_PISTOL): {_idcs pushBack 77023};
                case (_type isEqualTo WF_TYPE_EQUIPMENT): {
                    _idcs pushBack (if (getText(configFile >> 'CfgWeapons' >> _item >> 'simulation') == "NVGoggles") then {77006} else {77007})
                };
                case (_type isEqualTo WF_TYPE_ITEM): {
                    switch (getNumber(configFile >> _config_type >> _item >> 'ItemInfo' >> 'type')) do {
                            case WF_SUBTYPE_ACC_MUZZLE: {
                                _acc_idcs = [77014, 77019, 77024];
                                //--- Where does it fit?
                                {
                                    if !((_x select 0) isEqualTo "") then { //--- Muzzle is an array
                                        _compatibleItems = ([_x select 0, 101] call BIS_fnc_compatibleItems) call WFCO_FNC_ArrayToLower;
                                        if (_item in _compatibleItems) then {_idcs pushBack (_acc_idcs select _forEachIndex)};
                                    };
                                } forEach (_gear select 0);
                            };
                            case WF_SUBTYPE_ACC_SIDE: {
                                _acc_idcs = [77015, 77020, 77025];

                            //--- Where does it fit?
                            {
                                    if !((_x select 0) isEqualTo "") then { //--- Side is a subclass
                                        _compatibleItems = ([_x select 0, 301] call BIS_fnc_compatibleItems) call WFCO_FNC_ArrayToLower;
                                        {_compatibleItems pushBack toLower(configName _x)} forEach (configProperties[configfile >> _config_type >> (_x select 0) >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems", "true", true]);
                                        if (_item in _compatibleItems) then {_idcs pushBack (_acc_idcs select _forEachIndex)};
                                };
                            } forEach (_gear select 0);
                        };
                        case WF_SUBTYPE_ACC_OPTIC: {
                            _acc_idcs = [77016, 77021, 77026];
                            //--- Where does it fit?
                            {
                                    if !((_x select 0) isEqualTo "") then { //--- Optics is a subclass
                                        _compatibleItems = ([_x select 0, 201] call BIS_fnc_compatibleItems) call WFCO_FNC_ArrayToLower;
                                        if (_item in _compatibleItems) then {_idcs pushBack (_acc_idcs select _forEachIndex)};
                                };
                            } forEach (_gear select 0);
                        };
                        case WF_SUBTYPE_ACC_BIPOD: {
                            _acc_idcs = [77017, 77022, 77027];
                            //--- Where does it fit?
                            {
                                    if !((_x select 0) isEqualTo "") then { //--- Optics is a subclass
                                        _compatibleItems = ([_x select 0, 302] call BIS_fnc_compatibleItems) call WFCO_FNC_ArrayToLower;
                                        if (_item in _compatibleItems) then {_idcs pushBack (_acc_idcs select _forEachIndex)};
                                };
                            } forEach (_gear select 0);
                        };
                        case WF_SUBTYPE_HEADGEAR: {_idcs pushBack 77004};
                        case WF_SUBTYPE_VEST: {_idcs pushBack 77002};
                        case WF_SUBTYPE_UNIFORM: {_idcs pushBack 77001};
                        case WF_SUBTYPE_UAVTERMINAL: {_idcs pushBack 77009};
                        default {
                            switch (getText(configFile >> _config_type >> _item >> 'simulation')) do {
                                case "ItemMap": {_idcs pushBack 77008};
                                case "ItemGPS": {_idcs pushBack 77009};
                                case "ItemRadio": {_idcs pushBack 77010};
                                case "ItemCompass": {_idcs pushBack 77011};
                                case "ItemWatch": {_idcs pushBack 77012};
                            };
                        };
                    };
                };
            };
        };
    };
} else {
    _mass = uiNamespace getVariable "wf_dialog_ui_gear_target_gear_mass";
    _mass_item = _item call WFCL_fnc_getGenericItemMass;

    if (_mass_item + (_mass select 1) <= (_mass select 0)) then {
        _idcs = [77109];
    } else {
        _idcs_red = [77109];
    };
};

{
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _x) ctrlSetBackgroundColor [0.258823529, 0.713725490, 1, 0.7];
} forEach _idcs;

{
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _x) ctrlSetBackgroundColor [1, 0.258823529, 0.258823529, 0.7];
} forEach _idcs_red;

uiNamespace setVariable ["wf_dialog_ui_gear_drag_colored_idc", _idcs];
uiNamespace setVariable ["wf_dialog_ui_gear_drag_colored_idc_red", _idcs_red];