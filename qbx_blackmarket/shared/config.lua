Config = {}
Config.Debug = false
Config.Framework = 'qbx' -- 'qbx' or 'qb'

-- Performance optimization
Config.UpdateInterval = 1000 -- How often to update dealer states (ms)
Config.MaxConcurrentTransactions = 5
Config.BulkUpdatesEnabled = true
Config.CacheTimeout = 300 -- Seconds before cache expires

-- Different dealer types with unique characteristics
Config.DealerTypes = {
    weapon_dealer = {
        model = "g_m_m_armboss_01",
        items = {"WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_COMBATPISTOL", "ammo-9", "ammo-rifle", "ammo-shotgun", "armor", "WEAPON_KNUCKLE", "WEAPON_SWITCHBLADE"},
        schedule = "night", -- night/day/always
        risk_level = 3
    },
    drug_dealer = {
        model = "g_m_y_mexgoon_01",
        items = {"cocaine", "weed", "meth", "heroin", "drug_scales", "baggies", "chemicals", "weed_seeds", "drug_supplies", "cutting_agent"},
        schedule = "always",
        risk_level = 2
    },
    hacker = {
        model = "ig_lifeinvad_01",
        items = {"laptop", "hackingdevice", "trojan_usb", "secure_card", "encrypted_phone", "signal_jammer", "keycard_clone", "security_bypass", "vpn_device", "crypto_miner"},
        schedule = "day",
        risk_level = 1
    },
    fence = {
        model = "s_m_m_highsec_02",
        items = {"lockpick", "advancedlockpick", "thermite", "handcuffs", "drill", "c4_charge", "safe_cracker", "glass_cutter", "scrambler", "security_cards", "hacking_laptop"},
        schedule = "night",
        risk_level = 2
    },
    smuggler = {
        model = "s_m_y_dealer_01",
        items = {"fake_id", "counterfeit_cash", "gold_bar", "diamond", "forged_documents", "stolen_art", "contraband", "rare_coins", "black_money"},
        schedule = "always",
        risk_level = 3
    }
}

Config.BlackMarketLocations = {
    -- Weapon Dealers
    {
        coords = vector3(-1169.89, -1573.89, 4.35),
        heading = 125.0,
        dealer_type = "weapon_dealer",
        reputation_required = 100,
        zone = "city",
        spot_type = "indoor",
        backup_locations = {
            vector3(-1165.89, -1575.89, 4.35),
            vector3(-1172.89, -1570.89, 4.35)
        }
    },
    {
        coords = vector3(1240.86, -3168.42, 7.10),
        heading = 90.0,
        dealer_type = "weapon_dealer",
        reputation_required = 200,
        zone = "port",
        spot_type = "indoor"
    },

    -- Drug Dealers
    {
        coords = vector3(2340.12, 3126.45, 48.20),
        heading = 260.0,
        dealer_type = "drug_dealer",
        reputation_required = 50,
        zone = "desert",
        spot_type = "outdoor"
    },
    {
        coords = vector3(-1566.89, -405.89, 42.35),
        heading = 125.0,
        dealer_type = "drug_dealer",
        reputation_required = 150,
        zone = "city",
        spot_type = "indoor"
    },

    -- Hackers
    {
        coords = vector3(-1052.89, -230.89, 44.35),
        heading = 125.0,
        dealer_type = "hacker",
        reputation_required = 75,
        zone = "city",
        spot_type = "indoor"
    },

    -- Fences
    {
        coords = vector3(1647.89, 4857.89, 42.35),
        heading = 185.0,
        dealer_type = "fence",
        reputation_required = 25,
        zone = "county",
        spot_type = "outdoor"
    }
}

