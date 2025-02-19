local Cache = {
    data = {},
    timestamps = {}
}

function Cache:Set(key, value, timeout)
    self.data[key] = value
    self.timestamps[key] = GetGameTimer() + (timeout or Config.CacheTimeout) * 1000
end

function Cache:Get(key)
    if self.timestamps[key] and GetGameTimer() < self.timestamps[key] then
        return self.data[key]
    end
    return nil
end

function Cache:Clear(key)
    self.data[key] = nil
    self.timestamps[key] = nil
end