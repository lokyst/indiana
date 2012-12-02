Indy = {}

-- Some useful generic functions
local tableOfArtifactAchievements = {
		c08FB7D2A79AA293E = {
			["Already-used Treasure Map"] = true,
			["Aqua Flora"] = true,
			["Discarded Armor Pieces"] = true,
			["Discarded Bottles, Vials, and Flasks"] = true,
			["Discarded Weapons"] = true,
			["Dormant Runeshards"] = true,
			Driftwood = true,
			["Empty Treasure Chests"] = true,
			["Exotic Aqua Flora"] = true,
			["Fish Scales"] = true,
			["Keys to Nothing"] = true,
			["Moldy Tomes"] = true,
			["Mysterious Crystals"] = true,
			["Rings That Were Once Lost"] = true,
			["Shiny Pebbles"] = true
		},
		c0BB107D26CD43321 = {
			["An Analysis of Goblin Titles and Aliases"] = true,
			["Ascended Guardians"] = true,
			["Brougan Grote"] = true,
			["Codex Elementalism"] = true,
			["Divine Landing"] = true,
			["Food of Silverwood"] = true,
			["Hazing Committee Supplies"] = true,
			["High Elven Culture"] = true,
			["History of the High Elves"] = true,
			["Hylas and Shyla"] = true,
			["Jerome Drift"] = true,
			Overwatch = true,
			["Prince Hylas Aelfwar"] = true,
			["Quicksilver College"] = true,
			Silverwood = true,
			Tavril = true,
			["The Arboreal War"] = true,
			["The Great Betrayal"] = true,
			["The Holy City"] = true,
			["The Theology of the Vigil"] = true
		},
		c10F77141903E55AC = {
			["Cyclops Gladiator Gear"] = true,
			["Emberlord Ereetu"] = true,
			["Fossils of the Droughtlands"] = true,
			["Frontier Foods"] = true,
			["Gambler's Marks"] = true,
			["Helena Brass's Leaflets"] = true,
			["Kobold Creation Story"] = true,
			["Lantern Hook"] = true,
			["Mister Opal's Guide to Humans"] = true,
			["Rorf Collection; Awesome Reward"] = true,
			["The Bogling and the Kobold"] = true,
			["The Convocation"] = true,
			["The Eldritched Civilization of the Eth"] = true,
			["To Be a God"] = true,
			["Wanton Tribe Trophies"] = true,
			["Well Thought Out Plans of Victory"] = true
		},
		c11EBFDB32253AA12 = {
			["Bahmi Tribe Symbols"] = true,
			["Companion Sashes"] = true,
			["Dargal the Pyromancer"] = true,
			["Fortune's Shore"] = true,
			["Gambler's Equipment"] = true,
			["Khaliti Jewel Work"] = true,
			["Lost Treasure Maps"] = true,
			["Scales of Laethys"] = true,
			["Stormlord Casimir"] = true,
			["Sylver's Schematics"] = true,
			["Tam Daggerborn"] = true,
			["The Big Book of Eth Conspiracy"] = true,
			["The City-State of Redoubt"] = true,
			["The Sorcerer-Kings"] = true,
			["Thontic, God of Mystery"] = true,
			["Vaiyuu Wool"] = true
		},
		c1496CE24B30E62D5 = {
			["Droughtlands Fishing Trophies"] = true,
			["Ember Isle Fishing Trophies"] = true,
			["Freemarch Fishing Trophies"] = true,
			["Gloamwood Fishing Trophies"] = true,
			["Iron Pine Peak Fishing Trophies"] = true,
			["Moonshade Highlands Fishing Trophies"] = true,
			["Scarlet Gorge Fishing Trophies"] = true,
			["Scarwood Reach Fishing Trophies"] = true,
			["Shimmersand Fishing Trophies"] = true,
			["Silverwood Fishing Trophies"] = true,
			["Stillmoor Fishing Trophies"] = true,
			["Stonefield Fishing Trophies"] = true
		},
		c20E245864E8CB7D7 = {
			["Crops of Freemarch"] = true,
			["Fish of Solace"] = true,
			["Freemarch Warden Gear"] = true,
			["Keys of the Iron Fortress"] = true,
			["Liberation of the March"] = true,
			["Remains of the Mire"] = true,
			["Scrolls of Eliam"] = true,
			["Telaran Coins"] = true
		},
		c22B15A695E27E319 = {
			["Curses of Gloamwood"] = true,
			["Darkening Deeps"] = true,
			["Delilath the Hag"] = true,
			["Family Crests of Gloamwood"] = true,
			Gloamwood = true,
			["Gloamwood Horrors"] = true,
			["Love in the Age of the Shade"] = true,
			Oakheart = true,
			["Oswald's Notes"] = true,
			["Shadefallen Keep"] = true,
			["Tales of the Forest"] = true,
			["The Gedlo Conclave"] = true,
			["The Sanctuary Guard"] = true,
			["The Solemn Family"] = true,
			["Tintan's Snake Oil"] = true,
			["Tools of the Forest"] = true
		},
		c280046F1395370DF = {
			["Aelfwar Tokens"] = true,
			["Cat Gut Accessories"] = true,
			["Commander Kain"] = true,
			["Doctor Visek"] = true,
			["Ironwood Boughs"] = true,
			["Kain's Command"] = true,
			["Keenblade Manual"] = true,
			["Life Bomb Fragments"] = true,
			["Lord's Hall"] = true,
			["Lumber Saws"] = true,
			["On the Heavens"] = true,
			["Our Aelfwar Benefactors"] = true,
			["Relics of Carwin Mathos"] = true,
			["Remains of Granitewood Crossing"] = true,
			["Shatterbone Possessions"] = true,
			["Weapons of War"] = true
		},
		c2A729BB0823333B8 = {
			["Abyssal Summoning Implements"] = true,
			["Brother Jebiah"] = true,
			["Buccaneer Articles"] = true,
			["Fae Dust"] = true,
			["Fezziled's 100 Ways to Cook a Fae"] = true,
			Gorvaht = true,
			Hammerknell = true,
			["Intact Runebound Vessels"] = true,
			["Last Days of Hammerknell"] = true,
			["Moonshade Crofter Deeds"] = true,
			["Moonshade Highlands"] = true,
			["Proper Parenting Techniques By Eustace Green"] = true,
			["Rune King Molinar"] = true,
			["Runebound Accessories"] = true,
			["Story of Brother Damon"] = true,
			["The Dwarves of Moonshade"] = true,
			["Three Springs"] = true,
			["Tidelord Brenin"] = true
		},
		c30D8D0D5876EE950 = {
			["A Bahmi in the North"] = true,
			["Charms of Iron Pine"] = true,
			["Commander Calthyx"] = true,
			["Ice Statues"] = true,
			["Iron Pine Peak"] = true,
			["Orders of Rahn Chuluun"] = true,
			["Relics of Crucia's Last Battle"] = true,
			["Scriptkeeper Chekharoth's Scrolls"] = true,
			["Storm Legion Decorations"] = true,
			["Tabitha Leighton"] = true,
			["The Art of Combat"] = true,
			["The First Oaths of the Icewatch"] = true,
			["The Icewatch"] = true,
			["The Labors of Thedeor"] = true,
			["Thedeor's Sword"] = true,
			Whitefall = true,
			["Whitefall Recruitment Letters"] = true
		},
		c329C9B02946B2D29 = {
			["Emberlord Ereetu"] = true,
			["Kobold Creation Story"] = true,
			["Mister Opal's Guide to Humans"] = true,
			["Rorf Collection; Awesome Reward"] = true,
			["The Bogling and the Kobold"] = true,
			["Wanton Tribe Trophies"] = true,
			["Well Thought Out Plans of Victory"] = true
		},
		c490636CB6B61DCE0 = {
			["Aelfwar Tokens"] = true,
			["Life Bomb Fragments"] = true,
			["On the Heavens"] = true,
			["Our Aelfwar Benefactors"] = true,
			["Remains of Granitewood Crossing"] = true
		},
		c4C06352A998B34FD = {
			["Bahmi Tribe Symbols"] = true,
			["Companion Sashes"] = true,
			["Fortune's Shore"] = true,
			["Gambler's Equipment"] = true,
			["Khaliti Jewel Work"] = true,
			["The City-State of Redoubt"] = true,
			["Vaiyuu Wool"] = true
		},
		c539E1EAB7D3381FF = {
			["Abyssal Ritual Jars"] = true,
			["Cast Off Prototypes"] = true,
			["Crops of Freemarch"] = true,
			["Deep Master Tomes"] = true,
			["Fish of Solace"] = true,
			["Freemarch Warden Gear"] = true,
			["Journal of March Warden Denegar"] = true,
			["Kelari Idols"] = true,
			["Keys of the Iron Fortress"] = true,
			["Kira's Tools of the Trade"] = true,
			["Liberation of the March"] = true,
			["Orphiel's Planar Charts"] = true,
			["Relics of Freemarch"] = true,
			["Remains of the Mire"] = true,
			["Scrolls of Eliam"] = true,
			["Technician Tools"] = true,
			["Telaran Coins"] = true,
			["The Crossing"] = true,
			["The Day the Rifts Came"] = true,
			["The Port of Scion"] = true
		},
		c54E9B2BCB7E1986F = {
			["Maelforge's Imprisonment"] = true,
			["The Fallen Son"] = true,
			["The Farclan Pilgrimage"] = true,
			["The Keepers of the Flame"] = true,
			["War of the Fractured Plain"] = true
		},
		c562877A7AE21F8B5 = {
			Hammerknell = true,
			["Intact Runebound Vessels"] = true,
			["Last Days of Hammerknell"] = true,
			["Rune King Molinar"] = true,
			["Runebound Accessories"] = true,
			["The Dwarves of Moonshade"] = true
		},
		c5B0D3CF64DEA168B = {
			["Angdralthus the Lich"] = true,
			["Construct Apparatuses"] = true,
			["Demonic Binding Reagents"] = true,
			["Dime Novels"] = true,
			["Fire Idols"] = true,
			["Quarry Rat Instruments"] = true,
			["Scarlet Gorge"] = true,
			["The Court of Suffering"] = true,
			["The Golden Fable"] = true,
			["The Gorge"] = true,
			["The Grimoire of Chaos"] = true
		},
		c5B37AD517BEEF0B4 = {
			["High Elven Culture"] = true,
			["History of the High Elves"] = true,
			["Hylas and Shyla"] = true,
			Overwatch = true,
			["Prince Hylas Aelfwar"] = true,
			Tavril = true,
			["The Arboreal War"] = true,
			["The Great Betrayal"] = true
		},
		c5D59E7C1980176B2 = {
			["Demonic Binding Reagents"] = true,
			["Fire Idols"] = true,
			["The Court of Suffering"] = true
		},
		c5E26FB3A9927DADF = {
			["Relics of Crucia's Last Battle"] = true,
			["Scriptkeeper Chekharoth's Scrolls"] = true,
			["Storm Legion Decorations"] = true,
			["The First Oaths of the Icewatch"] = true,
			["Whitefall Recruitment Letters"] = true
		},
		c688F3C1FD088A1A8 = {
			["Curses of Gloamwood"] = true,
			["Delilath the Hag"] = true,
			["Family Crests of Gloamwood"] = true,
			["Love in the Age of the Shade"] = true,
			["Oswald's Notes"] = true,
			["Shadefallen Keep"] = true
		},
		c783753ABC4223791 = {
			["Caer Mathos Royal Relics"] = true,
			["Mathosian Delicacies"] = true,
			["Mathosian Families"] = true,
			["Mathosian Pottery"] = true,
			["Protective Talismans"] = true,
			["Richter, Lord of Belmont"] = true
		},
		c7929CAEEC87A39FE = {
			["Aedraxis Mathos, Tyrant"] = true,
			["Aelfwar Regrets"] = true,
			["Books of Black Magic"] = true,
			["Caer Mathos Royal Relics"] = true,
			["Endless Beginnings"] = true,
			["Endless Necromancer Skulls"] = true,
			["Forgotten Items of the Ascended"] = true,
			["Mathosian Delicacies"] = true,
			["Mathosian Families"] = true,
			["Mathosian Pottery"] = true,
			["Protective Talismans"] = true,
			["Relics of Greenscale's Tamers"] = true,
			["Richter, Lord of Belmont"] = true,
			Stillmoor = true,
			["The Kingdom of Mathosia"] = true,
			["The Rise and Fall of Mathosia"] = true,
			["The Second Fall of the Eth"] = true
		},
		c7E1C4E84600ED937 = {
			Abandoned = true,
			Anthousa = true,
			["Bahralt's Favor"] = true,
			["Borrin's Travel Supplies"] = true,
			["Elven Affects"] = true,
			["Farclan Relics"] = true,
			["For Maelforge"] = true,
			["Fort Zarnost"] = true,
			["Goblins of Ember Isle"] = true,
			["Karris's Correspondences"] = true,
			["Maelforge's Imprisonment"] = true,
			["Mount Carcera"] = true,
			["Native Monsters of Ember Isle"] = true,
			["Spirit Tokens"] = true,
			["Sylver's Ember Isle Research"] = true,
			["Symbols of Atia"] = true,
			["The Fallen Son"] = true,
			["The Farclan Pilgrimage"] = true,
			["The Keepers of the Flame"] = true,
			["The Pyrkari"] = true,
			["War of the Fractured Plain"] = true,
			["Weapons of Ember Isle"] = true
		},
		cFAFA45B6702B5600 = {
			["Burial Rites of the Caretakers"] = true,
			["Caretaker Officer Badges"] = true,
			["Caretaker Saboteur's Gear"] = true,
			["Caretaker Wardobe"] = true,
			["Storm Legion Contraband"] = true,
			["Storm Legion Technology Schematics"] = true,
			["Storm Legion Weapons"] = true
		},
		cFBA6E10F1BFFAD4E = {
			["Arlan Merkur's Battle Entries"] = true,
			["Arlan Merkur's Personal Effects"] = true,
			["Burial Rites of the Caretakers"] = true,
			["Caretaker Officer Badges"] = true,
			["Caretaker Saboteur's Gear"] = true,
			["Caretaker Wardobe"] = true,
			["Commander Dysolt's Personal Effects "] = true,
			["Doctorandus Willhelm Zoetl's Medical Journal"] = true,
			["General Blythe's Battle Plans"] = true,
			Morban = true,
			["Regions of Dusken"] = true,
			["Shaper Tools of the Trade"] = true,
			["Shaper's Twisted Artwork"] = true,
			["Shapers Artistic Fervor"] = true,
			["Storm Grafted Wreckage"] = true,
			["Storm Legion Contraband"] = true,
			["Storm Legion Technology Schematics"] = true,
			["Storm Legion Weapons"] = true,
			["Storm Legion's Occult"] = true,
			["The Elder Shapers of Dusken"] = true,
			["The Goddess of Fate"] = true
		},
		cFD1409459E5E68B9 = {
			["Ancient Brevanic Technology"] = true,
			["Brevanic Relics"] = true,
			["Dusken Delightful Recipes"] = true,
			["Dusken Townsfolk Mementos"] = true,
			["Krahzael Discarded Predictions"] = true,
			["Krahzael's Fated Charms"] = true,
			["Krahzael's Influence"] = true
		},
		cFDB0C99E79BFC95F = {
			["Aedraxis's Immortal Death"] = true,
			["Ancient Brevanic Technology"] = true,
			["Beast Victims’ Remains"] = true,
			["Brevanic Relics"] = true,
			["Caretaker Survival Kit"] = true,
			["Caretaker Trappings"] = true,
			["Crucia's Psychic Presence"] = true,
			["Dusken Delightful Recipes"] = true,
			["Dusken Townsfolk Mementos"] = true,
			["Ezael's Nicknacks"] = true,
			["Flora of Dusken"] = true,
			["Fungus of Dusken"] = true,
			["Kain's Mementos"] = true,
			["Krahzael Discarded Predictions"] = true,
			["Krahzael's Fated Charms"] = true,
			["Krahzael's Influence"] = true,
			["Nutrients of the Overseer"] = true,
			Seratos = true,
			["The Wild Hunt"] = true,
			["Thoughts of the Overseer"] = true,
			["Torath the Wretched"] = true
		},
		cFE15195276543CC1 = {
			["Air Elemental Mementos"] = true,
			["Brevane Biographies"] = true,
			["Brevane Heraldry"] = true,
			["Brevane Histories"] = true,
			["Captain Frigain’s Diary"] = true,
			["Infinity Gate Architectural Plans"] = true,
			["Infinity Gate Opposition Flyers"] = true,
			["Infinity Gate Pieces"] = true,
			["Legends of Crucia"] = true,
			["Nixtoc's Cocktail Recipes "] = true,
			["Nixtoc’s Least Favorites List"] = true,
			["Recipes of Ancient Brevane"] = true,
			["Selected Poems of Arlan Merkur"] = true,
			["Steppes of Infinity"] = true,
			["Storm Legion Mementos"] = true,
			["Storm Legion Weaponry"] = true
		},
		cFF605EAF978332FA = {
			["Brevane Biographies"] = true,
			["Brevane Heraldry"] = true,
			["Brevane Histories"] = true,
			["Infinity Gate Architectural Plans"] = true,
			["Infinity Gate Opposition Flyers"] = true,
			["Infinity Gate Pieces"] = true
		}
	}

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
    scanAH = false,
    tableOfArtifactAchievements = {}
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

