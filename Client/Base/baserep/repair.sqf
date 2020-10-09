_color = "#00ff00";
_dam = (1 - getDammage obj)*100;
_dr = 100 - _dam;

sleep 1;
_currentSupply = 0;
_currentSupply = (WF_Client_SideJoined) Call WFCO_FNC_GetSideSupply;
if (_currentSupply > 5) then {
for "_j" from 0 to 1 do 
{
  sleep 1;
  player playMove "AinvPknlMstpSlayWrflDnon_medic";
  for "_i" from 0 to 6 do 
  {
   
    _dam = (1 - getDammage obj)*100;
	if ( _dam > 67) then {_color = "#00ff00";} else {
    if ( _dam > 37) then {_color = "#ffe400"} else {_color = "#ff0000"}};
    _text = composeText [   
    parseText format ["<t size='1'>%1</t><br /><t size='1.2'>%2:</t><t size='1.2' color='%3' align='center'> %4 %5</t>",(baseb select objnum) select 1,localize "RB_state",_color ,str (_dam), "%"]
    ];
    hint _text;
    if (_dam == 100 && _currentSupply == 0) exitWith {repairprocess = "no";};
	[WF_Client_SideJoined, -15] Call WFCO_FNC_ChangeSideSupply;
    _dam = _dam + (baseb select objnum select 3);
    _dam = 1 - (_dam/100);	
    obj setDamage _dam;
    sleep 1; 
   };
 };}
 else {_text = composeText [parseText format ["<t size='1'>%1</t><br /><t size='1.2'>%2:</t><t size='1.2' color='%3' align='center'> %4 %5</t>",(baseb select _i) select 1,localize "RB_have_no_suppluys_for_rep",_color ,str (_dam), "%"]];
 hint _text;
 };
 
repairprocess = "no";