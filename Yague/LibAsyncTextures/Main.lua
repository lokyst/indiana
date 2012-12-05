local Addon, private = ...

-- Builtins
local next = next
local pairs = pairs
local print = print
local tremove = table.remove
local type = type

-- Globals
local InspectAddonCurrent = Inspect.Addon.Current
local InspectSystemWatchdog = Inspect.System.Watchdog
local InspectTimeReal = Inspect.Time.Real
local UtilityDispatch = Utility.Dispatch

-- Locals
local pendingList = {
--[[
	[addon] = {
		[*] = { frame, source, texture, callback }
	}
]]
}
local pendingTextures = 0

-- How many weghted loads are allowed per system update?
-- This parameter is a guesstimate and probably needs some tweaking.
local maxLoadTime = 0.010
local maxWatchdogTolerance = 0.050

-- The public interface table
local public = { }
LibAsyncTextures = public

-- Create a dummy Texture frame to get it's metatable and add applicable methods to it
local textureMeta = UI.CreateFrame("Texture", "Dummy", UI.CreateContext("LibAsyncTextures"))
textureMeta:SetVisible(false)
textureMeta = getmetatable(textureMeta)

local eventSystemUpdateEnd = { function() end, Addon.identifier, "loadTextures" }
Event.System.Update.End[#Event.System.Update.End + 1] = eventSystemUpdateEnd

setfenv(1, private)

if(Addon.toc.debug) then
	log = print
else
	log = function() end
end


-- Private methods
-- ============================================================================

local loadTextures

local function enable()
	eventSystemUpdateEnd[1] = loadTextures
end

local function disable()
	eventSystemUpdateEnd[1] = function() end
end

local previousIndex = nil
loadTextures = function()
	-- Don't start if the Watchdog is closing in too fast
	if(InspectSystemWatchdog() < maxWatchdogTolerance) then
		return
	end
	
	local index = previousIndex
	local addon

	local endTime = InspectTimeReal() + maxLoadTime
	repeat
		-- Load the textures in round-robin fashion i.e.
		-- One texture per addon, cycling all addons
		index, addon = next(pendingList, index)
		if(addon and #addon > 0) then
			local entry = tremove(addon, 1)
			if(entry[1]) then
				entry[1]:SetTexture(entry[2], entry[3])
			end
			pendingTextures = pendingTextures - 1
			if(entry[4]) then
				UtilityDispatch(function() entry[4](entry[1]) end, index, "SetTextureAsync callback")
			end
		end
	until(pendingTextures == 0 or InspectTimeReal() >= endTime)
	previousIndex = index
	
	if(pendingTextures == 0) then
		disable()
	end
end

-- Public methods
-- ============================================================================

-- Enqueue the given texture load in the current addon
function public.SetTextureAsync(frame, source, texture, callback)
	local addonIdentifier = InspectAddonCurrent()
	local frames = pendingList[addonIdentifier] or { }
	pendingList[addonIdentifier] = frames
	
	-- If the frame is already present in frames remove it
	for i = 1, #frames do
		if(frames[i][1] == frame) then
			tremove(frames, i)
			pendingTextures = pendingTextures - 1
			break
		end
	end
	
	frames[#frames + 1] = { frame, source, texture, type(callback) == "function" and callback or nil }
	pendingTextures = pendingTextures + 1
	if(pendingTextures == 1) then
		enable()
	end
end

-- Cancel the asynchronous loading for the given frame in the current addon
function public.CancelSetTextureAsync(frame)
	local addonIdentifier = InspectAddonCurrent()
	local frames = pendingList[addonIdentifier]
	if(frames) then
		for i = 1, #frames do
			if(frames[i][1] == frame) then
				tremove(frames, i)
				pendingTextures = pendingTextures - 1
				break
			end
		end
	end
	if(pendingTextures == 0) then
		disable()
	end
end

-- Insert a generic callback at the end of the queue to be executed when the already queued textures have loaded
function public.EnqueueCallback(callback)
	local addonIdentifier = InspectAddonCurrent()
	local frames = pendingList[addonIdentifier] or { }
	pendingList[addonIdentifier] = frames
	
	frames[#frames + 1] = { nil, nil, nil, type(callback) == "function" and callback or nil }
	pendingTextures = pendingTextures + 1
	if(pendingTextures == 1) then
		enable()
	end
end

-- Cancel all currently pending textures for the current addon
function public.CancelAllPendingTextures()
	local frames = pendingList[InspectAddonCurrent()]
	if(frames) then
		pendingList[InspectAddonCurrent()] = { }
		pendingTextures = pendingTextures - #frames
		if(pendingTextures == 0) then
			disable()
		end
	end
end

-- Return how many textures are pending in the current addon
function public.GetNumPendingTextures()
	local addonIdentifier = InspectAddonCurrent()
	local frames = pendingList[addonIdentifier]
	return frames and #frames or 0
end

-- Initialization
-- ============================================================================

textureMeta.__index.SetTextureAsync = public.SetTextureAsync
textureMeta.__index.CancelSetTextureAsync = public.CancelSetTextureAsync
