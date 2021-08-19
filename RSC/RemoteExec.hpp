#define F(NAME,TARGET) class NAME { \
	allowedTargets = TARGET; \
};
#define ANYONE 0
#define CLIENT 1
#define SERVER 2

class CfgRemoteExec {
    class Functions {
        mode = 2;
        jip = 1;
        /* Called on the Clients */
		F(WFCL_FNC_ARRadarMarkerUpdate,CLIENT)
		F(WFCL_FNC_AwardBountyPlayer,CLIENT)
		F(WFCL_FNC_AwardBounty,CLIENT)
		F(WFCL_FNC_doJump,CLIENT)
		F(WFCL_FNC_setVehicleLock,CLIENT)
		F(WFCL_FNC_ChangePlayerFunds,CLIENT)
		F(WFCL_FNC_passVoteResults,CLIENT)
		F(WFCL_FNC_UpdatgeRadarMarker,CLIENT)
		F(setshotparents,CLIENT)
		F(hint,CLIENT)
		F(hintSilent,CLIENT)

        /* Called on the Server */
		F(WFSE_FNC_GetGearTemplates,SERVER)
		F(WFSE_FNC_SaveGearTemplate,SERVER)
		F(WFSE_fnc_RequestMHQRepair,SERVER)
		F(WFSE_fnc_RequestVehicleLock,SERVER)
		F(WFSE_fnc_RequestChangeScore,SERVER)
		F(WFSE_fnc_RequestNewCommander,SERVER)
		F(WFSE_fnc_RequestCommanderVote,SERVER)
		F(WFSE_fnc_RequestTeamUpdate,SERVER)
		F(WFSE_fnc_RequestUpgrade,SERVER)
		F(WFSE_fnc_RequestJoin,SERVER)
		F(WFSE_fnc_RequestStructure,SERVER)
		F(WFSE_fnc_RequestStructureSell,SERVER)
		F(WFSE_fnc_RequestDefense,SERVER)
		F(WFSE_fnc_RequestAutoWallConstructinChange,SERVER)
		F(WFSE_FNC_GetTownGroups,SERVER)
		F(WFSE_FNC_MarkTownInactive,SERVER)
		F(WFSE_FNC_addEmptyVehicleToQueue,SERVER)
		F(WFSE_FNC_destroyCamp,SERVER)
		F(WFSE_FNC_repairCamp,SERVER)
		F(WFSE_FNC_passVote,SERVER)

        /* Functions for everyone */
		F(WFCL_FNC_LocalizeMessage,ANYONE)
		F(WFCL_FNC_SetTask,ANYONE)		
		F(WFCL_FNC_CampCaptured,ANYONE)
		F(BIS_fnc_taskCreate,ANYONE)
		F(BIS_fnc_setTask,ANYONE)
		F(BIS_fnc_taskSetDescription,ANYONE)
		F(ASL_Rope_Set_Mass,ANYONE)
		F(ASL_Extend_Ropes,ANYONE)
		F(ASL_Shorten_Ropes,ANYONE)
		F(ASL_Release_Cargo,ANYONE)
		F(ASL_Retract_Ropes,ANYONE)
		F(ASL_Hint,ANYONE)
		F(ASL_Deploy_Ropes,ANYONE)
		F(ASL_Deploy_Ropes_Index,ANYONE)
		F(ASL_Attach_Ropes,ANYONE)
		F(ASL_Drop_Ropes,ANYONE)
		F(ASL_Hide_Object_Global,ANYONE)
		F(ASL_Pickup_Ropes,ANYONE)		
    };

    class Commands {
        mode = 1;
        jip = 1;

		F(call,SERVER)
		F(execVM,ANYONE)
		F(say3d,ANYONE)
		F(setFace,ANYONE)
		F(enableSimulationGlobal,ANYONE)
		F(animatesource,ANYONE)
		F(addeventhandler,ANYONE)
    };
};