Config.Items = {
    -- Weapons
    WEAPON_PISTOL = {
        base_price = 15000,
        metadata = { registered = false },
        reputation_discount = true,
        police_price_multiplier = true,
        restock_time = 120,
        max_stock = 5,
        illegal_level = 3,
        required_items = { "black_money" }
    },
    WEAPON_SMG = {
        base_price = 25000,
        metadata = { registered = false },
        reputation_discount = true,
        police_price_multiplier = true,
        restock_time = 180,
        max_stock = 3,
        illegal_level = 3,
        required_items = { "black_money" }
    },

    -- Drugs
    cocaine = {
        base_price = 5000,
        reputation_discount = true,
        max_stock = 20,
        restock_time = 60,
        illegal_level = 2,
        quality_variation = true,
        metadata = { purity = 85 }
    },
    meth = {
        base_price = 4000,
        reputation_discount = true,
        max_stock = 20,
        restock_time = 60,
        illegal_level = 2,
        quality_variation = true,
        metadata = { purity = 85 }
    },

    -- Hacking Tools
    laptop = {
        base_price = 8000,
        reputation_discount = true,
        max_stock = 3,
        restock_time = 180,
        illegal_level = 1,
        required_items = { "black_money", "crypto" }
    },
    trojan_usb = {
        base_price = 3500,
        reputation_discount = true,
        max_stock = 5,
        restock_time = 120,
        illegal_level = 1
    },

    -- Tools
    lockpick = {
        base_price = 500,
        reputation_discount = true,
        max_stock = 15,
        restock_time = 30,
        illegal_level = 1
    },
    thermite = {
        base_price = 12000,
        reputation_discount = true,
        max_stock = 5,
        restock_time = 120,
        illegal_level = 2,
        required_items = { "black_money" }
    },

    -- Smuggled Items
    fake_id = {
        base_price = 7500,
        reputation_discount = true,
        max_stock = 8,
        restock_time = 90,
        illegal_level = 2,
        metadata = { quality = 90 }
    },
    gold_bar = {
        base_price = 25000,
        reputation_discount = true,
        max_stock = 2,
        restock_time = 240,
        illegal_level = 2,
        metadata = { purity = 99 }
    }
}

Config.ReputationLevels = {
    [0] = { name = "Stranger", discount = 0 },
    [50] = { name = "Associate", discount = 0.05, special_items = { "lockpick" } },
    [100] = { name = "Regular", discount = 0.10, special_items = { "WEAPON_PISTOL" } },
    [200] = { name = "Trusted", discount = 0.15, special_items = { "laptop" } },
    [500] = { name = "Made Man", discount = 0.20, special_items = { "WEAPON_SMG" } },
    [1000] = { name = "Kingpin", discount = 0.25, special_items = { "thermite" } }
}

Config.DynamicPricing = {
    police_multiplier = 0.1, -- 10% price increase per police
    time_multipliers = {
        ['00:00-04:00'] = 0.8, -- 20% discount at night
        ['04:00-08:00'] = 0.9,
        ['08:00-20:00'] = 1.0,
        ['20:00-00:00'] = 1.1
    },
    zone_multipliers = {
        ['city'] = 1.2,
        ['county'] = 1.0,
        ['desert'] = 0.8
    }
}

-- Unique dealer personality system
Config.DealerPersonalities = {
    paranoid = {
        suspicion_multiplier = 1.5,
        price_multiplier = 1.2,
        stock_multiplier = 0.7,
        dialogue = {
            greeting = {
                "Keep it quiet...",
                "You weren't followed, right?",
                "Make it quick..."
            },
            suspicious = {
                "Something's not right...",
                "I don't like this...",
                "We're being watched..."
            }
        }
    },
    professional = {
        suspicion_multiplier = 0.8,
        price_multiplier = 1.1,
        stock_multiplier = 1.0,
        dialogue = {
            greeting = {
                "Let's talk business.",
                "What can I help you with?",
                "Time is money."
            },
            suspicious = {
                "This isn't the right time.",
                "Let's reschedule.",
                "The situation is unfavorable."
            }
        }
    },
    greedy = {
        suspicion_multiplier = 0.6,
        price_multiplier = 1.3,
        stock_multiplier = 1.2,
        dialogue = {
            greeting = {
                "Got the cash?",
                "Let's make a deal!",
                "Show me the money!"
            },
            suspicious = {
                "This better be worth my time...",
                "The price just went up.",
                "Cash up front now."
            }
        }
    }
}

-- Dynamic event system
Config.Events = {
    police_raid = {
        duration = 30, -- minutes
        heat_increase = 50,
        price_multiplier = 1.5,
        affects_radius = 100.0
    },
    gang_war = {
        duration = 45,
        heat_increase = 30,
        price_multiplier = 0.8,
        affects_radius = 150.0
    },
    undercover_ops = {
        duration = 60,
        heat_increase = 40,
        dealer_relocation = true
    }
}

-- Dealer market influence system
Config.MarketInfluence = {
    max_influence = 100,
    decay_rate = 1, -- per hour
    effects = {
        price = {
            min_multiplier = 0.7,
            max_multiplier = 1.5
        },
        quality = {
            min_multiplier = 0.8,
            max_multiplier = 1.2
        },
        stock = {
            min_multiplier = 0.5,
            max_multiplier = 1.5
        }
    }
}
