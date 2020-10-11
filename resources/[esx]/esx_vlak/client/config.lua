Config = {}
-- Current Train Config
Config.ModelsLoaded = false
Config.inTrain = false -- F while train doesn't have driver
Config.inTrainAsPas = false -- F while train has driver
Config.TrainVeh = 0
Config.Speed = 0
Config.EnterExitDelay = 0
Config.EnterExitDelayMax = 600
--Marker and Locations
Config.MarkerType   = 1
Config.DrawDistance = 100.0
Config.MarkerType   = 1
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor  = {r = 0, g = 255, b = 0}
Config.BlipSprite   = 79

Config.DrawDistance = 100.0
Config.MaxDelivery	= 10
Config.TruckPrice	= 0
Config.Locale       = 'en'

Config.Cloakroom = {
			CloakRoom = {
					Pos   = {x = 714.03289794922, y = -716.51586914063, z = 25.203058242798},
					Size  = {x = 3.0, y = 3.0, z = 1.0},
					Color = {r = 204, g = 204, b = 0},
					Type  = 1,
					Id = 1
				}
}

Config.Zones = {
	VehicleSpawner = {
				Pos   = {x = 684.48742675781, y = -716.92510986328, z = 25.025840759277},
				Size  = {x = 3.0, y = 3.0, z = 1.0},
				Color = {r = 204, g = 204, b = 0},
				Type  = 1
	}
}

--Debug, enable train spawning.
Config.Debug = false

-- Marker/Blip Locations/Spawn locations
Config.TrainLocations = {
	{ ['x'] = 247.965,  ['y'] = -1201.17,  ['z'] = 38.92, ['trainID'] = 24, ['trainX'] = 247.9364, ['trainY'] = -1198.597, ['trainZ'] = 37.4482 }, -- Trolley
	{ ['x'] = 670.2056,  ['y'] = -685.7708,  ['z'] = 25.15311, ['trainID'] = 23, ['trainX'] = 670.2056, ['trainY'] = -685.7708, ['trainZ'] = 25.15311 }, -- FTrain
}

-- Train speeds (https://en.wikipedia.org/wiki/Rail_speed_limits_in_the_United_States)
Config.TrainSpeeds = {
	[1030400667] = { ["MaxSpeed"] = 36, ["Accel"] = 0.05, ["Dccel"] = 0.1, ["Pass"] = false }, -- F Trains
	[868868440] = { ["MaxSpeed"] = 91, ["Accel"] = 0.1, ["Dccel"] = 0.1, ["Pass"] = true }, -- T Trains
}

Config.Stanice = {
	{x = 2639.1247558594, y = 2978.5637207031, z = 41.181541442871}, --nekastanica
	{x = -447.89758300781, y = 5357.607421875, z = 82.614448547363}, --nekastanica2
	{x = -35.799076080322, y = 6231.6958007813, z = 32.269569396973}, --nekastanica3
	{x = 2570.9812011719, y = 2873.3776855469, z = 39.615345001221}, --nekastanica4
	{x = 2610.9306640625, y = 1619.1342773438, z = 28.812614440918}, --nekastanica5
	{x = 669.27301025391, y = -825.544921875, z = 23.984537124634} --vlakkraj
}

-- Utils
function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function findNearestTrain()
	local localPedPos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 120.0, 0.0)
	local veh = getVehicleInDirection(localPedPos, entityWorld)
	
	if veh > 0 and IsEntityAVehicle(veh) and IsThisModelATrain(GetEntityModel(veh)) then
		if Config.Debug then 
			debugLog("Checking ".. GetEntityModel(veh))
			DrawLine(localPedPos, entityWorld, 0,255,0,255)
		end
		return veh
	else
		if Config.Debug then 
			DrawLine(localPedPos, entityWorld, 255,0,0,255)
		end
		return 0
	end
end

function getTrainSpeeds(veh)
	local model = GetEntityModel(veh)
	local ret = {}
	ret.MaxSpeed = 0
	ret.Accel = 0
	ret.Dccel = 0
	
	if Config.TrainSpeeds[model] then
		local tcfg = Config.TrainSpeeds[model]
		ret.MaxSpeed = tcfg.MaxSpeed -- Heavy, but fast.
		ret.Accel = tcfg.Accel
		ret.Dccel = tcfg.Dccel
	end
	return ret
end

function getCanPassenger(veh)
	local model = GetEntityModel(veh)
	local ret = false
	
	if Config.TrainSpeeds[model] ~= nil then
		local tcfg = Config.TrainSpeeds[model]
		ret = tcfg.Pass
	end
	return ret
end

function createTrain(type,x,y,z)
	local train = CreateMissionTrain(type,x,y,z,true)
	SetTrainSpeed(train,0)
	SetTrainCruiseSpeed(train,0)
	SetEntityAsMissionEntity(train, true, false)
	debugLog("createTrain.")
end

function debugLog(msg)
	if Config.Debug then
		Citizen.Trace("[TrainSportation:Debug]: " .. msg)
	end
end

function Log(msg)
	Citizen.Trace("[TrainSportation]: " .. msg)
end