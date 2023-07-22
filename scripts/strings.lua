---------------------------------------------------------------------
-- Invisible Inc. MOD.
local STRINGS = include( "strings" )
local mapPath = STRINGS.MAP_NAMES
local simdefs = include("sim/simdefs")
local T_EVENT = simdefs.TA_EVENT_TABLE.EVENTS
local T_PROB = simdefs.TA_EVENT_TABLE.PROBS

local _M =
{

-- agentIDs list:

-- 	NAME = agentID	-- just for convenience: agentID is a number or string, name is easier to use
--	DECK = 0, -- tutorial

	DECKER = 1,		-- Decker
	SHALEM = 2,		-- Shalem
	TONY = 3,		-- Xu
	BANKS = 4,		-- Banks
	INTERNATIONALE = 5,	-- Internationale
	NIKA = 6,		-- Nika
	SHARP = 7,		-- Sharp
	PRISM = 8,		-- Prism

--	monster_final = 99,	-- got sent to 100 by alpha_voice
	MONSTER = 100,		-- starting
--	central_final = 107,	-- got sent to 107 by alpha_voice
	CENTRAL = 108,		-- starting

	OLIVIA = 1000,
	DEREK = 1001,
	RUSH = 1002,
	DRACO = 1003,

	PEDLER = "mod_01_pedler",  -- MODS AGENTS
	MIST = "mod_02_mist",
	GHUFF = "mod_03_ghuff",
	N_UMI = "mod_04_n_umi",
	CARMEN = "carmen_sandiego_o",
	GOOSE = "mod_goose",
	CONWAY = "gunpoint_conway",

	TRANSISTOR_SWORD = "transistor_red", --alpha_voice handles redirecting of name/anim

	INFORMANT = "MM_mole", -- NPC from More Missions
	REFIT_DRONE = "MM_refitDroneFriend", --available with More Missions

	-- Into the Breach agents
	BETHANY = "itb_bethany",
	CAMILA = "itb_camila",
	SILICA = "itb_silica",
	GANA = "itb_gana",
	ARCHIMEDES = "itb_archimedes",
	HENRY_KWAN = "itb_henry",
	LILY_REED = "itb_lily",

	GENERIC_AGENT = "agent_generic", -- mod agents with no lines, unused

	-- guard types for guard lines
	GENERIC = "type_guard",
	GENERIC_HUNTING = "type_guard_alerted",
	CFO = "type_cfo",
	SYSADMIN = "type_sysadmin",
	SCIENTIST = "type_scientist",
	DRONE = "type_combatdrone",
	CIVILIAN_FLEE = "type_civilian_flee",
	SEEN_GOOSE = "type_seenGoose",
	SEEN_GOOSE_R = "type_seenFancyGoose",

}

