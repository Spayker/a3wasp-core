/*
	Logging function.
	 Parameters:
		- Log Type.
		- Log Content.
		- {Log Level}.
*/
params ["_logType", "_logContent", ["_logLevel", 0]];

if!(_logLevel isEqualType 0) then { 
	_logLevel = 0;
	diag_log format["Error: %1 has raised error in WFCO_FNC_LogContent", _fnc_scriptNameParent];
};
if (_logLevel >= WF_LogLevel) then {diag_log Format["[WF (%1)] [frameno:%2 | ticktime:%3 | fps:%4] %5",_logType, diag_frameno, diag_tickTime, diag_fps, _logContent]};