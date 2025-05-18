local util = include("modules/util")
local simdefs = include( "sim/simdefs" )
local cdefs = include( "client_defs" )

local function init( modApi )
	local scriptPath = modApi:getScriptPath()
	local dataPath = modApi:getDataPath()
	
	include( scriptPath.."/triggers" )
	
	modApi.requirements = {"Sim Constructor","No Dialogues (Reworked)","Advanced Corporate Tactics"}	
	
	    -- Mount data (icons, agent upgrade pic).
	KLEIResourceMgr.MountPackage( dataPath .. "/dlc_banter_ico.kwad", "data" ) 	

	modApi:addGenerationOption("alpha_voice", STRINGS.alpha_voice.OPTIONS.MOD , STRINGS.alpha_voice.OPTIONS.MOD_TIP, {noUpdate = true})	
	
	modApi:addGenerationOption("chattyguards", STRINGS.alpha_voice.OPTIONS.GUARDS, STRINGS.alpha_voice.OPTIONS.GUARDS_TIP, {noUpdate = true} )
	
	-- modApi:addGenerationOption("chattyAlertedGuards", STRINGS.alpha_voice.OPTIONS.GUARDS_ALERTED, STRINGS.alpha_voice.OPTIONS.GUARDS_ALERTED_TIP, {noUpdate = true} )	
	
	-- modApi:addGenerationOption("talkativeagents_multiplier", STRINGS.alpha_voice.OPTIONS.FREQUENCY, STRINGS.alpha_voice.OPTIONS.FREQUENCY_TIP, 
	-- {
		-- values = {0.1, 0.3, 0.5, 0.75, 1, 1.5, 2, 1000}, 
		-- strings = STRINGS.alpha_voice.OPTIONS.FREQUENCY_STRINGS, 
		-- value=1,
		-- noUpdate = true,
	-- })
	
	-- modApi:addGenerationOption("guaranteeCertainTriggers", STRINGS.alpha_voice.OPTIONS.GUARANTEE_TRIGGERS, STRINGS.alpha_voice.OPTIONS.GUARANTEE_TRIGGERS_TIP, {noUpdate = true} )	

	modApi:addGenerationOption("talkativeagents_messagetime", STRINGS.alpha_voice.OPTIONS.MESSAGETIME, STRINGS.alpha_voice.OPTIONS.MESSAGETIME_TIP, 
	{
		values = {3,4,5,6}, 
		strings = STRINGS.alpha_voice.OPTIONS.MESSAGETIME_STRINGS, 
		value=4,
		noUpdate = true,
	})	
	
	-- modApi:addGenerationOption("talkative_cameras", STRINGS.alpha_voice.OPTIONS.BURNT_TOAST, STRINGS.alpha_voice.OPTIONS.BURNT_TOAST_TIP, {enabled = true, noUpdate = true} )		
	-- modApi:addGenerationOption("burnttoast", STRINGS.alpha_voice.OPTIONS.BURNT_TOAST, STRINGS.alpha_voice.OPTIONS.BURNT_TOAST_TIP, {enabled = false, noUpdate = true} )	
end


