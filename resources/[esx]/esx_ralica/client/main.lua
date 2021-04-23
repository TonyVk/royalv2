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
local Objekti = {}
local Blipara				  = {}
local Radis = false
local Odradio = 1

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ProvjeriPosao()
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
		if data.current.value == "biff" then
			ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 53.884044647217, function(vehicle)
				platenum = math.random(10000, 99999)
				SetVehicleNumberPlateText(vehicle, "WAL"..platenum)             
				plaquevehicule = "WAL"..platenum			
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   
			end)
			PokreniPosao()
			Radis = true
		end

			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function PokreniPosao()
		for i=1, #Config.Objekti, 1 do
			ESX.Game.SpawnLocalObject('prop_snow_bush_02_a', {
					x = Config.Objekti[i].x,
					y = Config.Objekti[i].y,
					z = Config.Objekti[i].z-1.6
			}, function(obj)
			--PlaceObjectOnGroundProperly(obj)
			Objekti[i] = obj
			FreezeEntityPosition(Objekti[i], true)
			end)
			Blipara[i] = AddBlipForCoord(Config.Objekti[i].x,  Config.Objekti[i].y,  Config.Objekti[i].z)
			SetBlipSprite (Blipara[i], 1)
			SetBlipDisplay(Blipara[i], 8)
			SetBlipColour (Blipara[i], 2)
			SetBlipScale  (Blipara[i], 1.0)
			SetBlipAsShortRange(Blipara[i], true)
		end
		Broj = #Config.Objekti
		Spawno = true
		Posao = 1
		ESX.ShowNotification("Ocistite cestu!")
		SetBlipRoute(Blipara[1],  true)
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

function IsJobRalica()
	if PlayerData ~= nil then
		local kosac = false
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'ralica' then
			kosac = true
		end
		return kosac
	end
end

AddEventHandler('esx_ralica:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobRalica() and Radis == false  then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobRalica() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

function ZavrsiPosao()
	for i=1, #Config.Objekti, 1 do
		if Objekti[i] ~= nil then
			ESX.Game.DeleteObject(Objekti[i])
			if DoesBlipExist(Blipara[i]) then
				RemoveBlip(Blipara[i])
			end
		end
	end
	Broj = 0
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	if vehicle ~= nil and tablica == plaquevehicule then
		ESX.Game.DeleteVehicle(vehicle)
	end
	Spawno = false
	Radis = false
	Odradio = 1
end

AddEventHandler('esx_ralica:hasExitedMarker', function(zone)
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
		if Spawno == true and Broj > 0 then
			local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			if tablica == plaquevehicule then
				local kord = GetEntityCoords(PlayerPedId())
				if #(kord-Config.Objekti[Odradio]) <= 10 then
					ESX.Game.DeleteObject(Objekti[Odradio])
					if DoesBlipExist(Blipara[Odradio]) then
						RemoveBlip(Blipara[Odradio])
					end
					Broj = Broj-1
					TriggerServerEvent("esx_ralica:platiTuljanu")
					TriggerServerEvent("biznis:DodajTuru", PlayerData.job.name)
					if Broj == 0 then
						--local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						--ESX.Game.DeleteVehicle(vehicle)
						for k,v in pairs(Config.Zones) do
							if k == "VehicleDeletePoint" then
								--SetNewWaypoint(v.Pos.x, v.Pos.y)
								if DoesBlipExist(Blip) then
									RemoveBlip(Blip)
								end
								Blip = AddBlipForCoord(v.Pos)
								SetBlipSprite(Blip, 1)
								SetBlipColour (Blip, 5)
								SetBlipAlpha(Blip, 255)
								SetBlipRoute(Blip,  true) -- waypoint to blip
							end
						end
						Spawno = false
						Radis = false
						Broj = 0
						Odradio = 1
						ESX.ShowNotification("Uspjesno zavrsen posao, vratite kamion do firme!")
					else
						Odradio = Odradio+1
						SetBlipRoute(Blipara[Odradio],  true)
					end
				end
			end
		end
    end
end)

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		if CurrentAction ~= nil then
			waitara = 0
			naso = 1
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if DoesBlipExist(Blip) then
				RemoveBlip(Blip)
			end
			if IsControlJustReleased(0, 38) and IsJobRalica() then

                if CurrentAction == 'Obrisi' then
					ZavrsiPosao()
                end
                CurrentAction = nil
            end
		end

		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		if IsJobRalica() then
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(#(coords-v.Pos) < v.Size.x) then
					waitara = 0
					naso = 1
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if(#(coords-v.Pos) < v.Size.x) then
					waitara = 0
					naso = 1
					isInMarker  = true
					currentZone = k
				end
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_ralica:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_ralica:hasExitedMarker', lastZone)
			end

		end
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobRalica() and v.Type ~= -1 and #(coords-v.Pos) < Config.DrawDistance) then
				waitara = 0
				naso = 1
				DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobRalica() and v.Type ~= -1 and #(coords-v.Pos) < Config.DrawDistance) then
				waitara = 0
				naso = 1
				DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
		if naso == 0 then
			waitara = 500
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
	ZavrsiPosao()
end)