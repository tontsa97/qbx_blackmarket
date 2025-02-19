function GetReputationLevel(reputation)
    local currentLevel = 0
    for level, data in pairs(Config.ReputationLevels) do
        if reputation >= level then
            currentLevel = level
        else
            break
        end
    end
    return currentLevel
end

function CalculateReputationGain(data)
    local baseGain = data.illegal_level * 5
    local qualityModifier = data.metadata and data.metadata.quality and (data.metadata.quality / 100) or 1
    return math.floor(baseGain * qualityModifier)
end