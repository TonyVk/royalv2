ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('gradjevinar:tuljaniplivaju')
AddEventHandler('gradjevinar:tuljaniplivaju', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(50)
	TriggerEvent("biznis:StaviUSef", "gradjevinar", math.ceil(50*0.30))
end)
