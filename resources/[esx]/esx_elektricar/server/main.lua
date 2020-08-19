ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('elektricar:platituljanu')
AddEventHandler('elektricar:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(250)
	TriggerEvent("biznis:StaviUSef", "elektricar", math.ceil(250*0.30))
end)
