tveltESX = nil

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end


    ESX.PlayerData = ESX.GetPlayerData()

    TriggerServerEvent("prot-hud:server:requestTable")
end)

local EVHud = true
local speed = 0.0
local seatbeltOn = false
local cruiseOn = false

local bleedingPercentage = 0
local hunger = 100
local thirst = 100
local drunk = 0

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
	if hour <= 9 then
		hour = "0" .. hour
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

Citizen.CreateThread(function()
    Citizen.Wait(500)
    while true do 
        if ESX ~= nil and EVHud then
			local mph = 0.0
			local pos
			local street1,street2
			local current_zone
			local fuel
			local engine
			if IsPedInAnyVehicle(PlayerPedId()) then
				local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				speed = GetEntitySpeed(veh) * 3.6
				fuel = exports['LegacyFuel']:GetFuel(veh)
				engine = GetVehicleEngineHealth(veh)
			end
            SendNUIMessage({
                action = "hudtick",
                show = IsPauseMenuActive(),
                health = GetEntityHealth(GetPlayerPed(-1)),
                armor = GetPedArmour(GetPlayerPed(-1)),
                thirst = thirst,
                hunger = hunger,
                drunk = drunk,
                bleeding = bleedingPercentage,
                speed = math.ceil(speed),
                fuel = fuel,
                engine = engine,
            })
            Citizen.Wait(200)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        if ESX ~= nil and EVHud then
			local time
			if IsPedInAnyVehicle(PlayerPedId()) then
				time = CalculateTimeToDisplay()
			end
            SendNUIMessage({
                action = "hudtick",
                show = IsPauseMenuActive(),
                time = time
            })
        end
		Citizen.Wait(60000)
    end
end)

local radarActive = false
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
        if IsPedInAnyVehicle(PlayerPedId()) and EVHud then
			if not radarActive then
				DisplayRadar(true)
				SendNUIMessage({
					action = "car",
					show = true,
				})
				local time
				time = CalculateTimeToDisplay()
				SendNUIMessage({
					action = "hudtick",
					show = IsPauseMenuActive(),
					time = time
				})
				radarActive = true
			end
        else
			if radarActive then
				DisplayRadar(false)
				SendNUIMessage({
					action = "car",
					show = false,
				})
				seatbeltOn = false
				cruiseOn = false

				SendNUIMessage({
					action = "seatbelt",
					seatbelt = seatbeltOn,
				})

				SendNUIMessage({
					action = "cruise",
					cruise = cruiseOn,
				})
				radarActive = false
			end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		TriggerEvent('esx_status:getStatus', 'hunger', function(h)
            TriggerEvent('esx_status:getStatus', 'thirst', function(t)
                TriggerEvent('esx_status:getStatus', 'drunk', function(d)
                    hunger = h.getPercent()
                    thirst = t.getPercent()
                    drunk = d.getPercent()
				end)
			end)
        end)
        Citizen.Wait(1000)
	end
end)

local vehiclesKHM = {}

Citizen.CreateThread(function()
	local currSpeed = 0.0
    local cruiseSpeed = 999.0
    local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
    local seatbeltEjectSpeed = 45.0 
    local seatbeltEjectAccel = 100.0
	local saljikm = 100
	while true do
        Citizen.Wait(1)
		local player = GetPlayerPed(-1)
        if IsPedInAnyVehicle(player, false) then
			local position = GetEntityCoords(player)
			local veh = GetVehiclePedIsIn(player, false)
            local vehicleClass = GetVehicleClass(veh)
			local prevSpeed = currSpeed
			currSpeed = GetEntitySpeed(veh)
            if vehicleClass ~= 13 then
                SetPedConfigFlag(PlayerPedId(), 32, true)
                if not seatbeltOn then
                    local vehIsMovingFwd = GetEntitySpeedVector(veh, true).y > 1.0
                    local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                    if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
                        SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                        SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                        Citizen.Wait(1)
                        SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                    else
                        prevVelocity = GetEntityVelocity(veh)
                    end
                else
                    DisableControlAction(0, 75)
                end
            end

			local plate = GetVehicleNumberPlateText(veh)
			local k = currSpeed * 3.6
			local h = ((k/60)/1000)/2.5

			if not vehiclesKHM[plate] then
				vehiclesKHM[plate] = 0
			end

			if GetPedInVehicleSeat(veh, -1) == player then
				vehiclesKHM[plate] = vehiclesKHM[plate] + h
			end
			if saljikm > 0 then
				saljikm = saljikm-1
			else
				saljikm = 100
				TriggerEvent("prot-hud:client:UpdateDrivingMeters", true, math.floor(vehiclesKHM[plate]))
			end

			if IsControlJustReleased(0, 29) then
				seatbeltOn = not seatbeltOn
				 if not seatbeltOn then
					TriggerEvent("seatbelt:client:ToggleSeatbelt",false)
					TriggerEvent("notification",'Seat Belt Disabled',2)
				else
					TriggerEvent("seatbelt:client:ToggleSeatbelt",true)
					TriggerEvent("notification",'Seat Belt Enabled',1)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5000)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local plate = GetVehicleNumberPlateText(veh)
            if vehiclesKHM[plate] and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                TriggerServerEvent("prot-hud:server:vehiclesKHM", plate, vehiclesKHM[plate])
            end
		end
	end
end)

RegisterNetEvent("prot-hud:client:vehiclesKHM")
AddEventHandler("prot-hud:client:vehiclesKHM", function(plate,kmh)
    vehiclesKHM[plate] = kmh
end)

RegisterNetEvent("prot-hud:client:vehiclesKHMTable")
AddEventHandler("prot-hud:client:vehiclesKHMTable", function(table)
    vehiclesKHM = table
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltOn = not seatbeltOn
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = seatbeltOn,
        })
    else
        seatbeltOn = toggle
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = toggle,
        })
    end
end)

RegisterNetEvent('prot-hud:client:ToggleHarness')
AddEventHandler('prot-hud:client:ToggleHarness', function(toggle)
    SendNUIMessage({
        action = "harness",
        toggle = toggle
    })
end)

RegisterNetEvent('prot-hud:client:UpdateDrivingMeters')
AddEventHandler('prot-hud:client:UpdateDrivingMeters', function(toggle, amount)
    SendNUIMessage({
        action = "UpdateDrivingMeters",
        amount = amount,
        toggle = toggle,
    })
end)

RegisterNetEvent('prot-hud:client:UpdateVoiceProximity')
AddEventHandler('prot-hud:client:UpdateVoiceProximity', function(Proximity)
    SendNUIMessage({
        action = "proximity",
        prox = Proximity
    })
end)

RegisterNetEvent('prot-hud:client:ProximityActive')
AddEventHandler('prot-hud:client:ProximityActive', function(active)
    SendNUIMessage({
        action = "talking",
        IsTalking = active
    })
end)

function GetDirectionText(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "Noord"
    elseif (heading >= 45 and heading < 135) then
        return "Oost"
    elseif (heading >=135 and heading < 225) then
        return "Zuid"
    elseif (heading >= 225 and heading < 315) then
        return "West"
    end
end

RegisterCommand('hud', function()
    EVHud = not EVHud
end)