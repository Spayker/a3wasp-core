//------------------fn_MutexUnlock--------------------------------------------------//
//	Initiate changing of a flag to "Unlock". This flag indicates status             //
//  of anything: locked or unlocked                                                 //
//------------------fn_MutexUnlock--------------------------------------------------//

params ["_mutex", ["_namespace", currentNamespace]];

//--Unlock mutex (Just delete variable)--
//--Разблокируем мьютекс (Просто удаляем переменную)--
_namespace setVariable [_mutex, nil];