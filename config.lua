local context = UI.CreateContext("Indy_ConfigContext")

local function CreateConfigWindow()
    local baseConfigWindow = UI.CreateFrame("SimpleWindow", "Indy_ConfigWindow", context)

    local buttonWidth = 135
    -- Make the dialog window 3 buttons and some padding wide
    baseConfigWindow:SetWidth(buttonWidth*3 + 40)
    baseConfigWindow:SetHeight(551)

    -- Add a close button to the top right corner
    baseConfigWindow:SetCloseButtonVisible(true)

    -- Set the title
    baseConfigWindow:SetTitle("Indiana Settings")

    -- Hide the window
    baseConfigWindow:SetVisible(false)

    return baseConfigWindow
end

local function CreateConfigFrame(parent)
    local configTexture = UI.CreateFrame("Texture", "Indy_ConfigFrame", parent)
    configTexture:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, 55)
    configTexture:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, -20)
    configTexture:SetTexture("Rift", "token_special_selected_normal.png.dds")
    configTexture:SetLayer(-1)

    return configTexture
end

local function CreateConfigOptionFrame(parent)
    -- Create a frame to hold the table of options
    local configTableFrame = UI.CreateFrame("Frame", "Indy_ConfigTableFrame", parent)
    configTableFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, 20)
    configTableFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, -20)

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
    configListFrame:SetPoint("TOPLEFT", parent, "CENTERLEFT", 30, -50)
    configListFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT",-30, -30)

    local configListTexture1 = UI.CreateFrame("Texture", "Indy_ConfigListTexture1", configListFrame)
    configListTexture1:SetPoint("TOPLEFT", configListFrame, "TOPLEFT", -5, -5)
    configListTexture1:SetPoint("BOTTOMRIGHT", configListFrame, "BOTTOMCENTER", -20, 5)
    configListTexture1:SetTexture("Rift", "inner_black_subwin_04.png.dds")

    -- Create a mask for the table of list names
    local configDoNotTrackListMask = UI.CreateFrame("SimpleScrollView", "Indy_ConfigListNamesMask1", configListTexture1)
    configDoNotTrackListMask:SetPoint("TOPLEFT", configListFrame, "TOPLEFT")
    configDoNotTrackListMask:SetPoint("BOTTOMRIGHT", configListFrame, "BOTTOMCENTER", -25, 0)
    configDoNotTrackListMask:SetBackgroundColor(0, 0, 0, 0)

    -- Create a frame to hold the table of list names
    local configDoNotTrackListFrame = UI.CreateFrame("SimpleList", "Indy_ConfigListNamesFrame1", configDoNotTrackListMask)
    configDoNotTrackListMask:SetContent(configDoNotTrackListFrame)
    configDoNotTrackListMask:SetScrollInterval(20)
    configDoNotTrackListFrame:SetBackgroundColor(0, 0, 0, 0)

    local configListTexture2 = UI.CreateFrame("Texture", "Indy_ConfigListTexture2", configListFrame)
    configListTexture2:SetPoint("TOPRIGHT", configListFrame, "TOPRIGHT", 5, -5)
    configListTexture2:SetPoint("BOTTOMLEFT", configListFrame, "BOTTOMCENTER", 20, 5)
    configListTexture2:SetTexture("Rift", "inner_black_subwin_04.png.dds")

    -- Create a mask for the table of list names
    local configTrackListMask = UI.CreateFrame("SimpleScrollView", "Indy_ConfigListNamesMask2", configListTexture2)
    configTrackListMask:SetPoint("TOPRIGHT", configListFrame, "TOPRIGHT")
    configTrackListMask:SetPoint("BOTTOMLEFT", configListFrame, "BOTTOMCENTER", 25, 0)
    configTrackListMask:SetBackgroundColor(0, 0, 0, 0)

    -- Create a frame to hold the table of list names
    local configTrackListFrame = UI.CreateFrame("SimpleList", "Indy_ConfigListNamesFrame2", configTrackListMask)
    configTrackListMask:SetContent(configTrackListFrame)
    configTrackListMask:SetScrollInterval(20)
    configTrackListFrame:SetBackgroundColor(0, 0, 0, 0)

    -- Attach a label to the top of the do not track list box
    local configDoNotTrackLabel = UI.CreateFrame("Text", "Indy_DoNotTrackLabel", configListFrame)
    configDoNotTrackLabel:SetPoint("BOTTOMLEFT", configDoNotTrackListFrame, "TOPLEFT", 0, -5)
    configDoNotTrackLabel:SetText("DO NOT TRACK")
    configDoNotTrackLabel:SetFontSize(16)
    configDoNotTrackLabel:SetFontColor(0.86,0.81,0.63)

    -- Attach a label to the top of the track list box
    local configTrackLabel = UI.CreateFrame("Text", "Indy_TrackLabel", configListFrame)
    configTrackLabel:SetPoint("BOTTOMLEFT", configTrackListFrame, "TOPLEFT", 0, -5)
    configTrackLabel:SetText("TRACK")
    configTrackLabel:SetFontSize(16)
    configTrackLabel:SetFontColor(0.86,0.81,0.63)

    -- Set functions for selecting a name from either list
    function configDoNotTrackListFrame.Event:ItemSelect(item)
        configTrackListFrame:ClearSelection()
    end

    function configTrackListFrame.Event:ItemSelect(item)
        configDoNotTrackListFrame:ClearSelection()
    end

    local trackButton = UI.CreateFrame("Texture", "Indy_TrackButton", configListFrame)
    trackButton:SetPoint("BOTTOMCENTER", configListFrame, "CENTERCENTER", 0, -2)
    trackButton:SetTexture("Indy", "textures/RightArrow_Normal.png")

    function trackButton.Event:MouseIn()
        self:SetTexture("Indy", "textures/RightArrow_Over.png")
    end

    function trackButton.Event:MouseOut()
        self:SetTexture("Indy", "textures/RightArrow_Normal.png")
    end

    function trackButton.Event:LeftDown()
        self:SetTexture("Indy", "textures/RightArrow_Down.png")
    end

    function trackButton.Event:LeftUp()
        self:SetTexture("Indy", "textures/RightArrow_Over.png")
    end

    trackButton.Event.LeftClick = function()
        local itemSelected = configDoNotTrackListFrame:GetSelectedItem()
        Indy:SetTrackStatus(itemSelected, true)
        local trackList, doNotTrackList = RefreshTrackLists()
        configDoNotTrackListFrame:SetItems(doNotTrackList)
        configTrackListFrame:SetItems(trackList)
    end

    local doNotTrackButton = UI.CreateFrame("Texture", "Indy_DoNotTrackButton", configListFrame)
    doNotTrackButton:SetPoint("TOPCENTER", configListFrame, "CENTERCENTER", 0, 2)
    doNotTrackButton:SetTexture("Indy", "textures/LeftArrow_Normal.png")

    function doNotTrackButton.Event:MouseIn()
        self:SetTexture("Indy", "textures/LeftArrow_Over.png")
    end

    function doNotTrackButton.Event:MouseOut()
        self:SetTexture("Indy", "textures/LeftArrow_Normal.png")
    end

    function doNotTrackButton.Event:LeftDown()
        self:SetTexture("Indy", "textures/LeftArrow_Down.png")
    end

    function doNotTrackButton.Event:LeftUp()
        self:SetTexture("Indy", "textures/LeftArrow_Over.png")
    end

    doNotTrackButton.Event.LeftClick = function()
        local itemSelected = configTrackListFrame:GetSelectedItem()
        Indy:SetTrackStatus(itemSelected, false)
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
    showTooltipBorder = {
        order = 11,
        type = "checkbox",
        label = "Show pretty tooltip borders",
        labelPos = "right",
        width = "full",
        get = function() return Indy.showTooltipBorder end,
        set = function(value) return Indy:ToggleShowTooltipBorder() end,
    },
    scanAH = {
        order = 20,
        type = "checkbox",
        label = "Scan AH for needed artifacts",
        labelPos = "right",
        width = "full",
        get = function() return Indy.scanAH end,
        set = function(value) return Indy:ToggleScanAH() end,
    },
    showIcon = {
        order = 30,
        type = "checkbox",
        label = "Show bag scan icon",
        labelPos = "right",
        width = "full",
        get = function() return Indy.showBagCheckButton end,
        set = function(value) return Indy:ToggleShowBagCheckButton() end,
    },
}

local function BuildConfigWindow()
    local configWindow = CreateConfigWindow()
    local configFrame = CreateConfigFrame(configWindow)
    local configOptionFrame = CreateConfigOptionFrame(configFrame)
    local configListFrame = CreateTrackListFrame(configFrame)

    Library.LibSimpleWidgets.Layout(CONFIG_TABLE, configOptionFrame)

    return configWindow
end

function Indy:ShowConfigWindow()
    if not self.configWindow then
        self.configWindow = BuildConfigWindow()
    end
    self.configWindow:SetVisible(true)
end

function Indy:ToggleShowTooltipBorder()
    self.showTooltipBorder = not self.showTooltipBorder
    print("Show pretty tooltip borders: " .. tostring(self.showTooltipBorder))

    self:UpdateTooltipBorder()
end
