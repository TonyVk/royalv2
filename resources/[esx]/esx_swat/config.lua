Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = false
Config.EnableESXIdentity          = true  -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = 64
Config.Locale                     = 'hr'

Config.SwatStations = {

	SWAT = {

		Blip = {
			Coords  = vector3(115.19259643555,-748.21105957031,45.75159072876),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 40
		},

		Cloakrooms = {
			vector3(115.19259643555,-748.21105957031,45.75159072876)
		},
		
		Lift = {
			vector3(136.37605285645, -761.48828125, 242.15208435059), --spawngorelift
			vector3(136.00257873535, -761.83264160156, 45.752002716064), --prvikatdizalo
			vector3(144.39872741699, -688.8828125, 33.128238677979) --portdogaraze
		},

		Armories = {
			vector3(118.98237609863,-731.2158203125,242.15190124512)
		},

		Vehicles = {
			{
				Spawner = vector3(170.76194763184,-693.73510742188,33.128093719482),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(166.08876037598,-706.60467529297,32.966159820557), heading = 158.79704284668, radius = 6.0 }
				}
			},
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 43.6),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{ coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0 }
				}
			}
		},

		BossActions = {
			vector3(113.17698669434,-735.30792236328,242.15219116211)
		}

	}

}

Config.AuthorizedWeapons = {
	recruit = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_SMOKEGRENADE', price = 0 }
	},

	officer = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_SMOKEGRENADE', price = 0 }
	},

	sergeant = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_SMOKEGRENADE', price = 0 }
	},

	intendent = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_SMOKEGRENADE', price = 0 }
	},

	lieutenant = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_SMOKEGRENADE', price = 0 }
	},

	chef = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_SMOKEGRENADE', price = 0 }
	},

	boss = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_SNIPERRIFLE', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 },
		{ weapon = 'WEAPON_SMOKEGRENADE', price = 0 }
	}
}

Config.AuthorizedVehicles = {
	Shared = {
		{ model = 'riot', label = 'SWAT Riot', price = 0 },
		{ model = 'fbi2', label = 'SWAT SUV', price = 0 },
		{ model = 'fbi', label = 'SWAT Buffalo', price = 0 },
		{ model = 'riot2', label = 'SWAT Riot 2', price = 0 },
		{ model = 'police4', label = 'SWAT Cruiser', price = 0 },
	},

	recruit = {

	},

	officer = {
		
	},

	sergeant = {
		
	},

	intendent = {

	},

	lieutenant = {
		
	},

	chef = {

	},

	boss = {

	}
}

Config.AuthorizedHelicopters = {
	recruit = {},

	officer = {},

	sergeant = {},

	intendent = {},

	lieutenant = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 0 }
	},

	chef = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 0 }
	},

	boss = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 0 }
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	recruit_wear = {
		male = {
			['tshirt_1'] = 127,  ['tshirt_2'] = 0,
            ['torso_1'] = 53,   ['torso_2'] = 0,
            ['mask_1'] = 121,   ['mask_2'] = 0,
            ['arms'] = 30,
            ['pants_1'] = 31,   ['pants_2'] = 0,
            ['shoes_1'] = 81,   ['shoes_2'] = 0,
            ['helmet_1'] = 115,  ['helmet_2'] = 0
		},
		female = {
			['tshirt_1'] = 155,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 102,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 125,  ['helmet_2'] = 0
		}
	},
	officer_wear = {
		male = {
			['tshirt_1'] = 127,  ['tshirt_2'] = 0,
            ['torso_1'] = 53,   ['torso_2'] = 0,
            ['mask_1'] = 121,   ['mask_2'] = 0,
            ['arms'] = 30,
            ['pants_1'] = 31,   ['pants_2'] = 0,
            ['shoes_1'] = 81,   ['shoes_2'] = 0,
            ['helmet_1'] = 115,  ['helmet_2'] = 0
		},
		female = {
			['tshirt_1'] = 155,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 102,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 125,  ['helmet_2'] = 0
		}
	},
	sergeant_wear = {
		male = {
			['tshirt_1'] = 127,  ['tshirt_2'] = 0,
            ['torso_1'] = 53,   ['torso_2'] = 0,
            ['mask_1'] = 121,   ['mask_2'] = 0,
            ['arms'] = 30,
            ['pants_1'] = 31,   ['pants_2'] = 0,
            ['shoes_1'] = 81,   ['shoes_2'] = 0,
            ['helmet_1'] = 115,  ['helmet_2'] = 0
		},
		female = {
			['tshirt_1'] = 155,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 102,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 125,  ['helmet_2'] = 0
		}
	},
	intendent_wear = {
		male = {
			['tshirt_1'] = 127,  ['tshirt_2'] = 0,
            ['torso_1'] = 53,   ['torso_2'] = 0,
            ['mask_1'] = 121,   ['mask_2'] = 0,
            ['arms'] = 30,
            ['pants_1'] = 31,   ['pants_2'] = 0,
            ['shoes_1'] = 81,   ['shoes_2'] = 0,
            ['helmet_1'] = 115,  ['helmet_2'] = 0
		},
		female = {
			['tshirt_1'] = 155,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 102,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 125,  ['helmet_2'] = 0
		}
	},
	lieutenant_wear = { -- currently the same as intendent_wear
		male = {
			['tshirt_1'] = 127,  ['tshirt_2'] = 0,
            ['torso_1'] = 53,   ['torso_2'] = 0,
            ['mask_1'] = 121,   ['mask_2'] = 0,
            ['arms'] = 30,
            ['pants_1'] = 31,   ['pants_2'] = 0,
            ['shoes_1'] = 81,   ['shoes_2'] = 0,
            ['helmet_1'] = 115,  ['helmet_2'] = 0
		},
		female = {
			['tshirt_1'] = 155,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 102,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 125,  ['helmet_2'] = 0
		}
	},
	chef_wear = {
		male = {
			['tshirt_1'] = 127,  ['tshirt_2'] = 0,
            ['torso_1'] = 53,   ['torso_2'] = 0,
            ['mask_1'] = 121,   ['mask_2'] = 0,
            ['arms'] = 30,
            ['pants_1'] = 31,   ['pants_2'] = 0,
            ['shoes_1'] = 81,   ['shoes_2'] = 0,
            ['helmet_1'] = 115,  ['helmet_2'] = 0
		},
		female = {
			['tshirt_1'] = 155,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 102,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 125,  ['helmet_2'] = 0
		}
	},
	boss_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 127,  ['tshirt_2'] = 0,
            ['torso_1'] = 53,   ['torso_2'] = 0,
            ['mask_1'] = 121,   ['mask_2'] = 0,
            ['arms'] = 30,
            ['pants_1'] = 31,   ['pants_2'] = 0,
            ['shoes_1'] = 81,   ['shoes_2'] = 0,
            ['helmet_1'] = 115,  ['helmet_2'] = 0
		},
		female = {
			['tshirt_1'] = 155,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['mask_1'] = 121,   ['mask_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 102,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 125,  ['helmet_2'] = 0
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}

}
