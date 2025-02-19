local Analytics = {
    transactions = {},
    player_patterns = {},
    market_trends = {}
}

function Analytics:RecordTransaction(data)
    table.insert(self.transactions, {
        timestamp = os.time(),
        player_id = data.player_id,
        dealer_id = data.dealer_id,
        item = data.item,
        price = data.price,
        quality = data.quality
    })
    
    self:UpdatePlayerPattern(data.player_id, data)
    self:UpdateMarketTrends(data)
end

function Analytics:GenerateInsights()
    local insights = {
        popular_items = self:GetPopularItems(),
        peak_hours = self:AnalyzeActivityPatterns(),
        price_trends = self:AnalyzePriceTrends(),
        player_preferences = self:AnalyzePlayerPreferences()
    }
    
    return insights
end