uisleep 3;

12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t>" + 	
	"<br /><t size='1.5'>100%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingGearTemplates')+"</t>","BLACK IN",2, true, true];

hudOn = false;

[] spawn {
	uisleep 3;

    _tipsData = selectRandom WF_C_INTRO_TIPS;
    _imageTips = _tipsData # 0;
    _textTips = localize (_tipsData # 1);

	[
	    parseText format["<t align='center' color='%1' font='PuristaBold' size='4.5'>%2 %3</t><br /><t align='center' font='PuristaLight' size='2.5'>%4</t><br /><br /><t align='center' valign='center' size='12'><img shadow='1' image='%5'/><br /><br /><t align='center' color='#ffd719' size='1'>%6</t></t>",
                        '#00a2e8', // title color
                        localize 'STR_MissionWorld_Intro_Title', // title text n1
                        localize format ['STR_MissionWorld_%1_Region', toLower worldName], // title text n2
                        localize 'STR_MissionWorld_Intro_QuickTips',
                        _imageTips,
                        _textTips
	                ],
		[0,0,1,1], [10, 10], 12, 1, 0.5
    ] spawn BIS_fnc_textTiles;
};

[] spawn {
    params[["_sleep", 16]];
    private ["_hq","_hqstatus","_closestTown"];

    sleep _sleep;

    _mhqs = (side player) Call WFCO_FNC_GetSideHQ;
    _hq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
	_hqstatus = [localize "STR_Destroyed", "OK"] select (alive _hq);
	_closestTown = [_hq, towns] call WFCO_FNC_GetClosestEntity;

	[
			[
				[localize "STR_MissionInfo_Region", "<t align = 'center' shadow = '1' size = '1' font='TahomaB'>%1</t>", 1],
				[localize format ['STR_MissionWorld_%1_Region', toLower worldName], "<t align = 'center' shadow = '1' size = '0.9'> %1</t>", 1],
				[localize "STR_MissionInfo_Time", "<br /><t align = 'center' shadow = '1' size = '1' font='TahomaB'>%1</t>", 1],
				[[] call WFCO_FNC_dateToString, "<t align = 'center' shadow = '1' size = '0.9'> %1</t>", 1],
				[localize "STR_MissionInfo_HQStatus", "<br /><t align = 'center' shadow = '1' size = '1' font='TahomaB'>%1</t>", 1],
				[format["[%1], %2", _hqstatus, format[localize "STR_MissionInfo_HQNearestTown", floor (_hq distance _closestTown), toUpper (_closestTown getVariable ["name", "?"])]],
					"<t align = 'center' shadow = '1' size = '0.9'> %1</t>", 1],
				[localize "STR_MissionInfo_NumOfBases", "<br /><t align = 'center' shadow = '1' size = '1' font='TahomaB'>%1</t>", 1],
				[str(count (WF_Client_Logic getVariable "wf_basearea")), "<t align = 'center' shadow = '1' size = '0.9'> %1</t>", 20]
			],
			(safeZoneX + safeZoneW / 2) - 0.2
	] spawn BIS_fnc_typeText;
};

_randomValue = random 100;
_camera = "camera" camCreate [((getPosATL player) # 0) + _randomValue, ((getPosATL player) # 1)+_randomValue,
                ((getPosATL player) # 2) + 500];
_camera cameraEffect ["Internal","back"];

_mseed = floor random [1,3,5];

switch(_mseed) do
{
	case 1: { 0 = []spawn { playMusic "LeadTrack02_F_EPA"; }; };
	case 2: { 0 = []spawn { playMusic "LeadTrack02b_F_EPA"; }; };
	case 3: { 0 = []spawn { playMusic "LeadTrack04_F_EPC"; }; };
	case 4: { 0 = []spawn { playMusic "BackgroundTrack02_F"; }; };
	case 5: { 0 = []spawn { playMusic "LeadTrack01b_F"; }; };
};

_camera camSetTarget player;
_camera camPreparePos ([((getPosATL player) select 0) + 21,((getPosATL player) select 1) + 21,((getPosATL player) select 2)+ 25]);
_camera camPrepareFOV 0.700;
_camera camCommitPrepared 30;

waituntil {camCommitted _camera};
_camera camPreparePos ([(getPosATL player) select 0,(getPosATL player) select 1,((getPosATL player) select 2)]);
_camera camCommitPrepared 4;
waituntil {camCommitted _camera};

_camera cameraEffect ["Terminate","back"];

WF_EndIntro = true;
hudOn = true;

_logic = (WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic;
_sleepTime = 3;

if(!isNil {_logic getVariable "wf_votetime"}) then {
	_sleepTime = _sleepTime + (_logic getVariable "wf_votetime");
};
