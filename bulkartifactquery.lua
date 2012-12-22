--watchdog is disabled during handling of Event.Addon.Startup.End.

local function ArtifactQuery()
    --Command.System.Watchdog.Quiet()
    local startTime = Inspect.Time.Real()
    local itemDetails = Inspect.Item.Detail(Indy.artifactTable)
    Indy.QueryItemDetailTime = Inspect.Time.Real() - startTime

    local artifactDetailCache = {}

    startTime = Inspect.Time.Real()
    local counter = 0
    for itemId, itemDetail in pairs(itemDetails) do
        counter = counter + 1

        artifactDetailCache[itemId] = itemDetail
    end
    Indy.ItemCacheTime = Inspect.Time.Real() - startTime
    Indy.ItemCacheCount = counter

    Indy.artifactDetailCache = artifactDetailCache
end


table.insert(Event.Addon.Startup.End, {ArtifactQuery, "Indy", "ArtifactQuery"})
