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

Config.ZemunskiStations = {

  Zemunski = {

    Blip = {
      Pos     = { x = -1516.3908691406, y = 852.08935546875, z = 180.59471130372 },
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
		  { name = '18performante',  label = 'Lamborghini Huracan Performante' },
		  { name = 'divo',  label = 'Bugatti Divo' },
		  { name = '19S650',      label = 'Mercedes-Benz S Class' },
		  { name = 'rmodgt63',      label = 'Mercedes-Benz AMG GT63S' },
		  { name = '911turbos',      label = 'Mercedes-Benz 911 Turbo S' },
		  { name = 'x6m',   	 label = 'BMW X6M' },
		  { name = 'guardian',   label = 'Guardian 4x4' },
		  { name = 'wraith',   label = 'Rolls Royce Wraith' },
		  { name = 'panamera17turbo',   label = 'Porsche Panamera' },
		  { name = 'p1',   label = 'McLaren P1' },
		  { name = 'bmwm8',   label = 'BMW M8 Coupe' },
		  { name = 'gtrc',   label = 'Mercedes-Benz GT-R' }
	  },
    Armories = {
      { x = 475.44345704, y = -1310.79194384766, z = 28.043359375 },
    },
	
	Impound = {
      { x = 485.68725585938, y = -1307.5949707031, z = 28.105322265625 },
    },
	
    Vehicles = {
      { 
        Spawner    = { x = 490.5250488282, y = -1306.23914794922, z = 28.2540893554 },
        SpawnPoint = { x = 484.8144335938, y = -1306.84107666016, z = 28.2750488282 },
        Heading    = 215.73,
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
      { x = 502.348461914, y = -1338.67784423828, z = 28.24039917 }
    },
    BossActions = {
      { x = 472.1908691406, y = -1310.08935546875, z = 28.09471130372 }
    },

  },

}
