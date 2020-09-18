disableSerialization;

12450 cutText ["","PLAIN",0];

_side = _this Select 0;
_sideText = Localize "STR_WF_PARAMETER_Side_East";
if (_side == West) then {_sideText = Localize "STR_WF_PARAMETER_Side_West"};
_sideName = Format[Localize "STR_WF_END_Victory",_sideText];

_width = 0.4;
TitleText["","PLAIN"];
sleep 0.5;
CutRsc["EndOfGameStats","PLAIN",0];

_eastUnitsCreated = WF_Logic getVariable "eastUnitsCreated";
_eastCasualties = WF_Logic getVariable "eastCasualties";
_eastVehiclesCreated = WF_Logic getVariable "eastVehiclesCreated";
_eastVehiclesLost = WF_Logic getVariable "eastVehiclesLost";
_westUnitsCreated = WF_Logic getVariable "westUnitsCreated";
_westCasualties = WF_Logic getVariable "westCasualties";
_westVehiclesCreated = WF_Logic getVariable "westVehiclesCreated";
_westVehiclesLost = WF_Logic getVariable "westVehiclesLost";

_eastCreatedRate = _eastVehiclesCreated / 5 * .1;
_eastLostRate = _eastVehiclesLost / 5 * .1;
_eastRecruitedRate = _eastUnitsCreated / 5 * .1;
_eastCasualtiesRate = _eastCasualties / 5 * .1;

_westCreatedRate = _westVehiclesCreated / 5 * .1;
_westLostRate = _westVehiclesLost / 5 * .1;
_westRecruitedRate = _westUnitsCreated / 5 * .1;
_westCasualtiesRate = _westCasualties / 5 * .1;

