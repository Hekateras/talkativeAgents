local simdefs = include("sim/simdefs")
local T_EVENT = simdefs.TA_EVENT_TABLE.EVENTS
local T_PROB = simdefs.TA_EVENT_TABLE.PROBS

-- the p_ variables are always integers between 0 and 1 representing the likelihood that the line will play. You can use the default ones set in simdefs by Talkative Agents (found in event_table.lua), or override them by just specifying your own integer instead.

-- There are some triggers I never bothered to use for TA or assign p_ values to them, but they are nonetheless still functional. They are set to 'nil' in the example. Just pick your own p_ value for them.

-- You don't need to come up with lines for every type of event trigger. Just leave the ones you don't want blank. Lines for being selected, attackinging, looting safes and exiting the mission are the most common and important to have. Try to keep lines fairly short and distinct from each other. If you can't think of a good one, it's better to just leave that one blank.

-- Below is a sample table containing every possible currently-implemented type of trigger with lines that explain the trigger. Use this as reference. If you scroll down, you'll find a proper template below.
	
local TA_lines = {

	-- replace "modded_agentID" with whatever the agentID of your modded agent is.
	["modded_agentID"] = {
		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"This line plays when an agent is selected for the very first time in a mission.","This line might play instead.","Try to aim for at least three lines per event, to avoid repetiveness."}},
		[T_EVENT.EV_RESELECTED] = {T_PROB.p_selected,{ "This plays when an agent is selected after rewinding.", }},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"This plays for ranged attacks with a lethal weapon."}},
		[T_EVENT.SHOOT_DRONE] =		{T_PROB.p_shootdrone,{"This plays for lethal ranged attacks on a drone."}},
		[T_EVENT.SHOOT_CAMERA] =		{T_PROB.p_shootcam,{"When you destroy a camera with a gun."}},
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"When you KO someone with a gun. Does NOT play for TAG pistols, etc."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"For melee-attacking."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Activating overwatch.",}},
		[T_EVENT.OVERWATCH_MELEE] =		nil, -- set the event entry to nil, like this, if you don't want ANY lines for that type of trigger. Or just delete the entire entry.
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Took damage!"}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Was revived after being in critical condition."}},

		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Getting PWR from a console."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Looting a safe."}},
		[T_EVENT.THREAT_DEVICE_LOOTED] =	{T_PROB.p_loot,{"Looting a Scanner AMP/Router/etc."}},

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Having your move interrupted, usually because you got seen by a camera OR a guard."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"You can guess this one."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Pinning a KO'd guard OR a drone."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Installing a new augment."}},
		[T_EVENT.DISGUISE_IN] =		{1,{"Activating a disguise."}},
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Cloaking."}},
		[T_EVENT.SET_SHOCKTRAP] =		{T_PROB.p_setshocktrap, {"Setting a trap on a door.",}},		
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Using a medgel to revive someone ELSE."}},
		[T_EVENT.WAKE_OTHER] =		nil, -- waking a KO agent by stimming them

		[T_EVENT.PARALYZER] =		nil, -- using a paralyzer on a guard
		[T_EVENT.STIM_SELF] =		{1,{"Using a stim on yourself."}},
		[T_EVENT.STIM_OTHER] =		nil, --stimming another agent, who is not KO
		[T_EVENT.STIMMED_BY] =		nil, -- being stimmed by another agent
		[T_EVENT.AWAKENED_BY] =		nil, --being stimmed AND awakened from KO by another agent...
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"This plays when the agent activates the Detention Center processor to release another agent, and AFTER the other agent's own rescued line."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"This plays when exiting a mission that went badly, meaning you failed the objective or one of the escaping agents is KO, OR an agent died during the mission (only with Permadeath mod).",}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Plays when exiting a mission that went well - you got the objective and nobody escaping is KO."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"Plays when exiting a mission where you killed three or more enemies, including drones. Takes priority over the good/bad escape lines.",}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Plays when exiting a mission and leaving an unconscious agent behind. Takes priority over good/bad esape lines.",}},
		[T_EVENT.OW_INTERVENTION] =	 {T_PROB.p_savefromow,{"Plays when taking out a guard (melee or ranged) who had another agent overwatched. Will also play when meleeing a guard who had YOU overwatched because of a tricky to fix quirk... Oops."}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"When another agent dies during the mission - only possible with Permadeath mod."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Plays when using the 'surrender' option available to overwatched agents in the Extra Agent Abilities mod. The agent is temporarily knocked out after this and guards will try to haul them away."}},
	},	
	
	-- Below is a more bare-bones template with only the basic/most common trigger types where you can directly start writing your custom lines. 

	["other_modded_agentID"] = {
		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{""}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{""}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{""}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"",}},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{""}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{""}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{""}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{""}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{""}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{""}},		
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{""}},
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{""}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"",}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{""}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"",}},
		[T_EVENT.OW_INTERVENTION] =	 {T_PROB.p_savefromow,{""}},
	},	
}

return TA_lines