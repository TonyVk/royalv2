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

RegisterCommand("youtube", function(source, args, rawCommandString)
	local ObjID = NetworkGetEntityFromNetworkId(Sadnice[2].NetID)
	DeleteEntity(ObjID)
end, false)

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
					Wait(100)
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

RegisterServerEvent('trava:MakniBranje')
AddEventHandler('trava:MakniBranje', function(nid)
	TriggerClientEvent("trava:NemosBrati", -1, nid)
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
				table.remove(Sadnice, i)
				local Temp = {}
				for a=1, #Sadnice, 1 do
					if Sadnice[a] ~= nil and Sadnice[a].ID == src then
						local ObjID = NetworkGetEntityFromNetworkId(Sadnice[a].NetID)
						if DoesEntityExist(ObjID) then
							local coord = GetEntityCoords(ObjID)
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

RegisterServerEvent('trava:PonovoKreiraj')
AddEventHandler('trava:PonovoKreiraj', function(nid, co)
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			if Sadnice[i].NetID == nid then
				local ObjID = NetworkGetEntityFromNetworkId(nid)
				if DoesEntityExist(ObjID) then
					DeleteEntity(ObjID)
				end
				local stanje = Sadnice[i].Stanje
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
				while not DoesEntityExist(Marih) do
					Wait(100)
				end
				local src = Sadnice[i].ID
				table.remove(Sadnice, i)
				local netid = NetworkGetNetworkIdFromEntity(Marih)
				TriggerClientEvent("trava:NoviNetID", -1, nid, netid, stanje)
				table.insert(Sadnice, {ID = src, Objekt = Marih, Stanje = stanje, NetID = netid})
				break
			end
		end
	end
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
					local mara = "bkr_prop_weed_01_small_01a"
					local Marih
					Marih = CreateObjectNoOffset(GetHashKey(mara), playerCoords.x,  playerCoords.y,  playerCoords.z-1.0,true,false)
					while not DoesEntityExist(Marih) do
						Wait(100)
					end
					local netid = NetworkGetNetworkIdFromEntity(Marih)
					local xe,ye,ze = table.unpack(playerCoords)
					local korde = vector3(xe,ye,ze-1.0)
					table.insert(Sadnice, {ID = src, Objekt = Marih, Stanje = 1, NetID = netid})
					TriggerClientEvent("trava:EoTiNetID", -1, netid, korde, 1)
					TriggerClientEvent("trava:PratiRast", src, netid, 1)
					local Temp = {}
					for i=1, #Sadnice, 1 do
						if Sadnice[i] ~= nil and Sadnice[i].ID == src then
							local ObjID = NetworkGetEntityFromNetworkId(Sadnice[i].NetID)
							if DoesEntityExist(ObjID) then
								local coord = GetEntityCoords(ObjID)
								table.insert(Temp, {Stanje = Sadnice[i].Stanje, Koord = coord})
							end
						end
					end
					MySQL.Async.execute('UPDATE users SET sadnice = @sad WHERE identifier = @id', {
						['@sad'] = json.encode(Temp),
						['@id'] = xPlayer.identifier
					})
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
	local korda = vector3(co.x, co.y, co.z)
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
	while not DoesEntityExist(Marih) do
		Wait(100)
	end
	local netid = NetworkGetNetworkIdFromEntity(Marih)
	table.insert(Sadnice, {ID = src, Objekt = Marih, Stanje = stanje, NetID = netid})
	TriggerClientEvent("trava:EoTiNetID", -1, netid, korda, stanje)
	TriggerClientEvent("trava:PratiRast", src, netid, stanje)
end

function Izrasti(nid, src, stanje) 
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
			if Sadnice[i].ID == src and Sadnice[i].NetID == nid then
				if DoesEntityExist(ObjID) then
					coord = GetEntityCoords(ObjID)
					DeleteEntity(ObjID)
					Sadnice[i].Stanje = stanje
					local Marih
					Marih = CreateObjectNoOffset(GetHashKey(mara), coord.x,  coord.y,  coord.z,true,false)
					while not DoesEntityExist(Marih) do
						Wait(100)
					end
					Sadnice[i].Objekt = Marih
					local netid = NetworkGetNetworkIdFromEntity(Marih)
					Sadnice[i].NetID = netid
					TriggerClientEvent("trava:PromjeniNetID", -1, nid, netid, stanje)
					if stanje ~= 3 then
						TriggerClientEvent("trava:PratiRast", src, netid, stanje)
					else
						xPlayer.showNotification("[Marihuana] Stabljika je spremna za branje!")
					end
					local Temp = {}
					for a=1, #Sadnice, 1 do
						if Sadnice[a] ~= nil and Sadnice[a].ID == src then
							local ObjID = NetworkGetEntityFromNetworkId(Sadnice[a].NetID)
							if DoesEntityExist(ObjID) then
								local coord = GetEntityCoords(ObjID)
								table.insert(Temp, {Stanje = stanje, Koord = coord})
							end
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
end

RegisterServerEvent('esx_drugs:cancelProcessing')
AddEventHandler('esx_drugs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
	for i=#Sadnice, 1, -1 do
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