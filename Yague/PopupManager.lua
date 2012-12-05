-- ***************************************************************************************************************************************************
-- * PopupManager.lua                                                                                                                                *
-- ***************************************************************************************************************************************************
-- * Popup Manager                                                                                                                                   *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.08.23 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local TInsert = table.insert
local UICreateFrame = UI.CreateFrame
local ipairs = ipairs
local pairs = pairs
local pcall = pcall

local popupConstructors = {}

function PublicInterface.PopupManager(name, parent)
	local mainFrame = UICreateFrame("Frame", name, parent)

	local visible = false
	local popupPool = {}
	
	local function ResetVisibility()
		if visible then
			for id, idPool in pairs(popupPool) do
				for _, popupFrame in ipairs(idPool) do
					if popupFrame:GetVisible() then
						mainFrame:SetVisible(true)
						return
					end
				end
			end
		end
		mainFrame:SetVisible(false)
	end
	
	mainFrame:SetAllPoints()
	mainFrame:SetLayer(999999)
	mainFrame:SetVisible(visible)
	
	local function eventSink() end
	mainFrame.Event.LeftClick = eventSink
	mainFrame.Event.LeftDown = eventSink
	mainFrame.Event.LeftUp = eventSink
	mainFrame.Event.LeftUpoutside = eventSink
	mainFrame.Event.RightClick = eventSink
	mainFrame.Event.RightDown = eventSink
	mainFrame.Event.RightUp = eventSink
	mainFrame.Event.RightUpoutside = eventSink
	mainFrame.Event.MiddleClick = eventSink
	mainFrame.Event.MiddleDown = eventSink
	mainFrame.Event.MiddleUp = eventSink
	mainFrame.Event.MiddleUpoutside = eventSink
	mainFrame.Event.Mouse4Click = eventSink
	mainFrame.Event.Mouse4Down = eventSink
	mainFrame.Event.Mouse4Up = eventSink
	mainFrame.Event.Mouse4Upoutside = eventSink
	mainFrame.Event.Mouse5Click = eventSink
	mainFrame.Event.Mouse5Down = eventSink
	mainFrame.Event.Mouse5Up = eventSink
	mainFrame.Event.Mouse5Upoutside = eventSink
	mainFrame.Event.MouseIn = eventSink
	mainFrame.Event.MouseMove = eventSink
	mainFrame.Event.MouseOut = eventSink
	mainFrame.Event.WheelBack = eventSink
	mainFrame.Event.WheelForward = eventSink
	
	local parentSetVisible = parent.SetVisible
	function parent:SetVisible(parentVisible)
		visible = parentVisible
		parentSetVisible(parent, visible)
		ResetVisibility()
	end
	
	function mainFrame:ShowPopup(id, ...)
		if id and popupConstructors[id] then
			popupPool[id] = popupPool[id] or {}
			
			local popup = nil
			for _, popupFrame in ipairs(popupPool[id]) do
				if not popupFrame:GetVisible() then
					popup = popupFrame
					break
				end
			end
			
			if not popup then
				popup = popupConstructors[id](mainFrame)
				popup:SetPoint("CENTER", mainFrame, "CENTER", #popupPool[id] % 10, #popupPool[id] % 10)
				TInsert(popupPool[id], popup)
			end
			
			popup:SetVisible(true)
			pcall(popup.SetData, popup, ...)
			ResetVisibility()
			
			return popup
		end
	end
	
	function mainFrame:HidePopup(id, popup)
		if id and popupPool[id] then
			for _, popupFrame in ipairs(popupPool[id]) do
				if popupFrame == popup then
					popupFrame:SetVisible(false)
					ResetVisibility()
					break
				end
			end
		end
	end
	
	return mainFrame
end

function PublicInterface.RegisterPopupConstructor(id, constructor)
	if id then
		popupConstructors[id] = constructor
	end
end