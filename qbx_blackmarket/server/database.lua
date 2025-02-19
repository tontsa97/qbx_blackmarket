function InitializeDatabase()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS player_reputations (
            citizenid VARCHAR(50) PRIMARY KEY,
            reputation INT DEFAULT 0,
            last_purchase TIMESTAMP,
            total_spent INT DEFAULT 0,
            favorite_dealer VARCHAR(50)
        )
    ]])
end

function LoadAllPlayerReputations()
    local result = MySQL.query.await('SELECT * FROM player_reputations')
    for _, data in ipairs(result) do
        playerReputations[data.citizenid] = {
            reputation = data.reputation,
            last_purchase = data.last_purchase,
            total_spent = data.total_spent,
            favorite_dealer = data.favorite_dealer
        }
    end
end