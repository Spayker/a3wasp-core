(_this # 0)  setVariable ['avail',missionNamespace getVariable "WF_C_BASE_AV_FORTIFICATIONS"];
(_this # 0)  setVariable ['availStaticDefense',missionNamespace getVariable "WF_C_BASE_DEFENSE_MAX"];
(_this # 0)  setVariable ["side",(_this # 1) ];
(_this # 2) setVariable ["wf_basearea", (_this # 3)+ [(_this # 0)], true]