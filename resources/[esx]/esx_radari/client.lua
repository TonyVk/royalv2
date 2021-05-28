--===============================================--===============================================
--= stationary radars based on  https://github.com/DreanorGTA5Mods/StationaryRadar           =
--===============================================--===============================================



ESX              = nil
local Provjerio = 0
local NemojGa = 0
local blip = {}

local radares = {
	{x = 195.9838256836, y = -810.2593383789, z = 31.09549331665, speed = 90}, --radar
	{x = 150.31101989746, y = -830.34600830078, z = 31.078777313232, speed = 90}, --radar
	{x = 160.54740905762, y = -1007.191833496, z = 29.489770889282, speed = 90}, --radar
	{x = 29.794961929322, y = -955.51831054688, z = 29.305561065674, speed = 90}, --radar4
	{x = 22.170276641846, y = -981.05200195312, z = 29.581214904786, speed = 90}, --radar5
	{x = 69.122604370118, y = -718.18627929688, z = 31.676187515258, speed = 90}, --radar6
	{x = 46.349380493164, y = -684.25103759766, z = 31.673376083374, speed = 90}, --radar7
	{x = 183.74586486816, y = -600.83935546875, z = 29.698072433472, speed = 90}, --radar8
	{x = 306.24508666992, y = -756.78704833984, z = 29.311225891114, speed = 90}, --radar9
	{x = 333.1153869629, y = -773.42266845704, z = 29.271980285644, speed = 90}, --radar10
	{x = 333.00790405274, y = -1064.7749023438, z = 29.495393753052, speed = 90}, --radar11
	{x = 412.7332458496, y = -907.52404785156, z = 29.418668746948, speed = 90}, --radar11
	{x = -194.7784729004, y = -529.15142822266, z = 34.709350585938, speed = 90}, --radar12
	{x = -158.92039489746, y = -329.41329956054, z = 36.340282440186, speed = 90}, --radar13
	{x = -262.86367797852, y = -255.92910766602, z = 32.978511810302, speed = 90}, --radar14
	{x = -299.71563720704, y = -261.16061401368, z = 32.504863739014, speed = 90}, --radar15
	{x = -397.4736328125, y = -202.42932128906, z = 36.383823394776, speed = 90}, --radar16
	{x = -424.24633789062, y = -249.26350402832, z = 36.277732849122, speed = 90}, --radar17
	{x = -741.63665771484, y = -322.25357055664, z = 36.29295349121, speed = 90}, --radar18
	{x = -745.37188720704, y = -355.4553527832, z = 35.51554107666, speed = 90}, --radar19
	{x = -869.30480957032, y = -631.40106201172, z = 28.33178138733, speed = 90}, --radar20
	{x = -280.21325683594, y = -1103.5213623046, z = 23.37995147705, speed = 90}, --radar21
	{x = -229.20755004882, y = -1050.482055664, z = 27.606670379638, speed = 90}, --radar22
	{x = -104.4923400879, y = -1098.995727539, z = 25.931991577148, speed = 90}, --radar23
	{x = -57.034118652344, y = -1059.0698242188, z = 27.71999168396, speed = 90}, --radar24
	{x = 62.933811187744, y = -1200.191040039, z = 29.499782562256, speed = 90}, --radar25
	{x = 49.523963928222, y = -1518.6568603516, z = 29.491428375244, speed = 90}, --radar26
	{x = 147.38648986816, y = -1753.165649414, z = 29.241062164306, speed = 90}, --radar27
	{x = 282.17636108398, y = 148.2763671875, z = 104.26134490966, speed = 90}, --radar28
	{x = 315.95993041992, y = 168.11584472656, z = 103.78887176514, speed = 90}, --radar29
	{x = -136.9801940918, y = 254.41632080078, z = 95.667991638184, speed = 90},	--radar30
	{x = 938.46, y = 205.90, z = 77.20, speed = 120}, --autocesta radar iz grada
	{x = 922.49, y = 220.01, z = 78.14, speed = 120}, --autocesta radar prema gradu
	{x = 436.88, y = -520.30, z = 28.76, speed = 90}, -- izlaz na autocestu iz grada
	{x = 449.24, y = -527.45, z = 28.41, speed = 120}, -- izlaz u grad sa autoceste
	{x = -294.29, y = -841.65, z = 31.07, speed = 90},
	{x = -281.98, y = -873.32, z = 31.07, speed = 90},
	{x = -526.45, y = -739.35, z = 32.12, speed = 90},
	{x = -724.11, y = -827.04, z = 22.53, speed = 90},
	{x = -727.14, y = -843.40, z = 22.39, speed = 90},
	{x = -825.51, y = -1015.17, z = 12.82, speed = 90},
	{x = -1150.59, y = -647.11, z = 10.73, speed = 120},
	{x = -1135.89, y = -665.33, z = 10.82, speed = 120},
	{x = 279.70, y = -523.41, z = 33.35, speed = 120},
	{x = 291.07, y = -492.88, z = 33.53, speed = 120},
	{x = 817.67, y = -855.58, z = 43.04, speed = 90},
	{x = 819.22, y = -845.40, z = 43.04, speed = 90},
	{x = 1199.28, y = -759.27, z = 57.30, speed = 90},
	{x = 246.44, y = -220.89, z = 68.81, speed = 90},
	{x = 244.07, y = -233.73, z = 53.50, speed = 90},
	{x = 31.61, y = -286.22, z = 47.23, speed = 90},
	{x = 32.82, y = -273.05, z = 47.11, speed = 90},
	{x = -230.32, y = 21.37, z = 54.81, speed = 90},
	{x = -246.75, y = 27.39, z = 55.56, speed = 90},
	{x = -710.32, y = -20.73, z = 37.36, speed = 90},
	{x = -711.75, y = -32.82, z = 37.34, speed = 90},
	{x = -1386.67, y = -382.25, z = 36.17, speed = 90},
	{x = -1378.59, y = -399.12, z = 36.16, speed = 90},
	{x = -2467.20, y = -210.73, z = 16.95, speed = 120},
	{x = -2474.72, y = -224.79, z = 16.95, speed = 120},
	{x = -3103.18, y = 1167.82, z = 19.84, speed = 120},
	{x = -3112.90, y = 1168.36, z = 19.84, speed = 120},
	{x = -2660.15, y = 2583.75, z = 16.15, speed = 120},
	{x = -2672.73, y = 2587.01, z = 16.15, speed = 120},
	{x = -2578.28, y = 3227.28, z = 13.15, speed = 120},
	{x = -2595.45, y = 3239.87, z = 13.02, speed = 120}
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	local br = 1
	for k,v in pairs(radares) do
		blip[br] = AddBlipForCoord(radares[k].x, radares[k].y, radares[k].z)
		SetBlipSprite(blip[br], 135)
		SetBlipColour(blip[br], 13)
		SetBlipScale(blip[br], 0.5)
		SetBlipAlpha(blip[br], 255)
		SetBlipDisplay(blip[br], 9)
		SetBlipAsShortRange(blip[br], true)
		br = br+1
	end
	ProvjeriPosao()
end)

