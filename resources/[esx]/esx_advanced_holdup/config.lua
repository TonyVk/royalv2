Config									= {}
Config.Locale						= 'hr'
Config.DrawDistance			= 25.0

Config.PercentCurrentMoney = 100 -- % of store current money to transfert to bank
Config.MaxRandomMultiplier = 1	-- multiplier (musn't go over 100% of PercentCurrentMoney)
-- For example : if 25% : multiplieur max = 4 (4*25=100)
-- partOfCurrentMoney = CurrentMoney * Config.PercentCurrentMoney / 100
-- randomMoneyToBank 	= math.random(partOfCurrentMoney, partOfCurrentMoney * Config.MaxRandomMultiplier)

Config.AddMoneyToStoresTimeOut	= 10 -- minutes
Config.AddMoneyToBanksTimeOut		= 30 -- minutes

Config.PhoneHackDifficulty = 7
Config.PhoneHackTime = 150

--[[
---------- TEMPLATES ----------

-- STORES
["My Little Store"] = {
	Pos				= { x = 28.288, y = -1339.537, z = 28.497 },
	Size  		= { x = 1.5, y = 1.5, z = 1.0 },
	Color 		= { r = 220, g = 110, b = 0 },
	Type  		= 1,
	AreaSize 	= 15, -- maximum area size the player can walk in without canceling the robbery
	CurrentMoney			= 1000, -- store starting money
	MaxMoney 					= 25000, -- store maximum money
	MoneyRegeneration	= math.random(1000,2300), -- store money generation each Config.AddMoneyToStoresTimeOut
	BankToDeliver 		= "My Little Bank", -- bank where the store money will go each Config.AddMoneyToBanksTimeOut
	Robbed						= 0, -- DO NOT CHANGE : current timer before new robbery allowed for this store
	TimeToRob					= 10, -- time to take the store money
	TimeBeforeNewRob 	= 100, -- time reference before new robbery allowed
	PoliceRequired		= 1 -- number of cops required to rob this store
},

-- BANKS (must be related to store's BankToDeliver)
["My Little Bank"] = {
	Pos				= { x = -706.193, y = -910.005, z = 18.216 },
	Size  		= { x = 1.5, y = 1.5, z = 1.0 },
	Color 		= { r = 220, g = 110, b = 0 },
	Type  		= 1,
	AreaSize 	= 15, -- maximum area size the player can walk in without canceling the robbery
	CurrentMoney			= 0, -- bank starting money
	MaxMoney 					= 80000,	-- bank maximum money
	Robbed						= 0, -- DO NOT CHANGE : current timer before new robbery allowed for this bank
	TimeToRob					= 10, -- time to take the bank money
	TimeBeforeNewRob 	= 100, -- time reference before new robbery allowed
	PoliceRequired		= 1 -- number of cops required to rob this bank
},

-------------------------------
]]--

Config.Zones = {

	-- STORES
	["24/7 Innocence Boulevard"] = {
		Pos				= { x = 28.288, y = -1339.537, z = 28.497 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9700),
		BankToDeliver 		= "Fleeca Bank Vespucci Boulevard",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 400,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	["LTD Gasoline Grove Street"] = {
		Pos				= { x = -43.057, y = -1748.811, z = 28.421 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Fleeca Bank Vespucci Boulevard",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 420,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["24/7 Supermarket 1"] = {
		Pos				= { x = 378.04071044922, y = 332.98928833008, z = 102.56636810303 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Fleeca Bank Vespucci Boulevard",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 400,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["LTD Gasoline 2"] = {
		Pos				= { x = 1159.8839111328, y = -314.0383605957, z = 68.205055236816 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Fleeca Bank 2",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 420,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["LTD Gasoline 3"] = {
		Pos				= { x = -1828.8621826172, y = 798.96643066406, z = 137.18365478516 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Fleeca Bank 3",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 420,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["Robs Liquor"] = {
		Pos				= { x = -1479.1412353516, y = -375.18435668945, z = 38.16332244873 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Fleeca Bank 2",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 420,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["Robs Liquor 2"] = {
		Pos				= { x = -1220.1519775391, y = -915.74090576172, z = 10.326163291931 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Fleeca Bank 2",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 420,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["LTD Gasoline 4"] = {
		Pos				= { x = -709.47406005859, y = -904.24829101563, z = 18.215591430664 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Blaine County Bank",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 420,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["Robs Liquor 3"] = {
		Pos				= { x = -2959.4538574219, y = 387.62646484375, z = 13.043151855469 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Fleeca Bank 3",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 420,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["24/7 Supermarket 2"] = {
		Pos				= { x = -3047.4658203125, y = 585.71850585938, z = 6.9089293479919 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Fleeca Bank 3",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 400,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["24/7 Supermarket 3"] = {
		Pos				= { x = -3249.6752929688, y = 1004.4720458984, z = 11.830711364746 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Blaine County Bank",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 400,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	["24/7 Supermarket 4"] = {
		Pos				= { x = 2549.5622558594, y = 384.86895751953, z = 107.62292480469 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney			= 10000,
		MaxMoney 					= 60000,
		MoneyRegeneration	= math.random(5000,9900),
		BankToDeliver 		= "Blaine County Bank",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 400,
		TimeBeforeNewRob 	= 3600,
		PoliceRequired		= 3,
		Tip = 1
	},
	
	--zlatara
	["Zlatara"] = {
		Pos				= { x = -623.04925537109, y = -229.50370788574, z = 38.057029724121 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		AreaSize 	= 15,
		Type  		= 1,
		CurrentMoney		= 20000,
		MaxMoney 			= 150000,
		MoneyRegeneration	= math.random(3000,6000),
		BankToDeliver 		= "Fleeca Bank 2",
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 440,
		TimeBeforeNewRob 	= 7200,
		PoliceRequired		= 5,
		Tip = 2
	},

	-- BANKS
	["Fleeca Bank Vespucci Boulevard"] = {
		Pos				= { x = 148.46, y = -1050.51, z = 28.34 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		Type  		= 1,
		AreaSize 	= 15,
		CurrentMoney			= 120000,
		MaxMoney 					= 450000,
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 480,
		TimeBeforeNewRob 	= 7200,
		PoliceRequired		= 7,
		Tip = 2,
		Hack = vector3(146.83, -1046.05, 29.36),
		["Bank_Vault"] = {
            ["model"] = -63539571,
            ["x"] = 148.025,
            ["y"] = -1044.364,
            ["z"] = 29.50693,
            ["hStart"] = 249.846,
            ["hEnd"] = -183.599
        }
	},
	["Fleeca Bank 2"] = {
		Pos				= { x = -1206.4625244141, y = -338.42425537109, z = 36.759304046631 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		Type  		= 1,
		AreaSize 	= 15,
		CurrentMoney			= 120000,
		MaxMoney 					= 450000,
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 480,
		TimeBeforeNewRob 	= 7200,
		PoliceRequired		= 7,
		Tip = 2,
		Hack = vector3(-1210.90, -336.67, 37.78),
		["Bank_Vault"] = {
            ["model"] = -63539571,
            ["x"] = -1211.261,
            ["y"] = -334.5596,
            ["z"] = 37.91989,
            ["hStart"] = 296.53,
            ["hEnd"] = -150.599
        }
	},
	["Fleeca Bank 3"] = {
		Pos				= { x = -2952.7961425781, y = 484.49993896484, z = 14.67539024353 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		Type  		= 1,
		AreaSize 	= 15,
		CurrentMoney			= 120000,
		MaxMoney 					= 450000,
		Robbed						= 0, -- DO NOT CHANGE
		TimeToRob					= 480,
		TimeBeforeNewRob 	= 7200,
		PoliceRequired		= 7,
		Tip = 2,
		Hack = vector3(-2956.47, 481.52, 15.69),
		["Bank_Vault"] = {
            ["model"] = -63539571,
            ["x"] = -2958.539,
            ["y"] = 482.2706,
            ["z"] = 15.835,
            ["hStart"] = 0.0,
            ["hEnd"] = -79.5
        }
	},
	["Blaine County Bank"] = {
		Pos			= { x = -103.59, y = 6477.89, z = 30.62 },
		Size  		= { x = 1.5, y = 1.5, z = 1.0 },
		Color 		= { r = 220, g = 110, b = 0 },
		Type  		= 1,
		AreaSize 	= 15,
		CurrentMoney			= 120000,
		MaxMoney 					= 450000,
		Robbed						= 7,
		TimeToRob					= 480,
		TimeBeforeNewRob 	= 7200,
		PoliceRequired		= 7,
		Tip = 2,
		Hack = vector3(-102.81394195557, 6471.6577148438, 31.62670135498),
		["Bank_Vault"] = {
            ["model"] = GetHashKey("v_ilev_cbankvauldoor01"),
            ["x"] = -104.91988372803,
            ["y"] = 6472.5854492188,
            ["z"] = 31.626726150513,
            ["hStart"] = 45.0,
            ["hEnd"] = 140.0
        }
	},
}

