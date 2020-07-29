Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale                     = 'hr'

Config.HitmanStations = {

  Hitman = {

    Blip = {
      Pos     = { x = 1399.79, y = 1141.65, z = 113.34 },
      Sprite  = 458,
      Display = 4,
      Scale   = 1.2,
      Colour  = 55,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_COMBATPISTOL', components = { 0, 0, 0, 0, nil }, price = 0 },
      { name = 'WEAPON_ASSAULTSMG',       price = 0 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 0 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 0 },
      { name = 'WEAPON_APPISTOL',         price = 0 },
      { name = 'WEAPON_CARBINERIFLE',     price = 0 },
      { name = 'WEAPON_REVOLVER',         price = 0 },
      { name = 'WEAPON_GUSENBERG',        price = 0 },
	  { name = 'WEAPON_SNIPERRIFLE',      price = 0 },
	  { name = 'WEAPON_STICKYBOMB',       price = 0 }
	  
    },

	  AuthorizedVehicles = {
		  { name = 'polgt500',  label = 'Policijski Auto' },
		  { name = 'tahoe',      label = 'Bolnicarski Auto' },
		  { name = 'r820',   label = 'Audi R8' },
		  { name = 'lambose',      label = 'Lamborghini Sesto Elemento' },
		  { name = 'amv19',   label = 'Aston Martin Vantage' },
		  { name = 'bmci',   label = 'BMW M5 F90' },
		  { name = 'rmodgt63',      label = 'Mercedes GT63s' }
	  },

    Cloakrooms = {
      { x = 1399.79, y = 1141.65, z = 113.34 },
    },

    Armories = {
      { x = 1399.79, y = 1139.65, z = 113.34 },
    },
	
	Ulazi = {
      { x = 1410.7829589844, y = 1147.4383544922, z = 113.33406829834, h = 272.51358032227 },
    },
	
	Izlazi = {
      { x = 1408.1248779297, y = 1147.287109375, z = 113.33361816406, h = 87.563606262207 },
    },

    Vehicles = {
      {
        Spawner    = { x = 1369.1, y = 1147.05, z = 112.77 },
        SpawnPoint = { x = 1370.71, y = 1149.4, z = 112.76 },
        Heading    = 40,
      }
    },

    VehicleDeleters = {
      { x = 1407.4262695312, y = 1115.5495605468, z = 113.83769989014 }
    },

    BossActions = {
      { x = 1395.39, y = 1148.44, z = 113.34 }
    },

  },

}

Config.Uniforms = {
	recruit_wear = {
		male = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 38,    ['chain_2'] = 0,
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
	officer_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
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
	sergeant_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 60,   ['decals_2'] = 0,
			['arms'] = 92,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 1,   ['shoes_2'] = 0,
			['helmet_1'] = 8,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
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
	intendent_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 0,
			['torso_1'] = 89,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 36,   ['pants_2'] = 0,
			['shoes_1'] = 1,   ['shoes_2'] = 0,
			['helmet_1'] = 5,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
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
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
}
