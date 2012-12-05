-- ***************************************************************************************************************************************************
-- * TabControl.lua                                                                                                                                  *
-- ***************************************************************************************************************************************************
-- * Tab control                                                                                                                                     *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.30 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local Panel = PublicInterface.Panel
local ShadowedText = PublicInterface.ShadowedText
local TInsert = table.insert
local TRemove = table.remove
local UICreateFrame = UI.CreateFrame
local ipairs = ipairs
local unpack = unpack

local TAB_OUTER_PADDING = 10
local TAB_INNER_PADDING = 60
local TAB_HEADERS_HEIGHT = 40
local TAB_PUSH_DOWN = 4
local TITLE_FONTSIZE_NEUTRAL = 16
local TITLE_FONTSIZE_MOUSEOVER = 18
local TITLE_FONTCOLOR_NEUTRAL = { 0.75, 0.75, 0.5 }
local TITLE_FONTCOLOR_DISABLED = { 0.5, 0.5, 0.5 }
local TITLE_FONTCOLOR_SELECTED = { 1, 1, 1 }
local TITLE_SHADOW_OFFSET =  2


function PublicInterface.TabControl(name, parent)
	local bTabControl = UICreateFrame("Frame", name, parent)
	
	local headerFrame = UICreateFrame("Frame", name .. ".HeaderFrame", bTabControl)
	local mainPanel = Panel(name .. ".MainPanel", bTabControl)

	local currentTab = nil
	local headers = {}
	local tabs = {}
	local tabOrder = {}
	
	local function CreateNewHeader(index, prevFrame)
		local header = Panel(headerFrame:GetName() .. ".Headers." .. index, headerFrame)
		local headerText = ShadowedText(header:GetName() .. ".Title", header)
		
		local headerTabID = nil
		local headerEnabled = false
		
		header:SetPoint("TOPLEFT", prevFrame, prevFrame == headerFrame and "TOPLEFT" or "TOPRIGHT", TAB_OUTER_PADDING, 0)
		header:SetPoint("BOTTOMLEFT", prevFrame, prevFrame == headerFrame and "BOTTOMLEFT" or "BOTTOMRIGHT", TAB_OUTER_PADDING, 0)
		header:SetWidth(TAB_INNER_PADDING)
		header:SetBottomBorderVisible(false)
		
		headerText:SetPoint("CENTER", header, "CENTER")
		headerText:SetFontSize(TITLE_FONTSIZE_NEUTRAL)
		headerText:SetFontColor(unpack(TITLE_FONTCOLOR_DISABLED))
		headerText:SetShadowOffset(TITLE_SHADOW_OFFSET, TITLE_SHADOW_OFFSET)
		headerText:SetText("")
		
		function header:SetData(tabID, title, frame, enabled, selected)
			headerTabID = tabID
		
			headerText:SetText(title or "")
			headerText:SetFontSize(TITLE_FONTSIZE_NEUTRAL)
			header:SetWidth(TAB_INNER_PADDING + headerText:GetWidth())
			
			if frame then
				frame:SetVisible(selected and true or false)
			end
			
			headerEnabled = enabled
			if not enabled then
				headerText:SetFontColor(unpack(TITLE_FONTCOLOR_DISABLED))
			elseif selected then
				headerText:SetFontColor(unpack(TITLE_FONTCOLOR_SELECTED))
			else
				headerText:SetFontColor(unpack(TITLE_FONTCOLOR_NEUTRAL))
			end
		end
		
		function header.Event:MouseIn()
			headerText:SetFontSize(headerEnabled and TITLE_FONTSIZE_MOUSEOVER or TITLE_FONTSIZE_NEUTRAL)
		end
		
		function header.Event:MouseOut()
			headerText:SetFontSize(TITLE_FONTSIZE_NEUTRAL)
		end
		
		function header.Event:LeftClick()
			if headerTabID and headerEnabled then
				bTabControl:SetSelectedTab(headerTabID)
			end
		end
		
		TInsert(headers, header)
		
		return header
	end
	
	local function RefreshHeaders(anchorFrame)
		local prevFrame = headerFrame
		
		for index, tabID in ipairs(tabOrder) do
			local header = headers[index] or CreateNewHeader(index, prevFrame)
			local tab = tabs[tabID]
			header:SetData(tabID, tab.title, tab.frame, tab.enabled, tabID == currentTab)
			prevFrame = header
		end
		
		for index, header in ipairs(headers) do
			header:SetVisible(index <= #tabOrder)
		end
	end
	
	headerFrame:SetPoint("TOPLEFT", bTabControl, "TOPLEFT", 0, TAB_PUSH_DOWN)
	headerFrame:SetPoint("BOTTOMRIGHT", bTabControl, "TOPRIGHT", 0, TAB_HEADERS_HEIGHT + TAB_PUSH_DOWN)
	
	mainPanel:SetPoint("TOPLEFT", bTabControl, "TOPLEFT", 0, TAB_HEADERS_HEIGHT)
	mainPanel:SetPoint("BOTTOMRIGHT", bTabControl, "BOTTOMRIGHT")
	
	function bTabControl:GetTabs()
		local returnTabs = {}
		for _, tabID in ipairs(tabOrder) do
			TInsert(returnTabs, tabID)
		end
		return returnTabs
	end
	
	function bTabControl:AddTab(id, title, frame, disabled)
		if not id or not title or tabs[id] then return false end
		disabled = disabled or not frame
		
		tabs[id] =
		{
			title = title,
			frame = frame,
			enabled = not disabled
		}
		TInsert(tabOrder, id)
		
		if frame then
			frame:SetAllPoints(mainPanel:GetContent())
		end
		
		if not currentTab and not disabled then
			bTabControl:SetSelectedTab(id)
		end
		
		RefreshHeaders()
		return true
	end
	
	function bTabControl:RemoveTab(id)
		if not id or not tabs[id] then return false end
		
		tabs[id] = nil
		
		local index = nil
		for tabIndex, tabID in ipairs(tabOrder) do
			if tabID == id then
				index = tabIndex
				break
			end
		end
		if index then
			TRemove(tabOrder, index)
		end
		
		local nextTab = nil
		if currentTab and currentTab == id then
			for _, tabID in ipairs(tabOrder) do
				if tabs[tabID].enabled then
					nextTab = tabID
					break
				end
			end
		end
		bTabControl:SetSelectedTab(nextTab)
		
		RefreshHeaders()
		return true
	end
	
	function bTabControl:GetTabEnabled(id)
		return id and tabs[id] and tabs[id].enabled and true or false
	end
	
	function bTabControl:SetTabEnabled(id, enabled)
		if not id or not tabs[id] then return false end
		
		if not tabs[id].frame then return false end
		
		tabs[id].enabled = enabled and true or false
		
		if not currentTab and enabled then
			bTabControl:SetSelectedTab(id)
		elseif currentTab and currentTab == id and not enabled then
			local nextTab = nil
			if currentTab and currentTab == id then
				for _, tabID in ipairs(tabOrder) do
					if tabs[tabID].enabled then
						nextTab = tabID
						break
					end
				end
			end
			bTabControl:SetSelectedTab(nextTab)
		end
		
		RefreshHeaders()
		return true
	end
	
	function bTabControl:GetSelectedTab()
		return currentTab
	end
	
	function bTabControl:GetSelectedFrame()
		return currentTab and tabs[currentTab] and tabs[currentTab].frame or nil
	end
	
	function bTabControl:SetSelectedTab(id)
		if id and not tabs[id] then return false end
		local prevTab = currentTab
		currentTab = id
		RefreshHeaders()
		if bTabControl.Event.TabSelected then
			bTabControl.Event.TabSelected(bTabControl, id, id and tabs[id] and tabs[id].frame or nil, prevTab, prevTab and tabs[prevTab] and tabs[prevTab].frame or nil)
		end
		return true
	end
	
	function bTabControl:GetContent()
		return mainPanel:GetContent()
	end

	PublicInterface.EventHandler(bTabControl, { "TabSelected" })

	return bTabControl
end
