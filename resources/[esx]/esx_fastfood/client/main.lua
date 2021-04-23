ESX = nil
local Objekti = {}
local Spawno = false
local objektSpawnan = false
local BrojDostava = 6
local opetBroj = 0
local Radis = false

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

local isInService = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}

local plaquevehicule = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blipara				  = {}
local VratiBlip				  = {}
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
				ESX.ShowNotification("Uzmite skuter i krenite sa dostavom!")
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

	for i=1, #Config.Bikes, 1 do
		table.insert(elements, {label = "Skuter", value = Config.Bikes[i]})
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "skuter" then
			ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 116.28479003906, function(vehicle)
				platenum = math.random(10000, 99999)
				SetVehicleNumberPlateText(vehicle, "WAL"..platenum)             
				plaquevehicule = "WAL"..platenum			
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
			end)
			restartajCitavuJebenuSkriptu()
			Radis = true
			SpawnObjekte()
		end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function SpawnObjekte()
	if objektSpawnan == false then
		local randomBroj = math.random(1,16)
		opetBroj = randomBroj
		ESX.Game.SpawnLocalObject('prop_ped_gib_01', {
				x = Config.Objekti[randomBroj].x,
				y = Config.Objekti[randomBroj].y,
				z = Config.Objekti[randomBroj].z
		}, function(obj)
		Objekti[randomBroj] = obj
		end)
		Blipara[randomBroj] = AddBlipForCoord(Config.Objekti[randomBroj].x,  Config.Objekti[randomBroj].y,  Config.Objekti[randomBroj].z)
		SetBlipSprite (Blipara[randomBroj], 1)
		SetBlipDisplay(Blipara[randomBroj], 8)
		SetBlipColour (Blipara[randomBroj], 2)
		SetBlipScale  (Blipara[randomBroj], 1.4)
		
		Spawno = true
		objektSpawnan = true
	end
end

function isASkuter()
	local isASkuter = false
	local playerPed = GetPlayerPed(-1)
	for i=1, #Config.Bikes, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(playerPed), Config.Bikes[i]) then
			isASkuter = true
			break
		end
	end
	return isASkuter
end

function IsJobFastFood()
	if ESX.PlayerData.job ~= nil then
		local fastfood = false
		if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'fastfood' then
			fastfood = true
		end
		return fastfood
	end
end

function restartajCitavuJebenuSkriptu()
	resetBrojDostava()
	Spawno = false
	objektSpawnan = false
end


function resetBrojDostava()
	BrojDostava = 6
	opetBroj = 0
end

function postaviWaypoint()
	SetNewWaypoint(452.63,-698.47)
end

AddEventHandler('esx_fastfood:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobFastFood() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobFastFood() then
			obrisiVozilo()
		end
	end
end)

function obrisiVozilo()
	local odjebi = 1
	odjebi = odjebi - 1
	if odjebi == 0 then
		ESX.ShowNotification("Vozilo vraceno")
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		ESX.Game.DeleteVehicle(vehicle)
		ZavrsiPosao()
		isInService = false
	end
end

function ZavrsiPosao()
	if Objekti[opetBroj] ~= nil then
		ESX.Game.DeleteObject(Objekti[opetBroj])
		if DoesBlipExist(Blipara[opetBroj]) then
			RemoveBlip(Blipara[opetBroj])
		end
	end
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	Spawno = false
	objektSpawnan = false
	Radis = false
end

AddEventHandler('esx_fastfood:hasExitedMarker', function(zone)
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
		if Spawno == true and opetBroj > 0 then
			if #(GetEntityCoords(PlayerPedId())-vector3(Config.Objekti[opetBroj].x, Config.Objekti[opetBroj].y, Config.Objekti[opetBroj].z)) <= 5 then
				Wait(300)
				ESX.Game.DeleteObject(Objekti[opetBroj])
				if DoesBlipExist(Blipara[opetBroj]) then
					RemoveBlip(Blipara[opetBroj])
				end
				BrojDostava = BrojDostava - 1
				TriggerServerEvent("fastfood:isplata")
				TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.job.name)
				if BrojDostava > 0 then
					objektSpawnan = false
					Spawno = false
					SpawnObjekte()
					ESX.ShowNotification("Dostavite sljedecu narudzbu")
					ESX.ShowNotification(BrojDostava)
				else						
					Radis = false
					opetBroj = 0
					Spawno = false
					ESX.ShowNotification("Dostavili ste sve narudzbe!")
					postaviWaypoint()
				end
			end
		end
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) and IsJobFastFood() then
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
	local waitara = 1000
	while true do
		local naso = 0
		Wait(waitara)

		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		if IsJobFastFood() then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					naso = 1
					waitara = 0
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					naso = 1
					waitara = 0
					isInMarker  = true
					currentZone = k
				end
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				naso = 1
				waitara = 0
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_fastfood:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				naso = 1
				waitara = 0
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_fastfood:hasExitedMarker', lastZone)
			end

		end
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobFastFood() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				naso = 1
				waitara = 0
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobFastFood() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				naso = 1
				waitara = 0
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				--ESX.ShowNotification("Dostavio")
			end

		end
		if naso == 0 then
			waitara = 1000
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	ZavrsiPosao()
end)