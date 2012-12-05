-- ***************************************************************************************************************************************************
-- * Popup.lua                                                                                                                                       *
-- ***************************************************************************************************************************************************
-- * Popup frame                                                                                                                                     *
-- ***************************************************************************************************************************************************
-- * 0.4.4 / 2012.08.24 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local UICreateFrame = UI.CreateFrame

function PublicInterface.Popup(name, parent)
	local mainFrame = UICreateFrame("Frame", name, parent)

	local backdropFrame = UICreateFrame("Frame", mainFrame:GetName() .. ".Backdrop", mainFrame)
	
	local borderFrame = UICreateFrame("Frame", mainFrame:GetName() .. ".Border", mainFrame)
	local background = UICreateFrame("Texture", borderFrame:GetName() .. ".Background", borderFrame)
	local cornerTopLeft = UICreateFrame("Texture", borderFrame:GetName() .. ".CornerTopLeft", borderFrame)
	local cornerTopRight = UICreateFrame("Texture", borderFrame:GetName() .. ".CornerTopRight", borderFrame)
	local cornerBottomLeft = UICreateFrame("Texture", borderFrame:GetName() .. ".CornerBottomLeft", borderFrame)
	local cornerBottomRight = UICreateFrame("Texture", borderFrame:GetName() .. ".CornerBottomRight", borderFrame)
	local borderTop = UICreateFrame("Texture", borderFrame:GetName() .. ".BorderTop", borderFrame)
	local borderBottom = UICreateFrame("Texture", borderFrame:GetName() .. ".BorderBottom", borderFrame)
	local borderLeft = UICreateFrame("Texture", borderFrame:GetName() .. ".BorderLeft", borderFrame)
	local borderRight = UICreateFrame("Texture", borderFrame:GetName() .. ".BorderRight", borderFrame)
	
	local contentFrame = UI.CreateFrame("Frame", mainFrame:GetName() .. ".Content", mainFrame)

	backdropFrame:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 5, 5)
	backdropFrame:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -5, -5)
	backdropFrame:SetBackgroundColor(0, 0, 0, 0.9)
	backdropFrame:SetLayer(-3)
	
	borderFrame:SetAllPoints(mainFrame)
	borderFrame:SetLayer(-2)

	background:SetTextureAsync(addonID, "Textures/PopupBackground.png")
	background:SetPoint("TOPLEFT", cornerTopLeft, "BOTTOMRIGHT", 0, 0)
	background:SetPoint("BOTTOMRIGHT", cornerBottomRight, "TOPLEFT", 0, 0)
	background:SetLayer(-2)
	
	cornerTopLeft:SetTextureAsync(addonID, "Textures/PopupCornerTopLeft.png")
	cornerTopLeft:SetPoint("TOPLEFT", borderFrame, "TOPLEFT", 0, 0)
	cornerTopLeft:SetLayer(-1)

	cornerTopRight:SetTextureAsync(addonID, "Textures/PopupCornerTopRight.png")
	cornerTopRight:SetPoint("TOPRIGHT", borderFrame, "TOPRIGHT", 0, 0)
	cornerTopRight:SetLayer(-1)

	cornerBottomLeft:SetTextureAsync(addonID, "Textures/PopupCornerBottomLeft.png")
	cornerBottomLeft:SetPoint("BOTTOMLEFT", borderFrame, "BOTTOMLEFT", 0, 0)
	cornerBottomLeft:SetLayer(-1)

	cornerBottomRight:SetTextureAsync(addonID, "Textures/PopupCornerBottomRight.png")
	cornerBottomRight:SetPoint("BOTTOMRIGHT", borderFrame, "BOTTOMRIGHT", 0, 0)
	cornerBottomRight:SetLayer(-1)

	borderTop:SetTextureAsync(addonID, "Textures/PopupBorderTop.png")
	borderTop:SetPoint("TOPLEFT", cornerTopLeft, "TOPRIGHT", 0, 0)
	borderTop:SetPoint("TOPRIGHT", cornerTopRight, "TOPLEFT", 0, 0)
	borderTop:SetLayer(-1)
	
	borderBottom:SetTextureAsync(addonID, "Textures/PopupBorderBottom.png")
	borderBottom:SetPoint("BOTTOMLEFT", cornerBottomLeft, "BOTTOMRIGHT", 0, 0)
	borderBottom:SetPoint("BOTTOMRIGHT", cornerBottomRight, "BOTTOMLEFT", 0, 0)
	borderBottom:SetLayer(-1)
	
	borderLeft:SetTextureAsync(addonID, "Textures/PopupBorderLeft.png")
	borderLeft:SetPoint("TOPLEFT", cornerTopLeft, "BOTTOMLEFT", 0, 0)
	borderLeft:SetPoint("BOTTOMLEFT", cornerBottomLeft, "TOPLEFT", 0, 0)
	borderLeft:SetLayer(-1)
	
	borderRight:SetTextureAsync(addonID, "Textures/PopupBorderRight.png")
	borderRight:SetPoint("TOPRIGHT", cornerTopRight, "BOTTOMRIGHT", 0, 0)
	borderRight:SetPoint("BOTTOMRIGHT", cornerBottomRight, "TOPRIGHT", 0, 0)
	borderRight:SetLayer(-1)
	
	contentFrame:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 10, 10)
	contentFrame:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -10, -10)
	contentFrame:SetLayer(-1)
	
	function mainFrame:GetBackdrop()
		return backdropFrame
	end
	
	function mainFrame:GetBorder()
		return borderFrame
	end
	
	function mainFrame:GetContent()
		return contentFrame
	end
	
	return mainFrame
end