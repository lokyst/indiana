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

    if oldTable.version and oldTable.version >= 1 then
        return oldTable
    end

    local newTable = {
        version = 1,
    }

    for artifactId, charList in pairs(oldTable) do
        if not (artifactId == "version") then
            newTable[artifactId] = {}

            -- Determine which sets this item belongs to
            local sets = self:FindArtifactSetsContainingId(artifactId)
            local charSets = {}
            local counter = 0
            local lastSet = ""
            for set, _ in pairs(sets) do
                counter = counter + 1
                lastSet = set
                charSets[set] = false
            end

            -- If item only belongs to one set then set the value to true
            if counter == 1 then
                charSets[lastSet] = true
            end

            -- if item belongs to multiple sets then add the item to a tracked
            --- list of unassociated items
            if counter ~= 1 then
                Indy.unassignedArtifacts[artifactId] = true
            end

            if counter > 0 then
                for char, _ in pairs(charList) do
                    newTable[artifactId][char] = charSets
                end
            end
        end
    end

    return newTable

end
