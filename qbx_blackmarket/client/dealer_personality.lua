local function InitializeDealerPersonality(dealer)
    local personalities = Config.DealerPersonalities
    local personality = personalities[math.random(#personalities)]
    
    dealer.personality = personality
    dealer.stress_level = 0
    dealer.last_transaction = 0
    dealer.failed_deals = 0
    
    return dealer
end

local function UpdateDealerMood(dealer)
    local stress_increase = 0
    
    -- Check various factors
    if GetPoliceCount() > 2 then
        stress_increase = stress_increase + 10
    end
    
    if dealer.failed_deals > 3 then
        stress_increase = stress_increase + 20
    end
    
    if GetGameTimer() - dealer.last_transaction < 300000 then -- 5 minutes
        stress_increase = stress_increase + 5
    end
    
    dealer.stress_level = math.min(100, dealer.stress_level + stress_increase)
    
    -- Dealer might temporarily close if too stressed
    if dealer.stress_level >= 90 then
        TriggerDealerBreak(dealer)
    end
end