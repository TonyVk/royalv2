ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('gradjevinar:tuljaniplivaju')
AddEventHandler('gradjevinar:tuljaniplivaju', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(60)
	TriggerEvent("biznis:StaviUSef", "gradjevinar", math.ceil(60*0.30))
end)

RegisterServerEvent('gradjevinar:tuljaniplivaju2')
AddEventHandler('gradjevinar:tuljaniplivaju2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(100)
	TriggerEvent("biznis:StaviUSef", "gradjevinar", math.ceil(100*0.30))
end)
