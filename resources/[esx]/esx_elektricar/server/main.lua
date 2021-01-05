ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('elektricar:platituljanu')
AddEventHandler('elektricar:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(650)
	TriggerEvent("biznis:StaviUSef", "elektricar", math.ceil(650*0.30))
end)
