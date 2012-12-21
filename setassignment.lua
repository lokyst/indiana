local context = UI.CreateContext("Indy_SetAssignmentUI")

local function CreateAssignmentWindow()
    local baseAssignWindow = UI.CreateFrame("SimpleWindow", "Indy_AssignmentWindow", context)

    local buttonWidth = 135
    -- Make the dialog window 3 buttons and some padding wide
    baseAssignWindow:SetWidth(buttonWidth*3 + 40)
    baseAssignWindow:SetHeight(551)

    -- Add a close button to the top right corner
    baseAssignWindow:SetCloseButtonVisible(true)

    -- Set the title
    baseAssignWindow:SetTitle("Indiana Set Assignment")

    -- Hide the window
    baseAssignWindow:SetVisible(false)

    return baseAssignWindow
end

local function CreateAssignmentFrame(parent)
    local assignTexture = UI.CreateFrame("Texture", "Indy_AssignFrame", parent)
    assignTexture:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, 55)
    assignTexture:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, -20)
    assignTexture:SetTexture("Rift", "token_special_selected_normal.png.dds")
    assignTexture:SetLayer(-1)
    assignTexture:SetBackgroundColor(0, 0, 0, 0)

    return assignTexture
end

local function CreateAssignmentListFrame(parent)
    -- Create a frame to hold the list management section
    local assignFrame = UI.CreateFrame("Frame", "Indy_AssignListFrame1", parent)
    assignFrame:SetPoint("TOPLEFT", parent, "CENTERLEFT", 30, -50)
    assignFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT",-30, -30)

    local assignListTexture1 = UI.CreateFrame("Texture", "Indy_AssignListTexture1", assignFrame)
    assignListTexture1:SetPoint("TOPLEFT", assignFrame, "TOPLEFT", -5, -5)
    assignListTexture1:SetPoint("BOTTOMRIGHT", assignFrame, "BOTTOMRIGHT", 5, 5)
    assignListTexture1:SetTexture("Rift", "inner_black_subwin_04.png.dds")
    assignListTexture1:SetBackgroundColor(0, 0, 0, 0)

    -- Create a mask for the table of list names
    local assignListMask = UI.CreateFrame("SimpleScrollView", "Indy_AssignListNamesMask1", assignListTexture1)
    assignListMask:SetPoint("TOPLEFT", assignFrame, "TOPLEFT")
    assignListMask:SetPoint("BOTTOMRIGHT", assignFrame, "BOTTOMRIGHT", 0, 0)
    assignListMask:SetBackgroundColor(0, 0, 0, 0)

    -- Create a frame to hold the table of list names
    assignListFrame = UI.CreateFrame("SimpleList", "Indy_AssignListNamesFrame1", assignListMask)
    assignListMask:SetContent(assignListFrame)
    assignListMask:SetScrollInterval(20)
    assignListFrame:SetBackgroundColor(0, 0, 0, 0)

    local assignSelect = UI.CreateFrame("SimpleSelect", "Indy_AssignSelect", assignFrame)
    assignSelect:SetPoint("BOTTOMLEFT", assignFrame, "TOPLEFT", 0, -30)
    assignSelect:SetWidth(assignFrame:GetWidth())
    --assignSelect:ClearWidth()
    --assignSelect:SetPoint("BOTTOMRIGHT", assignFrame, "TOPRIGHT", 0, 20)

    assignSelect.Event.ItemSelect = function(assignSelect, item, value, index)
        local sets = Indy:FindArtifactSetsContainingId(value)
        local setList = {}

        for k, _ in pairs(sets) do
            table.insert(setList, k)
        end

        assignListFrame:SetItems(setList)
    end

    return assignSelect
end

local function BuildAssignmentWindow()
    local assignWindow = CreateAssignmentWindow()
    local assignFrame = CreateAssignmentFrame(assignWindow)
    local assignSelect = CreateAssignmentListFrame(assignFrame)

    return assignWindow, assignSelect
end

local function GetUnassignedArtifactsList()
    local nameList = {}
    local idList = {}

    local itemDetails = Inspect.Item.Detail(Indy.unassignedArtifacts)

    for itemId, itemDetail in pairs(itemDetails) do
        table.insert(nameList, itemDetail.name)
        table.insert(idList, itemId)
    end

    return nameList, idList
end

function Indy:ShowAssignmentWindow()
    if not self.assignWindow then
        self.assignWindow, self.assignSelect = BuildAssignmentWindow()
    end
    self.assignWindow:SetVisible(true)

    local nameList, idList = GetUnassignedArtifactsList()

    self.assignSelect:SetItems(nameList, idList)
end
