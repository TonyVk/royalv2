Config              = {}
Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 0
Config.Locale       = 'en'

Config.Trucks = {
	"mower"
}

Config.Cloakroom = {
			CloakRoom = {
					Pos   = {x = -1348.412109375, y = 142.57148742676, z = 55.43796157837},
					Size  = {x = 3.0, y = 3.0, z = 1.0},
					Color = {r = 204, g = 204, b = 0},
					Type  = 1,
					Id = 1
				}
}

Config.Zones = {
	VehicleSpawner = {
				Pos   = {x = -1352.2934570312, y = 124.50176239014, z = 55.238651275634},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	},

	VehicleSpawnPoint = {
				Pos   = {x = -1351.6215820312, y = 136.58317565918, z = 55.699272155762},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Type  = -1
	},
	
	VehicleDeletePoint = {
				Pos   = {x = -1343.6362304688, y = 131.48942565918, z = 54.675247192382},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	},
	
	VehicleDeletePoint2 = {
				Pos   = {x = -1399.4075927734, y = 94.852767944336, z = 52.881084442139},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	}
}

Config.Uniforms = {
	EUP = true,
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
				{ 0, 0, 0 },
				{ 1, 0, 0 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 72, 1 },
				{ 3, 65, 1 },
				{ 10, 1, 1 },
				{ 8, 16, 1 },
				{ 4, 54, 1 },
				{ 6, 28, 1 },
				{ 7, 1, 1 },
				{ 9, 1, 1 },
				{ 5, 1, 1 },
			}
		},
		female = {
			ped = 'mp_f_freemode_01',
			props = {
				{ 0, 0, 0 },
				{ 1, 14, 1 },
				{ 2, 0, 0 },
				{ 6, 0, 0 },
			},
			components = {
				{ 1, 1, 1 },
				{ 11, 68, 1 },
				{ 3, 76, 1 },
				{ 10, 1, 1 },
				{ 8, 15, 1 },
				{ 4, 56, 1 },
				{ 6, 27, 1 },
				{ 7, 1, 1 },
				{ 9, 1, 1 },
				{ 5, 1, 1 },
			}
		}
	}
}

