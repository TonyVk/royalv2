ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('vodaa:platituljanu')
AddEventHandler('vodaa:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(550)
	TriggerEvent("biznis:StaviUSef", "vodoinstalater", math.ceil(550*0.30))
end)
