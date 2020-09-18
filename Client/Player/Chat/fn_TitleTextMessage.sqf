params ["_message", ["_style", "PLAIN"]];

12451 cutText [format["<t color='%1' size='1.5'>", WF_C_TITLETEXT_COLOR] + _message + "</t>", _style, 1, true, true];