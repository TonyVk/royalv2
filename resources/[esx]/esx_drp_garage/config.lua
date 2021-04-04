
Config = {

	DrawDistance = 100,
	
	Locale = "hr",

	Price = 1500,

	-- This is the multiplier of price to pay when the car is damaged
	-- 100% damaged means 1000 * Multiplier
	-- 50% damaged means 500 * Multiplier
	-- Etc.
	RepairMultiplier = 1, 
	
	BlipInfos = {
		Sprite = 290,
		Color = 38 
	},
	
	BlipPound = {
		Sprite = 67,
		Color = 64 
	}
}

Config.Garages = {

	Garage_Centre = {	
		Pos = vector3(212.76470947266, -887.22009277344, 18.319744110107),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Centar",
		SpawnPoint = {
			Pos = vector3(212.76470947266, -887.22009277344, 17.319744110107),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Heading= 55.50,
			Marker = 1		
		},
		DeletePoint = {
			Pos = vector3(219.13619995117, -902.43194580078, 17.319715499878),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1,
			
		},
		MunicipalPoundPoint = {
			Pos = vector3(-2607.8596191406, 1685.8980712891, 140.86524963379),
			Color = {r=25,g=25,b=112},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		SpawnMunicipalPoundPoint = {
			Pos = vector3(-2604.4438476563, 1678.1696777344, 140.30039978027),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1,
			Heading=226.78
		},
	},
	
	Garage_Paleto = {	
		Pos = vector3(105.359, 6613.586, 31.3973),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Paleto",
		SpawnPoint = {
			Pos = vector3(128.7822, 6622.9965, 30.7828),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = vector3(126.3572, 6608.4150, 30.8565),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	
	Garage_SandyShore = {	
		Pos = vector3(1501.2, 3762.19, 33.0 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Sandy Shore",
		SpawnPoint = {
			Pos = vector3(1497.15, 3761.37, 32.8 ),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = vector3(1504.1, 3765.55, 32.8 ),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	
		Garage_Aeroport = {	
		Pos = vector3(-977.21661376953, -2710.3798828125, 12.853487014771),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Aerodrom",
		SpawnPoint = {
			Pos = vector3(-977.21661376953,-2710.3798828125,12.853487014771 ),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = vector3(-966.88208007813,-2709.9028320313,12.83367729187 ),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_Gabo = {	
		Pos = vector3(-1095.0084228516, 358.60308837891, 68.070678710938 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		Ime = "Gabina garaza",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(-1095.0084228516, 358.60308837891, 67.070678710938 ),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = vector4(238.360962,-1004.80573,-99.99996,90.22185),	
		},
		SpawnVozila = {
			Pos = vector3(234.44923400879, -976.57659912109, -99.999954223633),
		},
		DeletePoint = {
			Pos = vector3(-1100.23, 358.14, 68.00 ),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 0
		}
	},
	Garage_DodatniMarkeri = {	
		Pos = vector3(218.76092529297, -878.7666015625, 18.319732666016 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(218.76092529297, -878.7666015625, 17.319732666016),
			Color = {r=0,g=255,b=0},
			Heading = 55.50,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = vector4(238.360962,-1004.80573,-99.99996,90.22185),	
		},
		SpawnVozila = {
			Pos = vector3(225.93049621582, -894.76141357422, 17.31974029541),
		},
		DeletePoint = {
			Pos = vector3(225.59072875977, -894.65692138672, 17.319715499878),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri2 = {	
		Pos = vector3(220.66430664062, -876.26593017578, 18.319734573364 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(220.66430664062, -876.26593017578, 17.319734573364),
			Color = {r=0,g=255,b=0},
			Heading = 55.50,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = vector4(238.360962,-1004.80573,-99.99996,90.22185),	
		},
		SpawnVozila = {
			Pos = vector3(231.84121704102, -886.31658935547, 17.319738388062),
		},
		DeletePoint = {
			Pos = vector3(231.5115814209, -886.24591064453, 17.319723129272),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri3 = {	
		Pos = vector3(214.74337768555, -884.45135498047, 17.319744110107 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(214.74337768555, -884.45135498047, 17.319744110107),
			Color = {r=0,g=255,b=0},
			Heading = 55.07,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = vector4(238.360962,-1004.80573,-99.99996,90.22185),	
		},
		SpawnVozila = {
			Pos = vector3(234.44923400879, -976.57659912109, -99.999954223633),
		},
		DeletePoint = {
			Pos = vector3(237.7785949707, -877.16766357422, 17.319723129272),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_Marina = {	
		Pos = vector3(-857.86236572266, -1328.017578125, 0.30489677190781),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Brod = true,
		Ime = "Marina",
		SpawnMarker = {
			Pos = vector3(-860.48217773438, -1323.0462646484, 0.6051669120789),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		SpawnPoint = {
			Pos = vector3(-857.86236572266, -1328.017578125, 0.31225422024727),
			Color = {r=0,g=255,b=0},
			Heading = 109.53,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = vector3(-854.32318115234, -1336.2690429688,0.31225422024727),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		Vracanje = vector3(-855.33941650391, -1331.8586425781, 1.5952188968658)
	},
}