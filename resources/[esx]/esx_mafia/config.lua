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

Config.MafiaStations = {

  Mafia = {

    Blip = {
      Pos     = { x = -809.283, y = 180.914, z = 72.635 },
      Sprite  = 378,
      Display = 4,
      Scale   = 1.2,
      Colour  = 4,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_COMBATPISTOL',     price = 2500 },
      { name = 'WEAPON_ASSAULTSMG',       price = 9200 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 5000 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 2500 },
      { name = 'WEAPON_FIREWORK',         price = 1000 },
      { name = 'WEAPON_APPISTOL',         price = 2000 },
      { name = 'WEAPON_CARBINERIFLE',     price = 5000 },
      { name = 'WEAPON_REVOLVER',         price = 4500 },
      { name = 'WEAPON_GUSENBERG',        price = 8200 }
	  
    },

	  AuthorizedVehicles = {
		  { name = 'schafter3',  label = 'Civilno vozilo' },
		  { name = 'btype',      label = 'Roosevelt' },
		  { name = 'w140',   	 label = 'Mercedes W140' },
		  { name = 'guardian',   label = 'Veliki 4x4' },
		  { name = 'burrito3',   label = 'Kombi' },
		  { name = 'dubsta',     label = 'Mercedes G klasa' },
		  { name = 'nh2r',   	 label = 'Kawasaki Ninja' }
	  },

    Armories = {
      { x = -811.750, y = 175.397, z = 76.017 },
    },

    Vehicles = {
      {
        Spawner    = { x = -818.40, y = 182.17, z = 72.087 },
        SpawnPoint = { x = -810.637, y = 188.963, z = 72.066 },
        Heading    = 98.22,
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
      { x = -807.5, y = 162.9, z = 71.027 },
      { x = -803.15, y = 163.3, z = 71.027 },
    },

    BossActions = {
      { x = -806.413, y = 170.897, z = 72.028 }
    },

  },

}