function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('radarce:NemojGa')
AddEventHandler('radarce:NemojGa', function(br)
    NemojGa = br
end)

Citizen.CreateThread(function()
	local br = 1
	for k,v in pairs(radares) do
		blip[br] = AddBlipForCoord(radares[k].x, radares[k].y, radares[k].z)
		SetBlipSprite(blip[br], 135)
		SetBlipColour(blip[br], 13)
		SetBlipScale(blip[br], 0.5)
		SetBlipAlpha(blip[br], 255)
		SetBlipDisplay(blip[br], 5)
		SetBlipAsShortRange(blip[br], true)
		br = br+1
	end
	while ESX == nil do
		Wait(100)
	end
	while ESX.PlayerData.job == nil do
		Citizen.Wait(100)
	end
	local Waitara = 500
    while true do
        Wait(Waitara)
		if IsPedInAnyVehicle(PlayerPedId(), false) and ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'ambulance' and ESX.PlayerData.job.name ~= 'sipa' and ESX.PlayerData.job.name ~= 'vatrogasac' then
			local Pronaso = 0
			Waitara = 0
			for k,v in pairs(radares) do
				local player = GetPlayerPed(-1)
				local x,y,z = table.unpack(GetEntityCoords(player,true))
				if Vdist2(radares[k].x, radares[k].y, radares[k].z, x, y, z) < 60 then
					Pronaso = 1
					if Provjerio == 0 and NemojGa == 0 then
						checkSpeed(radares[k].speed)
						Provjerio = 1
						Wait(1000)
						Provjerio = 0
					end
				end
			end
			if Pronaso == 0 then
				Waitara = 500
			end
		else
			Waitara = 1000
		end
    end
end)

function checkSpeed(mspeed)
    local pP = GetPlayerPed(-1)
    local speed = GetEntitySpeed(pP)
    local vehicle = GetVehiclePedIsIn(pP, false)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local plate = GetVehicleNumberPlateText(vehicle)
    local maxspeed = mspeed
    local mphspeed = math.ceil(GetEntitySpeed(vehicle) * 3.6)
	local fineamount = nil
	local finelevel = nil
	local truespeed = mphspeed
    if mphspeed > maxspeed and driver == pP then
        Citizen.Wait(250)
        TriggerServerEvent('kaznicaaa', mphspeed)
		if truespeed >= maxspeed and truespeed <= maxspeed+10 then
			fineamount = Config.Fine
			finelevel = '10km/h iznad ogranicenja'
		end
		if truespeed >= maxspeed+10 and truespeed <= maxspeed+20 then
			fineamount = Config.Fine2
			finelevel = '20km/h iznad ogranicenja'
		end
		if truespeed >= maxspeed+20 and truespeed <= maxspeed+30 then
			fineamount = Config.Fine3
			finelevel = '30km/h iznad ogranicenja'
		end
		if truespeed >= maxspeed+30 and truespeed <= 500 then
			fineamount = Config.Fine4
			finelevel = '40km/h iznad ogranicenja'
		end
        exports.pNotify:SetQueueMax("left", 1)
        exports.pNotify:SendNotification({
            text = "<h2><center>Radar</center></h2>" .. "</br>Dobili ste kaznu za prebrzu voznju!</br>Tablica: " .. plate .. "</br>Iznos kazne: $" .. fineamount .. "</br>Prekrsaj: " .. finelevel .. "</br>Ogranicenje: " .. maxspeed .. "</br>Tvoja brzina: " ..mphspeed,
            type = "error",
            timeout = 9500,
            layout = "centerLeft",
            queue = "left"
        })
    end
end

