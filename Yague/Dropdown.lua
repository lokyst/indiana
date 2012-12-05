-- ***************************************************************************************************************************************************
-- * Dropdown.lua                                                                                                                                    *
-- ***************************************************************************************************************************************************
-- * Dropdown selector frame                                                                                                                         *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.15 / Baanano: Rewritten                                                                                                         *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local Panel = PublicInterface.Panel
local MFloor = math.floor
local MMax = math.max
local MMin = math.min
local TInsert = table.insert
local TSort = table.sort
local UICreateFrame = UI.CreateFrame
local ipairs = ipairs
local pairs = pairs
local tostring = tostring
local type = type
local unpack = unpack

local VALUE_HEIGHT = 26
local VALUE_MARGIN = 0
local VALUE_BORDER = 1.5
local BORDER_HEIGHT = 8
local MAX_VALUES = 10
local DEFAULT_COLOR = { 1, 1, 1, }

function PublicInterface.Dropdown(name, parent)
	local bDropdown = Panel(name, parent)
	
	local iconTexture = UICreateFrame("Texture", name .. ".IconTexture", bDropdown:GetContent())
	local selectedText = UICreateFrame("Text", name .. ".SelectedText", bDropdown:GetContent())
	
	local dropdownPanel = Panel(name .. ".DropdownPanel", parent)
	local dropdownContent = dropdownPanel:GetContent()
	local dropdownScrollbar = UICreateFrame("RiftScrollbar", name .. ".DropdownScrollbar", dropdownContent)
	local dropdownFrame = UICreateFrame("Frame", name .. ".DropdownFrame", dropdownContent)
	local valueFrames = {}
	for index = 1, MAX_VALUES do
		local valueFrame = UICreateFrame("Frame", bDropdown:GetName() .. ".ValueFrames." .. index, dropdownFrame)
		
		local valueTexture = UICreateFrame("Texture", valueFrame:GetName() .. ".ValueTexture", valueFrame)
		local valueBackground = UICreateFrame("Frame", valueFrame:GetName() .. ".ValueBackground", valueFrame)
		local valueText = UICreateFrame("Text", valueFrame:GetName() .. ".ValueText", valueBackground)

		valueFrame:SetPoint("TOPLEFT", dropdownFrame, "TOPLEFT", 0, (index - 1) * (VALUE_HEIGHT + VALUE_MARGIN * 2 +  VALUE_BORDER * 2) + VALUE_MARGIN)
		valueFrame:SetPoint("BOTTOMRIGHT", dropdownFrame, "TOPRIGHT", 0, index * (VALUE_HEIGHT + VALUE_MARGIN * 2 +  VALUE_BORDER * 2) - VALUE_MARGIN)
		valueFrame:SetBackgroundColor(0, 0, 0, 1)

		valueTexture:SetTextureAsync(addonID, "Textures/DropdownBackground.png")
		valueTexture:SetAllPoints()
		valueTexture:SetLayer(0)
		valueTexture:SetVisible(false)
		
		valueBackground:SetPoint("TOPLEFT", valueFrame, "TOPLEFT", 0, VALUE_BORDER)
		valueBackground:SetPoint("BOTTOMRIGHT", valueFrame, "BOTTOMRIGHT", 0, -VALUE_BORDER)
		valueBackground:SetBackgroundColor(0, 0, 0, 1)
		valueBackground:SetLayer(1)
		
		valueText:SetPoint("CENTERLEFT", valueBackground, "CENTERLEFT", 0, 2)
		valueText:SetFontSize(14)
		valueText:SetFontColor(unpack(DEFAULT_COLOR))

		function valueFrame.Event:MouseIn()
			self:SetBackgroundColor(1, 0.75, 0, 1)
			valueTexture:SetVisible(true)
		end
		
		function valueFrame.Event:MouseOut()
			self:SetBackgroundColor(0, 0, 0, 1)
			valueTexture:SetVisible(false)
		end
		
		function valueFrame:SetValue(key, text, textColor)
			self:SetVisible(key and true or false)

			valueText:SetText(text or "")

			if type(textColor) == "table" then
				valueText:SetFontColor(unpack(textColor))
			else
				valueText:SetFontColor(unpack(DEFAULT_COLOR))
			end
			
			function self.Event:LeftClick()
				bDropdown:SetSelectedKey(key)
				dropdownPanel:SetVisible(false)
			end
		end
		
		TInsert(valueFrames, valueFrame)
	end

	bDropdown:GetContent():SetBackgroundColor(0, 0, 0, 0.75)
	bDropdown:SetInvertedBorder(true)
	
	iconTexture:SetPoint("CENTER", bDropdown:GetContent(), "CENTERLEFT", 15, 0)
	iconTexture:SetTextureAsync(addonID, "Textures/Dropdown.png")

	selectedText:SetPoint("CENTERLEFT", bDropdown:GetContent(), "CENTERLEFT", 40, 0)
	selectedText:SetFontSize(14)
	selectedText:SetFontColor(unpack(DEFAULT_COLOR))
	
	dropdownPanel:SetPoint("TOPLEFT", bDropdown, "BOTTOMLEFT")
	dropdownPanel:SetPoint("TOPRIGHT", bDropdown, "BOTTOMRIGHT")
	dropdownPanel:SetHeight(BORDER_HEIGHT)
	dropdownPanel:SetLayer(9999)
	dropdownPanel:GetContent():SetBackgroundColor(0, 0, 0, 0.75)
	dropdownPanel:SetVisible(false)

	dropdownScrollbar:SetPoint("TOPRIGHT", dropdownContent, "TOPRIGHT", -2, 2)
	dropdownScrollbar:SetPoint("BOTTOMLEFT", dropdownContent, "BOTTOMRIGHT", -18, -2)
	dropdownScrollbar:SetRange(0, 0)
	dropdownScrollbar:SetPosition(0)
	
	dropdownFrame:SetPoint("TOPLEFT", dropdownContent, "TOPLEFT", 2, 0)
	dropdownFrame:SetPoint("TOPRIGHT", dropdownContent, "TOPRIGHT", -20, 0)
	
	bDropdown.selectedText = selectedText
	bDropdown.dropdownPanel = dropdownPanel
	bDropdown.dropdownScrollbar = dropdownScrollbar
	bDropdown.dropdownFrame = dropdownFrame

	local enabled = false
	local values = {}
	local orderedKeys = {}
	local keyIndices = {}
	local selectedKey = nil
	
	local orderSelector = nil
	local textSelector = nil
	local colorSelector = nil

	local function GetTextAndColor(key, value)
		local text = tostring(key)
		if type(textSelector) == "function" then
			local proposedText = textSelector(key, value)
			text = proposedText and tostring(proposedText) or text
		elseif type(textSelector) ~= "nil" then
			text = value[textSelector] and tostring(value[textSelector]) or text
		end
		
		local color = DEFAULT_COLOR
		if type(colorSelector) == "function" then
			local proposedColor = colorSelector(key, value)
			color = proposedColor or color
		elseif type(colorSelector) ~= "nil" then
			color = value[colorSelector] or color
		end
		
		return text, color
	end
	
	local function RepaintValueFrames(startIndex)
		for index = 1, MAX_VALUES do
			local actualIndex = index + startIndex
			
			local key = orderedKeys[actualIndex]
			local text = nil
			local color = nil
			
			local value = key and values[key] or nil
			
			if key and value then
				text, color = GetTextAndColor(key, value)
			end
			
			valueFrames[index]:SetValue(key, text, color)
		end
	end
	
	function iconTexture.Event:LeftClick()
		if not enabled then return end
		dropdownPanel:SetVisible(not dropdownPanel:GetVisible())
	end
	
	function dropdownScrollbar.Event:ScrollbarChange()
		if self:GetPosition() ~= MFloor(self:GetPosition()) then
			self:SetPosition(MFloor(self:GetPosition()))
		else
			RepaintValueFrames(self:GetPosition())
		end
	end
	
	function dropdownContent.Event:WheelForward()
		if dropdownScrollbar:GetEnabled() and dropdownScrollbar:GetPosition() > 0 then
			dropdownScrollbar:SetPosition(MFloor(dropdownScrollbar:GetPosition()) - 1)
		end
	end
	
	function dropdownContent.Event:WheelBack()
		if dropdownScrollbar:GetEnabled() and MFloor(dropdownScrollbar:GetPosition()) < #orderedKeys - MAX_VALUES  then
			dropdownScrollbar:SetPosition(MFloor(dropdownScrollbar:GetPosition()) + 1)
		end
	end
	
	function bDropdown:GetEnabled()
		return enabled
	end

	function bDropdown:SetEnabled(value)
		enabled = value and true or false
		if not enabled then
			dropdownPanel:SetVisible(false)
		end
	end
	
	function bDropdown:GetValues()
		return values or {}
	end
	
	function bDropdown:SetValues(vals)
		values = vals or {}
		
		orderedKeys = {}
		for key, value in pairs(values) do
			TInsert(orderedKeys, key)
		end
		
		if orderSelector then
			if type(orderSelector) == "function" then
				TSort(orderedKeys, function(a, b) return orderSelector(a, b, values[a], values[b]) end)
			elseif type(orderSelector) ~= "boolean" then
				TSort(orderedKeys, 
					function(a, b)
						local valueA, valueB = values[a][orderSelector] or a, values[b][orderSelector] or b
						return valueA == valueB and a < b or valueA < valueB
					end)
			else
				TSort(orderedKeys)
			end
		end
		
		keyIndices = {}
		for index, key in ipairs(orderedKeys) do
			keyIndices[key] = index
		end

		dropdownPanel:SetHeight(MMin(#orderedKeys, MAX_VALUES) * (VALUE_HEIGHT + VALUE_MARGIN * 2 + VALUE_BORDER * 2) + BORDER_HEIGHT)
		
		dropdownScrollbar:SetRange(0, MMax(0, #orderedKeys - MAX_VALUES))
		dropdownScrollbar:SetPosition(0)
		RepaintValueFrames(0)
		dropdownScrollbar:SetEnabled(#orderedKeys > MAX_VALUES)
		
		self:SetEnabled(#orderedKeys > 0)
		self:SetSelectedKey(orderedKeys[1])
	end	
	
	function bDropdown:GetSelectedValue()
		return selectedKey, selectedKey and values[selectedKey] or nil
	end
	
	function bDropdown:SetSelectedKey(key)
		local value = key and values[key] or nil
		selectedKey = value and key or nil
		
		local index = (selectedKey and keyIndices[selectedKey] or 1) - 1
		index = MMax(MMin(index, #orderedKeys - MAX_VALUES), 0)
		dropdownScrollbar:SetPosition(index)
		
		local text, color = "", DEFAULT_COLOR
		if key and value then
			text, color = GetTextAndColor(key, value)
		end
		
		selectedText:SetText(text)
		selectedText:SetFontColor(unpack(color))
		
		if self.Event.SelectionChanged then
			self.Event.SelectionChanged(self, selectedKey, value)
		end			
	end
	
	function bDropdown:SetOrderSelector(order)
		orderSelector = order
	end
	
	function bDropdown:SetTextSelector(text)
		textSelector = text
	end
	
	function bDropdown:SetColorSelector(color)
		colorSelector = color
	end
	
	PublicInterface.EventHandler(bDropdown, { "SelectionChanged" })
	
	return bDropdown
end