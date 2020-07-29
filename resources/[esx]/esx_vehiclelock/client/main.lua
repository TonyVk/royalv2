ESX               = nil

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

local isRunningWorkaround = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ToggleVehicleLock()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords, 8.0, 0, 70)
	end

	if not DoesEntityExist(vehicle) then
		return
	end
	local dict = "anim@mp_player_intmenu@key_fob@"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
	ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle)

		if isOwnedVehicle then
			--local lockStatus = GetVehicleDoorLockStatus(vehicle)
			local lockStatus = GetVehicleDoorsLockedForPlayer(vehicle)
			if lockStatus == false then -- unlocked
				SetVehicleDoorsLockedForAllPlayers(vehicle, true)
				PlayVehicleDoorCloseSound(vehicle, 1)
				local prop
				if not IsPedInAnyVehicle(PlayerPedId(), true) then
					local playerPed = PlayerPedId()
					local x,y,z = table.unpack(GetEntityCoords(playerPed))
					prop = CreateObject(GetHashKey("lr_prop_carkey_fob"), x, y, z+2, true, true, true)
					local boneIndex = GetPedBoneIndex(playerPed, 57005)
					AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.038, 0.001, 10.0, 175.0, 90.0, true, true, false, true, 1, true)
					TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				end
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				if not IsPedInAnyVehicle(PlayerPedId(), true) then
					Citizen.Wait(600)
					DeleteObject(prop)
				end
				TriggerEvent('chat:addMessage', { args = { _U('message_title'), _U('message_locked') } })
			else-- locked
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				PlayVehicleDoorOpenSound(vehicle, 0)
				local prop
				if not IsPedInAnyVehicle(PlayerPedId(), true) then
					local playerPed = PlayerPedId()
					local x,y,z = table.unpack(GetEntityCoords(playerPed))
					prop = CreateObject(GetHashKey("lr_prop_carkey_fob"), x, y, z+2, true, true, true)
					local boneIndex = GetPedBoneIndex(playerPed, 57005)
					AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.038, 0.001, 10.0, 175.0, 90.0, true, true, false, true, 1, true)
					TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				end
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				if not IsPedInAnyVehicle(PlayerPedId(), true) then
					Citizen.Wait(600)
					DeleteObject(prop)
				end
				TriggerEvent('chat:addMessage', { args = { _U('message_title'), _U('message_unlocked') } })
			end
		end

	end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, Keys['U']) and IsInputDisabled(0) then
			ToggleVehicleLock()
			Citizen.Wait(300)
	
		-- D-pad down on controllers works, too!
		elseif IsControlJustReleased(0, 173) and not IsInputDisabled(0) then
			ToggleVehicleLock()
			Citizen.Wait(300)
		end
	end
end)
