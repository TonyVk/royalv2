ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('lockpick:ImasUkosnice', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	cb(xPlayer.getInventoryItem('ukosnica').count)
end)

RegisterServerEvent('lockpick:OduzmiUkosnicu')
AddEventHandler('lockpick:OduzmiUkosnicu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('ukosnica').count > 0 then
		xPlayer.removeInventoryItem('ukosnica', 1)
	end
end)