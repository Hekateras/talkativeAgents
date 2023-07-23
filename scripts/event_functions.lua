local array = include( "modules/array" )
local util = include( "modules/util" )
local mathutil = include( "modules/mathutil" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include( "sim/abilities/abilityutil" )
local unitdefs = include("sim/unitdefs")

local speechdefs = include( "sim/speechdefs" )

local T_EVENT = simdefs.TA_EVENT_TABLE.EVENTS
local T_PROB = simdefs.TA_EVENT_TABLE.PROBS

local swapAgentID = {
	[99] = 100, -- last mission's Monster to starting Monster
	[107] = 108, -- last mission's Central to starting Central
	--SAA compatibility stuff >_>
	[230] = 1, --decker 
	[232] = 2, --shalem
	[234] = 3, --xu
	[233] = 4, --banks
	[231] = 5, --maria
	[235] = 6, --nika
	[236] = 7, --sharp
	[237] = 8, --prism
	["mod_goose_2"] = "mod_goose", --goose
}

local doNotSkip = { 
	[T_EVENT.GOT_HIT] = true, --EV_UNIT_HIT
	[T_EVENT.REVIVED] = true, --EV_UNIT_HEAL
	[T_EVENT.BAD_ESCAPE] = true, --EV_MISSION_BAD
	[T_EVENT.GOOD_ESCAPE] = true, --EV_MISSION_GOOD
	[T_EVENT.BLOODY_MISSION] = true, --EV_MISSION_BLOODY
	[T_EVENT.ABANDONING_OTHER] = true, --EV_ABANDONED_AGENT
	[T_EVENT.AGENT_DEATH] = true, --EV_AGENT_DEATH
	[T_EVENT.EVENT_SELECTED] = true, --EV_SELECTED
	[T_EVENT.SURRENDER] = true, --surrender
	[T_EVENT.EV_MONSTER_MID2] = true,
	[T_EVENT.EV_MONSTER_MID2_ESCORTSFIXED] = true,
}

local TRANSISTOR_SWORD_DEF = {
	name = " UNKNOWN ",
	profile_anim = "portraits/turret_portrait",
	profile_build = "portraits/transistor_sword_face",
}
	
local function checkPMultiplier( sim, p_value_old, evType )
	local p_mod = sim:getParams().difficultyOptions.talkativeagents_multiplier
	local evType = evType or 0
	-- log:write("LOG talkative agents checking P for evType "..tostring(evType))
	local p_value = p_value_old
	if p_mod ~= nil then
		p_value = p_value_old*p_mod
	end
	if ((sim:getParams().world == "omni") or (sim:getParams().world == "omni2") ) and not doNotSkip[evType] then 
		p_value = p_value*0.1 --make agent oneliners a lot less frequent in Omni missions, unless it's the Selected event type
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
	
	return p_value
end

local function emitHonk( boardRig, goose, thread )
	local sound = "goose/goosesfx/honk"
	local x0, y0 = goose:getLocation()
	thread:unblock()
	
	local delay = 0.2--math.random(0.2,0.4)
	for i=1, math.random(1,3) do
		boardRig._world_sounds:playSound( sound, nil, x0, y0 )
		boardRig:wait( delay * cdefs.SECONDS )
	end
end

local function waitForUnitIdle( unit, boardRig, thread )
	thread:unblock()
	coroutine.yield()
	thread:waitForLocks( unit:getID() )
end

local getGuards = function( sim )
	local getAlerted = sim:getParams().difficultyOptions.chattyAlertedGuards ~= false
	local getCameras = sim:getParams().difficultyOptions.talkative_cameras ~= false and sim:getParams().world ~= "omni" and math.random() <= 0.001
	local enemies = {}
	
	for i, enemy in pairs( sim:getPC():getSeenUnits() ) do
		if enemy:getBrain()
			and not simquery.isUnitPinning(sim, enemy)
			and not enemy:isKO() 
			and ( not enemy:isAlerted() or ( getAlerted == true and not enemy:isAiming() ) ) 
			and ( not enemy:getTraits().isDrone or not enemy:getTraits().pacifist )
			and not enemy:getTraits().omni
			and enemy:getTraits().isGuard and not enemy:getTraits().enforcer then
				table.insert( enemies, enemy )
		elseif getCameras and enemy:getTraits().mainframe_camera and enemy:getTraits().mainframe_status == "active" then
			table.insert( enemies, enemy )
		end
	end
	
	return enemies
end

local function checkGuardType( chattyguard, sim )
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
		if (math.random()<=0.5) and (chattyguard:getTraits().ruffledByGoose["mod_goose_r"] or chattyguard:getTraits().ruffledByGoose["mod_goose_r_2"]) then
			guardtype = "type_seenFancyGoose" 
		else
			guardtype = "type_seenGoose"
		end
	-- else
		-- guardtype = "type_guard"
	end

	return guardtype
end
	
local function findBuddy( guard, enemies )
	local closestRange = math.huge
	local closestUnit = nil
	local x0, y0 = guard:getLocation()
	for i, unit in pairs( enemies ) do
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
end
	
local function doGuardBanter( sim, speaker1, speaker2, dialogues )
	local speechQue = {}
	local messageTime = (sim:getParams().difficultyOptions.talkativeagents_messagetime or 3) + 1
	local delay_time = 0.5
	local script = sim:getLevelScript()
	local banter = dialogues[math.random(1,#dialogues)]
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
				timing = messageTime,
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
			script:queue( messageTime*cdefs.SECONDS )					
			script:queue( { type="clearEnemyMessage" } )
		else
			script:queue( { script=que, type="newOperatorMessage" } )        		
		end        	
	end
end

local defaultHandler = function( ev, evType, evData, boardRig, hud, thread, targetUnit, showRight, isRevive )
	local sim = boardRig:getSim()
	local unit = targetUnit or evData.unit or (evData.unitID and sim:getUnit(evData.unitID))
	local agentDef = unit and unit:getUnitData()
	
	if agentDef and ( isRevive or not unit:isKO() ) and not evData.cancel then 
		local agentID = agentDef.agentID and swapAgentID[ agentDef.agentID ] or agentDef.agentID --reassign agentID if necessary
		local script = sim:getLevelScript()
		local speechData = evData.speechData
		
		if agentID and STRINGS.alpha_voice.AGENT_ONELINERS[ agentID ] then
			speechData = STRINGS.alpha_voice.AGENT_ONELINERS[ agentID ][ evType ]
		end
		
		if speechData ~= nil then			
			local p = checkPMultiplier( sim, speechData[1], evType )
			
			if math.random() <= p then
				local choice = speechData[2]
				local speech = choice[math.random(1, #choice)]	
				
				-- some logwrites for now, don't mind me - Hek
				-- log:write("LOG: oneliner")
				-- log:write(util.stringize(agentDef.name,2))
				-- log:write(util.stringize(speech,2))
				-- log:write(util.stringize(evType,2))
				
				local messageType = "newOperatorMessage"
				local messageTime = sim:getParams().difficultyOptions.talkativeagents_messagetime or 3
				if agentID == "transistor_red" then
					agentDef = TRANSISTOR_SWORD_DEF
					-- messageType = "enemyMessage"
					-- script:queue( { type="clearEnemyMessage" } )
				end
				
				local anim = agentDef.profile_anim
				local build = agentDef.profile_build or agentDef.profile_anim
				
				if not showRight then
					local text =  {{							
						text = speech,
						anim = anim,
						build = build,
						name = agentDef.name,
						timing = messageTime,
						voice = nil,
					}}	

					script:queue( { type="clearOperatorMessage" } )
					script:queue( 0.5*cdefs.SECONDS )								
					script:queue( { script=text, type=messageType, doNotQueue=true } )
				else
					script:queue( {
						body = speech,
						header= agentDef.name,
						type="enemyMessage", 
						profileAnim= anim,
						profileBuild= build,									
					} )
					
					script:queue( messageTime*cdefs.SECONDS )			-- time before clear, 3 seconds, as timing
					script:queue( { type="clearEnemyMessage" } )	-- no autoclear for those eh	
				end
				
				if evData.unit and agentID == "mod_goose" then
					emitHonk( boardRig, unit, thread )
				end
				
				return true
			end
		end
	end
end

local events = {
	[simdefs.EV_UNIT_STOP_WALKING] = function( ev, evType, evData, boardRig, hud, thread )
		local sim = boardRig:getSim()
		if simquery.isUnitPinning( sim, evData.unit ) then
			local pinning, pinnee = simquery.isUnitPinning( sim, evData.unit )
			if pinnee:getPlayerOwner() == sim:getNPC() then
				waitForUnitIdle( evData.unit, boardRig, thread )
				defaultHandler( ev, simdefs.EV_UNIT_START_PIN, evData, boardRig, hud, thread )
			end
		end
	end,
	
	[simdefs.EV_UNIT_START_SHOOTING] = function( ev, evType, evData, boardRig, hud, thread )
		local sim = boardRig:getSim()
		local unit = sim:getUnit( evData.unitID )
		local targetUnit = sim:getUnit( evData.targetUnitID )
		if unit and targetUnit then
			local weaponUnit = simquery.getEquippedGun( unit )
			
			if weaponUnit and weaponUnit:getTraits().canTag then
			
			elseif targetUnit:isAiming() and not simquery.isUnitUnderOverwatch(unit) and targetUnit:getBrain() and targetUnit:getBrain():getTarget() and targetUnit:getBrain():getTarget():getUnitData().agentID then
				defaultHandler( ev, T_EVENT.OW_INTERVENTION, evData, boardRig, hud, thread )
			elseif weaponUnit and weaponUnit:getTraits().canSleep then
				defaultHandler( ev, T_EVENT.ATTACK_GUN_KO, evData, boardRig, hud, thread )
			elseif targetUnit:getTraits().mainframe_camera then
				defaultHandler( ev, T_EVENT.SHOOT_CAMERA, evData, boardRig, hud, thread ) -- custom for shooting cameras
			elseif targetUnit:getTraits().isDrone then
				defaultHandler( ev, T_EVENT.SHOOT_DRONE, evData, boardRig, hud, thread ) -- custom for shooting drones
			elseif targetUnit:getTraits().isGuard then
				defaultHandler( ev, evType, evData, boardRig, hud, thread )
			end
		end
	end,
	
	[simdefs.EV_UNIT_MELEE] = function( ev, evType, evData, boardRig, hud, thread )
		local targetUnit = evData.targetUnit
		local unit = evData.unit
		if not targetUnit then
			return
		end
		
		if targetUnit:isAiming() and not simquery.isUnitUnderOverwatch(unit) and targetUnit:getBrain() and targetUnit:getBrain():getTarget() and targetUnit:getBrain():getTarget():getUnitData().agentID then
			defaultHandler( ev, T_EVENT.OW_INTERVENTION, evData, boardRig, hud, thread )
		else
			defaultHandler( ev, evType, evData, boardRig, hud, thread )
		end
	end,
	
	[simdefs.EV_UNIT_HIT] = function( ev, evType, evData, boardRig, hud, thread )
		if ((evData.kodamage or 0) > 0 or (evData.result or 0) > 0) and not boardRig:getSim():getTags().deliveringFinalWords then
			defaultHandler( ev, evType, evData, boardRig, hud, thread )
		end
	end,
	
	[simdefs.EV_UNIT_HEAL] = function( ev, evType, evData, boardRig, hud, thread )
		local sim = boardRig:getSim()
		local targetEv
		if evData.revive then
			if not evData.target:isDead() then	
				evType = T_EVENT.WAKE_OTHER		-- raise other from KO		
				targetEv = T_EVENT.AWAKENED_BY
			else 
				evType = T_EVENT.MEDGEL		-- revive fallen agent
				if evData.target:getTraits().isDying and sim.stimmingDeadAgent then
					log:write("LOG event stabilising bleedout")
				else
					targetEv = T_EVENT.REVIVED
				end
			end								
		elseif evData.target:getTraits().isGuard then
			evType = T_EVENT.PARALYZER			-- custom number for palaryzers	
		elseif evData.target == evData.unit then
			evType = T_EVENT.STIM_SELF	
			targetEv = T_EVENT.EV_SELF_STIMMED
		else 
			evType = T_EVENT.STIM_OTHER
			targetEv = T_EVENT.STIMMED_BY
		end
		
		defaultHandler( ev, evType, evData, boardRig, hud, thread )
		waitForUnitIdle( evData.unit, boardRig, thread )
		defaultHandler( ev, targetEv, evData, boardRig, hud, thread, evData.target, true, true )
	end,
	
	[simdefs.EV_UNIT_USECOMP] = function( ev, evType, evData, boardRig, hud, thread )
		local sim = boardRig:getSim()
		sim.lastCompUser = evData.unitID and sim:getUnit( evData.unitID )
		if evData.targetID ~= nil then
			local targetUnit = sim:getUnit( evData.targetID )
			if targetUnit:hasTag("detention_processor") then
				-- get the last entry in the script queue which should be an 8 second delay after the hireText script.
				local delayIdx = nil
				local sim = boardRig:getSim()
				local eventQueue = sim:getLevelScript():getQueue()
				
				for i = #eventQueue, 1, -1 do
					if eventQueue[i] == 8 * cdefs.SECONDS then
						delayIdx = i
						break
					end
				end
			
				-- for rescuing other agent from detention cell
				if defaultHandler( ev, T_EVENT.RESCUER, evData, boardRig, hud, thread ) and delayIdx then
					eventQueue[delayIdx] = 4 * cdefs.SECONDS -- changes 8 second delay to 4 second
				end
			elseif targetUnit:getTraits().mainframe_console and targetUnit:getTraits().cpus > 0 then
				defaultHandler( ev, evType, evData, boardRig, hud, thread ) -- use console
			end
		end	
	end,
	
	[simdefs.EV_UNIT_UNTIE] = function( ev, evType, evData, boardRig, hud, thread )
		local sim = boardRig:getSim()
		local eventQueue = sim:getLevelScript():getQueue()
		if sim.lastCompUser then
			-- insert the agent's line after the courier's line but before central's line
			local delayedEvents = {}
			for i = #eventQueue, 1, -1 do
				local ev = table.remove(eventQueue)
				table.insert(delayedEvents, ev)
				
				local SCRIPTS = include('client/story_scripts')
				if type(ev) == "table" and ev.script == SCRIPTS.INGAME.CENTRAL_HOSTAGE_CONV then
					defaultHandler( ev, evType, evData, boardRig, hud, thread, sim.lastCompUser )
					break
				end
			end
			
			while #delayedEvents > 0 do
				table.insert(eventQueue, table.remove(delayedEvents))
			end
		end
	end,
	
	[simdefs.EV_UNIT_WIRELESS_SCAN] = function( ev, evType, evData, boardRig, hud, thread )
		if evData.hijack then
			defaultHandler( ev, simdefs.EV_UNIT_USECOMP, evData, boardRig, hud, thread )	-- redirects Int's wireless hijack
		end
	end,
	
	[simdefs.EV_UNIT_INTERRUPTED] = defaultHandler,
	[simdefs.EV_UNIT_PEEK] = defaultHandler,
	[simdefs.EV_UNIT_OVERWATCH] = defaultHandler,
	[simdefs.EV_UNIT_OVERWATCH_MELEE] = defaultHandler,
	[simdefs.EV_UNIT_INSTALL_AUGMENT] = defaultHandler,	-- for installing augments
	[simdefs.EV_CLOAK_IN] = defaultHandler,		-- for activating cloak
	[T_EVENT.SURRENDER] = defaultHandler,
	
	[simdefs.EV_UNIT_DEATH] = function( ev, evType, evData, boardRig, hud, thread )
		if evData.unit:getUnitData().agentID and evData.unit:getTraits().corpseTemplate then
			local sim = boardRig:getSim()
			local units = sim:getPC():getUnits()
			local speakerunits = {}
			for _, unit in pairs(units) do
				if unit:getUnitData().agentID and not unit:isDown() then
					table.insert( speakerunits, unit )
				end
			end
			
			if #units > 0 then
				defaultHandler( ev, T_EVENT.AGENT_DEATH, evData, boardRig, hud, thread, speakerunits[ math.random( 1, #speakerunits ) ] )
			end
		end
	end,
	
	[simdefs.EV_UNIT_GOTO_STAND] = function( ev, evType, evData, boardRig, hud, thread )
		if evData.unit and evData.unit:getTraits().walk then
			defaultHandler( ev, evType, evData, boardRig, hud, thread )
		end
	end,		-- for Prism's disguise	
	
	[simdefs.EV_UNIT_USEDOOR_PST] = function( ev, evType, evData, boardRig, hud, thread )
		--this should only work when setting trap but not when disarming it (if disarmed, trap is already nil by the time trigger is given
		local sim = boardRig:getSim()
		if evData.unitID and evData.facing then
			local trapper = sim:getUnit(evData.unitID)
			local cell = sim:getCell( trapper:getLocation() )
			
			if cell and cell.exits[ evData.facing ] and cell.exits[ evData.facing ].trapped then
				defaultHandler( ev, T_EVENT.SET_SHOCKTRAP, evData, boardRig, hud, thread )
			end
		end
	end,
	
	["TA_MONST3R"] = function( ev, evType, evData, boardRig, hud, thread )
		defaultHandler( ev, evData.monst3rEv, evData, boardRig, hud, thread, evData.monst3r, true )
		
		if evData.monst3rEv == T_EVENT.EV_MONSTER_MID2_ESCORTSFIXED then
			boardRig:wait( cdefs.SECONDS )
			MOAIFmodDesigner.playSound( "SpySociety/HUD/gameplay/HUD_ItemStorage_PutIn" )
			boardRig:wait( cdefs.SECONDS )
		end
	end,
	
	["TA_ESCAPE"] = function( ev, evType, evData, boardRig, hud, thread )
		if not evData.success or evData.casualties then 
			evType = T_EVENT.BAD_ESCAPE
		else
			evType = T_EVENT.GOOD_ESCAPE
		end
		
		if evData.bloodymission and math.random() <= 0.7 then 
			evType = T_EVENT.BLOODY_MISSION
		end
		
		if evData.abandonedUnit then
			evType = T_EVENT.ABANDONING_OTHER --takes precedence
		end
		
		local sim = boardRig:getSim()
		local fieldUnits, escapingUnits = simquery.countFieldAgents( sim )
		for i = #escapingUnits, 1, -1 do
			local choice = math.random(1,i) -- Try random agents until we find one with escape lines
			
			if defaultHandler( ev, evType, evData, boardRig, hud, thread, escapingUnits[ choice ], true ) then
				return
			else
				escapingUnits[ choice ] = escapingUnits[ i ] -- Remove chosen agent from being picked again
			end
		end
	end,
	
	["TA_TRG"] = function( ev, evType, evData, boardRig, hud, thread )
		defaultHandler( ev, evData.trgType, evData.trgData, boardRig, hud, thread )
	end,
	
	["TA_GUARDS"] = function( ev, evType, evData, boardRig, hud, thread )
		local p_banter = 0.4 -- chance a banter will trigger instead of a oneliner, when both are available
		local p_banter_hunting = 0.4
		local sim = boardRig:getSim()
		
		if sim:getTrackerStage() < 6 then --no guard lines post 'full alert' alarm levels, no matter the settings. It's srs bsness time!
			local enemies = getGuards( sim )

			if #enemies > 0 then
				local chattyguard = enemies[math.random(1, #enemies)]
				local guardDef = chattyguard:getUnitData()
				local x1, y1 = chattyguard:getLocation()
				local buddy, range = findBuddy( chattyguard, enemies )
				local canSeeBuddy = false
							
				-- check what NPC type
				local guardType = checkGuardType( chattyguard, sim )
				local buddyType
				-- if buddy and range and range < 7 then --pick someone close enough to talk to \o/
				if buddy then
					if simquery.couldUnitSeeCell( sim, chattyguard, sim:getCell( buddy:getLocation() ) ) then
						canSeeBuddy = true
						buddyType = checkGuardType( buddy, sim )
					end
				end
				
				if buddyType == "type_guard" and guardType == "type_guard" and math.random() <= p_banter then 
					doGuardBanter( sim, chattyguard, buddy, STRINGS.alpha_voice.GUARDS.BANTERS )
				elseif buddyType == "type_guard_alerted" and guardType == "type_guard_alerted" and math.random() <= p_banter_hunting then 
					doGuardBanter( sim, chattyguard, buddy, STRINGS.alpha_voice.GUARDS.BANTERS_HUNTING )
				elseif sim:getTrackerStage() < 3 or sim:getParams().difficultyOptions.chattyAlertedGuards ~= false then -- oneliner block
				-- if hunting oneliners are on, it's fine to have oneliners at higher alarm levels, otherwise default to previous build behaviour
					defaultHandler( ev, evType, { speechData = STRINGS.alpha_voice.GUARDS.LINES[ guardType ]}, boardRig, hud, thread, chattyguard, true )
				end
			end
		end
	end,
	
	[T_EVENT.EVENT_SELECTED] = function( ev, evType, evData, boardRig, hud, thread )
		if evData.unit then
			if hud.taSelectEvents then
				if not hud.taSelectEvents[evData.unit] then
					hud.taSelectEvents[evData.unit] = true
					if hud.justRewound and defaultHandler( ev, T_EVENT.EV_RESELECTED, evData, boardRig, hud, thread ) then
						return
					end
					
					defaultHandler( ev, evType, evData, boardRig, hud, thread )
				end
			else
				hud.taSelectEvents = {}
			end
		end
	end,
	
	["TA_REWIND"] = function( ev, evType, evData, boardRig, hud, thread )
		hud.justRewound = true
	end,
}

return events