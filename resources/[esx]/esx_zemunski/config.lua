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
      Pos     = { x = -2611.802734375, y = 1693.3072509766, z = 146.32255554199 },
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
		 { name = 'cls2015',  label = 'Mercedes CLS 2015' },
		 { name = '18velar',  label = 'Range Rover Vogue' },
		 { name = 'rmodgt63',	label = 'Mercedes GT63s' }
	  },
    Armories = {
      { x = -2619.2275390625, y = 1714.4197998047, z = 141.37280273438 },
    },
	
	Impound = {
      { x = -2611.5349121094, y = 1685.0986328125, z = 140.86622619629 },
    },
	
    Vehicles = {
      { 
        Spawner    = { x = -2610.6298828125, y = 1676.5515136719, z = 140.86642456055 },
        SpawnPoint = { x = -2604.4438476563, y = 1678.1696777344, z = 140.30039978027 },
        Heading    = 226.78,
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
      { x = -2597.3459472656, y = 1680.1407470703, z = 140.86859130859 }
    },
    BossActions = {
      { x = -2611.802734375, y = 1693.3072509766, z = 145.32255554199 }
    },

  },

}
