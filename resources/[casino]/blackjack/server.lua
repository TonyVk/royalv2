ESX						= nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bleki:brisituljana')
AddEventHandler('bleki:brisituljana', function(amount)
	local amount = amount
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem('zeton').count
	if quantity >= amount then
		xPlayer.removeInventoryItem('zeton', amount)
		TriggerClientEvent('pNotify:SendNotification', _source, {text = "Kladili ste se sa "..amount.." zetona u BlackJacku.", layout = "bottomCenter"})
		TriggerEvent("DiscordBot:Zetoni", xPlayer.name.."["..xPlayer.source.."] se kladio na blackjacku sa "..amount.." zetona. Sada ima kod sebe "..xPlayer.getInventoryItem('zeton').count.." zetona.")
	end
	--TriggerClientEvent('route68_blackjack:start', _source)
end)

RegisterServerEvent('kasino:Tuljani')
AddEventHandler('kasino:Tuljani', function(amount, multi)
	local aciton = aciton
	local win = math.floor(amount * multi)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addInventoryItem('zeton', win)
	if multi == 2 then
		TriggerClientEvent('pNotify:SendNotification', _source, {text = "Osvojili ste "..win.." zetona! Cestitamo!", layout = "bottomCenter"})
	elseif multi == 1 then
		TriggerClientEvent('pNotify:SendNotification', _source, {text = "Obranili ste "..win.." zetona! Cestitamo!", layout = "bottomCenter"})
	end
	TriggerEvent("DiscordBot:Zetoni", xPlayer.name.."["..xPlayer.source.."] je osvojio na blackjacku "..win.." zetona. Sada ima kod sebe "..xPlayer.getInventoryItem('zeton').count.." zetona.")
	--TriggerClientEvent('route68_blackjack:start', _source)
end)

ESX.RegisterServerCallback('route68_blackjack:check_money', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem('zeton').count
	cb(quantity)
end)