private["_camp","_newSID","_force","_camp_cap_rate","_camp_range","_camp_range_players","_town_starting_sv"];

_newSID = -1;
_force = 0;

_camp_cap_rate = missionNamespace getVariable "WF_C_CAMPS_CAPTURE_RATE";
_camp_range = missionNamespace getVariable "WF_C_CAMPS_RANGE";
_camp_range_players = missionNamespace getVariable "WF_C_CAMPS_RANGE_PLAYERS";
_filteredTowns = [];
{
    _town = _x;
    _camps = _town getVariable ["camps", []];
    if (count _camps > 0) then { _filteredTowns pushBack _town }
} foreach towns;

while {!WF_GameOver} do {
    _filteredTowns = _filteredTowns - [objNull];
    for "_j" from 0 to ((count _filteredTowns) - 1) step 1 do {
        _town = _filteredTowns # _j;
        if!(isNil "_town") then {
        _camps = _town getVariable ["camps", []];
        _town_starting_sv = _town getVariable "startingSupplyValue";

        for "_i" from 0 to ((count _camps) - 1) step 1 do {
            _camp = _camps # _i;

            //--- Filter players and ai.
            _objects = _camp nearEntities["Man", _camp_range];
            _in_range = _objects;
            {
                if (isPlayer _x) then {if (_x distance _camp > _camp_range_players) then {_objects deleteAt _forEachIndex}};
            } forEach _in_range;

            _west = west countSide _objects;
            _east = east countSide _objects;
            _resistance = resistance countSide _objects;

            if(_west > 0 || _east > 0 || _resistance > 0) then {
                _skip = false;
                _protected = false;
                _captured = false;
                _sideID = _camp getVariable "sideID";
                _supplyValue = _camp getVariable "supplyValue";
                _town_sideID = _town getVariable "sideID";

                _resistanceDominion = (_resistance > _east && _resistance > _west);
                _westDominion = (_west > _east && _west > _resistance);
                _eastDominion = (_east > _west && _east > _resistance);

                if (_sideID == WF_C_GUER_ID && _resistanceDominion) then {_force = _resistance;_protected = true; _skip = true};
                if (_sideID == WF_C_EAST_ID && _eastDominion) then {_force = _east;_protected = true; _skip = true};
                if (_sideID == WF_C_WEST_ID && _westDominion) then {_force = _west;_protected = true; _skip = true};

                if(!_resistanceDominion && isObjectHidden _camp) then {
                    _skip = true;
                };

                switch (true) do {
                    case _resistanceDominion: { _resistance = [_resistance - _west, _resistance - _east] select (_east > _west); _force = _resistance; _east = 0; _west = 0};
                    case _westDominion: {_west =  [_west - _east, _west - _resistance] select (_east > _resistance); _force = _west; _east = 0; _resistance = 0};
                    case _eastDominion: {_east = [_east - _resistance, _east - _west] select (_west > _resistance); _force = _east; _west = 0; _resistance = 0};
                };

                if (!_resistanceDominion && !_westDominion && !_eastDominion) then {_west = 0; _east = 0; _resistance = 0};

                if !(_skip) then {
                    _newSID = switch (true) do {case (_west > 0): {WF_C_WEST_ID}; case (_east > 0): {WF_C_EAST_ID}; case (_resistance > 0): {WF_C_GUER_ID}};
                    _supplyValue = round(_supplyValue - ((_resistance + _east + _west)*_camp_cap_rate));

                    if (_supplyValue < 1) then {
                        _supplyValue = _town_starting_sv;
                        _captured = true
                    };

                    _camp setVariable ["supplyValue",_supplyValue,true];
                };

                if (_protected) then {
                    if (_supplyValue < _town_starting_sv) then {
                    _supplyValue = _supplyValue + round(_force * _camp_cap_rate);
                    if (_supplyValue > _town_starting_sv) then {_supplyValue = _town_starting_sv};
                    _camp setVariable ["supplyValue",_supplyValue,true];
                    };
                };

                if(_captured) then {
                    _newSide = (_newSID) Call WFCO_FNC_GetSideFromID;
                    _side = (_sideID) Call WFCO_FNC_GetSideFromID;

                    if (_sideID != WF_C_UNKNOWN_ID) then {
                        if (missionNamespace getVariable Format ["WF_%1_PRESENT",_side]) then {[_side,"LostAt",["Strongpoint",_town]] Spawn WFSE_FNC_SideMessage};
                    };

                    if (missionNamespace getVariable Format ["WF_%1_PRESENT",_newSide]) then {[_newSide,"CapturedNear",["Strongpoint",_town]] Spawn WFSE_FNC_SideMessage};

                    _camp setVariable ["sideID",_newSID,true];

                    [_camp,_newSID,_sideID] remoteExecCall ["WFCL_FNC_CampCaptured"];
                };
            };
            sleep 0.01
        };

        sleep 0.01
        }
    };
    sleep 5
}