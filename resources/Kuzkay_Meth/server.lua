ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_methcar:start')
AddEventHandler('esx_methcar:start', function(torba)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getInventoryItem('acetone').count >= 5 and xPlayer.getInventoryItem('lithium').count >= 2 and xPlayer.getInventoryItem('methlab').count >= 1 then
		if torba then
			if xPlayer.getInventoryItem('meth').count >= 30*2 then
				TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Prekoracili ste limit")
			else
				TriggerClientEvent('esx_methcar:startprod', _source)
				xPlayer.removeInventoryItem('acetone', 5)
				xPlayer.removeInventoryItem('lithium', 2)
				xPlayer.removeInventoryItem('methlab', 1)
			end
		else
			if xPlayer.getInventoryItem('meth').count >= 30 then
				TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Prekoracili ste limit")
			else
				TriggerClientEvent('esx_methcar:startprod', _source)
				xPlayer.removeInventoryItem('acetone', 5)
				xPlayer.removeInventoryItem('lithium', 2)
				xPlayer.removeInventoryItem('methlab', 1)
			end
		end
	else
		TriggerClientEvent('esx_methcar:notify', _source, "~r~~h~Nemate dovoljno sredstava kako bi kuhali meth")

	end
	
end)
RegisterServerEvent('esx_methcar:stopf')
AddEventHandler('esx_methcar:stopf', function(id)
local _source = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx_methcar:stopfreeze', xPlayers[i], id)
	end
	
end)
RegisterServerEvent('esx_methcar:make')
AddEventHandler('esx_methcar:make', function(posx,posy,posz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getInventoryItem('methlab').count >= 1 then
	
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			TriggerClientEvent('esx_methcar:smoke',xPlayers[i],posx,posy,posz, 'a') 
		end
		
	else
		TriggerClientEvent('esx_methcar:stop', _source)
	end
	
end)
RegisterServerEvent('esx_methcar:finish')
AddEventHandler('esx_methcar:finish', function(qualtiy)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	print(qualtiy)
	local rnd = math.random(-5, 5)
	TriggerEvent('KLevels:addXP', _source, 20)
	xPlayer.addInventoryItem('meth', math.floor(qualtiy / 2) + rnd)
	
end)

RegisterServerEvent('esx_methcar:blow')
AddEventHandler('esx_methcar:blow', function(posx, posy, posz)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx_methcar:blowup', xPlayers[i],posx, posy, posz)
	end
end)
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
AddEventHandler('meth:KupiMeth', function(torba)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= 5000 then
		if torba then
			if xPlayer.getInventoryItem('methlab').count < 1*2 then
				xPlayer.addInventoryItem('methlab', 1)
				xPlayer.removeMoney(5000)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Vec imate prijenosni laboratorij za meth!')
			end
		else
			if xPlayer.getInventoryItem('methlab').count < 1 then
				xPlayer.addInventoryItem('methlab', 1)
				xPlayer.removeMoney(5000)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Vec imate prijenosni laboratorij za meth!')
			end
		end
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Nemate dovoljno novca!')
	end
end)