local function CheckForUnknownItems(tableOfItemIds)
    local itemDetails
    local artifactId
    local artifactName = ""

    tableOfItemDetails = Inspect.Item.Detail(tableOfItemIds)

    for _, itemDetails in pairs(tableOfItemDetails) do
        -- Check if it is a collectible item
        if itemDetails and itemDetails.category and itemDetails.category:find("misc") and itemDetails.category:find("collectible") then
            artifactId = itemDetails.type
            artifactName = itemDetails.name

            -- Check if there is a record of it in our artifact list
            if not Indy.artifactTable[artifactId] then
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

    ttType, ttShown = Inspect.Tooltip()

    if ttType and ttShown and (ttType == "itemtype" or ttType == "item") then
        itemDetails = Inspect.Item.Detail(ttShown)
        artifactId = itemDetails.type
    end

    return artifactId

end

local function OnBagEvent(tableOfSlots)
    -- TODO -- Make this option toggleable

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
        Indy:AddItemToChar(artifactId)

    elseif cmd == "deleteitem" then
        local artifactId = InspectTooltip()
        Indy:DeleteItemFromChar(artifactId)

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

    elseif cmd == "scanbags" then
        Indy:ScanBagsForArtifacts()

    elseif cmd == "scanah" then
        Indy:ToggleScanAH()

    --elseif cmd == "processah" then
    --    Indy:ProcessAHData(Indy.AHData)

    elseif cmd == "scanachievements" then
        Indy:ScanAchievements(Indy.nextAchievementKey)

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
table.insert(Event.Item.Slot, {OnBagEvent, "Indy", "OnBagEvent"})
table.insert(Event.Item.Update, {OnBagEvent, "Indy", "OnBagEvent"})
table.insert(Event.Auction.Scan, {OnAuctionScan, "Indy", "OnAuctionScan"})

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
    local charName = self.charName
    local itemDetails = Inspect.Item.Detail(artifactId)
    local artifactName = itemDetails.name

    if self.artifactTable[artifactId] ~= nil then
        self.artifactTable[artifactId][charName] = true
        print(charName .. " has collected [" .. artifactName .. "]")
    end
