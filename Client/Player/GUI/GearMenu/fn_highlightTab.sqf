private ["_IDCs", "_index", "_selected"];
_index = _this;

_IDCs = [70501, 70502, 70503, 70504, 70505, 70506, 70507, 70508];
_selected = _IDCs select _index;
_IDCS = _IDCS - [_selected];

{
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _x) ctrlSetTextColor [0.4, 0.4, 0.4, 1];
} forEach _IDCs;
((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _selected) ctrlSetTextColor [0.258823529, 0.713725490, 1, 1];