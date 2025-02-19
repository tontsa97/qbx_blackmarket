function InitializeDealerInventories()
    for location, dealer in pairs(Config.BlackMarketLocations) do
        dealerInventories[location] = {}
        local dealerType = Config.DealerTypes[dealer.dealer_type]
        
        for _, itemName in ipairs(dealerType.items) do
            local itemConfig = Config.Items[itemName]
            dealerInventories[location][itemName] = {
                stock = itemConfig.max_stock,
                last_restock = os.time(),
                quality = GenerateItemQuality(itemConfig)
            }
        end
    end
end

function GenerateItemQuality(itemConfig)
    if not itemConfig.quality_variation then return 100 end
    return math.random(70, 100)
end
