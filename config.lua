local context = UI.CreateContext("Indy_ConfigContext")

local function CreateConfigWindow()
    local baseConfigWindow = UI.CreateFrame("SimpleWindow", "Indy_ConfigWindow", context)
    baseConfigWindow:SetPoint("CENTER", UIParent, "CENTER")

    local buttonWidth = 135
    -- Make the dialog window 3 buttons and some padding wide
    baseConfigWindow:SetWidth(buttonWidth*3 + 40)
    baseConfigWindow:SetHeight(700)

    -- Add a close button to the top right corner
    baseConfigWindow:SetCloseButtonVisible(true)

    -- Set the title
    baseConfigWindow:SetTitle("Indiana Settings")

    -- Hide the window
    baseConfigWindow:SetVisible(false)

    return baseConfigWindow
end

local function CreateConfigTabView(parent)
    local configTabView = UI.CreateFrame("SimpleTabView", "Indy_ConfigTabView", parent)

    configTabView:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, 55)
    configTabView:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, -20)

    return configTabView
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
    configListFrame:SetPoint("TOPLEFT", parent, "CENTERLEFT", 30, -30)
    configListFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT",-30, -60)

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

    -- Declaring reassignButton here so that we can refer to it sooner than the button is actually created
    local reassignButton

    -- Set functions for selecting a name from either list
    function configDoNotTrackListFrame.Event:ItemSelect(item)
        configTrackListFrame:ClearSelection()
        reassignButton:SetEnabled(item ~= Indy.charName)
    end

    function configTrackListFrame.Event:ItemSelect(item)
        configDoNotTrackListFrame:ClearSelection()
        reassignButton:SetEnabled(item ~= Indy.charName)
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

    -- Attach refresh function to the frame so we can call whenever
    function configListFrame:RefreshTrackLists()
        local trackList, doNotTrackList = RefreshTrackLists()
        configDoNotTrackListFrame:SetItems(doNotTrackList)
        configTrackListFrame:SetItems(trackList)
    end

    trackButton.Event.LeftClick = function()
        local itemSelected = configDoNotTrackListFrame:GetSelectedItem()
        Indy:SetTrackStatus(itemSelected, true)
        configListFrame:RefreshTrackLists()
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
        configListFrame:RefreshTrackLists()
    end

    configListFrame:RefreshTrackLists()

    -- Create reassign button underneath the List Frame
    reassignButton = UI.CreateFrame("RiftButton", "Indy_ReassignButton", configListFrame)
    reassignButton:SetPoint("TOPLEFT", configListFrame, "BOTTOMLEFT", 0, 5)
    reassignButton:SetText("Reassign")

    -- Call reassign window based on name selected from tracking lists
    function reassignButton.Event:LeftPress()
        local itemSelected

        itemSelected = configDoNotTrackListFrame:GetSelectedItem()
        if not itemSelected then
            itemSelected = configTrackListFrame:GetSelectedItem()
        end
        if not itemSelected then
            return
        end

        Indy:ShowReassignWindow(itemSelected)
    end

    return configListFrame

end

local function SaveHasColor()
    local rgb = {
        tonumber(Indy.hasColorWidget.r:GetText()) or 0,
        tonumber(Indy.hasColorWidget.g:GetText()) or 0,
        tonumber(Indy.hasColorWidget.b:GetText()) or 0,
        1
    }
    Indy.hasColor = rgb
end

local function RefreshHasSample()
    local r, g, b  = unpack(Indy.hasColor)
    Indy.hasColorWidget.sample:SetFontColor(r or 0, g or 0, b or 0)
end

local function SaveNeedColor()
    local rgb = {
        tonumber(Indy.needColorWidget.r:GetText()) or 0,
        tonumber(Indy.needColorWidget.g:GetText()) or 0,
        tonumber(Indy.needColorWidget.b:GetText()) or 0,
        1
    }
    Indy.needColor = rgb
end

local function RefreshNeedSample()
    local r, g, b  = unpack(Indy.needColor)
    Indy.needColorWidget.sample:SetFontColor(r or 0, g or 0, b or 0)
end

