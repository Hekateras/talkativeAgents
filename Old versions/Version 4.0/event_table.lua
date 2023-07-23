local TA_table = {

	EVENTS = {
	--	name of speech event		-- Corresponding existing simdef EV or TRG
	--	= value of existed EV/TRG on the right

		ATTACK_GUN = 8,			-- EV_UNIT_START_SHOOTING
		ATTACK_MELEE = 30,		-- EV_UNIT_MELEE

		GOT_HIT = 57,			-- EV_UNIT_HIT, not trigger on Last Words
		REVIVED = 102,			-- EV_UNIT_HEAL
		HIJACK = 19,			-- EV_UNIT_USECOMP also EV_UNIT_WIRELESS_SCAN for Internationale's wireless hijack got sent here
		INTERRUPTED = 4,		-- EV_UNIT_INTERRUPTED
		PEEK = 18,			-- EV_UNIT_PEEK
		OVERWATCH = 27,			-- EV_UNIT_OVERWATCH
		OVERWATCH_MELEE = 28,		-- EV_UNIT_OVERWATCH_MELEE
		PIN = 111,			-- EV_UNIT_START_PIN -- unused in game --Not anymore -- added by Cyberboy2000 :)

		SAFE_LOOTED = 66,       	-- TRG_SAFE_LOOTED -- there's trigger used
		INSTALL_AUGMENT = 62,
		DISGUISE_IN = 129,		-- for Prism's disguise
		CLOAK_IN = 614,			-- for activating cloak

		WIRELESS_SCAN = 100,		-- solely for Wireless Emitter Nerf mod, won't trigger normally

	-- next added for 'custom' events (sub-events?):

		ATTACK_GUN_KO = 1008,		-- for dartguns
		MEDGEL = 1009,			-- for using medgel on a downed agent
		SHOOT_CAMERA = 1010,
		SHOOT_DRONE = 1011,

		PARALYZER = 1012,		-- Banks have test line
		STIM_SELF = 1013,		-- Rush have test line		-- I just put some placeholders to test. Shirsh
		STIM_OTHER = 1014,		-- Shalem have test line
		SELF_STIMMED = 1015,		-- Rush have test line
		STIMMED_BY = 1016,		-- Rush have test line
		WAKE_OTHER = 1017,		-- Rush have test line
		AWAKENED_BY = 1018,		-- Shalem have test line

		EXEC_TERMINAL_LOOTED = 1019,	-- optional for Exec Terminals
		THREAT_DEVICE_LOOTED = 1020,	-- optional for looting FTM devices with tech (scanner and router)

		RESCUER = 1021,			-- agent who opens detention cell
		BAD_ESCAPE = 1022, -- Exit teleporter comments
		GOOD_ESCAPE = 1023,
		BLOODY_MISSION = 1024,
		ABANDONING_OTHER = 1025,
		SET_SHOCKTRAP = 1026,
		SAVED_FROM_OW = 2001, -- saved from guard, both currently unused
		AGENT_DEATH = 1027,
		OW_INTERVENTION = 1028, -- save someone from a guard who's on OW
		EVENT_SELECTED = 1029, --now used! fires once per mission per agent
		EV_RESELECTED = 1031, -- on selected, but used instead of above after rewinding
		SURRENDER = 73, --for "surrender" ability from New Corporate Tactics. unused simdefs.TRG_LAST_WORDS

		EV_MONSTER_MID2 = 2003, --Monster complains that you steal his gun
		EV_MONSTER_MID2_ESCORTSFIXED = 2004, --Monster steals his gun back
	},

	PROBS = {

		-- Speech chance  list
		-- Can be edited here centrally to change the chance that line will fire for a specific trigger, for all agents.
		-- If need be, agent-specific chances can still be tweaked by directly using a number there.

		p_selected = 1,
		p_gun = 0.7,
		p_gunko = 0.7,
		p_melee = 0.6,
		p_ow = 0.6,
		p_gothit = 0.7,
		p_revived = 0.8,
		p_scan = 0.5,
		p_hj = 0.2,
		p_loot = 0.5,
		p_inter = 0.5,
		p_peek = 0.05,
		p_pin = 0.5,
		p_augm = 0.9,
		p_cloak = 0.8,
		p_medgel = 0.8,
		p_rescuer = 0.8, --0.5
		p_shootcam = 0.7,
		p_shootdrone = 0.7,
		p_badescape = 1, -- 0.9
		p_goodescape = 1,
		p_bloodymission = 1,
		p_abandonedother = 1,
		p_setshocktrap = 0.8,
		p_savefromow = 0.9,
		p_ow_saved = 1, --0.8 --unused
		p_agentdeath = 0.9,
		p_surrender = 1,

		-- guard p values
		p_guard_generic = 0.4,
		p_guard_generic_hunt = 0.4,
		p_guard_cfo = 0.5, -- these NPCs are rarer so make theirs procc more frequently
		p_guard_admin = 0.5,
		p_guard_sci = 0.5,
		p_guard_drone = 0.3,
		p_begging = 0.15,
		p_guard_goose = 0.4,	
	},

}

return TA_table