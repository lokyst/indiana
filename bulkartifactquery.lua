-- Watchdog is disabled during handling of Event.Addon.Startup.End.
-- Cannot use watchdog quiet method because process still takes too long and may require
-- multiple queries.
-- Also, cannot use watchdog method if we need to query auction house or other post-start-up events.

-- Using cputime as a limit for co-routine execution because we want to limit time used per frame to avoid stuttering.
local function BulkArtifactQuery_Co(tableOfItemIDs, completionFunc)
    --print("Starting artifact name query")
    local failedItemQueries = {}
    local tableOfItemDetails = {}

    local itemCounter = 0
    local succeededItems = 0
    local failedItems = 0
    local cpuStartTime = Inspect.Time.Real()
    local loopCpuStartTime = Inspect.Time.Real()

    for itemId, _ in pairs(tableOfItemIDs) do
        local success
        local failCounter = 0
        local loopCpuTime
        
        repeat
            success, itemDetail = pcall(Inspect.Item.Detail, itemId)

            if success then
                --Indy.newList[itemId].name =  itemDetail.name
                --Indy.unnamedArtifacts[itemId] = nil
                tableOfItemDetails[itemId] = itemDetail
                succeededItems = succeededItems + 1
            else
                failCounter = failCounter + 1
            end

            -- if a particular item fails to query more than 50 times quit trying.
            if failCounter > 50 then
                tableOfItemDetails[itemId] = itemDetail
                failedItemQueries[itemId] = true
                failedItems = failedItems + 1
                success = true
            end

            -- Co routine check happens inside repeat because we might need to query same item multiple times until it succeeds
            loopCpuTime = Inspect.Time.Real() - loopCpuStartTime            
            if loopCpuTime > 0.01 then
                coroutine.yield(false)
                loopCpuStartTime =  Inspect.Time.Real()
            end

        until success

        -- Increment item counter after we have determined success or failure so that itemCounter = successCounter + failCounter
        itemCounter = itemCounter + 1
        
        -- Deubgging
        --if itemCounter % 100 == 0 then 
        --    print("[BulkArtifactQuery] Items Processed: " .. itemCounter .. " Success: " .. succeededItems .. " Failed: " .. failedItems .. " Total CPUTime: " .. Inspect.Time.Real() - cpuStartTime)
        --end
    end

    Indy.artifactTableCount = itemCounter
    Indy.failedItemQueries = failedItemQueries
    Indy.cpuTime = Inspect.Time.Real() - cpuStartTime

    --print("[BulkArtifactQuery] Items Processed: " .. itemCounter .. " Success: " .. succeededItems .. " Failed: " .. failedItems)    
    --print("[BulkArtifactQuery] Query complete after " .. Indy.cpuTime .. " seconds")
    
    completionFunc(tableOfItemDetails)
    
    return true
end

local CoroutinesQueue = {}

function Indy:QueryItemDetails(tableOfItemIDs, completionFunc)
    local myThreadId = coroutine.create(function ()
        return BulkArtifactQuery_Co(tableOfItemIDs, completionFunc)
    end)
    
    table.insert(CoroutinesQueue, myThreadId)
end

-- Release The Kraken!
local function BulkArtifactQuery()
    if #CoroutinesQueue == 0 then
        return
    end
    
    local currentCoroutine = CoroutinesQueue[1]
    
    if currentCoroutine ~= nil then
        --print("Resuming artifact query")
        local success, result = coroutine.resume(currentCoroutine)
        if not success then
            --print("[BulkArtifactQuery] coroutine failed: "..tostring(result))
            table.remove(CoroutinesQueue, 1)
        elseif result then
            --print("[BulkArtifactQuery] coroutine complete.")
            table.remove(CoroutinesQueue, 1)
        end
    end
end

table.insert(Event.System.Update.End, {BulkArtifactQuery, "Indy", "BulkArtifactQuery"})
