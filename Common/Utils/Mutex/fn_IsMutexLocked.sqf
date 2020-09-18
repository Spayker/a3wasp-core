//------------------fn_IsMutexLocked--------------------------------------------------//
//	Check status of mutex                                                             //
//------------------fn_IsMutexLocked--------------------------------------------------//

params ["_mutex", ["_namespace", currentNamespace]];

//--Is if not nil = locked--
//--Заблокированным считается наличие любого значения в переменной, кроме nil--
!isNil { _namespace getVariable _mutex; };