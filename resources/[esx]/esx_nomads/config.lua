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

Config.NomadsStations = {

  Nomads = {

    Blip = {
      Pos     = { x = -113.4178161621, y = 985.80725097656, z = 235.75410461426 },
      Sprite  = 378,
      Display = 4,
      Scale   = 1.2,
      Colour  = 1,
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
		  { name = 'bmwm8',  label = 'BMW M8 Coupe' },
		  { name = '458spc',      label = 'Ferrari 458 Speciale' },
		  { name = '18performante',  label = 'Lamborghini Huracan Performante' },
		  { name = 'guardian',   label = 'Guardian 4x4' },
		  { name = 'm5e60',   label = 'BMW M5 E60' },
		  { name = 'dubsta',     label = 'Mercedes G Class' },
		  { name = 'rmodgt63',     label = 'Mercedes AMG GT63S' },
		  { name = 'panamera17turbo',     label = 'Porsche Panamera Turbo' },
		  { name = 'nh2r',     label = 'Kawasaki Ninja' }
	},

    Armories = {
      { x = -795.97662353516, y = 326.52429199218, z = 216.03814697266 },
    },
	
	Ulazi = {
      { x = -113.4178161621, y = 985.80725097656, z = 234.75410461426, h = 272.51358032227 },
    },
	
	Izlazi = {
      { x = -786.58288574218, y = 315.88427734375, z = 216.63844299316, h = 87.563606262207 },
    },


    Vehicles = {
      {
        Spawner    = { x = -124.39297485352, y = 1009.9166259766, z = 234.73204040528 },
        SpawnPoint = { x = -124.26942443848, y = 999.41394042968, z = 234.35809326172 },
        Heading    = 203.43,
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
      { x = -131.19413757324, y = 1007.2371826172, z = 234.73204040528 }
    },

    BossActions = {
      { x = -790.96472167968, y = 328.3903503418, z = 216.03829956054 }
    },

  },

}
