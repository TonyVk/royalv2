Keys = {
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

ESX = nil
local menuOpen = false
local wasOpen = false
local lastEntity = nil
local currentAction = nil
local currentData = nil
local UKrugu = 0
local Ped = nil
local PrviPutUso = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterCommand("hifi", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			TriggerEvent('esx_hifi:place_hifi')
			TriggerEvent('esx:showNotification', _U('put_hifi'))
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	end)
end, false)

RegisterNetEvent('esx_hifi:place_hifi')
AddEventHandler('esx_hifi:place_hifi', function()
    startAnimation("anim@heists@money_grab@briefcase","put_down_case")
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject('prop_boombox_01', {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
		NetworkRequestControlOfEntity(obj)
		local neid = ObjToNet(obj)
		SetNetworkIdExistsOnAllMachines(neid, true)
		SetNetworkIdCanMigrate(neid, true)
	end)
    --TriggerEvent('esx:spawnObject', 'prop_boombox_01')
	Ped = PlayerPedId()
end)

RegisterNetEvent('esx_hifi:play_music2')
AddEventHandler('esx_hifi:play_music2', function(id, object)
	UKrugu = 0
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(100)
			if UKrugu == 1 then
				local objecte = GetClosestObjectOfType(object, 10.0, GetHashKey('prop_boombox_01'), false, false, false)
				if objecte == nil or objecte == -1 or objecte == 0 then
					UKrugu = 0
					lastEntity = nil
					currentAction = nil
					currentData = nil
					TriggerEvent("stopradio")
					break
				end
			end
			if distance(object) >= Config.distance then
				if UKrugu == 1 then
					TriggerEvent("stopradio")
					UKrugu = 0
				end
			else
				if UKrugu == 0 then
					TriggerEvent("playboomboxyt", id)
					UKrugu = 1
				end
			end
		end
	end)
end)

RegisterNetEvent('esx_hifi:play_music')
AddEventHandler('esx_hifi:play_music', function(id, object)
	TriggerEvent("loadmp3", id)
	UKrugu = 0
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(100)
				local objecte = nil
				objecte = GetClosestObjectOfType(object, 10.0, GetHashKey('prop_boombox_01'), false, false, false)
				if UKrugu == 1 then
					if objecte == nil or objecte == -1 or objecte == 0 then
						UKrugu = 0
						lastEntity = nil
						currentAction = nil
						currentData = nil
						TriggerEvent("stopmp3")
						break
					end
				end
				if distance(object) >= Config.distance then
					if UKrugu == 1 then
						TriggerEvent("pausemp3")
						UKrugu = 0
					end
				else
					if UKrugu == 0 then
						local pid = NetworkGetEntityOwner(objecte)
						local ide = GetPlayerServerId(pid)
						if ide ~= GetPlayerServerId(PlayerId()) then
							ESX.TriggerServerCallback('radio:DohvatiVrijeme', function(br)
								TriggerEvent("radio:SyncVr", br)
							end, ide)
						end
						TriggerEvent("resumemp3")
						UKrugu = 1
					end
				end
				if distance(object) >= 0 and distance(object) <= 1 then
					if UKrugu == 1 then
							TriggerEvent("volmp3", 1.0)
					end
				elseif distance(object) <= 2 and distance(object) > 1 then
					if UKrugu == 1 then
							TriggerEvent("volmp3", 0.9)
					end
				elseif distance(object) <= 3 and distance(object) > 2 then
					if UKrugu == 1 then
							TriggerEvent("volmp3", 0.8)
					end
				elseif distance(object) <= 4 and distance(object) > 3 then
					if UKrugu == 1 then
							TriggerEvent("volmp3", 0.7)
					end
				elseif distance(object) <= 5 and distance(object) > 4 then
					if UKrugu == 1 then
							TriggerEvent("volmp3", 0.6)
					end
				elseif distance(object) <= 6 and distance(object) > 5 then
					if UKrugu == 1 then
							TriggerEvent("volmp3", 0.5)
					end
				elseif distance(object) <= 7 and distance(object) > 6 then
					if UKrugu == 1 then
							TriggerEvent("volmp3", 0.4)
					end
				elseif distance(object) <= 8 and distance(object) > 7 then
					if UKrugu == 1 then
							TriggerEvent("volmp3", 0.3)
					end
				elseif distance(object) <= 9 and distance(object) > 8 then
					if UKrugu == 1 then
							TriggerEvent("volmp3", 0.2)
					end
				end
		end
	end)
end)

