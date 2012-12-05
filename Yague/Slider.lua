-- ***************************************************************************************************************************************************
-- * MoneyDisplay.lua                                                                                                                                *
-- ***************************************************************************************************************************************************
-- * Money frame                                                                                                                                     *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.16 / Baanano: Rewritten                                                                                                         *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local MFloor = math.floor
local MMax = math.max
local MMin = math.min
local Panel = PublicInterface.Panel
local SLen = string.len
local SFormat = string.format
local SUpper = string.upper
local TInsert = table.insert
local UICreateFrame = UI.CreateFrame
local ipairs = ipairs
local tonumber = tonumber
local type = type

local MAX_RANGE = 999

function PublicInterface.Slider(name, parent)
	local bSlider = UICreateFrame("Frame", name, parent)
	
	local slider = UICreateFrame("RiftSlider", name .. ".Slider", bSlider)
	local innerPanel = Panel(name .. ".InnerPanel", bSlider)
	local innerContent = innerPanel:GetContent()
	local textField = UICreateFrame("RiftTextfield", name .. ".InnerPanel.Textfield", innerContent)
	local secretLabel = UICreateFrame("Text", name .. ".SecretLabel", bSlider)

	slider:SetPoint("BOTTOMLEFT", bSlider, "BOTTOMLEFT", 10, 0)
	slider:SetPoint("BOTTOMRIGHT", bSlider, "BOTTOMRIGHT", -60, 0)

	innerPanel:SetPoint("CENTERLEFT", slider, "CENTERRIGHT", 14, slider:GetHeight() - 30)
	innerPanel:SetWidth(46)
	innerPanel:SetHeight(30)
	innerPanel:SetInvertedBorder(true)
	innerContent:SetBackgroundColor(0, 0, 0, 0.5)

	textField:SetPoint("CENTER", innerContent, "CENTER", 5, 1)
	textField:SetText("")

	secretLabel:SetVisible(false)

	local currentValue = 0
	local minValue, maxValue = 0, 0
	local preValues, postValues = {}, {}
	local pseudoValuesLookup = {}
	
	local function RepositionSlider()
		local minRange, maxRange = minValue - #preValues, maxValue + #postValues
		slider:SetRange(minRange, maxRange)
		currentValue = MMin(MMax(minRange, currentValue), maxRange)
		slider:SetPosition(currentValue)
		slider:SetEnabled(maxRange > minRange and true or false)
		
		local text = SFormat("%d", currentValue)
		local value = currentValue
		if currentValue < minValue then
			local preIndex = currentValue + #preValues + 1 - minValue
			text = preValues[preIndex].text or ""
			value = preValues[preIndex].value
		elseif currentValue > maxValue then
			local postIndex = currentValue - maxValue
			text = postValues[postIndex].text or ""
			value = postValues[postIndex].value
		end
		
		secretLabel:SetText(text)
		textField:SetText(text)
		textField:SetWidth(secretLabel:GetWidth() + 10)
		
		if bSlider.Event.PositionChanged then
			bSlider.Event.PositionChanged(bSlider, value)
		end
	end
	
	local function RebuildPseudoLookup()
		pseudoValuesLookup = {}
		for index, preValue in ipairs(preValues) do
			for _, key in ipairs(preValue.keys) do
				pseudoValuesLookup[SUpper(key)] = minValue - #preValues + index - 1
			end
		end
		for index, postValue in ipairs(postValues) do
			for _, key in ipairs(postValue.keys) do
				pseudoValuesLookup[SUpper(key)] = maxValue + index
			end
		end
	end

	function slider.Event:SliderChange()
		local newPosition = MFloor(self:GetPosition())
		if newPosition == currentValue then return end
		currentValue = MMax(MMin(newPosition, maxValue + #postValues), minValue - #preValues)
		RepositionSlider()
	end
	
	function textField.Event:KeyUp(key)
		if pseudoValuesLookup[SUpper(key)] then
			currentValue = pseudoValuesLookup[SUpper(key)]
			RepositionSlider()
			self:SetSelection(0, SLen(self:GetText()))
		end
	end
	
	function textField.Event:TextfieldChange()
		local newPosition = tonumber(self:GetText() ~= "" and self:GetText() or "0")
		newPosition = newPosition and MFloor(newPosition)
		if newPosition and newPosition ~= currentValue then
			currentValue = MMax(MMin(newPosition, maxValue), minValue)
		end
		RepositionSlider()
	end

	function textField.Event:KeyFocusGain()
		self:SetSelection(0, SLen(self:GetText()))
	end

	function innerPanel.Event:LeftClick()
		textField:SetKeyFocus(true)
	end
	
	function bSlider.Event:WheelForward()
		if slider:GetPosition() + 1 <= maxValue + #postValues then
			slider:SetPosition(slider:GetPosition() + 1)
		end
	end

	function bSlider.Event:WheelBack()
		if slider:GetPosition() - 1 >= minValue - #preValues then
			slider:SetPosition(slider:GetPosition() - 1)
		end
	end

	
	
	function bSlider:GetRange()
		return minValue, maxValue
	end
	
	function bSlider:SetRange(minRange, maxRange)
		minValue = MMax(minRange, 0)
		maxValue = MMin(maxRange, MAX_RANGE)
		currentValue = MMax(MMin(currentValue, maxValue + #postValues), minValue - #preValues)
		RebuildPseudoLookup()
		RepositionSlider()
	end

	function bSlider:SetPosition(position)
		position = pseudoValuesLookup[SUpper(position)] or position
		currentValue = MMax(MMin(position, maxValue + #postValues), minValue - #preValues)
		RepositionSlider()
	end

	function bSlider:GetPosition()
		if currentValue < minValue then
			local preIndex = currentValue + #preValues + 1 - minValue
			return preValues[preIndex].value
		elseif currentValue > maxValue then
			local postIndex = currentValue - maxValue
			return postValues[postIndex].value
		end	
		return currentValue
	end
	
	function bSlider:AddPreValue(keys, value, text)
		if type(keys) ~= "table" then keys = { keys } end
		TInsert(preValues, { keys = keys, value = value, text = text, })
		RebuildPseudoLookup()
		RepositionSlider()
	end

	function bSlider:AddPostValue(keys, value, text)
		if type(keys) ~= "table" then keys = { keys } end
		TInsert(postValues, { keys = keys, value = value, text = text, })
		RebuildPseudoLookup()
		RepositionSlider()
	end
	
	function bSlider:ResetPseudoValues()
		preValues = {}
		postValues = {}
		RebuildPseudoLookup()
		RepositionSlider()
	end

	PublicInterface.EventHandler(bSlider, { "PositionChanged" })
	
	RepositionSlider()

	return bSlider
end