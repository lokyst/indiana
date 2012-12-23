function Indy:FindArtifactSetsContainingId(id)
    local sets = {}
    for setName, ids in pairs(INDY_ArtifactCollections) do
        if ids[id] then
            sets[setName] = true
        end
    end
    return sets
end

function Indy:ConvertArtifactTableFrom0To1()
    local oldTable = Indy.artifactTable

    local newTable = {}

    for artifactId, charList in pairs(oldTable) do
        newTable[artifactId] = {
            name = "",
            charList = {},
        }

        -- Determine which sets this item belongs to
        local sets = self:FindArtifactSetsContainingId(artifactId)
        local charSets = {}
        local counter = 0
        local lastSet = ""
        for set, _ in pairs(sets) do
            counter = counter + 1
            lastSet = set
            -- Set the default owned item to the first item in the list
            if counter == 1 then
                charSets[set] = true
            else
                charSets[set] = false
            end
        end

        --[[-- If item only belongs to one set then set the value to true
        if counter == 1 then
            charSets[lastSet] = true
        end

        -- if item belongs to multiple sets then add the item to a tracked
        --- list of unassociated items
        if counter ~= 1 then
            Indy.unassignedArtifacts[artifactId] = true
        end--]]

        Indy.unnamedArtifacts[artifactId] = true

        if counter > 0 then
            for char, _ in pairs(charList) do
                newTable[artifactId].charList[char] = charSets
            end
        end
    end

    return newTable

end
