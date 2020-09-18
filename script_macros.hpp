#define SUB(var1,var2) var1 = var1 - var2
#define ADD(var1,var2) var1 = var1 + var2
#define SEL(ARRAY,INDEX) (ARRAY select INDEX)

//RemoteExec Macros
#define RSERV 2 //Only server
#define RCLIENT -2 //Except server
#define RANY 0 //Global

//Namespace Macros
#define SVAR_MNS missionNamespace setVariable
#define SVAR_UINS uiNamespace setVariable
#define SVAR_PNS parsingNamespace setVariable
#define SVAR_PRNS profileNamespace setVariable
#define GVAR_MNS missionNamespace getVariable
#define GVAR_UINS uiNamespace getVariable
#define GVAR_PRNS profileNamespace getVariable

//Config Macros
#define M_CONFIG(TYPE,CFG,CLASS,ENTRY) TYPE(missionConfigFile >> CFG >> CLASS >> ENTRY)
#define M_CONFIG2(TYPE,CFG,SECTION,CLASS,ENTRY) TYPE(missionConfigFile >> CFG >> SECTION >> CLASS >> ENTRY)
#define FETCH_CONFIG(TYPE,CFG,SECTION,CLASS,ENTRY) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY)
#define FETCH_CONFIG2(TYPE,CFG,CLASS,ENTRY) TYPE(configFile >> CFG >> CLASS >> ENTRY)
#define FETCH_CONFIG3(TYPE,CFG,SECTION,CLASS,ENTRY,SUB) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB)
#define FETCH_CONFIG4(TYPE,CFG,SECTION,CLASS,ENTRY,SUB,SUB2) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB >> SUB2)
#define BASE_CONFIG(CFG,CLASS) inheritsFrom(configFile >> CFG >> CLASS)

//Scripting Macros
#define CONST(var1,var2) var1 = compileFinal (if (var2 isEqualType "") then {var2} else {str(var2)})
#define CONSTVAR(var) var = compileFinal (if (var isEqualType "") then {var} else {str(var)})
#define FETCH_CONST(var) (call var)
#define PVAR_ALL(var) publicVariable var
#define PVAR_SERV(var) publicVariableServer var
#define PVAR_ID(var,id) id publicVariableClient var
#define GVAR getVariable
#define SVAR setVariable
#define RIFLE primaryWeapon player
#define RIFLE_ITEMS primaryWeaponItems player
#define PISTOL handgunWeapon player
#define PISTOL_ITEMS handgunItems player
#define LAUNCHER secondaryWeapon player
#define LAUNCHER_ITEMS secondaryWeaponItems player
#define PHEADGEAR headGear player
#define PBINOCULAR binocular player
#define PUNIFORM uniform player
#define PUNIFORM_ITEMS uniformItems player
#define PVEST vest player
#define PVEST_ITEMS vestItems player
#define PBACKPACK backpack player
#define PBACKPACK_ITEMS backpackItems player
#define PGOOGLES goggles player
#define P_ASSIGNED assignedItems player
#define CURWEAPON currentWeapon player
#define ANIMSTATE animationState player
#define NOTATTACHED(unit1) (isNull attachedTo unit1)

//Display Macros
#define CONTROL(disp,ctrl) ((findDisplay ##disp) displayCtrl ##ctrl)
#define CONTROL_DATA(ctrl) (lbData[ctrl,lbCurSel ctrl])
#define CONTROL_VALUE(ctrl) (lbValue[ctrl,lbCurSel ctrl])
#define CONTROL_DATAI(ctrl,index) ctrl lbData index
#define CONTROL_VALUEI(ctrl,index) ctrl lbValue index
#define CONTROL_TEXTI(ctrl,index) ctrl lbText index

#define grpPlayer group player
#define steamid getPlayerUID player

//Condition Macros
#define EQUAL(condition1,condition2) condition1 isEqualTo condition2
#define ISANIMSTATE(condition1) (animationState player) isEqualTo condition1
#define ISPSIDE(condition1) playerSide isEqualTo condition1
#define VEHPLAYER (vehicle player) isEqualTo player
#define NOTINVEH(condition1) isNull objectParent condition1
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitWith { _res = true };} forEach _types;_res}
#define ALTIS_TANOA(var1,var2) if (worldName isEqualTo "Altis") then {var1} else {var2}
#define ISLOCAL(var1) if (isLocalized (var1)) then {localize var1} else {var1}