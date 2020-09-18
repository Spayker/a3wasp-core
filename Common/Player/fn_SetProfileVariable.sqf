/*
	Set a variable in the profile namespace.
	 Parameters:
		- Variable name.
		- Value.
*/

Private ['_var','_value'];

_var = _this select 0;
_value = _this select 1;

profileNamespace setVariable [_var, _value];