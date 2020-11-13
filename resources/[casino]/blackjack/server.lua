ESX						= nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('route68_blackjack:removemoney')
AddEventHandler('route68_blackjack:removemoney', function(amount)
	local amount = amount
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('zeton', amount)
	TriggerClientEvent('pNotify:SendNotification', _source, {text = "Kladili ste se sa "..amount.." zetona u BlackJacku.", layout = "bottomCenter"})
	--TriggerClientEvent('route68_blackjack:start', _source)
end)

RegisterServerEvent('route68_blackjack:givemoney')
AddEventHandler('route68_blackjack:givemoney', function(amount, multi)
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
	--TriggerClientEvent('route68_blackjack:start', _source)
end)

ESX.RegisterServerCallback('route68_blackjack:check_money', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem('zeton').count
	cb(quantity)
end)