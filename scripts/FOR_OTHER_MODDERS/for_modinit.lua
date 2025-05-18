-- 1) In your modinit's init function, add :

	modApi.requirements = {"Talkative Agents"}

-- 2) In your modinit's lateInit function, add:

	local scriptPath = modApi:getScriptPath()
	local util = include("modules/util")	
	local STRINGS = include( "strings" )
	local modded_agent_TEMPLATE = include( scriptPath .. "/modded_agent_TEMPLATE") 

	if STRINGS.alpha_voice then -- by adding Talkative Agents to modApi.requirements and waiting until lateInit to run this block, we're making sure that TA's strings have initialised before we try to add to them. But just in case...
		util.tmerge(STRINGS.alpha_voice.AGENT_ONELINERS, modded_agent_TEMPLATE)
	end

-- 3) Don't forget to add lateInit to the return block at the end of modinit if you don't have it already.