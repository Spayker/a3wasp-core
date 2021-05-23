Params ['_position'];

{
    _x hideObjectGlobal true
} forEach (nearestTerrainObjects [_position, WF_C_CLEAN_AREA_KINDS, WF_C_BASE_TERRAIN_CLEAN_AREA_RANGE]);


{
    if(!(_x isKindOf 'WarfareBBaseStructure') && !(_x isKindOf 'Warfare_HQ_base_unfolded') && !(_x isKindOf 'StaticWeapon') && !(typeOf _x in WF_C_GARBAGE_OBJECTS)
            && !(typeOf _x in WF_C_CAMP_SEARCH_ARRAY) && !(typeOf _x in WF_Logic_Depot) ) then {
        _x hideObjectGlobal true
    }
} forEach (_position nearObjects ["House", WF_C_BASE_TERRAIN_CLEAN_AREA_RANGE])