ESX = nil

local hasAlreadyEnteredMarker = false
local lastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local runspeed = 1.20 --(Change the run speed here !!! MAXIMUM IS 1.49 !!! )
local onDrugs = false

-- Useitem thread
RegisterNetEvent('esx_koristiLSD:useItem')
AddEventHandler('esx_koristiLSD:useItem', function(itemName)
	if onDrugs == false then
		ESX.UI.Menu.CloseAll()

		if itemName == 'LSD' then
			onDrugs = true
			local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
			local playerPed = PlayerPedId()
			ESX.ShowNotification('Osjecate kako vam zivci pocinju raditi protiv vas...')
			TriggerServerEvent("esx_koristiLSD:removeItem", "LSD")
			local playerPed = PlayerPedId()
			SetEntityHealth(playerPed, 170)
			SetPedArmour(playerPed, 100)
			SetRunSprintMultiplierForPlayer(PlayerId(), 0.5)
			ESX.Streaming.RequestAnimDict(lib, function()
				TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

				Citizen.Wait(500)
				while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
					Citizen.Wait(0)
					DisableAllControlActions(0)
				end

				TriggerEvent('esx_koristiLSD:runMan')
			end)
		end
	else
		ESX.ShowNotification("Vec ste pod utjecajom droge!")
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
		ESX.ShowNotification('Utjecaj droge popusta')
    onDrugs = false
	end
end)

-- Cocaine effect (Run really fast)
RegisterNetEvent('esx_koristiLSD:runMan')
AddEventHandler('esx_koristiLSD:runMan', function()
    RequestAnimSet("move_m@hurry_butch@b")
    while not HasAnimSetLoaded("move_m@hurry_butch@b") do
        Citizen.Wait(0)
    end
	count = 0
    DoScreenFadeOut(200)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetTimecycleModifier("spectator5")
	SetPedVisualFieldMaxAngle(GetPlayerPed(-1), 60)
	SetPedScream(GetPlayerPed(-1))
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@hurry_butch@b", true)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.4)
    DoScreenFadeIn(200)
	repeat
		Citizen.Wait(10000)
		count = count + 2
	until count == 8
    DoScreenFadeOut(200)
    Citizen.Wait(1000)
    DoScreenFadeIn(200)
    ClearTimecycleModifier()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    ClearAllPedProps(GetPlayerPed(-1), true)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    ESX.ShowNotification('Utjecaj droge popusta...')
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
		if GetDistanceBetweenCoords(Config.PickupBlip.x,Config.PickupBlip.y,Config.PickupBlip.z, GetEntityCoords(GetPlayerPed(-1))) <= 200 then
			if spawned == false then
				if ESX.PlayerData.job ~= nil then
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						TriggerEvent('LSD:start')
						spawned = true
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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

local displayed = false
local menuOpen = false
			
AddEventHandler('LSD:hasEnteredMarker', function(zone)
	if zone == 'prodaja' then
		CurrentAction     = 'prodaj'
        CurrentActionMsg  = "Pritisnite E da dilate LSD!"
	end
end)

AddEventHandler('LSD:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

local process = true
Citizen.CreateThread(function()
	local waitara = 500
    while true do
			Citizen.Wait(waitara)
			local naso2 = 0
			local kordic = GetEntityCoords(PlayerPedId())
			if (GetDistanceBetweenCoords(-1452.6787109375, -842.34112548828, 2.1501929759979,  kordic.x,  kordic.y,  kordic.z,  true) <= 50.0) then
				waitara = 0
				naso2 = 1
				DrawMarker(27, -1452.6787109375, -842.34112548828, 1.1501929759979, 0, 0, 0, 0, 0, 0, 2.25, 2.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
			end
			
			local isInMarker  = false
			local currentZone = nil

			if(GetDistanceBetweenCoords(kordic, -1452.6787109375, -842.34112548828, 2.1501929759979, true) < 2.25) then
				isInMarker  = true
				currentZone = "prodaja"
			end
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('LSD:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('LSD:hasExitedMarker', lastZone)
			end
			if ESX ~= nil then
				if ESX.PlayerData.job ~= nil then
						for k in pairs(locations) do
							if GetDistanceBetweenCoords(locations[k].x, locations[k].y, locations[k].z, GetEntityCoords(GetPlayerPed(-1))) < 150 then
								waitara = 0
								naso2 = 1
								DrawMarker(3, locations[k].x, locations[k].y, locations[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 200, 0, 110, 0, 1, 0, 0)	
								
								if GetDistanceBetweenCoords(locations[k].x, locations[k].y, locations[k].z, GetEntityCoords(GetPlayerPed(-1)), false) < 1.0 then
									TriggerEvent('LSD:new', k)
									TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', 0, false)
									FreezeEntityPosition(PlayerPedId(), true)
									Citizen.Wait(2000)
									FreezeEntityPosition(PlayerPedId(), false)
									ClearPedTasks(PlayerPedId())
									ClearPedTasksImmediately(PlayerPedId())
									local torba = 0
									TriggerEvent('skinchanger:getSkin', function(skin)
										torba = skin['bags_1']
									end)
									if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
										TriggerServerEvent('LSD:get', true)
									else
										TriggerServerEvent('LSD:get', false)
									end
								end
							
							end
						end
						
						if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z, GetEntityCoords(GetPlayerPed(-1))) < 150 then
								waitara = 0
								naso2 = 1
								DrawMarker(1, Config.Processing.x, Config.Processing.y, Config.Processing.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0, 0, 200, 0, 110, 0, 1, 0, 0)	
								if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z, GetEntityCoords(GetPlayerPed(-1)), true) < 2 then			
									Draw3DText( Config.Processing.x, Config.Processing.y, Config.Processing.z-1.0 , "~w~Proizvodnja LSDa~y~\nPritisnite [~b~E~y~] da krenete sa proizvodnjom LSDa",4,0.15,0.1)
									if IsControlJustReleased(0, Keys['E']) then
										Citizen.CreateThread(function()
											Process()
										end)
									end
								end
								
								if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z, GetEntityCoords(GetPlayerPed(-1)), true) < 5 and GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z, GetEntityCoords(GetPlayerPed(-1)), true) > 3 then
									process = false
								end
						end
				end	
			end
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) then
					if CurrentAction == 'prodaj' then
						TriggerServerEvent("LSD:ProdajLSD")
					end
					CurrentAction = nil
				end
			end
			if naso2 == 0 then
				waitara = 500
			end
    end
end)

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
         local px,py,pz=table.unpack(GetGameplayCamCoords())
         local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
         local scale = (1/dist)*20
         local fov = (1/GetGameplayCamFov())*100
         local scale = scale*fov   
         SetTextScale(scaleX*scale, scaleY*scale)
         SetTextFont(fontId)
         SetTextProportional(1)
		 if inDist then
			SetTextColour(0, 190, 0, 220)		-- You can change the text color here
		 else
		 	SetTextColour(220, 0, 0, 220)		-- You can change the text color here
		 end
         SetTextDropshadow(1, 1, 1, 1, 255)
         SetTextEdge(2, 0, 0, 0, 150)
         SetTextDropShadow()
         SetTextOutline()
         SetTextEntry("STRING")
         SetTextCentre(1)
         AddTextComponentString(textInput)
         SetDrawOrigin(x,y,z+2, 0)
         DrawText(0.0, 0.0)
         ClearDrawOrigin()
