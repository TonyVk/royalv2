Config = {}
Config.Locale = 'hr'

Config.Price = 250

Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor  = {r = 102, g = 102, b = 204}
Config.MarkerType   = 1

Config.Zones = {}

Config.Shops = {
	vector3(72.254,    -1399.102, 28.376),
	vector3(-703.776,  -152.258,  36.415),
	vector3(-167.863,  -298.969,  38.733),
	vector3(428.694,   -800.106,  28.491),
	vector3(-829.413,  -1073.710, 10.328),
	vector3(-1447.797, -242.461,  48.820),
	vector3(11.632,    6514.224,  30.877),
	vector3(123.646,   -219.440,  53.557),
	vector3(1696.291,  4829.312,  41.063),
	vector3(618.093,   2759.629,  41.088),
	vector3(1190.550,  2713.441,  37.222),
	vector3(-1193.429, -772.262,  16.324),
	vector3(-3172.496, 1048.133,  19.863),
	vector3(-1108.441, 2708.923,  18.107),
	vector3(1102.823,  198.725,   -50.440),
	vector3(199.869, -872.952, 29.713)
}

for i=1, #Config.Shops, 1 do
	Config.Zones['Shop_' .. i] = {
		Pos   = Config.Shops[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end
