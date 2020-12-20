ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'zemunski', Config.MaxInService)
end

-- TriggerEvent('esx_phone:registerNumber', 'zemunski', _U('alert_zemunski'), true, true)
TriggerEvent('esx_society:registerSociety', 'zemunski', 'Zemunski', 'society_zemunski', 'society_zemunski', 'society_zemunski', {type = 'public'})

RegisterServerEvent('esx_zemunski:giveWeapon')
AddEventHandler('esx_zemunski:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterNetEvent('esx_zemunski:ResetirajOruzje')
AddEventHandler('esx_zemunski:ResetirajOruzje', function()
	  TriggerClientEvent("esx_zemunski:ResetOruzja", -1)
end)

RegisterNetEvent('zemunski:SpawnVozilo')
AddEventHandler('zemunski:SpawnVozilo', function(vehicle, co, he)
	local _source = source
	local veh = CreateVehicle(vehicle.model, co.x, co.y, co.z, he, true, false)
	while not DoesEntityExist(veh) do
		Wait(100)
	end
	local netid = NetworkGetNetworkIdFromEntity(veh)
	Wait(500)
	TriggerClientEvent("zemunski:VratiVozilo", _source, netid, vehicle, co)
end)

RegisterNetEvent('mafija:OdeJedan')
AddEventHandler('mafija:OdeJedan', function(plate, pr)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute('DELETE from ukradeni WHERE tablica = @pl', {
		['@pl'] = plate
	}, function(rowsChanged)
	end)
	MySQL.Async.execute('DELETE from owned_vehicles WHERE plate = @pl', {
		['@pl'] = plate
	}, function(rowsChanged)
	end)
	xPlayer.addMoney(pr)
	xPlayer.showNotification("Vozilo je 7 ili vise dana kod vas i dobili ste od njega $"..pr..".")
end)

RegisterNetEvent('mafija:MakniUkraden')
AddEventHandler('mafija:MakniUkraden', function(plate)
	MySQL.Async.execute('DELETE from ukradeni WHERE tablica = @pl', {
		['@pl'] = plate
	}, function(rowsChanged)
	end)
end)

local ZVrijeme = {}
RegisterServerEvent('zemunski:zapljeni6')
AddEventHandler('zemunski:zapljeni6', function(target, itemType, itemName, amount, torba)
	if ZVrijeme ~= nil and ZVrijeme[target] ~= nil then
		if GetGameTimer()-ZVrijeme[target] > 200 then
		  local sourceXPlayer = ESX.GetPlayerFromId(source)
		  local targetXPlayer = ESX.GetPlayerFromId(target)

		  if itemType == 'item_standard' then

			local label = sourceXPlayer.getInventoryItem(itemName).label
			local xItem = sourceXPlayer.getInventoryItem(itemName)
			local xItem2 = targetXPlayer.getInventoryItem(itemName)
			
			if torba then
				if xItem.limit ~= -1 and (xItem.count + amount) > xItem.limit*2 then
					TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Ne stane vam vise "..label.." u inventory!")
				else
					if targetXPlayer ~= nil then
						if xItem2.count >= amount then
							targetXPlayer.removeInventoryItem(itemName, amount)
							sourceXPlayer.addInventoryItem(itemName, amount)
							TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo "..amount.." "..itemName.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
							TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Oduzeli ste ~y~x" .. amount .. ' ' .. label .."~s~ od ~b~" .. targetXPlayer.name)
							TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. "~s~ je oduzeo od vas ~y~x" .. amount .. ' ' .. label )
						end
					end
				end
			else
				if xItem.limit ~= -1 and (xItem.count + amount) > xItem.limit then
					TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Ne stane vam vise "..label.." u inventory!")
				else
					if targetXPlayer ~= nil then
						if xItem2.count >= amount then
							targetXPlayer.removeInventoryItem(itemName, amount)
							sourceXPlayer.addInventoryItem(itemName, amount)
							TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo "..amount.." "..itemName.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
							TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Oduzeli ste ~y~x" .. amount .. ' ' .. label .."~s~ od ~b~" .. targetXPlayer.name)
							TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. "~s~ je oduzeo od vas ~y~x" .. amount .. ' ' .. label )
						end
					end
				end
			end

		  end

		  if itemType == 'item_account' then
			if targetXPlayer.getMoney() >= amount then
				targetXPlayer.removeMoney(amount)
				sourceXPlayer.addMoney(amount)
				TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo $"..amount.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Oduzeli ste ~y~$" .. amount .. "~s~ od ~b~" .. targetXPlayer.name)
				TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. "~s~ je oduzeo od vas ~y~$" .. amount)
			end
		  end

		  if itemType == 'item_weapon' then
			if targetXPlayer.hasWeapon(itemName) then
				targetXPlayer.removeWeapon(itemName)
				sourceXPlayer.addWeapon(itemName, amount)
				TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo oruzje "..itemName.." sa "..amount.." metaka od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Oduzeli ste ~y~x1" .. ESX.GetWeaponLabel(itemName) .. "~s~ od ~b~" .. targetXPlayer.name)
				TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. "~s~ je oduzeo od vas ~y~x1 " .. ESX.GetWeaponLabel(itemName))
			end
		  end
		  ZVrijeme[target] = GetGameTimer()
		end
	else
		  local sourceXPlayer = ESX.GetPlayerFromId(source)
		  local targetXPlayer = ESX.GetPlayerFromId(target)

		  if itemType == 'item_standard' then

			local label = sourceXPlayer.getInventoryItem(itemName).label
			local xItem = sourceXPlayer.getInventoryItem(itemName)
			local xItem2 = targetXPlayer.getInventoryItem(itemName)
			
			if torba then
				if xItem.limit ~= -1 and (xItem.count + amount) > xItem.limit*2 then
					TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Ne stane vam vise "..label.." u inventory!")
				else
					if targetXPlayer ~= nil then
						if xItem2.count >= amount then
							targetXPlayer.removeInventoryItem(itemName, amount)
							sourceXPlayer.addInventoryItem(itemName, amount)
							TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo "..amount.." "..itemName.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
							TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Oduzeli ste ~y~x" .. amount .. ' ' .. label .."~s~ od ~b~" .. targetXPlayer.name)
							TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. "~s~ je oduzeo od vas ~y~x" .. amount .. ' ' .. label )
						end
					end
				end
			else
				if xItem.limit ~= -1 and (xItem.count + amount) > xItem.limit then
					TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Ne stane vam vise "..label.." u inventory!")
				else
					if targetXPlayer ~= nil then
						if xItem2.count >= amount then
							targetXPlayer.removeInventoryItem(itemName, amount)
							sourceXPlayer.addInventoryItem(itemName, amount)
							TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo "..amount.." "..itemName.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
							TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Oduzeli ste ~y~x" .. amount .. ' ' .. label .."~s~ od ~b~" .. targetXPlayer.name)
							TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. "~s~ je oduzeo od vas ~y~x" .. amount .. ' ' .. label )
						end
					end
				end
			end

		  end

		  if itemType == 'item_account' then
			if targetXPlayer.getMoney() >= amount then
				targetXPlayer.removeMoney(amount)
				sourceXPlayer.addMoney(amount)
				TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo $"..amount.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Oduzeli ste ~y~$" .. amount .. "~s~ od ~b~" .. targetXPlayer.name)
				TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. "~s~ je oduzeo od vas ~y~$" .. amount)
			end
		  end

		  if itemType == 'item_weapon' then
			if targetXPlayer.hasWeapon(itemName) then
				targetXPlayer.removeWeapon(itemName)
				sourceXPlayer.addWeapon(itemName, amount)
				TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo oruzje "..itemName.." sa "..amount.." metaka od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Oduzeli ste ~y~x1" .. ESX.GetWeaponLabel(itemName) .. "~s~ od ~b~" .. targetXPlayer.name)
				TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. "~s~ je oduzeo od vas ~y~x1 " .. ESX.GetWeaponLabel(itemName))
			end
		  end
		  ZVrijeme[target] = GetGameTimer()
	end
