ESX             = nil
local ShopItems = {}
local Shopovi = {}
local NoveCijene = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM shops LEFT JOIN items ON items.name = shops.item', {}, function(shopResult)
		for i=1, #shopResult, 1 do
			if shopResult[i].name then
				if ShopItems[shopResult[i].store] == nil then
					ShopItems[shopResult[i].store] = {}
				end

				if shopResult[i].limit == -1 then
					shopResult[i].limit = 30
				end

				table.insert(ShopItems[shopResult[i].store], {
					label = shopResult[i].label,
					item  = shopResult[i].item,
					price = shopResult[i].price,
					limit = shopResult[i].limit
				})
			else
				print(('esx_shops: invalid item "%s" found!'):format(shopResult[i].item))
			end
		end
	end)
	MySQL.Async.fetchAll('SELECT store, owner, sef FROM shops2', {}, function(result)
		for i=1, #result, 1 do
			table.insert(Shopovi, { store = result[i].store, owner = result[i].owner, sef = result[i].sef })
		end
	end)
	MySQL.Async.fetchAll('SELECT trgovina, item, cijena FROM shops_itemi', {}, function(result)
		for i=1, #result, 1 do
			table.insert(NoveCijene, { store = result[i].trgovina, item = result[i].item, cijena = result[i].cijena })
		end
	end)
end)

ESX.RegisterServerCallback('esx_shops:requestDBItems', function(source, cb)
	cb(ShopItems, NoveCijene)
end)

ESX.RegisterServerCallback('esx_shops:DajDostupnost', function(source, cb, store)
	local naso = false
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == store then
			if Shopovi[i].owner == nil then
				cb(1)
				naso = true
				break
			end
		end
	end
	if not naso then
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_shops:DajSef', function(source, cb, store)
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == store then
			cb(Shopovi[i].sef)
			break
		end
	end
end)

ESX.RegisterServerCallback('esx_shops:DalJeVlasnik', function(source, cb, zona)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local naso = false
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == zona and Shopovi[i].owner == xPlayer.identifier then
			cb(1)
			naso = true
			break
		end
	end
	if not naso then
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_shops:DajBrojTrgovina', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local br = 0
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].owner == xPlayer.identifier then
			br = br+1
		end
	end
	cb(br)
end)

RegisterServerEvent('esx_shops:PromjeniCijenu')
AddEventHandler('esx_shops:PromjeniCijenu', function(store, ime, item, cijena)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local mere = false
	local ciji = 0
	
	for i=1, #ShopItems[store], 1 do
		if ShopItems[store][i].item == item then
			ciji = ShopItems[store][i].price
			if cijena >= ShopItems[store][i].price then
				mere = true
			end
			break
		end
	end

	if mere then
		local pronaso = false
		for i=1, #NoveCijene, 1 do
			if NoveCijene[i] ~= nil then
				if NoveCijene[i].item == item and NoveCijene[i].store == ime then
					pronaso = true
					NoveCijene[i].cijena = cijena
					break
				end
			end
		end
		if not pronaso then
			table.insert(NoveCijene, { store = ime, item = item, cijena = cijena })
		end
		
		TriggerClientEvent("esx_shops:UpdateCijene", -1, NoveCijene)
		
		MySQL.Async.fetchScalar('SELECT item FROM shops_itemi WHERE trgovina = @trg AND item = @item', {
			['@trg'] = ime,
			['@item'] = item
		}, function(result)
			if result == nil then
				MySQL.Async.execute('INSERT INTO shops_itemi (trgovina, item, cijena) VALUES (@trg, @it, @cij)',{
					['@trg'] = ime,
					['@it'] = item,
					['@cij'] = cijena
				})
			else
				MySQL.Async.execute('UPDATE shops_itemi SET `cijena` = @cij WHERE trgovina = @store AND item = @item', {
					['@cij'] = cijena,
					['@store'] = ime,
					['@item'] = item
				})
			end
		end)
		
		xPlayer.showNotification("Uspjesno ste promjenili cijenu proizvoda na $"..cijena)
	else
		xPlayer.showNotification("Greska! Cijena mora biti veca ili jednaka $"..ciji)
	end
end)