end

function Indy:DeleteItemFromChar(artifactId)
    local charName = self.charName
    local itemDetails = Inspect.Item.Detail(artifactId)
    local artifactName = itemDetails.name

    if self.artifactTable[artifactId] ~= nil then
        self.artifactTable[artifactId][charName] = nil
        print(charName .. " has deleted [" .. artifactName .. "]")
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
        auctionId = auctionDetails.id
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
    local auctionCost

    for auctionId, charList in pairs(tableOfAuctionsByChar) do
        auctionDetails = Inspect.Auction.Detail(auctionId)
        auctionBid = auctionDetails.bid
        auctionBuyout = auctionDetails.buyout
        itemId = auctionDetails.item
        itemDetails = Inspect.Item.Detail(itemId)
        artifactName = itemDetails.name

        print("[" .. artifactName .. "] Bid: " .. tostring(auctionBid) .. " BO: " .. tostring(auctionBuyout) .. " needed by: " .. table.concat(charList, ", "))

    end
end

function Indy:ScanAchievements(nextAchievementKey)
    if not nextAchievementKey then
        self.achievements  = tableOfArtifactAchievements
    end

    print(nextAchievementKey)
    self.nextAchievementKey = self:ProcessAchievements(nextAchievementKey)
end

function Indy:ProcessAchievements(nextAchievementKey)
    local counter = 1
    local requirements = {}
    local lastId

    for achievementId, _ in next, self.achievements, nextAchievementKey do
        if counter == 150 then
            break
        end
        counter = counter + 1

        local achievementDetails = Inspect.Achievement.Detail(achievementId)

        if achievementDetails.description:find("artifact") then
            print(achievementId .. " = ".. achievementDetails.name)

            requirements = achievementDetails.requirement
            for requirement, requirementDetails in pairs(requirements) do
                if requirementDetails.type == "artifactset" then
                    print("    " .. requirementDetails.name .. " = " .. tostring(requirementDetails.id) .. " Status: " .. tostring(requirementDetails.complete))
                end
            end

        end
        lastId = achievementId
    end

    return lastId

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
    print("/indy scanah - toggle scanning AH for artifacts")
    print("/indy help - prints this message")
end