end)

RegisterServerEvent('esx_zemunski:handcuff')
AddEventHandler('esx_zemunski:handcuff', function(target)
  TriggerClientEvent('esx_zemunski:handcuff', target)
end)

RegisterServerEvent('esx_zemunski:drag')
AddEventHandler('esx_zemunski:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_zemunski:drag', target, _source)
end)

RegisterServerEvent('esx_zemunski:putInVehicle')
AddEventHandler('esx_zemunski:putInVehicle', function(target)
  TriggerClientEvent('esx_zemunski:putInVehicle', target)
end)

RegisterServerEvent('esx_zemunski:OutVehicle')
AddEventHandler('esx_zemunski:OutVehicle', function(target)
    TriggerClientEvent('esx_zemunski:OutVehicle', target)
end)

RegisterServerEvent('esx_zemunski:getStockItem')
AddEventHandler('esx_zemunski:getStockItem', function(itemName, count, torba)

  local xPlayer = ESX.GetPlayerFromId(source)
  local sourceItem = xPlayer.getInventoryItem(itemName)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_zemunski', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
		if torba then
			if sourceItem.limit ~= -1 and (sourceItem.count + count) <= sourceItem.limit*2 then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Ne stane vam vise u inventory!")
			end
		else
			if sourceItem.limit ~= -1 and (sourceItem.count + count) <= sourceItem.limit then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Ne stane vam vise u inventory!")
			end
		end
	else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

  end)

