//------------------fn_MutexTryLock--------------------------------------------------//
//	Retrieve status of mutex                                                         //
//  IsNil {} construction cannot be interrupted from outside                         //
//------------------fn_MutexTryLock--------------------------------------------------//

params ["_mutex", ["_namespace", currentNamespace]];

private ["_locked"];

//--Do lock mutex in unscheduled environment (isNil {})--
//--Вызываем код блокировки в isNil, т. к. код в данной команде вызывается в незапланированной среде--
isNil {
	//--Lock mutex if it is unlocked--
    if ([_mutex, _namespace] call WFCO_FNC_IsMutexLocked) then {
        _locked = false;
    } else {
        _namespace setVariable [_mutex, true];
        _locked = true;
    };
};

_locked;