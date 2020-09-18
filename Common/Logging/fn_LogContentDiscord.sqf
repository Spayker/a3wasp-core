params [["_message",""],["_type",0]];

switch (_type) do {
    case 0: { diag_log Format["[WFDC]: %1", _message]; };
    case 1: { diag_log Format["[WFDCM]: %1", _message]; };
};