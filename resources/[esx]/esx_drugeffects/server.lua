ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('cocaine', function(source)
		--local xPlayer = ESX.GetPlayerFromId(source)
		--xPlayer.removeInventoryItem('cocaine', 1)
	
		TriggerClientEvent('esx_drogica:useItem', source, 'cocaine')

		Citizen.Wait(1000)
end)

ESX.RegisterServerCallback('esx_drogica:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_drogica:removeItem')
AddEventHandler('esx_drogica:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)
end)

function CancelProcessing(id)
	TriggerClientEvent('esx_drogica:removeEffect', id)
end
