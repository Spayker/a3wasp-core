//------------------fn_passVoteResults--------------------------------------------------------------------------------//
//	Server calls this function through remoteExec for passing voting results                                          //
//------------------fn_passVoteResults--------------------------------------------------------------------------------//

params ["_electResults"];

missionNamespace setVariable ["WF_VOTES", _electResults];