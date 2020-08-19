ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('kosaaac:platituljanu')
AddEventHandler('kosaaac:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(24)
	TriggerEvent("biznis:StaviUSef", "kosac", math.ceil(24*0.30))
end)

RegisterServerEvent('kosaaac:platituljanu2')
AddEventHandler('kosaaac:platituljanu2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(10)
	TriggerEvent("biznis:StaviUSef", "kosac", math.ceil(10*0.30))
end)

RegisterServerEvent('kosaaac:platituljanu3')
AddEventHandler('kosaaac:platituljanu3', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(2)
	TriggerEvent("biznis:StaviUSef", "kosac", math.ceil(2*0.30))
end)
