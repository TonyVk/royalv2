Config = {}

-- # Locale to be used. You can create your own by simple copying the 'en' and translating the values.
Config.Locale       				= 'en' -- Traduções disponives en / br

-- # By how many services a player's community service gets extended if he tries to escape
Config.ServiceExtensionOnEscape		= 0

-- # Don't change this unless you know what you are doing.
Config.ServiceLocation 				= {x =  129.17, y = -746.87, z = 258.00}

-- # Don't change this unless you know what you are doing.
Config.ReleaseLocation				= {x = 98.33, y = -743.55, z = 44.9}


-- # Don't change this unless you know what you are doing.
Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(150.0, -751.0, 257.59) },
	{ type = "cleaning", coords = vector3(142.0, -756.0, 257.59) },
	{ type = "cleaning", coords = vector3(136.0, -749.5, 257.59) },
	{ type = "cleaning", coords = vector3(125.6, -748.0, 257.59) },
	{ type = "cleaning", coords = vector3(124.0, -740.0, 257.59) },
	{ type = "cleaning", coords = vector3(116.0, -740.0, 257.59) },
	{ type = "cleaning", coords = vector3(127.0, -755.0, 257.59) },
	{ type = "gardening", coords = vector3(130.4, -751.25, 258.59) },
	{ type = "gardening", coords = vector3(147.8, -750.27, 258.59) },
}



Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 146, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 119, ['pants_1']  = 3,
			['pants_2']  = 7,   ['shoes_1']  = 12,
			['shoes_2']  = 12,  ['chain_1']  = 0,
			['chain_2']  = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1']  = 38,  ['torso_2']  = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 120,  ['pants_1'] = 3,
			['pants_2']  = 15,  ['shoes_1']  = 66,
			['shoes_2']  = 5,   ['chain_1']  = 0,
			['chain_2']  = 0
		}
	}
}
