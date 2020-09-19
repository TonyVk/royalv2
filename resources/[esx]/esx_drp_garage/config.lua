
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
		Pos = {x=-825.510, y= -440.8749, z= 35.6722},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Centar",
		SpawnPoint = {
			Pos = {x=-835.510, y= -401.8749, z= 30.4722},
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Heading= 300.00,
			Marker = 1		
		},
		DeletePoint = {
			Pos = {x=-828.774, y=-428.77, z=35.646},
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1,
			
		},
		MunicipalPoundPoint = {
			Pos = {x=-1981.15, y=-501.200, z=11.201},
			Color = {r=25,g=25,b=112},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x = -1978.8090820313, y = -494.64910888672, z = 11.177969932556},
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1,
			Heading=321.71
		},
	},
	
	Garage_Paleto = {	
		Pos = {x=105.359, y=6613.586, z=31.3973},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Paleto",
		SpawnPoint = {
			Pos = {x=128.7822, y= 6622.9965, z= 30.7828},
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = {x=126.3572, y=6608.4150, z=30.8565},
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	
	Garage_SandyShore = {	
		Pos = {x = 1501.2,y = 3762.19,z = 33.0 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Sandy Shore",
		SpawnPoint = {
			Pos = {x = 1497.15,y = 3761.37,z = 32.8 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = {x = 1504.1,y = 3765.55,z = 32.8 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	
		Garage_Aeroport = {	
		Pos = {x = -977.21661376953,y = -2710.3798828125,z = 12.853487014771 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Aerodrom",
		SpawnPoint = {
			Pos = {x = -977.21661376953,y = -2710.3798828125,z = 12.853487014771 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = {x = -966.88208007813,y = -2709.9028320313,z = 12.83367729187 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_Gabo = {	
		Pos = {x = -1095.0084228516, y = 358.60308837891, z = 68.070678710938 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		Ime = "Gabina garaza",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = {x = -1095.0084228516, y = 358.60308837891, z = 67.070678710938 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = {238.360962,-1004.80573,-99.99996,90.22185},	
		},
		SpawnVozila = {
			Pos = {234.44923400879, -976.57659912109, -99.999954223633},
		},
		DeletePoint = {
			Pos = {x = -1100.23, y = 358.14, z = 68.00 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 0
		}
	},
	Garage_DodatniMarkeri = {	
		Pos = {x = -838.8584228516, y = -397.13308837891, z = 30.370678710938 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = {x = -838.8584228516, y = -397.13308837891, z = 30.370678710938 },
			Color = {r=0,g=255,b=0},
			Heading = 300.00,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = {238.360962,-1004.80573,-99.99996,90.22185},	
		},
		SpawnVozila = {
			Pos = {234.44923400879, -976.57659912109, -99.999954223633},
		},
		DeletePoint = {
			Pos = {x = -838.14, y = -413.14, z = 35.80 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri2 = {	
		Pos = {x = -841.3184228516, y = -392.94308837891, z = 30.35678710938 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = {x = -841.3184228516, y = -392.94308837891, z = 30.35678710938 },
			Color = {r=0,g=255,b=0},
			Heading = 300.00,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = {238.360962,-1004.80573,-99.99996,90.22185},	
		},
		SpawnVozila = {
			Pos = {234.44923400879, -976.57659912109, -99.999954223633},
		},
		DeletePoint = {
			Pos = {x = -859.13, y = -409.39, z = 35.80 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri3 = {	
		Pos = {x = -867.38, y = -428.34, z = 35.80 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = {x = -816.3284228516, y = -420.86308837891, z = 44.45678710938 },
			Color = {r=0,g=255,b=0},
			Heading = 300.07,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		outMarker = {
			Pos = {238.360962,-1004.80573,-99.99996,90.22185},	
		},
		SpawnVozila = {
			Pos = {234.44923400879, -976.57659912109, -99.999954223633},
		},
		DeletePoint = {
			Pos = {x = -867.38, y = -428.34, z = 35.80 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_Marina = {	
		Pos = {x=-857.86236572266, y = -1328.017578125, z = 0.30489677190781},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Brod = true,
		Ime = "Marina",
		SpawnMarker = {
			Pos = {x=-860.48217773438, y = -1323.0462646484, z = 0.6051669120789},
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		SpawnPoint = {
			Pos = {x=-857.86236572266, y = -1328.017578125, z = 0.31225422024727},
			Color = {r=0,g=255,b=0},
			Heading = 109.53,
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		DeletePoint = {
			Pos = {x=-854.32318115234, y = -1336.2690429688, z = 0.31225422024727},
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		Vracanje = vector3(-855.33941650391, -1331.8586425781, 1.5952188968658)
	},
}
