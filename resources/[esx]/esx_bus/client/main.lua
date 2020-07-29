--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- ORIGINAL SCRIPT BY Marcio FOR CFX-ESX
-- Script serveur No Brain 
-- www.nobrain.org
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ESX = nil
local Pedovi = {}
local Spawno = false
local Broj = 0
local Posao = 0
local PlayerData              = nil
local Prikazo = 0
local Blip

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ProvjeriPosao();
end)
--------------------------------------------------------------------------------
-- NE RIEN MODIFIER
--------------------------------------------------------------------------------
local isInService = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}

local plaquevehicule = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blipara				  = {}
--------------------------------------------------------------------------------
function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
end

-- MENUS
function MenuCloakRoom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			elements = {
				{label = _U('job_wear'), value = 'job_wear'},
				{label = _U('citizen_wear'), value = 'citizen_wear'}
			}
		},
		function(data, menu)
			if data.current.value == 'citizen_wear' then
				isInService = false
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	    			TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
			if data.current.value == 'job_wear' then
				isInService = true
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    			if skin.sex == 0 then
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end
				end)
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function MenuVehicleSpawner()
	local elements = {}

	for i=1, #Config.Trucks, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Trucks[i])), value = Config.Trucks[i]})
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "bus" then
			ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 185.61895751954, function(vehicle)
				platenum = math.random(10000, 99999)
				SetVehicleNumberPlateText(vehicle, "WAL"..platenum)             
				plaquevehicule = "WAL"..platenum			
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   
			end)
			PokreniPosao()
		end

			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function PokreniPosao()
		for i=1, #Config.Ped, 1 do
			local model = RequestModel(Config.Ped[i].ped)
			while not HasModelLoaded(Config.Ped[i].ped) do
				Wait(1)
			end
			Pedovi[i] = CreatePed(5, model, Config.Ped[i].x, Config.Ped[i].y, Config.Ped[i].z , 260, false, true)
			SetModelAsNoLongerNeeded(model)
		end
		Broj = #Config.Ped
		Posao = 1
		ESX.ShowNotification("Idite do checkpointa kako bih ste nastavili sa poslom!")
end

function IsATruck()
	local isATruck = false
	local playerPed = GetPlayerPed(-1)
	for i=1, #Config.Trucks, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(playerPed), Config.Trucks[i]) then
			isATruck = true
			break
		end
	end
	return isATruck
end

function IsJobBus()
	if PlayerData ~= nil then
		local kosac = false
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'bus' then
			kosac = true
		end
		return kosac
	end
end

AddEventHandler('esx_bus:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end
	
	if Posao == 1 and zone == Posao then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		ESX.ShowNotification("Pricekajte dok se putnici ukrcaju!")
		for i=1, Broj, 1 do
			TaskEnterVehicle(Pedovi[i], vehicle, 5000, i, 1.5, 1, 0)
			FreezeEntityPosition(vehicle, true)
			Wait(5000)
		end
		Posao = Posao+1
		FreezeEntityPosition(vehicle, false)
		ESX.ShowNotification("Mozete nastaviti do iduce lokacije!")
		Prikazo = 0
	end
	
	if Posao > 1 and zone == Posao and Posao ~= 11 then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local peda = Posao
		ESX.ShowNotification("Pricekajte dok se putnik iskrca!")
		FreezeEntityPosition(vehicle, true)
		TaskLeaveVehicle(Pedovi[Posao-1], vehicle, 1)
		Wait(5000)
		Posao = Posao+1
		FreezeEntityPosition(vehicle, false)
		ESX.ShowNotification("Mozete nastaviti do iduce lokacije!")
		Prikazo = 0
		RemovePedElegantly(Pedovi[peda-1]) 
		Pedovi[peda-1] = nil
		TriggerServerEvent("esx_autobus:platiTuljanu")
	end
	
	if Posao == 11 and zone == Posao then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local peda = Posao
		ESX.ShowNotification("Pricekajte dok se putnik iskrca!")
		FreezeEntityPosition(vehicle, true)
		TaskLeaveVehicle(Pedovi[Posao-1], vehicle, 1)
		Wait(5000)
		Posao = Posao+1
		FreezeEntityPosition(vehicle, false)
		ESX.ShowNotification("Mozete nastaviti do iduce lokacije!")
		Prikazo = 0
		TriggerServerEvent("esx_autobus:platiTuljanu")
		RemovePedElegantly(Pedovi[peda-1]) 
		Pedovi[peda-1] = nil
		for k,v in pairs(Config.Zones) do
			if k == "VehicleDeletePoint" then
				--SetNewWaypoint(v.Pos.x, v.Pos.y)
				if DoesBlipExist(Blip) then
					RemoveBlip(Blip)
				end
				Blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
				SetBlipSprite(Blip, 1)
				SetBlipColour (Blip, 5)
				SetBlipAlpha(Blip, 255)
				SetBlipRoute(Blip,  true) -- waypoint to blip
			end
		end
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobBus() then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobBus() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

function ZavrsiPosao()
	for i=1, #Config.Ped, 1 do
		if Pedovi[i] ~= nil then
			RemovePedElegantly(Pedovi[i])
			Pedovi[i] = nil
		end
	end
	Broj = 0
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	if vehicle ~= nil and tablica == plaquevehicule then
		ESX.Game.DeleteVehicle(vehicle)
	end
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end
	Spawno = false
end

AddEventHandler('esx_bus:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) and IsJobBus() then

                if CurrentAction == 'Obrisi' then
					ZavrsiPosao()
                end
                CurrentAction = nil
            end
		end
    end
end)

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		if IsJobBus() then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if Posao >= 1 then
				local br = 1
				for k,v in pairs(Config.Stanice) do
					if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 3.0) and br == Posao then
						isInMarker  = true
						currentZone = Posao
					end
					br = br+1
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_bus:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_bus:hasExitedMarker', lastZone)
			end

		end

		local coords = GetEntityCoords(GetPlayerPed(-1))
		local br = 1
		if Posao >= 1 then
			for k,v in pairs(Config.Stanice) do
				if isInService and (IsJobBus() and GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) and br == Posao then
					DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
					if Prikazo == 0 then
						--SetNewWaypoint(v.x, v.y)
						if DoesBlipExist(Blip) then
							RemoveBlip(Blip)
						end
						Blip = AddBlipForCoord(v.x, v.y, v.z)
						SetBlipSprite(Blip, 1)
						SetBlipColour (Blip, 5)
						SetBlipAlpha(Blip, 255)
						SetBlipRoute(Blip,  true) -- waypoint to blip
						Prikazo = 1
					end
				end
				if isInService and IsJobBus() and br == Posao then
					if Prikazo == 0 then
						--SetNewWaypoint(v.x, v.y)
						if DoesBlipExist(Blip) then
							RemoveBlip(Blip)
						end
						Blip = AddBlipForCoord(v.x, v.y, v.z)
						SetBlipSprite(Blip, 1)
						SetBlipColour (Blip, 5)
						SetBlipAlpha(Blip, 255)
						SetBlipRoute(Blip,  true) -- waypoint to blip
						Prikazo = 1
					end
				end
				br = br+1
			end
		end
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobBus() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobBus() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
		
	end
end)

-------------------------------------------------
-- Fonctions
-------------------------------------------------
-- Fonction selection nouvelle mission livraison
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)