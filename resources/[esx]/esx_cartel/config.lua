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

Config.CartelStations = {

  Cartel = {

    Blip = {
      Pos     = { x = 1395.4532470704, y = 1152.8605957032, z = 113.35688018798 },
      Sprite  = 378,
      Display = 4,
      Scale   = 1.2,
      Colour  = 81,
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
		  { name = 'r820',  label = 'Audi R8 2020' },
		  { name = 'rmodgt63',  label = 'Mercedes Benz AMG gt63s' },
		  { name = 'rrst',      label = 'Range Rover Vogue' },
		  { name = 'wraith',   	 label = 'Rolls-Royce Wraith' },
		  { name = 'guardian',   label = 'Guardian 4x4' },
		  { name = '911turbos',   label = 'Porsche 911 Turbo S' },
		  { name = 'nh2r',   label = 'Kawasaki Ninja' },
		  { name = 'gle63c',   label = 'Mercedes Benz GLE' }
	  },
    Armories = {
      { x = 1394.6055908203, y = 1149.6101074219, z = 113.33361816406 },
    },
	
	Ulazi = {
      { x = 1410.7829589844, y = 1147.4383544922, z = 113.33406829834, h = 272.51358032227 },
    },
	
	Izlazi = {
      { x = 1408.1248779297, y = 1147.287109375, z = 113.33361816406, h = 87.563606262207 },
    },
	
    Vehicles = {
      { 
        Spawner    = { x = 1401.8325195312, y = 1114.1320800782, z = 113.83769989014   },
        SpawnPoint = { x = 1394.1110839844, y = 1116.7958984375, z = 113.8376235962 },
        Heading    = 81.73,
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
      { x = 1408.4262695312, y = 1118.5495605468, z = 113.83769989014 }
    },
    BossActions = {
      { x = 1400.0563964844, y = 1131.9931640625, z = 113.33358764648 }
    },

  },

}