local function CreateColorWidget(parent, saveFn, refreshFn)
    local colorWidgetFrame = UI.CreateFrame("Frame", "Indy_ColorWidgetFrame", parent)

    local colorWidgetLabelR = UI.CreateFrame("Text", "Indy_ColorWidgetText1R", colorWidgetFrame)
    colorWidgetLabelR:SetPoint("TOPLEFT", colorWidgetFrame, "TOPLEFT", 0, 0)
    colorWidgetLabelR:SetText("R:")
    local colorWidgetInputR = UI.CreateFrame("RiftTextfield", "Indy_ColorWidgetInputR", colorWidgetFrame)
    colorWidgetInputR:SetPoint("TOPLEFT", colorWidgetLabelR, "TOPRIGHT", 5, 0)
    colorWidgetInputR:SetWidth(40)
    colorWidgetInputR:SetBackgroundColor(0,0,0,1)
    colorWidgetInputR:SetText("0.5")

    local colorWidgetLabelG = UI.CreateFrame("Text", "Indy_ColorWidgetText1G", colorWidgetFrame)
    colorWidgetLabelG:SetPoint("TOPLEFT", colorWidgetInputR, "TOPRIGHT", 10, 0)
    colorWidgetLabelG:SetText("G:")
    local colorWidgetInputG = UI.CreateFrame("RiftTextfield", "Indy_ColorWidgetInputG", colorWidgetFrame)
    colorWidgetInputG:SetPoint("TOPLEFT", colorWidgetLabelG, "TOPRIGHT", 5, 0)
    colorWidgetInputG:SetWidth(40)
    colorWidgetInputG:SetBackgroundColor(0,0,0,1)
    colorWidgetInputG:SetText("0.5")

    local colorWidgetLabelB = UI.CreateFrame("Text", "Indy_ColorWidgetText1B", colorWidgetFrame)
    colorWidgetLabelB:SetPoint("TOPLEFT", colorWidgetInputG, "TOPRIGHT", 10, 0)
    colorWidgetLabelB:SetText("B:")
    local colorWidgetInputB = UI.CreateFrame("RiftTextfield", "Indy_ColorWidgetInputB", colorWidgetFrame)
    colorWidgetInputB:SetPoint("TOPLEFT", colorWidgetLabelB, "TOPRIGHT", 5, 0)
    colorWidgetInputB:SetWidth(40)
    colorWidgetInputB:SetBackgroundColor(0,0,0,1)
    colorWidgetInputB:SetText("0.5")

    local colorWidgetSampleLabel = UI.CreateFrame("Text", "Indy_ColorWidgetSampleText1", colorWidgetFrame)
    colorWidgetSampleLabel:SetPoint("TOPLEFT", colorWidgetInputB, "TOPRIGHT", 10, 0)
    colorWidgetSampleLabel:SetText("Sample")
    colorWidgetSampleLabel:SetFontColor(1,0,0,1)
    colorWidgetSampleLabel:SetFontSize(14)
    colorWidgetSampleLabel:SetBackgroundColor(0,0,0,1)

    colorWidgetInputR.Event.TextfieldChange = function()
        saveFn()
        refreshFn()
    end
    colorWidgetInputG.Event.TextfieldChange = function()
        saveFn()
        refreshFn()
    end
    colorWidgetInputB.Event.TextfieldChange = function()
        saveFn()
        refreshFn()
    end

    local colorWidget = {
        frame = colorWidgetFrame,
        r = colorWidgetInputR,
        g = colorWidgetInputG,
        b = colorWidgetInputB,
        sample = colorWidgetSampleLabel,
    }

    return colorWidget
end

local function CreateConfigColorFrame(parent)
    local configTexture = UI.CreateFrame("Texture", "Indy_ConfigColorFrameTexture", parent)
    configTexture:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, 55)
    configTexture:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, -20)
    configTexture:SetTexture("Rift", "token_special_selected_normal.png.dds")
    configTexture:SetLayer(-1)

    parent = configTexture

    -- Create a frame to hold color options
    local configColorFrame = UI.CreateFrame("Frame", "Indy_ConfigColorFrame", parent)
    configColorFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, 20)
    configColorFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, -20)

    -- Set Has Color
    local configColorHasLabel = UI.CreateFrame("Text", "Indy_ConfigColorHasText", configColorFrame)
    configColorHasLabel:SetPoint("TOPLEFT", configColorFrame, "TOPLEFT", 20, 20)
    configColorHasLabel:SetText("ACQUIRED ARTIFACTS")
    configColorHasLabel:SetFontSize(16)
    configColorHasLabel:SetFontColor(0.86,0.81,0.63)

    local hasColorWidget = CreateColorWidget(configColorFrame, SaveHasColor, RefreshHasSample)
    hasColorWidget.frame:SetPoint("TOPLEFT", configColorHasLabel, "TOPLEFT", 0, 24)

    -- Set Needs Color
    local configColorNeedLabel = UI.CreateFrame("Text", "Indy_ConfigColorNeedText", configColorFrame)
    configColorNeedLabel:SetPoint("TOPLEFT", hasColorWidget.frame, "TOPLEFT", 0, 24)
    configColorNeedLabel:SetText("NEEDED ARTIFACTS")
    configColorNeedLabel:SetFontSize(16)
    configColorNeedLabel:SetFontColor(0.86,0.81,0.63)

    local needColorWidget = CreateColorWidget(configColorFrame, SaveNeedColor, RefreshNeedSample)
    needColorWidget.frame:SetPoint("TOPLEFT", configColorNeedLabel, "TOPLEFT", 0, 24)

    return configTexture, hasColorWidget, needColorWidget
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
    showVerboseTooltips = {
        order = 12,
        type = "checkbox",
        label = "Show verbose tooltips",
        labelPos = "right",
        width = "full",
        get = function() return Indy.showVerboseTooltips end,
        set = function(value) return Indy:ToggleShowVerboseTooltips() end,
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
    charPerLine = {
        order = 40,
        type = "checkbox",
        label = "Show single character per line",
        labelPos = "right",
        width = "full",
        get = function() return Indy.charPerLine end,
        set = function(value) return Indy:ToggleCharPerLine() end,
    },
    moveIcon = {
        order = 50,
        type = "checkbox",
        label = "Move bag scan icon",
        labelPos = "right",
        width = "full",
        get = function() return Indy.moveBagCheckButton end,
        set = function(value) return Indy:ToggleMoveBagCheckButton() end,
    },
}