local DLC_STRINGS =
{
	OPTIONS =
	{
		MOD = "Talkative Agents",
		MOD_TIP = "Agents will quip with one-liners when they complete certain actions", --"<c:FF8411>FOR AGENTS</c>\nDecker\nInternationale\nShalem 11\nBanks\nNika\nPedler",
		GUARDS = "Talkative Guards",
		GUARDS_TIP = "Enables idle enemy chatter",
		GUARDS_ALERTED = "Alerted Guard Chatter",
		GUARDS_ALERTED_TIP = "Extra customisation for Talkative Guards option: Enables enemy chatter from hunting guards. Can be disabled if you find it too distracting when the heat is on. Guards will not talk past alarm level 6, even if this is enabled.",
		FREQUENCY = "Oneliner chance multiplier",
		FREQUENCY_TIP = "Modifies how often agents and guards will speak up. Pick lower values if you feel the characters are speaking up too often.",
		FREQUENCY_STRINGS = {"0.1X","0.3X","0.5X","0.75X","1X (default)","1.5X","2X","Always trigger"},
		MESSAGETIME = "Message time",
		MESSAGETIME_TIP = "How long oneliner messages are displayed",
		MESSAGETIME_STRINGS = {"3 seconds","4 seconds","5 seconds","6 seconds"},
		GUARANTEE_TRIGGERS = "Preserve important lines",
		GUARANTEE_TRIGGERS_TIP = "Certain special lines (such as surrender and mission end lines) will trigger even if the \"chance multiplier\" setting makes other lines more infrequent.",
		BURNT_TOAST = "Talkative Easter Egg",--"Burnt toast mode",
		BURNT_TOAST_TIP = "There is a non-gameplay-affecting bug that is now a super-rare Easter Egg because enough people thought it was funny. Turn this off to disable it completely if you're not one of those people.",--"Enables inanimate object chatter. Please don't take this seriously.",

	},
	-- location-specific starter lines an final words
	LOCATION_STRINGS = {
		[1] = { -- Decker
			["ko"] = {
				START = {
					"Not this place again.",
					"<hmph> Homefield advantage. They won't know what hit 'em.",
					"Hey look, my old office! Huh. Whoever they replaced me with is an amateur.",
				},
				FINAL_WORDS = {
					"What else do you want, Kelfried? You already got my spine.",
					"I knew you assholes would catch up eventually.",
					"I'm not giving you back my fucking cerebellum. Just shoot me.",
					"Damn, forgot to pass by the mini-bar.",
				},
			},
			["ftm"] = {
				START = {
					"I'm pretty sure this place used to be a dive bar. Actually, I'm pretty sure this is the one that got me fired.",
					"All these east coast places look the same. Wait. Or are we on the west coast?",
					"FTM sure does love their grey and featureless.",
				},
			},
			["plastech"] = {
				START = {
					"Can you believe these guys? As if people didn't already hate hospitals enough.",
					"These people got rich off suckers like me. Let's send them to Hell.",
				},
			},
			["detention_centre"] = {
				START = {
					"If it's that smug ass Shalem, can we just leave him there?",
				},
			},
			["cyberlab"] = {
				START = {
					"Let's keep this short. I've been in too many freaklabs already.",
					"Gonna put me under the knife again, boss? I suppose my spine can hardly get any worse.",
					"You can put any new augs in me you like. But I reserve my right to drink their net worth in whiskey.",
				},
			},
			["sankaku"] = {
				FINAL_WORDS = {
					"Can't believe it's Skynet that gets me. The irony is thick.",
					"I've been warning people about the dangers of technology. No-one ever listens.",
				},
			},
		},

		[2] = { -- Shalem
			["detention_centre"] = {
				START = {
					"If it's that drunkard, we may be better off recruiting whichever guard seems most alert. They may be a tad uncooperative, but then again, so is he.",
				},
			},
			["ko"] = {
				START = {
					"Armoured guards? Turrets with aim as precise as mine? Finally, a challenge."
				},
				FINAL_WORDS = {
					"Would it help if I told you I had shares in K&O? This facility specifically, I mean. No? Didn't think so.",
				},
			},
			["plastech"] = {
				START = {
					"They call this medicine? Imeh, you must be rolling in your grave.",
					"Those surgical masks aren't fooling anybody. Nobody is here because they want to save lives.",
				},
			},
			["ceo_office"] = {
				START = {
					"Let's try our best not to ruin his suit, yes? At least tell me what's on the tag.",
					"Places like this take me back. But I suppose we're trying to keep our target alive this time, yes?",
				},
			},
			["assassination"] = {
				START = {
					"Finally. Something that matches my area of expertise.",
					"I was paid more for this kind of contract when I was still a freelancer.",
					"How much are we getting for this one? Maybe next time you should let me handle the pay negotiations.",
				},
				FINAL_WORDS = {
					"Keep this out of the papers. I refuse to let this tarnish my record.",
				},
			},
			[mapPath.BEIRUT] = {
				START = {
					"This place... Hm.",
					"A pity we can't see the skyline from here.",
				},
				FINAL_WORDS = {
					"Have you lost count yet?",
					"Are we really in Beirut? I didn't realise I was coming home to die.",
				},
			},
		},

		[3] = { -- Xu
			["ko"] = {
				START = {
					"Here we are. K&O may have some impressive physical resistance, but I happen to know they're not impervious to electricity.",
					"Leave the turrets to me. I still remember precisely how long each model's reboot cycle lasts.",
					"Note to self: no lingering at consoles.",
				},
				FINAL_WORDS = {
					"Well. I suppose I did keep pushing my luck, didn't I?",
					"Let's skip the \"rehabilitation\" this time, shall we? We both know neither of us will learn our lesson.",
				},
			},
			["sankaku"] = {
				START = {
					"Interesting bit of trivia: Most Sankaku drones shut down instantly from a modest electromagnetic pulse.",
					"Some of their drones have very fragile electronics. I found that out the fun way.",
					"Thank goodness I installed my subdermal tools years ago. I would hate to bet my life on our hacking capacity.",
				},
			},
			[mapPath.HONG_KONG] = {
				START = {
					"Years ago, they would have welcomed me back here. I'm not so sure that's a good thing anymore.",
					"The Hong Kong skyline is incredible this time of night. It's only too bad we can't see it.",
					"My old institute isn't far from here...",
				},
				FINAL_WORDS = {
					"They say you can never go home again. Perhaps I should have taken that in the spirit of survival tips.",
					"It wasn't supposed to end up this way. But perhaps I'm a little glad it did.",
				},
			},
		},

		[4] = { -- Banks
			["plastech"] = {
				START = {
					"The mainframe is so busy here.",
					"There's demons on the grid. No, wait. Just daemons.",
					"All the antiseptic smell... No, I don't much think I like it here.",
				},
				FINAL_WORDS = {
					"Ya already have my soul. What more do ya want? Is it blood?",
					"Ya gonna turn me into one of yer cyberconscious freaks? Or am I too broken for that already?",
				},
			},
			["ftm"] = {
				START = {
					"Ya hear that? The AMPs, the routers. They're searching. *Screaming.*",
				},
			},
			["cyberlab"] = {
				START = {
					"I'm not much keen on going under the knife again...",
					"This place brings back some bad memories.",
					"I'd rather not be putting any more metal in me...",
					"I don't really *want* another augment...",
				},
			},
			["ko"] = {
				START = {
					"I'll never forgive them for what they've done to my home.",
					"K&O. Don't let their turrets catch ya, ya'll be sorry.",
					"Stay clear of the Spec Ops. He sees *everything*.",
				},
			},
			["vault"] = {
				START = {
					"Let's clean them out. Just like the good old days!",
					"Dibs on whatever is inside that vault. I jest, I jest.",
					"I've seen a vault layout of this kind before. Doesn't that just make one warm and fuzzy...",
					"When I was wee, I could clean out ten places like this before breakfast. Before I burned out.",
				},
			},
		},

		[5] = { -- Internationale
			["ko"] = {
				START = {
					"Here we see the military arm of capital in its raw brutality.",
					"K&O are brutal. Don't let them catch you.",
					"I'm used to mainframe threats, but K&O is heavy physical security. Keep your guard up, this won't be easy.",
					"Some day we will subvert their turrets permanently.",

				},
			},
			["plastech"] = {
				START = {
					"Transcend humanity - for a price.",
					"Life-changing technology, only for the rich."
				},
			},
			["neptune"] = {
				START = {
					"So much energy wasted on maintaining these temperatures.",
					"Planet gets warmer, Neptune offices get colder."
				},
			},
			["ftm"] = {
				START = {
					"I can't see that logo without thinking of the workers in the warehouses.",
					"One of their cushy offices, far away from the workers."
				},
			},
			["sankaku"] = {
				START = {
					"This place is nothing but soulless machines. They really did make them in their own image...",
					"Sankaku is *loud*. EM signals everywhere.",
					"I'll be on the lookout for drones.",
				},
				FINAL_WORDS = {
					"Go on, have your drones do the dirty work. It won't make your hands clean.",
					"You've made these machines of death to do your slaughter for you. But you can't hide from this.",
				},
			},
			[mapPath.HAVANA] = {
				START = {
					"Hola, mi pais. I wish I could recognise you.",
					-- "Havana, mi amada. One day, I'll make them pay for what they did to you.",
					"Mi amada ciudad... One day, I'll make them pay for what they did to you.",
				},
				FINAL_WORDS = {
					"This place will never belong to you. You know that, right? This is *my* home.",
					"At least I got to see Havana one last time.",
				},
			},
		},

		[6] = { -- Nika
			["ko"] = {
				START = {
					"...\n\nK&O's guards are tough. Be careful.",
					"Leave things to me in a fight. I've dealt with military-grade security before.",
					"I know K&O well. They won't have many cameras. But their personnel are formidable.",
					"We are here. Be careful. Their turrets won't hesitate.",
				},
				FINAL_WORDS = {
					"...So you'll be the one to take me out. It had to happen eventually.",
				},
			},
			["assassination"] = {
				START = {
					"Let's hope his bodyguards are not as good as I was.",
					"A hit job. It is funny that I am now on the other side of this.",
					"Let's avoid collateral damage. One dead target is already enough chaos.",
					"Be on your guard. The target will be scared. He may behave erratically.",
				},
			},
			[mapPath.MOSCOW] = {
				START = {
					"...Hm. The city outside is beautiful. But we're not here to sightsee.",
					"I've been in this building before. But not on this floor. I'm sorry, I don't know the layout.",
				},
			},
		},

		[7] = { -- Sharp
			["plastech"] = {
				START = {
					"Hmpf. Right idea, lackluster execution. Still far too... organic.",
					"This company pamphlet boasts of Plastech's \"augmented personnel.\" What a joke.",
					"Why do they have so many synthetic trees here? It's ridiculous.",
				},
			},
			["ko"] = {
				FINAL_WORDS = {
					"Do your worst. Your pathetic turrets will never be as strong as my chassis.",
				},
			},
			["sankaku"] = {
				START = {
					"They think their drones will keep them safe... Let this be a lesson in superior design to those artless lumps of scrap.",
				},
				FINAL_WORDS = {
					"I won't be repurposed into one of those *tin cans* quietly.",
					"You think you're better than me?! I am THE FUTURE!",
				},
			},
			["cyberlab"] = {
				START = {
					"Finally! It has been far too long without new upgrades.",
					"I am ready for the next step in my journey to perfection.",
					"Leave the cyberlab to me when we find it. That state-of-the-art tech would be wasted on *you lot*.",
				},
			},
			["assassination"] = {
				START = {
					"I'm supposed to split the payout for this one? What an insult.",
					"Killing meatbags is what I'm good at. Just don't get in my way.",
					"Many meatbags think their expensive security will save them. Time to show them how wrong they are.",
				},
			},
			[mapPath.PERTH] = {
				START = {
					"Ugh, Not this place again.",
					"I never wanted to come back here.",
				},
			},
		},

		[8] = { -- Prism
			["sankaku"] = {
				FINAL_WORDS = {
					"Never thought the hatebots would *literally* be the death of me.",
				},
				START = {
					"Guards, easy. Drones... a bit beyond my talents.",
				},
			},
			["plastech"] = {
				START = {
					"Plastech is the worst of them. At least the others don't pretend to be your doctor. Or your friend.",
					"Their uniforms make it easy. To pretend I’m in a Z-list vid.",
					"Not a fan of their costumes - I mean uniforms.",
				},
			},
			["ftm"] = {
				START = {
					"Time for another round of hide and seek. We'll see if your scanning amps can keep up.",
					"Careful; they have a lot of cameras. Can't say I'm as fond of those as I used to be.",
					"Who am I kidding? I was *never* fond of cameras.",
				},
			},
			["neptune"] = {
				START = {
					"Have these people ever been bitten by a penguin? I hope so.",
					"Brrrrr. Not big on heating expenses, are they?",
					"Here we are. One of Neptune's many frozen lairs.",
					"Bad guys with ice powers. How original.",
				},
			},
		},

		[100] = { -- Monst3r  --99
			["server_farm"] = {
				START = {
					"Something tells me I already know who'll be waiting for us. Watch your back, and more importantly, your wallet.",
				},
			},
			["ko"] = {
				START = {
					"Tread lightly, few corps are as ruthless as this one.",
					"These people have quite the robust armour over here. You'll want to make sure you've brought along a toy or two.",
				},
			},
			["nanofab"] = {
				FINAL_WORDS = {
					"Really?! You're going to kill me over *that*?! I could have sold you better gear for a quarter of what that scrap cost you!",
				},
			},
			[mapPath.ISTANBUL] = {
				FINAL_WORDS = {
					"I warned you, Gladstone... I told you coming back to this city was a bad idea. This is on you.",
				},
			},
		},
		[99] = { -- Monst3r  --duplicate
			["server_farm"] = {
				START = {
					"Something tells me I already know who'll be waiting for us. Watch your back, and more importantly, your wallet.",
				},
			},
			["ko"] = {
				START = {
					"Tread lightly, few corps are as ruthless as this one.",
					"These people have quite the robust armour over here. You'll want to make sure you've brought along a toy or two.",
				},
			},
			["nanofab"] = {
				FINAL_WORDS = {
					"Really?! You're going to kill me over *that*?! I could have sold you better gear for a quarter of what that scrap cost you!",
				},
			},
			[mapPath.ISTANBUL] = {
				FINAL_WORDS = {
					"I warned you, Gladstone... I told you coming back to this city was a bad idea. This is on you.",
				},
			},
		},

		[108] = { -- Central --107
			["ending_1"] = {
				FINAL_WORDS = {
					"Four decades, countless battles, and I falter at the finish line... There might be a joke in this, but I refuse to see it.",
					"We got farther than anyone else did. And you'll never live that down.",
					"No- so close! Incognita, hold on-",
					"I refuse to let it end here. I refuse...",
				},
			},
			["detention_centre"] = {
				FINAL_WORDS = {
					"You will not take me alive. Not this time. Not again.",
					"You won't get to put me in one of those cells again. This I swear.",
				},
			},
			[mapPath.LONDON] = {
				START = {
					"This city used to be home, once... Hmpf, I'm letting my mind wander.",
					-- "<bitter chuckle> I suppose God won't be saving this queen.",
				},
				FINAL_WORDS = {
					"I suppose it ends where it all began.",
					"Not going to offer me a cup of tea before you put a bullet in my skull? So much for British Hospitality.",
				},
			},
			[mapPath.ISTANBUL] = {
				START = {
					"We've failed here before, in Istanbul. The stakes are just as high now, Operator. Don't let me down.",
					"Back in this city at last... Let's not let history repeat itself, shall we?",
				},
			},
		},

		[107] = { -- Central --duplicate
			["ending_1"] = {
				FINAL_WORDS = {
					"Four decades, countless battles, and I falter at the finish line... There might be a joke in this, but I refuse to see it.",
					"We got farther than anyone else did. And you'll never live that down.",
					"No- so close! Incognita, hold on-",
					"I refuse to let it end here. I refuse...",
				},
			},
			["detention_centre"] = {
				FINAL_WORDS = {
					"You will not take me alive. Not this time. Not again.",
					"You won't get to put me in one of those cells again. This I swear.",
				},
			},
			[mapPath.LONDON] = {
				START = {
					"This city used to be home, once... Hmpf, I'm letting my mind wander.",
					-- "<bitter chuckle> I suppose God won't be saving this queen.",
				},
				FINAL_WORDS = {
					"I suppose it ends where it all began.",
					"Not going to offer me a cup of tea before you put a bullet in my skull? So much for British Hospitality.",
				},
			},
			[mapPath.ISTANBUL] = {
				START = {
					"We've failed here before, in Istanbul. The stakes are just as high now, Operator. Don't let me down.",
					"Back in this city at last... Let's not let history repeat itself, shall we?",

				},
			},
		},

		[1000] = { -- Olivia
			[mapPath.LONDON] = {
				START = {
					"I think this place used to be the British Library. Oh, how the mighty have fallen.",
					"I didn't think I'd be coming back here... but of course this is how it happens. Damn it. Now is not the time for sentimentality.",

				},
				FINAL_WORDS = {
					"Perhaps they'll bury me in the family plot. But somehow, I doubt their generosity.",
				},
			},
		},

		[1002] = { -- Rush
			[mapPath.ISTANBUL] = {
				START = {
					"Round two, Istanbul. I hope you're ready. Because I have been for a long, long time.",
				},
				FINAL_WORDS = {
					"What are you going to do, publicly execute me again?",
				},
			},
			["cyberlab"] = {
				START = {
					"Ugh, I was constantly in and out of these places when I was a kid. Pass.",
					"My life expectancy's already measured in pennies. Getting one more augment can't hurt.",
					"Nothing like living fast and dying young. But don't get your panties in a twist, Operator - not today.",
				},
			},
		},

		[1003] = { -- Draco
			["ko"] = {
				START = {
					-- "I don't have a good feeling about these lamps.",
					"Ahh. Can you hear it? The sound of lethal laser grids sizzling in the air.",
					"K&O is such a charming corp. So many lethal toys. Accidents happen.",
					"Brutes. Easy to read.",
					"They have books here, but they never read them.",
				},
			},
			["ftm"] = {
				START = {
					"Too many boxes.",
					"I can feel their scanners... hunting. We shall see who will emerge as predator, and who as prey.",
					"They think themselves clever... watching, listening. Mind your step.",

				},
			},
			["neptune"] = {
				START = {
					"Cold air, cold minds, tepid hearts.",
					"Let's not linger. I may count myself cold-blooded, but not to *this* extent.",
					"Ouside of these walls, the merciless sea surrounds us. Perhaps I'll jot down a poem about it later.",

				},
			},
			["sankaku"] = {
				START = {
					"Too much metal here. Too little flesh.",
					"I do my best work with things that are flesh and blood.",
					"Their machinery is as inscrutable as it is ruthless.",
				},
			},
			["plastech"] = {
				START = {
					"Strange minds, like books written in code.",
				},
			},
			["ceo_office"] = {
				START = {
					"Get me five minutes alone with the target. Trust me, we'll have no unanswered questions after that.",
				},
			},
			["assassination"] = {
				START = {
					"I was never a hitman, despite pernicious rumours to the contrary. But this job has piqued my interest.",
					"A murder the boss *won't* take issue with? How novel.",
					"Let me know when you find the target. I need them.... fresh.",
					"I quite look forward to getting familiar with our target's synapses.",
				},
			},
			[mapPath.ISTANBUL] = {
				START = {
					"I'll consider this visit research for my memoir. The pride - the Istanbul - before the fall.",
				},
				FINAL_WORDS = {
					"They say a little bit of death is good for the muse. I suppose mine's only good for selling copies of that terrible holo now.",
				},
			},
		},

		["mod_02_mist"] = { -- Mist
			["plastech"] = {
				START = {
					"I haven't missed this shade of orange.",
					"Guess what? It's me, your old experiment.",
					"I hope no one recognizes me. Or I recognize them.",
				},
				FINAL_WORDS = {
					"Have fun studying my corpse.",
				},
			},
			[mapPath.REYKJAVIK] = {
				START = {
					"Home. But no time to catch up.",
					"I haven't been back here in so long.",
				},
			},
		},

		["mod_04_n_umi"] = { -- N-Umi
			["sankaku"] = {
				START = {
					"Feels familiar. But that tells me nothing.",
					"No time to search for memories.",
					"I've always thought they overdid it with the decor.",
				},
				FINAL_WORDS = {
					"Have fun studying my corpse.",
				},
			},
			["ko"] = {
				START = {
					"I don’t see the advantage of turrets over drones.",
					"More heavy-handed aesthetics. None of the corps are subtle.",
				},
			},
		},
		-- [1] = { -- template
			-- ["ko"] = {
				-- START = {
					-- "Not K&O again",
				-- },
				-- FINAL_WORDS = {
					-- "Aw crud.",
				-- },
			-- },
			-- [mapPath.LONDON] = {
				-- START = {
					-- "Ugh, London.",
				-- },
				-- FINAL_WORDS = {
					-- "Ew, London.",
				-- },
			-- },
		-- },
	},

	-- guard oneliners and banters
	GUARDS =
	{
		LINES = {

			[_M.GENERIC] = {T_PROB.p_guard_generic,{
			"< grumble > Hate these night shifts...",
			"...Did I fill the bowl before I left? I must have. \n < sigh > Two hours down, nine to go...",
			"< Yawn > ",
			"Huh? \nDamn rats.",
			"I can't believe I still have to work here...",
			"...Does this gun even work? \nBetter not glitch out on me.",
			"... \nQuiet tonight...",
			"Bored...",
			"Did I hear something? Hmm, better not be rats.",
			"...",
			"< Sigh > Just a couple more months.",
			"Hmm, I better check the cams again.",
			"Why am I here? I might as well just stand there and stare at a wall for all the good I'm doing...",
			"< grumble > ...should quit and go back to school.... < grumble >",
			"I should bring my bonsai plant from home. Liven the place up a little...",
			"That was weird. Thought I heard something. \n...Benny? Is that you?",
			"< whistles >",
			"Mmh-hmm... never gonna let you down... Hmm-hmmm... never gonna run around and... desert you...",
			"Damn noises. Stupid cheap building...",
			"Was that door open before, or closed? I can't remember...",
			"Shit. Where did I put my contacts? They were in my pocket, weren't they? Damn...",
			"Can't wait to get home... Put my feet up...",
			"I wonder what's for dinner tonight...",
			"Shift's nearly over. I could go for a coffee... or just straight to bed...",
			"< grumble > Wish I had coffee... Guess the smokes will have to do...",
			"Ten minute break soon. Those noodles better still be where I left them...", --new batch starts here
			"Hope McMurry's still open when I finish my shift...",
			"I need to take Spencer on a walk when I get back. Poor guy's been cooped up all day...",
			"I better get my paycheck before the rent is due...",
			"I wonder if there's any new holovids lately...",
			"...Did I leave the lights on back home? Dammit...",
			"I... think my oven's still on.",
			"Maybe I should just tell them I'm quitting. I'll do it today, for sure...",
			" < sigh > Sometimes I wonder if the benefits are worth it...",
			"Okay, first day... Deep breath... positive attitudes...",
			"Roger better not have stolen my lunch again. I swear, we get fridge slots for a reason...",
			"Shit. I hope I don't end up like Morgan...",
			"...Did I hear something? \nMust have been the wind...",
			"I wonder when they'll give me my real arm back.",
			"Damn cheap building... stupid thin walls...",
			"Just two more months and I can afford a new phone.",
			"All this overtime, when I should be there for dad... Paid leave can't come soon enough...",
			"Damn contract... just fire me already...",
			"This decor is awful. Do they have no sense of aesthetic?",
			"This decor isn't bad.",
			"< shudder > Damn drones... Those things creep me out.",
			"At least I'm indoors.",
			"Damn genecode nearly killed me...",
			"Hey, where'd my sandwich go?",
			"I need a coffee I.V. for this job.",
			"I wonder if there's even anyone on the other end of those cameras... Always watching...",
			"Uhhh. Why'd I even sign up for that sweep...",
			"I swear one day I'll drop dead on my shift and no one will even remember me...",
			"Where'd my pack of cigs go? I swear I'd pocketed it earlier...",
			-- "< ZAP > Arghhhh! Stupid heart monitor...",
			"Crap, where'd all the Pidgeys go?",
			"Shit. There was a Jolteon *right there*...",
			"< sniff > \n...My shirt smells... Cheap dry cleaning... All this stuff on my skin...",
			"I could use a drink right about now...",
			"Sky must be pretty right now... Wish I was outside...",
			"How fire-safe is the building? Probably shouldn't think about that...",
			"Ughh. Probably shouldn't have eaten that sandwich...",
			"My feet are killing me...",
			"Would it kill them to put a few chairs in here... Can't spend all night on my feet... Not healthy...",
			"Third day on the job. Still can't find the bathrooms on this floor...",
			"I miss the beach.",
			"I hope this place isn't bugged...",
			"Can't wait to catch up when I'm home... I swear, the leaks better not be true...",
			"I hate ketchup.",
			"Brrrr. What is it with the AC in this building?",
			"What page of 'Homemade Crafts for Dummies' was I on before?",
			"Damn Jimmy... spoiled the entire show for me... Hope he gets shot... Okay, no, that's too harsh...",
			"This uniform is so itchy...",
			"Where'd my wallet go?",
			"I wonder if they've've fixed that leaky pipe yet.",
			"Stop complaining, Jake... 'Oh, the dental in this job sucks!' At least you have dental...",
			"I swear the Financial guy smelled like eggs...",
			"I wish I'd picked the day shift instead.",
			"I ought to ask for a raise...",
			"I smell funny... Should take a bath when I get home...",
			-- "I want ice cream...",
			"At least they actually pay me at this job...",
			"I could go for a burger right now...",
			"Forgot my insulin... Ugh, this is gonna be a long shift...",
			"Damn... If they cut my pay any more, how am I gonna afford her treatment?",
			"Ugh, the swelling's worse than yesterday... Starting to think these antibiotics might be fake...",
			"I used to be a pro tennis player, but then I took I a bullet in the knee.",
			}},

			[_M.GENERIC_HUNTING] = {T_PROB.p_guard_generic_hunt,{
			"Finally, some action!",
			"Yes! I get to use my gun for once!",
			"Time to get the heart pumping!",
			"Oh, I've been waiting for a good fight!",
			"This place must be like a maze to them...",
			"No visual on the infiltrators.",
			"I lost them... Damn it!",
			"How'd they disappear that fast?!",
			"Show yourselves!",
			"They must have some kind of cloaking device...",
			"Come out or... or I'll keep searching for you!",
			"Where are you?!",
			"Give it up! It'll save us both some time!",
			"Maybe the other guys will find them...",
			"First one that pops the spies gets a bonus!",
			"Uh... Come out! We'll find you anyway!",
			"You'd better come out now! \n\n...Hello?",
			"Don't be stupid. Just give yourselves up, and we'll take you into custody...",
			"I know you're in here!",
			"I'm giving you one chance. Drop any weapons and come out slowly, now!",
			"I better get my hazard pay for this.",
			"So much for a quiet night, godammit.",
			"You better surrender now! I've got movie tickets and I do NOT want to miss it!",
			"The longer you make us search for you, the worse it's gonna be when we find you!",
			"You can't keep hiding behind office furniture forever!",
			"Are you hiding in these boxes? \n\n..No?",
			"Ugh, last night was not a good time to watch a horror holo.",
			"If I get killed here, I'll never get to tell her how I feel...",
			}},

			[_M.DRONE] = {T_PROB.p_guard_drone,{	--new!
			" *Detecting a temperature rise of 0.02 degrees Celsius.* ",
			" *Weapons: Operational.* ",
			" *Internal grime detected. Maintenance required.* ",
			" *Unverified signature detected. Probability of rats: 92%. Ignoring...* ",
			" *Charge at 86%. Status: Operational.* ",
			" *Electromagnetic interference detected. Caution advised.* ",
			" *Plasma signature detected. Caution advised.* ",
			" *Warning. Network intrusion detected.* ",
			" *Analysing surroundings. Threats: Pending.* ",
			" *Service limit passed. Maintenance recommended.* ",
			" *Software trial period expired. Please contact a representative to purchase a license.* ",
			" *Analysing surroundings. Threat level: Normal.* ",
			" *System update downloaded. Installing...* ",
			" *Update installed. Enhanced hunting protocols initiated.* ",
			" *Turn #11: Bishop to F5. Awaiting response from Security Personnel #HK254. All possible counters calculated.* ",
			" *New San-Cake OS update available. Unit reboot is required to finish installing the update.* ",

			}},

			[_M.CFO] = {T_PROB.p_guard_cfo,{
			"Hmm, the returns from the last quarter... This is good, isn't it? I'm sure it's good...",
			" Ah-ahem. Good day, sir, I appreciate you taking the time. I wanted to discuss my recent... \nNo, that's too formal, what am I thinking?",
			"These numbers are no good. < sigh > I'll have to sell my yacht at this rate...",
			"Can't believe they left me out of the message chain... better not be promoting that bastard behind my back...",
			"...Did anyone else hear that? \n...Just me, then.",
			"I need to stop wasting time and finish this. What am I doing?",
			"Five more hours, I've still got five more hours... Who needs sleep, anyway?",
			"...Meeting's in the morning. That's fine. I've got plenty of time.",
			"We'll unionise, they say... Who the hell do they think they are? It's not the 40's anymore...",
			" < mutter > Damn strike... going to put us in the red for the next two quarters if this keeps up...",
			"Just get the strike ringleaders taken out and be done with it, nice and clean, like in the old days...",
			"Could have him taken care of, but nooo, too much paperwork, they say... < mutter >",
			"...When that one guy, Shalom-13 or something, was still taking jobs... those were the days...",
			}},

			[_M.SYSADMIN] = {T_PROB.p_guard_admin,{
			"...Did I run the update? I should do that before I leave...",
			"Feels like something weird is going on tonight. Hope nobody jumps me...",
			" < Yawn > I can't believe it's so late...",
			"I'm going to ask for that promotion... Yeah, I'll do it this week, for sure...",
			"I wonder if they even appreciate the work I do...",
			"Ugh, feels like I'm being watched again. Don't think about it, don't think about it...",
			"Air's so dry here. These damn vents...",
			"< grumble > How did I get stuck on the night shift, anyway...",
			"Let's see... Cameras, check, database, check... what's that? Huh. That's a bit weird...",
			"That's a weird-looking signal. Firewall's fine, though. Must have been a false positive...",
			"Did someone tamper with the main firewall? I should be on guard, just in case...",
			"That's not right. I'd better run a diagnostic...",
			"Strange. Alarm keeps ticking up, but what tripped it? Must be a glitch...",
			"I suppose I could try turning it off and on again...",
			"I miss Tetris. I can't believe I had to put her down...",
			"I swear, I've been getting flutters every since they put the heart monitor in...",
			}},

			[_M.CIVILIAN_FLEE] = {T_PROB.p_guard_admin,{
			"Aaaaah!",
			"Don't hurt me! I'm just a civilian!",
			"Security? SECURITY!!!",
			"Help! Help!",
			"Help! Intruders!",
			"L-look, I'm unarmed! I'm not a threat to you!",
			"Easy, easy! I'll just leave, I promise!",
			"T-this is a drill, right? Hello?",
			"I'm nobody, I swear! Just let me leave!",
			"The exit... Where was the exit?!",
			}},

			[_M.SCIENTIST] = {T_PROB.p_guard_sci,{
			"Hmmm? \nThought I heard a sound...",
			"If I change the PCA parameters, maybe I can... hmm...",
			"That's strange. Where did I put those notes? They have to be here somewhere...",
			"< Yawn > I should probably call it a night soon...",
			"At this rate, maybe I can retire soon. < sigh >",
			"Can we make this work? The budget is already so tight... < sigh >",
			"What time is it? \n...I suppose that means I've missed his birthday again...",
			"...Who took down these results? This is a mess. Was it me?",
			"Hmmm, between the two peaks, is that a signal? \n...Oh, just a coffee stain...",
			"I hope it stays quiet... I'd hate to be trapped here on lockdown again.",
			"Sometimes I wonder why I took this job... No, I shouldn't think like that. I'm lucky to be here...",
			"Oh. Now this is interesting. If we run a multicomponent analysis here, then...",
			"Sometimes I wonder if we're all just living in a huge simulation... But surely that's the sleep deprivation talking...",
			"This isn't what I imagined a life in science would be like...",
			"At least I don't get harassed by the hired muscle at this job.",
			}},

			[_M.SEEN_GOOSE] = {T_PROB.p_guard_goose, {
			"Was that a goose? Can't have been. Starting to see things...",
			"That did not just happen, right?",
			"I don't even know how to report what I just saw.",
			"Damn it. The intruder protocol doesn't have a section on wildlife.",
			"I'm just gonna pretend that didn't happen.",
			"That was a goose. Am I, like... supposed to tell someone?",
			"This is just like that time a bird got trapped in the vents. Bigger bird here, but still. Not my problem.",
			"Well that was weird.",
			"Those memos finally starting to make sense...",
			"I picked the wrong day to switch to nicotine patches.",
			"I can't tell them I saw a goose. They'll put me down for psych eval for sure.",
			"It must have been some kind of secret personality test, right?",
			"This job sure does get weirder every day.",
			"That goose sure had some meat on its bones. When's the last time I had real meat?",
			"I shouldn't have skipped lunch break. That goose looked tasty.",
			"I could have sworn that goose was carrying something.",
			"So, anyone else around here seen a... goose?",
			"They told me my bird allergy wouldn't be a problem at this job.",
			"Where did that goose go?",
			"Weird, it's like it vanished into thin air.",
			"Geese are scary...",
			"Where the hell is that bird? There aren't that many places to hide.",
			"I wonder where it waddled off to.",
			"That has got to be a prank, right? Garry, are you around somewhere? This shit isn't funny. Okay, maybe slightly funny, but come on...",
			"Maybe it was some kind of covert avian drone?",
			"I think that must have been an animatronic. No living thing should be able to make noises like that.",
			"Well, that was horrible.",

			}},
				[_M.SEEN_GOOSE_R] = {T_PROB.p_guard_goose, {
			"Was that goose wearing a ribbon? That's so odd.",
			"That wasn't just a goose. It was a fancy goose. What the hell?",
			"Probably someone's escaped pet. All dressed up and fancy. Best leave it alone just in case...",
			"Maybe that was the CEO's pet? Don't want a repeat of the gazelle incident...",
			"Fanciest goose I've ever seen.",
			"It had a ribbon on it...",
			}},

		},
		-- oneliners when you attack an enemy --unused
		BEGGING = { T_PROB.p_begging, {
		"No, please!",
		"Don't-",
		"No-",
		"Please, I don't want to-",
		"Aaaagh!",
		"Wait! N-no...",
		"Wh-who are... you...",
		"Please! Stop...",

		}},

		BANTERS = {

			{"Did you get that last memo?",
			"Yeah. Bring Your Kid to Work Day is cancelled, right? Can't say I'm too upset.",
			"That's because you're a childless misanthrope. Jake was looking forward to checking this place out, you know.",
			"There's always next time.",},

			{"You okay?",
			"Just jittery. Damn coffee machine is broke.",
			"Heh, getting the shakes already? Hang in there, man.",
			"Shut up.",},

			{"I have breath mints. You want some?",
			"What are you getting at?",
			"Nevermind.",},

			{"How's Molly? You picking out names yet?",
			"Good, she's good. Um, not yet. We don't want to jinx it, you know? After last time...",
			"Yeah, uh... I'm sorry.",
			"It's fine, man...",},

			{"Hey. You wanna see a funny pic?",
			"Sure. Just keep your voice down, okay?",
			"Sorry, man. Okay, so a friend of mine sent me this parrot holofeed...",},

			{"Hey. I trained my cat to fetch yesterday, and I got it on film. Wanna see?",
			"< sigh > Send it over.",},

			{"Stop looking at your phone. We've got a job to do.",
			"Get off my back, Gary...",},

			{"You ever feel like you're being watched?",
			"You're just paranoid.",
			"If you say so...",},

			{"Place gives me the creeps, this time of night.",
			"You think it's haunted? \n...Oh shit, did you see that? That door opened by itself!",
			"You think you're so funny...",},

			{"You ever think about what we're missing out on, stuck in the rat race?",
			"No.",
			"Oh, good... Uh, me neither.",},

			{"What was that? Sounded like a, a sound of some kind.",
			"Really? Shit. Guess we won't be making it to retirement, then.",
			"I was being serious, Pete...",},

			{"I should have become a writer.",
			"That's rich.",
			"You'll see. I'll write a book one day. \"A Security Guard's Life\". It'll be a hit.",
			"Can't wait.",},

			{"Shit, I'm hungry...",
			"I think there's still some year-old pudding left in the office freezer.",
			"On second thought...",},

			{"Hey, you okay? You're looking a little off, man.",
			"< cough > It's fine. Not like I can take a sick day, anyway.",
			"Okay, if you say so. Just don't get it on me.",},

			{"Achoo!",
			"Bless you.",
			"Thanks.",},

			{"I hate these patrols.",
			"Couldn't imagine why.",
			"I wonder what upper management is thinking sometimes. Would you believe I had to stare at a wall yesterday for five hours straight?",
			"Less whining, more patrolling.",},

			{"Were you smoking just now?",
			"What? That's none of your business.",
			"Smoking kills, you know. It's the number two cause of premature mortality.",
			"Not for us, it's not...",},

			{"Who were you on the phone with just now?",
			"< sigh > The police.",
			"Shit, really?",
			"It's my sixteen-year-old. It's fine. I'll just have to bail her out in the morning...",},

			{"I think I heard something. In the vents.",
			"In the vents? They're too small to climb through. You've been watching too many holos, man.",
			"Could be an pigeon. Or a genetically-engineered assassin who can dislocate his shoulders to fit through.",
			"...Like I said, too many holos.",},

			{"Do you ever think about how there's no fire escapes anywhere?",
			"I am now, thanks.",
			"What happens if there's a fire?",
			"Relax. You'll die of smoke inhalation long before the fire gets to you.",
			"Uh... thanks.",},

			{"Shit! My wedding band! Where is it?!",
			"Calm down. It probably just fell off somewhere. Roombas must have picked it up by now.",
			"What would they do with it?",
			"Toss it in the incinerator, probably.",
			"Well that doesn't help!",},

			{"Hell yeah! New season of GAT came out today.",
			"What was that? Global Action Team?",
			"Yeah, there's a guy in a hazmat suit and a chick with dolphins and a-",
			"That's kid stuff, man. Next thing I know, you'll be patrolling with a toy gun.",
			"It's a really good show, Tim!",},

			{"I hope my heart monitor doesn't act up again.",
			"So what? Just a false alarm. Wasn't your fault.",
			"But what if it, like, stops my heart or something?",
			"Pretty sure it can't. But just to be safe, dibs on your gaming rig.",},

			{"Why do we even have these passcards?",
			"Huh?",
			"Like, why can't they just put it in our chips?",
			"Because they're cheap, that's why.",},

			{"You sure these drone things can't hear us? Damn spyware is everywhere these days.",
			"If you want to find out, try telling them what you think of middle management.",
			"I'd rather not.",},

			{"I tell you, man, the benefits aren't worth it.",
			"What benefits?",
			"Exactly.",},

			{"I've always wanted to be a security guard.",
			"You're kidding.",
			"Uh, yeah. But my therapist said to try this positive attitude thing, so..."},

			{"NO!",
			"What?! What is it?!",
			"My lucky rabbit's foot! I left it at home!",
			"Geez. You can't be serious.",
			"I just hope nothing bad happens today..."},

			{"I've got some chips. You want some?",
			"We're still on duty.",
			"I won't report it if you don't.",
			"Fair enough..."},

			{"I actually like the night shift. It's calm, quiet...",
			"You're new, aren't you?",
			"What? I'm just saying, it's nice and quiet!",
			"Yeah, for now. Eyes up front, okay?"},

			{"You want to go for a coffee later? I hear HR's got a new coffee machine.",
			"The one that has real coffee beans and costs more than my annual salary? That's where you wanna go?",
			"Well, if you could avoid breaking it this time..."},

			{"Why do we have keycards?",
			"What?",
			"I mean, what's the point of carrying them if we never use them?",
			"Shut up! You could get us into a lot of trouble, talking like that!"},

			{"You know what? I wish someone *would* try to break in here.",
			"Yeah, it's about our only chance of getting promotions.",
			"Plus, holographic targets get boring after a while.",
			"You're joking. Right?",},

			{"You haven't seen me with my new augments yet, have you?",
			"Sweet. But you know they'll take them back if you leave, right?",
			"Not gonna happen. Why would I want to leave?",
			"...Are you sure installing augments is all they did?",},

			{" < This was not just data, or if it was, it was data as she had never experienced it... > ",
			"I heard that. You're listening to that old vampire book, aren't you?",
			"...So what if I am?",
			"Just don't let them catch you.",},

			{"Did you see the vacuum drone stuck under the weird statue in the break room?",
			"Yeah, I took a vid to show anyone who's worried about AI taking over.",
			"Unless the drone is an advanced AI in disguise, and the statue is, um...",
			"Hey, if you come up with a good conspiracy theory, make a vid about it.",},

			{"You ever wondered what it would be like to be a completely disembodied AI?",
			"If they're paying you to try to recruit me for some project, just say so.",
			"Chill out. I was just thinking.",
			"They don't pay us to think.",},

			{"You spend too much time on your phone.",
			"It's work. I'm posting about how much I like working here.",
			"Oh, right. How much have you earned so far, three millicredits?",
			"That's confidential information.",},

			{"Did you see that new memo? It's weird.",
			"Yeah, how likely are we to see a goose in here, anyway?",
			"It's weirder that it implies there might be some geese with security clearances.",
			"I think that was just poor wording.",
			"Whatever.",},

			-- continuation of oneliner by Hek --
			{"Hope this place isn't bugged.",
			"Why would you even ask that?",
			"You mean it isn't?",
			"No. I mean why the hell would you think it wouldn't be?",},

			{"Can't wait to get off this shift. Janice and I barely see each other these days.",
			"How come? You work in the same building.",
			"She got promoted to security guard. You know how the Child Care Act of '62 prohibits putting women to work on the night shift?",
			"Uh, yeah. I don't live under a rock. She doesn't have a kid, though?",
			"I guess the Child Care Act of '62 doesn't care about that."},

			{"I'm pretty sure this wall is asbestos.",
			"Take it up with the union.",
			"Very funny, Chris."},

			{"You hear what happened to Jensen? He got taken out.",
			"Keep your voice down. I heard it was overdose. Natural.",
			"After he spent two years trying to sue them over the chemical exposure? Yeah, that's totally a coincidence.",
			"Well, if anyone asks, we didn't know him. Got it?",
			"I just wish they'd actually fix the chemical exposure. Damn water cooler still tastes funny."},

			{"I heard about your fish. I'm sorry.",
			"Don't mess with me, Jake. She was a good fish.",
			"I'm not messing with you. Even small pets are family. I get it.",
			"...Thanks. Yeah, it's... I'll be okay."},

			{"Did you really spend half your shift facing the wall last time?",
			"Randomly assigned route. Can't complain, though.",
			"You're kidding, right? You can't see shit when you face the wall.",
			"That's the point. Plausible deniability.",
			},

			{"I brought my gerbil to work with me today. Want to see?",
			"You've got a pet on you?! Are you nuts?",
			"Relax, he's just sleeping in my pocket, see? He's not bothering anyone, and he helps me stay calm.",
			"He is kinda cute...",},

			{"Thought I heard a weird sound just now. Must have been the wind...",
			"We're indoors, Jason."},

			{"Shall we gather for whiskey and cigars tonight?", -- :^)
			"Indeed, I believe so."},

			{"How old did you say your sister was?",
			"Blow off, choffer."},

			{"Think you'll get your own squad after what happened last night?",
			"Never doubt it."},

			--and some fanfic references...
			{"Mom wants to have Milo put to sleep. Says we can't spare the cash for the vet bills...",
			"Shit, I'm sorry. Is Milo that mangy thing you smuggled back from Belgrade in your backpack?",
			"I-I was never in Belgrade, Tom.",
			"Right. Officially. But come on, we all know..."},

			{"Boss wants me to write up another threat assessment report for him. Due end of my shift. So I have to write it during my patrol somehow.",
			"Why doesn't he do it himself?",
			"Well, uh-",
			"Just kidding. Sucks to be you, man. Sucks to be you.",},

		},

		BANTERS_HUNTING = {
			{"Careful, these people are armed!",
			"With what?",
			"Worst case scenario, a flurry gun.",
			"Dear god...",},

			{"You check this way, I'll look over here.",
			"Hey! Who says you get to give the orders?",
			"You want to get whacked by these intruders?",
			" < Grumble > ",},

			{"Starting to wish you'd bought that life insurance, huh?",
			"Shut up."},

			{"Command says we're clear to use all means necessary. Let's go.",
			"Good hunting.",
			"You too, Jack."},

			-- {"You're saying you can't find them?!",
			-- "Yep.",
			-- "And they're still somewhere on this floor?",
			-- "Yep!",
			-- "And that we might get shot any second?!",
			-- "YEP.",
			-- "\n..."},

			-- {"The enemy is here!",
			-- "I know that!",
			-- "Then why aren't you searching for them?",
			-- "I am!",
			-- "Then search harder!",},

			{"Hey, did you hear that?!",
			"That's just the AC! Dammit, Tony, I'm jumpy enough as it is!"},

			{"Maybe they've already left the building.",
			"Don't be stupid. They're still here!",
			"How can you be sure?",
			"They're listening to us right now. I can tell!",
			"I always get stationed with the weird ones...",},

			{"Come on, look alive over here! We've got intruders on site!",
			"No need to yell, I already know that...",},

			{"They're still in the building! Look sharp!",
			"You don't have to tell me twice!",},

			{"Here, kitty, kitty, kitty...",
			"Stop messing around. They're intruders, not cats!",
			"Can't hurt to try.",},

			{"Where are you? Come out!",
			"Be quiet! You're giving away our position!",
			"Well, so are you!",},

			{"Trust nothing. Check every corner.",
			"I'm checking!",
			"Did you check behind the couch?",
			"Well, uh...",},

			{"Be sure to check the lamps. These bastards keep thinking those things are cover.",
			"I suppose it depends on the lamp?",
			"Now is not the time."},

			{"Remember your training. Check the sightlines.",
			"Who put you in charge?",
			"I've worked this job ten years and I'm not dead yet.",},

			{"Okay, we need to coordinate our search. I go this way, you go that way, got it?",
			"I'll holler if I find anything.",},

			{"Remember, 50 cred bonus if you catch them. 200 cred if they're still alive.",
			"Let's look together and split the cash?",
			"Works for me."},

			{"Don't let them get the drop on you. They shoot to kill.",
			"I didn't make it through deployment just to be gunned down by a common thief.",
			"They're uncommon thieves. Be careful."},

			{"Look everywhere. Think they couldn't hide under that coffee table? Think again. These bastards are slick.",
			"That coffee table's five inches off the ground...",
			"Look. Everywhere."},

			{"Keep searching. They're not as smart as you think. I once caught a guy trying to hide behind a flagpole. We'll find them.",
			"Behind a flagpole, really?",
			"It was a really flimsy one, too."},
		},
	},

	HOSTAGEQUIPS = {

		[_M.DRACO] = {"The night, honed into deadly purpose.","Your saviour.","A shadow. Follow me... into the darkness."},
		[_M.SHALEM] = {"I could tell you, but then I'd have to kill you.","Lucky for you, a professional."},
		[_M.RUSH] = {"The answer to your prayers.","Less talking, more running.","Looks like you're out of shape. Ugh, this is gonna suck."},
		[_M.DEREK] = {"Don't look at me, I'm just here for the sweet, sweet cash.",},
		[_M.OLIVIA] = {"No time to explain. Follow my lead."},
		[_M.INTERNATIONALE] = {"We're here to help. Let's get you out of here."},
		[_M.BANKS] = {"Come to cut the knots.","Ye can trust me, I'm a thief."},
		[_M.NIKA] = {"Quiet. Come with me.","...","You will listen to me if you want to get out alive."},
		[_M.CENTRAL] = {"Right now, we're your best and only chance.","It's best for you if you don't find out.","That's classified."},
		[_M.MONSTER] = {"Come with me if you want to live, is how I believe the saying goes...","Good question. By all rights, I shouldn't even be here!","Do look me up later if you're looking for new employment."},
		[_M.SHARP] = {"This sack of pus isn't worth my time.","Silence, human."},
		[_M.DECKER] = {"Well, pal, we'd be the cavalry.","Keep it quiet, and I'll buy you a drink later.","Can't tell you. Follow me, and keep that yapper shut."},
		[_M.TONY] = {"Who is anyone, really?","A fascinating question. Let's table it for later."},
		[_M.PRISM] = {"Right now, we're the good guys.","Just a security guard. \n\nI'm kiding. Let's go.","Really? You don't recognise me?"},
		[_M.GOOSE] = {" < HONK. > "," < HONK HONK HONK! > ",},
		[_M.CARMEN] = {"I've come to get you out of here!","Take it easy. You can call me Red.","Some call me the Scarlet Shadow, but that's a bit of a mouthful. Coming?","Scarlet Shadow. Crimson Thief. Carmen Sandiego. Take your pick, friend."},
		[_M.CONWAY] = {"Opening conveniently flimsy cuffs is my specialty.","I'm just a guy with a pair of pants.","You want my card?"},

	},

	AGENT_ONELINERS = {
-------------------	
	-- Decker
	[_M.DECKER] = {
		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Yeah, yeah. I hear you."," < sigh > Contact confirmed.","You better have a plan.","Comms are up. We're in.","This better not go like that job in Dubai.","Here we go.","I need a sip for good luck. Don't tell the boss, will ya?", " < grunt > Well, here we go.","Damn. Brings back memories.","Let's get this over with."}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Here we go.","Taking aim.","Hands are still steady. That's gotta count for something, right?"}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Night night.","Bed time.","Lights out.","Sweet dreams.","He's about to catch some z's."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Dig fast!","Chump.","Like a sack of potatoes.","Not much of a fight.","Might put some ice on that, pal.","Looks like the old dog still knows a few tricks."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Got it covered.","Like old times.",}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

	--	[T_PROB.EVENT_HIT_MELEE] = 		{1,{"chump"}},
	--	[T_PROB.EVENT_MISS_GUN] = 		{1,{"Slippery sucker"}},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"You... have... to..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"My hero.","I'm getting too old for this.","Doesn't mean I owe you squat."}},

		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Uploading virus.","Hmpf. Not as secure as they used to be."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Jackpot.","That's better."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Crud.","< sigh >","Oh, great."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Just a quick look.","Scouting the way."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"This one's pinned.","Do yourself a favor and stay down, pal.","Not much of a talker, are you."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Still human.","Flood myself with metal.","The future will drown us all.","Another one? Starting to lose count."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Running silent.","In the old days, they'd have burned me as a witch.","Right into thin air.","Whoosh..","And gone.","This thing's more useful than most of the people I work with."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Typical, really.","Think you can pack it this time?","< Sigh >","Quiet. Job ain't over.","Heads up, we're still on the clock.","Don't mention it.","You need to pick up the slack."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Pack your bags, pal.","You coming, or what?","Looks like today's your lucky day."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"We got away this time.","Let's get the hell out of here.","I'm gonna need a drink after this shit.","Why don't it ever go smooth?","...","Well, dammit.","I've seen worse.",}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Finally. I need a drink.","Not too bad, I suppose.","Could have gone worse.","Ha. Cakewalk.","Time for a drink.","Let's leave.","Where's my flask?","Godspeed.",}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"Any chance we could split the cleanup on that?","Ugh. I need a drink.","Just like old times, eh...","These men were poorly trained. Not our fault.","Back when I was on the job this mess would have caused an uproar.","They were all too slow.",}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Poor sod.","Should have packed a spare bullet.","So much for that.","At my old job we used to call that \"high employee turnover\".","Corps ain't too friendly to intruders these days.","Stay put. We'll be back.","Let's hope that their neural probes are worse at digging up dirt than I remember.","...I'm sorry.",}},
		[T_EVENT.OW_INTERVENTION] =	 {T_PROB.p_savefromow,{"< Sigh >","Don't mention it.","Buy me a drink later.","Easy on the trigger there, pal.","Nobody holds my team at gunpoint. Except me, maybe.","Don't make me bail you out again.","Staring down the barrel, huh? Trust  me, we've all been there.","You ever heard about stealth, pal?","The trick is to not let them see you."}},
		[T_EVENT.SAVED_FROM_OW] =	 {T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"I'll raise a glass to ya. Soon as I get one.","Aw, hell.","So much for that."," < sigh > "}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Mind the coat, it's vintage."," < sigh > Alright, you win for now.","If this keeps me from being riddled full of holes, so be."}},
	},

	-- Xu
	[_M.TONY] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Contact established, Operator.","I hear you, Operator.","You're coming in clear.", "Hmm? Ah yes. So what's the first move?","You have my attention. Use it well.","Let us get to it!","I can't wait to begin.","This should be interesting.","I am ready.","Active.","How are you, Operator?"}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Aim and fire... simple enough...","Hm, I don't suppose he'll be getting back up...","That ought to clear the air a bit.","An unfortunate necessity."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Excellent.","He's down for the count.","...Did I get him? Oh, there we go.","I do believe I'm getting the hang of this.","Yes!"}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"...And stay down!","Nothing like a little power surge.","These things pack quite the punch.","A-ha! Triumph.","< huff > Got him!"}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Weapon primed.","Monitoring the area.","Leave this to me.","Rest assured, I will handle it."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"I think I've been...","Oh, well, that's..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"That was unpleasant.","Much appreciated.","Ngh. Is that my blood?"}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"I don't suppose I could get five minutes with this? ...No?","Let's see what you're made of.","I wish I could take my time with this.","There's a certain elegance to their systems.","Hmpf. Not much of a challenge...","They really make this too easy.","This takes me back."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"What do we have here?","Let's see what's inside.","How curious...","Now that's interesting.","This will come in handy.","Would you look at that?"}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	{T_PROB.p_loot,{"Very nice. May I keep this? No?","These electronics are quite valuable.","I have a project this could work with!"," < sigh > I suppose Central will insist on selling this."}},

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Could be a problem.","Not ideal.","Er. Hello..."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Information is key.","Let's not charge in blindly.","Scouting area.","Surveying the room."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Enemy subdued.","This one won't be going anywhere.","Target pinned.","I hope you're comfortable.","I have it under control."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"I cannot wait to use this.","This seems promising.","I've always wanted to try that.","Still more human than some people I could name.","Efficiency improved.","I'll tinker around with this later."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Too bad this won't last for long.","That's some incredible tech.","I could get used to this.","The tricky part is not tripping over yourself.","It's a shame I didn't have this years ago.","You know, Clark's third law states that... Alright, maybe now is not the time.","And for my next trick..."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Good as new.","Are you alright?","Quiet! We're still in the field.","Welcome back.","So how was the light at the end of the tunnel?"}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		{0.5,{"This better not become a habit.","Whatever gives us the edge on them."}},
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"No time for pleasantries, I'm afraid.","Are you ready? Let's not linger.","I'm sure you'll be happier outside. Follow me.","Let's put this unpleasant place behind us.","You look like you could use some fresh air."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"That probably could have gone better.","That was, ah, tense.","An uncomfortably close call.","That was eventful."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"This went well.","Excellent. We did quite well, don't you think?","Central should be pleased.","I'm a bit winded. I'm looking forward to a nice long break before the next job.","Finally. Now I can get back to tinkering with my equipment."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"Quite the body count there...","Perhaps the white shirt was a mistake today.","That turned out bloody.","It's not that I sympathise with the enemy, but... was all that really necessary?","Either us or them, I suppose."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Ah, I wish it hadn't gone like this...","Pity we weren't able to make it out with everyone we came in with.","That's unfortunate.","On the bright side, I hear detention cells are very comfortable these days."}},
		[T_EVENT.SET_SHOCKTRAP] =		{T_PROB.p_setshocktrap, {"This should be interesting.","Never gets old.","Someone's in for a... shock.","This reminds me of simpler times.","Let's amp up the current situation.","A little surprise.","They ought to place more failsafes on their doors.","Now I just need to not forget that it's there.",}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"You're welcome!","Not so fast.","Gotcha.","There. I trust you'd do the same for me, if it comes to that."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"Er, thank you.","I appreciate that."}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"I fear our odds may have just plummeted.","Could this have been prevented? No, I mustn't think of that now."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Easy... Let's not do anything rash here.","Alright, alright, I'm cooperating.","Well, there goes my dignity. I surrender.","Operator, I hope you know what you're doing..."}},
	},


	-- Shalem
	[_M.SHALEM] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Operator. Always a pleasure.","What do you need, beautiful?","You're coming in clear.","Go ahead.","Let's make this one clean.","Hm?","What now?"}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Lined up.","In sights.","Gentle squeeze...","End of the line.","Keeping it clean."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"That was a half-measure.","He's out. For now.","That won't keep him down forever.","Not as permanent as I'd like.","Hmpf."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Boring conversation anyway.","That's one less.","I think he sprained something.","He'll be fine. The floor broke his fall."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Setting up.","Doing what I do.","Let them come.","Here we go.","I'm ready."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

	--	[T_PROB.EVENT_MISS_GUN] = 		{0.5,{"Guess that was a warning shot?","I.. uh.. missed."}},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"I'm coming... Rita...","About... time...","Not gonna just..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Just in time.","Hmpf...","...\nThanks."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Uploading virus.","You're wasting me on this?.","A monkey could do this.","The device is ours now.","Finally. What I've always trained for.","Give me a trigger, not a button."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"All boys need toys.","Not bad.","I get a cut of this, right?"}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"...","Mnh. Complication."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"No surprises.","Searching for hostiles.","Scouting ahead.","Active recon."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Shouldn't I just... shoot him?","Taking prisoners isn't really my bag.","...So how's your pension plan?","This could get dull.","Target subdued.","I've got him pinned."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"So long as it's useful.","This better work.","This better not slow me down.","More metal or less, it doesn't change anything.","Whatever it takes to win."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Hidden.","Seems a bit like cheating, doesn't it?","Cloaked.","Better not get too used to this."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Try to stay on your feet this time.","Eyes sharp now.","We're not done here yet.","By all means, take your time...","Don't take it personally.","Get up. We need to move."}},
		[T_EVENT.WAKE_OTHER] =			nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil, --{1,{"Try this."}}, -- sorry had no better ideas
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil, --{1,{"I... uh..."}}, -- sorry had no better ideas
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Oh, you. What was your name again?","Try to make yourself useful...","We're breaking you out. Come along."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Hmph. Well, we're still standing. That makes it a successful job in my books.","That was a mess and a half.","So much for putting on our best show."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Almost time for a G and T, don't you think?","This is what happens when everyone pulls their weight.","Not bad. We may actually survive at this rate."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"My suit will need some dry cleaning after this.","...Is that blood? This better come off...","Reminds me of some rougher jobs.","Rather sloppy. In my day, people valued finesse."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Ruthless, hm? I can live with that.","Well. Suppose we're a bit more short-handed now.","I suppose the jet was starting to get crowded, anyway."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"Don't take it personally.","Just doing my job...","Too slow.","Rescues cost extra, just so you know.","So much for us not getting spotted.","Next time, I might not be there to save your skin."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"There are worse ways to go.","Part of the job."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Hmpf. You've got me. For now.","Take it slow. I'm putting the gun down, see?","I better be paid double for this indignity."}},
	},

	-- Banks
	[_M.BANKS] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Where to?","Hey there, other voice in my head.","Hope this one goes smooth.","Alright then. Give us the stuff.","Tell us what's what.","Hmm? Oh right, right, the mission.","That's grand, I read ya. At least I assume that's what's going on.","I've done a lot of jobs. Don't make this one my last, okay?","Make it good.","What do ye got for me?","Dia Duit.","Hello, Operator!","What will it be?"}},
		[T_EVENT.ATTACK_GUN] = 		{0.3,{"Guns, I hate these things.","Do we really have to do this?","Sometimes I miss the solo gigs."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"I could get used to this.","I'd leave ye an asprin if I had one.","Believe me, buddy, I'm doing ye a favor.","He's down.","I've got him.","He's tranquilized.","He's still awake? Oof. No, there we go.","Yup. He's gonna have a headache on him.",}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Zappy would have been nice right now.","Facing a lot of resistance right now.","Down he goes!","Aaagh... everything's under control.","Sparkly.","How about ye rest for a while?","Take a little break, okay?","Shhhhhh."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Holding here.","Watching the way.","I'm on it.","I'm ready, I'm ready.","Okay..."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"I guess... I tried... one too many.","Doesn't... hurt... at all...","Had... a good run","It'll... be okay..."}},
	--	[T_PROB.EVENT_MISS_GUN] = 		{1,{"Ok, ok, I'm learning","Dammit! Harder than it looks"}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"I owe ye for that one.","Not a dream, then...","How many lives left?","Owww.","Mmm, guava.","Aaugh! I'm up, I'm up!"}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Just gotta bypass the... Done!","Easy peasy.","I wrote this code in Haiku.","CPU, I own you.","This console reeks of coffee.","Knock knock little machine.","Ooh, this still has Minesweeper."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Who wants stuff?.","Come to mamma.","Do I really have to share this?","I love this part.","Savage!","Oh yeah, here we go.","Sweet.","Got the booty on me!","Not too shabby."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Uh oh.","Uh, this isn't what it looks like?","...Hi there..."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"I see them, but they don't see me.","Swift and silent.","I know what lies in wait.","I see the way ahead.","Crap, they saw me- Ok nevermind, I'm grand.","Scouting ahead.","Eyes sharp.",}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Just stay there, buddy.","It will go better for ya if you don't move.","I could sing ya a lullaby while we're here.","Just stay down, will ya?"}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Will this fix me?","Another one.","I can hear it inside of me.","This will keep me company.","We're all just automatons in the end.","Two lefts can make a wrong."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Invisible, intangible, I have become air.","Into nothing I return.","Light as a feather, I am.","...Am I a ghost?","I can't see my- Oh. I forgot.","A puca now roams these halls.","I vanish."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Shh. Just let them sew you up.","Easy there, buddy.","Ya grand?","Now then, that's a lot of blood.","I'm sure ya'll be fine!","Ya'd do the same for me, right?","Don't worry, I've got ya.","D'ya have pain in ya at all?","Don't worry. The achin' is how ya know it worked."}},
		[T_EVENT.WAKE_OTHER] =				nil,

		[T_EVENT.PARALYZER] =		{1,{"Sleep well.","Shhhh.","Don't worry, ya'll miss all the bad parts.","Ya won't remember this at all.","No one has to get hurt.","Safest place for ya to be is nowhere at all."}},
		[T_EVENT.STIM_SELF] =		{0.5,{"This should help.","Already feeling things clear up...","Wow, I can focus! That's grand!","Is this what being normal feels like?","It's like the fog in my head just... poofed.","Ok, ok, so what do I do next?"}},
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Let's hit the road!","Doesn't look too comfy.","Come on!","The sky outside is beautiful. Come on, I'll show ya."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Time to go!","Let's not stick around.","Oof, that was a tough one.","We made a complete haymes o' that.","One little mess-up means nothing.","There's always a second chance.","At least we're not dead - right?",}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Piece of cake.","I think that went grand!","We done a savage job of that.","I can't wait to count the credits on us.","That went fierce well.","Well done, everyone!","We've a fine job done.","Bang on.",}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"I kind of hoped it wouldn't be like... that.","Mmm. This was a bad day to be keeping lucid, was it...","Maybe we could just knock some of them out next time?","Ugh, that was awful.","We shouldn't have let them get in the way.","I would have let them live...","We made right bags o' this.",
}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Do we have to? Can't we...","We'll find you again, I promise.","Sad day...","I don't like this...","This is why I worked alone, back in the day. Fewer people to lose.","I wish we could've done something.","This... shouldn't have happened.",}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"I've got him. You okay?","Take cover! Okay, nevermind, he's dealt with.","Let's hope nobody heard that.","I've got your back.","There. Now is a good time to scram.","And he thought he had you pinned down!"}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"I'll keep an ear on the daemons. Maybe I'll hear yours one day.","Oh no...","Until we meet again."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Well, lookit that. Ya got me.","Fine, alright, just don't shoot!","Easy on the trigger finger there.","Alright, I'll come quietly."}},
	},

	-- Internationale
	[_M.INTERNATIONALE] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"You're coming in clear.","On the team.","Read you loud and clear, Operator.","I read you.","Coming in clear.","Signal's good on my end. You read me?","Yes, Operator?","I am ready."}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"I do not like this.","This is the only way.","Count to three, pull the trigger...","Deep breath..."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Delivering toxin.","Clearing things up.","Let's open the way.","Taking him down."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Too bad we can't talk this out.","Sorry, friend.","This will probably sting.","Libertad!","El enemigo está bajo control.","Awaiting further instructions."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Ok, focused in.","I will take care of it.","I've got it.","Everything's under control.","Keeping a look out."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

	--	[T_PROB.EVENT_MISS_GUN] = 		{1,{"Target is obscured!","Need a better angle"}},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"I can't feel my... ","No, I...","Damn... you...","For... the team..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"That really cleared things up.","Thank you. I mean it.","Back in the fray.","That was too close.","For a moment there, I thought...","I knew I could count on you"}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"I'm on it.","Installing virus.","Let's see what their security is like.","No obstacles encountered.","Accessing their system."}},
		[T_EVENT.WIRELESS_SCAN] = 		{T_PROB.p_scan,{"Scanning area.","Pinging the mainframe.","Homing in on the signal.","A lot of noise around us.","Detecting.","Let's see...","I'm searching.","Checking for mainframe objects."}}, -- rather test
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Busted open.","Secrets revealed.","Time to redistribute.","New assets acquired.","New capital under our control."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Damn it, I'm seen!","Cover is blown."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Scouting ahead.","I know what's coming.","Area sighted.","I have eyes on this."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"I shouldn't sit here long.","I suppose this is more merciful.","Too bad you're unconscious. There are things I could tell you about your rights as a worker.","I'm just gonna leave this leaflet in your pocket, okay?"}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Whatever it takes to get the job done.","More than the sum of my parts.","I can use this.","Hopefully, this won't make me start drinking."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Time for stealth.","The subtle approach.","I can see why Brian likes this trick so much","Cloaked and ready.","Cloak active."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Take it easy.","Easy now.","Next time, be careful.","All good?","It'll be okay.","Let's get you out of here","We don't have time. Can you walk?","We're not safe yet. Focus.","Don't worry, they'll pay for this.","You okay? You just need to make it to the exit."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"We're getting you out of here.","No pressure, but we need to leave. Now."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"It's not always easy. But we made it out, this time.","This is but a bump in our road to a better world.",
"We've made mistakes. We'll fix that."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Here's to a job well done.","Even Gladstone shouldn't find fault with this.","We've all earned our rest. Let's get back.","This was a success.","Mission accomplished.",}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{".........","This was so unnecessary.","We had no reason to kill so many.","Someday, this will catch up to us.","What horrors have we committed...","...","This is *not* why I signed up.","They didn't deserve to die.","They were at the wrong place, at the wrong time.",}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Just for the record, I don't like this.","We don't leave our own behind... no matter who it is.","We should have tried to...","This is terrible.","I shouldn't have let this happen..."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"This is why we're a team.","I've got you covered.","Keep your head down. I might not be there next time.","Did he get you? No? Good."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"I can't believe we let this happen...","This death will not be in vain while I can still fight.","The forces of capital are heartless, but will not win."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Captivity doesn't frighten me.","I surrender.","Alright. I'm getting on the floor, just like you said. See?"}},
	},

	-- Nika
	[_M.NIKA] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Will get it done.","Yes?","I read you.","I'm waiting.","Receiving. Do you read?","I'm here, Operator.","Operator.","Uplink confirmed.","Awaiting instruction.","Signal is good. Let's go.","Hm?"}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"With lethal force.","Terminating.","Taking action.","...\nHe's down.","Enemy down.","Target down.","Threat eliminated.","Neutralized.","...","Hm.","......"}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Tranquing.","Knocking out the target.","...","...","Neutralizing target"}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"...","These guards are not good enough.","He is down.","Ready for the next target.","Hah!","Who's next?","Hm. Gets the blood flowing."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Covering this zone.","Will get it done.","Standing guard.","Ready to intercept."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

	--	[T_PROB.EVENT_MISS_GUN] = 		{1,{"Zey have cover"}},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Do svidanya...","Net...","I'll...","Nghhhhh...","Operator, make sure the team is..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Spasibo.","They cannot stop me.","Thank you.","... \nI'm up."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Virus installed.","Device hacked.","...","...\n I have the device."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"I have captured something.","Supplies.","..."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"..."}},
		[T_EVENT.PEEK] = 			nil,

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"I will break you.","Stay down.","I have him.","He will not move, trust me.","Target subdued."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Hmm.","Good.","...","Stronger now."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"...","I am cloaked.","Concealment active.","Very well. If it is stealth you need."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Get up.","Ne za shto.","...","...Good?","Move.","You're awake. Good.","Stay behind me.","...\nStay close to me if you cannot handle yourself.","We have work to do. Don't slow me down again.","You need to be better."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"You can still walk. Good.","I'm here to free you.","Follow me.","You need to find your strength. Quickly."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Everyone who's still alive is out. That's what matters.","...","We need to train harder to match them.","They're strong. We must be stronger."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Job went well.","...\nGood."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"Reminds me of my old job. Messy."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"...","I consider this a failure.","...\n...We should have done better."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"...","He hesitated. His mistake.","I won't allow this.","I have you covered. Move.","Find a better hiding spot. Now.","... \nKeep moving.","Don't let them see you again."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"...","Goodbye.","They will regret this.","I.. failed."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"...","......","...\n\nDo your worst.","I'm not afraid of you."}},
	},

	-- Sharp
	[_M.SHARP] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Ugh, what do you want?","I already know what to do.","Don't waste my time.","I can handle this.","You think you can tell me what to do?","I read you. But we're doing this my way.","...","... \nWhat?","What was that? I can't hear you. Guess I'll have to improvise.","I will not be bossed around by the likes of you.",}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Nowhere to run, meatbag.","This takes me back.","Perfect execution.","You should thank me.","They always drop too quickly.","Perish."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Pathetic.","Exploiting systemic vulnerabilities...","Foiled by a chemical.","That was too easy.","See, and that's why organic blood is a bad idea.",}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Hardly an opponent.","It didn't stand a chance.","No match for me.","Frail excuse for an organic.","Obsolete piece of meat.","Heh.","Are you watching, Operator?","This is how it's done."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Armed and ready.","They won't know what hit them.","Prepared for perfection.","Watch and learn.","Time to make this look good."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"I... refuse...!","I am NOT... this... fragile...","Missed... me...","No, NO! I'm not...","Like that's gonna... stop me..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"I didn't need your help.","I was just resting.","Ugh. Don't look at me.","Don't touch me.","Hands off, I'm fine!","..."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Uploading virus.","Even their digital systems fall short against me.","Interfacing with a vastly superior being.","Finally, some better company.","Accessing data."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"I have the goods.","Looting the container.","This should buy me an upgrade or two."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"How annoying.","This changes things.","Adapting."}},
		[T_EVENT.PEEK] = 			nil,

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Ugh, I think it's still alive.","Stop twitching!","Why am I wasting my time here?","This is humiliating.","Do I really have to be touching him? Can't I just... no?","Do you know how easy it would be to snap his neck?"}},
		[T_EVENT.INSTALL_AUGMENT] =		{1,{"Perfection is hard to improve, but I believe that did the trick.","At last!","One step closer to perfection.","Yes!","I am even more optimized.","I think that one had a scratch on it.","Acceptable.","Only the finest.","This better not be some cheap knock-off.","Who could bear to look upon such beauty?","Look at me. Do NOT touch.","Are you sure that was the best we had?","Working with a pile of meatsacks is worth it, for this."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Not certain if I like this.","...Still more attractive than anyone here.","I prefer my enemies to look me in the face before I obliterate them.","Undetectable. Yet another on my long list of traits.","This hardly seems necessary."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Pathetic.","Don't get your juices on me, meatbag.","That only delayed the inevitable, you know.","You're up? Good, because I refuse to drag you.","See? That was me, being a good teammate.","I just saved your life, you worthless sack of juice.","There. Try not to fall over yourself with gratitude.","You can thank me later. Cash is best."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Waste of time, really.","Oh, good. You can carry my things.","Fantastic, more dead weight."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Bah! I hate having meatbags slow me down.","Mission took a turn for the ugly. This is all your fault, you know.","Next time, just send me in solo. I'll do a better job, I guarantee you."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"We perservered, as well we should.","We were clearly superior to them. You're welcome.","We couldn't have done that without me.","That was a smooth run. I take full credit.","They were no match against my enhanced frame."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"Now that is what I call sport.","Quite entertaining, for a change.","Pity not every job is like this.","Nothing better than the squealing death throes of husks that haven't yet begun to rot."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Dibs on the free bunk.","The less dead weight, the better."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"I will handle this.","Leave it to the machine.","Be glad I was there for you, meatstain.","I'm feeling magnanimous today.","How typical. A meatsack in need of a rescue.","This doesn't mean I like you."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"I told you to keep backups...","That's what happens when you run around in a body like that.","Surprised you lasted this long, really...","Hmpf. Organics...","This is what happens when you get sloppy."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Fools. I am not defeated yet.","If you abandon me, Operator, I WILL come for you.","These dogs are not worth surrendering to! \n\n...But I suppose I have no choice.","Ugh, fine, take me in. Just keep your sweaty paws off the metal finish."}},
	},

	-- Prism
	[_M.PRISM] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Let's get started.","This should be easy.","I'm in. Try not to get me killed.","Coming in clear, Operator. Don't make me regret ditching solo jobs.","Bring it.","I'm listening.","You've got a plan?","Coast is clear. Let's move.",}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Let's get this over with.","Taking him down.","Time to pay, pig.","Roll credits.","Oh yeah. He's down.","Not the red carpet I want, but it'll do.","They should have been afraid of me all along."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"He's one of the lucky ones.","I guess that's one way to deal with them.","Oh yeah. He's down.","Time for your nap."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Guess what? That wasn't a prop.","Corporate pig.","This does make me feel better.","How's that for a stunt?","Yeah, I don't think so."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Sweet.","They won't get past me.","I'll show them.","Time to dazzle."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"No! I won't...","Can't... be...","Nice shot, asshole."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"They'll pay for that.","Back in the floodlights.","Think this could stop me? Watch.","Thanks, I guess","Yeah, um... I owe you one."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Uploading program.","Siphoning the PWR.","This device is ours now."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Good thing we stopped by.","X marks the spot.","My favorite moment.","I'm sure they won't miss this.","Not a bad haul."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Yikes.","Aw, shit.","Damn it.","So much for staying on the down-low..."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Path scouted.","I see all.","Nothing shall slip me by."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"If you're smart, you won't wake up.","I've got him under control.","Got it. Enemy pinned.","What now?","Already bored.","This could get old, real fast."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"I should get some nice mileage out of this.","Just what I've been looking for.","Damn, that stings.","Sweet, an upgrade.","I better not turn into one of those chrome nuts.","Ugh. Sharp won't let me hear the end of this."}},
		[T_EVENT.DISGUISE_IN] =		{1,{"Time to become someone else.","They won't know what hit them.","Let's do some acting.","They always did worry that I took the roles too seriously.","Roll out the red carpet.","First and final take.","Just like the good old days.","This takes me back.","Ahem. Just an ordinary guard...","Hey there, fellow security..."}},
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Out of sight, out of mind.","Bit of a strange feeling, this.","I do not need this to blend in.","Putting the \"invisible\" in... well, you know.","Just like magic, but better."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Let's get moving.","You good? Okay, let's go.","Can't laze around forever, you know.","We haven't got all day.","Try not to collapse till we're in the clear.","I worked hard on my hair. Don't get your blood on it.","Oh good, you're still alive.","You're welcome.","You wanna get out of here or what?","Let's not stick around."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Good news. This is officially a jailbreak.","Yeah, yeah, it's me. Rescue now, autograph later.","Good. I was hoping it'd be one of us."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Well, that was a disaster.","Hey, at least we got away.","So we probably could have handled that one better...","For a while there, I thought that was it.","Made it! Wasn't sure we would..."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Terrific performance.","Roll credits.","Job done, everyone out. Nice."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"They got what they deserved.","I feel a little bad for them. Just a bit, mind you."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"So much for team spirit, huh?","Shit.","I had to leave a lot of people behind, back in the day. Hoped it wouldn't come to that..."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"Yeah, I don't think so.","Surprise, corporate pig.","Thanks for distracting him.","You okay? I've taken him out.","I don't mind playing hero, but that was way too close."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"I'm adding this to the list, you bastards.","Damn it.","Looks like we owe someone a bullet.","Keep moving..."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {" < singsong > Better know what you're doing, boss..."," < eyeroll > Oh no, don't shoot, you've got me cornered.","Hey, I was just looking for the bathroom. What is this place?","This isn't what it looks like.","Do your worst, you corporate pig."}},
	},


	-- Olivia
	[_M.OLIVIA] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"I'm on site. Insertion clean.","I read you.","Communication is up. Let's not dally.","No contact so far. What's our next step?","What are we looking at, Operator?","I'm counting on you.","We don't have much time. Let's make this count.","Coming in clear.","Operator, do you read me?",}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Eliminating the target.","Clean and precise.","Enemy neutralized","That's one less for us to deal with."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"He's down. Let's not waste time.","That ought to do it.","Enemy neutralized.","Clean and precise."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"He's dealt with.","Aggressor neutralized.","Time to get rough, then.","That ought to teach you.","Threat removed, I would say."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"I'll keep a watchful eye.","Readying my sights.","I'll show these boys a thing or two.","I suppose we'll have to do this old-school."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"No! They mustn't...","You... bastard...","No... I still need to...","Damn you...","You can't... take me alive..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Good. I'm not done with them yet.","I'm still alive? I suppose they've never had the best aim...","Only a minor setback.","You have my thanks, agent.","I've weathered worse than that."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Uploading the worm.","Subverting enemy tech.","Another asset gained.","Virus installed."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Well this should prove useful."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Oh, bother.","Hm, a setback."}},
		[T_EVENT.PEEK] = 			nil,

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"I've got him pinned down.","Under control.","He's not going anywhere."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"I suppose that's useful enough.","An augment is only as good as its host.","I'll make do with this.","Anything to give us the edge.","Power can have many forms.","A beneficial upgrade."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Can't see me now, can you?","Cloak in."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Enough dilly-dallying.","Look sharp, we're still in enemy territory.","That was a close recovery.","You should be fine for now.","Do try not to get shot next time.","Don't be so sloppy."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"I believe you're overdue for a change of scenery.","Do not dally. They're coming for us.","Take it easy, agent. We're here for you."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Disappointing, but at least we got away in the end.","Let's aim to do better next time, shall we? This should have gone much more smoothly.","This one was a bit of a mess.","I expect a full evaluation on ways we could have improved our performance in this mission."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"That was exemplary. Colour me surprised.","That actually went quite well for a change. Well done, team.","If only all missions could be that smooth.","Now that is what I like to see.","Back to the jet. I'll allow for a celebration, a small one."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"It may not be pretty, but the lethal approach is the most effective one, sometimes.","Sometimes, ruthless efficiency is what's called for. Emphasis on \"ruthless\".","They would do well to fear us.",}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"This is disgraceful, but it's the only choice we have.","Damn it.","We'll do our best to track down the agent we just lost. Until then, I expect everyone to pull double their weight."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"Not on my watch.","I don't think so.","That's my agent, you loathsome wretch.","You'll want to reconsider.","Coast is clear. You should move.","Remember, we stay on our feet to survive."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"Someday, we'll hold them accountable for this.","Not another one.","It's better than being captured. Trust me.","It happens. Keep your head on the mission, Operator."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {" < mutter > This had BETTER be part of your plan, Operator.","I am not going back, I won't...","Do us both a favour and end it here. \n\n...No? Coward.","Kill me here and now, you corporate dog, or I WILL live to make you regret it."}},
	},


	-- Derek
	[_M.DEREK] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Now see, being Operator? That's a nice gig, don't you think?","I'm listening. For now, anyway.","You have my undivided attention.","Let's get this heist started.","Don't get me in trouble, now.","Comms are up.","I read you.","Yes?","Comms are functioning. Thank goodness for that, at least.","Uplink established.","I'm receiving. Go ahead.",}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Well. That takes care of that","Time to get messy.","Try not to splatter too much.","Taking aim.","Ugh, I suppose this is unavoidable..."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Take a nap, my friend.","Why don't you have a lie-down?","Well that takes care of that","I should get one of these custom-made.","If I could just rewire this a bit..."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Okay, acquiring this thing was worth it.","I'm looking forward to the contents of your pockets.","Subduing the enemy.","Well that takes care of that.","Ah, wetwork.","That's quite enough.","Do be quiet.","I'm taking him out.","Enemy engaged."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"This is really so uncivilized.","Prepared to take action.","Watching this area.","Ready to fire.","Preparing a nasty surprise."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Well, that's...not good...","I blame... the  management...","Corporate... scum...","No, not after everything...","Not... like this...","I can't be..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Ugh. Do I even get hazard pay?","A second chance.","Let's up the stakes.","Back in the game.","My thanks, friend.","Remind me to thank you later."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Money is power, but so is data.","Let's take a look at this darling.","Time to get to work.","Ths is what I'm here for.","And now the real job begins.","Subverting enemy mainframe.","Ahhh, now this? This is more like it.","Just look at this system - how quaint.","Open sesame!"}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"A penny stolen is a penny earned.","Let's wipe this place clean.","This is pocket change to them. But it's our pocket change now.","Let's grab this and run.","Marvelous. Anything else we could lift?","Can't leave this lying around.","Let's put this to use.","I imagine they'd want to keep this. That's too bad.","Now that's what I call rewarding.","This day just got better."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Well, uh...","So much for the ghost approach.","I've encountered difficulties."}},
		[T_EVENT.PEEK] = 			nil,

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Keeping him down.","I've always aspired to be someone's hired muscle.","Enemy pinned.","Well this could get old rather fast.","He's not going anywhere."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Time to embrace the new age.","Ah, the wonders of technology.","Not a bad choice.","I wasn't attached to that bit of tissue anyway."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"This is more my style.","I'm sure I could tweak this to work longer.","Now that's some toy.","I like this."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"You are quite fortunate to have modern medicine on your side.","There you go, friend.","Can you walk? Marvelous.","Don't worry, the stinging is how you know it's working.","Come on, I'll help you up.","Friends don't let friends bleed out on the ground, remember.","Stick to the buddy rule next time.","You'll have to make that up to me.","Let's move along now.","Good. Saves me the bother of dragging you."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Yeah, yeah. You can thank me later.","Let's get you out of here, friend.","Not exactly what you'd call a luxury suite, is it?","You don't owe me money, do you? Because now-ish would be a fine time to deliver."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Any chance we could make it a bit less eventful, next time?","I think we may have overstayed our welcome.","We couldn't have cut that one any closer.","I'm going to need some calming tea after this."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Everyone in? Splendid, let's go.","Please make sure all limbs are contained in the elevator area before departure.","We certainly made a tidy profit.","Why, I think we might have been almost competent."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"I really, really need to get a desk job.","See, that's why they call it wetwork.","I got blood on my laptop. Let's pray the thing still works.","This wetwork deal is starting to lose its shine."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"...","...\nDamn it...","On the bright side, I suppose we've got a vacancy now..."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"Time to play the hero.","How much would you say your life is worth? Because you owe me one.","They think themselves unstoppable.","Plot twist: I've got toys of my own.","How's that taste?","Pardon me.","You can make it up to me later. Money's good. Money's best, actually."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"Damn...","Bad luck. Happens to all of us.","Anyone else think it's high time we high-tail it out of here?","I think we've stayed here too long...","Darn it. This isn't the way it's supposed to go."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Er... hello there. Look at my hands, huh? Completely unarmed!","I could make you a very rich man if you walk away. \n\n...No? Ah, worth a try...","Perhaps you could close your eyes and count to ten, make it fair? \n\n...Very well.","I surrender. I'm sure I'm not going to regret this at all.","Well, I suppose it was high time I brushed up on my anti-interrogation protocols..."}},
	},


	-- Draco
	[_M.DRACO] = {
		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"You called upon me?","I am your servant.","Now the feast can begin.","I hear you, Operator.","Command me, and I shall do your bidding.","Shall we?","Yours to command.","As night fell, he rose.", "The scent of blood filled the air - he was ready.", "Let us finish before the sun rises.", "My life is in your hands.", "I trust you... for now.", "Leave as we came: without regrets.", "Make sure we walk out of here, Operator.","This place is familiar. Could it be..."}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"See you in hell.","More prey.","Add this to my tab.","It is almost too easy.","I wonder what you've got for me."}},
		[T_EVENT.SHOOT_DRONE] =		{T_PROB.p_shootdrone,{"No blood spilled this time.","Still no match for a predator's reflexes.","I wonder how much this cost them.","Peekaboo.","You are no use to me, anyway."}},
		[T_EVENT.SHOOT_CAMERA] =		{T_PROB.p_shootcam,{"I'm watching you, Big Brother.","Target practice.","This might get some attention.","Blind them first, it drives them crazy.","Nothing to see here."}},
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"How dull.","Inadequate.","Won't stay down for long.","This is your lucky day.","You look tired, friend..."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Bothersome.","This is how it feels!","A shocking experience.","For your own sake, stay down.","...You were saying?","The hunter strikes!"}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"The hunter awaits.","Prepared to strike.","Enemies beware.","The element of surprise!","Muscles tense, his focus didn't waver, not for a moment..","Trust me, I'm not afraid to use it."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Careless... of me...","Not... again...","You'll never... take me alive...","Never hear the end... of this..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"No rest for the wicked.","This chapter is still unfinished.","Like a bat out of hell.","Someone will pay for that.","He shall rise again.","It takes more than that to keep me down.","Frankly, I'm terrible at dying.","I live!","I am in your debt."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Truly thrilling.","Though boring it may be, it's part of the job."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Finders keepers!","Well, hello there.","Would be a shame to leave this here.","No one will miss it, I am certain.","Ours for the taking.","A treasure trove."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"There you are!","I see you.","They have me in their sights.","Hssst!"}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Senses sharpened.","A quick look is enough.","Curiosity saved the cat.","Just to be sure I don't fall prey to another.","He was silent and careful, nothing gave him away..."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Don't make me do anything you'll regret.","I should have brought a book.","If you're lucky I won't be anywhere near when you wake up.","So... is the insurance good?","Here we are. Just you, me, and your brain.","I can read you like a book.","Let's peek between those pages.","The hunter swoops, pinning his prey."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Surprisingly refreshing.","Evolve to survive.","This just got more interesting.","The craving has eased a little.","They are not ready for what I am now."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Into the shadows.","With a light step.","Now you see me... now you don't.","You saw nothing.","Fading into darkness.","They won't see me coming.","Striking from the shadows.","A deadly apparition."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Rise and shine!","Awaken.","I command you: Rise.","This shall knit your flesh together.","Next time, do not let them catch you."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		{1,{"A paralyzing bite!","Your slumber deepens."}},
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"I release you.","Freedom beckons. Let's both of us follow its song.","You must spring free of their clutches!","You are weak, still. Trust me, they will not slow down for that."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"A messy escape, but an escape nonetheless.","The thrill of the hunt lies in its lack of perfection.","They are our prey, but the reverse is true, as well.","We've met our match today. Perhaps we can do better.","Never a better time to leave.","Let us go while we are in one piece.","Until next time.","This time, they get the upper the hand."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"A worthy show of our abilities.","We persevered, as well we should.","They were no match for our cunning.","They had no chance against us.","A happy end - to this chapter, anyway."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"The smell of carnage fills the air.","We've hunted our fill today.","They put up a good fight.","They struggled, but we perservered.","They squealed like pigs.","It is time to leave this battleground."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"A ghastly  necessity.","We are stronger in numbers. Alas.","Rather be the hunter than the prey.","This begs for some old-fashioned revenge.","Eye for an eye, they owe us one.","Would this justify the upcoming clean-up cost?"}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"Consider yourself in my debt.","Anything else while I'm feeling generous?","This temptation, I must resist it night by night.","And here I thought you could handle it without me.","Waited for my moment.","My moment comes!","I'll take it from here, thank you.","Emerged from the night, left no witnesses.","The hunter became the hunted!"}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"In the end, all must feel night's sweet embrace.","I see the shadows descend - but not for me.","A requiem for a hope.","I'll pen your obituary."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"You cannot capture the darkness. But by all means, go ahead and try.","Even cornered, I am still stronger than you.","You're afraid of me. I can tell. But I'll make it easy.","I could sign your copy while we're going through the formalities."}},
	},



	-- Rush
	[_M.RUSH] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Oh great, it's middle management.","What do you want?","Yeah?","Make it quick. I can't wait to get started.","Let me guess. You want me to peek through that door?", " < Yawn > ", "Uh-oh. Here comes the nanny...","Alright, yeah! Let's do this!","Ready to crash this place to the ground?","Let's crash this party!"}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"I like it when we don't hold back.","Super messy, but at least it's not boring.","No more than they deserve.","I prefer a personal touch.","Taking out the target.","This is what you get."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"See? I can do bloodless.","I would have rocked the biathlon, if I'd bothered.","Perfect aim. As always.","He's down, but still in the game.","Couche-toi!","Taking him out."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"I'm sooo good at this.","This is so much faster than stealth.","That was subtle, for me.","Sucker.","Is that what they call armed force? Pathetic.","I expected better.","Next!","Not so tough now, are you?","You better hope I didn't break a nail, buddy."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Got it covered.","All right, I'll wait.","Fine, I'll do it.","Lying in wait.","Prepared to ambush.","I'm watching this area.","Here we go!","Because if there's anything I love, it's standing still.","Fiiine. I'll keep an eye out.",}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Like you could... stop me...","What? No...","I don't believe...","Worth it...","Damn... you...","Casse-toi...","Op... operator? So the bad news is...","You... dirty... cheater..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Let me at them!","They'll have to try harder than that.","Ugh, fine, I'll buy you a drink later.","Yeah, I'm gonna make them pay."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"There, tech, do your techy thing.","Knowing how this works isn't my job.","Why are we bothering with these, again?","System... you know, whatever.","Uh, open sesame?","I'm pretty sure Derek, like, whispers to these."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Bingo.","Smash. Grab. Okay, less smashing than I'd like.","Is this all? I thought these people were rich.","Money? Well, I won't say no.","Hm. Underwhelming."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"They can see  me. Good.","Hey there!","Gotta make this look good.","Oh good, I was worried I'd done my hair for nothing.","An audience. Finally!","I'm used to a bigger crowd when I do my stuff."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Nothing I'd consider interesting.","Yawn.","Let's have a look-see.","Room scouted. Great, can I go in now?"}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"And here I thought this job would be exciting.","...How long do I have to do this?","I'm not here to babysit.","Enemy pinned. If that helps.","Can I punch him again? Just in case?",}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"I swore I was done with these.","Ugh, if I have to.","Ow.","I don't need that. I'm already the best.","You want to turn me into some kind of cybersoldier? Fine, whatever."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"So, uh... what now?","Cloak and dagger isn't really my style.","Can I do something useful for a change?","Cloak active. For whatever that's worth","Whoo! Pretty fun.","Time to be super duper quiet."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Next time, I just leave you behind.","See? I can do teamwork!","I don't have time to babysit.","Hurts, huh? Suck it up and let's go.","You up? Good. Get a move on.","This? This is slowing me down.","Clock's ticking.","You're less of a dead weight now.","Walk it off.","Sheesh.","< Eyeroll >","Look on the bright side: Scars are in fashion."}},
		[T_EVENT.WAKE_OTHER] =			{1,{"Stand up!","I was just about to kick you."}}, -- sorry had no better ideas

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		{1,{"A little overclock can't hurt.","Zing. Where to?","GAME ON.","Not as much of a rush as it used to be.","Whoo! Yeah! Let's do this!","READY SET GO.","So much for trying to shake that habit."}},
		[T_EVENT.STIM_OTHER] =		nil,--{1,{"Try this"}}, -- sorry had no better ideas
		[T_EVENT.SELF_STIMMED] = 	nil,--	{1,{"Refreshing!"}}, -- sorry had no better ideas, test
		[T_EVENT.STIMMED_BY] = 		{1,{"Thanks, pal."}}, -- same
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Look who's here: The answer to your prayers.","So you coming, or what?","Come on, we've got a ride to catch."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Whoo, what a mess!","Hey, at least it wasn't boring.","Ugh. That sucked.","I should be better than that.","Sometimes you fall flat on your face. We'll show them next time."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"And that is how you do it.","We just ran circles around those idiots.","We sure showed them!","Oh yeah, that got the blood pumping!","I think I set a new personal best, just then.","Smash and grab. Just the way I like it.","Yeah!"}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"Rats. I got blood on my favourite shoes.","This was fun.","They got what was coming to them.","And that is why you don't stand in our way."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"I guess we're not going back, huh?","Too bad. I was starting to like the company."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"Like I always say: I'm the best.","Don't say I've never done anything for you.","Held at gunpoint. Exciting, wasn't it?","Don't make me clean up after you again.","Bored again.","That was fun. Call me next time you get caught again.","I think you're losing your edge.","Yeah, I know. I totally saved you."}},
		[T_EVENT.SAVED_FROM_OW] = 	nil,	--{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"Huh. Well, that sucked.","Too bad. I was starting to like you.","I'm gonna make them pay."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Surrender?! You have *got* to be kidding me.","Ugh, whatever. Fine, I give up, you've got me. < mutter > This is *so* not my style.","Why don't you put down that gun and we'll see who comes out on top, huh?","So you're gonna bring me in, huh? You and what army?","Sure you don't want to wait for backup first? Make it fair?"}},
	},

		-- Monst3r
	[_M.MONSTER] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Goodness me. Still not quite used to having you in my ear.","Technically, I don't answer to you. But let's hear it.","Mmm, yes?","Uplink is up. Please, do go on.","You're coming in clear. Shall we begin now?","Must be nice, sitting back there and pulling on strings.","I read you, Operator.","Ugh. Don't make me regret getting back in the field, will you?","Yes, yes, I hear you.","You're coming in nice and clear.",}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Inelegant, but this isn't a civilized age.","Call me squeamish, but this isn't really my preferred M.O.","Enemy snuffed. Enough of a euphemism for you?","All that work tinkering with that gun, and I still have to do... this."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Guess what? You get to test my new prototype.","And here I thought I'd put these days behind me.","Now this is more like it.","Tranquilising the target. Happy now?"}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Well that takes care of that.","Some things you don't forget. Like riding a bike.","Not my preferred weapon, but it works.","A little trip down memory lane.","Oof. I'm not as young as I used to be, you know!"}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"They won't be passing through here, I assure you.","I'll keep an eye out.","Ambush prepared.","Constant vigilance.",}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Didn't see that coming.","Well that was unwise...","I seem to have made a...","That really... stings...","Gladstone, are you there? I...","No, that's not how it's supposed to...","You... corporate... fiend..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Good. I'd rather not have to take one for the team.","Oh, splendid.","Didn't think you'd be rid of me that easily, did you?","That one's bound to leave a mark.","Oh, thank you. A refreshing bout of competence.","Ngh. Much appreciated.","I've missed this. Having someone who has my back, I mean.","Urghh. Thank you, I shall be fine now.","Still stings, but this should keep me on my feet until we're out, at least."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Finally, back to my comfort bubble.","Do try to avoid bringing down any heat while I'm busy.","Almost makes me want to get back into software.","No meowing. Thank goodness.","At least that was easy.","Now what do we have here?","Hmmmmm... interesting.","Ah! I recognise this.","I can work with this, yes."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Would be a terrible shame to leave this lying around...","Money. I'd know it anywhere.","Oh good, we could use some new toys.","I like you, so I won't take my usual percentage.","I'll find a good home for this.","This could be useful, I'm sure."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		nil,
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Knowledge makes the man.","Let's see what's ahead."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Undignified for both of us, isn't it?","What do you take me for - some kind of thug?","I have the enemy pinned, if that helps.","I'd much rather be doing something else with my time.","My usual job involves a tad more sophistication, I'll have you know.","I have him pinned.","What should I do next - hit him with a rock? That would be par the course here, woudln't it?","Is this truly how you wish me to use my time?"}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Ooh, I think this one's a limited edition!","Hmph, if I must.","Not too shabby.","Not inadequate, but I do miss my old suppliers."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"I do love these new toys.","This is incredibly satisfying.","This should give them the slip.","It is time to... disappear.","Whoosh. Ahem, that ought to do it.","More my style."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Oh, good. I wasn't looking forward to having to drag you around.","Do be more careful next time.","You're welcome. I'll be sending you the reimbursement bill later.","Someone has to pull their weight around here. Might as well be me.","Gladstone's always excelled at risking her live assets. You're spared that fate, for now.","You know she still considers you expendable, right?"}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Let's not abuse their hospitality.","Come along, now.","Not staying to enjoy the view, are you?","You look chipper enough, given your stay. I promise you, they were just getting started.",}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"I forgot how much I hate fieldwork.","Phew, back to safety. I haven't missed being in the field."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"I wish there was some other way of exiting the building.","I may get used to field work someday, but I will never get used to the transport beam.","I don't suppose I could take the stairs instead? Meet you on the roof?","Back into the transporter beam. Ngh, my bones already ache all over."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"Why, I ought to start selling you ammunition in bulk.","Goodness gracious. With these cleanup costs, it's no wonder you are perpetually short on credits.","There are *human flecks* on me. Good thing I brought my wet wipes."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Well this brings back some nasty memories.","I would have preferred not to be in this situation again.","Ah, well, the job must go on. Isn't that right, Gladstone?","Really, Gladstone? I suppose you'll claim this was strictly unavoidable.","Oh, well, what's one agent more or less, as they always say."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"A dreadful business. You alright there?","Let's both be thankful I got to you in time.","You'll want to keep your head out of trouble, next time.","I would jest about a reimbursement fee, but even I'm not that callous.","On the house.","Are you unharmed? Well then, what the blazes are you waiting for?"}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"You knew the risks, friend...","Sigh. Not the first casualty I've seen.","Could we perhaps stop letting them shoot at us? By any chance?","This is why I retired, you know.",}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Well, I suppose this might as well happen.","Why, yes, you can arrest me, but wouldn't you rather have this coupon for my store, instead?","I do feel that I am getting too old for this..."}},
		[T_EVENT.EV_MONSTER_MID2] = {1, {"Now, if there is any chance I could get my Neural Dart back... No? Fine, let it be a gift. Just this once.","You're welcome to the gun, I suppose. I'm not entirely above charity.","I see you're holding on to my custom gun. A word of warning, you'll be receiving my invoice in due time. Plus interest.",}},
		[T_EVENT.EV_MONSTER_MID2_ESCORTSFIXED] = {1, {"Before we go- If you would be so kind as to hand me my gun back? I rewired that one myself, you know.","One last thing. My gun, if you please. It has immense sentimental value.","I'll be taking the gun back. I've helped you out enough for one day, wouldn't you say?",}},
	},




		-- Central
	[_M.CENTRAL] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Coming in clear. Don't let us down, Operator.","The mission is in your hands, Operator.","Let's not waste time, Operator.","Let's begin. I'm counting on you, Operator.","You're coming in clear.","Very good. Comms link is up.","Let's do this one by the book.","I read you.",}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Obstacle eliminated.","Taking the shot.","I'm doing this for her.","Doing what must be done.","Let's keep the mess to a minimum.","If I have to get my hands dirty, so be it."}},
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Temporarily neutralized.", "Done. Now let's not waste time.","Taking the shot.","An elegant, quiet solution.","Let's not be here when he wakes up."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Brutal, but effective.","This one won't get in our way.","The sooner this is over with, the better.","Deep in the nit and grit of it.","Let's make sure they don't stand in our way.","I still remember how to do this."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"I have my eyes peeled.","Preparing the ambush.","Ready for hostiles.","Ready to engage.","Overwatch ready."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"No! We were... so close...","I have... to finish...","After all this time...","This won't be how... we lose...","Incognita? You must..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Back into the field.","I will not be held back by the likes of this.","Good. We have work to do.","You're earning your keep, agent.","Good. Let's continue.","You're only doing your duty, but don't think I don't appreciate that."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Subverting the system.","She now has access to this.","Power. There's no need to comment on the irony.","A little something extra for her to work with."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"I never thought we'd get this desperate.","This should prove useful.","Let's pick their bones clean.","Time to play the common thief."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		nil,--{T_PROB.p_inter,{"Curses!","Ah."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Let's not get sloppy.","Scouting ahead.","I see the way.","Gathering intel."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Let's keep things under control, shall we?","All this troble just to avoid bloodletting. Pity he won't appreciate it.","I have this one subdued.","I'm keeping him down."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"This should prove useful.","Our bodies are such a small price to pay.","It's been installed seamlessly. Good.","Better this than being under-equipped.","We need every edge we can get."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Such a rare and useful bit of tech.","Cloak engaged."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Back on your feet, agent.","I need you on your feet. There we go.","Pay more attention next time.","Keep your head down. I'll get you out of here, I promise.","Don't thank me yet. If they capture you, you're going to wish I'd let you bleed out."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"We're short on time. Their security just got a bump.","Let's get a move on, shall we? Time is wasting.","You will receive full treatment later. For now, I ask you to be at your best.","Let me be clear: If you sold us out, you'd best walk right back into that cell.","We'll do a debrief of this later. Let's make sure we get you out of here alive.","I see you've been enjoying the five-star treatment. On your way, now."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Unsatisfactory. We've trained to be better than this.","We must try harder next time.","I expect a full evaluation on the ways we could have improved our performance here."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Good show, team. Let's not get cocky.","Well done, everyone. If we keep this up, we may actually have a chance.","Not bad. To think all that training I invested in is actually paying off for a change.","Let's get back now. You've earned your rest."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"This was brutal, perhaps, unnecessarily so.","A bloody mess, that's what this was. Perhaps we could try to keep things a little cleaner next time?","The cleanup fees will be a nightmare, I can tell.","They are the enemy, and today, we had to treat them as such."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Unfortunate.","A mercy kill may have been kinder, but we don't have that luxury.","We'll prioritise detention facilities when we can. It's the best we can do.","I hate to leave an agent behind, but we have no other choice.","This has weakened our team. Let's try to pick up the pace.","We're one agent down. I need everyone to pick up the slack."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"If you want something done, do it yourself.","Don't just stand there, find cover!","Don't be so sloppy. They nearly had you.","Don't let yourself be compromised again. We need all hands on deck.","Be more careful next time."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		nil, -- Central already has reactions to this
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"I hope you know what you're doing, Operator.","A risky move, Operator, but I'll trust you.","I swore they'd never take me back alive. Make sure if I wake up, it's in our hands, Operator.","I surrender. Are you happy now, you dastardly pig?"}},
	},

