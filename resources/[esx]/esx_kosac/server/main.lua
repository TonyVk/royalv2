ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('kosaaac:platituljanu')
AddEventHandler('kosaaac:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(24)
end)

RegisterServerEvent('kosaaac:platituljanu2')
AddEventHandler('kosaaac:platituljanu2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(10)
end)

RegisterServerEvent('kosaaac:platituljanu3')
AddEventHandler('kosaaac:platituljanu3', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(2)
end)
