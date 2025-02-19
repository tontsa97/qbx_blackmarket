local activeZones = {}

function CreateDealerZone(location, dealer)
    local zone = lib.zones.sphere({
        coords = location.coords,
        radius = 2.0,
        debug = Config.Debug,
        inside = function()
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                lib.showTextUI('[E] - Talk to Dealer')
            end
        end,
        onExit = function()
            lib.hideTextUI()
        end
    })
    
    activeZones[location.coords] = zone
end