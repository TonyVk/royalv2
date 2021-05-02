local ESX      = nil
local PlayerData = {}
local holdingTablet = true

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)

	TriggerEvent('chat:addSuggestion', '/databaza', ' Policijski mobilni terminal podataka', {})	
	end


    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- Notification
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


local disablechatmdtpd = false

Citizen.CreateThread(function( )
	while true do
		Citizen.Wait(0)
		if disablechatmdtpd then
			DisableControlAction(0, 245, true)
			DisableControlAction(0, 309, true)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterCommand('databaza',function()
	if (ESX.PlayerData.job.name == 'police') then
        if (holdingTablet==true) then
            TriggerEvent("tabletmdttemporal")
            holdingTablet=false
			ESX.ShowNotification("Pritisnite ESC da izadjete!")
			ESX.TriggerServerCallback('databaza:fetch', function(d)
				disablechatmdtpd = true
				Citizen.Wait(2000)
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					array  = d
				})
			end, data, 'start')
        elseif (holdingTablet==false) then
            DeleteEntity(tab)
            ClearPedTasks(PlayerPedId())
            holdingTablet=true
		end
	else
		ESX.ShowNotification("Niste policajac!")
	end
end)

RegisterNetEvent("tabletmdttemporal")
AddEventHandler("tabletmdttemporal", function()
    local ped = GetPlayerPed(-1)
    if not IsEntityDead(ped) then
        if not IsEntityPlayingAnim(ped, "amb@world_human_seat_wall_tablet@female@idle_a", "idle_c", 3) then
            RequestAnimDict("amb@world_human_seat_wall_tablet@female@idle_a")
            while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@idle_a") do
                Citizen.Wait(100)
            end
            
            TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@idle_a", "idle_c", 8.0, -8, -1, 49, 0, 0, 0, 0)
            tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)        ----0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)   
            AttachEntityToEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 18905), 0.12, 0.05, 0.13, -10.5, 180.0, 180.0, true, true, false, true, 1, true)        
             Citizen.Wait(2000)
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        end
    end
end)



-- NUI Callback - Close
RegisterNUICallback('escape', function(data, cb)
	local ped = GetPlayerPed(-1)	
    disablechatmdtpd = false
	holdingTablet=true
    EnableControlAction(0, 245, true)
    EnableControlAction(0, 309, true)
    DeleteEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 18905), 0.12, 0.05, 0.13, -10.5, 180.0, 180.0, true, true, false, true, 1, true)    
    ClearPedTasksImmediately(ped)
    Citizen.Wait(1000)
	SetNuiFocus(false, false)
	cb('ok')
end)

-- NUI Callback - Fetch
RegisterNUICallback('fetch', function(data, cb)
	ESX.TriggerServerCallback('databaza:fetch', function( d )
    cb(d)
  end, data, data.type)
end)

-- NUI Callback - Search
RegisterNUICallback('search', function(data, cb)
	ESX.TriggerServerCallback('databaza:search', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Add
RegisterNUICallback('add', function(data, cb)
	ESX.TriggerServerCallback('databaza:add', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Update
RegisterNUICallback('update', function(data, cb)
	if data.classified ~= nil then
		if ESX.PlayerData.job.grade == 6 then
			ESX.TriggerServerCallback('databaza:update', function( d )
				cb(d)
			end, data)
		else
			ESX.ShowNotification("Niste nacelnik policije!")
		end
	else
		ESX.TriggerServerCallback('databaza:update', function( d )
			cb(d)
		end, data)
	end
end)

-- NUI Callback - Remove
RegisterNUICallback('remove', function(data, cb)
	ESX.TriggerServerCallback('databaza:remove', function( d )
    cb(d)
  end, data)
end)
