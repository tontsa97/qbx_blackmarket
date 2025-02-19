local QBX = exports['qbx-core']:GetCoreObject()
local PlayerData = QBX.Functions.GetPlayerData()
local activeDealers = {}
local currentHeat = 0
local policeRaids = false
local spawnedPeds = {}
local currentReputation = 0
local dealerBlips = {}

-- Function to calculate dynamic price
local function CalculatePrice(item, location)
    local basePrice = item.base_price
    local finalPrice = basePrice
    local currentTime = os.date("%H:%M")

    -- Time-based pricing
    for timeRange, multiplier in pairs(Config.DynamicPricing.time_multipliers) do
        local startTime, endTime = timeRange:match("([^-]+)-([^-]+)")
        if IsTimeBetween(currentTime, startTime, endTime) then
            finalPrice = finalPrice * multiplier
            break
        end
    end

    -- Zone-based pricing
    if location and Config.DynamicPricing.zone_multipliers[location.zone] then
        finalPrice = finalPrice * Config.DynamicPricing.zone_multipliers[location.zone]
    end

    -- Police presence pricing
    if item.police_price_multiplier then
        local policeCount = GetPoliceCount()
        finalPrice = finalPrice * (1 + (policeCount * Config.DynamicPricing.police_multiplier))
    end

    -- Reputation discount
    if item.reputation_discount then
        local discount = GetReputationDiscount(currentReputation)
        finalPrice = finalPrice * (1 - discount)
    end

    return math.floor(finalPrice)
end

-- Suspicious behavior detection
local function CheckSuspiciousBehavior()
    local ped = PlayerPedId()
    local suspicionLevel = 0

    -- Check if player is armed
    if IsPedArmed(ped, 7) then
        suspicionLevel = suspicionLevel + 0.3
    end

    -- Check if player is wearing a mask
    if IsPedWearingHelmet(ped) or IsPedWearingMask(ped) then
        suspicionLevel = suspicionLevel + 0.2
    end

    -- Check if player is running or in combat
    if IsPedRunning(ped) or IsPedInMeleeCombat(ped) then
        suspicionLevel = suspicionLevel + 0.2
    end

    -- Check for nearby police
    if IsPoliceNearby(20.0) then
        suspicionLevel = suspicionLevel + 0.3
    end

    return suspicionLevel
end

-- Heat system
local function UpdateHeat(amount)
    currentHeat = math.max(0, math.min(100, currentHeat + amount))

    -- Heat affects dealer behavior
    if currentHeat > 80 then
        TriggerEvent('blackmarket:client:dealersScattered')
    end
end

-- Reputation system
RegisterNetEvent('blackmarket:client:updateReputation', function(newRep)
    currentReputation = newRep
    local currentLevel = GetReputationLevel(currentReputation)

    lib.notify({
        title = 'Reputation Update',
        description = string.format('You are now a %s', Config.ReputationLevels[currentLevel].name),
        type = 'info'
    })
end)

-- Open the black market menu
function OpenBlackMarket()
    local suspicionLevel = CheckSuspiciousBehavior()
    if suspicionLevel > 0.7 then
        lib.notify({
            title = 'Dealer Warning',
            description = 'You\'re drawing too much attention...',
            type = 'error'
        })
        return
    end

    local currentDealer = GetNearestDealer()
    if not currentDealer then return end

    local dealerType = Config.DealerTypes[currentDealer.dealer_type]
    local options = {}

    for _, itemName in ipairs(dealerType.items) do
        local itemConfig = Config.Items[itemName]
        if itemConfig and CanPlayerAccessItem(itemName) then
            local itemData = exports.ox_inventory:Items()[itemName]
            local stock = GetItemStock(itemName)
            local price = CalculatePrice(itemConfig, currentDealer)
            local quality = itemConfig.quality_variation and GetItemQuality() or 100

            if stock > 0 then
                table.insert(options, {
                    title = itemData.label,
                    description = string.format("Price: $%s | Stock: %d | Quality: %d%%", price, stock, quality),
                    metadata = {
                        ['Price'] = price,
                        ['Stock'] = stock,
                        ['Quality'] = quality,
                        ['Reputation Required'] = GetRequiredReputation(itemConfig)
                    },
                    args = {
                        item = itemName,
                        price = price,
                        metadata = { ...itemConfig.metadata, quality = quality },
                        illegal_level = itemConfig.illegal_level
                    }
                })
            end
        end
    end

    -- Add special reputation-based options
    local repLevel = GetReputationLevel(currentReputation)
    if Config.ReputationLevels[repLevel].special_items then
        table.insert(options, {
            title = "Special Offers",
            description = "Exclusive items for " .. Config.ReputationLevels[repLevel].name,
            metadata = { ['Reputation Level'] = Config.ReputationLevels[repLevel].name },
            args = { special = true }
        })
    end

    lib.registerContext({
        id = 'blackmarket_shop',
        title = string.format('%s - Heat Level: %d%%', Config.ReputationLevels[repLevel].name, currentHeat),
        options = options,
        onSelect = function(args)
            if args.special then
                OpenSpecialOffers(currentDealer)
            else
                AttemptPurchase(args, currentDealer)
            end
        end
    })

    lib.showContext('blackmarket_shop')
end

-- Initialize dealers based on time
CreateThread(function()
    while true do
        local gameHour = GetClockHours()

        for location, dealer in pairs(Config.BlackMarketLocations) do
            local dealerType = Config.DealerTypes[dealer.dealer_type]
            local shouldBeActive = ShouldDealerBeActive(dealerType.schedule, gameHour)

            if shouldBeActive and not activeDealers[location] then
                SpawnDealer(location, dealer)
            elseif not shouldBeActive and activeDealers[location] then
                RemoveDealer(location)
            end
        end

        Wait(60000) -- Check every minute
    end
end)

-- Police raid system
RegisterNetEvent('blackmarket:client:policeRaidStarted', function(raidZone)
    if policeRaids then return end

    policeRaids = true
    local affectedDealers = {}

    for location, dealer in pairs(activeDealers) do
        if dealer.zone == raidZone then
            if dealer.backup_locations and #dealer.backup_locations > 0 then
                local backup = dealer.backup_locations[math.random(#dealer.backup_locations)]
                MoveDealerToBackup(location, backup)
                table.insert(affectedDealers, location)
            else
                RemoveDealer(location)
            end
        end
    end

    if raidZone == GetPlayerZone() then
        UpdateHeat(50)
    end

    SetTimeout(30 * 60000, function()
        policeRaids = false
        for _, location in ipairs(affectedDealers) do
            RestoreDealerPosition(location)
        end
    end)
end)

-- Quality variation system for items
local function GetItemQuality()
    local quality = math.random(50, 100)
    local bonusChance = (currentReputation / 1000) * 100

    if math.random(100) < bonusChance then
        quality = quality + math.random(0, 20)
    end

    return math.min(quality, 100)
end
