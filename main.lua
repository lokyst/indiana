Indy = {}

-- Some useful generic functions
local function strsplit(delimiter, text)
    local list = {}
    local pos = 1
    if string.find("", delimiter, 1) then -- this would result in endless loops
        error("delimiter matches empty string!")
    end
    while 1 do
        local first, last = string.find(text, delimiter, pos)
        if first then -- found?
            table.insert(list, string.sub(text, pos, first-1))
            pos = last+1
        else
            table.insert(list, string.sub(text, pos))
            break
        end
    end
    return list
end

local function strtrim(s)
    if not s then
        return nil
    end

    return s:match'^%s*(.*%S)' or ''
end

-- Define default values. Default value must never be nil

local function AllArtifactIds()
    local allIds = {}
    for _, ids in pairs(INDY_ArtifactCollections) do
        for id, _ in pairs(ids) do
            allIds[id] = {}
        end
    end
    return allIds
end

local profile = {
    trackCollectionsForChars = {},
    artifactTable = AllArtifactIds(),
    scanBags = false,
    scanAH = false,
    showTooltips = true,
    showBagCheckButton = true,
    showTooltipBorder = true,
    unassignedArtifacts = {},
    unnamedArtifacts = {},
}

local function Initialize(addonName)
    -- Do not put anything that can crash after this point
    if addonName ~= "Indy" then
        return
    end

    -- Set default values
    if not Indy_SavedVariables then
        -- Has to be global for toc
        --noinspection GlobalCreationOutsideO
        Indy_SavedVariables = {}
    end

    for key, value in pairs(profile) do
        if Indy_SavedVariables[key] == nil then
            Indy[key] = value
        else
            Indy[key] = Indy_SavedVariables[key]
        end
    end

    -- Do not put anything before this point

    -- Get current character's name
    local playerDetails = Inspect.Unit.Detail("player")
    local charName = playerDetails.name
    Indy.charName = charName

    -- Automatically add new characters to the track list
    if Indy.trackCollectionsForChars[charName] == nil then
        Indy.trackCollectionsForChars[charName] = true
    end

    Indy:ShowBagCheckButton()

    -- Initialize frames
    Indy:UpdateTooltipBorder()

    Indy.newList = Indy:ConvertArtifactTableFrom0To1()

    print("Indiana's Artifact Tracker loaded. Type /indy or /indy help for options.")
end

local function CheckForUnknownItems(tableOfItemIds)
    local itemDetails
    local artifactId
    local artifactName = ""

    local tableOfItemDetails = Inspect.Item.Detail(tableOfItemIds)

    for _, itemDetails in pairs(tableOfItemDetails) do
        -- Check if it is a collectible item
        if itemDetails and itemDetails.category and
                itemDetails.category:find("misc") and
                itemDetails.category:find("collectible") and
                itemDetails.stackMax and
                itemDetails.stackMax == 99 then
            artifactId = itemDetails.type
            artifactName = itemDetails.name

            -- Check if there is a record of it in our artifact list
            if artifactId ~= "" and not Indy.artifactTable[artifactId] then
                Indy.artifactTable[artifactId] = {}
                print("New artifact recorded: [" .. artifactName .. "]")
            end
        end
    end
end

local function OnTooltipChange(ttType, ttShown, ttBuff)
    local itemDetails = {}
    local artifactId

    if ttType and ttShown and (ttType == "itemtype" or ttType == "item") then
        CheckForUnknownItems({ttShown})
    end
end

local function InspectTooltip()
    local itemDetails = {}
    local artifactId

    local ttType, ttShown = Inspect.Tooltip()

    if ttType and ttShown and (ttType == "itemtype" or ttType == "item") then
        itemDetails = Inspect.Item.Detail(ttShown)
        artifactId = itemDetails.type
    end

    return artifactId

end

local function OnBagEvent(tableOfSlots)
    if not Indy.scanBags then
        return
    end

    CheckForUnknownItems(tableOfSlots)

    local tableOfItemDetails = Inspect.Item.Detail(tableOfSlots)
    local artifactId
    local artifactName = ""
    local charList = {}

    for slot, itemDetails in pairs(tableOfItemDetails) do
        if itemDetails.category and itemDetails.category:find("collectible") then
            artifactId = itemDetails.type
            artifactName = itemDetails.name

            -- Print a list of chars who need this item
            charList = Indy:WhoNeedsItem(artifactId)
            if #charList > 0 then
                print("[" .. artifactName .. "] needed by: " .. table.concat(charList, ", "))
            end
        end
    end

end

local function OnAuctionScan(tableOfTypes, tableOfAuctions)
    if not Indy.scanAH then
        return
    end

    --Indy.AHData = nil
    --Indy.AHData = tableOfAuctions

    -- Check that AH Data is paged before processing
    if tableOfTypes.index and tableOfTypes.index >= 0 then
        local tableOfAuctionsByChar = Indy:ProcessAHData(tableOfAuctions)
        Indy:PrintAuctionsByChar(tableOfAuctions, tableOfAuctionsByChar)
    end

