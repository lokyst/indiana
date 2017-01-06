--watchdog is disabled during handling of Event.Addon.Startup.End.

local function ArtifactQuery()
    --Command.System.Watchdog.Quiet()
    local startTime = Inspect.Time.Real()
    local counter = 0

    for itemId, _ in pairs(Indy.artifactTable) do
        counter = counter + 1
    end

    Indy.artifactTableCount = counter

    local itemDetails = Inspect.Item.Detail(Indy.artifactTable)
    Indy.QueryItemDetailTime = Inspect.Time.Real() - startTime

    local artifactDetailCache = {}

    startTime = Inspect.Time.Real()

    counter = 0
    for itemId, itemDetail in pairs(itemDetails) do
        counter = counter + 1

        artifactDetailCache[itemId] = itemDetail
    end
    Indy.ItemCacheTime = Inspect.Time.Real() - startTime
    Indy.ItemCacheCount = counter

    Indy.artifactDetailCache = artifactDetailCache
end


--table.insert(Event.Addon.Startup.End, {ArtifactQuery, "Indy", "ArtifactQuery"})

local function ArtifactQuery2()
    print("Starting artifact query")
    local artifactDetailCache = {}
    local failedArtifactIDs = {}

    local counter = 1

    for itemId, _ in pairs(Indy.artifactTable) do
        if itemId ~= "" then
            local startTime = Inspect.Time.Real()
            local success, itemDetail = pcall(Inspect.Item.Detail, itemId)
            print("ProcessTime: " .. (Inspect.Time.Real() - startTime))
            if success then
                artifactDetailCache[itemId] = itemDetail
            else
                failedArtifactIDs[itemId] = true
            end
        end

        if counter % 1 == 0 then
            coroutine.yield(false)
        end

        print("Items processed: "..counter)
        counter = counter + 1
    end

    repeat
        local success, itemDetails = pcall(Inspect.Item.Detail, failedArtifactIDs)
        if success then
            for itemId, itemDetail in pairs(itemDetails) do
                artifactDetailCache[itemId] = itemDetail
            end
        end
        coroutine.yield(false)
    until success

    Indy.artifactTableCount = counter
    Indy.artifactDetailCache = artifactDetailCache

    print("Artifact query done")
    return true
end

myThreadId = coroutine.create(function ()
    return ArtifactQuery2()
end)

local function ReleaseTheKraken()
    if myThreadId == nil then
        return
    end

    print("Resuming artifact query")
    local success, result = coroutine.resume(myThreadId)
    if not success then
        print("Artifact query failed: "..result)
        myThreadId = nil
    elseif result then
        print("Artifact query done 2")
        myThreadId = nil
    end
end

table.insert(Event.System.Update.End, {ReleaseTheKraken, "Indy", "ArtifactQuery"})
