params ["_unit"];
private ["_camps","_range","_temp", "_object"];

_object = objNull;
_range = missionNamespace getVariable "WF_C_NEAREST_VEHICLE_RANGE";

if(!(isNil "_unit") && (alive _unit)) then {
	//--- Attempt to get a nearby camp.
	_objects = nearestObjects [_unit, WF_C_ACTION_OBJECT_FILTER_KIND , _range, true];

	if (count _objects > 0) then {
	    _object = _objects # 0;
	    if (_object isKindOf 'AllVehicles') then {
            WF_VEHICLE_NEAR = true
        } else {
            WF_VEHICLE_NEAR = false
        };

        if (typeOf _object in WF_C_RADIO_OBJECTS) then {
            _isNewRadioTower = true;
            {
                _location = _x # 0;
                if (_location isEqualTo _object) exitWith {
                    _isNewRadioTower = false
                }
            } forEach WF_C_TAKEN_RADIO_TOWERS;

            if(_isNewRadioTower) then {
            WF_RADIO_TOWER_NEAR = true
        } else {
            WF_RADIO_TOWER_NEAR = false
            }
        } else {
            WF_RADIO_TOWER_NEAR = false
        };

        if (typeOf _object == missionNamespace getVariable 'WF_C_CAMP') then {
            _campSideId = _object getVariable 'sideID';
            if (isNil '_campSideId') then {
                WF_CAMP_NEAR = false
            } else {
                if (isObjectHidden _object) then {
                    WF_CAMP_NEAR_HIDDEN = true;
                    WF_CAMP_NEAR = false
                } else {
                    if (WF_Client_SideID != _campSideId) then {
                        WF_CAMP_NEAR = true
                    } else {
                        WF_CAMP_NEAR = false
                    }
                }
            }
        } else {
            WF_CAMP_NEAR = false
        }
	} else {
	    WF_VEHICLE_NEAR = false;
	    WF_RADIO_TOWER_NEAR = false;
	    WF_CAMP_NEAR = false;
	    WF_CAMP_NEAR_HIDDEN = false
	}
};

WF_CAMP_NEAR