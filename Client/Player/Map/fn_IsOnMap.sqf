Private ['_adis','_bdis','_borderdis','_boundary','_difx','_dify','_dir','_position','_positiondis','_sqrradH','_sqrradHR'];

_boundary = missionNamespace getVariable 'WF_BOUNDARIESXY';
_sqrradH = _boundary / 2;
_sqrradHR = [_sqrradH,_sqrradH];
_position = [getPos player select 0, getPos player select 1];

_difx = (_position select 0) - _sqrradH;
_dify = (_position select 1) - _sqrradH;
_dir = atan (_difx / _dify);
if (_dify < 0) then {_dir = _dir + 180};
_adis = abs (_sqrradH / cos (90 - _dir));
_bdis = abs (_sqrradH / cos _dir);
_borderdis = _adis min _bdis;
_positiondis = _position distance _sqrradHR;

if (_positiondis < _borderdis) then {true} else {false}