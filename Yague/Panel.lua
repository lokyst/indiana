-- ***************************************************************************************************************************************************
-- * Panel.lua                                                                                                                                       *
-- ***************************************************************************************************************************************************
-- * Panel frame                                                                                                                                     *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.15 / Baanano: Rewritten                                                                                                         *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local UICreateFrame = UI.CreateFrame

function PublicInterface.Panel(name, parent)
	local bPanel = UICreateFrame("Frame", name, parent)

	local borderFrame = UICreateFrame("Frame", bPanel:GetName() .. ".Border", bPanel)
	local background = UICreateFrame("Texture", borderFrame:GetName() .. ".Background", borderFrame)
	local cornerTopLeft = UICreateFrame("Texture", borderFrame:GetName() .. ".CornerTopLeft", borderFrame)
	local cornerTopRight = UICreateFrame("Texture", borderFrame:GetName() .. ".CornerTopRight", borderFrame)
	local cornerBottomLeft = UICreateFrame("Texture", borderFrame:GetName() .. ".CornerBottomLeft", borderFrame)
	local cornerBottomRight = UICreateFrame("Texture", borderFrame:GetName() .. ".CornerBottomRight", borderFrame)
	local borderTop = UICreateFrame("Texture", borderFrame:GetName() .. ".BorderTop", borderFrame)
	local borderBottom = UICreateFrame("Texture", borderFrame:GetName() .. ".BorderBottom", borderFrame)
	local borderLeft = UICreateFrame("Texture", borderFrame:GetName() .. ".BorderLeft", borderFrame)
	local borderRight = UICreateFrame("Texture", borderFrame:GetName() .. ".BorderRight", borderFrame)
	
	local contentFrame = UI.CreateFrame("Mask", bPanel:GetName() .. ".Content", bPanel)
	
	local borderVisibility = { top = true, left = true, bottom = true, right = true, }
	
	borderFrame:SetAllPoints(bPanel)
	borderFrame:SetLayer(-2)

	background:SetTextureAsync(addonID, "Textures/PanelExtBackground.png")
	background:SetPoint("TOPLEFT", cornerTopLeft, "BOTTOMRIGHT", 0, 0)
	background:SetPoint("BOTTOMRIGHT", cornerBottomRight, "TOPLEFT", 0, 0)
	background:SetLayer(-2)
	
	cornerTopLeft:SetTextureAsync(addonID, "Textures/PanelExtCornerTopLeft.png")
	cornerTopLeft:SetPoint("TOPLEFT", borderFrame, "TOPLEFT", 0, 0)
	cornerTopLeft:SetLayer(-1)

	cornerTopRight:SetTextureAsync(addonID, "Textures/PanelExtCornerTopRight.png")
	cornerTopRight:SetPoint("TOPRIGHT", borderFrame, "TOPRIGHT", 0, 0)
	cornerTopRight:SetLayer(-1)

	cornerBottomLeft:SetTextureAsync(addonID, "Textures/PanelExtCornerBottomLeft.png")
	cornerBottomLeft:SetPoint("BOTTOMLEFT", borderFrame, "BOTTOMLEFT", 0, 0)
	cornerBottomLeft:SetLayer(-1)

	cornerBottomRight:SetTextureAsync(addonID, "Textures/PanelExtCornerBottomRight.png")
	cornerBottomRight:SetPoint("BOTTOMRIGHT", borderFrame, "BOTTOMRIGHT", 0, 0)
	cornerBottomRight:SetLayer(-1)

	borderTop:SetTextureAsync(addonID, "Textures/PanelExtBorderTop.png")
	borderTop:SetPoint("TOPLEFT", cornerTopLeft, "TOPRIGHT", 0, 0)
	borderTop:SetPoint("TOPRIGHT", cornerTopRight, "TOPLEFT", 0, 0)
	borderTop:SetLayer(-1)
	
	borderBottom:SetTextureAsync(addonID, "Textures/PanelExtBorderBottom.png")
	borderBottom:SetPoint("BOTTOMLEFT", cornerBottomLeft, "BOTTOMRIGHT", 0, 0)
	borderBottom:SetPoint("BOTTOMRIGHT", cornerBottomRight, "BOTTOMLEFT", 0, 0)
	borderBottom:SetLayer(-1)
	
	borderLeft:SetTextureAsync(addonID, "Textures/PanelExtBorderLeft.png")
	borderLeft:SetPoint("TOPLEFT", cornerTopLeft, "BOTTOMLEFT", 0, 0)
	borderLeft:SetPoint("BOTTOMLEFT", cornerBottomLeft, "TOPLEFT", 0, 0)
	borderLeft:SetLayer(-1)
	
	borderRight:SetTextureAsync(addonID, "Textures/PanelExtBorderRight.png")
	borderRight:SetPoint("TOPRIGHT", cornerTopRight, "BOTTOMRIGHT", 0, 0)
	borderRight:SetPoint("BOTTOMRIGHT", cornerBottomRight, "TOPRIGHT", 0, 0)
	borderRight:SetLayer(-1)
	
	contentFrame:SetPoint("TOPLEFT", bPanel, "TOPLEFT", 4, 4)
	contentFrame:SetPoint("BOTTOMRIGHT", bPanel, "BOTTOMRIGHT", -4, -4)
	contentFrame:SetLayer(-1)
	
	local function UpdateVisibility()
		cornerTopLeft:SetVisible(borderVisibility.top and borderVisibility.left)
		cornerTopRight:SetVisible(borderVisibility.top and borderVisibility.right)
		cornerBottomLeft:SetVisible(borderVisibility.bottom and borderVisibility.left)
		cornerBottomRight:SetVisible(borderVisibility.bottom and borderVisibility.right)
		borderTop:SetVisible(borderVisibility.top)
		borderBottom:SetVisible(borderVisibility.bottom)
		borderLeft:SetVisible(borderVisibility.left)
		borderRight:SetVisible(borderVisibility.right)
	end

	function bPanel:SetInvertedBorder(inverted)
		if inverted then
			cornerTopLeft:SetTextureAsync(addonID, "Textures/PanelIntCornerTopLeft.png")
			cornerTopRight:SetTextureAsync(addonID, "Textures/PanelIntCornerTopRight.png")
			cornerBottomLeft:SetTextureAsync(addonID, "Textures/PanelIntCornerBottomLeft.png")
			cornerBottomRight:SetTextureAsync(addonID, "Textures/PanelIntCornerBottomRight.png")
			borderTop:SetTextureAsync(addonID, "Textures/PanelIntBorderTop.png")
			borderBottom:SetTextureAsync(addonID, "Textures/PanelIntBorderBottom.png")
			borderLeft:SetTextureAsync(addonID, "Textures/PanelIntBorderLeft.png")
			borderRight:SetTextureAsync(addonID, "Textures/PanelIntBorderRight.png")
		else
			cornerTopLeft:SetTextureAsync(addonID, "Textures/PanelExtCornerTopLeft.png")
			cornerTopRight:SetTextureAsync(addonID, "Textures/PanelExtCornerTopRight.png")
			cornerBottomLeft:SetTextureAsync(addonID, "Textures/PanelExtCornerBottomLeft.png")
			cornerBottomRight:SetTextureAsync(addonID, "Textures/PanelExtCornerBottomRight.png")
			borderTop:SetTextureAsync(addonID, "Textures/PanelExtBorderTop.png")
			borderBottom:SetTextureAsync(addonID, "Textures/PanelExtBorderBottom.png")
			borderLeft:SetTextureAsync(addonID, "Textures/PanelExtBorderLeft.png")
			borderRight:SetTextureAsync(addonID, "Textures/PanelExtBorderRight.png")
		end
	end

	function bPanel:GetBorder()
		return borderFrame
	end
	
	function bPanel:GetContent()
		return contentFrame
	end
	
	function bPanel:SetTopBorderVisible(visible)
		visible = visible and true or false
		if borderVisibility.top ~= visible then
			borderVisibility.top = visible
			UpdateVisibility()
		end
	end
	
	function bPanel:SetBottomBorderVisible(visible)
		visible = visible and true or false
		if borderVisibility.bottom ~= visible then
			borderVisibility.bottom = visible
			UpdateVisibility()
		end
	end
	
	function bPanel:SetLeftBorderVisible(visible)
		visible = visible and true or false
		if borderVisibility.left ~= visible then
			borderVisibility.left = visible
			UpdateVisibility()
		end
	end
	
	function bPanel:SetRightBorderVisible(visible)
		visible = visible and true or false
		if borderVisibility.right ~= visible then
			borderVisibility.right = visible
			UpdateVisibility()
		end
	end

	return bPanel
end