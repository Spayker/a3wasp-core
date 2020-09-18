//------------------fn_MutexLock--------------------------------------------------//
//	Initiate changing of a flag to "Lock". This flag indicates status             //
//  of anything: locked or unlocked                                                 //
//------------------fn_MutexLock--------------------------------------------------//

params ["_mutex", ["_namespace", currentNamespace]];

//--Wait for mutex lock--
waitUntil {
	//--Try to lock mutex on each iteration--
	//--Пытаемся заблокировать мьютекс на очередной итерации цикла--
    [_mutex, _namespace] call WFCO_FNC_MutexTryLock;
};