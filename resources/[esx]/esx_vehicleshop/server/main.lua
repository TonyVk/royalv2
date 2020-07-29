ESX = nil
local categories, vehicles = {}, {}
local br         = 0
local VoziloID   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'cardealer', _U('dealer_customers'), false, false)
TriggerEvent('esx_society:registerSociety', 'cardealer', _U('car_dealer'), 'society_cardealer', 'society_cardealer', 'society_cardealer', {type = 'private'})

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('[esx_vehicleshop] [^3WARNING^7] Plate character count reached, %s/8 characters!'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM vehicle_categories', {}, function(_categories)
		categories = _categories

		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(_vehicles)
			vehicles = _vehicles

			for k,v in ipairs(vehicles) do
				for k2,v2 in ipairs(categories) do
					if v2.name == v.category then
						vehicles[k].categoryLabel = v2.label
						break
					end
				end
			end

			-- send information after db has loaded, making sure everyone gets vehicle information
			TriggerClientEvent('esx_vehicleshop:sendCategories', -1, categories)
			TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, vehicles)
		end)
	end)
end)

function DeriBrojac(brj)
	local bro = brj
	SetTimeout(300000, function()
		TriggerClientEvent('salon:ObrisiVozilo', -1, VoziloID[bro])
		VoziloID[bro] = nil
    end)
end

RegisterServerEvent('salon:PlatiStetu')
AddEventHandler('salon:PlatiStetu', function (cifra)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(cifra)
end)

RegisterServerEvent('salon:PokreniTimer')
AddEventHandler('salon:PokreniTimer', function (vid)
	local _source = source
	VoziloID[br] = vid
	DeriBrojac(br)
	br = br+1
end)

RegisterServerEvent('ProvjeraObrisanihVozila')
AddEventHandler('ProvjeraObrisanihVozila', function ()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function (result)
		for i=1, #result, 1 do
			local v = json.decode(result[i].vehicle)
			for i=1, #vehicles, 1 do
				if GetHashKey(vehicles[i].model) == v.model and vehicles[i].category == "obrisani" then
					resellPrice = ESX.Math.Round(vehicles[i].price)
					xPlayer.addMoney(resellPrice)
					RemoveOwnedVehicle(v.plate)
					TriggerClientEvent('esx:showNotification', _source, "Vozilo "..vehicles[i].name.." je obrisano i dobili ste nazad "..resellPrice.."$")
					ESX.SavePlayer(xPlayer, function() 
					end)
					break
				end
			end
		end		
	end)
end)

function getVehicleLabelFromModel(model)
	for k,v in ipairs(vehicles) do
		if v.model == model then
			return v.name
		end
	end

	return
end

RegisterNetEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function(playerId, vehicleProps, model, label)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == 'cardealer' and xTarget then
		MySQL.Async.fetchAll('SELECT id FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = model
		}, function(result)
			if result[1] then
				local id = result[1].id

				MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
					['@id'] = id
				}, function(rowsChanged)
					if rowsChanged == 1 then
						MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
							['@owner']   = xTarget.identifier,
							['@plate']   = vehicleProps.plate,
							['@vehicle'] = json.encode(vehicleProps)
						}, function(rowsChanged)
							TriggerClientEvent('esx:showNotification', source, _U('vehicle_set_owned', vehicleProps.plate, xTarget.getName()))
							TriggerClientEvent('esx:showNotification', playerId, _U('vehicle_belongs', vehicleProps.plate))
						end)

						local dateNow = os.date('%Y-%m-%d %H:%M')

						MySQL.Async.execute('INSERT INTO vehicle_sold (client, model, plate, soldby, date) VALUES (@client, @model, @plate, @soldby, @date)', {
							['@client'] = xTarget.getName(),
							['@model'] = label,
							['@plate'] = vehicleProps.plate,
							['@soldby'] = xPlayer.getName(),
							['@date'] = dateNow
						})
					end
				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getSoldVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT client, model, plate, soldby, date FROM vehicle_sold', {}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('esx_vehicleshop:rentVehicle')
