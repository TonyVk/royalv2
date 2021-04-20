Config = {}
Config.Locale = 'hr'

Config.DoorList = {
	
	
	{
		textCoords = vector3(355.23, -301.54, 104.5),
		authorizedJobs = { 'gsf' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = '-1989765534',
				objYaw = 125.0,
				objCoords = vector3(355.23, -301.54, 105.0)
			},
		}
	},
	
	-- 
	-- BurgeriSeSutaju Lock
	--
	
	{
		textCoords = vector3(-1195.27, -897.07, 14.2),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'bs_cj_int_door_24',
				objYaw = 125.0,
				objCoords = vector3(-1195.27, -897.07, 14.0)
			},
		}
	},
	
	{
		textCoords = vector3(-1194.13, -899.87, 14.2),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'bs_cj_int_door_24',
				objYaw = 125.0,
				objCoords = vector3(-1194.13, -899.87, 14.0)
			},
		}
	},
	
	{
		textCoords = vector3(-1200.60, -892.01, 14.2),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'bs_cj_int_door_24',
				objYaw = -145.0,
				objCoords = vector3(-1200.60, -892.01, 14.0)
			}
		}
	},
	
	
	-- vanjska vrata
	{
		textCoords = vector3(-1178.65, -891.73, 14.2),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'p_bs_map_door_01_s',
				objYaw = 125.0,
				objCoords = vector3(-1178.65, -891.73, 14.0)
			}
		}
	},
	
	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'mrpd_door_01_l',
				objYaw = -90.0,
				objCoords = vector3(434.20129394531, -981.47717285156, 30.709379196167)
			},

			{
				objName = 'mrpd_door_01_r',
				objYaw = -90.0,
				objCoords = vector3(434.15423583984, -982.47698974609, 30.709373474121)
			}
		}
	},
	
	{
		textCoords = vector3(442.72979736328, -999.16217041016, 30.724523544312),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'mrpd_door_01_l',
				objYaw = 180.0,
				objCoords = vector3(442.25170898438, -999.17926025391, 30.724630355835)
			},

			{
				objName = 'mrpd_door_01_r',
				objYaw = 180.0,
				objCoords = vector3(443.38507080078, -999.19311523438, 30.724224090576)
			}
		}
	},
	
	{
		textCoords = vector3(440.14892578125, -999.24926757812, 30.725166320801),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'mrpd_door_01_l',
				objYaw = 180.0,
				objCoords = vector3(439.54876708984, -999.19927978516, 30.725484848022)
			},

			{
				objName = 'mrpd_door_01_r',
				objYaw = 180.0,
				objCoords = vector3(440.61465454102, -999.19219970703, 30.72513961792)
			}
		}
	},

	-- To locker room & roof
	{
		objName = 'mrpd_door_03',
		objYaw = 180.0,
		objCoords  = vector3(467.49243164062, -992.28735351562, 34.21692276001),
		textCoords = vector3(467.49243164062, -992.28735351562, 34.21692276001),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Rooftop
	{
		objName = 'mrpd_door_03',
		objYaw = 180.0,
		objCoords  = vector3(467.39343261719, -991.611328125, 30.689348220825),
		textCoords = vector3(467.39343261719, -991.611328125, 30.689348220825),
		authorizedJobs = { 'police' },
		locked = true
	},

	--
	-- Mission Row Cells
	--

	-- Main Cells
	{
		objName = 'mrpd_celldoor',
		objYaw = 180.0,
		objCoords  = vector3(461.64849853516, -985.19152832031, 34.187484741211),
		textCoords = vector3(461.64849853516, -985.19152832031, 34.187484741211),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 1
	{
		objName = 'mrpd_celldoor',
		objYaw = 0.0,
		objCoords  = vector3(461.31051635742, -988.54846191406, 34.187419891357),
		textCoords = vector3(461.31051635742, -988.54846191406, 34.187419891357),
		authorizedJobs = { 'police', 'sipa' },
		locked = true
	},

	-- Cell 2
	{
		objName = 'mrpd_celldoor',
		objYaw = 0.0,
		objCoords  = vector3(455.40615844727, -988.642578125, 34.187267303467),
		textCoords = vector3(455.40615844727, -988.642578125, 34.187267303467),
		authorizedJobs = { 'police', 'sipa' },
		locked = true
	},

	-- Cell 3
	{
		objName = 'mrpd_celldoor',
		objYaw = 0.0,
		objCoords  = vector3(449.69046020508, -988.60040283203, 34.187198638916),
		textCoords = vector3(449.69046020508, -988.60040283203, 34.187198638916),
		authorizedJobs = { 'police', 'sipa' },
		locked = true
	},

	{
		objName = 'mrpd_celldoor2',
		objYaw = 180.0,
		objCoords  = vector3(455.59994506836, -985.34173583984, 34.187389373779),
		textCoords = vector3(455.59994506836, -985.34173583984, 34.187389373779),
		authorizedJobs = { 'police', 'sipa' },
		locked = true
	},
	
	{
		objName = 'mrpd_celldoor2',
		objYaw = 180.0,
		objCoords  = vector3(449.73309326172, -985.32025146484, 34.187271118164),
		textCoords = vector3(449.73309326172, -985.32025146484, 34.187271118164),
		authorizedJobs = { 'police', 'sipa' },
		locked = true
	},
	
	{
		objName = 'mrpd_door_03',
		objYaw = 90.0,
		objCoords  = vector3(465.41317749023, -988.57843017578, 25.729692459106),
		textCoords = vector3(465.41317749023, -988.57843017578, 25.729692459106),
		authorizedJobs = { 'police', 'sipa' },
		locked = true
	},
	
	-- Opening Gate
	--{
		--objName = 'hei_prop_station_gate',
		--objYaw = -90.0,
		--objCoords  = vector3(409.1118, -1023.555, 28.36486),
--textCoords = vector3(410.1118, -1023.555, 29.4),
		--authorizedJobs = { 'police' },
		--locked = true,
		--distance = 14,
--size = 2
	--},
	
	-- Outside gates
	
	{
		objName = 'prop_gate_airport_01',
		objYaw = -90.0,
		objCoords  = vector3(410.59741210938, -1021.5045166016, 29.375396728516),
		textCoords = vector3(410.59741210938, -1021.5045166016, 29.375396728516),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 2
	},

	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = { 'police', 'sipa' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 0.0,
				objCoords  = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 180.0,
				objCoords  = vector3(469.9, -1014.4, 26.5)
			}
		}
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police', 'sipa' },
		locked = true,
		distance = 14,
		size = 2
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objName = 'v_ilev_shrfdoor',
		objYaw = 30.0,
		objCoords  = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
		authorizedJobs = { 'police' },
		locked = false
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_shrf2door',
				objYaw = -45.0,
				objCoords  = vector3(-443.1, 6015.6, 31.7),
			},

			{
				objName = 'v_ilev_shrf2door',
				objYaw = 135.0,
				objCoords  = vector3(-443.9, 6016.6, 31.7)
			}
		}
	},

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	--
	-- Addons
	--
	
	{
		objName = 'hei_v_ilev_bk_gate_pris',
		objCoords  = vector3(256.3116, 220.6579, 106.4296),
		textCoords = vector3(0.0, 0.0, -1000.0), 
		authorizedJobs = { 'police' },
		Banka = true,
		locked = true
	},
	{
		objName = 'hei_v_ilev_bk_gate2_pris',
		objCoords  = vector3(261.99899291992, 221.50576782227, 106.68346405029),
		textCoords = vector3(0.0, 0.0, -1000.0), 
		authorizedJobs = { 'police' },
		Banka = true,
		locked = true
	},
	{
		objName = 'v_ilev_bk_safegate',
		objCoords  = vector3(251.8576, 221.0655, 101.8324),
		textCoords = vector3(0.0, 0.0, -1000.0), 
		authorizedJobs = { 'police' },
		Banka = true,
		locked = true
	},
	{
		objName = 'hei_v_ilev_bk_safegate_pris',
		objCoords  = vector3(261.3004, 214.5051, 101.8324),
		textCoords = vector3(0.0, 0.0, -1000.0), 
		authorizedJobs = { 'police' },
		Banka = true,
		locked = true
	},
	{
		objName = 'v_ilev_bk_vaultdoor',
		objCoords  = vector3(254.12199291992, 225.50576782227, 101.87346405029),
		textCoords = vector3(0.0, 0.0, -1000.0), 
		authorizedJobs = { 'police' },
		Banka = true,
		locked = true
	},
	{
		objName = 'v_ilev_cbankvauldoor01',
		objCoords  = vector3(-104.91988372803, 6472.5854492188, 31.626726150513),
		textCoords = vector3(0.0, 0.0, -1000.0), 
		authorizedJobs = { 'police' },
		Banka = true,
		locked = true
	},

	--[[
	-- Entrance Gate (Mission Row mod) https://www.gta5-mods.com/maps/mission-row-pd-ymap-fivem-v1
	{
		objName = 'prop_gate_airport_01',
		objCoords  = vector3(420.1, -1017.3, 28.0),
		textCoords = vector3(420.1, -1021.0, 32.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 2
	}
	--]]
	
	-- SIPA Entrance Door--
	{
		textCoords = vector3(104.7607, -744.642, 47.0000),
		authorizedJobs = { 'sipa' },
		locked = true,
		distance = 5,
		size = 2,
		doors = {
			{
				objName = 'v_ilev_fibl_door02',
				objYaw = 78.5,
				objCoords  = vector3(106.3793, -742.6982, 46.5000)
			},

			{
				objName = 'v_ilev_fibl_door01',
				objYaw = 84.0,
				objCoords  = vector3(105.7607, -746.646, 46.5000)
			}
		}
	},
	-- Racing Doors--
	{
		objName = 'v_ilev_fibl_door1',
		objYaw = 00.0,
		objCoords  = vector3(128.5607, -731.386, 257.1500),
		textCoords = vector3(128.7607, -731.642, 257.0000),
		authorizedJobs = { 'sipa' },
		locked = true,
		distance = 14,
		size = 2
	},
	-- Granica --
	{
		objName = 'prop_sec_barrier_ld_02a',
		objYaw = -35.0,
		objCoords  = vector3(1455.4477539063, 760.55328369141, 77.254493713379),
		textCoords = vector3(1455.4477539063, 760.55328369141, 77.254493713379),
		grId = 1,
		authorizedJobs = { 'police', 'sipa' },
		locked = false,
		distance = 3,
		size = 1
	},
	
	{
		objName = 'prop_sec_barrier_ld_02a',
		objYaw = 145.0,
		objCoords  = vector3(1451.0988769531, 763.52484130859, 77.268585205078),
		textCoords = vector3(1451.0988769531, 763.52484130859, 77.268585205078),
		grId = 2,
		authorizedJobs = { 'police', 'sipa' },
		locked = false,
		distance = 3,
		size = 1
	},
	
	{
		objName = 'prop_sec_barrier_ld_02a',
		objYaw = -40.0,
		objCoords  = vector3(1432.8041992188, 722.60601806641, 78.021430969238),
		textCoords = vector3(1432.8041992188, 722.60601806641, 78.021430969238),
		grId = 3,
		authorizedJobs = { 'police', 'sipa' },
		locked = true,
		distance = 3,
		size = 1
	},
	-- Granica 2 --
	{
		objName = 'prop_sec_barrier_ld_02a',
		objYaw = 68.0,
		objCoords  = vector3(-2811.06640625, 46.21960067749, 14.777311325073),
		textCoords = vector3(-2811.06640625, 46.21960067749, 14.777311325073),
		grId = 4,
		authorizedJobs = { 'police', 'sipa' },
		locked = false,
		distance = 3,
		size = 1
	},
	
	{
		objName = 'prop_sec_barrier_ld_02a',
		objYaw = -112.0,
		objCoords  = vector3(-2806.4826660156, 38.704948425293, 14.850786209106),
		textCoords = vector3(-2806.4826660156, 38.704948425293, 14.850786209106),
		grId = 5,
		authorizedJobs = { 'police', 'sipa' },
		locked = false,
		distance = 3,
		size = 1
	},
	
	{
		textCoords = vector3(-1864.6369628906, 2060.4721679688, 140.97680664062),
		authorizedJobs = { 'lisice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'ball_fridge_mafia_l',
				objYaw = -90.0,
				objCoords = vector3(-1864.6369628906, 2060.4721679688, 140.97680664062)
			},

			{
				objName = 'ball_fridge_mafia_r',
				objYaw = -90.0,
				objCoords = vector3(-1864.6369628906, 2060.4721679688, 140.97680664062)
			}
		}
	},
	
	{
		objName = 'prop_id2_11_gdoor',
		objCoords  = vector3(998.58721923828, -2327.1960449218, 30.509534835816),
		textCoords = vector3(998.58721923828, -2327.1960449218, 30.509534835816),
		authorizedJobs = { 'mechanic' },
		locked = false,
		distance = 12,
		size = 2
	},
	
	{
		objName = 'prop_id2_11_gdoor',
		objCoords  = vector3(1034.3520507812, -2299.716796875, 30.501712799072),
		textCoords = vector3(1034.3520507812, -2299.716796875, 30.501712799072),
		authorizedJobs = { 'mechanic' },
		locked = false,
		distance = 12,
		size = 2
	},
	{
		objName = 'ba_prop_door_club_entrance',
		objYaw = 165.0,
		objCoords  = vector3(354.98229980469, 301.2021484375, 104.03697967529),
		textCoords = vector3(354.98229980469, 301.2021484375, 104.03697967529),
		authorizedJobs = { 'gsf' },
		locked = false,
		distance = 3,
		size = 2
	},
	{
		objName = 'ba_prop_door_club_glam_generic',
		objYaw = -12.0,
		objCoords  = vector3(380.81326293945, 265.97659301758, 91.190040588379),
		textCoords = vector3(380.81326293945, 265.97659301758, 91.190040588379),
		authorizedJobs = { 'gsf' },
		locked = true,
		distance = 3,
		size = 2
	},
	{
		objName = 'ba_prop_door_club_generic_vip',
		objYaw = 75.0,
		objCoords  = vector3(377.64376831055, 268.45965576172, 94.990516662598),
		textCoords = vector3(377.64376831055, 268.45965576172, 94.990516662598),
		authorizedJobs = { 'gsf' },
		locked = true,
		distance = 3,
		size = 2
	},
}