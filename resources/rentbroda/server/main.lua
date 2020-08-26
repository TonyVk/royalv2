ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('rentbroda:ImalPara', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 700 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent("rentbroda:SviSuTuljani")
AddEventHandler('rentbroda:SviSuTuljani', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(700)
end)