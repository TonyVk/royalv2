ESX						= nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_roulette:removemoney')
AddEventHandler('esx_roulette:removemoney', function(amount)
	local amount = amount
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('zeton', amount)
	TriggerEvent("DiscordBot:Zetoni", xPlayer.name.."["..xPlayer.source.."] se kladio na ruletu sa "..amount.." zetona. Kod sebe ima "..xPlayer.getInventoryItem('zeton').count.." zetona.")
end)

RegisterServerEvent('kasino:rTuljani')
AddEventHandler('kasino:rTuljani', function(action, amount)
	local aciton = aciton
	local amount = amount
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if action == 'black' or action == 'red' then
		local win = amount*2
		xPlayer.addInventoryItem('zeton', win)
		TriggerEvent("DiscordBot:Zetoni", xPlayer.name.."["..xPlayer.source.."] je osvojio na ruletu "..win.." zetona. Sada ima "..xPlayer.getInventoryItem('zeton').count.." zetona.")
	elseif action == 'green' then
		local win = amount*14
		xPlayer.addInventoryItem('zeton', win)
		TriggerEvent("DiscordBot:Zetoni", xPlayer.name.."["..xPlayer.source.."] je osvojio na ruletu "..win.." zetona. Sada ima "..xPlayer.getInventoryItem('zeton').count.." zetona.")
	else
	end
end)

ESX.RegisterServerCallback('esx_roulette:check_money', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem('zeton').count
	
	cb(quantity)
end)