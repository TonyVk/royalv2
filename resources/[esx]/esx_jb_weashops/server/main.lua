ESX               = nil
local ItemsLabels = {}
local GunShopPrice = Config.EnableClip.GunShop.Price
local GunShopLabel = Config.EnableClip.GunShop.Label

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function LoadLicenses (source)
  TriggerEvent('esx_license:getLicenses', source, function (licenses)
    TriggerClientEvent('esx_weashop:loadLicenses', source, licenses)
  end)
end

if Config.EnableLicense == true then
  AddEventHandler('esx:playerLoaded', function (source)
    LoadLicenses(source)
  end)
end

RegisterServerEvent('oruzje:dajgalicenca')
AddEventHandler('oruzje:dajgalicenca', function (zona)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.get('money') >= Config.LicensePrice then
    xPlayer.removeMoney(Config.LicensePrice)

    TriggerEvent('esx_license:addLicense', _source, 'weapon', function ()
      LoadLicenses(_source)
    end)
	
	TriggerClientEvent("oruzje:OtvoriMenu", _source, zona)
  else
    TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
  end
end)

ESX.RegisterServerCallback('esx_gun:DajDostupnost', function(source, cb, store)
	local result = MySQL.Sync.fetchAll('SELECT owner FROM weashops2 WHERE name = @store', {
		['@store'] = store
	})
	if result[1].owner == nil then
		cb(1)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_gun:DajSef', function(source, cb, store)
	local result = MySQL.Sync.fetchAll('SELECT sef FROM weashops2 WHERE name = @store', {
		['@store'] = store
	})
	cb(result[1].sef)
end)

ESX.RegisterServerCallback('esx_gun:DalJeVlasnik', function(source, cb, zona)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT name FROM weashops2 WHERE owner = @id AND name = @st', {
		['@id'] = xPlayer.identifier,
		['@st'] = zona
	})
	if result[1] == nil then
		cb(0)
	else
		cb(1)
	end
end)

RegisterServerEvent('weapon:piku2')
AddEventHandler('weapon:piku2', function(zona, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	-- can the player afford this item?
	if xPlayer.getMoney() >= 5000000 then
		xPlayer.removeMoney(5000000)
		local store = zona..id
		MySQL.Async.execute('UPDATE weashops2 SET `owner` = @identifier WHERE name = @store', {
			['@identifier'] = xPlayer.identifier,
			['@store'] = store
		})
		TriggerClientEvent('esx:showNotification', _source, "Kupili ste GunShop za $5000000")
		TriggerClientEvent("esx_gun:ReloadBlip", _source)
	else
		local missingMoney = 5000000 - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)

function DajFirmi(id, price)
	local result = MySQL.Sync.fetchAll('SELECT sef FROM weashops2 WHERE name = @st', {
		['@st'] = id
	})
	local cij = result[1].sef+price
	MySQL.Async.execute('UPDATE weashops2 SET `sef` = @se WHERE name = @st', {
		['@se'] = cij,
		['@st'] = id
	})
end

function OduzmiFirmi(id, price)
	local result = MySQL.Sync.fetchAll('SELECT sef FROM weashops2 WHERE name = @st', {
		['@st'] = id
	})
	local cij = result[1].sef-price
	MySQL.Async.execute('UPDATE weashops2 SET `sef` = @se WHERE name = @st', {
		['@se'] = cij,
		['@st'] = id
	})
end

RegisterServerEvent('esx_gun:ProdajFirmu')
AddEventHandler('esx_gun:ProdajFirmu', function(firma)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(2500000)
	MySQL.Async.execute('UPDATE weashops2 SET `owner` = null WHERE name = @st', {
		['@st'] = firma
	})
	TriggerClientEvent('esx:showNotification', _source, "Uspjesno ste prodali GunShop!")
	TriggerClientEvent("esx_gun:ReloadBlip", _source)
end)

RegisterServerEvent('esx_gun:OduzmiFirmi')
AddEventHandler('esx_gun:OduzmiFirmi', function(firma, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	OduzmiFirmi(firma, amount)
	xPlayer.addMoney(amount)
end)


ESX.RegisterServerCallback('esx_weashop:requestDBItems', function(source, cb)

  MySQL.Async.fetchAll(
    'SELECT * FROM weashops',
    {},
    function(result)

      local shopItems  = {}

      for i=1, #result, 1 do

        if shopItems[result[i].name] == nil then
          shopItems[result[i].name] = {}
        end

        table.insert(shopItems[result[i].name], {
          name  = result[i].item,
          price = result[i].price,
          label = ESX.GetWeaponLabel(result[i].item)
        })
      end
	  
	  if Config.EnableClipGunShop == true then
		table.insert(shopItems["GunShop"], {
          name  = "clip",
          price = GunShopPrice,--Config.EnableClip.GunShop.Price,
          label = GunShopLabel--Config.EnableClip.GunShop.label
        })
		end
      cb(shopItems)

    end
  )
  LoadLicenses(source)
end)

RegisterServerEvent('wesh:KuPi2')
AddEventHandler('wesh:KuPi2', function(id, zone, ide)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 700 then
		if id == 1 then
			xPlayer.addWeaponComponent("WEAPON_PISTOL", "clip_extended")
			TriggerClientEvent('esx:showNotification', _source, "Kupili ste extended spremnik za 700$!")
		elseif id == 2 then
			xPlayer.addWeaponComponent("WEAPON_CARBINERIFLE", "clip_extended")
			TriggerClientEvent('esx:showNotification', _source, "Kupili ste extended spremnik za 700$!")
		elseif id == 3 then
			xPlayer.addWeaponComponent("WEAPON_PISTOL", "suppressor")
			TriggerClientEvent('esx:showNotification', _source, "Kupili ste prigusivac za 700$!")
		end
		xPlayer.removeMoney(700)
		DajFirmi(zone..ide, 350)
	else
		TriggerClientEvent('esx:showNotification', _source, "Nemate dovoljno novca!")
	end
end)

RegisterServerEvent('wesh:KuPi')
AddEventHandler('wesh:KuPi', function(itemName, price, zone, id)

  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)
  local account = xPlayer.getAccount('black_money')

  if zone=="BlackWeashop" then
    if account.money >= price then
		if itemName == "clip" then
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. "sarzer")
		else
			xPlayer.addWeapon(itemName, 42)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetWeaponLabel(itemName))
		end
		xPlayer.removeAccountMoney('black_money', price)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough_black'))
	end

  else if xPlayer.get('money') >= price then
		if itemName == "clip" then
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. "chargeur")
		else
			
			xPlayer.addWeapon(itemName, 42)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetWeaponLabel(itemName))
		end
		xPlayer.removeMoney(price)
		DajFirmi(zone..id, price/2)
  else
    TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
  end
  end

end)

-- thx to Pandorina for script
RegisterServerEvent('esx_weashop:remove')
AddEventHandler('esx_weashop:remove', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('clip', 1)
end)

ESX.RegisterUsableItem('clip', function(source)
	TriggerClientEvent('esx_weashop:clipcli', source)
end)
