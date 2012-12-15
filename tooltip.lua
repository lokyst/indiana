local context = UI.CreateContext("Indy_TTContext")
local ttFrame = UI.CreateFrame("Frame", "Indy_TTFrame", context)
local ttNeedsTextFrame = UI.CreateFrame("Text", "Indy_NeedsTooltip", ttFrame)
ttNeedsTextFrame:SetBackgroundColor(0,0,0,0.75)
local ttHasTextFrame = UI.CreateFrame("Text", "Indy_HasTooltip", ttFrame)
ttHasTextFrame:SetBackgroundColor(0,0,0,0.75)

context:SetStrata("topmost")
context:SetVisible(false)
ttFrame:SetVisible(false)
ttNeedsTextFrame:SetVisible(false)
ttHasTextFrame:SetVisible(false)

local padding = 20
local verticalOffset = 8

local onNextFrameFunc = nil
local onNextFrameDelay = 2

local function DisplayTooltip(needList, hasList)
    ttFrame:SetPoint("TOPLEFT", UI.Native.Tooltip, "BOTTOMLEFT", 0, 5)
    ttFrame:SetPoint("TOPRIGHT", UI.Native.Tooltip, "BOTTOMRIGHT", 0, 5)

    local needString = ""
    local hasString = ""

    if #needList > 0 then
        needString = "Needs: " .. table.concat(needList, ", ")
    end
    if #hasList > 0 then
        hasString = "Has: " .. table.concat(hasList, ", ")
    end

    ttNeedsTextFrame:SetText(needString)
    ttNeedsTextFrame:SetFontSize(14)
    ttNeedsTextFrame:SetWordwrap(true)
    ttNeedsTextFrame:ClearAll()
    ttNeedsTextFrame:SetVisible(false)

    ttNeedsTextFrame:SetPoint("TOPLEFT", ttFrame, "TOPLEFT", 10, 10)
    ttNeedsTextFrame:SetPoint("TOPRIGHT", ttFrame, "TOPRIGHT", -10, 10)
    ttNeedsTextFrame:SetFontColor(1,0,0)

    ttHasTextFrame:SetText(hasString)
    ttHasTextFrame:SetFontSize(14)
    ttHasTextFrame:SetWordwrap(true)
    ttHasTextFrame:ClearAll()
    ttHasTextFrame:SetVisible(false)

    local vHeight = 20
    local vOffset = 10
    if #needList > 0 then
        vHeight =  vHeight + ttNeedsTextFrame:GetHeight()
        vOffset = vOffset + ttNeedsTextFrame:GetHeight()
        ttNeedsTextFrame:SetVisible(true)
    end

    if #hasList > 0 then
        vHeight =  vHeight + ttHasTextFrame:GetHeight()
        ttHasTextFrame:SetVisible(true)
    end

    ttHasTextFrame:SetPoint("TOPLEFT", ttFrame, "TOPLEFT", 10, vOffset)
    ttHasTextFrame:SetPoint("TOPRIGHT", ttFrame, "TOPRIGHT", -10, vOffset)
    ttHasTextFrame:SetFontColor(0,1,0)

    ttFrame:SetHeight(vHeight)

    ttFrame:SetVisible(true)
    context:SetVisible(true)
end

local function IndyTooltip(ttType, ttShown, ttBuff)
    if not Indy.showTooltips then
        return
    end

    context:SetVisible(false)
    ttFrame:SetVisible(false)
    ttNeedsTextFrame:SetVisible(false)
    ttHasTextFrame:SetVisible(false)
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

    if #needList > 0 or #hasList > 0 then
        onNextFrameFunc = function() DisplayTooltip(needList, hasList) end
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

function Indy:UpdateTooltipBorder()
    if Indy.showTooltipBorder then
        Library.LibSimpleWidgets.SetBorder("tooltip", ttFrame)
        ttFrame.__lsw_border:SetPosition("inside")
    elseif ttFrame.__lsw_border then
        ttFrame.__lsw_border:Destroy()
        ttFrame.__lsw_border = nil
    end
end

table.insert(Event.Tooltip, {IndyTooltip, "Indy", "IndyTooltip"})
table.insert(Event.System.Update.Begin, {OnFrameUpdate, "Indy", "OnFrameUpdate"})
