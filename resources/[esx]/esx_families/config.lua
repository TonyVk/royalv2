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

Config.GroveStations = {

  Grove = {

    Blip = {
      Pos     = { x = -18.316884994507, y = -1438.61328125, z = 31.101543426514 },
      Sprite  = 378,
      Display = 4,
      Scale   = 1.2,
      Colour  = 25,
    },

    AuthorizedWeapons = {
{ name = 'WEAPON_FLAREGUN',         price = 50000 },
      { name = 'WEAPON_APPISTOL',         price = 120000 },
	  { name = 'WEAPON_ASSAULTRIFLE',     price = 500000 },
      { name = 'WEAPON_SWITCHBLADE',      price = 5000 },
	  { name = 'WEAPON_REVOLVER',         price = 200000 },
	  { name = 'WEAPON_POOLCUE',          price = 100 },
	  { name = 'WEAPON_MICROSMG',        price = 300000 }, -- WEAPON_PISTOL50
	  { name = 'WEAPON_PISTOL50',        price = 150000 }
    },

	  AuthorizedVehicles = {
		  { name = 'tornado',  label = 'Tornado' },
		  { name = 'manana',      label = 'Manana' },
		  { name = 'buccaneer',   label = 'Buccaneer' },
		  { name = 'x6m',   	  label = 'BMW X6M' },
		  { name = 'dubsta',   	  label = 'Mercedes G klasa' },
		  { name = 'nh2r',   	  label = 'Kawasaki Ninja' }
	  },

    Armories = {
      { x = -17.134414672852, y = -1430.4561767578, z = 30.101528167725 },
    },

    Vehicles = {
      {
        Spawner    = { x = -25.224924087524, y = -1434.8931884766, z = 29.653142929077 },
        SpawnPoint = { x = -24.449729919434, y = -1441.3275146484, z = 29.653142929077 },
        Heading    = 180.0,
      }
    },
	
	Helicopters = {
      {
        Spawner    = { x = -12.789277076721, y = -1428.5339355469, z = 34.15209197998 },
        SpawnPoint = { x = -12.203351974487, y = -1436.1190185547, z = 34.15209197998 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = -26.673856735229, y = -1427.6628417969, z = 29.672258377075 },
      { x = -24.101741790771, y = -1427.7016601563, z = 29.656564712524 },
    },

    BossActions = {
      { x = -9.7409744262695, y = -1434.5415039063, z = 30.101552963257 }
    },

  },

}
