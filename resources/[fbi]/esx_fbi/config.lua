Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 =  0
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true -- only turn this on if you are using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.MaxInService               = -1
Config.Locale                     = 'en'

Config.FbiStations = {

	FBI = {

		Blip = {	
            Pos     = { x = 1666.1, y = -16.3, z = 173.7 },			
            Sprite  = 188,		
            Display = 4,	
            Scale   = 0.8,	
            Colour  = 26,
		},
		-- https://wiki.fivem.net/wiki/Weapons
		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK',       price = 0 },
			{ name = 'WEAPON_COMBATPISTOL',     price = 0 },
			{ name = 'WEAPON_ASSAULTSMG',       price = 0 },
			{ name = 'WEAPON_ASSAULTRIFLE',     price = 0 },
			{ name = 'WEAPON_PUMPSHOTGUN',      price = 0 },
			{ name = 'WEAPON_STUNGUN',          price = 0 },
			{ name = 'WEAPON_FLASHLIGHT',       price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', price = 0 },
			{ name = 'WEAPON_FLAREGUN',         price = 0 },
			{ name = 'WEAPON_STICKYBOMB',       price = 0 },
			{ name = 'GADGET_PARACHUTE',        price = 0 },
		},

		Cloakrooms = {
			{ x = 1662.814, y = -25.305, z = 173.551 },
		},

		Armories = {
			{ x = 1663.998, y = -49.942, z = 168.552 },
		},

		Vehicles = {
			{
				Spawner    = { x = 1670.185, y = -59.915, z = 173.533 },
				SpawnPoint = { x = 1668.85, y = -62.44, z = 173.533 },
				Heading    = 254.0,
			}
		},

		Helicopters = {
			{
				Spawner    = { x = 1689.960, y = -11.945, z = 162.511 },
				SpawnPoint = { x = 1708.190, y = -6.930, z = 164.391 },
				Heading    = 289.6,
			}
		},

		VehicleDeleters = {
			{ x = 1660.334, y = -75.981, z = 172.133 },
		},

		BossActions = {
			{ x = 1667.830, y = -23.239, z = 178.151 },
		},

	},

}

-- https://wiki.fivem.net/wiki/Vehicles
Config.AuthorizedVehicles = {
	Shared = {
		{
			model = 'police4',
			label = 'BMW M5'
		},
		{
			model = 'police2',
			label = 'Insurgent'
		},
		{
			model = 'fbi2',
			label = 'Volkswagen Touareg'
		},
	},

	recruit = {
	
	},

	officer = {
	
	},

	sergeant = {
	
	},

	lieutenant = {
		
	},

	boss = {
		
	},
}



-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	lieutenant_wear = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 208,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 19,
			['pants_1'] = 97,   ['pants_2'] = 8,
			['shoes_1'] = 70,   ['shoes_2'] = 8,
			['helmet_1'] = 106,  ['helmet_2'] = 20,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['glasses_1'] = 15,    ['glasses_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 160,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 3,
			['pants_1'] = 30,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		}
	},
	
	commandant_wear = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 208,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 19,
			['pants_1'] = 97,   ['pants_2'] = 8,
			['shoes_1'] = 70,   ['shoes_2'] = 8,
			['helmet_1'] = 114,  ['helmet_2'] = 7,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['glasses_1'] = 15,    ['glasses_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 160,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 3,
			['pants_1'] = 30,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		}
	},

	bullet_wear = {
		male = {
			['bproof_1'] = 16,  ['bproof_2'] = 2
		},
		female = {
			['bproof_1'] = 16,  ['bproof_2'] = 2
		}
	}

}