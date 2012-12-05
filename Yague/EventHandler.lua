-- ***************************************************************************************************************************************************
-- * EventHandler.lua                                                                                                                                *
-- ***************************************************************************************************************************************************
-- * Extended event handler                                                                                                                          *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.15 / Baanano: Rewritten                                                                                                         *
-- * 0.4.0 / 2012.06.30 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local error = error
local pairs = pairs
local rawget = rawget
local rawset = rawset
local setmetatable = setmetatable

function PublicInterface.EventHandler(element, events)
	local newEventHandler = {}
	local handledEvents = {}
	
	for _, event in pairs(events) do
		handledEvents[event] = true
	end

	local oldEventHandler = element.Event

	setmetatable(newEventHandler, {
		__index = function(tab, event)
			if handledEvents[event] then
				return rawget(tab, event)
			elseif oldEventHandler then
				return oldEventHandler[event]
			else
				error("Invalid event: " .. event)
			end
		end,
		
		__newindex = function(tab, event, func)
			if handledEvents[event] then
				rawset(tab, event, func)
			elseif oldEventHandler then
				oldEventHandler[event] = func
			else
				error("Invalid event: " .. event)
			end
		end
	})

	element.Event = newEventHandler
end