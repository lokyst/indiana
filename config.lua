local context = UI.CreateContext("Indy_ConfigContext")

local function CreateConfigWindow()
    local baseConfigWindow = UI.CreateFrame("SimpleWindow", "Indy_ConfigWindow", context)

    local buttonWidth = 135
    -- Make the dialog window 3 buttons and some padding wide
    baseConfigWindow:SetWidth(buttonWidth*3 + 40)
    baseConfigWindow:SetHeight(551)

    -- Add a close button to the top right corner
    baseConfigWindow:SetCloseButtonVisible(true)

    -- Hide the window
    baseConfigWindow:SetVisible(false)

    return baseConfigWindow
end

local function CreateConfigFrame(parent)
    local configFrame = UI.CreateFrame("Frame", "Indy_ConfigFrame", parent)
    configFrame:SetAllPoints(parent)

    return configFrame
end

local function CreateConfigOptionFrame(parent)
    -- Create a frame to hold the table of options
    local configTableFrame = UI.CreateFrame("Frame", "Indy_ConfigTableFrame", parent)
    configTableFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 50, 70)
    configTableFrame:SetPoint("BOTTOMRIGHT", parent, "CENTERRIGHT", -50, -100)

    return configTableFrame
end

local function RefreshTrackLists()
    local doNotTrackList = {}
    local trackList = {}
    for k,v in pairs(Indy.trackCollectionsForChars) do
        if v then
            table.insert(trackList, k)
        else
            table.insert(doNotTrackList, k)
        end
    end

    return trackList, doNotTrackList
end

local function CreateTrackListFrame(parent)
    -- Create a frame to hold the list management section
    local configListFrame = UI.CreateFrame("Frame", "Indy_ConfigListFrame1", parent)
    configListFrame:SetPoint("TOPLEFT", parent, "CENTERLEFT", 50, -50)
    configListFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT",-50, -70)

    -- Create a mask for the table of list names
    local configDoNotTrackListMask = UI.CreateFrame("SimpleScrollView", "Indy_ConfigListNamesMask1", configListFrame)
    configDoNotTrackListMask:SetPoint("TOPLEFT", configListFrame, "TOPLEFT")
    configDoNotTrackListMask:SetPoint("BOTTOMRIGHT", configListFrame, "BOTTOMCENTER", -25, 0)
    configDoNotTrackListMask:SetBackgroundColor(0, 0, 0, 1)

    -- Create a frame to hold the table of list names
    configDoNotTrackListFrame = UI.CreateFrame("SimpleList", "Indy_ConfigListNamesFrame1", configDoNotTrackListMask)
    configDoNotTrackListMask:SetContent(configDoNotTrackListFrame)
    configDoNotTrackListMask:SetScrollInterval(20)
    function configDoNotTrackListFrame.Event:ItemSelect(item)
        Indy.doNotTrackListSelected = item
    end

    -- Create a mask for the table of list names
    local configTrackListMask = UI.CreateFrame("SimpleScrollView", "Indy_ConfigListNamesMask2", configListFrame)
    configTrackListMask:SetPoint("TOPRIGHT", configListFrame, "TOPRIGHT")
    configTrackListMask:SetPoint("BOTTOMLEFT", configListFrame, "BOTTOMCENTER", 25, 0)
    configTrackListMask:SetBackgroundColor(0, 0, 0, 1)

    -- Create a frame to hold the table of list names
    configTrackListFrame = UI.CreateFrame("SimpleList", "Indy_ConfigListNamesFrame2", configTrackListMask)
    configTrackListMask:SetContent(configTrackListFrame)
    configTrackListMask:SetScrollInterval(20)
    function configTrackListFrame.Event:ItemSelect(item)
        Indy.trackListSelected = item
    end

    local trackButton = UI.CreateFrame("Texture", "Indy_TrackButton", configListFrame)
    trackButton:SetPoint("BOTTOMCENTER", configListFrame, "CENTERCENTER", 0, -10)
    trackButton:SetTexture("Indy", "textures/sq_next_icon&24.png")
    trackButton:SetAlpha(0.75)

    function trackButton.Event:MouseIn()
        self:SetAlpha(1)
    end

    function trackButton.Event:MouseOut()
        self:SetAlpha(0.75)
    end

    trackButton.Event.LeftClick = function()
        Indy:SetTrackStatus(Indy.doNotTrackListSelected, true)
        local trackList, doNotTrackList = RefreshTrackLists()
        configDoNotTrackListFrame:SetItems(doNotTrackList)
        configTrackListFrame:SetItems(trackList)
    end

    local doNotTrackButton = UI.CreateFrame("Texture", "Indy_DoNotTrackButton", configListFrame)
    doNotTrackButton:SetPoint("TOPCENTER", configListFrame, "CENTERCENTER", 0, 10)
    doNotTrackButton:SetTexture("Indy", "textures/sq_prev_icon&24.png")
    doNotTrackButton:SetAlpha(0.75)

    function doNotTrackButton.Event:MouseIn()
        self:SetAlpha(1)
    end

    function doNotTrackButton.Event:MouseOut()
        self:SetAlpha(0.75)
    end

    doNotTrackButton.Event.LeftClick = function()
        Indy:SetTrackStatus(Indy.trackListSelected, false)
        local trackList, doNotTrackList = RefreshTrackLists()
        configDoNotTrackListFrame:SetItems(doNotTrackList)
        configTrackListFrame:SetItems(trackList)
    end

    local trackList, doNotTrackList = RefreshTrackLists()
    configDoNotTrackListFrame:SetItems(doNotTrackList)
    configTrackListFrame:SetItems(trackList)

    return configListFrame

end

local CONFIG_TABLE = {
    showTooltips = {
        order = 10,
        type = "checkbox",
        label = "Show collected status under artifact tooltips",
        labelPos = "right",
        width = "full",
        get = function() return Indy.showTooltips end,
        set = function(value) return Indy:ToggleShowTooltips() end,
    },
}

function Indy:BuildConfigWindow()
    local configWindow = CreateConfigWindow()
    local configFrame = CreateConfigFrame(configWindow)
    local configOptionFrame = CreateConfigOptionFrame(configFrame)
    local configListFrame = CreateTrackListFrame(configFrame)

    Library.LibSimpleWidgets.Layout(CONFIG_TABLE, configOptionFrame)

    return configWindow

end