local function BuildConfigWindow()
    local configWindow = CreateConfigWindow()
    local configFrame = CreateConfigFrame(configWindow)
    local configOptionFrame = CreateConfigOptionFrame(configFrame)
    local configListFrame = CreateTrackListFrame(configFrame)
    local configColorFrame, hasColorWidget, needColorWidget = CreateConfigColorFrame(configWindow)

    -- Set up tab view
    local configTabView = CreateConfigTabView(configWindow)
    configTabView:AddTab("General", configFrame)
    configTabView:AddTab("Colors", configColorFrame)

    Library.LibSimpleWidgets.Layout(CONFIG_TABLE, configOptionFrame)

    return configWindow, configOptionFrame, hasColorWidget, needColorWidget, configListFrame
end

function Indy:RefreshColorValues()
    local R, G, B = unpack(Indy.hasColor)
    self.hasColorWidget.r:SetText(tostring(R))
    self.hasColorWidget.g:SetText(tostring(G))
    self.hasColorWidget.b:SetText(tostring(B))
    self.hasColorWidget.sample:SetFontColor(R or 0, G or 0, B or 0,1)

    R, G, B = unpack(Indy.needColor)
    self.needColorWidget.r:SetText(tostring(R))
    self.needColorWidget.g:SetText(tostring(G))
    self.needColorWidget.b:SetText(tostring(B))
    self.needColorWidget.sample:SetFontColor(R or 0, G or 0, B or 0,1)
end

function Indy:ShowConfigWindow()
    if not self.configWindow then
        self.configWindow, self.configOptionFrame, self.hasColorWidget, self.needColorWidget, self.configListFrame = BuildConfigWindow()
    end
    Library.LibSimpleWidgets.Layout(CONFIG_TABLE, self.configOptionFrame)
    self:RefreshColorValues()
    self.configWindow:SetVisible(true)
end

function Indy:UpdateConfigWindow()
    if not self.configWindow then return end

    Library.LibSimpleWidgets.Layout(CONFIG_TABLE, self.configOptionFrame)
end

function Indy:ToggleShowTooltipBorder()
    self.showTooltipBorder = not self.showTooltipBorder
    print("Show pretty tooltip borders: " .. tostring(self.showTooltipBorder))
    self:UpdateConfigWindow()

    self:UpdateTooltipBorder()
end

function Indy:ToggleShowVerboseTooltips()
    self.showVerboseTooltips = not self.showVerboseTooltips
    print("Show verbose tooltips: " .. tostring(self.showVerboseTooltips))
    self:UpdateConfigWindow()

    Indy:UpdateTooltip()
end

function Indy:ToggleScanAH()
    self.scanAH = not self.scanAH
    print("Scan AH for artifacts: " .. tostring(self.scanAH))
    self:UpdateConfigWindow()
end

function Indy:ToggleScanBags()
    self.scanBags = not self.scanBags
    print("Scan bag updates for artifacts: " .. tostring(self.scanBags))
    self:UpdateConfigWindow()
end

function Indy:ToggleShowTooltips()
    self.showTooltips = not self.showTooltips
    print("Show Tooltips: " .. tostring(self.showTooltips))
    self:UpdateConfigWindow()

    Indy:UpdateTooltip()
end

function Indy:ToggleShowBagCheckButton()
    self.showBagCheckButton = not self.showBagCheckButton
    print("Show Bag Check Button: " .. tostring(self.showBagCheckButton))
    self:UpdateConfigWindow()

    self:ShowBagCheckButton()
end

