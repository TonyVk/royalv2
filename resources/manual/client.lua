ESX                           = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local UVozilu = false

local setGear = GetHashKey('SET_VEHICLE_CURRENT_GEAR') & 0xFFFFFFFF
local function SetVehicleCurrentGear(veh, gear)
	Citizen.InvokeNative(setGear, veh, gear)
end

local nextGear = GetHashKey('SET_VEHICLE_NEXT_GEAR') & 0xFFFFFFFF
local function SetVehicleNextGear(veh, gear)
	Citizen.InvokeNative(nextGear, veh, gear)
end

local function ForceVehicleGear (vehicle, gear)
	SetVehicleCurrentGear(vehicle, gear)
	SetVehicleNextGear(vehicle, gear)
	return gear
end

--------------------------------------------------------------------------------
local Manual = false

local mode

RegisterNetEvent('EoTiIzSalona')
AddEventHandler('EoTiIzSalona', function(br)
	if br == 1 then
		Manual = false
		TriggerEvent("SaljiGear", -69)
	elseif br == 2 then
		Manual = true
	end
end)

Citizen.CreateThread(function ()
	local vehicle, lastVehicle, ped
	local gear, maxGear
	local nextMode, maxMode
	local odradio = false

	local braking
	local function HandleVehicleBrake ()
		if gear == 0 then -- Prevent reversing
			DisableControlAction(2, 72, true)
			-- use parking brake once stopped
			if IsDisabledControlPressed(2, 72) then
				SetControlNormal(2, 76, 1.0)
				braking = true
			end
		elseif IsControlPressed(2, 72) then
			braking = true
		end
	end
	
	local function Brejkaj ()
		Citizen.CreateThread(function ()
			if gear == 1 then
				SetVehicleHandbrake(vehicle, true)
				Wait(1000)
				SetVehicleHandbrake(vehicle, false)
			end
		end)
	end

	local function OnTick()
			braking = false

			-- Reverse
			if mode == 1 then
				DisableControlAction(2, 71, true)
				-- gas
				if IsDisabledControlPressed(2, 71) then
					SetControlNormal(2, 72, GetDisabledControlNormal(2, 71))
				else
					HandleVehicleBrake()
				end

			-- Neutral
			elseif mode == 2 then
				HandleVehicleBrake()
				ForceVehicleGear(vehicle, 1)

				-- gas
				DisableControlAction(2, 71, true)
				DisableControlAction(2, 72, true)
				if IsDisabledControlPressed(2, 71) and GetIsVehicleEngineRunning(vehicle) then
					SetVehicleCurrentRpm(vehicle, 1.0)
				end
				if IsDisabledControlPressed(2, 72) then
					SetVehicleBrakeLights(vehicle, true)
					SetVehicleNextGear(vehicle, 0)
					braking = true
				end
			-- Drive
			else
				HandleVehicleBrake()
				ForceVehicleGear(vehicle, mode - 2)
			end

			-- Brake
			if braking or IsControlPressed(2, 76) then
				SetVehicleBrakeLights(vehicle, true)
				--SetVehicleNextGear(vehicle, 0)
				braking = true
			end
	end

	while true do
		ped = PlayerPedId()
		vehicle = GetVehiclePedIsUsing(ped)
		if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped then
			while ESX == nil do
				Citizen.Wait(0)
			end
			if UVozilu == false then
				local globalplate  = GetVehicleNumberPlateText(vehicle)
				if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
					ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
						if mj == 2 then
							Manual = true
						end
					end, globalplate)
					UVozilu = true
				end
			end
		else
			if UVozilu == true then
				UVozilu = false
				Manual = false
				odradio = false
				TriggerEvent("SaljiGear", -69)
			end
		end
		if Manual == true then
			
			if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped then
				gear = GetVehicleCurrentGear(vehicle)

				-- Entered vehicle
				if lastVehicle ~= vehicle then
					lastVehicle = vehicle
					maxGear = GetVehicleHighGear(vehicle)
					maxMode = 2 + maxGear

					-- Use current gear | neutral
					if gear >= 1 then
						mode = gear + 2
					else
						mode = 2
					end
				end
				if odradio == false then
					maxGear = GetVehicleHighGear(vehicle)
					maxMode = 2 + maxGear
					nextMode = math.min(mode, maxMode)
					local modeText = { 'R', 'N'}
					local gira
					if mode >=2 then
						gira = nextMode - 2
					else
						gira = modeText[nextMode]
						--gira = mode - 1 -- GetVehicleCurrentGear(vehicle)
					end
					if gira == nil or gira == 0 or gira == '' then
						gira = "N"
					end
					TriggerEvent("SaljiGear", gira)
					odradio = true
				end

				-- Gear up | down
				if IsControlJustPressed(0, 131) and GetIsVehicleEngineRunning(vehicle) then
					nextMode = math.min(mode + 1, maxMode)
					local modeText = { 'R', 'N'}
					
					local gira
					if mode >=2 then
						gira = nextMode - 2
					else
						gira = modeText[nextMode]
						--gira = mode - 1 -- GetVehicleCurrentGear(vehicle)
					end
					TriggerEvent("SaljiGear", gira)
				elseif IsControlJustPressed(0, 132) and GetIsVehicleEngineRunning(vehicle) then
					nextMode = math.max(mode - 1, 1)
					local modeText = { 'R', 'N'}
					
					local gira
					if nextMode >=2 then
						gira = nextMode-2
					else
						gira = modeText[nextMode]
						--gira = mode - 1 -- GetVehicleCurrentGear(vehicle)
					end
					
					if gira == nil or gira == 0 or gira == '' then
						gira = "N"
					end
					TriggerEvent("SaljiGear", gira)
					Brejkaj()
				else
					nextMode = mode
				end
				-- On Shift
				if nextMode ~= mode then
					mode = nextMode
				end

				OnTick()
			elseif lastVehicle then
				lastVehicle = false
				mode = false
			end
			
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				local speed = GetEntitySpeed(vehicle)
				local kmh = (speed * 3.6)
				if IsControlPressed(0, 71) then
					if kmh < 5 then
						if gear > 1 and GetIsVehicleEngineRunning(vehicle) then
							SetVehicleEngineOn( vehicle, false, true, true )
						end
					end
				end
				if kmh < 2 then
					SetVehicleNextGear(vehicle, 0)
				end
			end
		end
		Wait(0)
	end
end)

--------------------------------------------------------------------------------
