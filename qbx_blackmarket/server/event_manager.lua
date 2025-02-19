local EventManager = {
    active_events = {},
    event_effects = {}
}

function EventManager:StartEvent(event_type, location)
    if not Config.Events[event_type] then return end
    
    local event_config = Config.Events[event_type]
    local event_id = os.time()
    
    self.active_events[event_id] = {
        type = event_type,
        location = location,
        start_time = os.time(),
        end_time = os.time() + event_config.duration * 60,
        affects_radius = event_config.affects_radius
    }
    
    -- Apply immediate effects
    self:ApplyEventEffects(event_id)
    
    -- Schedule cleanup
    SetTimeout(event_config.duration * 60 * 1000, function()
        self:EndEvent(event_id)
    end)
    
    return event_id
end