local function lateInit()
	local simactions = include("sim/simactions")
	local rewindAction_old = simactions.rewindAction
	simactions.rewindAction = function( sim, rewindsLeft, ... )
		rewindAction_old( sim, rewindsLeft, ... )
		sim:dispatchEvent( "TA_REWIND", {} )
	end

	local hud = include( "hud/hud" )
	local oldSelectUnit = hud.onSelectUnit

	hud.onSelectUnit = function( self, prevUnit, selectedUnit )
		if self._game and self._game.viz then
			self._game.viz:processViz( {
				eventType = simdefs.TA_EVENT_TABLE.EVENTS.EVENT_SELECTED,
				eventData = { unit = selectedUnit }
			} )
		end
		
		return oldSelectUnit( self, prevUnit, selectedUnit )
	end
	
	--This keeps the "I got hit" oneliners from following the final words and ruining the dramatic impact
	local abilitydefs = include( "sim/abilitydefs" )
	local lastWords = abilitydefs.lookupAbility("lastWords")
	local lastWords_executeAbility_old = lastWords.executeAbility
	lastWords.executeAbility = function( self, sim, sourceUnit, ... )
		sim:getTags().deliveringFinalWords = true
		lastWords_executeAbility_old( self, sim, sourceUnit, ... )
	end
	
	if abilitydefs._abilities.surrender then --from Advanced Corporate Tactics
		local surrender_executeAbility_old = abilitydefs._abilities.surrender.executeAbility

		abilitydefs._abilities.surrender.executeAbility = function(self, sim, unit, userUnit, target, ... )

			local targetUnit = sim:getUnit(target)
			-- local script = sim:getLevelScript()
			local delay_time = 2.5
			sim:dispatchEvent( simdefs.TA_EVENT_TABLE.EVENTS.SURRENDER, {unit = targetUnit} )  --insert trigger so alpha_voice can detect it
			sim:dispatchEvent( simdefs.EV_WAIT_DELAY, delay_time * cdefs.SECONDS )
			-- script:queue( delay_time*cdefs.SECONDS )
			surrender_executeAbility_old(self, sim, unit, userUnit, target, ... ) --run default function as normal

		end
	end
	
	------------ LOCATION-SPECIFIC LINE SUPPORT
	local simparams = include("sim/simparams")
	local createCampaign_old = simparams.createCampaign

	simparams.createCampaign = function( campaignData, ... )
		local params = createCampaign_old( campaignData, ... )
		params.TA_location = campaignData.situation.mapLocation
		return params
	end
	
	local mission_util = include("sim/missions/mission_util")
	local makeAgentConnection_old = mission_util.makeAgentConnection
	mission_util.makeAgentConnection = function( script, sim, ... )
		log:write("TA makeAgentConnection wrap")
		sim:getTags().TA_getSpeechFlag_START = true -- flag for simunit:getSpeech
		makeAgentConnection_old( script, sim, ... )
		sim:getTags().TA_getSpeechFlag_START = nil
		sim:triggerEvent("finishedAgentConnection")
	end
	
	local abilitydefs = include( "sim/abilitydefs" )
	local lastWords = abilitydefs.lookupAbility("lastWords")
	local lastWords_execute_old = lastWords.executeAbility
	lastWords.executeAbility = function( self, sim, sourceUnit, ... )
		sim:getTags().TA_getSpeechFlag_FINAL = true -- flag for simunit:getSpeech
		
		if sourceUnit and sourceUnit:getUnitData().agentID == "mod_goose" then --Goose mod integration
			local goose = sourceUnit
			local sound = "goose/goosesfx/honk"
			local x0, y0 = goose:getLocation()
			sim:emitSound( { path = sound, range = 7 }, x0, y0, nil )
		end
		
		lastWords_execute_old( self, sim, sourceUnit, ... )
		sim:getTags().TA_getSpeechFlag_FINAL = nil
	end
	
	local CHANCE_OF_CITY = 0.8
	local CHANCE_OF_CORP = 0.5
	local CHANCE_OF_SITUATION = 0.8
	local serverdefs = include("modules/serverdefs")
	
	local simunit = include("sim/simunit")
	local simunit_getspeech_old = simunit.getSpeech
	simunit.getSpeech = function( self, ... )
		local sim = self:getSim()
		-- log:write("LOG getting speech for "..self:getUnitData().name)
		local speech = self._unitData.speech
		if speech and speech.LOCATION_SPECIFIC and sim:getParams().TA_location then
			local situation = sim:getParams().situationName
			local corpSpeech = nil
			local citySpeech = nil
			local situationSpeech = nil
			local corpworld = sim:getParams().world
			local location = serverdefs.MAP_LOCATIONS[ sim:getParams().TA_location ]
			local cityName = location.name
			-- log:write(cityName)
			
			if sim:getTags().TA_getSpeechFlag_START then
			
				if speech.LOCATION_SPECIFIC[corpworld] and speech.LOCATION_SPECIFIC[corpworld].START and (#speech.LOCATION_SPECIFIC[corpworld].START > 0) then
					-- log:write("LOG found corp-specific")
					corpSpeech = speech.LOCATION_SPECIFIC[corpworld]
				end
				
				if speech.LOCATION_SPECIFIC[cityName] and speech.LOCATION_SPECIFIC[cityName].START and (#speech.LOCATION_SPECIFIC[cityName].START > 0) then
					-- log:write("LOG found city-specific")
					citySpeech = speech.LOCATION_SPECIFIC[cityName]
				end
				
				if speech.LOCATION_SPECIFIC[situation] and speech.LOCATION_SPECIFIC[situation].START and (#speech.LOCATION_SPECIFIC[situation].START > 0) then
					-- log:write("LOG found mission-specific")
					situationSpeech = speech.LOCATION_SPECIFIC[situation]
				end				
	
			elseif sim:getTags().TA_getSpeechFlag_FINAL then

				if speech.LOCATION_SPECIFIC[corpworld] and speech.LOCATION_SPECIFIC[corpworld].FINAL_WORDS and (#speech.LOCATION_SPECIFIC[corpworld].FINAL_WORDS > 0) then
					corpSpeech = speech.LOCATION_SPECIFIC[corpworld]
				end
				
				if speech.LOCATION_SPECIFIC[cityName] and speech.LOCATION_SPECIFIC[cityName].FINAL_WORDS  and (#speech.LOCATION_SPECIFIC[cityName].FINAL_WORDS > 0) then
					citySpeech = speech.LOCATION_SPECIFIC[cityName]
				end
				
				if speech.LOCATION_SPECIFIC[situation] and speech.LOCATION_SPECIFIC[situation].FINAL_WORDS and (#speech.LOCATION_SPECIFIC[situation].FINAL_WORDS > 0) then
					situationSpeech = speech.LOCATION_SPECIFIC[situation]
				end
								
			end
				
			if citySpeech and (sim:nextRand() <= CHANCE_OF_CITY) then
				return citySpeech
			end
			if situationSpeech and (sim:nextRand() <= CHANCE_OF_SITUATION ) then
				return situationSpeech
			end				
			if corpSpeech and (sim:nextRand() <= CHANCE_OF_CORP) then

				return corpSpeech
			end	
		end
	
		return simunit_getspeech_old( self, ... )
	end
end

local function load(modApi, options, params)
	local scriptPath = modApi:getScriptPath()
	if options["chattyguards"] and options["chattyguards"].enabled and params then
		params.chattyguards = true
	end
	if params then --NEW
		params.chattyAlertedGuards = true
		params.talkativeagents_multiplier = 1
	end
	
	if options["alpha_voice"].enabled then
		local handlers = include( scriptPath .. "/event_functions" )
		
		for evType, fn in pairs( handlers ) do
			modApi:addVizEvHandler( evType, fn )
		end
	end
	
	------ deprecated
	-- if options["chattyAlertedGuards"] and options["chattyAlertedGuards"].enabled and params then
		-- params.chattyAlertedGuards = true
	-- end	
	-- if options["talkativeagents_multiplier"] and params then
		-- params.talkativeagents_multiplier = options["talkativeagents_multiplier"].value
	-- end
	------

	if options["talkativeagents_messagetime"] and params then
		params.talkativeagents_messagetime = options["talkativeagents_messagetime"].value
	end	
	
	-- if options["burnttoast"] and params then
		-- params.burnttoast = options["burnttoast"].value
	-- end
	
	-- log:write("LOG abilitydefs")
	-- log:write(util.stringize(abilitydefs._abilities.surrender,2))
end

local function initStrings(modApi)
	local scriptPath = modApi:getScriptPath()
	local dataPath = modApi:getDataPath()
	local simdefs = include("sim/simdefs")
	--initiate the TA table.
	local event_table = include( scriptPath .. "/event_table" )
	simdefs.TA_EVENT_TABLE = event_table	
	
	local DLC_STRINGS = include( scriptPath .. "/strings" )
 	modApi:addStrings( dataPath, "alpha_voice", DLC_STRINGS )
end

local function lateLoad(modApi, options, params, allOptions)
	if options["alpha_voice"].enabled then
		local agentdefs = include("sim/unitdefs/agentdefs")
		local LOCATION_STRINGS = STRINGS.alpha_voice.LOCATION_STRINGS
		for i, agent in pairs(agentdefs) do
			if agent.speech and agent.agentID and LOCATION_STRINGS[agent.agentID] then
				agent.speech.LOCATION_SPECIFIC = LOCATION_STRINGS[agent.agentID]
			end
		end
	end
end

return {
    init = init,
	lateInit = lateInit,
    load = load,
	lateLoad = lateLoad,
    initStrings = initStrings,
}
