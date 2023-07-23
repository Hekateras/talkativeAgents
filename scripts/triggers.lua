local simdefs = include("sim/simdefs")
local util = include( "modules/util" )
local array = include( "modules/array" )
local unitdefs = include("sim/unitdefs")
local mainframe = include( "sim/mainframe" )
local mathutil = include( "modules/mathutil" )
local simquery = include( "sim/simquery" )

local T_EVENT = simdefs.TA_EVENT_TABLE.EVENTS
local T_PROB = simdefs.TA_EVENT_TABLE.PROBS

local objectives = {
	["TERMINAL"] = true,
	["checkGuardDistance"] = true,
	["checkNoGuardKill"] = true,
	["followHeatSig"] = true,
	["followAccessCard"] = true,
	["CEO"] = true, 
	["VAULT-LOOTOUTER"] = true,
	["BOUGHT"] = true,
	["NANOFAB"] = true,
	["TOPGEAR"] = true, 
	["USE_TERMINAL"] = true
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

local function mid2MonsterComment( sim, escapingUnits )
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
			if unitdefs.lookupTemplate("ef_pilfer") then
				return T_EVENT.EV_MONSTER_MID2_ESCORTSFIXED, monster
			else
				return T_EVENT.EV_MONSTER_MID2, monster
			end
		end
	end		
end

local triggerObject = {
	onTrigger = function( self, sim, evType, evData )
		-- Block for exit teleportation oneliners
		if evType == simdefs.TRG_MAP_EVENT and evData.units and evData.event == simdefs.MAP_EVENTS.TELEPORT then
			if sim:getParams().situationName == "mid_1" then
				return
			end
		
			local fieldUnits, escapingUnits = simquery.countFieldAgents( sim )
				
			if sim:getParams().situationName == "mid_2" then
				local monst3rEv, monst3r = mid2MonsterComment( sim, escapingUnits )
				if monst3rEv then
					sim:dispatchEvent( "TA_MONST3R", { monst3r = monst3r, monst3rEv = monst3rEv } )
					return
				end
			end
			
			local gotTechExpoItem = getMMTechExpoResult(sim)

			-- escapingUnits = evData.units
			if escapingUnits and #escapingUnits > 0 then
				-- check how well the mission went!
				
				local casualties = nil
				local bloodymission = nil
				local abandonedUnit = nil
				local VIP_escape = nil
				local success = true
				
				for i, unit in ipairs(fieldUnits) do
					if unit:isKO() then
						abandonedUnit = unit
					else
						return --finalescape = nil
					end
				end
				for i, unit in ipairs(escapingUnits) do
					if unit:isKO() then
						casualties = true
					end
					if unit:hasTag("MM_distressCallAgent") then --for MM
						VIP_escape = true
					end
				end
				
				-- log:write("LOG2")
				-- log:write(util.stringize(sim:getLevelScript().hooks,3))
				--for vanilla missions, we can check for the presence of various mission hook functions as a proxy for objective completion.
				local missionhooks = sim:getLevelScript().hooks
				for i, hook in pairs(missionhooks) do
					if objectives[hook.name] then
						success = false
					end
				end
				
				-- for More Missions:
				if sim.TA_mission_success == false then
					log:write("LOG TA mission failed")
					success = false
				end
				if (VIP_escape == true) or (gotTechExpoItem == true) then --Distress Call and Tech Expo update success tag after rescuee/loot has escaped. set success to true even if rescuee is escaping right now and tag hasn't been updated yet.
					log:write("LOG TA mission successful")
					success = true
				end
				
				if sim.permadeathkilled then --permadeath mod compatibility
					casualties = true
				end
				
				if sim:getCleaningKills() > 2 then
					bloodymission = true
				end
				
				-- actually decide what type of reaction to show
				sim:dispatchEvent( "TA_ESCAPE", { success = success, casualties = casualties, bloodymission = bloodymission, abandonedUnit = abandonedUnit } )
			end
		end
		
		-- normal trigger stuff
		if not evData.cancel then
			if evType == simdefs.TRG_SAFE_LOOTED then 
				if evData.targetUnit:getTraits().safeUnit then
					sim:dispatchEvent( "TA_TRG", { trgType = T_EVENT.SAFE_LOOTED, trgData = evData } )
				elseif evData.targetUnit:getTraits().public_term then
					sim:dispatchEvent( "TA_TRG", { trgType = T_EVENT.EXEC_TERMINAL_LOOTED, trgData = evData } )
				elseif evData.targetUnit:getTraits().scanner or evData.targetUnit:getTraits().router then
					sim:dispatchEvent( "TA_TRG", { trgType = T_EVENT.THREAT_DEVICE_LOOTED, trgData = evData } )
				end	
			end
		end
		
		-- chatty guard block --
		if sim:getParams().difficultyOptions.chattyguards and evType == simdefs.TRG_START_TURN and evData:isPC() then
			sim:dispatchEvent( "TA_GUARDS" )
		end
	end
}


local oldInit = mainframe.init

function mainframe.init( sim, ... )
	local self = util.tcopy(triggerObject)
	
	sim:addTrigger(simdefs.TRG_START_TURN,self)
	sim:addTrigger(simdefs.TRG_SAFE_LOOTED,self)
	sim:addTrigger(simdefs.TRG_MAP_EVENT,self)

	return oldInit( sim, ... )
end
