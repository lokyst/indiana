local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local context = UI.CreateContext("Indy_TTContext")
local ttFrame = UI.CreateFrame("Frame", "Indy_TTFrame", context)
Library.LibSimpleWidgets.SetBorder("tooltip", ttFrame)
ttFrame.__lsw_border:SetPosition("inside")
local ttTextFrame = UI.CreateFrame("Text", "Indy_Tooltip", ttFrame)
ttTextFrame:SetBackgroundColor(0,0,0,0.75)

context:SetStrata("topmost")
context:SetVisible(false)
ttFrame:SetVisible(false)
ttTextFrame:SetVisible(false)

local padding = 20
local verticalOffset = 8

local onNextFrameFunc = nil
local onNextFrameDelay = 2

local function DisplayTooltip(tooltipString)
    ttTextFrame:SetText(tooltipString)
    ttTextFrame:SetFontSize(14)
    ttTextFrame:SetWordwrap(true)
    ttTextFrame:ClearAll()

    ttFrame:SetPoint("TOPLEFT", UI.Native.Tooltip, "BOTTOMLEFT", 0, 5)
    ttFrame:SetPoint("TOPRIGHT", UI.Native.Tooltip, "BOTTOMRIGHT", 0, 5)

    ttTextFrame:SetPoint("TOPLEFT", ttFrame, "TOPLEFT", 10, 10)
    ttTextFrame:SetPoint("TOPRIGHT", ttFrame, "TOPRIGHT", -10, 10)

    ttFrame:SetHeight(math.max(38,ttTextFrame:GetHeight() + 20))
    ttTextFrame:SetHeight(ttFrame:GetHeight() - 20)

    ttFrame:SetVisible(true)
    ttTextFrame:SetVisible(true)
    context:SetVisible(true)
end

local function IndyTooltip(ttType, ttShown, ttBuff)
    if not Indy.showTooltips then
        return
    end

    context:SetVisible(false)
    ttFrame:SetVisible(false)
    ttTextFrame:SetVisible(false)
    onNextFrameFunc = nil

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
        local text = table.concat(myStrings, "\n")
        onNextFrameFunc = function() DisplayTooltip(text) end
        onNextFrameDelay = 2
    end
end

-- To stop the evil flickering
local function OnFrameUpdate()
    if onNextFrameFunc then
        onNextFrameDelay = onNextFrameDelay - 1
        if onNextFrameDelay <= 0 then
            onNextFrameFunc()
            onNextFrameFunc = nil
        end
    end
end

table.insert(Event.Tooltip, {IndyTooltip, "Indy", "IndyTooltip"})
table.insert(Event.System.Update.Begin, {OnFrameUpdate, "Indy", "OnFrameUpdate"})
