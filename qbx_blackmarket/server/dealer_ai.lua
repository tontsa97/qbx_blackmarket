local DealerAI = {
    behavior_patterns = {},
    learning_rate = 0.1
}

function DealerAI:UpdateBehavior(dealer_id, transaction_result)
    local pattern = self.behavior_patterns[dealer_id]
    if not pattern then
        pattern = self:InitializePattern(dealer_id)
    end
    
    -- Update success rate
    pattern.success_rate = (pattern.success_rate * (1 - self.learning_rate)) +
                          (transaction_result and 1 or 0) * self.learning_rate
                          
    -- Adjust pricing strategy
    if pattern.success_rate < 0.3 then
        pattern.price_multiplier = math.max(0.8, pattern.price_multiplier - 0.05)
    elseif pattern.success_rate > 0.7 then
        pattern.price_multiplier = math.min(1.2, pattern.price_multiplier + 0.05)
    end
    
    self.behavior_patterns[dealer_id] = pattern
end
