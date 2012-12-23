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

local onNextFrameFunc
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

    ttNeedsTextFrame:ClearAll()
    ttNeedsTextFrame:SetText(needString)
    ttNeedsTextFrame:SetFontSize(14)
    ttNeedsTextFrame:SetWordwrap(true)
    ttNeedsTextFrame:SetVisible(false)

    ttNeedsTextFrame:SetPoint("TOPLEFT", ttFrame, "TOPLEFT", 10, 10)
    ttNeedsTextFrame:SetPoint("TOPRIGHT", ttFrame, "TOPRIGHT", -10, 10)
    ttNeedsTextFrame:SetFontColor(1,0,0)

    ttHasTextFrame:ClearAll()
    ttHasTextFrame:SetText(hasString)
    ttHasTextFrame:SetFontSize(14)
    ttHasTextFrame:SetWordwrap(true)
    ttHasTextFrame:SetVisible(false)

    local vHeight = 20
    local vOffset = 10
    if #needList > 0 then
        vHeight =  vHeight + ttNeedsTextFrame:GetHeight()
        vOffset = vOffset + ttNeedsTextFrame:GetHeight()
        ttNeedsTextFrame:SetVisible(true)
    end

    ttHasTextFrame:SetPoint("TOPLEFT", ttFrame, "TOPLEFT", 10, vOffset)
    ttHasTextFrame:SetPoint("TOPRIGHT", ttFrame, "TOPRIGHT", -10, vOffset)
    ttHasTextFrame:SetFontColor(0,1,0)

    if #hasList > 0 then
        vHeight =  vHeight + ttHasTextFrame:GetHeight()
        ttHasTextFrame:SetVisible(true)
    end

    ttFrame:SetHeight(vHeight)

    ttFrame:SetVisible(true)
    context:SetVisible(true)
end

local ttType, ttShown, ttBuff
local function IndyTooltip(rType, rShown, rBuff)
    if not Indy.showTooltips then
        return
    end

    ttType = rType or ttType
    ttShown = rShown or ttShown
    ttBuff = rBuff or ttBuff

    context:SetVisible(false)
    ttFrame:SetVisible(false)
    ttNeedsTextFrame:SetVisible(false)
    ttHasTextFrame:SetVisible(false)
    onNextFrameFunc = nil

    if not (ttType and ttShown) then return end

    if not (ttType == "item" or ttType == "itemtype") then return end

    local itemDetails = Inspect.Item.Detail(ttShown)

    if not itemDetails then return end

    if not itemDetails.category then return end

    if not (itemDetails.category:find("misc") and itemDetails.category:find("collectible")) then
        return
    end

    if itemDetails.stackMax == nil or itemDetails.stackMax ~= 99 then
        return
    end

    --local needList = Indy:WhoNeedsItem(itemDetails.type)
    local needList = {}
    local charList, itemCounts, setCount = Indy:WhoNeedsItem(itemDetails.type)

    if setCount == 0 then
        setCount = "??"
    end

    for i, v in ipairs(charList) do
        local verbose = ""
        if Indy.showVerboseTooltips then
            verbose = " (" .. itemCounts[i] .. "/" .. setCount .. ")"
        end
        table.insert(needList, charList[i] .. verbose)
    end

    --local hasList = Indy:WhoHasItem(itemDetails.type)
    local hasList = {}
    charList, itemCounts, setCount = Indy:WhoHasItem(itemDetails.type)

    if setCount == 0 then
        setCount = "??"
    end

    for i, v in ipairs(charList) do
        local verbose = ""
        if Indy.showVerboseTooltips then
            verbose = " (" .. itemCounts[i] .. "/" .. setCount .. ")"
        end
        table.insert(hasList, charList[i] .. verbose)
    end

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

Indy.IndyTooltip = IndyTooltip

table.insert(Event.Tooltip, {IndyTooltip, "Indy", "IndyTooltip"})
table.insert(Event.System.Update.Begin, {OnFrameUpdate, "Indy", "OnFrameUpdate"})
