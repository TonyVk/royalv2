
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
		Pos = vector3(-825.510, -440.8749, 35.6722),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Centar",
		SpawnPoint = {
			Pos = vector3(-835.510, -401.8749, 30.4722),
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Heading= 300.00,
			Marker = 1		
		},
		DeletePoint = {
			Pos = vector3(-828.774, -428.77, 35.646),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1,
			
		},
		MunicipalPoundPoint = {
			Pos = vector3(45.74942779541, -2559.0095214844, 4.9999952316284),
			Color = {r=25,g=25,b=112},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		SpawnMunicipalPoundPoint = {
			Pos = vector3(45.74942779541, -2559.0095214844, 5.9999952316284),
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
		Pos = vector3(-838.8584228516, -397.13308837891, 30.370678710938 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(-838.8584228516, -397.13308837891, 30.370678710938 ),
			Color = {r=0,g=255,b=0},
			Heading = 300.00,
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
			Pos = vector3(-838.14,-413.14, 35.80 ),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri2 = {	
		Pos = vector3(-841.3184228516, -392.94308837891, 30.35678710938 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(-841.3184228516, -392.94308837891, 30.35678710938 ),
			Color = {r=0,g=255,b=0},
			Heading = 300.00,
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
			Pos = vector3(-859.13, -409.39, 35.80 ),
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri3 = {	
		Pos = vector3(-867.38, -428.34, 35.80 ),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = vector3(-816.3284228516, -420.86308837891, 44.45678710938 ),
			Color = {r=0,g=255,b=0},
			Heading = 300.07,
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
			Pos = vector3(-867.38, -428.34, 35.80 ),
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
