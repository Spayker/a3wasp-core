//-------------------------fn_dateToString--------------------------//
//	author: wasp community                                          //
//  returns: date as string representation "YYYY.mm.dd HH:MM"       //
//-------------------------fn_dateToString--------------------------//

private ["_date","_month","_day","_hours","_minutes"];

_date = date;

_month = date # 1;
_day = date # 2;
_hours = date # 3;
_minutes = date # 4;

if (_month < 10) then {_month = "0" + str _month};
if (_day < 10) then {_day = "0" + str _day};
if (_hours < 10) then {_hours = "0" + str _hours};
if (_minutes < 10) then {_minutes = "0" + str _minutes};

format["%1.%2.%3 %4:%5", _date # 0, _month, _day, _hours, _minutes];