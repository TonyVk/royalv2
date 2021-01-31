ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj 
		end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('route68_blackjack:start')
AddEventHandler('route68_blackjack:start', function()
	ESX.TriggerServerCallback('route68_blackjack:check_money', function(quantity)
		if quantity >= 100 then
			if quantity > 100000 then
				SendNUIMessage({
					type = "enableui",
					enable = true,
					coins = 100000
				})
			else
				SendNUIMessage({
					type = "enableui",
					enable = true,
					coins = quantity
				})
			end
			SetNuiFocus(true, true)
		else
			ESX.ShowNotification('Morate imati minimalno 100 zetona!')
		end
	end, '')
	--roulette_menu()
end)

RegisterNUICallback('escape', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "enableui",
		enable = false
	})
end)

RegisterNUICallback('card', function(data, cb)
	cb('ok')
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'PlayCard', 1.0)
end)

RegisterNUICallback('bet', function(data, cb)
	cb('ok')
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'betup', 1.0)
end)

RegisterNUICallback('escape2', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "enableui",
		enable = false
	})
	TriggerEvent('pNotify:SendNotification', {text = 'Nemate vise zetona!', layout = "bottomCenter"})
end)

RegisterNUICallback('DobioOkladu', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerServerEvent('kasino:Tuljani', count, 2)
end)

RegisterNUICallback('IzjednacenaOklada', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerServerEvent('kasino:Tuljani', count, 1)
end)

RegisterNUICallback('LostBet', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerEvent('pNotify:SendNotification', {text = "Izgubili ste "..count.." zetona!", layout = "bottomCenter"})
end)

RegisterNUICallback('Status', function(data, cb)
	cb('ok')
	TriggerEvent('pNotify:SendNotification', {text = data.tekst, layout = "bottomCenter"})
end)

RegisterNUICallback('StartPartia', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerServerEvent('bleki:brisituljana', count)
end)