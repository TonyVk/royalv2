
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
		Pos = {x=215.800, y=-810.057, z=29.727},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 1,
		PrikaziBlip = 1,
		Ime = "Garaza Centar",
		SpawnPoint = {
			Pos = {x=239.700, y= -772.1149, z= 29.5722},
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Heading=157.84,
			Marker = 1		
		},
		DeletePoint = {
			Pos = {x=236.424, y=-739.377, z=29.646},
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1,
			
		},
		MunicipalPoundPoint = {
			Pos = {x=482.896, y=-1316.557, z=28.301},
			Color = {r=25,g=25,b=112},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x=490.942, y=-1313.067, z=27.964},
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1,
			Heading=299.42
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
			Pos = {x = 245.23, y = -743.14, z = 31.90 },
			Color = {r=0,g=255,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 0
		}
	},
	Garage_DodatniMarkeri = {	
		Pos = {x = 245.23, y = -743.14, z = 31.90 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = {x = 251.5884228516, y = -760.33308837891, z = 33.570678710938 },
			Color = {r=0,g=255,b=0},
			Heading = 345.00,
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
			Pos = {x = 245.23, y = -742.14, z = 29.70 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri2 = {	
		Pos = {x = 245.23, y = -743.14, z = 31.90 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = {x = 242.6184228516, y = -779.94308837891, z = 29.55678710938 },
			Color = {r=0,g=255,b=0},
			Heading = 160.07,
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
			Pos = {x = 252.23, y = -744.44, z = 29.70 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
	Garage_DodatniMarkeri3 = {	
		Pos = {x = 245.23, y = -743.14, z = 31.90 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 1,
		Ime = "DodatniMarkeri2",
		PrikaziBlip = 0,
		SpawnPoint = {
			Pos = {x = 232.0084228516, y = -775.86308837891, z = 29.55678710938 },
			Color = {r=0,g=255,b=0},
			Heading = 160.07,
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
			Pos = {x = 258.83, y = -746.44, z = 29.70 },
			Color = {r=255,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 1
		}
	},
}
