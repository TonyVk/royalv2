ESX = nil
local playersProcessingCannabis = {}
local Droga = {}
local Sadnice = {}

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

AddEventHandler('playerDropped', function()
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil and Sadnice[i].ID == source then
			DeleteEntity(Sadnice[i].Objekt)
			table.remove(Sadnice, i)
			break
		end
	end
end)

RegisterServerEvent('trava:ProvjeriSadnice')
AddEventHandler('trava:ProvjeriSadnice', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll(
      'SELECT sadnice FROM users WHERE identifier = @ident',
      { ['@ident'] = xPlayer.identifier },
      function(result)
        for i=1, #result, 1 do
			if result[i].sadnice ~= "[]" then
				local sadnice = json.decode(result[i].sadnice)
				for a=1, #sadnice do
					PosadiTravu2(src, sadnice[a].Koord, sadnice[a].Stanje)
				end
			end
        end
      end
    )
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

RegisterServerEvent('trava:Posadi')
AddEventHandler('trava:Posadi', function()
	PosadiTravu(source)
end)

RegisterServerEvent('trava:Izrasti')
AddEventHandler('trava:Izrasti', function(nid, stanje)
	Izrati(nid, source, stanje)
end)

RegisterServerEvent('trava:ObrisiSadnicu')
AddEventHandler('trava:ObrisiSadnicu', function(nid)
	local ObjID = NetworkGetEntityFromNetworkId(nid)
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			if Sadnice[i].Objekt == ObjID then
				local src = Sadnice[i].ID
				local xPlayer = ESX.GetPlayerFromId(src)
				DeleteEntity(Sadnice[i].Objekt)
				table.remove(Sadnice, i)
				local Temp = {}
				for i=1, #Sadnice, 1 do
					if Sadnice[i] ~= nil and Sadnice[i].ID == src then
						local coord = GetEntityCoords(Sadnice[i].Objekt)
						table.insert(Temp, {Stanje = Sadnice[i].Stanje, Koord = coord})
					end
				end
				MySQL.Async.execute('UPDATE users SET sadnice = @sad WHERE identifier = @id', {
					['@sad'] = json.encode(Temp),
					['@id'] = xPlayer.identifier
				})
				break
			end
		end
	end
end)

function PosadiTravu(src)
	local broj = 0
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			if Sadnice[i].ID == src then
				broj = broj+1
			end
		end
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	local xSeed = xPlayer.getInventoryItem('seed')
	if xSeed.count >= 1 then
		if broj < 5 then
			xPlayer.removeInventoryItem('seed', 1)
			local mara = "bkr_prop_weed_01_small_01a"
			local player = src
			local ped = GetPlayerPed(player)
			local playerCoords = GetEntityCoords(ped)
			local Marih
			Marih = CreateObjectNoOffset(GetHashKey(mara), playerCoords.x,  playerCoords.y,  playerCoords.z-1.0,true,false)
			table.insert(Sadnice, {ID = src, Objekt = Marih, Stanje = 1})
			Wait(100)
			local netid = NetworkGetNetworkIdFromEntity(Marih)
			TriggerClientEvent("trava:EoTiNetID", -1, netid)
			TriggerClientEvent("trava:PratiRast", src, netid, 1)
			local Temp = {}
			for i=1, #Sadnice, 1 do
				if Sadnice[i] ~= nil and Sadnice[i].ID == src then
					local coord = GetEntityCoords(Sadnice[i].Objekt)
					table.insert(Temp, {Stanje = Sadnice[i].Stanje, Koord = coord})
				end
			end
			MySQL.Async.execute('UPDATE users SET sadnice = @sad WHERE identifier = @id', {
				['@sad'] = json.encode(Temp),
				['@id'] = xPlayer.identifier
			})
		else
			xPlayer.showNotification("Vec imate posadjeno 5 sadnica")
		end
	else
		xPlayer.showNotification("Nemate dovoljno sjemena!")
	end
end

function PosadiTravu2(src, co, stanje)
	local mara
	if stanje == 1 then
		mara = "bkr_prop_weed_01_small_01a"
	elseif stanje == 2 then
		mara = "bkr_prop_weed_med_01a"
	else
		mara = "bkr_prop_weed_lrg_01a"
	end
	local Marih
	Marih = CreateObjectNoOffset(GetHashKey(mara), co.x,  co.y,  co.z,true,false)
	table.insert(Sadnice, {ID = src, Objekt = Marih, Stanje = stanje})
	Wait(100)
	local netid = NetworkGetNetworkIdFromEntity(Marih)
	TriggerClientEvent("trava:EoTiNetID", -1, netid)
	TriggerClientEvent("trava:PratiRast", src, netid, stanje)
end

function Izrati(nid, src, stanje) 
	local xPlayer = ESX.GetPlayerFromId(src)
	local mara
	if stanje == 2 then
		mara = "bkr_prop_weed_med_01a"
	else
		mara = "bkr_prop_weed_lrg_01a"
	end
	local ObjID = NetworkGetEntityFromNetworkId(nid)
	local coord = nil
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			if Sadnice[i].ID == src and Sadnice[i].Objekt == ObjID then
				coord = GetEntityCoords(Sadnice[i].Objekt)
				DeleteEntity(Sadnice[i].Objekt)
				Sadnice[i].Stanje = stanje
				local Marih
				Marih = CreateObjectNoOffset(GetHashKey(mara), coord.x,  coord.y,  coord.z,true,false)
				Sadnice[i].Objekt = Marih
				Wait(100)
				local netid = NetworkGetNetworkIdFromEntity(Marih)
				TriggerClientEvent("trava:PromjeniNetID", -1, nid, netid, stanje)
				if stanje ~= 3 then
					TriggerClientEvent("trava:PratiRast", src, netid, stanje)
				end
				local Temp = {}
				for i=1, #Sadnice, 1 do
					if Sadnice[i] ~= nil and Sadnice[i].ID == src then
						local coord = GetEntityCoords(Sadnice[i].Objekt)
						table.insert(Temp, {Stanje = Sadnice[i].Stanje, Koord = coord})
					end
				end
				MySQL.Async.execute('UPDATE users SET sadnice = @sad WHERE identifier = @id', {
					['@sad'] = json.encode(Temp),
					['@id'] = xPlayer.identifier
				})
				break
			end
		end
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