RegisterNetEvent('esx_hifi:stop_music')
AddEventHandler('esx_hifi:stop_music', function(object)
    if distance(object) < Config.distance then
        TriggerEvent("stopmp3")
		TriggerEvent("stopradio")
		UKrugu = 0
    end
end)

RegisterNetEvent('esx_hifi:setVolume')
AddEventHandler('esx_hifi:setVolume', function(volume, object)
    if distance(object) < Config.distance then
		TriggerEvent("volmp3", volume)
    end
end)

function distance(object)
    local playerPed = PlayerPedId()
    local lCoords = GetEntityCoords(playerPed)
    local distance  = GetDistanceBetweenCoords(lCoords, object, true)
    return distance
end

function OpenhifiMenu()
    menuOpen = true
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hifi', {
        title   = 'La hifi a momo',
        align   = 'top-left',
        elements = {
            {label = _U('get_hifi'), value = 'get_hifi'},
            {label = _U('play_music'), value = 'play'},
			{label = "Pusti YT", value = 'playyt'},
            {label = _U('volume_music'), value = 'volume'},
            {label = _U('stop_music'), value = 'stop'}
        }
    }, function(data, menu)
        local playerPed = PlayerPedId()
        local lCoords = GetEntityCoords(playerPed)
        if data.current.value == 'get_hifi' then
            ESX.PlayerData = ESX.GetPlayerData()
            local alreadyOne = false
            for i=1, #ESX.PlayerData.inventory, 1 do
                if ESX.PlayerData.inventory[i].name == 'hifi' and ESX.PlayerData.inventory[i].count > 0 then
                    alreadyOne = true
                end
            end
            if not alreadyOne then
                NetworkRequestControlOfEntity(currentData)
                menu.close()
                menuOpen = false
                startAnimation("anim@heists@narcotics@trash","pickup")
                Citizen.Wait(700)
                SetEntityAsMissionEntity(currentData,false,true)
                DeleteEntity(currentData)
                ESX.Game.DeleteObject(currentData)
                if not DoesEntityExist(currentData) then
                    TriggerServerEvent('esx_hifi:remove_hifi', lCoords)
                    currentData = nil
                end
                Citizen.Wait(500)
                ClearPedTasks(PlayerPedId())
            else
                menu.close()
                menuOpen = false
                TriggerEvent('esx:showNotification', _U('hifi_alreadyOne'))
            end
        elseif data.current.value == 'play' then
            play(lCoords)
		elseif data.current.value == 'playyt' then
            play2(lCoords)
        elseif data.current.value == 'stop' then
            TriggerServerEvent('esx_hifi:stop_music', lCoords)
			TriggerEvent("loadmp3", "nema")
            menuOpen = false
            menu.close()
        elseif data.current.value == 'volume' then
            setVolume(lCoords)
        end
    end, function(data, menu)
        menuOpen = false
        menu.close()
    end)
end

function setVolume(coords)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'setvolume',
        {
            title = _U('set_volume'),
        }, function(data, menu)
            local value = tonumber(data.value)
            if value < 0 or value > 100 then
                ESX.ShowNotification(_U('sound_limit'))
            else
                TriggerServerEvent('esx_hifi:setVolume', value, coords)
                menu.close()
            end
        end, function(data, menu)
            menu.close()
        end)
end

function play2(coords)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'play',
        {
            title = _U('play'),
        }, function(data, menu)
            TriggerServerEvent('esx_hifi:play_music2', data.value, coords)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
end


function play(coords)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'play',
        {
            title = _U('play'),
        }, function(data, menu)
            TriggerServerEvent('esx_hifi:play_music', data.value, coords)
			Citizen.CreateThread(function()
				while true do
					if UKrugu == 1 then
						TriggerEvent("radio:SyncGa", GetPlayerServerId(PlayerId()))
					end
					Citizen.Wait(1000)
				end
			end)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
		if Ped ~= nil then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			local closestDistance = -1
			local closestEntity   = nil

			local object = GetClosestObjectOfType(coords, 3.0, GetHashKey('prop_boombox_01'), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end

			if closestDistance ~= -1 and closestDistance <= 3.0 then
				if lastEntity ~= closestEntity and not menuOpen then
					ESX.ShowHelpNotification(_U('hifi_help'))
					lastEntity = closestEntity
					currentAction = "music"
					currentData = closestEntity
				end
			else
				if lastEntity then
					lastEntity = nil
					currentAction = nil
					currentData = nil
				end
			end
		end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		
        if currentAction then
            if IsControlJustReleased(0, 38) and currentAction == 'music' then
                OpenhifiMenu()
            end
        end
    end
end)

function startAnimation(lib,anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end)
end