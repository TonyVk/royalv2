ESX = nil

local Mete = {}
local Imena = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'Hitman', Config.MaxInService)
end

function DohvatiMete()
	MySQL.Async.fetchAll('SELECT * FROM mete', {}, function(result)
		if result[1] ~= nil then
			for i=1, #result, 1 do
				MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = result[i].identifier }, function(result2)
					Mete[result[i].ime] = result[i].cijena
					Imena[result[i].ime] = result2[1].firstname.." "..result2[1].lastname
				end)
			end
		end
	end)
	TriggerClientEvent("hitman:UpdateMete", -1, Mete, Imena)
end

MySQL.ready(function ()
	DohvatiMete()
end)

-- TriggerEvent('esx_phone:registerNumber', 'Hitman', _U('alert_Hitman'), true, true)
TriggerEvent('esx_society:registerSociety', 'hitman', 'Hitman', 'society_hitman', 'society_hitman', 'society_hitman', {type = 'public'})

RegisterServerEvent('esx_hitmanjob:giveWeapon')
AddEventHandler('esx_hitmanjob:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

function DajRandomMetu()
	local xPlayers 	= ESX.GetPlayers()
	if #xPlayers ~= 0 then
		local rand = math.random(#xPlayers)
		local xPlayer = ESX.GetPlayerFromId(xPlayers[rand])
		TriggerEvent("hitman:SaljiCifru2", xPlayer.source, 10000)
	end
	SetTimeout(5400000, DajRandomMetu)
end

DajRandomMetu()

RegisterServerEvent('hitman:UmroLik')
AddEventHandler('hitman:UmroLik', function(kid)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local kPlayer = ESX.GetPlayerFromId(kid)
	local jIme = kPlayer.getJob().name
	local ime = GetPlayerName(_source)
	if jIme == "hitman" and Mete[ime] ~= nil and _source ~= kid then
		MySQL.Sync.execute("DELETE FROM mete WHERE `identifier` = @identifier", {
			['@identifier'] = xPlayer.identifier
		})
		local price = math.floor(Mete[ime]/2)
		kPlayer.addMoney(price)
		Mete[ime] = nil
		Imena[ime] = nil
		TriggerClientEvent('esx:showNotification', kid, "Dobili ste $"..price.." za ubojstvo!")
		TriggerClientEvent('esx:showNotification', _source, 'Ubijeni ste od strane hitmana!')
		local societyAccount = nil
		TriggerEvent('esx_addonaccount:getSharedAccount', "society_hitman", function(account)
			societyAccount = account
		end)
		societyAccount.addMoney(price)
		TriggerClientEvent("hitman:UpdateMete", -1, Mete, Imena)
	end
end)

RegisterServerEvent('hitman:SaljiCifru2')
AddEventHandler('hitman:SaljiCifru2', function(idic, cije)
	local id = tonumber(idic)
	local ime = GetPlayerName(id)
	local cijena = math.floor(tonumber(cije))
	if Mete[ime] ~= nil then
		Mete[ime] = Mete[ime]+cijena
	else
		Mete[ime] = cijena
	end
	GetRPName(id, function(Firstname, Lastname)
		local imea = Firstname.." "..Lastname
		Imena[ime] = imea
		TriggerClientEvent("hitman:SaljiMete", -1, id, Mete[ime], Mete, Imena)
	end)
	local xPlayer = ESX.GetPlayerFromId(id)
	MySQL.Async.fetchAll('SELECT cijena FROM mete WHERE identifier = @iden', {
			['@iden'] = xPlayer.identifier
		}, function(result)
			if result[1] ~= nil then
				MySQL.Async.execute('UPDATE mete SET cijena = @cij WHERE identifier = @identifier', {
					['@cij']     = cijena+result[1].cijena,
					['@identifier'] = xPlayer.identifier
				})
			else
				MySQL.Async.execute('INSERT INTO mete (identifier, cijena, ime) VALUES (@iden, @cij, @im)',
				{
					['@iden'] = xPlayer.identifier,
					['@cij'] = cijena,
					['@im'] = ime
				})
			end
	end)
end)

RegisterServerEvent('hitman:SaljiCifru')
AddEventHandler('hitman:SaljiCifru', function(idic, cije)
	local _source = source
	local id = tonumber(idic)
	local ime = GetPlayerName(id)
	local cijena = math.floor(tonumber(cije))
	local xPlayer = ESX.GetPlayerFromId(_source)
	local dPlayer = ESX.GetPlayerFromId(id)
	if xPlayer.getMoney() >= cijena then
		MySQL.Async.fetchAll('SELECT cijena FROM mete WHERE identifier = @iden', {
			['@iden'] = dPlayer.identifier
		}, function(result)
			if result[1] ~= nil then
				MySQL.Async.execute('UPDATE mete SET cijena = @cij WHERE identifier = @identifier', {
					['@cij']     = cijena+result[1].cijena,
					['@identifier'] = dPlayer.identifier
				})
			else
				MySQL.Async.execute('INSERT INTO mete (identifier, cijena, ime) VALUES (@iden, @cij, @im)',
				{
					['@iden'] = dPlayer.identifier,
					['@cij'] = cijena,
					['@im'] = ime
				})
			end
		end)
		xPlayer.removeMoney(cijena)
		if Mete[ime] ~= nil then
			Mete[ime] = Mete[ime]+cijena
		else
			Mete[ime] = cijena
		end
		GetRPName(id, function(Firstname, Lastname)
			local imea = Firstname.." "..Lastname
			Imena[ime] = imea
			TriggerClientEvent('esx:showNotification', _source, "Uplatili ste ubojstvo!")
			TriggerClientEvent("hitman:SaljiMete", -1, id, Mete[ime], Mete, Imena)
		end)
	else
		TriggerClientEvent('esx:showNotification', _source, "Nemate dovoljno novca!")
	end
end)

function GetRPName2(iden, data)
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = iden }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

RegisterServerEvent('esx_hitmanjob:confiscatePlayerItem')
AddEventHandler('esx_hitmanjob:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label

    targetXPlayer.removeInventoryItem(itemName, amount)
    sourceXPlayer.addInventoryItem(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

end)

RegisterServerEvent('esx_hitmanjob:handcuff')
AddEventHandler('esx_hitmanjob:handcuff', function(target)
  TriggerClientEvent('esx_hitmanjob:handcuff', target)
end)

RegisterServerEvent('esx_hitmanjob:drag')
AddEventHandler('esx_hitmanjob:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_hitmanjob:drag', target, _source)
end)

RegisterServerEvent('esx_hitmanjob:putInVehicle')
AddEventHandler('esx_hitmanjob:putInVehicle', function(target)
  TriggerClientEvent('esx_hitmanjob:putInVehicle', target)
end)

RegisterServerEvent('esx_hitmanjob:OutVehicle')
AddEventHandler('esx_hitmanjob:OutVehicle', function(target)
    TriggerClientEvent('esx_hitmanjob:OutVehicle', target)
end)

RegisterServerEvent('esx_hitmanjob:getStockItem')
AddEventHandler('esx_hitmanjob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_hitman', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_hitmanjob:putStockItems')
AddEventHandler('esx_hitmanjob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_hitman', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('hitman:DohvatiMete', function(source, cb)
	local data = {
		mete = Mete,
		imena = Imena
	}
	cb(data)
end)

ESX.RegisterServerCallback('esx_hitmanjob:getOtherPlayerData', function(source, cb, target)

  if Config.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
    }

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', source, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', _source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

ESX.RegisterServerCallback('esx_hitmanjob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types_Hitman WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_hitmanjob:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_hitmanjob:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_hitman', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_hitmanjob:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_hitman', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_hitmanjob:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_hitman', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)


ESX.RegisterServerCallback('esx_hitmanjob:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_hitman', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_hitmanjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_hitman', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_hitmanjob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)