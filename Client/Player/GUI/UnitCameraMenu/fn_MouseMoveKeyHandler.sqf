private ["_coord_x", "_coord_y"];
_coord_x = _this select 1;
_coord_y = _this select 2;

_anchor = uiNamespace getVariable "wf_dialog_ui_unitscam_anchor";
if (!isNil '_anchor') then { //--- Make sure that the mouse is still being held
    _origin_x = _anchor select 0;
    _origin_y = _anchor select 1;

    _dX = ((_coord_x - _origin_x) * 180) / 20;
    _dY = (-(_coord_y - _origin_y) * 180) / 20;

    uiNamespace setVariable ["wf_dialog_ui_unitscam_dir", (uiNamespace getVariable "wf_dialog_ui_unitscam_dir") + _dX];
    _pitch = ((uiNamespace getVariable "wf_dialog_ui_unitscam_pitch") + _dY) max -90 min +90;
    uiNamespace setVariable ["wf_dialog_ui_unitscam_pitch", _pitch];
}