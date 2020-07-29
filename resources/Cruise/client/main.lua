local _cruising = false
local _rpm

Citizen.CreateThread(function()
	while true do
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			if IsControlJustPressed(0, 19) then
				local v = GetVehiclePedIsIn(PlayerPedId(),false)
				if v ~= nil and not IsEntityInAir(v) then
					local class = GetVehicleClass(v)
					if GetVehicleCurrentGear(v) ~= 0 and class ~= 13 and class ~= 8 and class ~= 16 and class ~= 15 and class ~= 14 and class ~= 21 then
						if _cruising == false then
							_cruising = true
							_rpm = GetVehicleCurrentRpm(v)
							CruiseAtSpeed(GetEntitySpeed(v))
						else
							_cruising = false
						end
					end
				end
			end
		else
			Wait(500)
		end
		Wait(0)
	end
end)

function CruiseAtSpeed(s)
    while _cruising do
        local v = GetVehiclePedIsIn(PlayerPedId(),false)
        if v ~= 0 then
			SetVehicleForwardSpeed(v, s)
			SetVehicleCurrentRpm(v, _rpm)

            if GetPedInVehicleSeat(v, -1) ~= PlayerPedId() or IsEntityInWater(v) or IsVehicleInBurnout(v) or not GetIsVehicleEngineRunning(v) or 
            IsEntityInAir(v) or HasEntityCollidedWithAnything(v) or
            GTASpeedToMPH(GetEntitySpeed(v)) <= 25 or GTASpeedToMPH(GetEntitySpeed(v)) >= 100 or
            IsControlPressed(0, 76) or IsDisabledControlPressed(0, 76) or
            IsControlPressed(0, 72) or IsDisabledControlPressed(0, 72) then
				_cruising = false
            end
            if IsControlPressed(0, 71) or IsDisabledControlPressed(0, 71) then
                AcceleratingToNewSpeed()
			end
        else
			return
        end
        Wait(0)
    end
end

function AcceleratingToNewSpeed()
    _cruising = false
    while (IsControlPressed(0, 71) or
          IsDisabledControlPressed(0, 71)) and
          GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 do
		Wait(100)
    end

    if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
        _cruising = true
        CruiseAtSpeed(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)))
    end
end

function GTASpeedToMPH(s)
	return s*2.23694+0.5
end