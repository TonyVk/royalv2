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

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0
local SpawnajDropMarker 		= false
local DropCoord
local PokupioCrate 				= false
local DostavaBlip 				= nil
local ZatrazioOruzje = {}
local ZOBr = 0
local BVozilo 					= nil
local GarazaV 					= nil
local Vblip 					= nil

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  ProvjeriPosao()
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
end

RegisterNetEvent('esx_property:ProsljediVozilo')
AddEventHandler('esx_property:ProsljediVozilo', function(voz, bl)
	if bl == nil then
		if DoesEntityExist(Vblip) then
			RemoveBlip(Vblip)
		end
	end
	GarazaV = voz
	Vblip = bl
end)

RegisterNetEvent('zemunski:VratiVozilo')
AddEventHandler('zemunski:VratiVozilo', function(nid, vehicle, co)
	local attempt = 0
	while not NetworkDoesEntityExistWithNetworkId(nid) and attempt < 100 do
		Wait(1)
		attempt = attempt+1
	end
	if attempt < 100 then
		local callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		while not DoesEntityExist(callback_vehicle) do
			Wait(1)
			callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		end
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		--SetEntityHeading(callback_vehicle, he)
		SetVehRadioStation(callback_vehicle, "OFF")
		GarazaV = nid
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		local pla = vehicle.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, vehicle.model)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		ESX.ShowNotification("Uzeli ste vozilo iz garaze")
		TriggerServerEvent('eden_garage:modifystate', vehicle, 0)
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	else
		print("Greska prilikom kreiranja vozila. NetID: "..nid)
		local ped = GetPlayerPed(-1)
		SetEntityCoords(ped, co)
		local coords = GetEntityCoords(ped)
		local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
		local callback_vehicle = veh
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		--SetEntityHeading(callback_vehicle, he)
		SetVehRadioStation(callback_vehicle, "OFF")
		GarazaV = nid
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		local pla = vehicle.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, vehicle.model)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		ESX.ShowNotification("Uzeli ste vozilo iz garaze")
		TriggerServerEvent('eden_garage:modifystate', vehicle, 0)
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	end
end)

function SpawnVehicle(vehicle, co, he)
	if GarazaV ~= nil then
		TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
		GarazaV = nil
		if Vblip ~= nil then
			RemoveBlip(Vblip)
			Vblip = nil
		end
	end
	TriggerServerEvent("zemunski:SpawnVozilo", vehicle, co, he)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('esx_zemunski:hasEnteredMarker', function(station, part, partNum)
  if part == 'Impound' then
    CurrentAction     = 'menu_impound'
    CurrentActionMsg  = "Pritisnite E da zapljenite vozilo"
    CurrentActionData = {station = station}
  end
end)

AddEventHandler('esx_zemunski:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'automafija' and (GetGameTimer() - GUI.Time) > 150 then
		if CurrentAction == 'menu_impound' then
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			local vehicle = ESX.Game.GetVehicleProperties(veh)
			ESX.TriggerServerCallback('esx_zemunski:OsobnoVozilo', function(isOwnedVehicle)
				if isOwnedVehicle then
					TriggerServerEvent('eden_garage:modifystate2', vehicle, 2)
					ESX.Game.DeleteVehicle(veh)
					Wait(200)
					if DoesEntityExist(veh) then
						local entity = veh
						carModel = GetEntityModel(entity)
						carName = GetDisplayNameFromVehicleModel(carModel)
						NetworkRequestControlOfEntity(entity)
						
						local timeout = 2000
						while timeout > 0 and not NetworkHasControlOfEntity(entity) do
							Wait(100)
							timeout = timeout - 100
						end

						SetEntityAsMissionEntity(entity, true, true)
						
						local timeout = 2000
						while timeout > 0 and not IsEntityAMissionEntity(entity) do
							Wait(100)
							timeout = timeout - 100
						end

						Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
						
						if (DoesEntityExist(entity)) then 
							DeleteEntity(entity)
						end 
					end
					ESX.ShowNotification("Vozilo spremljeno u garazu!")
				else
					ESX.ShowNotification("Ovo nije osobno vozilo ili se desio bug dupliciranog vozila!")
				end
			end, ESX.Math.Trim(GetVehicleNumberPlateText(veh)))
        end
		CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

    if PlayerData.job ~= nil and PlayerData.job.name == 'automafija' then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)
	  
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.ZemunskiStations) do
		for i=1, #v.Impound, 1 do
          if GetDistanceBetweenCoords(coords,  v.Impound[i].x,  v.Impound[i].y,  v.Impound[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Impound'
            currentPartNum = i
          end
        end
      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_zemunski:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_zemunski:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_zemunski:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

      for k,v in pairs(Config.ZemunskiStations) do

		for i=1, #v.Impound, 1 do
          if GetDistanceBetweenCoords(coords,  v.Impound[i].x,  v.Impound[i].y,  v.Impound[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Impound[i].x, v.Impound[i].y, v.Impound[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end
      end
    end
  end
end)
