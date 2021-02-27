Private ['_side','_availableRoles'];

_side = _this select 0;

_availableRoles = missionNamespace getVariable Format["WF_%1AvailableRoles",str _side];
if(isNil '_availableRoles')then{
    _availableRoles = [];
    _availableRoles pushBack [
        WF_RECON,
        WF_RECON,
        "Recon role with special abilities: <br/>" +
         "- leaves marks on map by aiming<br/>" +
         "- can purchase sniper rifles <br/>",
        [],
        2500,
        [],
        3, // max limit of the role in team
        0 // current occupied amount
    ];

    _availableRoles pushBack [
        WF_ASSAULT,
        WF_ASSAULT,
        "Assault role for town taking. Abilities: <br/>"+
        "- have access to assault rifles<br/>"+
        "- can repair camps",
        [],
        2500,
        [],
        12, // max limit of the role in team
        0 // current occupied amount
    ];
    _availableRoles pushBack [
        WF_ENGINEER,
        WF_ENGINEER,
        "Support role on battlefield. Abilities: <br/>" +
        "- can repair vehicles without toolsets <br/>"+
        "- can destroy camps<br/>"+
        "- can repair camps",
        [],
        5000,
        [],
        6, // max limit of the role in team
        0 // current occupied amount
    ];
    _availableRoles pushBack [
        WF_SPECOPS,
        WF_SPECOPS,
        "Support role on battlefield. Abilities: <br/>"+
        "- can hi-jack enemy locked vehicles <br/>" +
        "- can hack radio towers <br/>",
        [],
        5000,
        [],
        3, // max limit of the role in team
        0 // current occupied amount
    ];
    _availableRoles pushBack [
        WF_MEDIC,
        WF_MEDIC,
        "Support role on battlefield. Abilities: <br/>"+
        "- can do full heal<br/>" +
        "- can heal with medkit package <br/>",
        [],
        5000,
        [],
        3, // max limit of the role in team
        0 // current occupied amount
    ];
    _availableRoles pushBack [
        WF_SUPPORT,
        WF_SUPPORT,
        "Support role on battlefield. Features: <br/>"+
        "- access to backpacks with UAVs<br/>" +
        "- can buy UAV vehicles<br/>" +
        "- can buy advanced rocket artillery<br/>",
        [],
        5000,
        [],
        3, // max limit of the role in team
        0 // current occupied amount
    ];
    missionNamespace setVariable [Format["WF_%1AvailableRoles",str _side], _availableRoles];
};

_availableRoles;