ESX                             = nil
Callback = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
end)

AddEventHandler("lockpick:Start", function(func)
    Callback = func
	ESX.TriggerServerCallback('lockpick:ImasUkosnice', function(br)
		if br > 0 then
			RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
			while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
				Citizen.Wait(0)
			end
			TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false)
			ESX.ShowNotification("Ukosnicu okrecete sa misem, dok cilindar mozete okretati sa D tipkom")
			SendNUIMessage({
				prikazi = true,
				ukosnice = br
			})
			SetNuiFocus(true, true)
		else
			ESX.ShowNotification("Nemate ukosnica!")
		end
	end)
end)

RegisterNUICallback(
    "oduzmi",
    function()
		TriggerServerEvent("lockpick:OduzmiUkosnicu")
    end
)

RegisterNUICallback(
    "kraj",
    function(data, cb)
		if data.win then
			Callback(true)
			SendNUIMessage({
				prikazi = true
			})
			SetNuiFocus(false)
			ClearPedTasksImmediately(PlayerPedId())
		else
			Callback(false)
			SendNUIMessage({
				prikazi = true
			})
			SetNuiFocus(false)
			ClearPedTasksImmediately(PlayerPedId())
		end
    end
)