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

Config.BritvaStations = {

  Britvasi = {

    Blip = {
      Pos     = { x = -2677.4111328125, y = 1336.4871826172, z = 152.01608276367 },
      Sprite  = 378,
      Display = 4,
      Scale   = 1.2,
      Colour  = 39,
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
		  { name = 'r6',  label = 'Yamaha YZF R6 2015' },
		  { name = 'e63b',  label = 'Mercedes-Benz E63 Brabus' },
		  { name = 'mlbrabus',      label = 'Mercedes-Benz ML Brabus' },
		  { name = 'rmodgt63',      label = 'Mercedes-Benz AMG GT63S' },
		  { name = 'fastback',      label = 'Ford Mustang Fastback 1967' },
		  { name = 'x6m',   	 label = 'BMW X6M' },
		  { name = 'guardian',   label = 'Guardian 4x4' },
		  { name = 'bmci',   label = 'BMW M5 F90' }
	  },
    Armories = {
      { x = -2676.90234375, y = 1328.4166259766, z = 139.881423950 },
    },
	
    Vehicles = {
      { 
        Spawner    = { x = -2668.6625976563, y = 1304.9753417969, z = 146.11845397949 },
        SpawnPoint = { x = -2660.4921875, y = 1307.4168701172, z = 145.83178710938 },
        Heading    = 271.75,
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
      { x = -2668.5422363281, y = 1309.7915039063, z = 146.11863708496 }
    },
    BossActions = {
      { x = -2677.4111328125, y = 1336.4871826172, z = 151.01608276367 }
    },

  },

}
