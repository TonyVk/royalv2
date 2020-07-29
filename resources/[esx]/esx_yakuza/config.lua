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

Config.YakuzaStations = {

  Yakuza = {

    Blip = {
      Pos     = { x = -881.91589355468, y = -1462.3604736328, z = 7.5268020629882 },
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
      { name = 'WEAPON_FIREWORK',         price = 1000 },
      { name = 'WEAPON_APPISTOL',         price = 2000 },
      { name = 'WEAPON_CARBINERIFLE',     price = 5000 },
      { name = 'WEAPON_REVOLVER',         price = 4500 },
      { name = 'WEAPON_GUSENBERG',        price = 8200 }
	  
    },

	  AuthorizedVehicles = {
		  { name = 'm3f80',  label = 'BMW M3 F80' },
		  { name = 'rs7',      label = 'Audi RS7' },
		  { name = 'mule3',   	 label = 'Mule' },
		  { name = 'guardian',   label = 'Guardian 4x4' },
		  { name = 'lancerevox',   label = 'Mitsubishi EVO X' },
		  { name = 'rrst',     label = 'Range Rover' },
		  { name = 'windsor2',     label = 'Windsor' }
	  },

    Armories = {
      { x = -867.22772216796, y = -1458.2868652344, z = 6.5268049240112 },
    },

    Vehicles = {
      {
        Spawner    = { x = -960.49157714844, y = -1492.9588623046, z = 4.0087790489196 },
        SpawnPoint = { x = -967.86749267578, y = -1486.178100586, z = 5.010293006897 },
        Heading    = 44.47,
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
      { x = -962.51239013672, y = -1505.2902832032, z = 4.0159659385682 }
    },

    BossActions = {
      { x = -881.91589355468, y = -1462.3604736328, z = 6.5268020629882 }
    },

  },

}
