Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true  -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableLicenses             = true -- enable if you're using esx_license
Config.EnableSocietyOwnedVehicles = false

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'hr'

Config.ZastitarStations = {

	Zastitar = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 487,
			Display = 4,
			Scale   = 1.2,
			Colour  = 29,
			Naziv = "Hatler zastitarska agencija"
		},

		Cloakrooms = {
			vector3(452.6, -992.8, 30.6),
			vector3(1662.814, -25.306, 172.551)
		},

		Armories = {
			vector3(451.7, -980.1, 30.6),
			vector3(1663.998, -49.942, 168.552)
		},

		Vehicles = {
		  {
			Spawner    = vector3(454.6, -1017.4, 28.4),
			SpawnPoint = vector3(438.4, -1018.3, 27.7),
			Heading    = 90.0,
		  }
		},
		
		VehicleDeleters = {
			vector3(448.14599609375, -1025.1856689453, 27.607002258301)
		},
		
		AuthorizedVehicles = {
			{ name = 'cls2015',  label = 'Mercedes CLS 2015' },
			{ name = 'guardian',  label = 'Guardian' }
		},

		BossActions = {
			vector3(448.4, -973.2, 30.6)
		}

	}
}

Config.AuthorizedWeapons = {
	zastitar = {
		{ weapon = 'WEAPON_APPISTOL', components = { nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_ASSAULTRIFLE', components = { nil, nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { nil, nil, nil, nil, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	sekretar = {
		{ weapon = 'WEAPON_APPISTOL', components = { nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_ASSAULTRIFLE', components = { nil, nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { nil, nil, nil, nil, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	komandant = {
		{ weapon = 'WEAPON_APPISTOL', components = { nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_ASSAULTRIFLE', components = { nil, nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { nil, nil, nil, nil, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	boss = {
		{ weapon = 'WEAPON_APPISTOL', components = { nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_ASSAULTRIFLE', components = { nil, nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_COMBATPISTOL', components = { nil, nil, nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { nil, nil, nil }, price = 0 },
		{ weapon = 'WEAPON_SMG' , components = { nil, nil, nil, nil, nil }, price = 0},
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
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
				{ 0, 14, 1 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 201, 3 },
				{ 3, 5, 1 },
				{ 10, 1, 1 },
				{ 8, 39, 2 },
				{ 4, 26, 1 },
				{ 6, 52, 1 },
				{ 7, 9, 1 },
				{ 9, 1, 1 },
				{ 5, 54, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 14, 1 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 203, 3 },
				{ 3, 4, 1 },
				{ 10, 1, 1 },
				{ 8, 52, 2 },
				{ 4, 42, 2 },
				{ 6, 53, 1 },
				{ 7, 9, 1 },
				{ 9, 1, 1 },
				{ 5, 54, 1 },
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
	chef_wear = { -- INFECTED
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
	EUPchef_wear = { -- INFECTED
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
	boss_wear = { -- ISMIR
		EUP = true,
		male = {
			['tshirt_1'] = 21,  ['tshirt_2'] = 4,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 12,  ['helmet_2'] = 0,
			['chain_1'] = 125,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['glasses_1'] = 4,     ['glasses_2'] = 2
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
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 5, 2 },
				{ 3, 13, 1 },
				{ 10, 1, 1 },
				{ 8, 12, 1 },
				{ 4, 11, 4 },
				{ 6, 11, 1 },
				{ 7, 13, 9 },
				{ 9, 24, 1 },
				{ 5, 67, 1 },
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
				{ 11, 25, 3 },
				{ 3, 8, 1 },
				{ 10, 1, 1 },
				{ 8, 65, 2 },
				{ 4, 4, 9 },
				{ 6, 30, 1 },
				{ 7, 1, 1 },
				{ 9, 26, 1 },
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
