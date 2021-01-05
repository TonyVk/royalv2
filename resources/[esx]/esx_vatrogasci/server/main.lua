ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('vatraaa:platituljanu')
AddEventHandler('vatraaa:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(620)
	TriggerEvent("biznis:StaviUSef", "vatrogasac", math.ceil(620*0.30))
end)
