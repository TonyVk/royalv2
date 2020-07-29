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

Config.PoliceStations = {
	SIPA = {

		Blip = {
			Coords     = vector3(112.27687072754, -749.67126464844, 45.751571655273),			
            Sprite  = 60,		
            Display = 4,	
            Scale   = 1.2,	
            Colour  = 40
		},

		Cloakrooms = {
			vector3(144.38725280762, -762.70251464844, 242.15196228027),
		},

		Armories = {
			vector3(118.81113433838, -729.02087402344, 242.15197753906),
		},

		Vehicles = {
			{
				Spawner = vector3(160.07308959961, -682.25354003906, 33.128028869629),
				InsideShop = vector3(228.5, -993.5, -99.0),
				SpawnPoints = {
					{ coords = vector3(154.28256225586, -698.27508544922, 32.782466888428), heading = 159.48413085938, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(138.35475158691, -765.03167724609, 242.15200805664),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{ coords = vector3(-75.233131408691, -819.96740722656, 326.27493286133), heading = 355.53, radius = 10.0 }
				}
			}
		},

		BossActions = {
			vector3(111.49167633057, -758.63348388672, 242.15214538574)
		}

	}

}

Config.AuthorizedWeapons = {
	recruit = {
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	officer = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	sergeant = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	intendent = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { 0, 0, 0, 0, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_SNIPERRIFLE', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	lieutenant = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	boss = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 0, 0, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { 0, 0, 0, 0, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_SNIPERRIFLE', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	}
}

Config.AuthorizedVehicles = {
	Shared = {
		{ model = 'police3', label = 'Novi Auto', price = 0 },
		{ model = 'poctavia', label = 'Skoda Octavia', price = 0},
	},

	recruit = {
		{ model = 'police', label = 'Mercedes CLA', price = 0 },
		{ model = 'poctavia', label = 'Skoda Octavia', price = 0},
	},

	officer = {
		{ model = 'police', label = 'Mercedes CLA', price = 0 },
		{ model = 'polgt500', label = 'Ford Mustang GT500', price = 0},
		{ model = 'poctavia', label = 'Skoda Octavia', price = 0},
	},

	sergeant = {
		{ model = 'police', label = 'Mercedes CLA', price = 0 },
		{ model = 'polgt500', label = 'Ford Mustang GT500', price = 0},
		{ model = 'pol718', label = 'Porsche Cayman 718', price = 0 },
		{ model = 'poctavia', label = 'Skoda Octavia', price = 0},
	},

	intendent = {
		{ model = 'riot', label = 'Int oklopno', price = 0},
		{ model = 'fbi2', label = 'VW Touareg', price = 0},
		{ model = 'police4', label = 'BMW 520d', price = 0 },
		{ model = 'Sheriff2', label = 'Mercedes G', price = 0},
	},

	lieutenant = {
		{ model = 'Rumpo3', label = 'Vojni Kombi', price = 0},
		{ model = 'police4', label = 'BMW 520d', price = 0 },
		{ model = 'riot2', label = 'Neko vozilo', price = 0},
		{ model = 'Sheriff2', label = 'Mercedes G', price = 0},
	},

	boss = {
		{ model = 'Rumpo3', label = 'Vojni Kombi', price = 0},
		{ model = 'police4', label = 'BMW 520d', price = 0 },
		{ model = 'riot2', label = 'Neko vozilo', price = 0},
		{ model = 'Sheriff2', label = 'Mercedes G', price = 0},
		{ model = 'fbi2', label = 'VW Touareg', price = 0},
		{ model = 'riot', label = 'Oklopno vozilo Interventna', price = 0 },
		{ model = 'fbi', label = 'Audi S8', price = 0 },
		{ model = 'riot2', label = 'Neko vozilo', price = 0}
	}
}

Config.AuthorizedHelicopters = {
	recruit = {},

	officer = {},

	sergeant = {},

	intendent = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 0 }
	},

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
	recruit_wear = {  -- Pocetnici
		EUP = true,
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPrecruit_wear = {  -- Pocetnici
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 194, 5 },
				{ 3, 5, 1 },
				{ 10, 1, 1 },
				{ 8, 54, 1 },
				{ 4, 26, 2 },
				{ 6, 16, 1 },
				{ 7, 9, 1 },
				{ 9, 15, 1 },
				{ 5, 56, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 196, 5 },
				{ 3, 4, 1 },
				{ 10, 1, 1 },
				{ 8, 28, 2 },
				{ 4, 42, 3 },
				{ 6, 53, 1 },
				{ 7, 9, 1 },
				{ 9, 1, 1 },
				{ 5, 56, 1 },
			}
		}
	},
	officer_wear = {  -- Saobracajci
		EUP = true,
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 2,
			['pants_1'] = 28,   ['pants_2'] = 15,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 113,  ['helmet_2'] = 5,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPofficer_wear = {  -- Saobracajci
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 45, 8 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 194, 9 },
				{ 3, 5, 1 },
				{ 10, 1, 1 },
				{ 8, 89, 1 },
				{ 4, 88, 13 },
				{ 6, 25, 1 },
				{ 7, 2, 1 },
				{ 9, 26, 2 },
				{ 5, 33, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 44, 8 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 196, 9 },
				{ 3, 4, 1 },
				{ 10, 1, 1 },
				{ 8, 66, 1 },
				{ 4, 91, 13 },
				{ 6, 26, 1 },
				{ 7, 2, 1 },
				{ 9, 28, 2 },
				{ 5, 33, 1 },
			}
		}
	},
	sergeant_wear = {  -- Od policajca do visi narednik
		EUP = true,
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 15,
			['helmet_1'] = 113,  ['helmet_2'] = 1,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPsergeant_wear = {  -- Od policajca do visi narednik
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 102, 1 },
				{ 3, 5, 1 },
				{ 10, 13, 1 },
				{ 8, 38, 1 },
				{ 4, 88, 3 },
				{ 6, 25, 1 },
				{ 7, 2, 1 },
				{ 9, 15, 1 },
				{ 5, 75, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 93, 1 },
				{ 3, 4, 1 },
				{ 10, 12, 1 },
				{ 8, 3, 1 },
				{ 4, 91, 3 },
				{ 6, 26, 1 },
				{ 7, 2, 1 },
				{ 9, 1, 1 },
				{ 5, 75, 1 },
			}
		}
	},
	intendent_wear = {  -- neko
		EUP = true,
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 15,
			['helmet_1'] = 113,  ['helmet_2'] = 14,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['glasses_1'] = 15,     ['glasses_2'] = 6
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,		['mask_2'] = 0
		}
	},
	
	EUPintendent_wear = {  -- neko
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 76, 1 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 53, 1 }, --maska
				{ 11, 54, 1 }, --torso
				{ 3, 97, 1 }, --ruke
				{ 10, 6, 1 }, --decals
				{ 8, 16, 1 }, --majica
				{ 4, 38, 1 }, --hlace
				{ 6, 26, 1 }, --cizme
				{ 7, 111, 1 }, --lancic
				{ 9, 17, 3 }, --bproof
				{ 5, 49, 1 }, --torba
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 75, 1 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 53, 1 },
				{ 11, 47, 1 },
				{ 3, 112, 1 },
				{ 10, 6, 1 },
				{ 8, 16, 1 },
				{ 4, 37, 1 },
				{ 6, 26, 1 },
				{ 7, 82, 1 },
				{ 9, 19, 3 },
				{ 5, 49, 1 },
			}
		}
	},
	lieutenant_wear = {
		EUP = true,
		male = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0,
			['torso_1'] = 139,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 59,   ['pants_2'] = 9,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 106,  ['helmet_2'] = 20,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['glasses_1'] = 15,     ['glasses_2'] = 6,
			['mask_1'] = 35,		['mask_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPlieutenant_wear = {
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 37, 2 },
				{ 3, 13, 1 },
				{ 10, 1, 1 },
				{ 8, 12, 1 },
				{ 4, 11, 5 },
				{ 6, 11, 1 },
				{ 7, 7, 1 },
				{ 9, 25, 1 },
				{ 5, 49, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 169, 2 },
				{ 3, 8, 1 },
				{ 10, 1, 1 },
				{ 8, 40, 4 },
				{ 4, 4, 4 },
				{ 6, 30, 1 },
				{ 7, 7, 1 },
				{ 9, 10, 1 },
				{ 5, 60, 1 },
			}
		}
	},
	boss_wear = {
		EUP = true,
		male = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0,
			['torso_1'] = 221,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 87,   ['pants_2'] = 6,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 106,  ['helmet_2'] = 20,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['glasses_1'] = 15,     ['glasses_2'] = 6,
			['mask_1'] = 0,		['mask_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	EUPboss_wear = {
		male = {
			ped = 'mp_m_freemode_01',
			props = {
			{ 0, 29, 3 },
			{ 1, 0, 0 },
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
			components = {
			{ 1, 1, 1 },
			{ 11, 64, 1 },
			{ 3, 1, 1 },
			{ 10, 24, 1 },
			{ 8, 3, 2 },
			{ 4, 88, 2 },
			{ 6, 36, 1 },
			{ 7, 1, 1 },
			{ 9, 1, 1 },
			{ 5, 1, 1 },
		}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
			{ 0, 29, 3 },
			{ 1, 0, 0 },
			{ 2, 0, 0 },
			{ 6, 0, 0 },
		},
			components = {
			{ 1, 1, 1 },
			{ 11, 57, 1 },
			{ 3, 15, 1 },
			{ 10, 23, 1 },
			{ 8, 15, 1 },
			{ 4, 91, 2 },
			{ 6, 37, 1 },
			{ 7, 1, 1 },
			{ 9, 1, 1 },
			{ 5, 1, 1 },
		}
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 18,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	gilet_wear = {
		male = {
			['bproof_1'] = 10,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}
}
