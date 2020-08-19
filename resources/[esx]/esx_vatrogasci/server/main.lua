ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('vatraaa:platituljanu')
AddEventHandler('vatraaa:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(220)
	TriggerEvent("biznis:StaviUSef", "vatrogasac", math.ceil(220*0.30))
end)
