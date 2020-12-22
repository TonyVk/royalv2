

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




RegisterServerEvent("Heroin:get")
AddEventHandler("Heroin:get", function(torba)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if torba then
		if xPlayer.getInventoryItem('gljive').count < 30*2 then
			local randa = math.random(1,3)
			if xPlayer.getInventoryItem('gljive').count+randa > 30*2 then
				xPlayer.addInventoryItem("gljive", 1)
			else
				xPlayer.addInventoryItem("gljive", randa)
			end
		else
			TriggerClientEvent('esx:showNotification', source, '~r~Ne mozete nositi vise gljiva')
		end
	else
		if xPlayer.getInventoryItem('gljive').count < 30 then
			local randa = math.random(1,3)
			if xPlayer.getInventoryItem('gljive').count+randa > 30 then
				xPlayer.addInventoryItem("gljive", 1)
			else
				xPlayer.addInventoryItem("gljive", randa)
			end
		else
			TriggerClientEvent('esx:showNotification', source, '~r~Ne mozete nositi vise gljiva')
		end
	end	
end)

ESX.RegisterUsableItem('heroin', function(source)
	
		TriggerClientEvent('esx_koristiHeroin:useItem', source, 'heroin')

		Citizen.Wait(1000)
end)

ESX.RegisterServerCallback('esx_koristiHeroin:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_koristiHeroin:removeItem')
AddEventHandler('esx_koristiHeroin:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)
end)

function CancelProcessing(id)
	TriggerClientEvent('esx_koristiHeroin:removeEffect', id)
end

RegisterNetEvent('heroin:ProdajHeroin')
AddEventHandler('heroin:ProdajHeroin', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local naso = 0
	local tozu = xPlayer.getInventoryItem('heroin').count
	if tozu > 0 then
		local cijena = tozu * 400
		xPlayer.removeInventoryItem('heroin', tozu)
		xPlayer.addMoney(cijena)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Prodali ste "..tozu.."g heroina za $"..cijena..".")
		naso = 1
	end
	if naso == 0 then
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Nemate heroina za prodati!")
	end
end)

ESX.RegisterServerCallback('Heroin:process', function (source, cb, torba)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
			
	if xPlayer.getInventoryItem('gljive').count >= 3 then
		if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
			if xPlayer.getInventoryItem('heroin').count < 10*2 then 
				xPlayer.removeInventoryItem('gljive', 3) 
				xPlayer.addInventoryItem('heroin', 1) 
				cb(true)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Nemate vise prostora')
				cb(false)
			end
		else
			if xPlayer.getInventoryItem('heroin').count < 10 then 
				xPlayer.removeInventoryItem('gljive', 3) 
				xPlayer.addInventoryItem('heroin', 1) 
				cb(true)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Nemate vise prrostora')
				cb(false)
			end
		end
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Nemate dosta gljiva')
		cb(false)
	end
end)



