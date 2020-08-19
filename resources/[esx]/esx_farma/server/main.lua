ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('seljacina:platituljanu')
AddEventHandler('seljacina:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(15)
	TriggerEvent("biznis:StaviUSef", "farmer", math.ceil(15*0.30))
end)
