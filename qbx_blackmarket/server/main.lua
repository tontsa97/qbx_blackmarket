local QBX = exports['qbx-core']:GetCoreObject()
local itemStock = {}
local playerReputations = {}
local dealerInventories = {}

-- Initialize dealer inventories and stock
local function InitializeInventories()
    for location, dealer in pairs(Config.BlackMarketLocations) do
        dealerInventories[location] = {}
        local dealerType = Config.DealerTypes[dealer.dealer_type]

        for _, itemName in ipairs(dealerType.items) do
            local itemConfig = Config.Items[itemName]
            dealerInventories[location][itemName] = {
                stock = itemConfig.max_stock,
                last_restock = os.time()
            }
        end
    end

    for _, item in pairs(Config.Items) do
        itemStock[item.name] = item.max_stock
    end
end

-- Stock management
local function ManageStock()
    while true do
        Wait(60000) -- Check every minute
        for itemName, stock in pairs(itemStock) do
            local itemConfig = GetItemConfig(itemName)
            if itemConfig and stock < itemConfig.max_stock then
                if math.random() < (1 / (itemConfig.restock_time * 60)) then
                    itemStock[itemName] = stock + 1
                    TriggerClientEvent('blackmarket:client:updateStock', -1, itemName, itemStock[itemName])
                end
            end
        end

        for location, inventory in pairs(dealerInventories) do
            for itemName, itemData in pairs(inventory) do
                local itemConfig = Config.Items[itemName]
                if itemConfig and os.time() - itemData.last_restock >= (itemConfig.restock_time * 60) then
                    local dealer = Config.BlackMarketLocations[location]
                    local restockChance = GetRestockChance(dealer, itemConfig)

                    if math.random() < restockChance then
                        itemData.stock = math.min(itemData.stock + 1, itemConfig.max_stock)
                        itemData.last_restock = os.time()
                        TriggerClientEvent('blackmarket:client:updateStock', -1, location, itemName, itemData.stock)
                    end
                end
            end
        end
    end
end

-- Buy item with advanced features
RegisterNetEvent('blackmarket:server:buyItem', function(data)
    local src = source
    local Player = QBX.Functions.GetPlayer(src)

    if not Player then return end

    local currentDealer = GetPlayerDealer(src)
    if not currentDealer then return end

    local inventory = dealerInventories[currentDealer]
    if not inventory or not inventory[data.item] then return end

    local itemConfig = Config.Items[data.item]

    -- Check required items
    if itemConfig.required_items then
        for _, requiredItem in ipairs(itemConfig.required_items) do
            if not HasRequiredItem(Player, requiredItem) then
                lib.notify(src, {
                    title = 'Missing Requirements',
                    description = 'You need ' .. requiredItem .. ' for this transaction',
                    type = 'error'
                })
                return
            end
        end
    end

    -- Process purchase
    if inventory[data.item].stock > 0 then
        if Player.Functions.RemoveMoney('cash', data.price, "blackmarket-purchase") then
            -- Remove required items
            if itemConfig.required_items then
                for _, requiredItem in ipairs(itemConfig.required_items) do
                    RemoveRequiredItem(Player, requiredItem)
                end
            end

            -- Add item with quality
            local success = exports.ox_inventory:AddItem(src, data.item, 1, data.metadata)

            if success then
                -- Update stock
                inventory[data.item].stock = inventory[data.item].stock - 1

                -- Update reputation and heat
                AddPlayerReputation(src, CalculateReputationGain(data))
                UpdateDealerHeat(currentDealer, data.illegal_level)

                -- Chance for police notification
                HandlePoliceNotification(src, data, currentDealer)

                lib.notify(src, {
                    title = 'Purchase Successful',
                    description = 'Transaction completed',
                    type = 'success'
                })
            else
                -- Return money if item couldn't be added
                Player.Functions.AddMoney('cash', data.price, "blackmarket-purchase-failed")
                lib.notify(src, {
                    title = 'Purchase Failed',
                    description = 'Cannot carry this item',
                    type = 'error'
                })
            end
        end
    else
        lib.notify(src, {
            title = 'Out of Stock',
            description = 'This item is currently unavailable',
            type = 'error'
        })
    end
end)

-- Initialize inventories and start stock management
CreateThread(function()
    InitializeInventories()
    ManageStock()
end)
