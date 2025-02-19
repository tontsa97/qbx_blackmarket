function IsTimeBetween(time, startTime, endTime)
    local currentHour = tonumber(string.sub(time, 1, 2))
    local startHour = tonumber(string.sub(startTime, 1, 2))
    local endHour = tonumber(string.sub(endTime, 1, 2))
    
    if endHour < startHour then
        return currentHour >= startHour or currentHour <= endHour
    else
        return currentHour >= startHour and currentHour <= endHour
    end
end

function GetPoliceCount()
    local players = QBX.Functions.GetQBPlayers()
    local policeCount = 0
    
    for _, player in pairs(players) do
        if player.PlayerData.job.name == "police" then
            policeCount = policeCount + 1
        end
    end
    
    return policeCount
end