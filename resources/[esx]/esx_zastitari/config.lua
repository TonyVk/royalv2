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
			Coords  = vector3(-1989.4814453125, -505.12197875977, 16.11011505127),
			Sprite  = 487,
			Display = 4,
			Scale   = 1.2,
			Colour  = 29,
			Naziv = "Hatler zastitarska agencija"
		},

		Cloakrooms = {
			vector3(-1981.3006591797, -499.80526733398, 20.732828140259)
		},

		Armories = {
			vector3(-1985.7078857422, -505.61401367188, 12.178236961365)
		},

		Vehicles = {
		  {
			Spawner    = vector3(-1983.1166992188, -499.81042480469, 12.178228378296),
			SpawnPoint = vector3(-1974.0572509766, -488.51544189453, 11.16717338562),
			Heading    = 232.23,
		  }
		},
		
		VehicleDeleters = {
			vector3(-1977.9602050781, -493.32781982422, 11.178526878357)
		},
		
		AuthorizedVehicles = {
			{ name = 'cls2015',  label = 'Mercedes CLS 2015' },
			{ name = 'guardian',  label = 'Guardian' }
		},

		BossActions = {
			vector3(-1989.4814453125, -505.12197875977, 16.11011505127)
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
	zastitar_wear = {  -- Pocetnici
		EUP = false,
		male = {
			['tshirt_1'] = 87,  ['tshirt_2'] = 0,
			['torso_1'] = 18,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 19,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 53,   ['shoes_2'] = 0,
			['chain_1'] = 1, 	['chain_2'] = 0,
			['helmet_1'] = 44,  ['helmet_2'] = 4,
			['glasses_1'] = 8,    ['glasses_2'] = 0
		},
		female = {
			['tshirt_1'] = 87,  ['tshirt_2'] = 0,
			['torso_1'] = 18,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 19,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 53,   ['shoes_2'] = 0,
			['chain_1'] = 1, 	['chain_2'] = 0,
			['helmet_1'] = 44,  ['helmet_2'] = 4,
			['glasses_1'] = 8,    ['glasses_2'] = 0
		}
	},
	EUPzastitar_wear = {  -- Pocetnici
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
	sekretar_wear = {  -- Saobracajci
		EUP = false,
		male = {
			['tshirt_1'] = 87,  ['tshirt_2'] = 0,
			['torso_1'] = 18,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 19,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 53,   ['shoes_2'] = 0,
			['chain_1'] = 1, 	['chain_2'] = 0,
			['helmet_1'] = 44,  ['helmet_2'] = 4,
			['glasses_1'] = 8,    ['glasses_2'] = 0
		},
		female = {
			['tshirt_1'] = 87,  ['tshirt_2'] = 0,
			['torso_1'] = 18,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 19,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 53,   ['shoes_2'] = 0,
			['chain_1'] = 1, 	['chain_2'] = 0,
			['helmet_1'] = 44,  ['helmet_2'] = 4,
			['glasses_1'] = 8,    ['glasses_2'] = 0
		}
	},
	EUPsekretar_wear = {  -- Saobracajci
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
	komandant_wear = {  -- Od policajca do visi narednik
		EUP = false,
		male = {
			['tshirt_1'] = 87,  ['tshirt_2'] = 0,
			['torso_1'] = 18,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 19,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 53,   ['shoes_2'] = 0,
			['chain_1'] = 1, 	['chain_2'] = 0,
			['helmet_1'] = 44,  ['helmet_2'] = 4,
			['glasses_1'] = 8,    ['glasses_2'] = 0
		},
		female = {
			['tshirt_1'] = 87,  ['tshirt_2'] = 0,
			['torso_1'] = 18,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 19,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 53,   ['shoes_2'] = 0,
			['chain_1'] = 1, 	['chain_2'] = 0,
			['helmet_1'] = 44,  ['helmet_2'] = 4,
			['glasses_1'] = 8,    ['glasses_2'] = 0
		}
	},
	EUPkomandant_wear = {  -- Od policajca do visi narednik
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
	boss_wear = {
		EUP = false,
		male = {
			['tshirt_1'] = 54,  ['tshirt_2'] = 0,
			['torso_1'] = 118,   ['torso_2'] = 8,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 32,   ['pants_2'] = 1,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 8, 	['chain_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['glasses_1'] = 8,    ['glasses_2'] = 0
		},
		female = {
			['tshirt_1'] = 54,  ['tshirt_2'] = 0,
			['torso_1'] = 118,   ['torso_2'] = 8,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 32,   ['pants_2'] = 1,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 8, 	['chain_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['glasses_1'] = 8,    ['glasses_2'] = 0
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
	}
}
