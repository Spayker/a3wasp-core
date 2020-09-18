params[["_rmtFnc", ""], ["_scope", player], ["_params", []], ["_limit", 30]];
private["_result", "_varName", "_rmtVarQueue", "_queueSize", "_tryingCnt", "_rmtVarQuIndex"];

_result = nil;

_queueSize = 5;
_varName = format["rmtVar%1", floor random _queueSize];
_rmtVarQueue = _scope getVariable ["rmtVarQueue", []];
waitUntil { (count _rmtVarQueue) < _queueSize };
while{_varName in _rmtVarQueue} do {
	_varName = format["rmtVar%1", floor random _queueSize];
};

_rmtVarQueue pushBack _varName;
_scope setVariable ["rmtVarQueue", _rmtVarQueue];
_scope setVariable [_varName, nil];

[_scope, _varName, _params] remoteExecCall [_rmtFnc, 2];

_tryingCnt = 0;

if (!canSuspend) then {
	diag_log format["REMOTE EXEC Can't suspend with calling of %1 server function!", _rmtFnc];
	_limit = _limit * 1000;
	
	while {isNil "_result" && _tryingCnt < _limit} do {	
		_result = _scope getVariable [_varName, nil];	
		_tryingCnt = _tryingCnt + 1;
	};
} else {
	while {isNil "_result" && _tryingCnt < _limit} do {	
		_result = _scope getVariable [_varName, nil];	
		_tryingCnt = _tryingCnt + 1;
		sleep 0.01;
	};
};

if(_tryingCnt >= _limit) then {
	diag_log format["REMOTE EXEC Didn't wait result from %1 server function! _varName == %2, _scope 'rmtVarQueue' == %3", 
	_rmtFnc,
	_varName,
	_scope getVariable "rmtVarQueue"];
};

_rmtVarQueue = _scope getVariable ["rmtVarQueue", []];
_rmtVarQuIndex = _rmtVarQueue find _varName;
if(_rmtVarQuIndex != -1) then { _rmtVarQueue deleteAt _rmtVarQuIndex; };
_scope setVariable ["rmtVarQueue", _rmtVarQueue];
_scope setVariable [_varName, nil];

if(!isNil "_result") then {
_result;
};