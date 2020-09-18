//--- Check whether magazines shall be kept after changing a weapon or not
private ["_gear", "_magazines", "_magazines_old", "_replace", "_weapon", "_weapon_old"];

_weapon_old = _this select 0;
_weapon = _this select 1;
	_removeMagazines = if (count _this > 2) then {_this select 2} else {false};

_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

_magazines_old = (getArray(configFile >> 'CfgWeapons' >> _weapon_old >> 'magazines')) call WFCO_FNC_ArrayToLower;
_magazines = (getArray(configFile >> 'CfgWeapons' >> _weapon >> 'magazines')) call WFCO_FNC_ArrayToLower;

_replace = [];
{
		if !(_removeMagazines) then {
    if (_x in _magazines_old && !(_x in _magazines) && !(_x in _replace)) then {
        _replace pushBack _x;
    };
		} else {
			if (_x in _magazines_old && !(_x in _replace)) then {
				_replace pushBack _x;
			};
		};
} forEach ((((_gear select 1) select 0) select 1) + (((_gear select 1) select 1) select 1) + (((_gear select 1) select 2) select 1));

if (count _replace > 0) then {
    private ["_container_capacity", "_container_items_mass", "_count", "_current_magazine", "_expected_mass", "_freespace", "_items", "_magazine_new", "_magazine_new_mass", "_return"];
    _magazine_new = _magazines select 0;
    _magazine_new_mass = (_magazine_new) call WFCL_fnc_getGenericItemMass;

    for '_i' from 2 to 0 step -1 do {
        _items = ((_gear select 1) select _i) select 1;
        for '_j' from 0 to count(_items)-1 do {
            if ((_items select _j) in _replace) then {
                ["ContainerItem", _items select _j, "", [_i]] call WFCL_fnc_updateMass;
                [_i, 70301+_i] call WFCL_fnc_updateContainerProgress;
                _items set [_j, "!nil!"];
                };
            };
			_count = {_x isEqualTo "!nil!"} count _items;
			if (_count > 0) then {
				_items = _items - ["!nil!"];
        ((_gear select 1) select _i) set [1, _items];
        _return = [((_gear select 1) select _i) select 0, _items] call WFCL_fnc_getContainerMass;
        _container_items_mass = _return select 1;
        _container_capacity = _return select 2;

        //--- Determine how much new magazines we can fill.
        _freespace = _container_capacity - _container_items_mass;
        _expected_mass = _count * _magazine_new_mass;

        while { _expected_mass > _freespace && _expected_mass > 0 } do { _expected_mass = _expected_mass - _magazine_new_mass };
			if !(_removeMagazines) then {
                if (_expected_mass > 0) then {
                    for '_k' from 1 to (_expected_mass/_magazine_new_mass) do {
                        [_magazine_new, _i] call WFCL_fnc_AddContainerItem;
                        ["ContainerItem", "", _magazine_new, [_i]] call WFCL_fnc_UpdateMass;
                    };
                    [_i, 70301+_i] call WFCL_fnc_UpdateContainerProgress;
                };
            };
        };

        _current_magazine = ((_gear select 0) select _i) select 2;
        if (count _current_magazine > 0) then {
            if ((_current_magazine select 0) in _replace) then {
                [_magazine_new, _i, 70901+_i] call WFCL_fnc_changeCurrentMagazine;
            };
        };

        _current_grenade = ((_gear select 0) select _i) select 3;
        if (count _current_grenade > 0) then {
            if ((_current_grenade select 0) in _replace) then {
                [_magazine_new, _i, 70992+_i] call WFCL_fnc_changeCurrentGrenade;
            };
        };
    };

    (((_gear select 1) select (uiNamespace getVariable "wf_dialog_ui_gear_items_tab")) select 1) call WFCL_fnc_displayContainerItems;
};