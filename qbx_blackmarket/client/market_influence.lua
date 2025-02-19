local MarketInfluence = {
    dealers = {},
    global_factors = {}
}

function MarketInfluence:UpdateDealer(dealer_id)
    local dealer = self.dealers[dealer_id]
    if not dealer then return end
    
    local influence = dealer.influence or 0
    local personality = dealer.personality
    
    -- Calculate price modifications
    local price_mod = self:CalculatePriceModifier(influence, personality)
    local quality_mod = self:CalculateQualityModifier(influence, personality)
    local stock_mod = self:CalculateStockModifier(influence, personality)
    
    -- Apply to dealer
    dealer.current_modifiers = {
        price = price_mod,
        quality = quality_mod,
        stock = stock_mod
    }
    
    -- Decay influence over time
    dealer.influence = math.max(0, influence - Config.MarketInfluence.decay_rate)
end