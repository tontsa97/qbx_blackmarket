local BulkUpdates = {
    cache = {},
    threshold = 10
}

function BulkUpdates:Add(type, data)
    if not self.cache[type] then
        self.cache[type] = {}
    end
    table.insert(self.cache[type], data)
    
    if #self.cache[type] >= self.threshold then
        self:Flush(type)
    end
end

function BulkUpdates:Flush(type)
    if not self.cache[type] or #self.cache[type] == 0 then return end
    
    if type == 'inventory' then
        MySQL.transaction.await(self:GenerateInventoryQueries(self.cache[type]))
    elseif type == 'reputation' then
        MySQL.transaction.await(self:GenerateReputationQueries(self.cache[type]))
    end
    
    self.cache[type] = {}
end