waitUntil {!isNull (["currentCutDisplay"] call BIS_FNC_GUIget)};
((["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90001) CtrlSetText _sideName;

_westRecruitedCounter = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90200;
_westRecruitedBar = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90201;
_westCasualtyCounter = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90202;
_westCasualtyBar = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90203;
_westCreatedCounter = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90204;
_westCreatedBar = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90205;
_westLostCounter = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90206;
_westLostBar = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90207;

_position = CtrlPosition _westRecruitedBar;
_recruited = _width * (_westUnitsCreated / 500);
if (_recruited > _width) then {_recruited = _width};
_position Set[2,0];
_westRecruitedBar CtrlSetPosition _position;
_westRecruitedBar CtrlCommit 0;
_position Set[2,_recruited];
_westRecruitedBar CtrlSetPosition _position;
_westRecruitedBar CtrlCommit 8;

_position = CtrlPosition _westCasualtyBar;
_casualties = _width * (_westCasualties / 500);
if (_casualties > _width) then {_casualties = _width};
_position Set[2,0];
_westCasualtyBar CtrlSetPosition _position;
_westCasualtyBar CtrlCommit 0;
_position Set[2,_casualties];
_westCasualtyBar CtrlSetPosition _position;
_westCasualtyBar CtrlCommit 8;

_position = CtrlPosition _westCreatedBar;
_created = _width * (_westVehiclesCreated / 150);
if (_created > _width) then {_created = _width};
_position Set[2,0];
_westCreatedBar CtrlSetPosition _position;
_westCreatedBar CtrlCommit 0;
_position Set[2,_created];
_westCreatedBar CtrlSetPosition _position;
_westCreatedBar CtrlCommit 8;

_position = CtrlPosition _westLostBar;
_lost = _width * (_westVehiclesLost / 150);
if (_lost > _width) then {_lost = _width};
_position Set[2,0];
_westLostBar CtrlSetPosition _position;
_westLostBar CtrlCommit 0;
_position Set[2,_lost];
_westLostBar CtrlSetPosition _position;
_westLostBar CtrlCommit 8;

_eastRecruitedCounter = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90101;
_eastRecruitedBar = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90102;
_eastCasualtyCounter = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90103;
_eastCasualtyBar = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90104;
_eastCreatedCounter = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90105;
_eastCreatedBar = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90106;
_eastLostCounter = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90107;
_eastLostBar = (["currentCutDisplay"] call BIS_FNC_GUIget) DisplayCtrl 90108;

_position = CtrlPosition _eastRecruitedBar;
_recruited = _width * (_eastUnitsCreated / 500);
if (_recruited > _width) then {_recruited = _width};
_position Set[2,0];
_eastRecruitedBar CtrlSetPosition _position;
_eastRecruitedBar CtrlCommit 0;
_position Set[2,_recruited];
_eastRecruitedBar CtrlSetPosition _position;
_eastRecruitedBar CtrlCommit 8;

_position = CtrlPosition _eastCasualtyBar;
_casualties = _width * (_eastCasualties / 500);
if (_casualties > _width) then {_casualties = _width};
_position Set[2,0];
_eastCasualtyBar CtrlSetPosition _position;
_eastCasualtyBar CtrlCommit 0;
_position Set[2,_casualties];
_eastCasualtyBar CtrlSetPosition _position;
_eastCasualtyBar CtrlCommit 8;

_position = CtrlPosition _eastCreatedBar;
_created = _width * (_eastVehiclesCreated / 150);
if (_created > _width) then {_created = _width};
_position Set[2,0];
_eastCreatedBar CtrlSetPosition _position;
_eastCreatedBar CtrlCommit 0;
_position Set[2,_created];
_eastCreatedBar CtrlSetPosition _position;
_eastCreatedBar CtrlCommit 8;

_position = CtrlPosition _eastLostBar;
_lost = _width * (_eastVehiclesLost / 150);
if (_lost > _width) then {_lost = _width};
_position Set[2,0];
_eastLostBar CtrlSetPosition _position;
_eastLostBar CtrlCommit 0;
_position Set[2,_lost];
_eastLostBar CtrlSetPosition _position;
_eastLostBar CtrlCommit 8;

_timePassed = 0;
_eastCasualtyCount = 0;
_eastRecruitedCount = 0;
_eastCreatedCount = 0;
_eastLostCount = 0;

_westCasualtyCount = 0;
_westRecruitedCount = 0;
_westCreatedCount = 0;
_westLostCount = 0;

while {_timePassed < 8} do {
	sleep 0.1;

	_eastRecruitedCount = _eastRecruitedCount + _eastRecruitedRate;
	if (_eastRecruitedCount > _eastUnitsCreated) then {_eastRecruitedCount = _eastUnitsCreated};
	_eastRecruitedCounter CtrlSetText Format["%1",_eastRecruitedCount - (_eastRecruitedCount % 1)];

	_eastCasualtyCount = _eastCasualtyCount + _eastCasualtiesRate;
	if (_eastCasualtyCount > _eastCasualties) then {_eastCasualtyCount = _eastCasualties};
	_eastCasualtyCounter CtrlSetText Format["%1",_eastCasualtyCount - (_eastCasualtyCount % 1)];

	_eastCreatedCount = _eastCreatedCount + _eastCreatedRate;
	if (_eastCreatedCount > _eastVehiclesCreated) then {_eastCreatedCount = _eastVehiclesCreated};
	_eastCreatedCounter CtrlSetText Format["%1",_eastCreatedCount - (_eastCreatedCount % 1)];

	_eastLostCount = _eastLostCount + _eastLostRate;
	if (_eastLostCount > _eastVehiclesLost) then {_eastLostCount = _eastVehiclesLost};
	_eastLostCounter CtrlSetText Format["%1",_eastLostCount - (_eastLostCount % 1)];

	_westRecruitedCount = _westRecruitedCount + _westRecruitedRate;
	if (_westRecruitedCount > _westUnitsCreated) then {_westRecruitedCount = _westUnitsCreated};
	_westRecruitedCounter CtrlSetText Format["%1",_westRecruitedCount - (_westRecruitedCount % 1)];

	_westCasualtyCount = _westCasualtyCount + _westCasualtiesRate;
	if (_westCasualtyCount > _westCasualties) then {_westCasualtyCount = _westCasualties};
	_westCasualtyCounter CtrlSetText Format["%1",_westCasualtyCount - (_westCasualtyCount % 1)];

	_westCreatedCount = _westCreatedCount + _westCreatedRate;
	if (_westCreatedCount > _westVehiclesCreated) then {_westCreatedCount = _westVehiclesCreated};
	_westCreatedCounter CtrlSetText Format["%1",_westCreatedCount - (_westCreatedCount % 1)];

	_westLostCount = _westLostCount + _westLostRate;
	if (_westLostCount > _westVehiclesLost) then {_westLostCount = _westVehiclesLost};
	_westLostCounter CtrlSetText Format["%1",_westLostCount - (_westLostCount % 1)];

	_timePassed = _timePassed + 0.1;
};