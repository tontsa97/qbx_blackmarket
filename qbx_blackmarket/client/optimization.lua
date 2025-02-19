local function OptimizeNearbyChecks()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Cache nearby dealers
    local nearbyDealers = {}
    for id, dealer in pairs(activeDealers) do
        local distance = #(playerCoords - dealer.coords)
        if distance < 100.0 then
            nearbyDealers[id] = dealer
        end
    end
    
    Cache:Set('nearbyDealers', nearbyDealers)
    return nearbyDealers
end