------------

	[_M.PEDLER] = {

		[T_EVENT.EVENT_SELECTED] = 		{T_PROB.p_selected,{"*Shall we proceed?*","*Do not waste my Time*"}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"*Such dirty work.*","*A necessary unpleasantry.*"}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		nil,
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"*Enough with you!*","*Servo 3 is twitchy.*"}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"*This way is watched.*"}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

	--	[T_PROB.EVENT_MISS_GUN] = 		{1,{"*Servo 3 is twitchy*"}},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"*Power... empty...*"}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"*Let's not do that again.*"}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"*Uploading virus.*"}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"*I want to deconstruct this.*"}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"*I have complications.*"}},
		[T_EVENT.PEEK] = 			nil,

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"*Such dirty work.*","A necessary unpleasantry.*"}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"*My power grows.*","*I am now... more*","*I have integrated it.*","*I find this... satisfactory.*"}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			nil,
		[T_EVENT.MEDGEL] =			nil,
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			nil,
		[T_EVENT.BAD_ESCAPE] = 		nil,
		[T_EVENT.GOOD_ESCAPE] = 		nil,
		[T_EVENT.BLOODY_MISSION] = 	nil,
		[T_EVENT.ABANDONING_OTHER] = nil,
		[T_EVENT.OW_INTERVENTION] = 	nil,
		[T_EVENT.SAVED_FROM_OW] = 	nil,
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"*There are ways to cheat death... but not this time.*",}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"*Maybe we can settle this mano-a-mano?*","*I surrender.*"}},
	},

	[_M.MIST] = {

		[T_EVENT.EVENT_SELECTED] = 	nil, --{T_PROB.p_selected,{"",}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Don't think... don't feel... just do it","I work for Invisible now."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"This will sting. Like a sea anemone.","I wonder what toxin is used here."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"I feel your pain. Literally.","Looks like my training paid off.","That was surprisingly easy.","Okay. Now what?","Sometimes stealth isn't the answer."}},
		[T_EVENT.OVERWATCH] = 		nil,
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Experiment... failed.","Looks like I'll never see Iceland again..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"No... no... oh, it's you.","I knew I couldn't die.","Ow! Easy on the needle.","Huge syringe. Ugh, what a sight to come back to."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"I can do things with this.","Power... yes..."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"I found something.","How much can we buy with this?","Some day I'm going to have to ask someone to explain credits to me."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"What? What's going on?"}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"See without being seen."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"I'm good at this part.","On/off... awake/asleep...","I know how your augments feel.","Is this what revenge feels like?"}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"I've always wanted one of these.","So what percentage human am I now?"}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"I chose my new name for a reason.","You can't see me"}},
		[T_EVENT.MEDGEL] =			nil,
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			nil,
		[T_EVENT.BAD_ESCAPE] = 		nil,
		[T_EVENT.GOOD_ESCAPE] = 		nil,
		[T_EVENT.BLOODY_MISSION] = 	nil,
		[T_EVENT.ABANDONING_OTHER] = nil,
		[T_EVENT.OW_INTERVENTION] = 	nil,
		[T_EVENT.SAVED_FROM_OW] = 	nil,
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"Gone, just like that... I could feel it.",}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"I... I can't go back!","I-I... Fine, you've got me. I'll do as you say."}},
	},

	[_M.GHUFF] = {

		[T_EVENT.EVENT_SELECTED] = 	nil,--{T_PROB.p_selected,{"",}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Time to make some new enemies"}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"You don't know how lucky you are.","Yeah, let's get this guy out of the way."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Gotcha.","These things are kind of fun.","Zapped.","It's nothing personal."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Nobody sneaks up on me"}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"You got lucky.","Too bad... things were just getting interesting..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Much obliged, friend.",}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Anything to get ahead.","Should I adjust the air conditioning while I'm here? This place is too damn cold."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Checking for hidden compartments.","What have we got here?","Leave no stone unturned.","There are people who'd kill for this much. Poor bastards."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		nil,
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Leave the scouting to me.","My eyes see everything.","Got a real good view."}},

		[T_EVENT.PIN] = 			nil,
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Hmm... feels good.","Now we're in business.","Better quality than what my old friends sold."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Would you believe this is more illegal than anything else I've done?"}},
		[T_EVENT.MEDGEL] =			nil,
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			nil,
		[T_EVENT.BAD_ESCAPE] = 		{T_PROB.p_badescape, {"What an absolute mess.","Let's try and not do *that* again."}},
		[T_EVENT.GOOD_ESCAPE] = 		nil,
		[T_EVENT.BLOODY_MISSION] = 	nil,
		[T_EVENT.ABANDONING_OTHER] = nil,
		[T_EVENT.OW_INTERVENTION] = 	nil,
		[T_EVENT.SAVED_FROM_OW] = 	nil,
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"Well, damn.",}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Ah, well.","Hmm. Outmaneuvered.","Not gonna read me my rights?"}},
	},

	[_M.N_UMI] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Operator.","My skills are yours.","I'm receiving.","I hear you."}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Die.","I've chosen my side.","Time to get my hands dirty."}},
		[T_EVENT.SHOOT_DRONE] =		{T_PROB.p_shootdrone, {"Sorry. But you are just a machine.","You'll live on as scrap metal.",}},
		[T_EVENT.SHOOT_CAMERA] =		{T_PROB.p_shootcam,{"Eliminating surveillance.","No more hostile eyes.","They can't watch us now."}},
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Dream for a while.","Taking the enemy out.","A nonlethal approach.","A little sting..."}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Electricity has many uses.","If they could see me now.","If it's any consolation, your brain is more resistant to damage than delicate electronics are.","He's down.","Out before he knew it.",}},

		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"Confirmed.","Overwatch ready.","Area sighted.","I'm on the lookout.",}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Remember... remember...","Ow... So cold... and familiar..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Is my drone okay?","Just as well. I'm not ready to give up.","Thanks.",}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Fuel for my drone army! ...Just kidding.","Power transferred.","Interesting... but unlike some people, I can prioritize."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Like drones, credits are just a tool. It's what you use them for.","I've searched it.","Empty now."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		nil,
		[T_EVENT.PEEK] = 			nil,

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Everything has a power-off switch, if you know where to look.","Be still now.","Don't make a fuss.","Are you still out? Good."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Why does this process seem vaguely familiar?","Not the absolute highest quality, but it'll do.","I could improve this, but we don't have the time."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"I can't help but be awed by this tech.","Holo-optics are a fascinating field.","An advanced model. I can barely feel the heat build-up.",}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"You're welcome.","You're lucky I'm here.","Administering first aid.","Thank godness for nanomachines.","Even medicine is all about robotics now.",}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			nil,
		[T_EVENT.BAD_ESCAPE] = 		nil,
		[T_EVENT.GOOD_ESCAPE] = 		nil,
		[T_EVENT.BLOODY_MISSION] = 	nil,
		[T_EVENT.ABANDONING_OTHER] = nil,
		[T_EVENT.OW_INTERVENTION] = 	nil,
		[T_EVENT.SAVED_FROM_OW] = 	nil,
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"Life is impermanent.",}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"It's fine. I can make this work.","Better to live to fight another day, as they say. I surrender."}},
	},

	[_M.CARMEN] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Here we go.","What's good, Opera?","I'm listening.","You're coming in loud and clear.","Where to next?"}},
		[T_EVENT.ATTACK_GUN] = 		{0.2,{"I swore I would never do this....","I just stole something I can never give back.",}},
		[T_EVENT.SHOOT_DRONE] =		{T_PROB.p_shootdrone,{"I've got my own gadgets to deal with you.",}},
		[T_EVENT.SHOOT_CAMERA] =		{T_PROB.p_shootcam,{"No peeking!","Lights out.","I'm not looking to get on camera today.","Paparazzi time-out.",}},
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Don't worry, you won't feel a thing.","Taking him out from a distance.","There we go.","All clear!",}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"This is going to sting.","Sorry, you're in my way.","Easy now.","Okay, he's down.","He's out.","I'm taking him out.","I've gotta be rough here, sorry."}},

		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"I'm ready.","I'll give you the cover you need.","I've got the room covered.",}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Ow, that... hurts...","I think I have to... stop here...","Good thing I... wore red...","It's fine, go on... without me...","I might have to... take a break...",}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Ow. Still stings.","Thanks. I feel better already.","Didn't search my pockets for loose change first, did you? Wouldn't blame you.","They owe me a new coat.","Thanks. I'll be fine.",}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"I'm in the system.","Let's see what we have here...","I'm in.","That's one cluttered desktop.",}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"I've got the valuables.","This goes straight in my pockets.","I prefer stealing artefacts, myself.","Maybe we can donate some of this when we're done.","I know a children's charity that could use some of this.","Don't worry, I left them a consolation note.","All clean now.","Bait and switch. Easy enough.","Good thing I have so many pockets.",}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_loot,{"Drat!","Hey there.","Looks like you've caught a peek of me.","Still have to catch me!","Now comes the chase!"}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Let's see what's going on here...","Eyes and ears open.","A quick look inside.","I think I got a pretty good look.","Interesting...",}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Keep still, now.","Don't mind me while I go through your pockets.","I'll make sure he stays like this. Wouldn't want him walking around again.",}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"It's not the tech that makes the thief. But it helps.","This should be useful!","Ouch, I'm going to feel that one for a while.","This will take some getting used to.",}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"They won't see me like this.","Time for a bit more subtlety.","I guess the public appearance will have to wait.",}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"You alright?","It's okay, I've got you.","We need to get you out of here...","Take it easy, now.","You got shot. But you're all better now.","You're disoriented. Stay calm and follow my lead.",}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Time to fly the coop.","Care to stretch your legs?","Now for the fun part.","The more, the merrier!","Good to have you onboard.",}},
		[T_EVENT.BAD_ESCAPE] = 		{T_PROB.p_badescape,{"Oof. At least we got away...","That could have gone better.","Better luck next time.","We'll need a better plan.","That was too close.",}},
		[T_EVENT.GOOD_ESCAPE] = 		{T_PROB.p_goodescape,{"My pockets are full. Nice.","We sure showed them!","Reminds me of that heist in Cairo.","These villains are no match for us.",}},
		[T_EVENT.BLOODY_MISSION] = 	{T_PROB.p_bloodymission,{"That was... gruesome.","This wasn't the deal. I can't work like this.","We stole so many lives...","This isn't how it should be.","Sometimes I think you people are no better than V.I.L.E.",}},
		[T_EVENT.ABANDONING_OTHER] = {T_PROB.p_abandonedother,{"No! We have to go back, we have to!","Never leave someone behind... I used to follow that motto.","...","< sigh >",}},
		[T_EVENT.OW_INTERVENTION] = 	{T_PROB.p_savefromow, {"On the house!","Good thing I love playing hero.","And that's why they call me the Scarlet Shadow.","Heads up!"},},
		[T_EVENT.SAVED_FROM_OW] = 	nil,
		[T_EVENT.AGENT_DEATH] = 		nil,
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"Ugh, dramatic rescue would not go amiss right now...","Where's my team when I need them?","Funny, you don't look like the guy I always thought might be the one to catch me.","You could chase me around a bit, make it sporting."}},
	},

	[_M.GOOSE] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{" < HONK > ", " < HONK  HONK > ", " < HONK. > ", " < HONK HONK HONK? > ",}},
		[T_EVENT.ATTACK_GUN] = 		nil,
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_GUN_KO] = 	nil,
		[T_EVENT.ATTACK_MELEE] = 	nil,
		[T_EVENT.OVERWATCH] = 		nil,
		[T_EVENT.OVERWATCH_MELEE] =		nil,
	--	[T_PROB.EVENT_MISS_GUN] = 	nil,
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{" < HON- > ", " < H-HONK... HONK... > "}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{" < coo > ", " < HONK! > ", "..."," < croon > ",}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{" < HONK! > "," < HONK HONK HONK. > ",}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{" < HONK > ",}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"...", " < HONK? > ",}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{" < HONK > ", " < HONK. > "}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{" < HONK! > ", " < HONK HONK HONK. > ", "...", " < HOOONK! > "}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{" < HONK! > ", " < HONK. > ",}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"..."," < (honk) > "}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{" < HONK! HONK HONK! > ", " -flap flap- ", " < HOOOONK! > -flap- ",}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{" < HONK. > ", " -flap flap flap- ", " <HONK!> ",}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{" < HONK! > "}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{" < HONK HONK! > "}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{" < HONK HONK HONK HONK! > -flap flap- "}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"..."," < HONK... > "}},
		[T_EVENT.OW_INTERVENTION] = 		nil,
		[T_EVENT.SAVED_FROM_OW] = 		nil,
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"..."," < HONK... HONK. > ", " < H-HONK? HONK?! HOOOONK! > "}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {" < HONK > ","...","...\n\n < HONK. > "," < HONK! > \n\n <flap flap flap> "}},
	},

	[_M.CONWAY] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Coming through.","Coming through loud and clear.","Crashing through loud and clear.","When you say Jump, I ask Onto Whom."}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"This is gonna get messy.","I was aiming for his leg!","Someone's gonna have to clean that up.","Threat resolved."}},
		-- [T_EVENT.SHOOT_DRONE] =		{T_PROB.p_shootdrone,{"I've got my own gadgets to deal with you.",}},
		[T_EVENT.SHOOT_CAMERA] =		{T_PROB.p_shootcam,{"Whoo! Bullseye!","I'd have enjoyed hacking it more.","Local backup annihilated.","It's rude to stare. Even at me.",}},
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Pew pew!","Down he goes.","Better scram before he wakes up.","I should run over and punch him, too, just in case.","What happened to good old-fashioned fisticuffs?"}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"So much for being the perfect gentleman.","And here I thought I'd left my sordid past behind me.","Violence is not the answer. But it makes for a decent question!","Don't make me punch you any harder!","I think that hurt me more than it hurt him."}},

		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"I'd prefer a laser sight.","Shouldn't I be the projectile?","I won't actually need this, right?","Uh, ready to target stuff.","I am... watching... over.",}},
		-- [T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"Uh oh.","Oh, shit-","Shoulda... worn the vest...","Owie..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Makes me feel slightly less old.","Let's throw a funeral party later.","Huh. What's up, doc?","Ready to hop once more."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Beep boop BLEEOUP!","Beebidy boop.","Pro tip: Always stop to read other people's emails.","Do I get extra credit for jacking these? I'd better.","Hack attack!"}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"Enjoyable.","Satisfying.","One step closer to a gold leaf trenchcoat.","It's like Christmas, if presents came in reinforced steel wrapping.","New gadget, here I come!","I'm not in it for the money. Not exclusively.",}},
		-- [T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		-- [T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_loot,{"Not again.","I'll rewire you. And hide. Not in that order.","Hopefully they'll blur out my face.","Can't leave witnesses!","So much for being a ghost."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Better take a look around.","Let's peek ahead, just in case.","Peeking through conveniently slatted doors is my specialty.",}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"I might have to punch you again, just in case.","Nice and easy now.","Looks like you got jumped.","He's still breathing, right? Oh good."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"Maybe the real friends were the augments we got along the way.","That smarts.","Starting to get real crowded in me.","I like my tech how I like my blood: on the outside."}},
		-- [T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Swishy swooshy.","This bit's never getting old.","All that time spent picking out the perfect hat, wasted.",}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"No worries, I've practised in surgery simulation.","Phew, soon I will have saved/avenged more than I've killed.","You'll be fine, I know what I'm doing. (Lie)"}},
		-- [T_EVENT.WAKE_OTHER] =		nil,

		-- [T_EVENT.PARALYZER] =		nil,
		-- [T_EVENT.STIM_SELF] =		nil,
		-- [T_EVENT.STIM_OTHER] =		nil,
		-- [T_EVENT.SELF_STIMMED] =		nil,
		-- [T_EVENT.STIMMED_BY] =		nil,
		-- [T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"Good to see you too. Let's get hopping!","You've got a bad case of the jailbirds.",}},
		[T_EVENT.BAD_ESCAPE] = 		{T_PROB.p_badescape,{"I could do with some ketamine.","I could do with bingewatching some TV series.","I could do with a day off.",}},
		[T_EVENT.GOOD_ESCAPE] = 		{T_PROB.p_goodescape,{"Another job well done.","I hope I get some ugprades!","This might be the break we've been waiting for.","Not bad.","Yay!","Nice. Now to iron my pants.","We can kick back and relax now.","Could go for a coffee. Or an egg cream.","Pushing elevator buttons is my specialty."}},
		[T_EVENT.BLOODY_MISSION] = 	{T_PROB.p_bloodymission,{"I feel the ludonarrative dissonance settling in.","What was that about stand-up fights?","These stains won't wash out of my coat.","Bad case of crossed wires."}},
		[T_EVENT.ABANDONING_OTHER] = {T_PROB.p_abandonedother,{"Sucks to be you.","Our party dwindles by the day.","I don't like where this is going.","You'd come back for me, though... right?"}},
		[T_EVENT.OW_INTERVENTION] = 	{T_PROB.p_savefromow, {"See? I've got it under control.","Conway saves the day! Du-duru-du-du!","The trick is to not let them catch you."},},
		-- [T_EVENT.SAVED_FROM_OW] = 	nil,
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"Oh. Uh...","Well, crap.","That escalated fast.","I don't like where this is all going.","I guess I'd better take off my hat."}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {"This is starting to look pretty hopless.","Looks like you've got me... at gunpoint.","Could use a well-timed rescue. \n\n...Hello?","Uh oh. I was just looking for the bathroom. (Lie) ","Where's a window when you need one?","I give up! Don't shoot, I have so much to live for!"}},
	},

	[_M.INFORMANT] = {
		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Yes, darling?","Monst3r said you came highly recommended. Don't disappoint.","Naturally, I'll be taking my cut when all is said and done.","This should be fun.",}},
		[T_EVENT.SHOOT_DRONE] = 		{T_PROB.p_shootdrone,{"Can't have that running around.","Shush, you.","I prefer people. They're much more open to conversation.",}},
		[T_EVENT.SHOOT_CAMERA] =		{T_PROB.p_shootcam,{"Nothing to watch me as I do my work.","One less set of eyes to worry about,"}},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"This isn't what I signed... up...","Damnation...","Not the way I... planned...","Guess my luck... finally turned...",}},
		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Ah, damn. There goes my cover.","Tsk. This job just got a lot more complicated.","A witness. We'll have to take care of that.","I'm seen. You understand the implications of this, yes?",}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Can't have anyone spot me, now can we?","Let's check if the path is clear.","Are you seeing anything I'm not?","Let's share our intel.",}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"How considerate. You must be desperate for my services.","I was right to trust you.","Ngh. What...?", "You... saved me? I must be more useful to you than I thought.",}},
		[T_EVENT.MEDGEL] = 			{T_PROB.p_medgel,{"You're quite welcome.",}},
	},

	[_M.REFIT_DRONE] = {
		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{" < Bzzzt. > ", " < Beep-boop. > ", " < Brrrrzzzt? > ", " < Weee-wooo > "," < Oowoo. > ",}},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{" < -zzzzzzzt- > "," < Bz... bzoop. > ", " < BZZ- > ",}},
		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{" < Beep-boop? > ",}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{" < Beep-boop. >", " < Beep-beep-beep. > ", " < Bzeepity. > "," < ooOoooooo. > ", " < Dooweep. > ",}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{" < BzzzrRRRRtt. > ", " < Beep-beep-beep. > ", " < Bzz-bloop! > ",}},
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{" < Beep-boop!!! > ", " < Bzzz-boop. > ",}},
	},

	[_M.TRANSISTOR_SWORD] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{" < Eyes up front, Red. > "," < Job has started. Look sharp. > "," < Be careful, alright? > "}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{" < Easy on the trigger. Good. Just like that. > "," < Take him out. > "," < Getting to be a better shot than I was. > "," < Don't think about it. Just aim and fire. > "," < Don't like seeing you with a gun. But at least you can take care of yourself. > ",}},
		[T_EVENT.SHOOT_DRONE] =		{T_PROB.p_shootdrone,{" < The Process is different here. Still easy to kill. > "," < This takes me back. > "," , Alright. Looks like that did it. > ",}},
		[T_EVENT.SHOOT_CAMERA] =		{T_PROB.p_shootcam,{" < Prying eyes. > "," < Too many paparazzi. > "," < Even now, they can't stop staring. > "," < No pictures. > "," < A little privacy here! > ", " < They still like you. Too bad. > ",}},
		[T_EVENT.ATTACK_GUN_KO] = 	{T_PROB.p_gunko,{" < That put him out, for sure. > "," < Getting to be a better shot than I was. > "," < Good. Just like that. > ",}},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{" < Shouldn't have to get your hands dirty. > "," < He's out cold. > "," < Didn't hurt yourself, did you? Good. > "," < Who taught you how to punch like that? > "," < That did it. > "," < Goon's down. > "," < That's one less. > "," < Making progress. > ",}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{" < Deep breath. Now wait. > "," < Wish I could have your back for this. > "," < Alright. You ready? > "," < I should be the one doing this. > ",}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,
	--	[T_PROB.EVENT_MISS_GUN] = 	nil,
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{" < No! > ", " < You're hit! Hang in there, Red! > "," < You'll be okay. Hang on! > "," < No! I can't lose you like this! > "," < Damn it! I can't even- > "," < No... too much red... > ",}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{" < That was too close. > "," < Don't do that again. Please. > "," < Can't take you out that easily. > "," < Looks like your team's got your back. Good. > "," < Red... You alright? > "," < I almost lost you. > ",}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"< Clever little system. Reminds me of home. > "," < You feel like ordering pizza? Just kidding. > "," < Let's see what the weather forecast's like. > "," < Alright, we're in the system. > "," < More circuits. Same old. > "," < I miss the countryside. > ",}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{" < Found something here. > "," < Should be useful. > "," < Money's good. But we're still on the run. > ",}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{" < Red, think fast! > ","< Quick! Hide! > "," < Get to safety! > ", " < Gotta move! > ",}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{" < Don't let them see you. > "," < You're getting good at this. > "," < See anything? > "," < Red. Be careful. > ",}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{" < Give him another kick, just to be sure. > "," < Not going anywhere. > "," < You remember that technique I taught you, right? > "," < We've got him pinned down. > "}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{" < More parts. When does it end? > "," < I wish I could be there with you. > "," < Don't overdo it. You might end up just like me. > ",}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{" < They can't see us. Time to move. > "," < Faded. Can't waste it. > "," < Should slip right by. > ",}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{" < Let's hope they'd do the same for you. > "," < Saving people. That's the Red I know. > "," < Wish I'd had one of these gels lying around when... well, you know. > "," < That did it. Think they can walk already? Well, no time to find out. > ",}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{" < Never liked these cages. > "," < Let's get them out of here. > "," < Good. We got here just in time. > "," < Still alive. Could have been a lot worse. > "," < Got them out in time. Well done. > ",}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{" < At least you're out. All that matters. > "," < Still standing. Could have been a lot worse. > "," < Still got all hands and feet. I count that a win. > "," < It's gonna be alright. I promise. > ",}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{" < Sure showed them. > "," < Can't stop us. Not when we're together. > "," < Pretty good. > "," < Is that you humming? I thought so. > "," < Here's to a job well done. > "," < Your grumpy boss should be happy. Don't... don't tell her I said that. > ",}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{" < That was a mess. > "," < Well. That was something. > "," < It was them or us. > "," < Red. You okay? > "}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{" < It wasn't your fault, you know. > "," < We'll find them. > "," < Don't like leaving people behind. Never gets easier. > ",}},
		[T_EVENT.OW_INTERVENTION] = 	{T_PROB.p_savefromow, {" < Playing hero is a good look on you. > "," < Just in time. > "," < Good timing on that one. > "," < They'd better be grateful. > ",}},
		[T_EVENT.SAVED_FROM_OW] = 		nil,
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {" < I can... feel them... > ", " < New trace. Funny how that happens. > "," < Processing's started. Shouldn't take too long. > ",}},
		[T_EVENT.SURRENDER] = 		{T_PROB.p_surrender, {" < Stay calm. They're not shooting to kill. > "," < Easy, Red. Your team'll come through. > "," < They'd better not hurt you. > ",}},
	},

		-- INTO THE BREACH agents ------------
	[_M.BETHANY] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"I'm listening!","What do you think we should do, Operator?",}},
		[T_EVENT.EV_RESELECTED] = {T_PROB.p_selected,{ "Does... do colors seem sharper to anyone else?", "Did we just create a new timeline or...", "I heard repeated local breaches can induce s-s-stuttering... oh no.", "Temporal physics used to make my brain hurt. Now they do, literally." , }},
		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"I... I've got this enemy pinned!","Nice to pin one of the guards for once!", "I'm keeping this guy down, but I don't know for how long!" }},	
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"I... I'm back. Just need a moment to get my bearings." }},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"No! ...Not like this...","Not you too!", "Gone... but not forgotten." ,}},	
		
	},
	[_M.CAMILA] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Ready on your mark, commander.","Deployment successful. Ready when you are, commander.","Camila Vera, reporting in.","Camila Vera, ready to engage.","Deployment successful, all systems go."}},
		[T_EVENT.EV_RESELECTED] = {T_PROB.p_selected,{ "Nnnh... localized breaches make my head hurt.", "Can't do that again for a while.", "We got a second chance, let's make it count.", "Localized breach successful, commander... er, this may be the first time you've heard this.", "Localized breach successful, commander." , }},
		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"I've got him pinned!","This one's not going anywhere.",}},	
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Nnh... Camila Vera, reporting for duty.","Time for round two." }},		
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"Agent down! I want no more mistakes!","Everyone, focus! We can't lose anyone else!", "We lost them! Dammit!", }},
	},
	[_M.SILICA] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Scanning region for useful resources. Awaiting input.", "Excavation commencing.","Excavation plans not found. Requesting Operator to supply.",}},
		[T_EVENT.EV_RESELECTED] = {T_PROB.p_selected,{ "Systems resetting.","Updating chronometer." , }},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Enemy destroyed."}},
		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"This hostile is not cleared to re-engage.","Reemergence of consciousness prevented.",}},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{ "Deactivating... \n\n...systems.", "Sensor failure... reported...", }},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Reactivated.","Sensors online.", "Commencing self-diagnostic.", }},		
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"Unauthorised dereliction of duty detected.","Agent has abandoned post. Reporting transgression to squad leader.",}},
	},
	[_M.GANA] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Components reporting for duty.","Communications subsystem has initiated successfully. What are your orders?","Components are ready for input.","My weapons have reported in. All components are eager to fulfill their purpose.",}},
		[T_EVENT.EV_RESELECTED] = {T_PROB.p_selected,{ "Recalibrating. Updating chronometers.","Localised temporal breach detected.","Tensile forces have been exerted on this timeline.","Chronometers reset. Objectives remain fixed.","Localized breach successful. Suggest avoiding any more wear and tear on timeline.", }},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Enemy hazard disposed of.","Hostile disposal operations are on track.", "Clearing enemy hazard.", "Removing hostile from the area.", "Clearing hazard from area, but caution is advised." }},
		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Enemy hazard is secure.", "Enemy has been detained.","Enemy has been prevented from surfacing to a threat state.", }},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{ "Systems... surrendering...","Primary systems... have mutinied, I repeat-","Core system dereliction, collapse imminent-", }},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Self... un-decommissioned.", "Core functions restored. Resuming work.", "Recommission order countermanded by Agency combat directives.", }},			
	},
	[_M.ARCHIMEDES] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"You seem competent enough. I suppose I can listen to you.","I am receiving your transmission. Onward!","This communications tech is quite archaic, but I suppose it will have to do.",}},
		[T_EVENT.EV_RESELECTED] = {T_PROB.p_selected,{ "Did we go actually just go back in time? Or did we create a divergent timeline?","Did we just- Oh my. I was not aware the agency commanded that kind of technology.","How odd. I detect signatures not unlike those of a temporal breach...",}},
		[T_EVENT.ATTACK_GUN] = 	{T_PROB.p_gun,{ "I have disposed of this threat to human safety.",
		"The enemy has been disposed of safely and humanely.",
		"I'm relatively certain the creature didn't feel any pain.",
		"The corporate hazard has been sanitized."}},
		[T_EVENT.PIN] = 	{T_PROB.p_pin,{"Keeping the enemy restrained in such a manner is rather embarrassing.",
		"Squatting on unconscious enemies was not what I was programmed for.",
		"Surely we can find a better way to keep these creatures from waking up than with the weight of our bodies.",}},
		[T_EVENT.GOT_HIT] = 	{T_PROB.p_gothit,{"Systems fail-"}},
		[T_EVENT.REVIVED] = 	{T_PROB.p_revived,{"Power... restored. Why, how embarrassing. Was I out long?","Let's not speak of this.","I seem to have... taken a hit. All is well now.",}},
		[T_EVENT.AGENT_DEATH] = 	{T_PROB.p_agentdeath, {"Their life signs have ceased.","Why are humans so fragile?","Regrettable. I hardly knew the agent, but it seemed an adequate specimen.",}},
	},	
	[_M.HENRY_KWAN] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"What is it? I'm listening.","Let me at them. Where do you want me first?","Operator, this ass-kicking machine is at your disposal!","You can relax and kick back, Operator. I've got this covered.",}},
		[T_EVENT.EV_RESELECTED] = {T_PROB.p_selected,{ "Feels like we're stripping time's gears when we do that...","Felt like there was two of me for a sec... how awesome would that be!","Hello, hello? Okay, the universe didn't blow up from that. Great.", "Let's try this one more time, then.", "Oh, did we reset? Haha, you didn't get me killed or anything, right?" }},
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Did you all see that?", "Got him! Yes!", }},
		[T_EVENT.PIN] = 	{T_PROB.p_pin,{ "Easy there, big fella.", "No waking up for you today.", "I'm on top of the situation.", "Simmer down, big fella." }},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"No way... I'm not supposed to die...","Lucky... shot...", "Not... fair...", "Didn't... see it coming...", "At least... I went out fighting..." }},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Did... did I get knocked out? What happened?", "...I hope no cameras saw that.", "Annnnd I'm back!", "Time for some payback!" }},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"If only they'd listened to me, this wouldn't have happened", "Dammit! I ordered you not to die!", "I'll avenge you, just you wait!", "That's one more the corps will answer for!" ,}},		
	},
	[_M.LILY_REED] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Coming in clear!","I can hear you just fine! What's next?","Here we go!"}},
		[T_EVENT.EV_RESELECTED] = {T_PROB.p_selected,{ "It worked! We didn't blow up time or anything!","That. Was. So. COOL.", "All my senses feel... sharper. Colors seem... brighter.", "Annnnd we're back!", "Okay, Lily, remember - don't do the thing you did before, do a different thing.", }},
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"And there's more where that came from!", "That's from the team, sucker!", "One down! Who's next!","Lights out!", "And STAY down!", }},
		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"No... no way...","Gave it... my best shot...","Ow, that... really hurt...","I don't think I can... finish this...", }},		
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"What... what happened? Did I pass out?","Ooooh... my head is killing me!", "Ow-ow-ow...", }},
		[T_EVENT.AGENT_DEATH] = 		{T_PROB.p_agentdeath, {"No no no... This wasn't supposed to happen!",}},		
	},		
	

		-- GENERIC_AGENT -- for all other agents --UNUSED
	[_M.GENERIC_AGENT] = {

		[T_EVENT.EVENT_SELECTED] = 	{T_PROB.p_selected,{"Coming in clear. Don't let us down, Operator.","The mission is in your hands, Operator.","Let's not waste time, Operator.","Let's begin. I'm counting on you, Operator.","You're coming in clear.","Very good. Comms link is up.","Let's do this one by the book.","I read you.",}},
		[T_EVENT.ATTACK_GUN] = 		{T_PROB.p_gun,{"Obstacle eliminated.","Taking the shot.","I'm doing this for her.","Doing what must be done.","Let's keep the mess to a minimum.","If I have to get my hands dirty, so be it."}},
		[T_EVENT.ATTACK_GUN_KO] = 		{T_PROB.p_gunko,{"Temporarily neutralized.", "Done. Now let's not waste time.","Taking the shot.","An elegant, quiet solution.","Let's not be here when he wakes up."}},
		[T_EVENT.SHOOT_DRONE] =		nil,
		[T_EVENT.SHOOT_CAMERA] =		nil,
		[T_EVENT.ATTACK_MELEE] = 		{T_PROB.p_melee,{"Brutal, but effective.","This one won't get in our way.","The sooner this is over with, the better.","Deep in the nit and grit of it.","Let's make sure they don't stand in our way.","I still remember how to do this."}},
		[T_EVENT.OVERWATCH] = 		{T_PROB.p_ow,{"I have my eyes peeled.","Preparing the ambush.","Ready for hostiles.","Ready to engage.","Overwatch ready."}},
		[T_EVENT.OVERWATCH_MELEE] =		nil,

		[T_EVENT.GOT_HIT] = 			{T_PROB.p_gothit,{"No! We were... so close...","I have... to finish...","After all this time...","This won't be how... we lose...","Incognita? You must..."}},
		[T_EVENT.REVIVED] = 			{T_PROB.p_revived,{"Back into the field.","I will not be held back by the likes of this.","Good. We have work to do.","You're earning your keep, agent.","Good. Let's continue.","You're only doing your duty, but don't think I don't appreciate that."}},
		[T_EVENT.HIJACK] = 			{T_PROB.p_hj,{"Subverting the system.","She now has access to this.","Power. There's no need to comment on the irony.","A little something extra for her to work with."}},
		[T_EVENT.SAFE_LOOTED] = 		{T_PROB.p_loot,{"I never thought we'd get this desperate.","This should prove useful.","Let's pick their bones clean.","Time to play the common thief."}},
		[T_EVENT.EXEC_TERMINAL_LOOTED] =	nil,
		[T_EVENT.THREAT_DEVICE_LOOTED] =	nil,

		[T_EVENT.INTERRUPTED] = 		{T_PROB.p_inter,{"Curses!","Ah."}},
		[T_EVENT.PEEK] = 			{T_PROB.p_peek,{"Let's not get sloppy.","Scouting ahead.","I see the way.","Gathering intel."}},

		[T_EVENT.PIN] = 			{T_PROB.p_pin,{"Let's keep things under control, shall we?","All this troble just to avoid bloodletting. Pity he won't appreciate it.","I have this one subdued.","I'm keeping him down."}},
		[T_EVENT.INSTALL_AUGMENT] =		{T_PROB.p_augm,{"This should prove useful.","Our bodies are such a small price to pay.","It's been installed seamlessly. Good.","Better this than being under-equipped.","We need every edge we can get."}},
		[T_EVENT.DISGUISE_IN] =		nil,
		[T_EVENT.CLOAK_IN] =			{T_PROB.p_cloak,{"Such a rare and useful bit of tech.","Cloak engaged."}},
		[T_EVENT.MEDGEL] =			{T_PROB.p_medgel,{"Back on your feet, agent.","I need you on your feet. There we go.","Pay more attention next time.","Keep your head down. I'll get you out of here, I promise.","Don't thank me yet. If they capture you, you're going to wish I'd let you bleed out."}},
		[T_EVENT.WAKE_OTHER] =		nil,

		[T_EVENT.PARALYZER] =		nil,
		[T_EVENT.STIM_SELF] =		nil,
		[T_EVENT.STIM_OTHER] =		nil,
		[T_EVENT.SELF_STIMMED] =		nil,
		[T_EVENT.STIMMED_BY] =		nil,
		[T_EVENT.AWAKENED_BY] =		nil,
		[T_EVENT.RESCUER] = 			{T_PROB.p_rescuer,{"We're short on time. Their security just got a bump.","Let's get a move on, shall we? Time is wasting.","You will receive full treatment later. For now, I must ask you to be at your best.","Let me be clear: If you sold us out, you'd best walk right back into that cell.","We'll do a debrief of this later. Let's make sure we get you out of here alive."}},
		[T_EVENT.BAD_ESCAPE] = 			{T_PROB.p_badescape,{"Unsatisfactory. We've trained to be better than this.","We must try harder next time.","I expect a full evaluation on the ways we could have improved our performance here."}},
		[T_EVENT.GOOD_ESCAPE] = 			{T_PROB.p_goodescape,{"Good show, team. Let's not get cocky.","Well done, everyone. If we keep this up, we may actually have a chance.","Not bad. To think all that training I invested in is actually paying off for a change.","Let's get back now. You've earned your rest."}},
		[T_EVENT.BLOODY_MISSION] = 		{T_PROB.p_bloodymission,{"This was brutal, perhaps unnecessarily so.","A bloody mess, that's what this was. Perhaps we could try to keep things a little cleaner next time?","The cleanup fees will be a nightmare, I can tell.","They are the enemy, and today, we had to treat them as such."}},
		[T_EVENT.ABANDONING_OTHER] = 	{T_PROB.p_abandonedother,{"Unfortunate.","A mercy kill may have been kinder, but we don't have that luxury.","We'll prioritise detention facilities when we can. It's the best we can do.","I hate to leave an agent behind, but we have no other choice.","This has weakened our team. Let's try to pick up the pace."}},
		[T_EVENT.OW_INTERVENTION] = 		{T_PROB.p_savefromow,{"If you want something done, do it yourself.","Don't just stand there, find cover!","Don't be so sloppy. They nearly had you.","Don't let yourself be compromised again. We need all hands on deck.","Be more careful next time."}},
		[T_EVENT.SAVED_FROM_OW] = 		{T_PROB.p_ow_saved,{"",}},
		[T_EVENT.AGENT_DEATH] = 		nil, -- Central already has reactions to this
	},
-------------------	
	},


------------

}

return DLC_STRINGS