AddEventHandler('esx_vehicleshop:rentVehicle', function(vehicle, plate, rentPrice, playerId)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == 'cardealer' and xTarget then
		MySQL.Async.fetchAll('SELECT id, price FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = vehicle
		}, function(result)
			if result[1] then
				local price = result[1].price

				MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
					['@id'] = result[1].id
				}, function(rowsChanged)
					if rowsChanged == 1 then
						MySQL.Async.execute('INSERT INTO rented_vehicles (vehicle, plate, player_name, base_price, rent_price, owner) VALUES (@vehicle, @plate, @player_name, @base_price, @rent_price, @owner)', {
							['@vehicle']     = vehicle,
							['@plate']       = plate,
							['@player_name'] = xTarget.getName(),
							['@base_price']  = price,
							['@rent_price']  = rentPrice,
							['@owner']       = xTarget.identifier
						}, function(rowsChanged2)
							TriggerClientEvent('esx:showNotification', source, _U('vehicle_set_rented', plate, xTarget.getName()))
						end)
					end
				end)
			end
		end)
	end
end)

RegisterNetEvent('esx_vehicleshop:getStockItem')
AddEventHandler('esx_vehicleshop:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, item.label))
			else
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_society'))
		end
	end)
end)

RegisterNetEvent('esx_vehicleshop:putStockItems')
AddEventHandler('esx_vehicleshop:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', count, item.label))
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_amount'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function(source, cb)
	cb(categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function(source, cb)
	cb(vehicles)
end)

