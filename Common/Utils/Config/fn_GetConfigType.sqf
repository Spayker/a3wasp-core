//--------------------------fn_GetConfigType------------------------------------//
//																				//
//	Determines config type of a class									        //
//																				//
//--------------------------fn_GetConfigType------------------------------------//
params [["_class", ""]];
private ["_confType"];

_confType = switch (true) do { //--- Determine the kind of item that we're dealing with
						case (isClass (configFile >> 'CfgWeapons' >> _class)): {"CfgWeapons"};
						case (isClass (configFile >> 'CfgMagazines' >> _class)): {"CfgMagazines"};
						case (isClass (configFile >> 'CfgVehicles' >> _class)): {"CfgVehicles"};
						case (isClass (configFile >> 'CfgGlasses' >> _class)): {"CfgGlasses"};
						default {"nil"};
					};
					
_confType;