end)

RegisterServerEvent('esx_zemunski:SaljiCrate')
AddEventHandler('esx_zemunski:SaljiCrate', function(cr, par, job, id)
    TriggerClientEvent('esx_zemunski:VratiCrate', -1, cr, par, job, id)
end)

RegisterServerEvent('esx_zemunski:BrisiCrate')
AddEventHandler('esx_zemunski:BrisiCrate', function(id)
    TriggerClientEvent('esx_zemunski:ObrisiCrate', -1, id)
end)

RegisterServerEvent('esx_zemunski:SpremiIme')
AddEventHandler('esx_zemunski:SpremiIme', function(ime, br)
    TriggerClientEvent('esx_zemunski:VratiIme', -1, ime, br)
end)

RegisterServerEvent('esx_zemunski:putStockItems')
AddEventHandler('esx_zemunski:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)
  local sourceItem = xPlayer.getInventoryItem(itemName)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_zemunski', function(inventory)

    local item = inventory.getItem(itemName)

    if sourceItem.count >= count and count > 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. sourceItem.label)

  end)

end)

ESX.RegisterServerCallback('mafija:DofatiDatum', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM ukradeni WHERE tablica = @plate', {
		['@plate'] = plate
	}, function(result)
		local d, m, y = string.match(result[1].datum, "(%d+)/(%d+)/(%d+)")
		if RacunajDane(d, m, y) >= 7 then
			cb(false)
		else
			cb(true)
		end
	end)
end)

function RacunajDane(d, m, y)
	reference = os.time{day=d, year=y, month=m}
	daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
	wholedays = math.floor(daysfrom)
	return wholedays;
end

ESX.RegisterServerCallback('esx_zemunski:OsobnoVozilo', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate AND state = 0', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('esx_zemunski:getOtherPlayerData', function(source, cb, target)

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
      novac       = xPlayer.getMoney(),
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

ESX.RegisterServerCallback('esx_zemunski:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types_mafia WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_zemunski:getVehicleInfos', function(source, cb, plate)

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

ESX.RegisterServerCallback('esx_zemunski:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_zemunski', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_zemunski:addArmoryWeapon', function(source, cb, weaponName, am)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_zemunski', function(store)

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

ESX.RegisterServerCallback('esx_zemunski:removeArmoryWeapon', function(source, cb, weaponName, am)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, am)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_zemunski', function(store)

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


ESX.RegisterServerCallback('zemunski:piku4', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_zemunski', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_zemunski:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_zemunski', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_zemunski:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)
