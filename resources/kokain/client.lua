ESX = nil

local hasAlreadyEnteredMarker = false
local lastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local Mafije = {}
local runspeed = 1.20 --(Change the run speed here !!! MAXIMUM IS 1.49 !!! )
local onDrugs = false

-- Useitem thread
RegisterNetEvent('esx_drogica:useItem')
AddEventHandler('esx_drogica:useItem', function(itemName)
	if onDrugs == false then
		ESX.UI.Menu.CloseAll()

		if itemName == 'cocaine' then
			onDrugs = true
			local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
			local playerPed = PlayerPedId()
			ESX.ShowNotification('Osjecate kako vam zivci pocinju raditi protiv vas...')
			TriggerServerEvent("esx_drogica:removeItem", "cocaine")
			local playerPed = PlayerPedId()
			SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
			SetPedArmour(playerPed, 100)
			ESX.Streaming.RequestAnimDict(lib, function()
				TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

				Citizen.Wait(500)
				while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
					Citizen.Wait(0)
					DisableAllControlActions(0)
				end

				TriggerEvent('esx_drogica:runMan')
			end)
		end
	else
		ESX.ShowNotification("Vec ste nadrogirani!")
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if onDrugs == true then
		DoScreenFadeOut(1000)
		Citizen.Wait(1000)
		DoScreenFadeIn(1000)
		ClearTimecycleModifier()
		ResetPedMovementClipset(GetPlayerPed(-1), 0)
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		ClearAllPedProps(GetPlayerPed(-1), true)
		SetPedMotionBlur(GetPlayerPed(-1), false)
		ESX.ShowNotification('Dolazite sebi...')
    onDrugs = false
	end
end)

-- Cocaine effect (Run really fast)
RegisterNetEvent('esx_drogica:runMan')
AddEventHandler('esx_drogica:runMan', function()
    RequestAnimSet("move_m@hurry_butch@b")
    while not HasAnimSetLoaded("move_m@hurry_butch@b") do
        Citizen.Wait(0)
    end
	count = 0
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetTimecycleModifier("spectator5")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@hurry_butch@b", true)
	SetRunSprintMultiplierForPlayer(PlayerId(), runspeed)
    DoScreenFadeIn(1000)
	repeat
		ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
		TaskJump(GetPlayerPed(-1), false, true, false)
		Citizen.Wait(5000)
		count = count  + 1
	until count == 6
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    ClearAllPedProps(GetPlayerPed(-1), true)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    ESX.ShowNotification('Dolazite sebi...')
    onDrugs = false
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	PostaviPosao()
end)

function PostaviPosao()
	ESX.PlayerData = ESX.GetPlayerData()
	
	ESX.TriggerServerCallback('mafije:DohvatiMafijev2', function(mafija)
		Mafije = mafija
	end)
end

local locations = {}


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
local spawned = false
Citizen.CreateThread( function()
	Citizen.Wait(10000)
	while true do
		Citizen.Wait(1000)
		if #(GetEntityCoords(PlayerPedId())-Config.PickupBlip) <= 200 then
		--if GetDistanceBetweenCoords(Config.PickupBlip.x,Config.PickupBlip.y,Config.PickupBlip.z, GetEntityCoords(GetPlayerPed(-1))) <= 200 then
			if spawned == false then
				if ESX.PlayerData.job ~= nil then
					local naso = 0
					for i=1, #Mafije, 1 do
						if Mafije[i] ~= nil and Mafije[i].Ime == ESX.PlayerData.job.name then
							naso = 1
							break
						end
					end
					if naso == 1 then
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						TriggerEvent('esx_drogica:start')
						spawned = true
					end
				end
			end
		else
			if spawned then
				locations = {}
			end
			spawned = false
		end
	end
end)

RegisterNetEvent('mafije:UpdateMafije')
AddEventHandler('mafije:UpdateMafije', function(maf)
	Mafije = maf
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	local waitara = 500
    while true do
		Citizen.Wait(waitara)
		if ESX ~= nil then
			if ESX.PlayerData.job ~= nil then
				local naso = 0
				for i=1, #Mafije, 1 do
					if Mafije[i] ~= nil and Mafije[i].Ime == ESX.PlayerData.job.name then
						naso = 1
						break
					end
				end
				local naso2 = 0
				if naso == 1 then
					local kordic = GetEntityCoords(PlayerPedId())
					for k in pairs(locations) do
						if #(kordic-locations[k]) < 150 then
						--if GetDistanceBetweenCoords(locations[k].x, locations[k].y, locations[k].z, GetEntityCoords(GetPlayerPed(-1))) < 150 then
							waitara = 0
							naso2 = 1
							DrawMarker(3, locations[k], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 200, 0, 110, 0, 1, 0, 0)	
							if #(kordic-locations[k]) < 1.0 then
							--if GetDistanceBetweenCoords(locations[k].x, locations[k].y, locations[k].z, GetEntityCoords(GetPlayerPed(-1)), false) < 1.0 then	
								TriggerEvent('esx_drogica:new', k)
								TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', 0, false)
								Citizen.Wait(2000)
								ClearPedTasks(PlayerPedId())
								ClearPedTasksImmediately(PlayerPedId())
								local torba = 0
								TriggerEvent('skinchanger:getSkin', function(skin)
									torba = skin['bags_1']
								end)
								if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
									TriggerServerEvent('esx_drogica:get', true)
								else
									TriggerServerEvent('esx_drogica:get', false)
								end
							end
						end
					end
				end
			end	
		end
		if naso2 == 0 then
			waitara = 500
		end
    end
end)

RegisterNetEvent('esx_drogica:start')
AddEventHandler('esx_drogica:start', function()
	local set = false
	Citizen.Wait(10)
	
	local x,y,z = table.unpack(Config.PickupBlip)
	
	local rnX = x + math.random(-35, 35)
	local rnY = y + math.random(-35, 35)
	
	local u, Z = GetGroundZFor_3dCoord(rnX ,rnY ,300.0,0)
	
	

	local vect = vector3(rnX, rnY, Z+0.3)
	table.insert(locations, vect);

	

end)

RegisterNetEvent('esx_drogica:new')
AddEventHandler('esx_drogica:new', function(id)
	local set = false
	Citizen.Wait(10)
	
	local x,y,z = table.unpack(Config.PickupBlip)
	
	local rnX = x + math.random(-35, 35)
	local rnY = y + math.random(-35, 35)
	
	
	local u, Z = GetGroundZFor_3dCoord(rnX ,rnY ,300.0,0)
	
	local vect = vector3(rnX, rnY, Z+0.3)
	
	locations[id] = vect
	ClearPedTasks(PlayerPedId())
end)