end

local function SlashHandler(arg)
    local cmds = strsplit(" ", arg)
    local cmd = string.lower(cmds[1])
    local name
    if cmd == "reset" then
        Indy:ResetList()

    elseif cmd == "additem" then
        local artifactId = InspectTooltip()
        if not artifactId then
            return
        end

        Indy:AddItemToChar(artifactId)

        local itemDetails = Inspect.Item.Detail(artifactId)
        local artifactName = itemDetails.name
        print(Indy.charName .. " has collected [" .. artifactName .. "]")

    elseif cmd == "deleteitem" then
        local artifactId = InspectTooltip()
        if not artifactId then
            return
        end

        Indy:DeleteItemFromChar(artifactId)

        local itemDetails = Inspect.Item.Detail(artifactId)
        local artifactName = itemDetails.name
        print(Indy.charName .. " has deleted [" .. artifactName .. "]")

    elseif cmd == "whohasitem" then
        local artifactId = InspectTooltip()
        local charList = Indy:WhoHasItem(artifactId)

        print(tostring(table.concat(charList, ", ")))

    elseif cmd == "whoneedsitem" then
        local artifactId = InspectTooltip()
        local charList = Indy:WhoNeedsItem(artifactId)

        print(tostring(table.concat(charList, ", ")))

    elseif cmd == "dotrack" then
        Indy:AddCharToTrackList(Indy.charName)

    elseif cmd == "donottrack" then
        Indy:RemoveCharFromTrackList(Indy.charName)

    elseif cmd == "checkbags" then
        Indy:CheckBagsForArtifacts()

    elseif cmd == "scanbags" then
        Indy:ToggleScanBags()

    elseif cmd == "scanah" then
        Indy:ToggleScanAH()

    elseif cmd == "showtooltips" then
        Indy:ToggleShowTooltips()

    elseif cmd == "showtooltipborder" then
        Indy:ToggleShowTooltipBorder()

    elseif cmd == "assign" then
        Indy:ShowAssignmentWindow()

    elseif cmd == "config" then
        Indy:ShowConfigWindow()

    --elseif cmd == "processah" then
    --    Indy:ProcessAHData(Indy.AHData)

    --elseif cmd == "scanachievements" then
    --    Indy:ScanAchievements(Indy.nextAchievementKey)

    elseif cmd == "help" then
        Indy:PrintHelp()

    else
        Indy:ShowConfigWindow()

    end

end

