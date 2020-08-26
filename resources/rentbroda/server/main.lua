ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('rentbroda:OduzmiPare', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 700 then
		xPlayer.removeMoney(700)
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent("rentbroda:SviSuTuljani")
AddEventHandler('rentbroda:SviSuTuljani', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addMoney(700)
end)