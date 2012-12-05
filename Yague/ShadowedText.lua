-- ***************************************************************************************************************************************************
-- * ShadowedText.lua                                                                                                                                *
-- ***************************************************************************************************************************************************
-- * Shadowed Text frame                                                                                                                             *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.15 / Baanano: Rewritten                                                                                                         *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local UICreateFrame = UI.CreateFrame
local unpack = unpack

local DEFAULT_OFFSET = 1
local DEFAULT_SHADOW_COLOR = { 0, 0, 0, 0.25 }

function PublicInterface.ShadowedText(name, parent)
	local label = UICreateFrame("Text", name, parent)
	local shadow = UICreateFrame("Text", name .. ".Shadow", parent)
	
	shadow:SetPoint("TOPLEFT", label, "TOPLEFT", DEFAULT_OFFSET, DEFAULT_OFFSET)
	shadow:SetLayer(label:GetLayer() - 1)
	shadow:SetFontColor(unpack(DEFAULT_SHADOW_COLOR))
	
	local oldSetFont = label.SetFont
	local oldSetFontSize = label.SetFontSize
	local oldSetText = label.SetText
	local oldSetWordwrap = label.SetWordwrap
	local oldSetVisible = label.SetVisible
	
	function label:SetFont(source, font)
		oldSetFont(self, source, font)
		shadow:SetFont(source, font)
	end

	function label:SetFontSize(fontSize)
		oldSetFontSize(self, fontSize)
		shadow:SetFontSize(fontSize)
	end

	function label:SetText(text, html)
		oldSetText(self, text, html or false)
		shadow:SetText(text, html or false)
	end

	function label:SetWordwrap(wordWrap)
		oldSetWordwrap(self, wordWrap)
		shadow:SetWordwrap(wordWrap)
	end
	
	function label:SetVisible(visible)
		oldSetVisible(self, visible)
		shadow:SetVisible(visible)
	end
	
	function label:SetShadowColor(r, g, b, a)
		shadow:SetFontColor(r, g, b, a)
	end
	
	function label:SetShadowOffset(x, y)
		shadow:ClearAll()
		shadow:SetPoint("TOPLEFT", self, "TOPLEFT", x or DEFAULT_OFFSET, y or DEFAULT_OFFSET)
	end

	return label
end