--watchdog is disabled during handling of Event.Addon.Startup.End.
--[[
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
--]]
--[[local function ArtifactQuery2()
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

table.insert(Event.System.Update.End, {ReleaseTheKraken, "Indy", "ArtifactQuery"})--]]

local function ArtifactNameQuery()
    print("Starting artifact name query")
    local failedItemQueries = {}

    local itemCounter = 0
    local succeededItems = 0
    local failedItems = 0
    local cpuStartTime = Inspect.Time.Real()
    local loopCpuStartTime = Inspect.Time.Real()

    for itemId, _ in pairs(Indy.artifactTable) do
        local success
        local failCounter = 0
        local loopCpuTime
        
        repeat
            success, itemDetail = pcall(Inspect.Item.Detail, itemId)

            if success then
                --Indy.newList[itemId].name =  itemDetail.name
                --Indy.unnamedArtifacts[itemId] = nil

                succeededItems = succeededItems + 1
            else

                failCounter = failCounter + 1
            end

            -- if a particular item fails to query more than 50 times quit trying.
            if failCounter > 50 then
                failedItemQueries[itemId] = true
                failedItems = failedItems + 1
                success = true
            end

            -- Increment item counter after we have determined success or failure so that itemCounter = successCounter + failCounter
            itemCounter = itemCounter + 1

            -- Co routine check happens inside repeat because we might need to query same item multiple times until it succeeds
            loopCpuTime = Inspect.Time.Real() - loopCpuStartTime            
            if loopCpuTime > 0.01 then
                coroutine.yield(false)
                loopCpuStartTime =  Inspect.Time.Real()
            end

        until success
        
        if itemCounter % 100 == 0 then 
            print("[BulkArtifactQuery] Items Processed: " .. itemCounter .. " Success: " .. succeededItems .. " Failed: " .. failedItems .. " Total CPUTime: " .. Inspect.Time.Real() - cpuStartTime)
        end
    end

    Indy.artifactTableCount = itemCounter
    Indy.artifactCycleCount = cycleCounter
    Indy.failedItemQueries = failedItemQueries
    Indy.cpuTime = Inspect.Time.Real() - cpuStartTime

    print("[BulkArtifactQuery] Items Processed: " .. itemCounter .. " Success: " .. succeededItems .. " Failed: " .. failedItems)    
    print("[BulkArtifactQuery] Query complete after " .. Indy.cpuTime .. " seconds")
    return true
end

myThreadId = coroutine.create(function ()
    return ArtifactNameQuery()
end)

local function ReleaseTheKraken()
    if myThreadId == nil then
        return
    end

    --print("Resuming artifact query")
    local success, result = coroutine.resume(myThreadId)
    if not success then
        print("Artifact query failed: "..result)
        myThreadId = nil
    elseif result then
        print("Artifact name query complete. Exiting co-routine.")
        myThreadId = nil
    end
end

table.insert(Event.System.Update.End, {ReleaseTheKraken, "Indy", "ArtifactNameQuery"})