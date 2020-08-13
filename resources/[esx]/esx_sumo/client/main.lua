ESX = nil

local USumo = false
local StareKoord = nil
local Vozilo = nil
local Minuta = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("sumo:Vrime")
AddEventHandler('sumo:Vrime', function(vr)
    Minuta = vr
end)

RegisterNetEvent("sumo:Zavrsi")
AddEventHandler('sumo:Zavrsi', function()
    if USumo then
		TriggerEvent("iens:Dozvoljeno", true)
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
		SetPlayerCanDoDriveBy(PlayerId(), true)
        USumo = false
		SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
		StareKoord = nil
		TriggerServerEvent("sumo:Tuljan")
	end
end)

RegisterNetEvent("sumo:Joinaj")
AddEventHandler('sumo:Joinaj', function()
    if not USumo then
		ESX.TriggerServerCallback('sumo:DohvatiPoziciju', function(br)
			if br > 10 then
				ESX.ShowNotification("Nema vise mjesta!")
			else
				TriggerServerEvent("sumo:PovecajPoziciju")
				USumo = true
				TriggerEvent("iens:Dozvoljeno", false)
				StareKoord = GetEntityCoords(PlayerPedId())
				ESX.ShowNotification("Usli ste u sumo!")
				ESX.ShowNotification("Da napustite sumo pisite /napustisumo!")
				SetEntityCoords(PlayerPedId(), Config.Spawnovi[br].x, Config.Spawnovi[br].y, Config.Spawnovi[br].z, false, false, false, false)
				ESX.Game.SpawnVehicle("monster",{
					x=Config.Spawnovi[br].x,
					y=Config.Spawnovi[br].y,
					z=Config.Spawnovi[br].z											
				},Config.Spawnovi[br].h, function(callback_vehicle)
					TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
					FreezeEntityPosition(callback_vehicle, true)
					TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(callback_vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(callback_vehicle)))
					SetVehicleDoorsLocked(callback_vehicle, 4)
					Vozilo = callback_vehicle
				end)
				TriggerEvent("EoTiIzSalona", 1)
				Startajj = 1
				PratiPocetak()
				OdradiOstalo()
			end
		end)
	else
		ESX.ShowNotification("Vec ste u sumou!")
	end
end)

RegisterNetEvent("sumo:Prekini")
AddEventHandler('sumo:Prekini', function()
    if USumo then
		TriggerEvent("iens:Dozvoljeno", true)
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
		SetPlayerCanDoDriveBy(PlayerId(), true)
        USumo = false
		SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
		StareKoord = nil
	end
end)

RegisterCommand("napustisumo", function(source, args, rawCommandString)
	if USumo then
		TriggerServerEvent("sumo:SmanjiPoziciju")
		TriggerEvent("iens:Dozvoljeno", true)
		USumo = false
		ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
		SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
		StareKoord = nil
		SetPlayerCanDoDriveBy(PlayerId(), true)
		ESX.ShowNotification("izaso si iz sumoa!")
	else
		ESX.ShowNotification("Niste u sumo eventu!")
	end
end, false)

function PratiPocetak()
	local Aha1 = 0
	local Aha2 = 0
	local Aha3 = 0
	local AhaGo = 0
	Citizen.CreateThread(function()
		while Startajj == 1 do
			Citizen.Wait(0)
			if USumo then
				if Minuta == 3 and Aha1 == 0 then
					TriggerEvent("pNotify:SendNotification", {text = "3", type = "info", timeout = 1000, layout = "bottomCenter"})
					PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
					Aha1 = 1
				end
				if Minuta == 2 and Aha2 == 0 then
					TriggerEvent("pNotify:SendNotification", {text = "2", type = "info", timeout = 1000, layout = "bottomCenter"})
					PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
					Aha2 = 1
				end
				if Minuta == 1 and Aha3 == 0 then
					TriggerEvent("pNotify:SendNotification", {text = "1", type = "info", timeout = 1000, layout = "bottomCenter"})
					PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
					Aha3 = 1
				end
				if Minuta == 0 and AhaGo == 0 then
					TriggerEvent("pNotify:SendNotification", {text = "GO", type = "info", timeout = 1000, layout = "bottomCenter"})
					PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
					AhaGo = 1
					ESX.TriggerServerCallback('sumo:DohvatiPoziciju', function(br)
						if br == 2 then
							USumo = false
							Startajj = 0
							TriggerServerEvent("sumo:SmanjiPoziciju")
							TriggerEvent("iens:Dozvoljeno", true)
							ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
							SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
							StareKoord = nil
							SetPlayerCanDoDriveBy(PlayerId(), true)
							ESX.ShowNotification("Sumo je zavrsio zato sto ste sami bili!")
						else
							FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), false)
							TriggerServerEvent("sumo:TrajeSumo")
							Startajj = 0
						end
					end)
				end
			else
				Startajj = 0
			end
		end
	end)
end

function OdradiOstalo()
	Citizen.CreateThread(function() 
		local hashara = GetHashKey("WEAPON_UNARMED")
        while USumo do
            Citizen.Wait(5)
			SetCurrentPedWeapon(PlayerPedId(),hashara,true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			SetPlayerCanDoDriveBy(PlayerId(), false)
			
			local kord = GetEntityCoords(PlayerPedId())
			if (kord.z < 34.0 or kord.y > -3133.5) and USumo then
				TriggerServerEvent("sumo:SmanjiPoziciju")
				TriggerEvent("iens:Dozvoljeno", true)
				USumo = false
				ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
				SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
				StareKoord = nil
				SetPlayerCanDoDriveBy(PlayerId(), true)
				ESX.ShowNotification("Ispao si iz sumoa!")
			end

			if not IsPedInAnyVehicle(PlayerPedId(), false) and USumo then
                ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
				TriggerEvent("iens:Dozvoljeno", true)
                ESX.ShowNotification("Napustili ste vozilo te ste izbaceni iz sumoa!")
				SetPlayerCanDoDriveBy(PlayerId(), true)
                USumo = false
				SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
				StareKoord = nil
				TriggerServerEvent("sumo:SmanjiPoziciju")
                return
            end
        end
    end)
end

