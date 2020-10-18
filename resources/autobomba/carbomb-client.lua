ESX                             = nil
local timer = 0
local ped = GetPlayerPed(-1)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('RNG_CarBomb:CheckIfRequirementsAreMet')
AddEventHandler('RNG_CarBomb:CheckIfRequirementsAreMet', function()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
    local vCoords = GetEntityCoords(veh)
    local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, vCoords.x, vCoords.y, vCoords.z, false)
    local animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
    local anim = "weed_spraybottle_crouch_base_inspector"

    if not IsPedInAnyVehicle(ped, false) then
        if veh and (dist < 3.0) then
            loadAnimDict(animDict)
            Citizen.Wait(1000)
            TaskPlayAnim(ped, animDict, anim, 3.0, 1.0, -1, 0, 1, 0, 0, 0)
			FreezeEntityPosition(ped, true)
            if Config.ProgressBarType == 0 then
                --return
            elseif Config.ProgressBarType == 1 then
                exports['progressBars']:startUI(Config.TimeTakenToArm * 1000, _U('arming'))
            elseif Config.ProgressBarType == 2 then
                FastMythticProg(_U('arming'), Config.TimeTakenToArm * 1000)
            end
            Citizen.Wait(Config.TimeTakenToArm * 1000)
            ClearPedTasksImmediately(ped)
			FreezeEntityPosition(ped, false)
			TriggerServerEvent("bomba:SpremiVozilo", GetVehicleNumberPlateText(veh))
            TriggerServerEvent('RNG_CarBomb:RemoveBombFromInv')
            if Config.DetonationType == 0 then
                if Config.UsingMythicNotifications then
                    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = _U('vanilla', Config.TimeUntilDetonation), length = 5500})
                else
                    ShowNotification(_U('vanilla', Config.TimeUntilDetonation))  
                end
                RunTimer(veh)
            elseif Config.DetonationType == 1 then
                if Config.UsingMythicNotifications then
                    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = _U('speed', Config.maxSpeed, Config.Speed), length = 5500})
                else
                    ShowNotification(_U('speed', Config.maxSpeed, Config.Speed)) 
                end
            elseif Config.DetonationType == 2 then
                if Config.UsingMythicNotifications then
                    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = _U('remote'), length = 5500})
                else
                    ShowNotification(_U('remote'))
                end
            elseif Config.DetonationType == 3 then
                if Config.UsingMythicNotifications then
                    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = _U('delayed', Config.TimeUntilDetonation), length = 5500})
                else
                    ShowNotification(_U('delayed', Config.TimeUntilDetonation))    
                end 
            elseif Config.DetonationType == 4 then
                if Config.UsingMythicNotifications then
                    TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = _U('instant'), length = 5500})
                else
                    ShowNotification(_U('instant'))    
                end 
            end 
        else
            if Config.UsingMythicNotifications then
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = _U('novehnearby'), length = 5500})
            else
                ShowNotification(_U('novehnearby'))    
            end 
        end 
    else
        if Config.UsingMythicNotifications then
            TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = _U('cantinside'), length = 5500})
        else
            ShowNotification(_U('cantinside'))    
        end 
    end
end)

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, dispname, netId)
	ESX.TriggerServerCallback('bomba:ProvjeriVozilo', function(ima)
		if ima then
			while not IsVehicleEngineStarting(currentVehicle) do
				Wait(100)
			end
			DetonateVehicle(currentVehicle)
			TriggerServerEvent("bomba:MakniVozilo", GetVehicleNumberPlateText(currentVehicle))
		end
	end, GetVehicleNumberPlateText(currentVehicle))
end)

RegisterCommand("bomba", function(source, args, rawCommandString)
	TriggerEvent("RNG_CarBomb:CheckIfRequirementsAreMet")
end, false)

function RunTimer(veh)
    timer = Config.TimeUntilDetonation
    while timer > 0 do
        timer = timer - 1
        Citizen.Wait(1000)
        if timer == 0 then
            DetonateVehicle(veh)
        end
    end
end

function DetonateVehicle(veh)
    if DoesEntityExist(veh) then
		NetworkExplodeVehicle(veh, true, false, false)
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(20)
    end
end

function FastMythticProg(message, time)
    exports['mythic_progbar']:Progress({
		name = "tint",
		duration = time,
		label = message,
		useWhileDead = false,
		canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(cancelled)
        if not cancelled then
            
		else
			Citizen.Wait(1000)
		end
	end)
end

function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end