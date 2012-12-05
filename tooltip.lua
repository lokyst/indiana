local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local context = UI.CreateContext("Indy_TTContext")
local ttFrame = Yague.Popup("Indy_TooltipFrame", context)
local ttTextFrame = UI.CreateFrame("Text", "Indy_Tooltip", ttFrame)

context:SetStrata("topmost")
context:SetVisible(false)
ttFrame:SetVisible(false)
ttTextFrame:SetVisible(false)

local padding = 20
local verticalOffset = 8

local function DisplayTooltip(tooltipString)
    ttTextFrame:SetText(tooltipString)
    ttTextFrame:SetFontSize(14)
    ttTextFrame:SetWordwrap(true)
    ttTextFrame:ClearAll()

    ttFrame:SetPoint("TOPLEFT", UI.Native.Tooltip, "BOTTOMLEFT", 0, 5)
    ttFrame:SetPoint("TOPRIGHT", UI.Native.Tooltip, "BOTTOMRIGHT", 0, 5)

    ttTextFrame:SetPoint("TOPLEFT", ttFrame, "TOPLEFT", padding, verticalOffset)
    ttTextFrame:SetPoint("TOPRIGHT", ttFrame, "TOPRIGHT", -padding, verticalOffset)

    ttFrame:SetHeight(math.max(58,ttTextFrame:GetHeight() + verticalOffset*2))

    ttFrame:SetVisible(true)
    ttTextFrame:SetVisible(true)
    context:SetVisible(true)
end
Yague.RegisterPopupConstructor(addonID .. ".DisplayTooltip", DisplayTooltip)

local function IndyTooltip(ttType, ttShown, ttBuff)
    if not Indy.showTooltips then
        return
    end
    
    context:SetVisible(false)
    ttFrame:SetVisible(false)
    ttTextFrame:SetVisible(false)

    if not (ttType and ttShown) then return end

    if not (ttType == "item" or ttType == "itemtype") then return end

    local itemDetails = Inspect.Item.Detail(ttShown)

    if not itemDetails then return end

    if not itemDetails.category and not (itemDetails.category:find("misc") and itemDetails.category:find("collectible")) then
        return
    end

    if itemDetails.sell == nil or itemDetails.sell ~= 1 then
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
    if #myStrings > 0 then
        DisplayTooltip(table.concat(myStrings, "\n"))
    end
end

table.insert(Event.Tooltip, {IndyTooltip, "Indy", "IndyTooltip"})