local addon, private = ...
local strsplit = private.strsplit
local strtrim = private.strtrim

Indy = {}

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

local SETS_BY_ID = {}
local function ConstructSetsByIdTable()
    for setName, ids in pairs(INDY_ArtifactCollections) do
        for id, _ in pairs(ids) do
            if SETS_BY_ID[id] then  -- already exists
                if not SETS_BY_ID[id].sets[setName] then
                    SETS_BY_ID[id].sets[setName] = true
                    SETS_BY_ID[id].setCount = SETS_BY_ID[id].setCount + 1
                end

            else
                SETS_BY_ID[id] = {}
                SETS_BY_ID[id].sets = {}
                SETS_BY_ID[id].sets[setName] = true
                SETS_BY_ID[id].setCount = 1
            end
        end
    end
end

local ITEM_CACHE = {}
function Indy:InspectItemDetail(itemId)
    -- Cache item data for repeat queries
    local itemDetails
    if ITEM_CACHE[itemId] then
        itemDetails = ITEM_CACHE[itemId]
    else
        itemDetails = Inspect.Item.Detail(itemId)
        ITEM_CACHE[itemId] = itemDetails
    end
    return itemDetails
end

function Indy:AddNewArtifacts()
    local allIds =  AllArtifactIds()
    local artifactTable = Indy.artifactTable

    for artifactId, _ in pairs(allIds) do
        if artifactTable[artifactId] == nil then
            artifactTable[artifactId] = {}
        end
    end
end

