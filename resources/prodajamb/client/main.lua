local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local Oruzja					= {}
local BrojOruzja				= {}
local Cijena 					= 0
local VoziloID 					= nil
local Blip 						= nil
local VBlip						= nil
local DostavaID 				= 0
local PrikazoTekst 				= 0
local Prodaje 					= 0
local Poslic 					= nil
local TrajeDostava 				= 0

local dostave = 
{
    {x = 907.12414550781, y = -1732.8756103516, z = 30.062334060669}, --istovaroruzjadroge1
	{x = 976.80212402344, y = -1825.0364990234, z = 30.636585235596}, --istovaroruzjadroge2
	{x = 955.66595458984, y = -2110.9118652344, z = 30.031211853027}, --istovaroruzjadroge3
	{x = 845.36651611328, y = -2362.0415039063, z = 29.824703216553}, --istovaroruzjadroge4
	{x = 1244.3372802734, y = -3142.044921875, z = 5.0414257049561}, --istovaroruzjadroge5
	{x = 1216.5462646484, y = -3002.2944335938, z = 5.3450527191162}, --istovaroruzjadroge6
	{x = 34.788818359375, y = -2650.1391601563, z = 5.4856877326965}, --istovaroruzjadroge7
	{x = -525.09619140625, y = -2901.0568847656, z = 5.4814658164978}
}

ESX                             = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  while ESX.GetPlayerData().job == nil do
	Citizen.Wait(100)
  end
  DohvatiSve()
end)

function DohvatiSve()
	ESX.PlayerData = ESX.GetPlayerData()
end

RegisterNetEvent("prodajamb:VratiVozilo")
AddEventHandler('prodajamb:VratiVozilo', function(id, did)
	VoziloID = id
	DostavaID = did
end)

