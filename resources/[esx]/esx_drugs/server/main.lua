ESX = nil
local playersProcessingCannabis = {}
local Droga = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('droge:prodajih')
AddEventHandler('droge:prodajih', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price
	if itemName ~= "seed" then
	price = Config.DrugDealerItems[itemName]
	price = math.ceil(price * amount)
	else 
	price = 45
	price = math.ceil(price * amount)
	end
	local xItem = xPlayer.getInventoryItem(itemName)
	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end
	if itemName == "seed" then
		if xPlayer.getMoney() < price then
			TriggerClientEvent('esx:showNotification', source, "Nemate dovoljno novca!")
			return
		end
		xPlayer.removeMoney(price)
		xPlayer.addInventoryItem(itemName, amount)
	else
	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end

	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
		ESX.SavePlayer(xPlayer, function() 
		end)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
	end
end)

ESX.RegisterServerCallback('esx_drugs:buyLicense', function(source, cb, licenseName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local license = Config.LicensePrices[licenseName]

	if license == nil then
		print(('esx_drugs: %s attempted to buy an invalid license!'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.getMoney() >= license.price then
		xPlayer.removeMoney(license.price)

		TriggerEvent('esx_license:addLicense', source, licenseName, function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_drugs:MakniSeed')
AddEventHandler('esx_drugs:MakniSeed', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('seed')
	xPlayer.removeInventoryItem(xItem.name, 1)
end)

RegisterServerEvent('esx_drugs:EoTiKanabisa')
AddEventHandler('esx_drugs:EoTiKanabisa', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('cannabis')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('weed_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

ESX.RegisterServerCallback('esx_drugs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xItem.limit ~= -1 and xItem.count >= xItem.limit then
		cb(false)
	else
		cb(true)
	end
end)

RegisterServerEvent('esx_drugs:PreradiGa')
AddEventHandler('esx_drugs:PreradiGa', function()
	if not playersProcessingCannabis[source] then
		local _source = source

		playersProcessingCannabis[_source] = ESX.SetTimeout(Config.Delays.WeedProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCannabis, xMarijuana = xPlayer.getInventoryItem('cannabis'), xPlayer.getInventoryItem('marijuana')

			if xMarijuana.limit ~= -1 and (xMarijuana.count + 1) >= xMarijuana.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('weed_processingfull'))
			elseif xCannabis.count < 3 then
				TriggerClientEvent('esx:showNotification', _source, _U('weed_processingenough'))
			else
				xPlayer.removeInventoryItem('cannabis', 3)
				xPlayer.addInventoryItem('marijuana', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('weed_processed'))
			end

			playersProcessingCannabis[_source] = nil
		end)
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingCannabis[playerID] then
		ESX.ClearTimeout(playersProcessingCannabis[playerID])
		playersProcessingCannabis[playerID] = nil
	end
end

RegisterServerEvent('esx_drugs:cancelProcessing')
AddEventHandler('esx_drugs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)

ESX.RegisterUsableItem('marijuana', function(source)
	if Droga[source] == nil then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('marijuana', 1)
		TriggerClientEvent('esx_status:remove', source, 'thirst', 100000)
		TriggerClientEvent('esx_drugs:Animacija', source)
		Droga[source] = true
		Wait(10000)
		Droga[source] = nil
	end
end)
