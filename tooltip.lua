-- Acknowledgement: The basic framework for this functionality was borrowed
-- from the ImhoBags AddOn, from file windows\TooltipEnhancer.lua.

local context = UI.CreateContext("Indy_TTContext")
local window = UI.CreateFrame("Text", "Indy_Tooltip", context)

context:SetStrata("topmost")
window:SetVisible(false)
window:SetBackgroundColor(0, 0, 0, 0.8)

local padding = 10
local verticalOffset = 0

local function DisplayTooltip(tooltipString)
    local left, top, right, bottom = UI.Native.Tooltip:GetBounds()
    local screenHeight = UIParent:GetHeight()
    local height = window:GetHeight()

    window:SetText(tooltipString)
    window:SetFontSize(14)
    window:SetVisible(true)
    window:ClearAll()
    window:SetPoint("TOPLEFT", UI.Native.Tooltip, "BOTTOMLEFT", padding, verticalOffset)
    window:SetPoint("TOPRIGHT", UI.Native.Tooltip, "BOTTOMRIGHT", -padding, verticalOffset)
end

local function IndyTooltip(ttType, ttShown, ttBuff)
    window:SetVisible(false)

    if not (ttType and ttShown) then return end

    if not (ttType == "item" or ttType == "itemtype") then return end

    local itemDetails = Inspect.Item.Detail(ttShown)

    if not itemDetails then return end

    if not itemDetails.category and not itemDetails.category:find("collectible") then
        return
    end

    local needList = Indy:WhoNeedsItem(itemDetails.type)
    local hasList = Indy:WhoHasItem(itemDetails.type)

    local myStrings = {}
    if #needList > 0 then
        table.insert(myStrings, "Needs: " .. (table.concat(needList, ", ")))
    end

    if #hasList > 0 then
        table.insert(myStrings, "Has: " .. (table.concat(hasList, ", ")))
    end
    DisplayTooltip(table.concat(myStrings, "\n"))
end

table.insert(Event.Tooltip, {IndyTooltip, "Indy", "IndyTooltip"})