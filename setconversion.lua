function Indy:FindArtifactSetsContainingId(id)
    local sets = {}
    local setCount = 0
    for setName, ids in pairs(INDY_ArtifactCollections) do
        if ids[id] then
            sets[setName] = true
            setCount = setCount + 1
        end
    end
    return sets, setCount
end

function Indy:ConvertArtifactTableFrom0To1()
    local oldTable = Indy.artifactTable

    if self.artifactTableVersion >= 1 then return oldTable end

    local newTable = {}

    for artifactId, charList in pairs(oldTable) do
        local newCharList = {}

        for char, _ in pairs(charList) do
            newCharList[char] = 1
        end

        newTable[artifactId] = newCharList

    end

    Indy.artifactTableVersion = 1
    return newTable

end