table.insert(Event.Addon.Load.End, {Initialize, "Indy", "Initialize"})
table.insert(Event.Tooltip, {OnTooltipChange, "Indy", "OnTooltipChange"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {function() Indy:SaveVars() end, "Indy", "Save variables"})
table.insert(Command.Slash.Register("indy"), {SlashHandler, "Indy", "Slash Handler"})
table.insert(Event.Item.Slot, {OnBagEvent, "Indy", "OnBagEvent"})
table.insert(Event.Item.Update, {OnBagEvent, "Indy", "OnBagEvent"})
table.insert(Event.Auction.Scan, {OnAuctionScan, "Indy", "OnAuctionScan"})

------------------------ Indy functions begin here -----------------------------

function Indy:SaveVars()
    for key, _ in pairs(profile) do
        -- Avoid overwriting with nil in the event that the addon crashes
        if not (Indy[key] == nil) then
            Indy_SavedVariables[key] = Indy[key]
        end
    end
end

function Indy:ResetList()
    Indy.artifactTable = {}
end

function Indy:AddItemToChar(artifactId)
    if not artifactId then
        return
    end
    local charName = self.charName

    CheckForUnknownItems({artifactId})

    if self.artifactTable[artifactId] ~= nil then
        self.artifactTable[artifactId].charList[charName] = true
    end
end

function Indy:DeleteItemFromChar(artifactId)
    if not artifactId then
        return
    end
    local charName = self.charName

    CheckForUnknownItems({artifactId})

    if self.artifactTable[artifactId] ~= nil then
        self.artifactTable[artifactId].charList[charName] = nil
    end
end

function Indy:WhoHasItem(artifactId)
    local charList = {}

    if self.artifactTable[artifactId] then
        for name, trackStatus in pairs(self.trackCollectionsForChars) do
            if trackStatus then
                local statusCollected = self.artifactTable[artifactId].charList[name]
                if statusCollected then
                    table.insert(charList, name)
                end
            end
        end
    end

    return charList
end

function Indy:WhoNeedsItem(artifactId)
    local charList = {}

    if self.artifactTable[artifactId] then
        for name, trackStatus in pairs(self.trackCollectionsForChars) do
            if trackStatus then
                local statusCollected = self.artifactTable[artifactId].charList[name]
                if not statusCollected then
                    table.insert(charList, name)
                end
            end
        end
    end

    return charList
end

function Indy:AddCharToTrackList(charName)
    Indy.trackCollectionsForChars[charName] = true
end

function Indy:RemoveCharFromTrackList(charName)
    Indy.trackCollectionsForChars[charName] = false
end

function Indy:CheckBagsForArtifacts()
    local slots = Utility.Item.Slot.All()
    local itemIds = Inspect.Item.List(slots)
    local tableOfItemDetails = Inspect.Item.Detail(itemIds)
    local artifactId
    local artifactName = ""
    local charList = {}

    CheckForUnknownItems(itemIds)

    for itemId, itemDetails in pairs(tableOfItemDetails) do
        if itemDetails.category and itemDetails.category:find("collectible") then
            artifactId = itemDetails.type
            artifactName = itemDetails.name

            -- Print a list of chars who need this item
            charList = self:WhoNeedsItem(artifactId)
            if #charList > 0 then
                print("[" .. artifactName .. "] needed by: " .. table.concat(charList, ", "))
            end
        end
    end

end

function Indy:ToggleScanAH()
    self.scanAH = not self.scanAH
    print("Scan AH for artifacts: " .. tostring(self.scanAH))
end

function Indy:ToggleScanBags()
    self.scanBags = not self.scanBags
    print("Scan bag updates for artifacts: " .. tostring(self.scanBags))
end

function Indy:ProcessAHData(tableOfAuctions)
    if not tableOfAuctions then
        return
    end

    local tableOfAuctionDetails = Inspect.Auction.Detail(tableOfAuctions)

    local itemId = ""
    local itemDetails = {}
    local artifactId = ""
    local artifactName = ""
    local charList = {}
    local tableOfAuctionsByChar = {}

    for _, auctionDetails in pairs(tableOfAuctionDetails) do
        local auctionId = auctionDetails.id
        itemId = auctionDetails.item
        itemDetails = Inspect.Item.Detail(itemId)

        CheckForUnknownItems({itemId})

        if itemDetails.category and itemDetails.category:find("collectible") then
            artifactId = itemDetails.type
            artifactName = itemDetails.name

            -- Return a list of chars who need this item
            charList = self:WhoNeedsItem(artifactId)
            tableOfAuctionsByChar[auctionId] = charList

        end

    end

    return tableOfAuctionsByChar

end

function Indy:PrintAuctionsByChar(tableOfAuctions, tableOfAuctionsByChar)
    local auctionDetails = {}
    local itemId = ""
    local itemDetails = {}
    local artifactName = ""
    local auctionBid
    local auctionBuyout

    for auctionId, charList in pairs(tableOfAuctionsByChar) do
        auctionDetails = Inspect.Auction.Detail(auctionId)
        auctionBid = auctionDetails.bid
        auctionBuyout = auctionDetails.buyout
        itemId = auctionDetails.item
        itemDetails = Inspect.Item.Detail(itemId)
        artifactName = itemDetails.name

        if #charList > 0 then
            print("[" .. artifactName .. "] Bid: " .. tostring(auctionBid) .. " BO: " .. tostring(auctionBuyout) .. " needed by: " .. table.concat(charList, ", "))
        end
    end
end

function Indy:SetTrackStatus(charName, bool)
    if not charName then
        return
    end
    self.trackCollectionsForChars[charName] = bool
end

function Indy:ToggleShowTooltips()
    self.showTooltips = not self.showTooltips
    print("Show Tooltips: " .. tostring(self.showTooltips))
end

function Indy:ToggleShowBagCheckButton()
    self.showBagCheckButton = not self.showBagCheckButton
    print("Show Bag Check Button: " .. tostring(self.showBagCheckButton))
    self:ShowBagCheckButton()
end

function Indy:PrintHelp()
    print("Indiana's Artifact Tracker")
    --print("/indy reset - DANGER!!! Clears the list of known artifacts. DANGER!!!")
    print("/indy additem - adds the mouse-overed item to the list of collected artifacts for this character")
    print("/indy deleteitem - removes the mouse-overed item from the list of collected artifacts for this character")
    print("/indy whohasitem - returns a list of the characters who have the mouse-overed item")
    print("/indy whoneedsitem - returns a list of the characters who need the mouse-overed item")
    print("/indy dotrack - adds the current character to the list of characters tracking collections")
    print("/indy donottrack - removes the current character from the list of characters tracking collections")
    print("/indy checkbags - check bags for artifacts")
    --print("/indy scanbags - toggle scanning bag updates for artifacts")
    print("/indy scanah - toggle scanning AH for artifacts  (" .. tostring(self.scanBags) .. ")")
    print("/indy showtooltips - toggle display of tooltips for artifacts (" .. tostring(self.showTooltips) .. ")")
    print("/indy showtooltipborder - toggle display of pretty tooltip borders (" .. tostring(self.showTooltipBorder) .. ")")
    print("/indy config - opens the configuration window")
    print("/indy help - prints this message")
end
