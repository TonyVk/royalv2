Config              = {}
Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 0
Config.Locale       = 'en'

Config.Trucks = {
	"handler"
}

Config.Cloakroom = {
			CloakRoom = {
					Pos   = {x = 1197.1558837891, y = -3253.685546875, z = 5.9951871871948},
					Size  = {x = 3.0, y = 3.0, z = 1.0},
					Color = {r = 204, g = 204, b = 0},
					Type  = 1,
					Id = 1
				}
}

Config.Uniforms = {
	EUP = false,
	uniforma = { 
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 0,
			['torso_1'] = 89,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 36,   ['pants_2'] = 0,
			['shoes'] = 35,
			['helmet_1'] = 5,  ['helmet_2'] = 0,
			['glasses_1'] = 19,  ['glasses_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 0,
			['torso_1'] = 0,   ['torso_2'] = 11,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 68,
			['pants_1'] = 30,   ['pants_2'] = 2,
			['shoes'] = 26,
			['helmet_1'] = 19,  ['helmet_2'] = 0,
			['glasses_1'] = 15,  ['glasses_2'] = 0
		}
	},
	EUPuniforma = { 
		male = {
			ped = 'mp_m_freemode_01',
			props = {
				{ 0, 61, 2 },
				{ 1, 16, 10 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 3, 6 },
				{ 3, 64, 1 },
				{ 10, 1, 1 },
				{ 8, 91, 1 },
				{ 4, 50, 4 },
				{ 6, 52, 4 },
				{ 7, 1, 1 },
				{ 9, 4, 3 },
				{ 5, 49, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 61, 1 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 118, 1 },
				{ 3, 82, 1 },
				{ 10, 1, 1 },
				{ 8, 55, 1 },
				{ 4, 5, 2 },
				{ 6, 27, 1 },
				{ 7, 1, 1 },
				{ 9, 6, 3 },
				{ 5, 49, 1 },
			}
		}
	}
}

Config.Spawnovi = {
	{ 
		Prikolica = {x = 1058.1937255859, y = -3186.3842773438, z = 6.0999102592468, h = 359.32376098633},
		Kontenjer = {x = 1050.2928466797, y = -3187.4399414063, z = 5.9017262458801, h = 359.03329467773},
		Kamion = {x = 1057.6279296875, y = -3172.6674804688, z = 5.9007320404053, h = 87.062911987305}
	},
	{
		Prikolica = {x = 1029.6059570313, y = -3187.8837890625, z = 6.101722240448, h = 0.60524392127991},
		Kontenjer = {x = 1022.005859375, y = -3187.8012695313, z = 5.9010605812073, h = 0.96068859100342},
		Kamion = {x = 1030.1016845703, y = -3172.6567382813, z = 5.9677567481995, h = 90.131416320801}
	},
	{ 
		Prikolica = {x = 1009.6091308594, y = -3185.2561035156, z = 6.1002860069275, h = 359.29776000977},
		Kontenjer = {x = 1001.6154174805, y = -3186.2888183594, z = 5.9008226394653, h = 359.12899780273},
		Kamion = {x = 1009.2541503906, y = -3172.458984375, z = 5.9680428504944, h = 91.093452453613}
	},
	{ 
		Prikolica = {x = 949.03997802734, y = -3185.4575195313, z = 5.9690685272217, h = 0.67891997098923},
		Kontenjer = {x = 941.35803222656, y = -3186.6750488281, z = 5.9008021354675, h = 358.0500793457},
		Kamion = {x = 948.97784423828, y = -3172.8913574219, z = 5.9685888290405, h = 90.293968200684}
	},
	{ 
		Prikolica = {x = 933.02099609375, y = -3186.0908203125, z = 5.9688863754272, h = 0.58739846944809},
		Kontenjer = {x = 925.16217041016, y = -3186.5290527344, z = 5.9008016586304, h = 0.5447758436203},
		Kamion = {x = 933.20892333984, y = -3172.6318359375, z = 5.968213558197, h = 90.064674377441}
	},
	{ 
		Prikolica = {x = 908.63403320313, y = -3185.701171875, z = 5.968400478363, h = 0.81930881738663},
		Kontenjer = {x = 900.77514648438, y = -3186.884765625, z = 5.897566318512, h = 3.153736114502},
		Kamion = {x = 908.51727294922, y = -3172.5593261719, z = 5.9683451652527, h = 90.367736816406}
	}
}

Config.VehicleSpawnPoint = {
	{
		Pos   = {x = 1054.0427246094, y = -3210.7768554688, z = 4.9685968399048},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Prikolica = {x = 1058.1937255859, y = -3186.3842773438, z = 6.0999102592468},
		Type  = -1
	},
	{
		Pos   = {x = 1029.8850097656, y = -3210.9443359375, z = 6.0475077629089},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Prikolica = {x = 1029.6059570313, y = -3187.8837890625, z = 6.101722240448},
		Type  = -1
	},
	{
		Pos   = {x = 1009.5610351563, y = -3211.2102050781, z = 6.093939781189},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Prikolica = {x = 1009.6091308594, y = -3185.2561035156, z = 6.1002860069275},
		Type  = -1
	},
	{
		Pos   = {x = 949.32751464844, y = -3209.7724609375, z = 5.9679970741272},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Prikolica = {x = 949.03997802734, y = -3185.4575195313, z = 5.9690685272217},
		Type  = -1
	},
	{
		Pos   = {x = 933.25305175781, y = -3209.9450683594, z = 5.9678611755371},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Prikolica = {x = 933.02099609375, y = -3186.0908203125, z = 5.9688863754272},
		Type  = -1
	},
	{
		Pos   = {x = 908.74432373047, y = -3210.021484375, z = 5.9680867195129},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Prikolica = {x = 908.63403320313, y = -3185.701171875, z = 5.968400478363},
		Type  = -1
	}
}

Config.Zones = {
	VehicleSpawner = {
				Pos   = {x = 1181.3631591797, y = -3263.0061035156, z = 4.4287132263184},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	},
	
	VehicleDeletePoint = {
				Pos   = {x = 1156.4053955078, y = -3287.73046875, z = 4.801026725769},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 255, g = 0, b = 0},
				Type  = 1
	}
}