ESX.RegisterServerCallback('autosalon:sealion', function(source, cb, model, plate, mjenjac, vd)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local modelPrice
	local modelName

	for k,v in ipairs(vehicles) do
		if model == v.model then
			modelPrice = v.price
			modelName = v.name
			break
		end
	end
	
	vd.plate = plate
	vd.model = GetHashKey(model)

	if mjenjac == 1 then
		if modelPrice and xPlayer.getMoney() >= (modelPrice+5000) then
			xPlayer.removeMoney(modelPrice+5000)
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, mjenjac) VALUES (@owner, @plate, @vehicle, @mj)', {
				['@owner']   = xPlayer.identifier,
				['@plate']   = plate,
				['@vehicle'] = json.encode(vd),
				['@mj'] = mjenjac
			}, function(rowsChanged)
				TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', plate))
				TriggerEvent("DiscordBot:Vozila", GetPlayerName(_source).." je kupio "..modelName.."(automatik)["..plate.."] u salonu za $"..modelPrice+5000)
				cb(true)
			end)
		else
			cb(false)
		end
	elseif mjenjac == 2 then
		if modelPrice and xPlayer.getMoney() >= modelPrice then
			xPlayer.removeMoney(modelPrice)
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, mjenjac) VALUES (@owner, @plate, @vehicle, @mj)', {
				['@owner']   = xPlayer.identifier,
				['@plate']   = plate,
				['@vehicle'] = json.encode(vd),
				['@mj'] = mjenjac
			}, function(rowsChanged)
				TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', plate))
				TriggerEvent("DiscordBot:Vozila", GetPlayerName(_source).." je kupio "..modelName.."(rucni)["..plate.."] u salonu za $"..modelPrice)
				TriggerClientEvent("EoTiIzSalona", _source, 2)
				TriggerClientEvent('esx:showNotification', _source, "Brzine mjenjate sa lijevim shiftom i ctrlom!")
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCommercialVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT price, vehicle FROM cardealer_vehicles ORDER BY vehicle ASC', {}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyCarDealerVehicle', function(source, cb, model)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'cardealer' then
		local modelPrice

		for k,v in ipairs(vehicles) do
			if model == v.model then
				modelPrice = v.price
				break
			end
		end

		if modelPrice then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				if account.money >= modelPrice then
					account.removeMoney(modelPrice)

					MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
						['@vehicle'] = model,
						['@price'] = modelPrice
					}, function(rowsChanged)
						cb(true)
					end)
				else
					cb(false)
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_vehicleshop:returnProvider')
AddEventHandler('esx_vehicleshop:returnProvider', function(vehicleModel)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'cardealer' then
		MySQL.Async.fetchAll('SELECT id, price FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = vehicleModel
		}, function(result)
			if result[1] then
				local id = result[1].id

				MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
					['@id'] = id
				}, function(rowsChanged)
					if rowsChanged == 1 then
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
							local price = ESX.Math.Round(result[1].price * 0.75)
							local vehicleLabel = getVehicleLabelFromModel(vehicleModel)

							account.addMoney(price)
							TriggerClientEvent('esx:showNotification', source, _U('vehicle_sold_for', vehicleLabel, ESX.Math.GroupDigits(price)))
						end)
					end
				end)
			else
				print(('[esx_vehicleshop] [^3WARNING^7] %s attempted selling an invalid vehicle!'):format(xPlayer.identifier))
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getRentedVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles ORDER BY player_name ASC', {}, function(result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name = result[i].vehicle,
				plate = result[i].plate,
				playerName = result[i].player_name
			})
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:giveBackVehicle', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT base_price, vehicle FROM rented_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			local vehicle = result[1].vehicle
			local basePrice = result[1].base_price

			MySQL.Async.execute('DELETE FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function(rowsChanged)
				MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
					['@vehicle'] = vehicle,
					['@price']   = basePrice
				})

				RemoveOwnedVehicle(plate)
				cb(true)
			end)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function(source, cb, plate, model)
	local xPlayer, resellPrice = ESX.GetPlayerFromId(source)
	local vime = nil

	--if xPlayer.job.name == 'cardealer' then
		-- calculate the resell price
		for i=1, #vehicles, 1 do
			if GetHashKey(vehicles[i].model) == model then
				resellPrice = ESX.Math.Round(vehicles[i].price / 100 * Config.ResellPercentage)
				vime = vehicles[i].name
				break
			end
		end

		if not resellPrice then
			print(('[esx_vehicleshop] [^3WARNING^7] %s attempted to sell an unknown vehicle!'):format(xPlayer.identifier))
			cb(false)
		else
			MySQL.Async.fetchAll('SELECT * FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function(result)
				if result[1] then -- is it a rented vehicle?
					cb(false) -- it is, don't let the player sell it since he doesn't own it
				else
					MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
						['@owner'] = xPlayer.identifier,
						['@plate'] = plate
					}, function(result)
						if result[1] then -- does the owner match?
							local vehicle = json.decode(result[1].vehicle)

							if vehicle.model == model then
								if vehicle.plate == plate then
									xPlayer.addMoney(resellPrice)
									RemoveOwnedVehicle(plate)
									TriggerEvent("DiscordBot:Vozila", GetPlayerName(source).." je prodao "..vime.." u salonu za $"..resellPrice)
									cb(true)
								else
									print(('[esx_vehicleshop] [^3WARNING^7] %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
									cb(false)
								end
							else
								print(('[esx_vehicleshop] [^3WARNING^7] %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
								cb(false)
							end
						end
					end)
				end
			end)
		end
	--end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:DajGaVamo', function (source, cb, mod)
	print(mod)
	local xPlayer = ESX.GetPlayerFromId(source)
	local test = 0
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function (result)
		for i = 1, #result, 1 do
			local prop = json.decode(result[i]["vehicle"])
			local model = prop["model"]
			if model == mod then
				cb(true)
				test = 1
			end
		end
		if test == 0 then
			cb(false)
		end
	end)
end)

RegisterNetEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('[esx_vehicleshop] [^3WARNING^7] %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)
