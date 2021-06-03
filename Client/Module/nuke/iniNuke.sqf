private["_blastPos", "_20psi", "_5psi", "_1psi", "_y", "_radFireball", "_rad1psi", "_rad5psi", "_rad20psi", "_rad500rem", "_rad5000rem", "_rad100thermal", "_rad50thermal", "_int", "_jam", "_debug", "_damage", "_uniforms", "_goggles", "_radFallout", "_radCrater", "_airMode"];

_blastPos = _this select 0;
_y = _this select 1;
_debug = _this select 2;
_damage = _this select 3;

//calculate relevant data
_radFireball = (_y ^ 0.39991) * 79.30731 - 0.33774;
_rad1psi = (_y ^ 0.33308) * 1179.03371;
_rad5psi = (_y ^ 0.33325) * 458.29634;
_rad20psi = (_y ^ 0.33355) * 216.89585 + (_y ^ 0.1798) * 1.17158;
_rad500rem = (_y ^ 0.16353) * 228.38886 + (_y ^ 3) * 7.86898e-8 - 0.00175 * (_y ^ 2) + (_y ^ 0.16353) * 625.25398;
_rad5000rem = (_y ^ 0.21107) * 424.37067 + (_y ^ 3) * 2.40299e-6 - 0.00175 * (_y ^ 2) + (_y ^ 0.21107) * 85.15598;
_rad100thermal = (_y ^ 0.43788) * 517.81986 + (_y ^ 3) * 3.17366e-11 - (_y ^ 2) * 4.76245e-6 + (_y ^ (-1.11864)) * 3.50645;
_rad50thermal = (_y ^ 0.9993) * 283.0527 + (_y ^ 5) * 9.10689e-22 + (_y ^ 0.41672) * 598.33159 - 280.91567 * _y;
_radCrater = (_y ^ 0.3342305) * 19.13638 + 0.4707669;

_airMode = switch (param[4, 2]) do {
	case 0: {false};
	case 1: {true};
	case 2: {false};
	default {false};
};

if ((param[4, 2] == 2) && (((_rad5psi + _rad20psi) / 2) < (_blastPos # 2))) then { _airMode = true };

if(_radCrater < 10) then { _radCrater = 0 };
_radFallout = (_rad20psi + _rad5psi) / 2;

//uniforms and googles that protect against fallout
_uniforms = ["U_C_CBRN_Suit_01_White_F", "U_C_CBRN_Suit_01_Blue_F", "U_I_CBRN_Suit_01_AAF_F", "U_B_CBRN_Suit_01_wdl_F", "U_B_CBRN_Suit_01_Tropic_F", "U_B_CBRN_Suit_01_MTP_F", "U_I_E_CBRN_Suit_01_EAF_F"];
_goggles = ["G_AirPurifyingRespirator_01_F", "G_AirPurifyingRespirator_01_nofilter_F", "G_AirPurifyingRespirator_02_black_F", "G_AirPurifyingRespirator_02_olive_F", "G_AirPurifyingRespirator_02_sand_F", "G_RegulatorMask_F"];

if (_y >= 550) then {_rad5000rem = -1;};
if (_y >= 2000) then {_rad500rem = -1;};

//draw marker of the explosion on map (debug option)
if (_debug) then {
	_mark1psi = createMarker ["1 psi Airblast", _blastPos];
	_mark1psi setMarkerColor "ColorGrey";
	_mark1psi setMarkerShape "ELLIPSE";
	_mark1psi setMarkerSize [_rad1psi, _rad1psi];
	_mark1psi setMarkerText "1 psi Airblast";

	_mark5psi = createMarker ["5 psi Airblast", _blastPos];
	_mark5psi setMarkerColor "ColorYellow";
	_mark5psi setMarkerShape "ELLIPSE";
	_mark5psi setMarkerSize [_rad5psi, _rad5psi];
	_mark5psi setMarkerText "5 psi Airblast";

	_mark20psi = createMarker ["20 psi Airblast", _blastPos];
	_mark20psi setMarkerColor "ColorRed";
	_mark20psi setMarkerShape "ELLIPSE";
	_mark20psi setMarkerSize [_rad20psi, _rad20psi];
	_mark20psi setMarkerText "20 psi Airblast";
	
	if(! _airMode) then {
		_markWaste = createMarker ["Nuclear Waste", _blastPos];
		_markWaste setMarkerColor "ColorGreen";
		_markWaste setMarkerBrush "FDiagonal";
		_markWaste setMarkerShape "ELLIPSE";
		_markWaste setMarkerSize [(_rad20psi + _rad5psi) / 2,(_rad20psi + _rad5psi) / 2];
		_markWaste setMarkerText "Nuclear Waste";
	}
};

_radFireball = _radFireball * 0.4; //about 115 * 0.4 = 46 at 2.5 kT

//creates visual effects
[[_blastPos, _radFireball, _airMode],"freestyleNuke\flash.sqf"] remoteExec ["execVM",0];

if(! _airMode) then {
	[[_blastPos, _radFireball,_rad5psi * 0.8,_rad5psi * 1.1],"freestyleNuke\mushroomcloud.sqf"] remoteExec ["execVM",0];
};

[[_blastPos, _rad1psi, _airMode],"freestyleNuke\blastwave.sqf"] remoteExec ["execVM",0];

if (_radFireball > 46) then {
	[_blastPos, _y, _radFireball * 2, _airMode] execVM "freestyleNuke\iniCondensationRings.sqf"
} else {
	[_blastPos, -1, _radFireball * 2, _airMode] execVM "freestyleNuke\iniCondensationRings.sqf"
};

if((! _airMode) && ((_radFireball / 0.4)  > (_blastPos # 2))) then {
	[[_blastPos, _radFallout, 900],"freestyleNuke\falloutParticle.sqf"] remoteExec ["execVM", 0]
};

//create damaging effects
if (_damage) then {
	[_blastPos, _rad5000rem] execVM "freestyleNuke\radioation5000rem.sqf";
	[_blastPos, _rad100thermal] execVM "freestyleNuke\thermal100.sqf";
	
	_20psi = [_blastPos, _rad20psi, _radCrater + 10] execVM "freestyleNuke\airblast20psi.sqf";
	waitUntil { scriptDone _20psi };
	
	
	if(! _airMode) then { _crater = [_blastPos, _radCrater] execVM "freestyleNuke\crater.sqf" };
	
	_5psi = [_blastPos, _rad5psi,_rad20psi] execVM "freestyleNuke\airblast5psi.sqf";
	waitUntil { scriptDone _5psi };

	_1psi = [_blastPos, _rad1psi,_rad5psi] execVM "freestyleNuke\airblast1psi.sqf";
	waitUntil { scriptDone _1psi };
	
	_jam = [_blastPos, _rad1psi] execVM "freestyleNuke\jamming.sqf";
	
	if ((! _airMode) && ((_radFireball / 0.4)  > (_blastPos # 2))) then {
		_waste = [_blastPos, _radFallout, 900, _uniforms, _goggles] execVM "freestyleNuke\nuclearWaste.sqf"
	}
}

