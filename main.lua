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
local profile = {
    trackCollectionsForChars = {},
    artifactTable = {},
}

local function Initialize(addonName)
    -- Do not put anything that can crash after this point
    if addonName ~= "Indy" then
        return
    end

    -- Set default values
    if not Indy_SavedVariables then
        -- Has to be global for toc
        Indy_SavedVariables = {}
    end

    for key, value in pairs(profile) do
        if not Indy_SavedVariables[key] then
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

    print("Indiana's Artifact Tracker loaded. Type /indy or /indy help for options.")
end

local function OnTooltipChange(ttType, ttShown, ttBuff)

    local itemDetails = {}
    local artifactId

    if ttType and ttShown and (ttType == "itemtype" or ttType == "item") then
        itemDetails = Inspect.Item.Detail(ttShown)

        -- Check if it is a collectible item
        if itemDetails and itemDetails.category and itemDetails.category:find("collectible") then
            artifactId = itemDetails.type

            -- Check if there is a record of it in our artifact list
            if not Indy.artifactTable[artifactId] then
                Indy.artifactTable[artifactId] = {}
                --print("New artifact recorded: " .. itemDetails.name)
            end
        end
    end

end

local function InspectTooltip()

    local itemDetails = {}
    local artifactId

    ttType, ttShown = Inspect.Tooltip()

    if ttType and ttShown and (ttType == "itemtype" or ttType == "item") then
        itemDetails = Inspect.Item.Detail(ttShown)

        -- Check if it is a collectible item
        if itemDetails.category and itemDetails.category:find("collectible") then
            artifactId = itemDetails.type

            -- Check if there is a record of it in our artifact list
            if not Indy.artifactTable[artifactId] then
                Indy.artifactTable[artifactId] = {}
                --print("New artifact recorded: " .. itemDetails.name)
            end
        end
    end

    return artifactId

end

local function CheckNewItem(tableOfSlots)
    local tableOfItemDetails = Inspect.Item.Detail(tableOfSlots)
    local artifactId
    local artifactName = ""
    local charList = {}

    for slot, itemDetails in pairs(tableOfItemDetails) do
        if itemDetails.category and itemDetails.category:find("collectible") then
            artifactId = itemDetails.type
            artifactName = itemDetails.name

            -- Check if there is a record of it in our artifact list
            if not Indy.artifactTable[artifactId] then
                Indy.artifactTable[artifactId] = {}
                --print("New artifact recorded: " .. artifactName)
            end

            -- Print a list of chars who need this item
            charList = Indy:WhoNeedsItem(artifactId)
            if #charList > 0 then
                print(artifactName .. " needed by: " .. table.concat(charList, ","))
            end
        end
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
        Indy:AddItemToChar(artifactId)

    elseif cmd == "deleteitem" then
        local artifactId = InspectTooltip()
        Indy:DeleteItemFromChar(artifactId)

    elseif cmd == "whohasitem" then
        local artifactId = InspectTooltip()
        local charList = Indy:WhoHasItem(artifactId)

        print(tostring(table.concat(charList, ",")))

    elseif cmd == "whoneedsitem" then
        local artifactId = InspectTooltip()
        local charList = Indy:WhoNeedsItem(artifactId)

        print(tostring(table.concat(charList, ",")))

    elseif cmd == "dotrack" then
        Indy:AddCharToTrackList(Indy.charName)

    elseif cmd == "donottrack" then
        Indy:RemoveCharFromTrackList(Indy.charName)

    elseif cmd == "scanbags" then
        Indy:ScanBagsForArtifacts()

    elseif cmd == "help" then
        Indy:PrintHelp()

    else
        Indy:PrintHelp()

    end

end

table.insert(Event.Addon.Load.End, {Initialize, "Indy", "Initialize"})
table.insert(Event.Tooltip, {OnTooltipChange, "Indy", "OnTooltipChange"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {function() Indy:SaveVars() end, "Indy", "Save variables"})
table.insert(Command.Slash.Register("indy"), {SlashHandler, "Indy", "Slash Handler"})
table.insert(Event.Item.Slot, {CheckNewItem, "Indy", "ItemCheck"})
table.insert(Event.Item.Update, {CheckNewItem, "Indy", "ItemCheck"})

------------------------ Indy functions begin here -----------------------------

function Indy:SaveVars()
    for key, _ in pairs(profile) do
        -- Avoid overwriting with nil in the event that the addon crashes
        --if not (Indy[key] == nil) then
            Indy_SavedVariables[key] = Indy[key]
        --end
    end
end

function Indy:ResetList()
    Indy.artifactTable = {}
end

function Indy:AddItemToChar(artifactId)
    local playerDetails = Inspect.Unit.Detail("player")
    local charName = playerDetails.name
    local itemDetails = Inspect.Item.Detail(artifactId)
    local artifactName = itemDetails.name

    if self.artifactTable[artifactId] ~= nil then
        self.artifactTable[artifactId][charName] = true
        print(charName .. " has collected " .. artifactName)
    end
end

function Indy:DeleteItemFromChar(artifactId)
    local playerDetails = Inspect.Unit.Detail("player")
    local charName = playerDetails.name
    local itemDetails = Inspect.Item.Detail(artifactId)
    local artifactName = itemDetails.name

    if self.artifactTable[artifactId] ~= nil then
        self.artifactTable[artifactId][charName] = nil
        print(charName .. " has deleted " .. artifactName)
    end
end

function Indy:WhoHasItem(artifactId)
    local charList = {}

    if self.artifactTable[artifactId] then
        for name, trackStatus in pairs(self.trackCollectionsForChars) do
            if trackStatus then
                statusCollected = self.artifactTable[artifactId][name]
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
                statusCollected = self.artifactTable[artifactId][name]
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

function Indy:ScanBagsForArtifacts()
    local slots = Utility.Item.Slot.All()
    local itemIds = Inspect.Item.List(slots)
    local tableOfItemDetails = Inspect.Item.Detail(itemIds)
    local artifactId
    local artifactName = ""
    local charList = {}

    for itemId, itemDetails in pairs(tableOfItemDetails) do
        if itemDetails.category and itemDetails.category:find("collectible") then
            artifactId = itemDetails.type
            artifactName = itemDetails.name

            -- Check if there is a record of it in our artifact list
            if not self.artifactTable[artifactId] then
                self.artifactTable[artifactId] = {}
                --print("New artifact recorded: " .. artifactName)
            end

            -- Print a list of chars who need this item
            charList = self:WhoNeedsItem(artifactId)
            if #charList > 0 then
                print(artifactName .. " needed by: " .. table.concat(charList, ","))
            end
        end
    end

end

function Indy:PrintHelp()
    print("Indiana's Artifact Tracker")
    print("/indy reset - DANGER!!! Clears the list of known artifacts. DANGER!!!")
    print("/indy additem - adds the mouse-overed item to the list of collected artifacts for this character")
    print("/indy deleteitem - removes the mouse-overed item from the list of collected artifacts for this character")
    print("/indy whohasitem - returns a list of the characters who have the mouse-overed item")
    print("/indy whoneedsitem - returns a list of the characters who need the mouse-overed item")
    print("/indy dotrack - adds the current character to the list of characters tracking collections")
    print("/indy donottrack - removes the current character from the list of characters tracking collections")
    print("/indy scanbags - scan bags for artifacts")
    print("/indy help - prints this message")
end
