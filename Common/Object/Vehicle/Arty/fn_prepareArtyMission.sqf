Private ['_vehicle'];

_vehicle = _this select 0;

if (alive (driver _vehicle)) then {
	(driver _vehicle) action ["engineOff", _vehicle];
	{(driver _vehicle) enableAI _x} forEach ["MOVE","TARGET","AUTOTARGET"];
};

waitUntil {speed _vehicle < 1};

sleep 3;