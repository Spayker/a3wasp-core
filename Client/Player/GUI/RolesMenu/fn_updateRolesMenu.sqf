private ["_list"];
disableSerialization;

_list = (findDisplay 2800) displayCtrl 2801;
lbClear _list;
_roleList = [WF_Client_SideJoined] call WFCO_fnc_roleList;

{
    private ["_y","_c","_skillName"];
    _y = _x;
    if ((_y # 0) isEqualType "") then {
        _list lbAdd (_y select 1);
        _list lbSetData[(lbSize _list) - 1, (_y select 0)];
        _list lbSetValue[(lbSize _list) - 1, (_y select 4)];

        if ((_y select 0) in WF_gbl_boughtRoles) then {
            _list lbSetColor [(lbSize _list) - 1, [0,0.42,0.788,1]];
            _list lbSetPicture [(lbSize _list) - 1, "\A3\ui_f\data\map\markers\military\objective_CA.paa"];
        } else {
            _list lbSetPicture [(lbSize _list) - 1, "\A3\ui_f\data\map\markers\military\circle_CA.paa"];
        };
    } else {
         _c = 0;
         {
             _skillName = (_x select 1);

             _list lbAdd _skillName;
             _list lbSetData [(lbSize _list) - 1, (_x select 0)];
             _list lbSetValue[(lbSize _list) - 1, (_x select 4)];

             if ((_x select 0) in WF_gbl_boughtRoles) then {
                 _list lbSetColor [(lbSize _list) - 1, [0,0.42,0.788,1]];
                 _list lbSetPicture [(lbSize _list) - 1, "\A3\ui_f\data\map\markers\military\objective_CA.paa"];
             } else {
                 _list lbSetPicture [(lbSize _list) - 1, "\A3\ui_f\data\map\markers\military\circle_CA.paa"];
             };
             _c = _c + 1;

         } foreach _y;
     };
} foreach (_roleList);

((findDisplay 2800) displayCtrl 2803) ctrlSetStructuredText parseText format[
"<t size='1.25'>Current Role: %1</t><br/><t size='1.25'>Money: %2$</t>",
WF_gbl_boughtRoles select 0,
call WFCL_FNC_GetPlayerFunds];

WF_role_list = [];