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

Config.CamorraStations = {

  Camorra = {

    Blip = {
      Pos     = { x = -824.72473144531, y = 180.1802520752, z = 70.959587097168 },
      Sprite  = 378,
      Display = 4,
      Scale   = 1.2,
      Colour  = 40,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_COMBATPISTOL',     price = 2500 },
      { name = 'WEAPON_ASSAULTSMG',       price = 9200 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 5000 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 2500 },
      { name = 'WEAPON_APPISTOL',         price = 2000 },
      { name = 'WEAPON_CARBINERIFLE',     price = 5000 },
      { name = 'WEAPON_REVOLVER',         price = 4500 },
      { name = 'WEAPON_GUSENBERG',        price = 8200 }
	  
    },

	  AuthorizedVehicles = {
		  { name = 'cls2015',  label = 'Mercedes Benz CLS' },
		  { name = 'x6m',  label = 'BMW X6M' },
		  { name = 'divo',      label = 'Bugatti Divo' },
		  { name = '911turbos',      label = 'Porsche 911 Turbo S' },
		  { name = 'gtr',      label = 'Nissan GT-R' },
		  { name = 'x6m',   	 label = 'BMW X6M' },
		  { name = 'guardian',   label = 'Guardian 4x4' },
		  { name = 'rmodgt63',   label = 'Mercedes Benz AMG GT63S' },
		  { name = 'r6',   label = 'Yamaha R6' }
	  },
    Armories = {
      { x = -809.63250732422, y = 172.34397888184, z = 75.74055480957 },
    },
	
    Vehicles = {
      { 
        Spawner    = { x = -818.06384277344, y = 184.86972045898, z = 71.300422668457 },
        SpawnPoint = { x = -824.72473144531, y = 180.1802520752, z = 69.959587097168 },
        Heading    = 134.67,
      }
    },
	
	Helicopters = {
      {
        Spawner    = { x = 20.312, y = 535.667, z = 173.627 },
        SpawnPoint = { x = 3.40, y = 525.56, z = 177.919 },
        Heading    = 0.0,
      }
    },
    VehicleDeleters = {
      { x = -811.95550537109, y = 187.35440063477, z = 71.473335266113 }
    },
    BossActions = {
      { x = -803.93542480469, y = 173.0811920166, z = 71.844718933105 }
    },

  },

}
