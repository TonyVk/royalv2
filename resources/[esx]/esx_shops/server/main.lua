ESX             = nil
local ShopItems = {}

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
end)

ESX.RegisterServerCallback('esx_shops:requestDBItems', function(source, cb)
	cb(ShopItems)
end)

ESX.RegisterServerCallback('esx_shops:DajDostupnost', function(source, cb, store)
	local result = MySQL.Sync.fetchAll('SELECT owner FROM shops2 WHERE store = @store', {
		['@store'] = store
	})
	if result[1].owner == nil then
		cb(1)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_shops:DajSef', function(source, cb, store)
	local result = MySQL.Sync.fetchAll('SELECT sef FROM shops2 WHERE store = @store', {
		['@store'] = store
	})
	cb(result[1].sef)
end)

ESX.RegisterServerCallback('esx_shops:DalJeVlasnik', function(source, cb, zona)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT store FROM shops2 WHERE owner = @id AND store = @st', {
		['@id'] = xPlayer.identifier,
		['@st'] = zona
	})
	if result[1] == nil then
		cb(0)
	else
		cb(1)
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
end

RegisterServerEvent('esx_shops:ProdajFirmu')
AddEventHandler('esx_shops:ProdajFirmu', function(firma)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(1000000)
	MySQL.Async.execute('UPDATE shops2 SET `owner` = null WHERE store = @st', {
		['@st'] = firma
	})
	TriggerClientEvent('esx:showNotification', _source, "Uspjesno ste prodali trgovinu!")
	TriggerClientEvent("esx_shops:ReloadBlip", _source)
end)

RegisterServerEvent('esx_shops:OduzmiFirmi')
AddEventHandler('esx_shops:OduzmiFirmi', function(firma, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	OduzmiFirmi(firma, amount)
	xPlayer.addMoney(amount)
end)

RegisterServerEvent('ducan:piku')
AddEventHandler('ducan:piku', function(itemName, amount, zone, id)
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
			price = ShopItems[zone][i].price
			itemLabel = ShopItems[zone][i].label
			break
		end
	end

	price = price * amount

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		-- can the player carry the said amount of x item?
		if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
		else
			xPlayer.removeMoney(price)
			DajFirmi(zone..id, price/2)
			xPlayer.addInventoryItem(itemName, amount)
			TriggerClientEvent('esx:showNotification', _source, _U('bought', amount, itemLabel, ESX.Math.GroupDigits(price)))
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)
