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

Config.Markeri = {
	{x = -39.806713104248, y = -1745.1953125, z = 28.601583480835}, --dostavapica1
	{x = 143.32846069336, y = -1303.0866699219, z = 28.422067642212}, --dostavapica2
	{x = 1157.2739257813, y = -331.84103393555, z = 68.280609130859}, --dostavapica3
	{x = -715.37548828125, y = -920.79321289063, z = 18.449592590332}, --dostavapica4
	{x = 1136.5935058594, y = -974.05975341797, z = 46.032112121582}, --dostavapica5
	{x = -1230.2580566406, y = -896.75286865234, z = 11.575876235962} --dostavapica6 
}

Config.ShelbyStations = {

  Shelby = {

    Blip = {
      Pos     = { x = -1500.4376220703, y = 103.34625244141, z = 55.650211334229 },
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
		  { name = 'cls2015',  label = 'Mercedes CLS 2015' },
		  { name = 'guardian', label = 'Guardian 4x4' },
	  },
    Armories = {
      { x = -1505.6791992188, y = 110.83092498779, z = 47.047618865967 },
    },
	
	Posao = {
      { x = 556.86828613281, y = -2716.5651855469, z = 6.1122403144836 },
    },
	
    Vehicles = {
      { 
        Spawner    = { x = -1541.0744628906, y = 92.109931945801, z = 56.952049255371 },
        SpawnPoint = { x = -1531.4735107422, y = 83.44214630127, z = 56.16077041626 },
        Heading    = 315.96,
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
      { x = -1524.7529296875, y = 82.465606689453, z = 55.551036834717 }
    },
    BossActions = {
      { x = -1515.5166015625, y = 115.58491516113, z = 54.248188018799 }
    },

  },

}
