

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




RegisterServerEvent("LSD:get")
AddEventHandler("LSD:get", function(torba)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if torba then
		if xPlayer.getInventoryItem('kemija').count < 20*2 then
			local randa = math.random(1,2)
			if xPlayer.getInventoryItem('kemija').count+randa > 20*2 then
				xPlayer.addInventoryItem("kemija", 1)
			else
				xPlayer.addInventoryItem("kemija", randa)
			end
		else
			TriggerClientEvent('esx:showNotification', source, '~r~Ne mozete nositi vise kemije')
		end
	else
		if xPlayer.getInventoryItem('kemija').count < 20 then
			local randa = math.random(1,2)
			if xPlayer.getInventoryItem('kemija').count+randa > 20 then
				xPlayer.addInventoryItem("kemija", 1)
			else
				xPlayer.addInventoryItem("kemija", randa)
			end
		else
			TriggerClientEvent('esx:showNotification', source, '~r~Ne mozete nositi vise kemije')
		end
	end	
end)

ESX.RegisterUsableItem('LSD', function(source)
	
		TriggerClientEvent('esx_koristiLSD:useItem', source, 'LSD')

		Citizen.Wait(1000)
end)

ESX.RegisterServerCallback('esx_koristiLSD:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_koristiLSD:removeItem')
AddEventHandler('esx_koristiLSD:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)
end)

function CancelProcessing(id)
	TriggerClientEvent('esx_koristiLSD:removeEffect', id)
end

RegisterNetEvent('LSD:ProdajLSD')
AddEventHandler('LSD:ProdajLSD', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local naso = 0
	local tozu = xPlayer.getInventoryItem('LSD').count
	if tozu > 0 then
		local cijena = tozu * 500
		xPlayer.removeInventoryItem('LSD', tozu)
		xPlayer.addMoney(cijena)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Prodali ste "..tozu.."g LSDa za $"..cijena..".")
		naso = 1
	end
	if naso == 0 then
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Nemate LSDa za prodati!")
	end
end)

ESX.RegisterServerCallback('LSD:process', function (source, cb, torba)
	
	local _source = source
	
	local xPlayer  = ESX.GetPlayerFromId(_source)
			
	if xPlayer.getInventoryItem('kemija').count >= 2 then
		if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
			if xPlayer.getInventoryItem('LSD').count < 10*2 then 
				xPlayer.removeInventoryItem('kemija', 2) 
				xPlayer.addInventoryItem('LSD', 1) 
				cb(true)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Nemate vise prostora za LSD')
				cb(false)
			end
		else
			if xPlayer.getInventoryItem('LSD').count < 10 then 
				xPlayer.removeInventoryItem('kemija', 2) 
				xPlayer.addInventoryItem('LSD', 1) 
				cb(true)
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Nemate vise prostora za LSD')
				cb(false)
			end
		end
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Nemate dosta kemije za preraditi u LSD')
		cb(false)
	end
end)



