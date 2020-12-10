ESX = nil

local Cuffan = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'sipa', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'sipa', 'SIPA', 'society_sipa', 'society_sipa', 'society_sipa', {type = 'public'})

RegisterServerEvent('popo:zapljeni69')
AddEventHandler('popo:zapljeni69', function(target, itemType, itemName, amount)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
 
    if sourceXPlayer.job.name ~= 'sipa' then
        print(('esx_sipajob: %s attempted to confiscate!'):format(xPlayer.identifier))
        return
    end
 
    if itemType == 'item_standard' then
        local targetItem = targetXPlayer.getInventoryItem(itemName)
        local sourceItem = sourceXPlayer.getInventoryItem(itemName)
 
        -- does the target player have enough in their inventory?
        if targetItem.count > 0 and targetItem.count <= amount then
        
            -- can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
            else
                targetXPlayer.removeInventoryItem(itemName, amount)
                --sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo "..amount.."x"..itemName.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
                --TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
                TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
            end
        else
            TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
        end
 
    elseif itemType == 'item_account' then
        targetXPlayer.removeMoney(amount)
		MySQL.Async.execute('UPDATE users SET `money` = @money WHERE identifier = @identifier', {
					['@money']      = targetXPlayer.getMoney(),
					['@identifier'] = targetXPlayer.identifier
				}, function(rowsChanged)
		end)
		local societyAccount = nil
		local sime = "society_sipa"
		TriggerEvent('esx_addonaccount:getSharedAccount', sime, function(account)
			societyAccount = account
		end)
		societyAccount.addMoney(amount)
        --sourceXPlayer.addMoney   (itemName, amount)
		TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo $"..amount.." od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
        --TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
        TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))
 
    elseif itemType == 'item_weapon' then
        if amount == nil then amount = 0 end
        targetXPlayer.removeWeapon(itemName, amount)
        --sourceXPlayer.addWeapon   (itemName, amount)
		TriggerEvent("DiscordBot:Oduzimanje", sourceXPlayer.name.."["..sourceXPlayer.source.."] je oduzeo oruzje "..itemName.."sa "..amount.." metaka od igraca "..targetXPlayer.name.."["..targetXPlayer.source.."]")
        --TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
        TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
    end
end)

RegisterServerEvent('sipa:UzmiDrona')
AddEventHandler('sipa:UzmiDrona', function()
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
 
    if sourceXPlayer.job.name ~= 'sipa' then
        print(('esx_sipajob: %s attempted to confiscate!'):format(xPlayer.identifier))
        return
    end
    local sourceItem = sourceXPlayer.getInventoryItem("drone_flyer_7")
 
    if sourceItem.limit ~= -1 and (sourceItem.count + 1) > sourceItem.limit then
        TriggerClientEvent('esx:showNotification', _source, "Vec imate jednog drona!")
    else
        sourceXPlayer.addInventoryItem("drone_flyer_7", 1)
        TriggerClientEvent('esx:showNotification', _source,  "Uzeli ste drona")
    end
end)

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
        local identity = result[1]
        return identity
    else
        return nil
    end
end

RegisterServerEvent('esx_sipa:handcuff')
AddEventHandler('esx_sipa:handcuff', function(target, tip)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'sipa' then
		TriggerClientEvent('esx_sipa:handcuff', target, source, tip)
	else
		print(('esx_sipa: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_sipa:SaljiAnim')
AddEventHandler('esx_sipa:SaljiAnim', function(id, tip)
	TriggerClientEvent('esx_sipa:VratiAnim', id, tip)
end)

RegisterServerEvent('esx_sipa:SaljiAnimv2')
AddEventHandler('esx_sipa:SaljiAnimv2', function(id)
	TriggerClientEvent('esx_sipa:VratiAnimv2', id)
end)

RegisterServerEvent('esx_sipa:drag')
AddEventHandler('esx_sipa:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'sipa' then
		TriggerClientEvent('esx_sipa:drag', target, source)
	else
		print(('esx_sipa: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_sipa:putInVehicle')
AddEventHandler('esx_sipa:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'sipa' then
		TriggerClientEvent('esx_sipa:putInVehicle', target)
	else
		print(('esx_sipa: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_sipa:OutVehicle')
AddEventHandler('esx_sipa:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'sipa' then
		TriggerClientEvent('esx_sipa:OutVehicle', target, source)
	else
		print(('esx_sipa: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_sipa:getStockItem')
AddEventHandler('esx_sipa:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sipa', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('esx_sipa:putStockItems')
AddEventHandler('esx_sipa:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sipa', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_sipa:getOtherPlayerData', function(source, cb, target)
	if Config.EnableESXIdentity then
		local xPlayer = ESX.GetPlayerFromId(target)
		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, money, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height
		local money 	= result[1].money

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			novac 	  = money,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
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

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)
	end
end)

ESX.RegisterServerCallback('esx_sipa:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('esx_sipa:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_sipa:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_sipa:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_sipa', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_sipa:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_sipa', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
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

ESX.RegisterServerCallback('esx_sipa:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_sipa', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
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

ESX.RegisterServerCallback('esx_sipa:buyWeapon', function(source, cb, weaponName, type, componentNum, nesta)
	local xPlayer = ESX.GetPlayerFromId(source)
	local authorizedWeapons, selectedWeapon = Config.AuthorizedWeapons[xPlayer.job.grade_name]

	for k,v in ipairs(authorizedWeapons) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		print(('esx_sipa: %s attempted to buy an invalid weapon.'):format(xPlayer.identifier))
		cb(false)
	else
		-- Weapon
		if type == 1 then
			if xPlayer.getMoney() >= selectedWeapon.price then
				xPlayer.removeMoney(selectedWeapon.price)
				xPlayer.addWeapon(weaponName, 100)
				cb(true)
			else
				cb(false)
			end

		-- Weapon Component
		elseif type == 2 then
				local price = selectedWeapon.components[componentNum]
				local weaponNum, weapon = ESX.GetWeapon(weaponName)

				local component = weapon.components[componentNum]

				if component then
					if nesta == "metci" then
						xPlayer.addWeapon(weaponName, 100)
						print("Type 2 sam");
						cb(true)
					end
					if nesta ~= "metci" then
						if xPlayer.getMoney() >= price then
							xPlayer.removeMoney(price)
							xPlayer.addWeaponComponent(weaponName, component.name)
							cb(true)
						else
							cb(false)
						end
					end
				else
					print(('esx_sipa: %s attempted to buy an invalid weapon component.'):format(xPlayer.identifier))
					cb(false)
				end
		end
	end
end)


ESX.RegisterServerCallback('esx_sipa:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		print(('esx_sipa: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_sipa:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_sipa: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]
		local shared = Config.AuthorizedVehicles['Shared']

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end

		for k,v in ipairs(shared) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

ESX.RegisterServerCallback('esx_sipa:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sipa', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_sipa:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)

		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'sipa' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_sipa:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('esx_sipa:spawned')
AddEventHandler('esx_sipa:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'sipa' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_sipa:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_sipa:forceBlip')
AddEventHandler('esx_sipa:forceBlip', function()
	TriggerClientEvent('esx_sipa:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_sipa:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_sipa:message')
AddEventHandler('esx_sipa:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)