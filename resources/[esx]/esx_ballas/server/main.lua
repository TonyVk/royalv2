ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'ballas', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'ballas', 'Ballas', 'society_ballas', 'society_ballas', 'society_ballas', {type = 'public'})

RegisterServerEvent('esx_ballasjob:SyncajIm')
AddEventHandler('esx_ballasjob:SyncajIm', function(id, Dostava, Kombi)
	TriggerClientEvent("esx_ballasjob:Syncam", -1, id, Dostava, Kombi)
end)

RegisterServerEvent('esx_ballasjob:ResetSveStack')
AddEventHandler('esx_ballasjob:ResetSveStack', function(id)
	TriggerClientEvent("esx_ballasjob:ResetajGa", -1, id)
end)

RegisterServerEvent('esx_ballasjob:DajOruzje')
AddEventHandler('esx_ballasjob:DajOruzje', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('ball:zapljeni8')
AddEventHandler('ball:zapljeni8', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label

    targetXPlayer.removeInventoryItem(itemName, amount)
    sourceXPlayer.addInventoryItem(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

  end

  if itemType == 'item_account' then

    targetXPlayer.removeMoney(amount)
    sourceXPlayer.addMoney(amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

end)

RegisterServerEvent('esx_ballasjob:DajImPare')
AddEventHandler('esx_ballasjob:DajImPare', function()
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ballas', function(account)
		account.addMoney(6500)
	end)
end)


RegisterServerEvent('esx_ballasjob:ZaveziGa')
AddEventHandler('esx_ballasjob:ZaveziGa', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ballas' then
		TriggerClientEvent('esx_ballasjob:VeziGa', target)
	else
		print(('esx_ballas: %s attempted to handcuff a player (not ballas)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ballasjob:VuciMe')
AddEventHandler('esx_ballasjob:VuciMe', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ballas' then
		TriggerClientEvent('esx_ballasjob:VuciGa', target, _source)
	else
		print(('esx_ballas: %s attempted to drag a player (not ballas)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ballasjob:StrpajUVozilo')
AddEventHandler('esx_ballasjob:StrpajUVozilo', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ballas' then
		TriggerClientEvent('esx_ballasjob:StrpajGa', target)
	else
		print(('esx_ballas: %s attempted to put in vehicle a player (not ballas)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ballasjob:VadiIzVozila')
AddEventHandler('esx_ballasjob:VadiIzVozila', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ballas' then
		TriggerClientEvent('esx_ballasjob:VadiGa', target)
	else
		print(('esx_ballas: %s attempted to get out of vehicle a player (not ballas)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ballasjob:MakniImGa')
AddEventHandler('esx_ballasjob:MakniImGa', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, "Greska!")
    end

  end)

end)

RegisterServerEvent('esx_ballasjob:getStockItem')
AddEventHandler('esx_ballasjob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
	  TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

  end)

end)

RegisterServerEvent('esx_ballasjob:putStockItems')
AddEventHandler('esx_ballasjob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)

    local item = xPlayer.getInventoryItem(itemName)

    if item.count >= 0 and item.count >= count then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

function DodajMarimahovinu()
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)
		inventory.addItem("cannabis", 5)
	end)
	SetTimeout(3600000, DodajMarimahovinu)
end

ESX.RegisterServerCallback('esx_ballasjob:getOtherPlayerData', function(source, cb, target)

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

ESX.RegisterServerCallback('esx_ballasjob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types_grove WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_ballasjob:getVehicleInfos', function(source, cb, plate)

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

ESX.RegisterServerCallback('esx_ballasjob:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_ballas', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_ballasjob:addArmoryWeapon', function(source, cb, weaponName, am)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_ballas', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
		weapons[i].ammo = weapons[i].ammo+am
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1,
		ammo = am
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_ballasjob:removeArmoryWeapon', function(source, cb, weaponName, am)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, am)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_ballas', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
		weapons[i].ammo = (weapons[i].ammo > 0 and weapons[i].ammo - am or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0,
		ammo = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)


ESX.RegisterServerCallback('ball:piku', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ballas', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)
end)

ESX.RegisterServerCallback('esx_ballasjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_ballasjob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

SetTimeout(3600000, DodajMarimahovinu)