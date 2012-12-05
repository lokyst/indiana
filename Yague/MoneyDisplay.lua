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
local UICreateFrame = UI.CreateFrame
local tostring = tostring

function PublicInterface.MoneyDisplay(name, parent)
	local bMoneyDisplay = UICreateFrame("Frame", name, parent)
	
	local silverText = UICreateFrame("Text", bMoneyDisplay:GetName() .. ".SilverText", bMoneyDisplay)
	local goldText = UICreateFrame("Text", bMoneyDisplay:GetName() .. ".GoldText", bMoneyDisplay)
	local platinumText = UICreateFrame("Text", bMoneyDisplay:GetName() .. ".PlatinumText", bMoneyDisplay)
	local silverTexture = UICreateFrame("Texture", bMoneyDisplay:GetName() .. ".SilverTexture", bMoneyDisplay)
	local goldTexture = UICreateFrame("Texture", bMoneyDisplay:GetName() .. ".GoldTexture", bMoneyDisplay)
	local platinumTexture = UICreateFrame("Texture", bMoneyDisplay:GetName() .. ".PlatinumTexture", bMoneyDisplay)

	silverText:SetPoint("CENTERRIGHT", bMoneyDisplay, "CENTERRIGHT", -16, 0)

	goldText:SetPoint("CENTERRIGHT", bMoneyDisplay, "CENTERRIGHT", -54, 0)

	platinumText:SetPoint("CENTERRIGHT", bMoneyDisplay, "CENTERRIGHT", -92, 0)
	
	silverTexture:SetPoint("CENTERRIGHT", bMoneyDisplay, "CENTERRIGHT", 0, 0)
	silverTexture:SetWidth(16)
	silverTexture:SetHeight(16)
	silverTexture:SetTextureAsync("Rift", "coins_silver.png.dds")
	
	goldTexture:SetPoint("CENTERRIGHT", bMoneyDisplay, "CENTERRIGHT", -38, 0)
	goldTexture:SetWidth(16)
	goldTexture:SetHeight(16)
	goldTexture:SetTextureAsync("Rift", "coins_gold.png.dds")	
	
	platinumTexture:SetPoint("CENTERRIGHT", bMoneyDisplay, "CENTERRIGHT", -76, 0)
	platinumTexture:SetWidth(16)
	platinumTexture:SetHeight(16)
	platinumTexture:SetTextureAsync("Rift", "coins_platinum.png.dds")	
	
	local value = 0
	
	local function ResetMoneyFrame()
		local silver, gold, platinum = value % 100, MFloor(value / 100) % 100, MFloor(value / 10000)

		local displayPlatinum = platinum > 0
		local displayGold = displayPlatinum or gold > 0
		local displaySilver = displayGold or silver > 0
		
		silverTexture:SetVisible(displaySilver)
		silverText:SetVisible(displaySilver)
		silverText:SetText(tostring(silver))

		goldTexture:SetVisible(displayGold)
		goldText:SetVisible(displayGold)
		goldText:SetText(tostring(gold))

		platinumTexture:SetVisible(displayPlatinum)
		platinumText:SetVisible(displayPlatinum)
		platinumText:SetText(tostring(platinum))
	end
	
	function bMoneyDisplay:GetValue()
		value = MFloor(value or 0)
		return value
	end
	
	function bMoneyDisplay:SetValue(newValue)
		value = MFloor(MMax(newValue or 0, 0))
		ResetMoneyFrame()
	end
	
	ResetMoneyFrame()
	
	return bMoneyDisplay
end
