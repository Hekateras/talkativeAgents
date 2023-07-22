local array = include( "modules/array" )
local util = include( "modules/util" )
local mathutil = include( "modules/mathutil" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simengine = include("sim/engine")

if simengine.pushEventTrigger then return end --somebody else added this already

-- local _init = simengine.init
-- function simengine:init( ... )
	-- _init(self, ...)
	-- self._evtriggers = {}
-- end

function simengine:addEventTrigger( evType, obj, ... )
	
	-- can't init properly so do this instead
	if not self._evtriggers then
		self._evtriggers = {}
	end
	
	if not self._evtriggers[ evType ] then
		self._evtriggers[ evType ] = {}
	end

	local trigger = {...}
	trigger._obj = obj

	assert( obj.onEventTrigger )
	assert( array.findIf( self._evtriggers[ evType ], function( t ) return t._obj == obj end ) == nil )

	table.insert(self._evtriggers[ evType ], trigger)
    return trigger
end

function simengine:removeEventTrigger( evType, obj )
    assert( obj )
	
	-- can't init properly so do this instead
	if not self._evtriggers then
		self._evtriggers = {}
	end
	
	for i,trigger in ipairs(self._evtriggers[ evType ]) do
		if trigger._obj == obj then
			table.remove( self._evtriggers[ evType ], i )
			break
		end
	end
end

function simengine:pushEventTrigger( evType, evData, before )
	assert( evType )

	if self._evtriggers[ evType ] then
		local processList = util.tdupe( self._evtriggers[ evType ] )
        table.sort( processList, function( t1, t2 ) return (t1.priority or 0) < (t2.priority or 0) end )
		
		while next( processList ) do
			local trigger = table.remove( processList )
			trigger._obj:onEventTrigger( self, evType, evData, before, unpack(trigger) )
		end
		
	end

    return evData -- Only returning triggerData table for convenience.
end

local _dispatchEvent = simengine.dispatchEvent
function simengine:dispatchEvent( evType, evData, ... )
	
	-- can't init properly so do this instead
	if not self._evtriggers then
		self._evtriggers = {}
	end
	
	self:pushEventTrigger(evType, evData, true)
	
	local ret = _dispatchEvent( self, evType, evData, ... )
	
	self:pushEventTrigger(evType, evData, false)
	
	return ret
end
