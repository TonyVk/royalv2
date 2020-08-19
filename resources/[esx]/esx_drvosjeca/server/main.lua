ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('drvosjeca:platituljanu')
AddEventHandler('drvosjeca:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(150)
	TriggerEvent("biznis:StaviUSef", "drvosjeca", math.ceil(150*0.30))
end)
