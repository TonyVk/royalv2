ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('rentkampera:ImalPara', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 500 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent("rentkampera:SviSuTuljani")
AddEventHandler('rentkampera:SviSuTuljani', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(500)
end)

RegisterNetEvent('meth:ProdajMeth')
AddEventHandler('meth:ProdajMeth', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local naso = 0
	local tozu = xPlayer.getInventoryItem('meth').count
	if tozu > 0 then
		local cijena = tozu * 750
		xPlayer.removeInventoryItem('meth', tozu)
		xPlayer.addMoney(cijena)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Prodali ste "..tozu.."g metha za $"..cijena..".")
		naso = 1
	end
	if naso == 0 then
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Nemate metha za prodati!")
	end
end)

RegisterNetEvent('meth:KupiMeth')
AddEventHandler('meth:KupiMeth', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= 5000 then
		if xPlayer.getInventoryItem('methlab').count == 0 then
			xPlayer.addInventoryItem('methlab', 1)
			xPlayer.removeMoney(5000)
		else
			TriggerClientEvent('esx:showNotification', source, '~r~Vec imate!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Nemate dovoljno novca!')
	end
end)