RegisterServerEvent('ducan:piku2')
AddEventHandler('ducan:piku2', function(zona, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	-- can the player afford this item?
	if xPlayer.getMoney() >= 2000000 then
		xPlayer.removeMoney(2000000)
		local store = zona..id
		MySQL.Async.execute('UPDATE shops2 SET `owner` = @identifier WHERE store = @store', {
			['@identifier'] = xPlayer.identifier,
			['@store'] = store
		})
		TriggerClientEvent('esx:showNotification', _source, "Kupili ste trgovinu za $2000000")
		TriggerClientEvent("esx_shops:ReloadBlip", _source)
		for i=1, #Shopovi, 1 do
			if Shopovi[i] ~= nil and Shopovi[i].store == store then
				Shopovi[i].owner = xPlayer.identifier
				break
			end
		end
	else
		local missingMoney = 2000000 - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)

function DajFirmi(id, price)
	local result = MySQL.Sync.fetchAll('SELECT sef FROM shops2 WHERE store = @st', {
		['@st'] = id
	})
	local cij = result[1].sef+price
	MySQL.Async.execute('UPDATE shops2 SET `sef` = @se WHERE store = @st', {
		['@se'] = cij,
		['@st'] = id
	})
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == id then
			Shopovi[i].sef = Shopovi[i].sef+price
			break
		end
	end
end

function OduzmiFirmi(id, price)
	local result = MySQL.Sync.fetchAll('SELECT sef FROM shops2 WHERE store = @st', {
		['@st'] = id
	})
	local cij = result[1].sef-price
	MySQL.Async.execute('UPDATE shops2 SET `sef` = @se WHERE store = @st', {
		['@se'] = cij,
		['@st'] = id
	})
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == id then
			Shopovi[i].sef = Shopovi[i].sef-price
			break
		end
	end
end

RegisterServerEvent('esx_shops:ProdajFirmu')
AddEventHandler('esx_shops:ProdajFirmu', function(firma)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(1000000)
        local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio $1000000"
	TriggerEvent("SpremiLog", por)
	MySQL.Async.execute('UPDATE shops2 SET `owner` = null WHERE store = @st', {
		['@st'] = firma
	})
	TriggerClientEvent('esx:showNotification', _source, "Uspjesno ste prodali trgovinu!")
	TriggerClientEvent("esx_shops:ReloadBlip", _source)
	for i=1, #Shopovi, 1 do
		if Shopovi[i] ~= nil and Shopovi[i].store == firma then
			Shopovi[i].owner = nil
			break
		end
	end
end)

RegisterServerEvent('esx_shops:OduzmiFirmi')
AddEventHandler('esx_shops:OduzmiFirmi', function(firma, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	OduzmiFirmi(firma, amount)
	xPlayer.addMoney(amount)
        local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio $"..amount
	TriggerEvent("SpremiLog", por)
end)

RegisterServerEvent('ducan:piku')
AddEventHandler('ducan:piku', function(itemName, amount, zone, id, torba)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	amount = ESX.Math.Round(amount)

	-- is the player trying to exploit?
	if amount < 0 then
		print('esx_shops: ' .. xPlayer.identifier .. ' attempted to exploit the shop!')
		return
	end

	-- get price
	local price = 0
	local itemLabel = ''
	
	for i=1, #ShopItems[zone], 1 do
		if ShopItems[zone][i].item == itemName then
			if #NoveCijene > 0 then
				local naso = false
				for j=1, #NoveCijene, 1 do
					if NoveCijene[j].store == (zone..id) and NoveCijene[j].item == itemName then
						naso = true
						price = NoveCijene[j].cijena
						itemLabel = ShopItems[zone][i].label
						break
					end
				end
				if not naso then
					price = ShopItems[zone][i].price
					itemLabel = ShopItems[zone][i].label
				end
				break
			else
				price = ShopItems[zone][i].price
				itemLabel = ShopItems[zone][i].label
				break
			end
		end
	end

	price = price * amount

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		-- can the player carry the said amount of x item?
		if torba then
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit*2 then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				xPlayer.removeMoney(price)
				DajFirmi(zone..id, price/2)
				xPlayer.addInventoryItem(itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('bought', amount, itemLabel, ESX.Math.GroupDigits(price)))
				local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item "..itemName.." x "..amount
				TriggerEvent("SpremiLog", por)
			end
		else
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				xPlayer.removeMoney(price)
				DajFirmi(zone..id, price/2)
				xPlayer.addInventoryItem(itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('bought', amount, itemLabel, ESX.Math.GroupDigits(price)))
				local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item "..itemName.." x "..amount
				TriggerEvent("SpremiLog", por)
			end
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)
