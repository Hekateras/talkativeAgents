local array = include( "modules/array" )
local util = include( "modules/util" )
local mathutil = include( "modules/mathutil" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include( "sim/abilities/abilityutil" )
local unitdefs = include("sim/unitdefs")

local speechdefs = include( "sim/speechdefs" )

local EVENT_HIJACK = 19
local EV_UNIT_HIT = 57
local TRG_SAFE_LOOTED = 66

local EV_ATTACK_GUN_KO = 1008
local EV_HEALER = 1009
local EV_SHOOT_CAMERA = 1010
local EV_SHOOT_DRONE = 1011 

local EV_PARALYZER = 1012
local EV_STIM_SELF = 1013
local EV_STIM_OTHER = 1014
local EV_SELF_STIMMED = 1015
local EV_STIMMED_BY = 1016
local EV_WAKE = 1017
local EV_AWAKENED = 1018

local EV_EXEC_TERMINAL = 1019
local EV_DEVICE_LOOTED = 1020

local EV_RESCUED_OTHER = 1021
local EV_MISSION_BAD = 1022
local EV_MISSION_GOOD = 1023
local EV_MISSION_BLOODY = 1024
local EV_ABANDONED_AGENT = 1025

local EV_SET_SHOCKTRAP = 1026
local EV_AGENT_DEATH = 1027
local EV_OW_INTERVENTION = 1028
local EV_SELECTED = 1029
local EV_STABILISING = 1030 --unused for now
local EV_RESELECTED = 1031 -- on rewinds

-- guard event types! -- 
local EV_GUARD_ONELINER = 2000
local EV_GUARD_BANTER = 2001
local EV_GUARD_BANTER_HUNTING = 2002
-- local EV_GUARD_BEGGING = 2002

local EV_MONSTER_MID2 = 2003
local EV_MONSTER_MID2_ESCORTSFIXED = 2004

--(simdefs.TRG_LAST_WORDS = 73)

local TRANSISTOR_SWORD_DEF = {
	name = " UNKNOWN ",
	profile_anim = "portraits/turret_portrait",
	profile_build = "portraits/transistor_sword_face",
}

local objectives = {
["TERMINAL"] = true, ["checkGuardDistance"] = true, ["checkNoGuardKill"] = true, ["followHeatSig"] = true, ["followAccessCard"] = true,
 ["CEO"] = true, 
 ["VAULT-LOOTOUTER"] = true,
 ["BOUGHT"] = true, ["NANOFAB"] = true,
 ["TOPGEAR"] = true, 
 ["USE_TERMINAL"] = true}

local doNotSkip = { 
	[57] = true, --EV_UNIT_HIT
	[102] = true, --EV_UNIT_HEAL
	[1022] = true, --EV_MISSION_BAD
	[1023] = true, --EV_MISSION_GOOD
	[1024] = true, --EV_MISSION_BLOODY
	[1025] = true, --EV_ABANDONED_AGENT
	[1027] = true, --EV_AGENT_DEATH
	[1029] = true, --EV_SELECTED
	[73] = true, --surrender
 } 

local function getMMTechExpoResult(sim)
--this is basically copypasted from MM's Tech Expo for the purposes of determining mission success a bit earlier
	if not sim.totalTopGear then
		return false
	end
	local not_stolen = {}
	for i, unit in pairs(sim:getAllUnits()) do
		if unit:hasTag("MM_topGearItem") then
			local stolen_item = true
			local owner = unit:getUnitOwner()
			local owner_cell = owner and owner:getLocation() and sim:getCell(owner:getLocation())
			if owner == nil then
				if owner_cell ~= nil then --on the floor. items sold at nanofab are ownerless but also cell-less
					stolen_item = false
				end
			elseif owner then
				if owner:getPlayerOwner() == sim:getPC() then
					if not owner:getTraits().isAgent then
						stolen_item = false
					elseif owner_cell and not owner_cell.exitID then
						stolen_item = false
					end
				else
					stolen_item = false
				end
			end
			if stolen_item == false then
				table.insert(not_stolen, unit )
			end
		end
	end		
	local stolen = sim.totalTopGear -(#not_stolen)
	if stolen > 0 then
		return true
	else
		return false
	end
end

local function mid2MonsterComment( sim, evType, agentID, speaker, escapingUnits )
	-- have Monster comment on whether or not you're stealing his gun. if not applicable, run the normal comment.
	-- check for Escorts Fixed
	local monster = nil
	local stolenGun = nil
	for i, unit in pairs(escapingUnits) do
		if unit:getTraits().monst3rUnit and unit:getUnitData().agentID then
			if not unit:isKO() then
				monster = unit
			end
		else
			for k, item in pairs(unit:getChildren()) do
				if item:getUnitData().id == "item_monst3r_gun" then
					stolenGun = true
				end
			end
		end
	end
	
	if monster and stolenGun then
		-- too lazy to check if mid2-monster is permanently part of agency so let's do this as a proxy
		local isTempMonster = true
		local bonus_skill = 0
		if monster._skills then
			for i,skill in ipairs(monster._skills) do
				if (skill:getCurrentLevel() > 1) then
					bonus_skill = bonus_skill + 1
				end
			end
		end
		if bonus_skill > 2 then
			isTempMonster = false
		end
		if isTempMonster == true then
			evType = EV_MONSTER_MID2
			speaker = monster
			agentID = monster:getUnitData().agentID		
			if unitdefs.lookupTemplate("ef_pilfer") then
				evType = EV_MONSTER_MID2_ESCORTSFIXED
			end
		end
	end
	
	return evType, agentID, speaker		
end

local function Monster_stealback( sim )
	local sound = "SpySociety/HUD/gameplay/HUD_ItemStorage_PutIn"
	local delay = 1
	sim:dispatchEvent( simdefs.EV_WAIT_DELAY, delay * cdefs.SECONDS )
	sim:dispatchEvent( simdefs.EV_PLAY_SOUND, "SpySociety/HUD/gameplay/HUD_ItemStorage_PutIn" )
	sim:dispatchEvent( simdefs.EV_WAIT_DELAY, delay * cdefs.SECONDS )
end

local function emitHonk( sim, goose, seedfriendly ) --seedfriendly is a bool for UI calls that shouldn't mess with seed generation/rewinds
		local sound = "goose/goosesfx/honk"
		local x0, y0 = goose:getLocation()
		sim:emitSound( { path = sound, range = 0 }, x0, y0, nil )
		local delay = 0.2--sim:nextRand(0.2,0.4)
		if seedfriendly then	
			sim:dispatchEvent( simdefs.EV_WAIT_DELAY, delay * cdefs.SECONDS )
			sim:emitSound( { path = sound, range = 0 }, x0, y0, nil )
			-- log:write("seedfriendly honk")
		else
			if sim:nextRand() < 0.5 then
				for i=1, (sim:nextRand(1,2)) do
					sim:dispatchEvent( simdefs.EV_WAIT_DELAY, delay * cdefs.SECONDS )
					sim:emitSound( { path = sound, range = 0 }, x0, y0, nil )
				end
			end
		end
end

local function onSelectedLine( script, sim, abilityOwner, self )
	local level = include( "sim/level" )

    local userUnit = self.abilityOwner
    if userUnit == nil then
        return
    end	
	
	local RightAgent = false
	script:waitFor( { uiEvent = level.EV_UNIT_SELECTED, 
		fn = function( sim, unitID )
			if userUnit:isValid() and unitID == userUnit:getID() then
				RightAgent = true
			end
			return userUnit:isValid() and unitID == userUnit:getID()
		end } )
	
	self.selectedCount = self.selectedCount or 1 -- first agent this will trigger for is the one auto-selected. They might be saying a starting oneliner so we want this to trigger later, and the result is nicer than just adding a delay
	local agentDef = userUnit:getUnitData()
	if RightAgent and ( self.selectedCount > 1 ) and not userUnit:getTraits().alreadySelected then
		local agent = agentDef.agentID
		agent = self.checkAgentID( agent ) --reassign agentID if necessary
		local evType = EV_SELECTED
		
		if STRINGS.alpha_voice.AGENT_ONELINERS[ agent] ~= nil then	
			local speechData = STRINGS.alpha_voice.AGENT_ONELINERS[ agent][evType ]
			if speechData ~= nil then		
				local p = speechData[1]
				p = self.checkPMultiplier( sim, p, evType )
				if self.rand <= p then
					local choice = speechData[2]
					local speech = choice[math.floor(self.rand*#choice)+1]
					
					-- REWOUND ONELINERS --
					if sim:getTags().justRewound and STRINGS.alpha_voice.AGENT_ONELINERS[ agent ][ EV_RESELECTED ] then
						local new_speechData = STRINGS.alpha_voice.AGENT_ONELINERS[ agent ][ EV_RESELECTED ]
						local new_choice = new_speechData[2]
						local new_speech = new_choice[math.floor(self.rand*#new_choice)+1]
						if new_speech then
							speech = new_speech
						end
					end
					
					local messageType = "newOperatorMessage"
					if agentDef.agentID == "transistor_red" then
						agentDef = TRANSISTOR_SWORD_DEF
					end
					
					local anim = agentDef.profile_anim
					local build = agentDef.profile_anim
					if agentDef.profile_build then
						build = agentDef.profile_build
					end		
					
					local text =  {{							
						text = speech,
						anim = anim,
						build = build,
						name = agentDef.name,
						timing = self.message_time,
						voice = nil,
					}}	
					
					if not userUnit:isKO() then
					
						script:queue( { type="clearOperatorMessage" } )
						script:queue( 0.5*cdefs.SECONDS )
						script:queue( { script=text, type=messageType, doNotQueue=true } ) 
						-- log:write("oneliner for" .. agentDef.name )
						if agent == "mod_goose" then
							emitHonk(sim, userUnit, true)
						end
					end
					userUnit:getTraits().alreadySelected = true
				end
			end
		end
	else
		self.hook = sim:getLevelScript():addHook( "alpha_voice_UNIT_SELECTED", onSelectedLine, nil, self.abilityOwner, self )
		
	end
	self.selectedCount = self.selectedCount + 1
	
end
	
local alpha_voice =
{
	canUseAbility = function( self, sim, abilityOwner, abilityUser )
		if abilityOwner:isKO() then 
			return false
		end 
		if abilityOwner:isDead() then 
			return false
		end 
		return true
	end,

	name = STRINGS.ITEMS.AUGMENTS.CENTRALS,
	getName = function( self, sim, unit )
		return self.name
	end,
	
	onSpawnAbility = function( self, sim, unit )
	    self.abilityOwner = unit
	--      sim:addTrigger( simdefs.TRG_OPEN_DOOR, self )			-- left for a test/example purpose if needed
		sim:addTrigger( simdefs.TRG_SAFE_LOOTED, self )
	--	sim:addEventTrigger( simdefs.EV_UNIT_SPEAK, self )		-- example
		sim:addEventTrigger( simdefs.EV_UNIT_START_SHOOTING, self )
		sim:addEventTrigger( simdefs.EV_UNIT_MELEE, self )
		sim:addEventTrigger( simdefs.EV_UNIT_HIT, self )
		sim:addEventTrigger( simdefs.EV_UNIT_HEAL, self )
		sim:addEventTrigger( simdefs.EV_UNIT_USECOMP, self )
		sim:addEventTrigger( simdefs.EV_UNIT_WIRELESS_SCAN, self )
		sim:addEventTrigger( simdefs.EV_UNIT_INTERRUPTED, self )
		sim:addEventTrigger( simdefs.EV_UNIT_PEEK, self )
		sim:addEventTrigger( simdefs.EV_UNIT_OVERWATCH, self )
		sim:addEventTrigger( simdefs.EV_UNIT_OVERWATCH_MELEE, self )
		sim:addEventTrigger( simdefs.EV_UNIT_STOP_WALKING, self )
		sim:addEventTrigger( simdefs.EV_UNIT_START_PIN, self )		-- unused in game --Not anymore :)
		sim:addEventTrigger( simdefs.EV_UNIT_INSTALL_AUGMENT, self )	-- for installing augments
		sim:addEventTrigger( simdefs.EV_CLOAK_IN, self )		-- for activating cloak
		sim:addEventTrigger( simdefs.EV_UNIT_GOTO_STAND, self )		-- for Prism's disguise	
		sim:addEventTrigger( simdefs.EV_UNIT_RESCUED, self ) -- for rescuing other agent from detention cell
		sim:addEventTrigger( simdefs.EV_UNIT_USEDOOR_PST, self ) -- for shock trap line
		sim:addTrigger( simdefs.TRG_MAP_EVENT, self ) -- for exiting mission
		sim:addTrigger( simdefs.TRG_UNIT_KILLED, self ) -- for reaction to agent death
		sim:addTrigger( simdefs.TRG_START_TURN, self )
		sim:addTrigger( simdefs.TRG_UNIT_WARP, self ) -- for hostage
		sim:addTrigger( simdefs.TRG_LAST_WORDS, self ) -- for Surrender ability, unused otherwise
		self.hook = sim:getLevelScript():addHook( "alpha_voice_UNIT_SELECTED", onSelectedLine, nil, self.abilityOwner, self )
		self.rand = sim:nextRand() --move this to onSpawn so it doesn't affect rewinds
		self.message_time = sim:getParams().difficultyOptions.talkativeagents_messagetime or 3
		
		

	end,
        
	onDespawnAbility = function( self, sim, unit )
	--      sim:removeTrigger( simdefs.TRG_OPEN_DOOR, self )
		sim:removeTrigger( simdefs.TRG_SAFE_LOOTED, self )
	--	sim:removeEventTrigger( simdefs.EV_UNIT_SPEAK, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_START_SHOOTING, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_MELEE, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_HIT, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_HEAL, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_USECOMP, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_WIRELESS_SCAN, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_INTERRUPTED, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_PEEK, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_OVERWATCH, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_OVERWATCH_MELEE, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_STOP_WALKING, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_START_PIN, self )		-- unused in game --Not anymore :)
		sim:removeEventTrigger( simdefs.EV_UNIT_INSTALL_AUGMENT, self )		-- for installing augments
		sim:removeEventTrigger( simdefs.EV_CLOAK_IN, self )			-- for activating cloak
		sim:removeEventTrigger( simdefs.EV_UNIT_GOTO_STAND, self )		-- for Prism's disguise
		sim:removeEventTrigger( simdefs.EV_UNIT_RESCUED, self )
		sim:removeEventTrigger( simdefs.EV_UNIT_USEDOOR_PST, self )
		sim:removeTrigger( simdefs.TRG_MAP_EVENT, self )
		sim:removeTrigger( simdefs.TRG_UNIT_KILLED, self )
		sim:removeTrigger( simdefs.TRG_START_TURN, self )
		sim:removeTrigger( simdefs.TRG_UNIT_WARP, self )
		sim:removeTrigger( simdefs.TRG_LAST_WORDS, self ) -- for Surrender ability, unused otherwise
		sim:getLevelScript():removeHook( self.hook )
	    self.abilityOwner = nil
		self.selectedCount = nil
		self.rand = nil
		self.message_time = nil
		
	end,

	checkAgentID = function( agent )
		if agent == 99 then					-- last mission's Monster to starting Monster 
			agent = 100;
		elseif agent == 107 then 				-- last mission's Central to starting Central 
			agent = 108;
		elseif agent == 230 then	--SAA compatibility stuff >_>
			agent = 1 --decker
		elseif agent == 232 then
			agent = 2 --shalem
		elseif agent == 234 then
			agent = 3 --xu
		elseif agent == 233 then
			agent = 4 --banks
		elseif agent == 231 then
			agent = 5 --maria
		elseif agent == 235 then
			agent = 6 --nika
		elseif agent == 236 then
			agent = 7 --sharp
		elseif agent == 237 then
			agent = 8 --prism
		end
		return agent
	end,
	
	checkPMultiplier = function( sim, p_value_old, evType )
		local p_mod = sim:getParams().difficultyOptions.talkativeagents_multiplier
		local evType = evType or 0
		-- log:write("LOG talkative agents checking P for evType "..tostring(evType))
		local p_value = p_value_old
		if p_mod ~= nil then
			p_value = p_value_old*p_mod
		end
		if ((sim:getParams().world == "omni") or (sim:getParams().world == "omni2") ) and not doNotSkip[evType]
		then --make agent oneliners a lot less frequent in Omni missions, unless it's the Selected event type
			p_value = p_value*0.1
		end
		if p_value > 1 then
			p_value = 1
		end
		
		if (p_value_old >= 0.8) and ((sim:getParams().difficultyOptions.guaranteeCertainTriggers) or (sim:getParams().difficultyOptions.guaranteeCertainTriggers == nil)) then
			-- log:write("LOG guaranteed trigger")
			p_value = p_value_old
		end
		
		if p_mod == 1000 then
			p_value = 1 --guaranteed trigger
		end		
		-- log:write("------")
		-- log:write("LOG p multiplier")
		-- log:write(tostring(p_value_old))
		-- log:write(tostring(p_value))
		-- log:write("------")
		return p_value
	end,
	
	getGuards = function( sim, observers, getAlerted )
		local enemies = {}
		local params = sim:getParams()
		local getAlerted = getAlerted or false
		-- local enemynames = {}
		if not (#observers > 0) then return enemies end
		-- log:write("talkative guards getGuards")
		local allEnemies = sim:getNPC():getUnits()
		for k, agent in pairs( observers ) do			
			if agent and #allEnemies > 0 then
				for i, enemy in pairs(allEnemies) do
						
					local pinning, pinnee = simquery.isUnitPinning(sim, enemy)
					
					if enemy and enemy:getBrain() and sim:canUnitSeeUnit( agent, enemy ) 
					and not pinning
					and not enemy:isKO() 
					and ( not enemy:isAlerted() or ( getAlerted == true) and not enemy:isAiming() ) 
					and ( not enemy:getTraits().isDrone or not enemy:getTraits().pacifist )
					and not enemy:getTraits().omni
					and enemy:getTraits().isGuard and not enemy:getTraits().enforcer then
						table.insert( enemies, enemy )
					end
				end
			end
			if (params.difficultyOptions.talkative_cameras or (params.difficultyOptions.talkative_cameras == nil)) and (params.world ~= "omni" ) and ( sim:nextRand() <= 0.001 ) then
				for i, enemy in pairs(sim:getAllUnits()) do
					if sim:canUnitSeeUnit( agent, enemy) and enemy:getTraits().mainframe_camera and enemy:getTraits().mainframe_status == "active" then
						table.insert( enemies, enemy )
					end
				end
			end			
		end
		
		-- log:write("LOG enemynames")
		-- log:write(util.stringize(enemynames,2)) -- for debugging
		return enemies
	
	end,
	
	checkGuardType = function( chattyguard, sim )
		local guardtype = "type_guard"
		if not chattyguard:getTraits().isDrone and chattyguard:getTraits().pacifist then
			if chattyguard:getTraits().cfo or chattyguard:getTraits().vip then
				guardtype = "type_cfo"
			end
			if chattyguard:getTraits().scientist or chattyguard:getUnitData().template == "npc_scientist" then
				guardtype = "type_scientist"
			end
			if chattyguard:getTraits().investigateHackedDevices then
				guardtype = "type_sysadmin"
			end
	
			if (chattyguard:getBrain():getSituation().ClassType == simdefs.SITUATION_FLEE) or (chattyguard:getBrain():getSituation().ClassType == simdefs.SITUATION_COMBAT) then
				guardtype = "type_civilian_flee"
			end	
			
		elseif chattyguard:getTraits().isDrone then
			guardtype = "type_combatdrone" --pacifist check done in getGuards
		elseif chattyguard:isAlerted() and not chattyguard:isAiming() then --no need for params check, getGuards does that
			guardtype = "type_guard_alerted"
		elseif (chattyguard:getTraits().alerted == false) and chattyguard:getTraits().unGoosed and chattyguard:getTraits().ruffledByGoose then --Goose Protocol compatibility
			if (sim:nextRand()<=0.5) and (chattyguard:getTraits().ruffledByGoose["mod_goose_r"] or chattyguard:getTraits().ruffledByGoose["mod_goose_r_2"]) then
				guardtype = "type_seenFancyGoose" 
			else
				guardtype = "type_seenGoose"
			end
		-- else
			-- guardtype = "type_guard"
		end

		return guardtype
	end,
	
	doGuardBanter = function( sim, speaker1, speaker2, self )
		local speechQue = {}
		local message_time = 4
		local delay_time = 0.5
		local script = sim:getLevelScript()
		local dialogues = STRINGS.alpha_voice.GUARDS.BANTERS
		if speaker1:getTraits().guardType == "type_guard_alerted" then
			dialogues = STRINGS.alpha_voice.GUARDS.BANTERS_HUNTING
		end
		local banter = dialogues[sim:nextRand(1,#dialogues)]
		local guardDef1 = speaker1:getUnitData()
		local guardDef2 = speaker2:getUnitData()
		-- log:write("guard banter 1")

		for i, line in ipairs(banter) do	
			local anim = guardDef1.profile_anim
			local build = guardDef1.profile_anim
			if guardDef1.profile_build then
				build = guardDef1.profile_build
			end
			local name = guardDef1.name
			local enemy = true --start on the right
			if (i % 2 == 0) then -- for left/right display alternation
				enemy = false
				anim = guardDef2.profile_anim
				build = guardDef2.profile_anim
				if guardDef2.profile_build then
					build = guardDef2.profile_build
				end
				name = guardDef2.name
			end

			local speech = {
				{
					text = banter[i],
					anim = anim,
					build = build,
					name = name,
					timing = (self.message_time+1),
					enemy = enemy,				
				}
			}
			table.insert(speechQue, speech)		
		end
		-- do the banter!

		script:queue( delay_time*cdefs.SECONDS )
		for i,que in ipairs(speechQue)do

			if que[1].enemy then
				script:queue( { body=que[1].text, header=que[1].name, type="enemyMessage", 
					profileAnim=que[1].anim,
					profileBuild=que[1].build,
				} )	
				script:queue( (self.message_time+1)*cdefs.SECONDS )					
				script:queue( { type="clearEnemyMessage" } )
		else
				script:queue( { script=que, type="newOperatorMessage" } )        		
			end        	
		end	
		sim.chattyGuards = sim:getTurnCount()
		
	end,
	
	findBuddy = function( guard, enemies )
		local closestRange = math.huge
		local closestUnit = nil
		local x0, y0 = guard:getLocation()
		for i, unit in pairs(enemies) do
			if unit ~= guard then
				local x1, y1 = unit:getLocation()
				if x1 then
					local range = mathutil.distSqr2d( x0, y0, x1, y1 )
					if range < closestRange then
						closestRange = range
						closestUnit = unit
					end
				end
			end
		end
	return closestUnit, math.sqrt( closestRange )
	end,

	onEventTrigger = function( self, sim, evType, evData, before )	
		local script = sim:getLevelScript()
		local agentDef = self.abilityOwner:getUnitData()

	-- Pinning block:	
	
		if evType == simdefs.EV_UNIT_STOP_WALKING and (evData.unit == self.abilityOwner or evData.unitID == self.abilityOwner:getID()) and simquery.isUnitPinning( sim, evData.unit ) and not before then
			local pinning, pinnee = simquery.isUnitPinning( sim, evData.unit )
			if pinnee:getPlayerOwner() == sim:getNPC() then
				sim:dispatchEvent( simdefs.EV_UNIT_START_PIN, evData )
			end
		end
	
	-- Block for 'active' events(being executor of action or healing etc):	

	if (evData.unit == self.abilityOwner or evData.unitID == self.abilityOwner:getID()) and not evData.cancel and before then 	
			if not self.abilityOwner:isKO() then	
				-- log:write("EVTYPE: ".. tostring(evType))
				-- log:write("LOG: active event block")
				if evType == simdefs.EV_UNIT_START_SHOOTING  then
					local weaponUnit = simquery.getEquippedGun( self.abilityOwner )
					local targetUnit = sim:getUnit(evData.targetUnitID)
					if targetUnit == nil then return end
					if weaponUnit and weaponUnit:getTraits().canSleep then
						evType = EV_ATTACK_GUN_KO;				-- custom number added for shooting Darts	
						if targetUnit:isAiming() and not simquery.isUnitUnderOverwatch(self.abilityOwner) then
							for i, unit in pairs(sim:getPC():getUnits()) do
								if unit:getUnitData().agentID and unit ~= self.abilityOwner and sim:canUnitSeeUnit( targetUnit, unit ) then
									evType = EV_OW_INTERVENTION
								end
							end
						end
					elseif targetUnit:getTraits().mainframe_camera then
						evType = EV_SHOOT_CAMERA;				-- custom for shooting cameras
					elseif targetUnit:getTraits().isDrone then
						evType = EV_SHOOT_DRONE					-- custom for shooting drones
					elseif targetUnit:getTraits().isGuard then
						evType = simdefs.EV_UNIT_START_SHOOTING
						if targetUnit:isAiming() and not simquery.isUnitUnderOverwatch(self.abilityOwner) then
							for i, unit in pairs(sim:getPC():getUnits()) do
								if unit:getUnitData().agentID and unit ~= self.abilityOwner and sim:canUnitSeeUnit( targetUnit, unit ) then
									evType = EV_OW_INTERVENTION
								end
							end
						end
						if weaponUnit:getTraits().canTag then
							evType = 0
						end						
					end
				elseif evType == simdefs.EV_UNIT_MELEE then
					local targetUnit = evData.targetUnit
					-- log:write(util.stringize(targetUnit,2))
					if targetUnit:isAiming() and not simquery.isUnitUnderOverwatch(self.abilityOwner) then
						evType = EV_OW_INTERVENTION --can't check for LOS here, as LOS is refreshed in melee.lua before the event is dispatched
					end
				elseif evType == simdefs.EV_UNIT_WIRELESS_SCAN and evData.hijack then	-- redirects Int's wireless hijack
					evType = EVENT_HIJACK
				elseif evType == simdefs.EV_UNIT_USECOMP then
					if evData.targetID ~= nil then
						local targetUnit = sim:getUnit(evData.targetID)
						if targetUnit:hasTag("detention_processor") then	
							if agentDef.agentID ~= nil then
								sim.rescuer = agentDef -- use for EV_UNIT_RESCUED
							end
						end
						if targetUnit:getTraits().mainframe_console and targetUnit:getTraits().cpus > 0 and not targetUnit:hasTag("detention_processor") then
							evType = EVENT_HIJACK		-- use console
						else evType = 0
						end					
					else evType = 0
					end	
				elseif evType == simdefs.EV_UNIT_HEAL then		-- injection event
					if evData.revive then
						if not evData.target:isDead() then	
							evType = EV_WAKE		-- raise other from KO				
						else 
							evType = EV_HEALER		-- revive fallen agent	
							if evData.target:getTraits().isDying and sim.stimmingDeadAgent then
								evType = EV_STABILISING
								log:write("LOG event stabilising bleedout")
							end
						end								
					elseif evData.target:getTraits().isGuard then
						evType = EV_PARALYZER			-- custom number for palaryzers	
					elseif evData.target == evData.unit then
						evType = EV_STIM_SELF	
					else 
						evType = EV_STIM_OTHER
					end
				elseif evType == simdefs.EV_UNIT_RESCUED and evData.unit:getUnitData().agentID and sim.rescuer then -- make sure it's an agent rescuing an agent and not prisoner, etc.
					evType = EV_RESCUED_OTHER	
				elseif evType == simdefs.EV_UNIT_USEDOOR_PST and evData.unitID then --this should only work when setting trap but not when disarming it (if disarmed, trap is already nil by the time trigger is given
					local trapper = sim:getUnit(evData.unitID)
					local x0, y0 = trapper:getLocation()
					for _, targetUnit in pairs( sim:getAllUnits() ) do
						local x1, y1 = targetUnit:getLocation()
						if x1 == x0 and y1 == y0 and targetUnit:getTraits().trap then
							evType = EV_SET_SHOCKTRAP
						end
					end
				elseif evType == simdefs.EV_UNIT_GOTO_STAND then
					if evData.unit:getTraits().walk == false then
						evType = 0
					end
				elseif evType == simdefs.EV_UNIT_HIT then
					if sim:getTags().deliveringFinalWords then
						log:write("TA: delivering final words... skipping ouch oneliner")
						evType = 0
					end
				end
				if agentDef.agentID ~= nil then 
					local agent = agentDef.agentID	
					agent = self.checkAgentID( agent ) --reassign agentID if necessary
					
					if evType == EV_RESCUED_OTHER then -- opening detention cell
						agentDef = sim.rescuer
						agent = sim.rescuer.agentID -- if rescue, we want the agent who opened the doors to speak, not (just) the rescuee
						agent = self.checkAgentID( agent )
					end
					
					if STRINGS.alpha_voice.AGENT_ONELINERS[ agent] ~= nil then		
						local speechData = STRINGS.alpha_voice.AGENT_ONELINERS[ agent][evType ]				
						if speechData ~= nil then			
							local p = speechData[1]
							p = self.checkPMultiplier( sim, p, evType )
							if sim:nextRand() <= p then
						   		local choice = speechData[2]
								local speech = choice[math.floor(sim:nextRand()*#choice)+1]	
								
								-- some logwrites for now, don't mind me - Hek
								-- log:write("LOG: oneliner")
								-- log:write(util.stringize(agentDef.name,2))
								-- log:write(util.stringize(speech,2))
								-- log:write(util.stringize(evType,2))
								
								local messageType = "newOperatorMessage"
								if agentDef.agentID == "transistor_red" then
									agentDef = TRANSISTOR_SWORD_DEF
									-- messageType = "enemyMessage"
									-- script:queue( { type="clearEnemyMessage" } )
								end
								
								local anim = agentDef.profile_anim
								local build = agentDef.profile_anim
								if agentDef.profile_build then
									build = agentDef.profile_build
								end
								
								local text =  {{							
									text = speech,
									anim = anim,
									build = build,
									name = agentDef.name,
									timing = self.message_time,
									voice = nil,
								}}	

								script:queue( { type="clearOperatorMessage" } )
								script:queue( 0.5*cdefs.SECONDS )								
								script:queue( { script=text, type=messageType, doNotQueue=true } ) 
								if evData.unit and (agent == "mod_goose") then
									emitHonk(sim, evData.unit)
								end
								--script:queue( 3*cdefs.SECONDS )
								--script:queue( { type="clearOperatorMessage" } ) -- it autoclears after "timing =3"
							end
						end
					end
				end
			end
		end


	-- Block for 'passive' events(being target of healing), triggers after, message on the right:

		if (evData.target == self.abilityOwner or evData.targetID == self.abilityOwner:getID()) and not before then 
			if evType == simdefs.EV_UNIT_HEAL and not before then
				if not evData.revive then			-- if it's Stim or Defib
					if evData.target ~= evData.unit then
						evType = EV_STIMMED_BY		-- by other agent
					else 	evType = EV_SELF_STIMMED	-- by self						
					end
				elseif not evData.target:isDead() then	
					evType = EV_AWAKENED			-- raised from KO
				elseif evData.target:getTraits().isDying and
				sim.stimmingDeadAgent then
					evType = 0
					-- log:write("LOG dying agent stimmed")
				end	--default to EV_UNIT_HEAL
				if agentDef.agentID ~= nil then 
					local agent = agentDef.agentID	
					agent = self.checkAgentID( agent )

					if STRINGS.alpha_voice.AGENT_ONELINERS[ agent] ~= nil then		
						local speechData = STRINGS.alpha_voice.AGENT_ONELINERS[ agent][evType ]				
						if speechData ~= nil then			
							local p = speechData[1]
							p = self.checkPMultiplier( sim, p, evType )
							if sim:nextRand() <= p then
								local choice = speechData[2]
								local speech = choice[math.floor(sim:nextRand()*#choice)+1]		

								local messageType = "newOperatorMessage"
								if agentDef.agentID == "transistor_red" then
									agentDef = TRANSISTOR_SWORD_DEF
									-- messageType = "enemyMessage"
									-- script:queue( { type="clearEnemyMessage" } )
								end
					
								local anim = agentDef.profile_anim
								local build = agentDef.profile_anim	-- if there no build then use default one from anim
								if agentDef.profile_build then		
									build = agentDef.profile_build	-- either way use build as a skin
								end								
								local name = agentDef.name
								if evType == EV_SELF_STIMMED then	-- to have speech pop-up on the left
									local text =  {{								
									text = speech,
									anim = anim,
									build = build,
									name = name,
									timing = self.message_time,
									voice = nil,
									}}
									
									script:queue( { type="clearOperatorMessage" } )
									script:queue( 0.5*cdefs.SECONDS )			
									script:queue( { script=text, type=messageType, doNotQueue=true } )
									if agent == "mod_goose" then
										emitHonk(sim, evData.unit)
									end									
								else					-- to have speech pop-up on the right						
									script:queue( { body = speech, header= name, type="enemyMessage", 
											profileAnim= anim,
											profileBuild= build,									
											} )
									script:queue( self.message_time*cdefs.SECONDS )			-- time before clear, 3 seconds, as timing
									script:queue( { type="clearEnemyMessage" } )	-- no autoclear for those eh	
									if agent == "mod_goose" then
										emitHonk(sim, evData.unit)
									end
								end
							end
						end
					end
				end
			end			
		end
	-- BLOCK END	
	
	-- block for special guard reaction oneliners
	if not sim:getParams().difficultyOptions.chattyguards or (sim:getParams().difficultyOptions.chattyguards and sim:getParams().difficultyOptions.chattyguards == true) then
	
	
	if (evData.unit == self.abilityOwner or evData.unitID == self.abilityOwner:getID()) and not evData.cancel and before then 
		local guardBegging = false
		local targetUnit = nil
		if evType == simdefs.EV_UNIT_START_SHOOTING  then
			local weaponUnit = simquery.getEquippedGun( self.abilityOwner )
			targetUnit = sim:getUnit(evData.targetUnitID)
			if weaponUnit and targetUnit then
				local traits = targetUnit:getTraits()
				
				if traits and traits.isGuard and not traits.omni
				and not traits.enforcer and not traits.isDrone
				and not weaponUnit:getTraits().canTag then
					guardBegging = true
				end
			end
		elseif evType  == simdefs.EV_UNIT_MELEE then
			targetUnit = evData.targetUnit
			local traits = targetUnit:getTraits()
			if traits and traits.isGuard and not traits.omni
			and not traits.enforcer and not traits.isDrone then
				guardBegging = true
			end
			
		end
		
		if ( guardBegging == true ) and targetUnit then
			local guardDef = targetUnit:getUnitData()
			local anim = guardDef.profile_anim
			local build = guardDef.profile_anim	-- if there no build then use default one from anim
			if guardDef.profile_build then		
				build = guardDef.profile_build	-- either way use build as a skin
			end								
			local name = guardDef.name
			local speechData = STRINGS.alpha_voice.GUARDS.BEGGING
			
			if #speechData ~= nil then
				local p = speechData[1]
				p = self.checkPMultiplier( sim, p )
				-- commented out for now, wasn't working well
				-- if sim:nextRand() <= p then
					-- local choice = speechData[2]
					-- local speech = choice[math.floor(sim:nextRand()*#choice)+1]

						-- script:queue( 1*cdefs.SECONDS )
						
						-- script:queue( { 
						-- body= speech, 
						-- header= name, 
						-- type="enemyMessage", 
						-- profileAnim= anim,
						-- profileBuild= build,
						-- } )
						
						-- script:queue( 4*cdefs.SECONDS )			-- time before clear, 3 seconds, as timing
						-- script:queue( { type="clearEnemyMessage" } )				
				
				-- end			
			end		
		end	
	end
	-- block end

	end -- params end
	--end of guard oneliner block
	end,

	-- trigger

	onTrigger = function( self, sim, evType, evData  )	
		local script = sim:getLevelScript()
		local agentDef = self.abilityOwner:getUnitData()
		
		local function isKO( unit )
			return unit:isKO()
		end

		local function isNotKO( unit )
			return not unit:isKO()
		end
		
		-- Block for exit teleportation oneliners
		if evType == simdefs.TRG_MAP_EVENT and evData.units and evData.event == simdefs.MAP_EVENTS.TELEPORT then

			if sim:getParams().situationName == "mid_1" then
				return
			end
			evType = 0
			local fieldUnits, escapingUnits = simquery.countFieldAgents( sim )
			local VIP_escape = false
			local gotTechExpoItem = getMMTechExpoResult(sim)

			-- escapingUnits = evData.units
			if escapingUnits and #escapingUnits > 0 then
				local agent = nil
				local speaker = escapingUnits[ sim:nextRand(1, #escapingUnits ) ]
				local someone_awake = false --super edge case
				for  k, unit in pairs(escapingUnits) do
					if not unit:isKO() then
						someone_awake = true
					end
					if unit:hasTag("MM_distressCallAgent") then --for MM
						VIP_escape = true
					end
				end
				if someone_awake and speaker:isKO() then
					repeat
						speaker = escapingUnits[ sim:nextRand(1, #escapingUnits ) ] -- this should be returned eventually since there had to be someone to activate the escape ability... right? ^^;;
					until not speaker:isKO()
				end
				if speaker:getUnitData().agentID then
					agent = speaker:getUnitData().agentID
				end
				
				if agent and not sim.alreadySpoken then -- every agent has this ability  but it should only trigger once per escape
				
					agent = self.checkAgentID( agent )
				
				-- check how well the mission went!
				
					local casualties = nil
					local finalescape = nil
					local bloodymission = nil
					local success = true
					-- log:write("LOG2")
					-- log:write(util.stringize(sim:getLevelScript().hooks,3))
					--for vanilla missions, we can check for the presence of various mission hook functions as a proxy for objective completion.
					local missionhooks = script.hooks
					for i, hook in pairs(missionhooks) do
						if objectives[hook.name] then
							success = false
						end
						
						-- if hook.name == "TERMINAL" or hook.name == "CEO" or hook.name == "RUN" or hook.name == "escaped" or hook.name == "VAULT-LOOTOUTER" or hook.name == "BOUGHT" or hook.name == "NANOFAB" or hook.name == "TOPGEAR" or hook.name == "USE_TERMINAL" then
							-- success = false -- super ugly check for uncompleted main objectives
						-- end
					end
					
					-- for More Missions:
					if (sim.TA_mission_success ~= nil) and (sim.TA_mission_success == false ) then
						log:write("LOG TA mission failed")
						success = false
					end
					if (VIP_escape == true) or (gotTechExpoItem == true) then --Distress Call and Tech Expo update success tag after rescuee/loot has escaped. set success to true even if rescuee is escaping right now and tag hasn't been updated yet.
						log:write("LOG TA mission successful")
						success = true
					end
					
					local isPartialEscape = array.findIf( fieldUnits, isNotKO) ~= nil
					local abandonedUnit = array.findIf( fieldUnits, isKO ) -- wounded agents still in the field
					if not isPartialEscape then
						finalescape = true
					end
					local injuredUnit = array.findIf( escapingUnits, isKO )
					-- check for "dead" agents who are also in the elevator
					
					if injuredUnit then 
						casualties = true 
					end
					
					if sim.permadeathkilled then --permadeath mod compatibility
						casualties = true
					end
					
					if sim:getCleaningKills() > 2 then
						bloodymission = true
					end
					
					-- actually decide what type of reaction to show
					if finalescape then
						if not success or casualties then 
							evType = EV_MISSION_BAD
						end

						if success and not casualties then 
							evType = EV_MISSION_GOOD
						end
						
						if bloodymission and sim:nextRand() <= 0.7 then 
							evType = EV_MISSION_BLOODY
						end
						
						if abandonedUnit then
							evType = EV_ABANDONED_AGENT --takes precedence
						end
						
					end
					
					if sim:getParams().situationName == "mid_2" then
						log:write("situation is mid2")
						evType, agent, speaker = mid2MonsterComment( sim, evType, agent, speaker, escapingUnits )
					end				

					if STRINGS.alpha_voice.AGENT_ONELINERS[ agent] ~= nil then		
							local speechData = STRINGS.alpha_voice.AGENT_ONELINERS[ agent][evType ]	
							local agentDef = speaker:getUnitData()
							if speechData ~= nil then				
								local p = speechData[1]
								p = self.checkPMultiplier( sim, p, evType )
								if sim:nextRand() <= p then
									local choice = speechData[2]
									local speech = choice[math.floor(sim:nextRand()*#choice)+1]
									
									local anim = agentDef.profile_anim
									local build = agentDef.profile_anim
									if agentDef.profile_build then
										build = agentDef.profile_build
									end

									script:queue( { 
										body = speech, 
										header= agentDef.name, 
										type="enemyMessage", 
										profileAnim= anim,
										profileBuild= build,
									} )
									script:queue( self.message_time*cdefs.SECONDS )			-- time before clear, 3 seconds, as timing
									script:queue( { type="clearEnemyMessage" } )
									
									-- local text =  {{							
										-- text = speech,
										-- anim = agentDef.profile_anim,
										-- build = agentDef.profile_build,
										-- name = agentDef.name,
										-- timing = self.message_time,
										-- voice = nil,
									-- }}					
									-- script:queue( { script=text, type="newOperatorMessage", } )
									
									sim.alreadySpoken = true
									if agent == "mod_goose" then
										emitHonk(sim, speaker)
									end
									-- log:write("LOG: oneliner")
									-- log:write(util.stringize(agent,1))
									-- log:write(util.stringize(text,1))
									if evType == EV_MONSTER_MID2_ESCORTSFIXED then
										Monster_stealback(sim )
									end
								end
							end
						end	
					
				end
				
			end
		
		end

		-- normal trigger stuff
		if (evData.unit == self.abilityOwner or evData.unitID == self.abilityOwner:getID()) and not evData.cancel then 	
			if not self.abilityOwner:isKO() then
				if evType == simdefs.TRG_SAFE_LOOTED then 
					if evData.targetUnit:getTraits().safeUnit then
						evType = TRG_SAFE_LOOTED
					elseif evData.targetUnit:getTraits().public_term then
						evType = EV_EXEC_TERMINAL		-- 
					elseif evData.targetUnit:getTraits().scanner or evData.targetUnit:getTraits().router then
						evType = EV_DEVICE_LOOTED
					else evType = 0
					end	
				end				
				if agentDef.agentID ~= nil then 
					local agent = agentDef.agentID	
					agent = self.checkAgentID( agent )
									
					if STRINGS.alpha_voice.AGENT_ONELINERS[ agent] ~= nil then		
						local speechData = STRINGS.alpha_voice.AGENT_ONELINERS[ agent][evType ]				
						if speechData ~= nil then				
							local p = speechData[1]
							p = self.checkPMultiplier( sim, p, evType )
							if sim:nextRand() <= p then
						   		local choice = speechData[2]
								local speech = choice[math.floor(sim:nextRand()*#choice)+1]		

								local messageType = "newOperatorMessage"
								if agentDef.agentID == "transistor_red" then
									agentDef = TRANSISTOR_SWORD_DEF
									-- messageType = "enemyMessage"
									-- script:queue( { type="clearEnemyMessage" } )
								end
								
								local anim = agentDef.profile_anim
								local build = agentDef.profile_anim
								if agentDef.profile_build then
									build = agentDef.profile_build
								end
								
								local text =  {{							
									text = speech,
									anim = anim,
									build = build,
									name = agentDef.name,
									timing = self.message_time,
									voice = nil,
								}}
								
								script:queue( { type="clearOperatorMessage" } )
								script:queue( 0.5*cdefs.SECONDS )								
								script:queue( { script=text, type=messageType, doNotQueue=true } )
								if agent == "mod_goose" then
									emitHonk(sim, evData.unit)
								end								
								-- log:write("LOG: oneliner")
								-- log:write(util.stringize(agent,1))
								-- log:write(util.stringize(text,1))
								--script:queue( 3*cdefs.SECONDS )
								--script:queue( { type="clearOperatorMessage" } ) -- it autoclears after "timing =3"
							end
						end
					end
				end
			end
		end
	
		-- agent reaction to agent death, message on the right
		if evType == simdefs.TRG_UNIT_KILLED and evData.unit:getUnitData().agentID and evData.unit:getTraits().corpseTemplate then
			evType = EV_AGENT_DEATH
			local units = sim:getPC():getUnits()
			local speakerunits = {}
			for _, unit in pairs(units) do
				if unit:getUnitData().agentID and not unit:isKO() then
					table.insert( speakerunits, unit )
				end
			end
			
			if #speakerunits > 0 then
			
				local speaker = speakerunits[ sim:nextRand(1, #speakerunits) ]
				local speakerDef = speaker:getUnitData()
				local agent = speakerDef.agentID
				agent = self.checkAgentID( agent )
				
				if STRINGS.alpha_voice.AGENT_ONELINERS[ agent ] ~= nil and not evData.unit:getTraits().alreadyMourned then
					local speechData = STRINGS.alpha_voice.AGENT_ONELINERS[ agent][ evType ]
					if speechData ~= nil then
						local p = speechData[1]
						p = self.checkPMultiplier( sim, p, evType )
						if sim:nextRand() <= p then
							local choice = speechData[2]
							local speech = choice[math.floor(sim:nextRand()*#choice)+1]								
									local anim = speakerDef.profile_anim
									local build = speakerDef.profile_anim	-- if there no build then use default one from anim
									if speakerDef.profile_build then		
										build = speakerDef.profile_build	-- either way use build as a skin
									end								
									local name = speakerDef.name
									
									script:queue( 3*cdefs.SECONDS )
									script:queue( { 
										body = speech, 
										header= name, 
										type="enemyMessage", 
										profileAnim= anim,
										profileBuild= build,
										} )
										script:queue( self.message_time*cdefs.SECONDS )			-- time before clear, 3 seconds, as timing
										script:queue( { type="clearEnemyMessage" } )
									evData.unit:getTraits().alreadyMourned = true
									if speaker:getUnitData().agentID == "mod_goose" then
										emitHonk(sim, speaker)
									end								
						end
					end
				end
			end
		end

	-- chatty guard block --
		if not sim:getParams().difficultyOptions.chattyguards or (sim:getParams().difficultyOptions.chattyguards and sim:getParams().difficultyOptions.chattyguards == true) then
	
	
		if evType == simdefs.TRG_START_TURN and evData:isPC() then
			local p_banter = 0.4 -- chance a banter will trigger instead of a oneliner, when both are available
			local p_banter_hunting = 0.4
			if sim.chattyGuards == nil then 
				sim.chattyGuards = sim:getTurnCount()
				-- log:write("LOG setting sim.chattyGuards")
			end
			-- log:write("talkative guards 1")
			if (sim:getTurnCount() > sim.chattyGuards) and (sim:getTrackerStage( sim:getTracker() ) < 6) then --no guard lines post 'full alert' alarm levels, no matter the settings. It's srs bsness time!
				-- This makes sure it only proccs once per turn
				-- log:write("LOG running chatty guard block!")
				
				local agents = sim:getPC():getUnits()
				local observers = {}
				for _, agent in pairs(agents) do
					if not agent:isKO() and agent:getTraits().isAgent and agent:getTraits().hasSight then
						table.insert(observers, agent)
						-- log:write("LOG observer")
						-- log:write(util.stringize(agent:getUnitData().name,1))
					end
				end

				local getAlerted = false
				if sim:getParams() and sim:getParams().difficultyOptions.chattyAlertedGuards and (sim:getParams().difficultyOptions.chattyAlertedGuards == true) then
					getAlerted = true
				end
				local enemies = self.getGuards( sim, observers, getAlerted )

				if #enemies > 0 then
					local chattyguard = enemies[sim:nextRand(1, #enemies)]
					local guardDef = chattyguard:getUnitData()
					local x1, y1 = chattyguard:getLocation()
					local buddy, range = self.findBuddy( chattyguard, enemies )
					local canSeeBuddy = false
								
					-- check what NPC type
					chattyguard:getTraits().guardType = self.checkGuardType( chattyguard, sim )
					-- if buddy and range and range < 7 then --pick someone close enough to talk to \o/
					if buddy then
						buddy:getTraits().guardType = self.checkGuardType( buddy, sim )
						if simquery.couldUnitSeeCell( sim, chattyguard, sim:getCell( buddy:getLocation() ) ) then
							canSeeBuddy = true
						end
					end

					local evType = 2000 --kind of cosmetic, we don't really need evType here...
					if buddy and (buddy:getTraits().guardType == "type_guard") and (chattyguard:getTraits().guardType == "type_guard") and (sim:nextRand() <= p_banter) and canSeeBuddy then 
						evType = 2001
						-- log:write("LOG evType 2001")
					end
					
					if buddy and (buddy:getTraits().guardType == "type_guard_alerted") and (chattyguard:getTraits().guardType == "type_guard_alerted") and (sim:nextRand() <= p_banter_hunting) and canSeeBuddy then 
						evType = 2002
					end
					
					if evType == 2001 then -- guard banter
						self.doGuardBanter( sim, chattyguard, buddy, self )
						-- log:write("guard banter coming up")
					elseif evType == 2002 then
						self.doGuardBanter( sim, chattyguard, buddy, self )
					elseif ( evType == 2000 ) and ((sim:getTrackerStage( sim:getTracker() ) < 3) or getAlerted) then -- oneliner block
					-- if hunting oneliners are on, it's fine to have oneliners at higher alarm levels, otherwise default to previous build behaviour

						local anim = guardDef.profile_anim
						local build = guardDef.profile_anim	-- if there no build then use default one from anim
						if guardDef.profile_build then		
							build = guardDef.profile_build	-- either way use build as a skin
						end								
						local name = guardDef.name
						local speechData = STRINGS.alpha_voice.GUARDS.LINES[ chattyguard:getTraits().guardType ]
						if speechData ~= nil then
							local p = speechData[1]
							p = self.checkPMultiplier( sim, p )
							if sim:nextRand() <= p then
								local choice = speechData[2]
								local speech = choice[math.floor(sim:nextRand()*#choice)+1]
						
							-- log:write("talkative guards 4")
								script:queue( 2*cdefs.SECONDS )
								
								script:queue( { 
								body= speech, 
								header= name, 
								type="enemyMessage", 
								profileAnim= anim,
								profileBuild= build,
								} )
								
								script:queue( (self.message_time+1)*cdefs.SECONDS )			-- time before clear, 3 seconds, as timing
								script:queue( { type="clearEnemyMessage" } )
								
							end
							sim.chattyGuards = sim:getTurnCount()
						end
					end
				end
		

			end
		
		end
	
		end -- param block
		-- Block for hostage response
	
	if evType == simdefs.TRG_UNIT_WARP and evData.unit:getTraits().untie_anim then -- this triggers on despawn of the hostage prop
		if sim.hostageReply == nil then
			-- log:write("log unit untie")
			local hostage = nil
			local unbinder = nil
			local units = {}
			for i, unit in pairs(sim:getPC():getUnits()) do			
				if unit:getTraits().hostage == true then
					hostage = unit -- find actual hostage unit
				elseif unit:getTraits().isAgent and not unit:isKO() then
					table.insert( units, unit )
				end
			end
			
			if hostage then 
				local buddy, range = self.findBuddy( hostage, units ) -- find closest agent, presumably the one who freed the hostage
				if buddy and range < 1.5 then 
					unbinder = buddy
				end
				
				if unbinder and unbinder:getUnitData().agentID then
				
					local agentDef = unbinder:getUnitData()
					local agent = agentDef.agentID
					agent = self.checkAgentID( agent )
					
					if STRINGS.alpha_voice.HOSTAGEQUIPS[ agent ] ~= nil then
						local speechData = STRINGS.alpha_voice.HOSTAGEQUIPS[ agent ]
						local speech = speechData[math.floor(sim:nextRand()*#speechData)+1]
						
						local messageType = "newOperatorMessage"
						local anim = agentDef.profile_anim
						local build = agentDef.profile_anim	-- if there no build then use default one from anim
						if agentDef.profile_build then		
							build = agentDef.profile_build	-- either way use build as a skin
						end								
						local name = agentDef.name						
						
						local text =  {{								
							text = speech,
							anim = anim,
							build = build,
							name = name,
							timing = self.message_time,
							voice = nil,
							}}	
													
						script:queue( { type="clearOperatorMessage" } )
						script:queue( 0.5*cdefs.SECONDS )			
						script:queue( { script=text, type=messageType, doNotQueue=true } )
						script:queue( 3*cdefs.SECONDS )
						
						if agent == "mod_goose" then
							emitHonk(sim, unbinder)
						end						
						-- sim.hostageReply = true
						
					
					end	

					sim.hostageReply = true
					local text = {{
						text = STRINGS.MISSIONS.ESCAPE.OPERATOR_HOSTAGE_CONVO1,
						anim = "portraits/central_face",
						build = "portraits/central_face",
						name = "CENTRAL",
						voice = "SpySociety/VoiceOver/Missions/Hostage/Operator_MissingCourier",
						timing = self.message_time,
						donotskip = true,
						}}
				
					script:queue( { type="clearOperatorMessage" } )
					script:queue( 0.5*cdefs.SECONDS )
					script:queue( {script=text, type="newOperatorMessage", doNotQueue=true} )
				end
			
			end		
			
		end				
	end
	
	end,
	
}

return alpha_voice