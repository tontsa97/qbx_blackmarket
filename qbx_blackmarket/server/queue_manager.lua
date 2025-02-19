local QueueManager = {
    active_transactions = {},
    queue = {},
    max_concurrent = Config.MaxConcurrentTransactions
}

function QueueManager:AddTransaction(player_id, transaction_data)
    if #self.active_transactions >= self.max_concurrent then
        table.insert(self.queue, {
            player_id = player_id,
            data = transaction_data
        })
        return false
    end
    
    self:ProcessTransaction(player_id, transaction_data)
    return true
end