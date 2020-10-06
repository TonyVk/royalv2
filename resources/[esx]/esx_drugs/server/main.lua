ESX = nil
local playersProcessingCannabis = {}
local Droga = {}
local Sadnice = {}
local Kuce = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('droge:prodajih')
AddEventHandler('droge:prodajih', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price
	if itemName ~= "seed" then
		price = Config.DrugDealerItems[itemName]
		price = math.ceil(price * amount)
	else 
		price = 200
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
		if xItem.limit ~= -1 and (xItem.count + amount) > xItem.limit then
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Ne stane vam vise sjemena u inventory!")
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(itemName, amount)
		end
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

RegisterNetEvent('kuce:UKuci')
AddEventHandler('kuce:UKuci', function(br)
	local src = source
	Kuce[src] = br
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
	TriggerClientEvent("trava:VratiSadnice", src, Sadnice)
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
			elseif xCannabis.count < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('weed_processingenough'))
			else
				xPlayer.removeInventoryItem('cannabis', 2)
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

RegisterServerEvent('trava:Izrasti')
AddEventHandler('trava:Izrasti', function(nid, stanje)
	Izrasti(nid, source, stanje)
end)

RegisterServerEvent('trava:ObrisiSadnicu')
AddEventHandler('trava:ObrisiSadnicu', function(nid)
	local ObjID = NetworkGetEntityFromNetworkId(nid)
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			if Sadnice[i].NetID == nid then
				local src = Sadnice[i].ID
				local xPlayer = ESX.GetPlayerFromId(src)
				DeleteEntity(ObjID)
				TriggerClientEvent("trava:MakniBlip", src, nid)
				table.remove(Sadnice, i)
				local Temp = {}
				for a=1, #Sadnice, 1 do
					if Sadnice[a] ~= nil and Sadnice[a].ID == src then
						local ObjeID = NetworkGetEntityFromNetworkId(Sadnice[a].NetID)
						if DoesEntityExist(ObjeID) then
							local coord = GetEntityCoords(ObjeID)
							table.insert(Temp, {Stanje = Sadnice[a].Stanje, Koord = coord})
						end
					end
				end
				MySQL.Async.execute('UPDATE users SET sadnice = @sad WHERE identifier = @id', {
					['@sad'] = json.encode(Temp),
					['@id'] = xPlayer.identifier
				})
				TriggerClientEvent("trava:MakniSadnicu", -1, nid)
				break
			end
		end
	end
end)

RegisterNetEvent('trava:EoTiSadnica')
AddEventHandler('trava:EoTiSadnica', function(nid, stanje)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local ObjID = NetworkGetEntityFromNetworkId(nid)
	table.insert(Sadnice, {ID = src, Objekt = ObjID, Stanje = stanje, NetID = nid})
	local Temp = {}
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil and Sadnice[i].ID == src then
			local ObjeID = NetworkGetEntityFromNetworkId(Sadnice[i].NetID)
			if DoesEntityExist(ObjeID) then
				local coord = GetEntityCoords(ObjeID)
				table.insert(Temp, {Stanje = Sadnice[i].Stanje, Koord = coord})
			end
		end
	end
	MySQL.Async.execute('UPDATE users SET sadnice = @sad WHERE identifier = @id', {
		['@sad'] = json.encode(Temp),
		['@id'] = xPlayer.identifier
	})
end)

function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

function PosadiTravu(src)
	local player = src
	local xPlayer = ESX.GetPlayerFromId(player)
	if Kuce[player] == nil or Kuce[player] == false then
		local ped = GetPlayerPed(player)
		local playerCoords = GetEntityCoords(ped)
		local broj = 0
		local dist = false
		for i=1, #Sadnice, 1 do
			if Sadnice[i] ~= nil then
				local ObjID = NetworkGetEntityFromNetworkId(Sadnice[i].NetID)
				if Sadnice[i].ID == src then
					broj = broj+1
				end
				if DoesEntityExist(ObjID) then
					local kord = GetEntityCoords(ObjID)
					if distanceFrom(kord.x, kord.y, playerCoords.x, playerCoords.y) < 2.0 then
						dist = true
					end
				end
			end
		end
		local xSeed = xPlayer.getInventoryItem('seed')
		local xSaksija = xPlayer.getInventoryItem('saksija')
		local xZemlja = xPlayer.getInventoryItem('zemlja')
		if xSeed.count >= 1 and xSaksija.count >= 1 and xZemlja.count >= 1 then
			if broj < 20 then
				if dist == false then
					xPlayer.removeInventoryItem('seed', 1)
					xPlayer.removeInventoryItem('saksija', 1)
					xPlayer.removeInventoryItem('zemlja', 1)
					TriggerClientEvent("trava:SpawnSadnicu", player, 1)
				else
					xPlayer.showNotification("Preblizu ste drugoj sadnici!")
				end
			else
				xPlayer.showNotification("Vec imate posadjeno 20 sadnica")
			end
		else
			xPlayer.showNotification("Nemate dovoljno sjemena/saksija/zemlje!")
		end
	else
		xPlayer.showNotification("Ne mozete saditi u kuci!")
	end
end

function PosadiTravu2(src, co, stanje)
	TriggerClientEvent("trava:SpawnSadnicu", src, stanje, co)
end

function Izrasti(nid, src, stanje) 
	local xPlayer = ESX.GetPlayerFromId(src)
	local ObjID = NetworkGetEntityFromNetworkId(nid)
	local coord = nil
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			if Sadnice[i].ID == src and Sadnice[i].NetID == nid then
				if DoesEntityExist(ObjID) then
					coord = GetEntityCoords(ObjID)
					DeleteEntity(ObjID)
				end
				table.remove(Sadnice, i)
				TriggerClientEvent("trava:SpawnSadnicu", src, stanje, coord)
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
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil and Sadnice[i].ID == playerID then
			local ObjID = NetworkGetEntityFromNetworkId(Sadnice[i].NetID)
			if DoesEntityExist(ObjID) then
				DeleteEntity(ObjID)
			end
			table.remove(Sadnice, i)
		end
	end
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

ESX.RegisterUsableItem('seed', function(source)
	PosadiTravu(source)
end)