Config.Objekti = {
	{x = -1336.6204833984, y = 130.82232666016, z = 54.283576965332}, 
	{x = -1324.103881836, y = 115.27574157714, z = 54.167377471924}, 
	{x = -1319.4246826172, y = 97.489234924316, z = 53.423778533936}, 
	{x = -1304.8073730468, y = 87.645217895508, z = 52.510105133056}, 
	{x = -1287.1822509766, y = 100.08847045898, z = 52.88620376587}, 
	{x = -1276.1564941406, y = 115.06087493896, z = 54.580352783204}, 
	{x = -1261.0874023438, y = 132.91331481934, z = 55.940868377686}, 
	{x = -1237.5656738282, y = 118.4698791504, z = 54.785709381104}, 
	{x = -1226.0162353516, y = 94.592765808106, z = 54.358806610108}, 
	{x = -1237.4927978516, y = 69.403785705566, z = 50.174758911132}, 
	{x = -1254.2172851562, y = 48.475540161132, z = 47.812454223632}, 
	{x = -1269.3270263672, y = 29.308032989502, z = 46.243701934814}, 
	{x = -1289.2399902344, y = 23.951700210572, z = 48.285945892334}, 
	{x = -1241.6400146484, y = 20.061225891114, z = 45.199825286866}, 
	{x = -1194.5032958984, y = -6.3355832099914, z = 44.81364440918}, 
	{x = -1168.7250976562, y = -22.788251876832, z = 43.329811096192}, 
	{x = -1149.7358398438, y = -41.018283843994, z = 42.90950012207}, 
	{x = -1123.8868408204, y = -20.715253829956, z = 46.3662109375}, 
	{x = -1111.8679199218, y = 11.486560821534, z = 47.725761413574}, 
	{x = -1106.6242675782, y = 56.203281402588, z = 50.537822723388}, 
	{x = -1130.4426269532, y = 92.263931274414, z = 54.815578460694}, 
	{x = -1144.4881591796, y = 130.2903289795, z = 58.19034576416}, 
	{x = -1124.1652832032, y = 146.08227539062, z = 59.36003112793}, 
	{x = -1117.3946533204, y = 168.95635986328, z = 60.45259475708}, 
	{x = -1121.6223144532, y = 190.30805969238, z = 61.90784072876} 
}
Config.Objekti2 = {
	{x = -1342.4163818359, y = 124.05695343018, z = 54.748692321777},
	{x = -1342.2075195313, y = 121.57494354248, z = 54.760702514648},
	{x = -1342.1020507813, y = 119.64608001709, z = 54.702730560303},
	{x = -1341.9260253906, y = 116.57598876953, z = 54.727207183838},
	{x = -1341.6997070313, y = 112.77196502686, z = 54.775289154053},
	{x = -1340.3869628906, y = 110.97012329102, z = 54.773254394531},
	{x = -1339.6683349609, y = 112.53863525391, z = 54.789764404297},
	{x = -1339.7641601563, y = 115.44703674316, z = 54.711737060547},
	{x = -1339.8385009766, y = 118.10711669922, z = 54.736212158203},
	{x = -1340.2283935547, y = 120.98516082764, z = 54.736561584473},
	{x = -1340.4645996094, y = 123.90135192871, z = 54.750701141357},
	{x = -1342.6029052734, y = 123.0333480835, z = 54.79368057251},
	{x = -1342.2204589844, y = 120.33592224121, z = 54.720484161377},
	{x = -1342.1243896484, y = 118.06735992432, z = 54.750881195068},
	{x = -1341.9088134766, y = 115.096824646, z = 54.703090667725},
	{x = -1341.7800292969, y = 113.86675262451, z = 54.78932723999},
	{x = -1341.5844726563, y = 111.30113983154, z = 54.758462524414},
	{x = -1339.6402587891, y = 113.88889312744, z = 54.707353973389},
	{x = -1339.7918701172, y = 116.45008087158, z = 54.716047668457},
	{x = -1340.0714111328, y = 119.32345581055, z = 54.77281036377},
	{x = -1340.2884521484, y = 122.31519317627, z = 54.791527557373},
	{x = -1338.3288574219, y = 110.81678009033, z = 54.733061218262},
	{x = -1337.9287109375, y = 112.28453826904, z = 54.752222442627},
	{x = -1337.9458007813, y = 113.48886108398, z = 54.74769821167},
	{x = -1338.0578613281, y = 115.08321380615, z = 54.751375579834},
	{x = -1338.1278076172, y = 116.729637146, z = 54.76791229248},
	{x = -1338.2945556641, y = 117.84379577637, z = 54.795053863525},
	{x = -1338.3956298828, y = 118.98859405518, z = 54.743313598633},
	{x = -1338.5281982422, y = 120.29377746582, z = 54.792588043213},
	{x = -1338.6794433594, y = 121.79180908203, z = 54.749114227295},
	{x = -1338.8671875, y = 123.66437530518, z = 54.719899749756},
	{x = -1339.9340820313, y = 125.07683563232, z = 54.701524353027},
	{x = -1340.0280761719, y = 126.39344787598, z = 54.791491699219},
	{x = -1340.2176513672, y = 127.93090820313, z = 54.776080322266},
	{x = -1340.1782226563, y = 129.40679931641, z = 54.772345733643},
	{x = -1340.2824707031, y = 131.45718383789, z = 54.767642211914},
	{x = -1340.3989257813, y = 132.96032714844, z = 54.724038696289},
	{x = -1340.5250244141, y = 134.3447265625, z = 54.761243438721},
	{x = -1340.6267089844, y = 135.85850524902, z = 54.706130981445},
	{x = -1340.8190917969, y = 137.87255859375, z = 54.737979888916},
	{x = -1340.9508056641, y = 139.6125793457, z = 54.935301971436},
	{x = -1336.2681884766, y = 110.90816497803, z = 54.781870269775},
	{x = -1336.1833496094, y = 112.22068786621, z = 54.788851165771},
	{x = -1336.2781982422, y = 113.4684677124, z = 54.774935150146},
	{x = -1336.4553222656, y = 114.92356872559, z = 54.781771087646},
	{x = -1336.6392822266, y = 116.39248657227, z = 54.733517456055},
	{x = -1336.6447753906, y = 117.62637329102, z = 54.764584350586},
	{x = -1336.7442626953, y = 119.16118621826, z = 54.924864196777},
	{x = -1336.9060058594, y = 120.24474334717, z = 54.967142486572},
	{x = -1337.1307373047, y = 121.85045623779, z = 54.925881195068},
	{x = -1337.1655273438, y = 123.69707489014, z = 54.902423095703},
	{x = -1338.0218505859, y = 125.14430236816, z = 54.998257446289},
	{x = -1338.15625, y = 126.30811309814, z = 54.986805725098},
	{x = -1338.3801269531, y = 127.92498779297, z = 54.969261932373},
	{x = -1338.5087890625, y = 129.42083740234, z = 54.957054901123},
	{x = -1338.6246337891, y = 131.08476257324, z = 54.991116333008},
	{x = -1338.7504882813, y = 132.81143188477, z = 54.967772674561},
	{x = -1338.9306640625, y = 134.18965148926, z = 55.234789276123},
	{x = -1339.0690917969, y = 135.87838745117, z = 55.281717681885},
	{x = -1339.1770019531, y = 137.29081726074, z = 55.217030334473},
	{x = -1339.3298339844, y = 139.37452697754, z = 55.258652496338}
}
Config.Objekti3 = {
	{x = 1054.8657226563, y = -402.08120727539, z = 65.388729858398},
	{x = 1053.9881591797, y = -402.86151123047, z = 65.373463439941},
	{x = 1053.4102783203, y = -403.35061645508, z = 65.359295654297},
	{x = 1052.6072998047, y = -404.02514648438, z = 65.339512634277},
	{x = 1051.8181152344, y = -404.70657348633, z = 65.296826171875},
	{x = 1051.1313476563, y = -405.29800415039, z = 65.25581817627},
	{x = 1050.4967041016, y = -405.84506225586, z = 65.217869567871},
	{x = 1049.5462646484, y = -406.66516113281, z = 65.160786437988},
	{x = 1048.8040771484, y = -407.26922607422, z = 65.116955566406},
	{x = 1048.189453125, y = -407.78286743164, z = 65.081120300293},
	{x = 1047.6850585938, y = -408.19039916992, z = 65.051091003418},
	{x = 1047.0943603516, y = -408.65887451172, z = 65.022106933594},
	{x = 1039.4614257813, y = -414.9739074707, z = 64.56895904541},
	{x = 1038.6854248047, y = -415.56857299805, z = 64.521977233887},
	{x = 1037.92578125, y = -416.16265869141, z = 64.477787780762},
	{x = 1037.1447753906, y = -416.7682800293, z = 64.432621765137},
	{x = 1036.3775634766, y = -417.36511230469, z = 64.388363647461},
	{x = 1035.53515625, y = -418.03518676758, z = 64.339024353027},
	{x = 1034.8349609375, y = -418.57772827148, z = 64.298680114746},
	{x = 1034.1547851563, y = -419.10015869141, z = 64.259213256836},
	{x = 1033.4544677734, y = -419.638671875, z = 64.218739318848},
	{x = 1032.6965332031, y = -420.23522949219, z = 64.174664306641},
	{x = 1032.0916748047, y = -420.70635986328, z = 64.13935546875},
	{x = 1031.4991455078, y = -421.17416381836, z = 64.103718566895},
	{x = 1031.0275878906, y = -421.56423950195, z = 64.058430480957},
	{x = 1013.8204345703, y = -435.09292602539, z = 63.088818359375},
	{x = 1012.6307983398, y = -435.90472412109, z = 63.015301513672},
	{x = 1011.7562255859, y = -436.53530883789, z = 62.966366577148},
	{x = 1010.8024902344, y = -437.23419189453, z = 62.912281799316},
	{x = 1009.8929443359, y = -437.90728759766, z = 62.853123474121},
	{x = 1009.2620849609, y = -438.38088989258, z = 62.813153076172},
	{x = 1000.5746459961, y = -445.0592956543, z = 62.289589691162},
	{x = 999.46508789063, y = -445.82461547852, z = 62.265034484863},
	{x = 998.4365234375, y = -446.56393432617, z = 62.206295776367},
	{x = 997.46856689453, y = -447.25012207031, z = 62.148098754883},
	{x = 996.31506347656, y = -448.0827331543, z = 62.079590606689},
	{x = 995.21423339844, y = -448.89517211914, z = 62.018326568604},
	{x = 994.27709960938, y = -449.58465576172, z = 61.966500091553},
	{x = 993.33813476563, y = -450.27554321289, z = 61.915749359131},
	{x = 992.41809082031, y = -450.93789672852, z = 61.866436767578},
	{x = 991.58959960938, y = -451.52618408203, z = 61.821976470947},
	{x = 990.48492431641, y = -452.30975341797, z = 61.76068572998},
	{x = 989.21282958984, y = -453.2331237793, z = 61.689209747314},
	{x = 988.28137207031, y = -453.89379882813, z = 61.637070465088},
	{x = 987.50329589844, y = -454.44964599609, z = 61.593483734131},
	{x = 986.64483642578, y = -455.06201171875, z = 61.54515914917},
	{x = 985.73175048828, y = -455.71490478516, z = 61.494160461426},
	{x = 985.03106689453, y = -456.20712280273, z = 61.454842376709},
	{x = 984.21130371094, y = -456.80657958984, z = 61.395806121826},
	{x = 970.73870849609, y = -466.48364257813, z = 60.588112640381},
	{x = 969.6337890625, y = -467.19348144531, z = 60.522507476807},
	{x = 968.54943847656, y = -467.88320922852, z = 60.468395996094},
	{x = 967.61779785156, y = -468.4794921875, z = 60.417244720459},
	{x = 966.27893066406, y = -469.3801574707, z = 60.343304443359},
	{x = 965.24591064453, y = -470.06350708008, z = 60.286598968506},
	{x = 964.09387207031, y = -470.84335327148, z = 60.223393249512},
	{x = 963.14294433594, y = -471.48764038086, z = 60.171265411377},
	{x = 962.05609130859, y = -472.23443603516, z = 60.110367584229},
	{x = 961.07391357422, y = -472.9118347168, z = 60.051571655273},
	{x = 959.89385986328, y = -473.68539428711, z = 59.981304931641},
	{x = 958.92663574219, y = -474.34310913086, z = 59.922978210449},
	{x = 957.92663574219, y = -475.00527954102, z = 59.863323974609},
	{x = 956.90515136719, y = -475.67568969727, z = 59.79866104126},
	{x = 956.12579345703, y = -476.17935180664, z = 59.744946289062},
	{x = 955.373046875, y = -476.66314697266, z = 59.6928565979},
	{x = 954.69989013672, y = -477.07931518555, z = 59.646042633057},
	{x = 945.56976318359, y = -482.74160766602, z = 59.037983703613},
	{x = 944.53607177734, y = -483.32843017578, z = 58.993920135498},
	{x = 943.52294921875, y = -483.8796081543, z = 58.929814147949},
	{x = 942.64105224609, y = -484.35626220703, z = 58.87487487793},
	{x = 941.72650146484, y = -484.85278320313, z = 58.826908874512},
	{x = 941.11022949219, y = -485.19970703125, z = 58.794472503662},
	{x = 932.38598632813, y = -489.87478637695, z = 58.226685333252},
	{x = 931.27435302734, y = -489.90899658203, z = 58.179055023193},
	{x = 930.24591064453, y = -491.02249145508, z = 58.108780670166},
	{x = 929.02648925781, y = -491.57971191406, z = 58.036843109131},
	{x = 927.95574951172, y = -492.09661865234, z = 57.973286437988},
	{x = 926.89263916016, y = -492.6015625, z = 57.910488891602},
	{x = 925.51641845703, y = -493.25143432617, z = 57.833222198486},
	{x = 924.10217285156, y = -493.89605712891, z = 57.75287322998},
	{x = 923.14288330078, y = -494.31182861328, z = 57.713803100586},
	{x = 922.15814208984, y = -494.72964477539, z = 57.605305480957},
	{x = 913.00640869141, y = -498.84005737305, z = 57.010968017578},
	{x = 912.08703613281, y = -499.15963745117, z = 56.960606384277},
	{x = 911.04895019531, y = -499.55392456055, z = 56.896271514893},
	{x = 910.00634765625, y = -499.97180175781, z = 56.833611297607},
	{x = 908.76025390625, y = -500.4665222168, z = 56.757763671875},
	{x = 907.61706542969, y = -500.89151000977, z = 56.6896484375},
	{x = 906.43292236328, y = -501.35626220703, z = 56.618397521973},
	{x = 905.53930664063, y = -501.70907592773, z = 56.564865875244},
	{x = 904.69677734375, y = -502.15386962891, z = 56.516411590576},
	{x = 897.99981689453, y = -504.69888305664, z = 56.11644821167},
	{x = 896.80023193359, y = -505.10140991211, z = 56.036938476562},
	{x = 895.57702636719, y = -505.49691772461, z = 55.967823791504},
	{x = 894.41168212891, y = -505.87426757813, z = 55.905628967285},
	{x = 893.09106445313, y = -506.31024169922, z = 55.846062469482},
	{x = 891.79333496094, y = -506.732421875, z = 55.794899749756},
	{x = 890.46453857422, y = -507.21722412109, z = 55.761627960205},
	{x = 889.00543212891, y = -507.76800537109, z = 55.719036865234},
	{x = 888.00469970703, y = -508.12100219727, z = 55.696488189697},
	{x = 886.69689941406, y = -508.62460327148, z = 55.678845214844},
	{x = 885.88494873047, y = -509.01458740234, z = 55.667805480957},
	{x = 884.91418457031, y = -509.48965454102, z = 55.657421875},
	{x = 884.40228271484, y = -509.75750732422, z = 55.678490447998},
	{x = 883.83258056641, y = -510.07125854492, z = 55.69953994751},
	{x = 875.81805419922, y = -515.27807617188, z = 55.661236572266},
	{x = 874.55627441406, y = -516.29278564453, z = 55.673092651367},
	{x = 873.15759277344, y = -517.58624267578, z = 55.671578216553},
	{x = 871.91296386719, y = -518.86029052734, z = 55.671646881104},
	{x = 870.88116455078, y = -520.00921630859, z = 55.665222930908},
	{x = 869.76531982422, y = -521.39404296875, z = 55.667767333984},
	{x = 868.92749023438, y = -522.57049560547, z = 55.670147705078},
	{x = 868.19000244141, y = -523.59222412109, z = 55.68020324707},
	{x = 863.8046875, y = -531.84289550781, z = 55.641449737549},
	{x = 863.45733642578, y = -532.75457763672, z = 55.66510848999},
	{x = 862.94561767578, y = -533.97601318359, z = 55.665802764893},
	{x = 862.48846435547, y = -535.34362792969, z = 55.672161865234},
	{x = 862.17858886719, y = -536.52142333984, z = 55.672478485107},
	{x = 862.01013183594, y = -537.19110107422, z = 55.674160766602},
	{x = 861.76519775391, y = -538.15582275391, z = 55.66678314209},
	{x = 860.87030029297, y = -547.49938964844, z = 55.663414764404},
	{x = 860.95129394531, y = -548.96075439453, z = 55.662422943115},
	{x = 861.01904296875, y = -550.06622314453, z = 55.66206817627},
	{x = 861.12524414063, y = -551.41064453125, z = 55.661694335937},
	{x = 861.31286621094, y = -553.15454101563, z = 55.66145401001},
	{x = 861.48040771484, y = -554.66558837891, z = 55.661377716064},
	{x = 861.79663085938, y = -556.24932861328, z = 55.664032745361},
	{x = 862.09906005859, y = -557.52685546875, z = 55.668343353271},
	{x = 862.35906982422, y = -558.53253173828, z = 55.639553833008},
	{x = 866.83728027344, y = -568.58996582031, z = 55.653569030762},
	{x = 867.57788085938, y = -569.73883056641, z = 55.665642547607},
	{x = 868.40496826172, y = -570.99450683594, z = 55.666180419922},
	{x = 869.22991943359, y = -572.22204589844, z = 55.667938995361},
	{x = 870.46911621094, y = -573.78082275391, z = 55.664608764648},
	{x = 871.41949462891, y = -574.86791992188, z = 55.663502502441},
	{x = 872.28656005859, y = -575.85186767578, z = 55.655316162109},
	{x = 873.43927001953, y = -577.02368164063, z = 55.651039886475},
	{x = 874.6572265625, y = -578.27105712891, z = 55.639054107666},
	{x = 889.2490234375, y = -588.00872802734, z = 55.696678924561},
	{x = 890.43273925781, y = -588.77380371094, z = 55.707333374023},
	{x = 891.82391357422, y = -589.56475830078, z = 55.693306732178},
	{x = 892.96801757813, y = -590.259765625, z = 55.691223907471},
	{x = 893.9560546875, y = -590.90985107422, z = 55.693005371094},
	{x = 894.78656005859, y = -591.42321777344, z = 55.697361755371},
	{x = 895.27624511719, y = -591.70825195313, z = 55.70357208252},
	{x = 898.91760253906, y = -593.91711425781, z = 55.709599304199},
	{x = 899.87286376953, y = -594.60626220703, z = 55.705590057373},
	{x = 900.88201904297, y = -595.32897949219, z = 55.707901763916},
	{x = 901.98425292969, y = -596.12542724609, z = 55.711903381348},
	{x = 903.07336425781, y = -596.87200927734, z = 55.715561676025},
	{x = 903.68804931641, y = -597.30187988281, z = 55.721722412109},
	{x = 904.33673095703, y = -597.70300292969, z = 55.728592681885},
	{x = 910.30859375, y = -601.83624267578, z = 55.743202972412},
	{x = 911.28546142578, y = -602.48931884766, z = 55.738999176025},
	{x = 912.39978027344, y = -603.26531982422, z = 55.742043304443},
	{x = 913.42626953125, y = -604.02581787109, z = 55.744530487061},
	{x = 914.30279541016, y = -604.68841552734, z = 55.746624755859},
	{x = 915.20758056641, y = -605.32452392578, z = 55.755642700195},
	{x = 918.70709228516, y = -607.79669189453, z = 55.76390914917},
	{x = 919.70874023438, y = -608.59075927734, z = 55.761616516113},
	{x = 920.88745117188, y = -609.53973388672, z = 55.764881896973},
	{x = 921.96423339844, y = -610.3759765625, z = 55.767979431152},
	{x = 923.02703857422, y = -611.18420410156, z = 55.762070465088},
	{x = 937.82257080078, y = -623.24230957031, z = 55.772164154053},
	{x = 938.69287109375, y = -623.97088623047, z = 55.791832733154},
	{x = 939.24957275391, y = -624.51519775391, z = 55.789112854004},
	{x = 942.81695556641, y = -627.87121582031, z = 55.791691589355},
	{x = 943.57885742188, y = -628.69616699219, z = 55.789688873291},
	{x = 944.55596923828, y = -629.75372314453, z = 55.789376068115},
	{x = 945.71099853516, y = -630.98107910156, z = 55.789196777344},
	{x = 946.63439941406, y = -631.9814453125, z = 55.788933563232},
	{x = 947.58898925781, y = -633.00598144531, z = 55.788933563232},
	{x = 948.60925292969, y = -634.1318359375, z = 55.789082336426},
	{x = 949.70208740234, y = -635.36865234375, z = 55.78893737793},
	{x = 950.91516113281, y = -636.74243164063, z = 55.788658905029},
	{x = 951.96197509766, y = -637.94763183594, z = 55.788945007324},
	{x = 952.71844482422, y = -638.88623046875, z = 55.792282867432},
	{x = 953.49340820313, y = -639.88781738281, z = 55.797074127197},
	{x = 954.10900878906, y = -640.73382568359, z = 55.799618530273},
	{x = 954.78979492188, y = -641.56005859375, z = 55.787724304199},
	{x = 955.16290283203, y = -642.04321289063, z = 55.771374511719},
	{x = 955.66680908203, y = -642.66888427734, z = 55.760430145264},
	{x = 961.76141357422, y = -651.02471923828, z = 55.757469940186},
	{x = 962.24926757813, y = -651.77667236328, z = 55.77331237793},
	{x = 962.7236328125, y = -652.50799560547, z = 55.785454559326},
	{x = 963.04180908203, y = -653.00335693359, z = 55.778393554687},
	{x = 963.3671875, y = -653.53802490234, z = 55.766190338135},
	{x = 968.99591064453, y = -662.419921875, z = 55.780297088623},
	{x = 969.50256347656, y = -663.47857666016, z = 55.789963531494},
	{x = 970.10479736328, y = -664.65600585938, z = 55.789894866943},
	{x = 970.66198730469, y = -665.77728271484, z = 55.789574432373},
	{x = 971.05560302734, y = -666.56042480469, z = 55.792427825928},
	{x = 971.52117919922, y = -667.37713623047, z = 55.798001098633},
	{x = 974.27947998047, y = -672.88732910156, z = 55.79683380127},
	{x = 974.68084716797, y = -673.85614013672, z = 55.787972259521},
	{x = 975.07806396484, y = -674.89929199219, z = 55.783879089355},
	{x = 975.36584472656, y = -675.58905029297, z = 55.775601196289},
	{x = 975.65179443359, y = -676.27691650391, z = 55.759064483643},
	{x = 980.18347167969, y = -687.29473876953, z = 55.774338531494},
	{x = 980.6923828125, y = -688.55017089844, z = 55.790642547607},
	{x = 981.15087890625, y = -689.62854003906, z = 55.790688323975},
	{x = 981.60974121094, y = -690.69012451172, z = 55.790604400635},
	{x = 982.14306640625, y = -691.8818359375, z = 55.790718841553},
	{x = 982.515625, y = -692.64276123047, z = 55.790856170654},
	{x = 982.94012451172, y = -693.43933105469, z = 55.797982025146},
	{x = 984.26989746094, y = -695.90173339844, z = 55.799011993408},
	{x = 984.71551513672, y = -696.73767089844, z = 55.793591308594},
	{x = 985.14581298828, y = -697.45489501953, z = 55.791081237793},
	{x = 986.00579833984, y = -698.76623535156, z = 55.801861572266},
	{x = 986.38580322266, y = -699.43634033203, z = 55.793656158447},
	{x = 993.05096435547, y = -708.61578369141, z = 55.781853485107},
	{x = 994.07067871094, y = -709.89996337891, z = 55.79080657959},
	{x = 995.0830078125, y = -711.10723876953, z = 55.790783691406},
	{x = 996.00335693359, y = -712.22491455078, z = 55.790692138672},
	{x = 997.20361328125, y = -713.63354492188, z = 55.790955352783},
	{x = 998.37072753906, y = -715.03247070313, z = 55.790882873535},
	{x = 999.34558105469, y = -716.20684814453, z = 55.790798950195},
	{x = 1000.5375976563, y = -717.63598632813, z = 55.79080657959},
	{x = 1001.4225463867, y = -718.69293212891, z = 55.794323730469},
	{x = 1002.3502807617, y = -719.80432128906, z = 55.800644683838},
	{x = 1003.3737182617, y = -720.99548339844, z = 55.807827758789},
	{x = 1004.1837158203, y = -721.96478271484, z = 55.813427734375},
	{x = 1004.9591674805, y = -722.95001220703, z = 55.825814056396},
	{x = 1005.5547485352, y = -723.69757080078, z = 55.834187316895},
	{x = 1013.68359375, y = -733.42895507813, z = 56.039986419678},
	{x = 1014.7796630859, y = -734.73083496094, z = 56.07649307251},
	{x = 1015.9637451172, y = -736.09686279297, z = 56.091431427002},
	{x = 1017.0185546875, y = -737.36907958984, z = 56.097359466553},
	{x = 1018.5467529297, y = -739.20422363281, z = 56.101376342773},
	{x = 1019.5703125, y = -740.35528564453, z = 56.104500579834},
	{x = 1020.5611572266, y = -741.53997802734, z = 56.106392669678},
	{x = 1021.4563598633, y = -742.62286376953, z = 56.107064056396},
	{x = 1022.3303833008, y = -743.64007568359, z = 56.107964324951},
	{x = 1023.2411499023, y = -744.76782226563, z = 56.108540344238},
	{x = 1024.3240966797, y = -745.98046875, z = 56.110165405273},
	{x = 1025.2862548828, y = -747.00469970703, z = 56.106030273437},
	{x = 1026.224609375, y = -748.02233886719, z = 56.108353424072},
	{x = 1026.7662353516, y = -748.5908203125, z = 56.106995391846},
	{x = 1027.5131835938, y = -749.32275390625, z = 56.101055908203},
	{x = 1035.5587158203, y = -755.94903564453, z = 56.065113830566},
	{x = 1036.4581298828, y = -756.51934814453, z = 56.072029876709},
	{x = 1037.2642822266, y = -757.05303955078, z = 56.096504974365},
	{x = 1038.1682128906, y = -757.65838623047, z = 56.075608062744},
	{x = 1047.4222412109, y = -762.32885742188, z = 56.081524658203},
	{x = 1048.7974853516, y = -762.88775634766, z = 56.111267852783},
	{x = 1050.1140136719, y = -763.38568115234, z = 56.111130523682},
	{x = 1051.5974121094, y = -763.92456054688, z = 56.111187744141},
	{x = 1053.4953613281, y = -764.55493164063, z = 56.110955047607},
	{x = 1055.0518798828, y = -764.97302246094, z = 56.110821533203},
	{x = 1056.5642089844, y = -765.37109375, z = 56.11071472168},
	{x = 1058.23046875, y = -765.77923583984, z = 56.110829162598},
	{x = 1059.9112548828, y = -766.12164306641, z = 56.111279296875},
	{x = 1061.5423583984, y = -766.38024902344, z = 56.110970306396},
	{x = 1062.7120361328, y = -766.56829833984, z = 56.110543060303},
	{x = 1063.7043457031, y = -766.71459960938, z = 56.104172515869},
	{x = 1073.82421875, y = -767.29870605469, z = 56.08275680542},
	{x = 1074.6251220703, y = -767.28735351563, z = 56.117115783691},
	{x = 1075.4650878906, y = -767.24438476563, z = 56.120526123047},
	{x = 1083.6350097656, y = -767.16076660156, z = 56.116341400146},
	{x = 1085.1059570313, y = -767.21838378906, z = 56.111992645264},
	{x = 1086.7458496094, y = -767.28723144531, z = 56.111256408691},
	{x = 1088.2012939453, y = -767.33282470703, z = 56.11078338623},
	{x = 1089.8979492188, y = -767.33020019531, z = 56.110657501221},
	{x = 1091.3137207031, y = -767.33514404297, z = 56.110615539551},
	{x = 1092.6629638672, y = -767.33953857422, z = 56.110546875},
	{x = 1094.0715332031, y = -767.35211181641, z = 56.11042098999},
	{x = 1095.4649658203, y = -767.33795166016, z = 56.110642242432},
	{x = 1096.8225097656, y = -767.32861328125, z = 56.110844421387},
	{x = 1098.0670166016, y = -767.33648681641, z = 56.110791015625},
	{x = 1098.9683837891, y = -767.35455322266, z = 56.110043334961},
	{x = 1099.6490478516, y = -767.37860107422, z = 56.105290222168},
	{x = 1100.7266845703, y = -767.87115478516, z = 56.095703887939}
}