RegisterNetEvent("prodajamb:VratiOruzje")
AddEventHandler('prodajamb:VratiOruzje', function(oruz, br)
	Oruzja = oruz
	BrojOruzja = br
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if DostavaID ~= 0 then
			coords = GetEntityCoords(GetPlayerPed(-1))
			if (GetDistanceBetweenCoords(coords, dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z, true) < 100) and Prodaje == 1 then
				DrawMarker(1, dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z-0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

AddEventHandler("playerSpawned", function()
	TriggerServerEvent("prodajamb:DaliPostoji")
end)

Citizen.CreateThread(function()
	while true do
		Wait(5000)
		if DostavaID ~= 0 then
			if ESX.PlayerData.job.name == Poslic then
				local coords = GetEntityCoords(VoziloID)
				if DoesBlipExist(VBlip) then
					RemoveBlip(VBlip)
				end
				VBlip = AddBlipForCoord(coords)
				SetBlipSprite(VBlip, 477)
				SetBlipColour (VBlip, 1)
				SetBlipAlpha(VBlip, 255)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Dostava oruzja")
				EndTextCommandSetBlipName(VBlip)
			end
			if ESX.PlayerData.job.name == "ballas" then
				if GetVehiclePedIsIn(PlayerPedId(), false) == VoziloID then
					if DoesBlipExist(Blip) then
						RemoveBlip(Blip)
					end
					Blip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
					SetBlipSprite(Blip, 1)
					SetBlipColour (Blip, 5)
					SetBlipAlpha(Blip, 255)
					SetBlipRoute(Blip,  true) -- waypoint to blip
					Prodaje = 1
				end
				local coords = GetEntityCoords(VoziloID)
				if DoesBlipExist(VBlip) then
					RemoveBlip(VBlip)
				end
				if PrikazoTekst == 0 then
					PrikazoTekst = 1
					ESX.ShowNotification("Mafija je zapocela dostavu oruzja, svakih 5 sekundi vam se pokaze trenutna lokacija vozila!")
				end
				VBlip = AddBlipForCoord(coords)
				SetBlipSprite(VBlip, 477)
				SetBlipColour (VBlip, 1)
				SetBlipAlpha(VBlip, 255)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Dostava oruzja")
				EndTextCommandSetBlipName(VBlip)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		if DostavaID ~= 0 then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			if GetDistanceBetweenCoords(coords, dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z, true) < 3.0 and Prodaje == 1 then
				isInMarker  = true
				currentZone = "Dostava"
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('prodajamb:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('prodajamb:hasExitedMarker', lastZone)
			end

		end

	end
end)

AddEventHandler('prodajamb:hasEnteredMarker', function(zone)
	if zone == 'Dostava' then
		if VoziloID == GetVehiclePedIsIn(PlayerPedId(), false) then
			if DoesBlipExist(Blip) then
				RemoveBlip(Blip)
			end
			Prodaje = 0
			for i=1, 10, 1 do
				Oruzja[i] = nil
				BrojOruzja[i] = nil
			end
			DostavaID = 0
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
			ESX.ShowNotification("Istovar..")
			Wait(5000)
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
			TriggerServerEvent("prodajamb:IsplatiSve", ESX.PlayerData.job.name)
			TriggerServerEvent("prodajamb:TrajeDostava", 0)
			ESX.ShowNotification("Zavrsili ste dostavu!")
			if DoesEntityExist(VoziloID) then
				ESX.Game.DeleteVehicle(VoziloID)
			end
		else
			ESX.ShowNotification("Niste u vozilu za dostavu!")
		end
	end
end)

AddEventHandler('prodajamb:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
end)
		
RegisterNetEvent("prodajamb:PokreniProdaju")
AddEventHandler('prodajamb:PokreniProdaju', function(posao)
	if Oruzja[1] ~= nil then
		if TrajeDostava == 0 then
			if posao == "yakuza" then
				local hashVehicule = "mule"
				ESX.Streaming.RequestModel(hashVehicule)
				VoziloID = CreateVehicle(hashVehicule, -967.86749267578, -1486.178100586, 5.010293006897, 44.47, true, false)
				SetVehicleCustomPrimaryColour(VoziloID, 0,0,0)
				SetVehicleCustomSecondaryColour(VoziloID, 0,0,0)
				TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
				DostavaID = math.random(1,#dostave)
				Blip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
				SetBlipSprite(Blip, 1)
				SetBlipColour (Blip, 5)
				SetBlipAlpha(Blip, 255)
				SetBlipRoute(Blip,  true) -- waypoint to blip
				Prodaje = 1
				TriggerServerEvent("prodajamb:SaljiVozilo", VoziloID, DostavaID)
				TriggerServerEvent("prodajamb:TrajeDostava", 1)
				ESX.ShowNotification("Za 5 sekundi cete postati vidljivi svim bandama na serveru!")
				Poslic = posao
				SetModelAsNoLongerNeeded(hashVehicule)
			elseif posao == "britvasi" then
				local hashVehicule = "mule"
				ESX.Streaming.RequestModel(hashVehicule)
				VoziloID = CreateVehicle(hashVehicule, -2660.4921875, 1307.4168701172, 145.83178710938, 271.75, true, false)
				SetVehicleCustomPrimaryColour(VoziloID, 51, 51, 51)
				SetVehicleCustomSecondaryColour(VoziloID, 51, 51, 51)
				TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
				DostavaID = math.random(1,#dostave)
				Blip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
				SetBlipSprite(Blip, 1)
				SetBlipColour (Blip, 5)
				SetBlipAlpha(Blip, 255)
				SetBlipRoute(Blip,  true) -- waypoint to blip
				Prodaje = 1
				TriggerServerEvent("prodajamb:SaljiVozilo", VoziloID, DostavaID)
				TriggerServerEvent("prodajamb:TrajeDostava", 1)
				ESX.ShowNotification("Za 5 sekundi cete postati vidljivi svim bandama na serveru!")
				Poslic = posao
				SetModelAsNoLongerNeeded(hashVehicule)
			elseif posao == "cartel" then
				local hashVehicule = "mule"
				ESX.Streaming.RequestModel(hashVehicule)
				VoziloID = CreateVehicle(hashVehicule, 1394.1110839844, 1116.7958984375, 113.8376235962, 81.73, true, false)
				SetVehicleCustomPrimaryColour(VoziloID, 51, 51, 51)
				SetVehicleCustomSecondaryColour(VoziloID, 51, 51, 51)
				TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
				DostavaID = math.random(1,#dostave)
				Blip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
				SetBlipSprite(Blip, 1)
				SetBlipColour (Blip, 5)
				SetBlipAlpha(Blip, 255)
				SetBlipRoute(Blip,  true) -- waypoint to blip
				Prodaje = 1
				TriggerServerEvent("prodajamb:SaljiVozilo", VoziloID, DostavaID)
				TriggerServerEvent("prodajamb:TrajeDostava", 1)
				ESX.ShowNotification("Za 5 sekundi cete postati vidljivi svim bandama na serveru!")
				Poslic = posao
				SetModelAsNoLongerNeeded(hashVehicule)
			elseif posao == "shelby" then
				local hashVehicule = "mule"
				ESX.Streaming.RequestModel(hashVehicule)
				VoziloID = CreateVehicle(hashVehicule, -1531.4735107422, 83.44214630127, 56.16077041626, 315.96, true, false)
				SetVehicleCustomPrimaryColour(VoziloID, 51, 51, 51)
				SetVehicleCustomSecondaryColour(VoziloID, 51, 51, 51)
				TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
				DostavaID = math.random(1,#dostave)
				Blip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
				SetBlipSprite(Blip, 1)
				SetBlipColour (Blip, 5)
				SetBlipAlpha(Blip, 255)
				SetBlipRoute(Blip,  true) -- waypoint to blip
				Prodaje = 1
				TriggerServerEvent("prodajamb:SaljiVozilo", VoziloID, DostavaID)
				TriggerServerEvent("prodajamb:TrajeDostava", 1)
				ESX.ShowNotification("Za 5 sekundi cete postati vidljivi svim bandama na serveru!")
				Poslic = posao
				SetModelAsNoLongerNeeded(hashVehicule)
			elseif posao == "mafia" then
				local hashVehicule = "mule"
				ESX.Streaming.RequestModel(hashVehicule)
				VoziloID = CreateVehicle(hashVehicule, 8.237, 556.963, 175.266, 90.0, true, false)
				SetVehicleCustomPrimaryColour(VoziloID, 51, 51, 51)
				SetVehicleCustomSecondaryColour(VoziloID, 51, 51, 51)
				TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
				DostavaID = math.random(1,#dostave)
				Blip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
				SetBlipSprite(Blip, 1)
				SetBlipColour (Blip, 5)
				SetBlipAlpha(Blip, 255)
				SetBlipRoute(Blip,  true) -- waypoint to blip
				Prodaje = 1
				TriggerServerEvent("prodajamb:SaljiVozilo", VoziloID, DostavaID)
				TriggerServerEvent("prodajamb:TrajeDostava", 1)
				ESX.ShowNotification("Za 5 sekundi cete postati vidljivi svim bandama na serveru!")
				Poslic = posao
				SetModelAsNoLongerNeeded(hashVehicule)
			elseif posao == "nomads" then
				local hashVehicule = "mule"
				ESX.Streaming.RequestModel(hashVehicule)
				VoziloID = CreateVehicle(hashVehicule,-124.26942443848, 999.41394042968, 235.35809326172, 203.43, true, false)
				SetVehicleCustomPrimaryColour(VoziloID, 225, 59, 59)
				SetVehicleCustomSecondaryColour(VoziloID, 225, 59, 59)
				TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
				DostavaID = math.random(1,#dostave)
				Blip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
				SetBlipSprite(Blip, 1)
				SetBlipColour (Blip, 5)
				SetBlipAlpha(Blip, 255)
				SetBlipRoute(Blip,  true) -- waypoint to blip
				Prodaje = 1
				TriggerServerEvent("prodajamb:SaljiVozilo", VoziloID, DostavaID)
				TriggerServerEvent("prodajamb:TrajeDostava", 1)
				ESX.ShowNotification("Za 5 sekundi cete postati vidljivi svim bandama na serveru!")
				Poslic = posao
				SetModelAsNoLongerNeeded(hashVehicule)
			elseif posao == "camorra" then
				local hashVehicule = "mule"
				ESX.Streaming.RequestModel(hashVehicule)
				VoziloID = CreateVehicle(hashVehicule,-824.72473144531, 180.1802520752, 69.959587097168, 134.67, true, false)
				SetVehicleCustomPrimaryColour(VoziloID, 0, 0, 0)
				SetVehicleCustomSecondaryColour(VoziloID, 0, 0, 0)
				TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
				DostavaID = math.random(1,#dostave)
				Blip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
				SetBlipSprite(Blip, 1)
				SetBlipColour (Blip, 5)
				SetBlipAlpha(Blip, 255)
				SetBlipRoute(Blip,  true) -- waypoint to blip
				Prodaje = 1
				TriggerServerEvent("prodajamb:SaljiVozilo", VoziloID, DostavaID)
				TriggerServerEvent("prodajamb:TrajeDostava", 1)
				ESX.ShowNotification("Za 5 sekundi cete postati vidljivi svim bandama na serveru!")
				Poslic = posao
				SetModelAsNoLongerNeeded(hashVehicule)
			elseif posao == "zemunski" then
				local hashVehicule = "mule"
				ESX.Streaming.RequestModel(hashVehicule)
				VoziloID = CreateVehicle(hashVehicule, -1541.2944335938, 879.79107666016, 179.81750488282, 282.73, true, false)
				SetVehicleCustomPrimaryColour(VoziloID, 0, 0, 0)
				SetVehicleCustomSecondaryColour(VoziloID, 0, 0, 0)
				TaskWarpPedIntoVehicle(PlayerPedId(),  VoziloID,  -1)
				DostavaID = math.random(1,#dostave)
				Blip = AddBlipForCoord(dostave[DostavaID].x, dostave[DostavaID].y, dostave[DostavaID].z)
				SetBlipSprite(Blip, 1)
				SetBlipColour (Blip, 5)
				SetBlipAlpha(Blip, 255)
				SetBlipRoute(Blip,  true) -- waypoint to blip
				Prodaje = 1
				TriggerServerEvent("prodajamb:SaljiVozilo", VoziloID, DostavaID)
				TriggerServerEvent("prodajamb:TrajeDostava", 1)
				ESX.ShowNotification("Za 5 sekundi cete postati vidljivi svim bandama na serveru!")
				Poslic = posao
				SetModelAsNoLongerNeeded(hashVehicule)
			end
		else
			ESX.ShowNotification("Vec je pokrenuta dostava!")
		end
	else
		ESX.ShowNotification("Niste izabrali oruzja za prodaju!")
	end
end)

RegisterNetEvent('prodajamb:VratiDostavu')
AddEventHandler('prodajamb:VratiDostavu', function(br)
	TrajeDostava = br
end)

RegisterNetEvent('prodajamb:ResetSve')
AddEventHandler('prodajamb:ResetSve', function(br)
	if br == 1 then
		if DoesEntityExist(VoziloID) then
			ESX.Game.DeleteVehicle(VoziloID)
		end
	end
	if DoesBlipExist(VBlip) then
		RemoveBlip(VBlip)
	end
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
	end
	Prodaje = 0
	DostavaID = 0
	PrikazoTekst = 0
	TriggerServerEvent("prodajamb:TrajeDostava", 0)
	for i=1, 10, 1 do
		Oruzja[i] = nil
		BrojOruzja[i] = nil
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)