end

function Process()
	ESX.Streaming.RequestAnimDict("mini@repair", function()
            TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 32, 0, false, false, false)
	end)
	process = true
	local making = true
	while making and process do
	TriggerEvent('esx:showNotification', '~g~Pocetak ~g~proizvodnje ~w~LSDa')
	Citizen.Wait(5000)
	ESX.TriggerServerCallback('LSD:process', function(output)
			making = output
		end)

	end
end


RegisterNetEvent('LSD:start')
AddEventHandler('LSD:start', function()
	local set = false
	Citizen.Wait(10)
	
	local rnX = Config.PickupBlip.x + math.random(-20, 20)
	local rnY = Config.PickupBlip.y + math.random(-20, 20)
	
	local u, Z = GetGroundZFor_3dCoord(rnX ,rnY ,300.0,0)
	
	

	
	table.insert(locations,{x=rnX, y=rnY, z=Z + 0.3});

	

end)


RegisterNetEvent('LSD:new')
AddEventHandler('LSD:new', function(id)
	local set = false
	Citizen.Wait(10)
	
	
	local rnX = Config.PickupBlip.x + math.random(-20, 20)
	local rnY = Config.PickupBlip.y + math.random(-20, 20)
	
	local u, Z = GetGroundZFor_3dCoord(rnX ,rnY ,300.0,0)
	
	locations[id].x = rnX
	locations[id].y = rnY
	locations[id].z = Z + 0.3
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('LSD:message')
AddEventHandler('LSD:message', function(message)
	ESX.ShowNotification(message)
end)
			
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