function Indy:ToggleMoveBagCheckButton()
    self.moveBagCheckButton = not self.moveBagCheckButton
    print("Move Bag Check Button: " .. tostring(self.moveBagCheckButton))
    self:UpdateConfigWindow()
end

function Indy:ToggleCharPerLine()
    self.charPerLine = not self.charPerLine
    print("Show single character per line: " .. tostring(self.charPerLine))
    self:UpdateConfigWindow()
end

--------------------------------------------------------------------------------

local function CreateReassignWindow()
    local reassignWindow = UI.CreateFrame("SimpleWindow", "Indy_ReassignWindow", context)

    reassignWindow:SetPoint("CENTER", UIParent, "CENTER")
    reassignWindow:SetTitle("Reassign Character")
    reassignWindow:SetHeight(250)
    reassignWindow:SetLayer(1000)
    reassignWindow:SetVisible(false)

    return reassignWindow
end

local function CreateReassignMessageFrame(parent)
    local reassignMessageFrame = parent:GetContent()

    -- Create a frame for the message with a nice background
    local reassignTexture = UI.CreateFrame("Texture", "Indy_ConfigListTexture2", reassignMessageFrame)
    reassignTexture:SetPoint("TOPLEFT", reassignMessageFrame, "TOPLEFT", 10, -5)
    reassignTexture:SetPoint("BOTTOMRIGHT", reassignMessageFrame, "BOTTOMRIGHT", -10, -50)
    reassignTexture:SetTexture("Rift", "inner_black_subwin_04.png.dds")
    reassignTexture:SetLayer(1)

    local reassignMessageText = UI.CreateFrame("Text", "Indy_ReassignMessageText", reassignMessageFrame)
    reassignMessageText:SetPoint("TOPLEFT", reassignTexture, "TOPLEFT", 10, 10)
    reassignMessageText:SetPoint("BOTTOMRIGHT", reassignTexture, "BOTTOMRIGHT", -10, -10)
    reassignMessageText:SetLayer(2)

    -- Create Ok and Cancel buttons
    local cancelButton = UI.CreateFrame("RiftButton", "Indy_ReassignCancel", reassignMessageFrame)
    cancelButton:SetPoint("BOTTOMRIGHT", reassignMessageFrame, "BOTTOMRIGHT", -15, -10)
    cancelButton:SetText("Cancel")

    function cancelButton.Event:LeftPress()
        parent:SetVisible(false)
    end

    local okButton = UI.CreateFrame("RiftButton", "Indy_ReassignOk", reassignMessageFrame)
    okButton:SetPoint("BOTTOMRIGHT", cancelButton, "BOTTOMLEFT", 10, 0)
    okButton:SetText("Ok")

    function okButton.Event:LeftPress()
        Indy:ReassignArtifacts(parent.selectedChar, Indy.charName)
        parent:SetVisible(false)
    end

    return reassignMessageText
end

local function BuildReassignWindow()
    local reassignWindow = CreateReassignWindow()
    local reassignMessageText = CreateReassignMessageFrame(reassignWindow)

    return reassignWindow, reassignMessageText
end

function Indy:ShowReassignWindow(selectedChar)
    if not self.reassignWindow then
        self.reassignWindow, self.reassignMessageText = BuildReassignWindow()
    end
    local myString = "You are about to reassign the artifact list from " .. selectedChar .. " to the current character (" .. Indy.charName .. "). This will OVERWRITE " .. Indy.charName .. "'s data and DELETE " .. selectedChar .. "'s data. Do you wish to proceed?"
    self.reassignMessageText:SetText(myString)
    self.reassignMessageText:SetWordwrap(true)
    self.reassignWindow:SetVisible(true)

    self.reassignWindow.selectedChar = selectedChar
end

function Indy:ReassignArtifacts(fromChar, toChar)
    if fromChar == toChar then
        return
    end

    for artifactId, _ in pairs(self.artifactTable) do
        local fromArtifactStatus = self.artifactTable[artifactId][fromChar]
        if fromArtifactStatus ~= nil and fromArtifactStatus > 0 then
            local toArtifactStatus = self.artifactTable[artifactId][toChar]
            if toArtifactStatus == nil then toArtifactStatus = 0 end
            self.artifactTable[artifactId][toChar] = math.max(fromArtifactStatus, toArtifactStatus)
            -- Remove the entry from the artifact ID
            self.artifactTable[artifactId][fromChar] = nil
        end
    end

    -- Remove the char from the lilst of collections to be tracked
    self.trackCollectionsForChars[fromChar] = nil

    -- Update the tracking lists so that they do not display the old char
    self.configListFrame:RefreshTrackLists()
    print("Artifacts reassigned from " .. tostring(fromChar) .. " to " .. tostring(toChar))
end
