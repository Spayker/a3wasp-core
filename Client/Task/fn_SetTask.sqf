Private ["_task","_taskPos","_taskTime","_taskTimeLabel"];

_task = _this select 0;
_taskTime = _this select 1;
_taskTimeLabel = _this select 2;
_taskPos = _this select 3;

if (!isNull(comTask)) then {player removeSimpleTask comTask};
comTask = player createSimpleTask ["CommanderOrder"];
comTask setSimpleTaskDescription [Format[localize "STR_WF_CHAT_TaskTO_Display",_task,_taskTimeLabel], _task, _task];
comTask setSimpleTaskDestination _taskPos;
player setCurrentTask comTask;

["TaskAssigned",[localize "str_taskNew",_task]] call BIS_fnc_showNotification;

[comTask,_taskTime,_taskPos,_task] Spawn {
	Private ["_duration","_pos","_succeed","_task","_timer","_type"];
	_task = _this select 0;
	_duration = (_this select 1)*60; //--- Converts to seconds.
	_pos = _this select 2;
	_type = _this select 3;
	
	_timer = 0;
	_succeed = false;
	while {(taskDestination _task) select 0 == (_pos select 0) && !_succeed} do {
		sleep 5;
		if (player distance _pos < 250) then {_timer = _timer + 5};
		if (_timer > _duration) then {_succeed = true};
	};
	
	if (_succeed) then {
		taskHint [format [localize "str_taskAccomplished" + "\n%1",_type], [1,1,1,1], "taskDone"];
		_task setTaskState "Succeeded";
		player kbTell [sideHQ, WF_V_HQTopicSide, "OrderDone",["1","","HQ",["HQ"]],["2","","We are",["WeAre"]],["3","","ready for orders",["ReadyForOrders"]],["4","","over.",["Over1"]],true];
	};
};