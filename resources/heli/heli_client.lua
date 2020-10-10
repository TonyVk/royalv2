-- FiveM Heli Cam by mraes
-- Version 1.3 2017-06-12

-- config
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)

-- Script starts here
local polmav_hash = GetHashKey("polmav")
Citizen.CreateThread(function()
	local waitara = 500
	while true do
        Citizen.Wait(waitara)
		if IsPlayerInPolmav() then
			waitara = 0
			local lPed = GetPlayerPed(-1)
			local heli = GetVehiclePedIsIn(lPed)
			
			if IsHeliHighEnough(heli) then
				if IsControlJustPressed(0, toggle_rappel) then -- Initiate rappel
					if GetPedInVehicleSeat(heli, 1) == lPed or GetPedInVehicleSeat(heli, 2) == lPed then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						TaskRappelFromHeli(GetPlayerPed(-1), 1)
					else
						SetNotificationTextEntry( "STRING" )
						AddTextComponentString("~r~Ne mozete se spustit sa spagom iz ovog sjedala!")
						DrawNotification(false, false )
						PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false) 
					end
				end
			end
		else
			waitara = 500
		end
	end
end)

function IsPlayerInPolmav()
	local lPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(lPed)
	return IsVehicleModel(vehicle, polmav_hash)
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 1.5
end