-- optimizations
local tonumber            = tonumber
local unpack              = table.unpack
local CreateThread        = Citizen.CreateThread
local Wait                = Citizen.Wait
local TriggerEvent        = TriggerEvent
local RegisterCommand     = RegisterCommand
local PlayerPedId         = PlayerPedId
local IsPedInAnyVehicle   = IsPedInAnyVehicle
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetVehiclePedIsIn   = GetVehiclePedIsIn
local GetIsTaskActive     = GetIsTaskActive
local SetPedIntoVehicle   = SetPedIntoVehicle
local disabled            = false

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) and not disabled then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(veh, 0) == ped then
                if not GetIsTaskActive(ped, 164) and GetIsTaskActive(ped, 165) then
					local angle = GetVehicleDoorAngleRatio(veh, 1)
					if angle ~= 0.0 then
						SetVehicleDoorControl(veh, 1, 1, 0.0)
					end
                    SetPedIntoVehicle(PlayerPedId(), veh, 0)
                end
            end
        end
    end
end)

RegisterCommand("prebaci", function()
    CreateThread(function()
        disabled = true
        Wait(3000)
        disabled = false
    end)
end)

TriggerEvent('chat:addSuggestion', '/prebaci', 'Koristite da se prebacite na vozacevo mjesto!')