-- Location-specific lines
-- START and FINAL_WORDS lines. These lines are in the same category as vanilla lines and trigger at the start of a mission (in the absence of a multi-character banter) and when Delivering Final Words. With this mod, you can add a special subset of these lines that will trigger only in certain corporations, mission types and specific cities.

-- Note, this is NOT a complete file. This chunk needs to go in your regular strings file, alongside your custom agent's START and FINAL_WORDS lines, as illustrated below.

local STRINGS = include( "strings" ) -- put this at the top of your strings file since we'll be indexing this for the city names below.

BANTER = {  -- Your agent's regular mandatory start and final words go here. This is likely part of a table in your strings file.
	START = {
		"We have arrived."
	},
	FINAL_WORDS = {
		"Oh no!",
	},
	LOCATION_SPECIFIC = { -- this is a new table that exists as a BANTER sub-table! Everything for this mod goes here.
		["ko"] = { --corp short name, as used in serverdefs.MAP_LOCATIONS
			START = {
				"Not K&O again",
			},
			FINAL_WORDS = {
				"Aw crud.",
			},
		},
		["detention_centre"] = { -- mission type short name, as in serverdefs.ESCAPE_MISSION_TAGS
			START = {
				 "I hope we find somebody useful in here.",
				 "I don't like Detention Centers.", -- more lines are better, to avoid repetition.
			},
			-- we don't have a FINAL_WORDS field here, and that's fine. In all of thee, a missing or empty START or FINAL_WORDS table won't break anything.
		},
		[STRINGS.MAP_NAMES.LONDON] = { -- city-specific subset.
			START = {
				"Ugh, London.",
			},
			FINAL_WORDS = {
				"I can't believe I'm gonna die in London.",
			},
		},
	},
}		

-- You cannot have specific combinations of these checks (e.g. you cannot use this to have lines trigger only in Detention Centers that are also Sankaku).

-- City names must use the same string as in serverdefs.MAP_LOCATIONS.

-- Mission type names must use the same names as in serverdefs.ESCAPE_MISSION_TAGS, also seen here:
 "vault", "ceo_office", "security", "executive_terminals", "server_farm", "nanofab", "cyberlab", "detention_centre"

-- Custom mission names from the More Missions mod are:
"distress_call", "ea_hostage", "assassination", "ai_terminal", "weapons_expo", "mole_insertion"