local profile = {
    trackCollectionsForChars = {},
    artifactTableVersion = 0,
    artifactTable = AllArtifactIds(),
    scanBags = false,
    scanAH = false,
    showTooltips = true,
    showVerboseTooltips = true,
    showBagCheckButton = true,
    moveBagCheckButton = false,
    showTooltipBorder = true,
    hasColor = {0,1,0,1},
    needColor = {1,0,0,1},
    charPerLine = false,
    posX = false,
    posY = false,
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

    -- Perform table conversions
    Indy.artifactTable = Indy:ConvertArtifactTableFrom0To1()

    -- Construct lookup table of item sets by itemId
    ConstructSetsByIdTable()

    -- Update profile artifact list with any new artifacts in INDY_ArtifactCollections
    Indy:AddNewArtifacts()

    -- Migrate existing data to new artifact Ids if necessary
    private.MigrateArtifacts(Indy)

    -- Initialize frames
    Indy:UpdateTooltipBorder()
    Indy:ShowBagCheckButton()

    print("Indiana's Artifact Tracker loaded. Type /indy or /indy help for options.")
end

local function CheckForUnknownItemsInItemDetailsTable(tableOfItemDetails)
    local itemDetails
    local artifactId
    local artifactName = ""

    for _, itemDetails in pairs(tableOfItemDetails) do
        -- Check if it is a collectible item
        if itemDetails and itemDetails.category and
                ((itemDetails.category:find("misc") and
                itemDetails.category:find("collectible")) or
                itemDetails.category:find("artifact")) and
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

local function CheckForUnknownItems(tableOfItemIds)
    local tableOfItemDetails = Inspect.Item.Detail(tableOfItemIds)

    CheckForUnknownItemsInItemDetailsTable(tableOfItemDetails)
end

local function OnTooltipChange(ttType, ttShown, ttBuff)
    local itemDetails = {}
    local artifactId

    if ttType and ttShown and (ttType == "itemtype" or ttType == "item") then
        itemDetails = Indy:InspectItemDetail(ttShown)
        if itemDetails then
            artifactId = itemDetails.type
        end

        CheckForUnknownItems({artifactId})
    end
end

local function InspectTooltip()
    local itemDetails = {}
    local artifactId

    local ttType, ttShown = Inspect.Tooltip()

    if ttType and ttShown and (ttType == "itemtype" or ttType == "item") then
        itemDetails = Indy:InspectItemDetail(ttShown)
        if itemDetails then
            artifactId = itemDetails.type
        end
    end

    return artifactId

end

local function OnBagEvent(tableOfSlots)
    if not Indy.scanBags then
        return
    end

    --CheckForUnknownItems(tableOfSlots)
    local tableOfItemDetails = Inspect.Item.Detail(tableOfSlots)
    CheckForUnknownItemsInItemDetailsTable(tableOfItemDetails)

    local artifactId
    local artifactName = ""
    local charList = {}

    for slot, itemDetails in pairs(tableOfItemDetails) do
        if itemDetails.category and (itemDetails.category:find("collectible") or itemDetails.category:find("artifact")) then
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
        Indy:PrintAuctionsByChar(tableOfAuctions, tableOfAuctionsByChar) -- *** PERFORMANCE WARNING *** --
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

        local itemDetails = Indy:InspectItemDetail(artifactId)
        local artifactName = itemDetails.name
        Indy:UpdateTooltip()
        print(Indy.charName .. " has collected [" .. artifactName .. "]")

    elseif cmd == "deleteitem" then
        local artifactId = InspectTooltip()
        if not artifactId then
            return
        end

        Indy:DeleteItemFromChar(artifactId)

        local itemDetails = Indy:InspectItemDetail(artifactId)
        local artifactName = itemDetails.name
        Indy:UpdateTooltip()
        print(Indy.charName .. " has deleted [" .. artifactName .. "]")

    elseif cmd == "whohasitem" then
        local artifactId = InspectTooltip()
        local charList, itemCounts, setCount = Indy:WhoHasItem(artifactId)

        if setCount == 0 then
            setCount = "??"
        end

        local hasStrings = {}
        for i, v in ipairs(charList) do
            table.insert(hasStrings, charList[i] .. "(" .. itemCounts[i] .. "/" .. setCount .. ")")
        end

        print(tostring(table.concat(hasStrings, ", ")))

    elseif cmd == "whoneedsitem" then
        local artifactId = InspectTooltip()
        local charList, itemCounts, setCount = Indy:WhoNeedsItem(artifactId)

        if setCount == 0 then
            setCount = "??"
        end

        local needsStrings = {}
        for i, v in ipairs(charList) do
            table.insert(needsStrings, charList[i] .. "(" .. itemCounts[i] .. "/" .. setCount .. ")")
        end

        print(tostring(table.concat(needsStrings, ", ")))

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

    elseif cmd == "showverbosetooltips" then
        Indy:ToggleShowVerboseTooltips()

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
        local _, setCount = self:FindArtifactSetsContainingId(artifactId)

        if not self.artifactTable[artifactId][charName] then
            self.artifactTable[artifactId][charName] = 0
        end

        if setCount > 0 then
            if self.artifactTable[artifactId][charName] < setCount then
                self.artifactTable[artifactId][charName] = self.artifactTable[artifactId][charName] + 1
            end
        else
            self.artifactTable[artifactId][charName] = self.artifactTable[artifactId][charName] + 1
        end
    end
end

function Indy:DeleteItemFromChar(artifactId)
    if not artifactId then
        return
    end
    local charName = self.charName

    CheckForUnknownItems({artifactId})

    if self.artifactTable[artifactId] ~= nil then
        local _, setCount = self:FindArtifactSetsContainingId(artifactId)

        if not self.artifactTable[artifactId][charName] then
            return
        end

        if self.artifactTable[artifactId][charName] > 0 then
            self.artifactTable[artifactId][charName] = self.artifactTable[artifactId][charName] - 1
        end

        if self.artifactTable[artifactId][charName] == 0 then
            self.artifactTable[artifactId][charName] = nil
        end
    end
end

function Indy:WhoHasItem(artifactId)
    local charList = {}
    local itemCounts = {}
    local _, setCount = self:FindArtifactSetsContainingId(artifactId)

    if self.artifactTable[artifactId] then
        for name, trackStatus in pairs(self.trackCollectionsForChars) do
            if trackStatus then
                local statusCollected = self.artifactTable[artifactId][name]
                if statusCollected and statusCollected >= setCount then
                    table.insert(charList, name)
                    table.insert(itemCounts, statusCollected)
                end
            end
        end
    end

    return charList, itemCounts, setCount
end

function Indy:WhoNeedsItem(artifactId)
    local charList = {}
    local itemCounts = {}
    local _, setCount = self:FindArtifactSetsContainingId(artifactId) -- *** PERFORMANCE WARNING *** --

    if self.artifactTable[artifactId] then
        for name, trackStatus in pairs(self.trackCollectionsForChars) do
            if trackStatus then
                local statusCollected = self.artifactTable[artifactId][name]
                if statusCollected == nil then statusCollected = 0 end

                if (statusCollected < setCount) or (setCount == 0 and statusCollected == 0) then
                    table.insert(charList, name)
                    table.insert(itemCounts, statusCollected)
                end
            end
        end
    end

    return charList, itemCounts, setCount
end

function Indy:AddCharToTrackList(charName)
    Indy.trackCollectionsForChars[charName] = true
end

function Indy:RemoveCharFromTrackList(charName)
    Indy.trackCollectionsForChars[charName] = false
end

function Indy:CheckBagsForArtifacts()
    local slots = Utility.Item.Slot.All()
    local tableOfItemIds = Inspect.Item.List(slots)
    local tableOfItemDetails = Inspect.Item.Detail(tableOfItemIds)

    --CheckForUnknownItems(itemIds)
    CheckForUnknownItemsInItemDetailsTable(tableOfItemDetails)

    for itemId, itemDetails in pairs(tableOfItemDetails) do
        if itemDetails.category and (itemDetails.category:find("collectible") or itemDetails.category:find("artifact")) then
            local artifactId = itemDetails.type
            local artifactName = itemDetails.name

            -- Print a list of chars who need this item
            local needList = {}
            local charList, itemCounts, setCount = Indy:WhoNeedsItem(artifactId)
            if #charList > 0 then
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

                print("[" .. artifactName .. "] needed by: " .. table.concat(needList, ", "))
            end
        end
    end

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
        itemDetails = self:InspectItemDetail(itemId)

        CheckForUnknownItems({itemId})

        if itemDetails.category and (itemDetails.category:find("collectible") or itemDetails.category:find("artifact")) then
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

    for auctionId, _ in pairs(tableOfAuctionsByChar) do -- *** PERFORMANCE WARNING *** --
        auctionDetails = Inspect.Auction.Detail(auctionId)
        auctionBid = auctionDetails.bid
        auctionBuyout = auctionDetails.buyout
        itemId = auctionDetails.item
        itemDetails = self:InspectItemDetail(itemId) -- *** PERFORMANCE WARNING *** --
        artifactName = itemDetails.name

        local needList = {}
        local charList, itemCounts, setCount = Indy:WhoNeedsItem(itemDetails.type) -- *** PERFORMANCE WARNING *** --
        if #charList > 0 then
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

            print("[" .. artifactName .. "] Bid: " .. tostring(auctionBid) .. " BO: " .. tostring(auctionBuyout) .. " needed by: " .. table.concat(needList, ", "))
        end
    end
end

function Indy:SetTrackStatus(charName, bool)
    if not charName then
        return
    end
    self.trackCollectionsForChars[charName] = bool
end

function Indy:FindArtifactSetsContainingId(id)
    local idLookup = SETS_BY_ID[id]
    if idLookup then
        return idLookup.sets, idLookup.setCount
    end

    return {}, 0
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
    print("/indy showverbosetooltips - toggle display of verbose tooltips (" .. tostring(self.showVerboseTooltips) .. ")")
    print("/indy config - opens the configuration window")
    print("/indy help - prints this message")
end
