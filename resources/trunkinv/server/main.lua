ESX = nil
local arrayWeight = {}
local VehicleList = {}
local Tablice = {}

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('gepeke:getOwnedVehicule')
AddEventHandler('gepeke:getOwnedVehicule', function()
    local vehicules = {}
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll(
        'SELECT vehicle FROM owned_vehicles WHERE owner = @owner',
        {
            ['@owner'] = xPlayer.identifier
        },
        function(result)
            if result ~= nil and #result > 0 then
                for _, v in pairs(result) do
                    local vehicle = json.decode(v.vehicle)
                    table.insert(vehicules, {plate = vehicle.plate})
                end
            end
            TriggerClientEvent('gepeke:setOwnedVehicule', _source, vehicules)
        end)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	for _, v in pairs(VehicleList) do
        if (playerID == v.id) then
			TriggerEvent('gepeke:RemoveVehicleList', v.vehicleplate)
            break
        end
    end
end)

RegisterServerEvent('gepeke:getInventory')
AddEventHandler('gepeke:getInventory', function(plate)
    local inventory_ = {}
    local _source = source
	local moze = true
	for a = 1, #Tablice, 1 do
        if Tablice[a].plate == plate then
			if Tablice[a].id ~= _source then
				if GetGameTimer()-Tablice[a].vrijeme < 2000 then
					moze = false
				end
			end
		end
	end
	if moze then
		MySQL.Async.fetchAll(
			'SELECT item, count, name, itemt FROM `truck_inventory` WHERE `plate` = @plate',
			{
				['@plate'] = plate
			},
			function(inventory)
				if inventory ~= nil and #inventory > 0 then
					for i = 1, #inventory, 1 do
						if inventory[i].itemt ~= "item_weapon" then
							if inventory[i].count > 0 then
								table.insert(inventory_, {
									label = inventory[i].name,
									name = inventory[i].item,
									count = inventory[i].count,
									type = inventory[i].itemt
								})
							end
						else
							table.insert(inventory_, {
								label = inventory[i].name,
								name = inventory[i].item,
								count = inventory[i].count,
								type = inventory[i].itemt
							})
						end
					end
				end
				local weight = (getInventoryWeight(inventory_))
				local xPlayer = ESX.GetPlayerFromId(_source)
				TriggerClientEvent('gepeke:getInventoryLoaded', xPlayer.source, inventory_, weight)
			end)
	end
end)

RegisterServerEvent('gepeke:removeInventoryItem')
AddEventHandler('gepeke:removeInventoryItem', function(plate, item, itemType, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if plate ~= " " or plate ~= nil or plate ~= "" then
        MySQL.Async.fetchScalar('SELECT `count` FROM truck_inventory WHERE `plate` = @plate AND `item`= @item AND `itemt`= @itemt',
            {
                ['@plate'] = plate,
                ['@item'] = item,
                ['@itemt'] = itemType
            }, function(countincar)
                if countincar >= count then
					if itemType == "item_weapon" then
						if countincar == count then
							MySQL.Async.execute('DELETE FROM `truck_inventory` WHERE `plate` = @plate AND `item`= @item AND `itemt`= @itemt', {
									['@plate'] = plate,
									['@item'] = item,
									['@itemt'] = itemType
							})
						end
					end
                    MySQL.Async.execute('UPDATE `truck_inventory` SET `count`= `count` - @qty WHERE `plate` = @plate AND `item`= @item AND `itemt`= @itemt',
                        {
                            ['@plate'] = plate,
                            ['@qty'] = count,
                            ['@item'] = item,
                            ['@itemt'] = itemType
                        })
                    if xPlayer ~= nil then
                        if itemType == 'item_standard' then
                            xPlayer.addInventoryItem(item, count)
							TriggerEvent("DiscordBot:Gepek", GetPlayerName(_source).."[".._source.."] je izvadio iz gepeka "..count.." "..item..". Tablica vozila: "..plate)
                        end
                        
                        if itemType == 'item_account' then
                            xPlayer.addAccountMoney(item, count)
							TriggerEvent("DiscordBot:Gepek", GetPlayerName(_source).."[".._source.."] je izvadio iz gepeka "..count.." "..item..". Tablica vozila: "..plate)
                        end
                        
                        if itemType == 'item_weapon' then
                            xPlayer.addWeapon(item, count)
							TriggerEvent("DiscordBot:Gepek", GetPlayerName(_source).."[".._source.."] je izvadio iz gepeka "..count.." "..item..". Tablica vozila: "..plate)
                        end
                    end
                
                end
            
            end)
    end
end)

RegisterServerEvent('gepeke:addInventoryItem')
AddEventHandler('gepeke:addInventoryItem', function(type, model, plate, item, qtty, name, itemType, ownedV)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if plate ~= " " or plate ~= nil or plate ~= "" then
        
        if xPlayer ~= nil then
            if itemType == 'item_standard' then
                local playerItemCount = xPlayer.getInventoryItem(item).count
                if playerItemCount >= qtty then
                    xPlayer.removeInventoryItem(item, qtty)
                    putInTrunk(plate, qtty, item, name, itemType, ownedV)
					TriggerEvent("DiscordBot:Gepek", GetPlayerName(_source).."[".._source.."] je stavio u gepek "..qtty.." "..item..". Tablica vozila: "..plate)
                else
                    TriggerClientEvent('esx:showNotification', _source, 'Kriva kolicina')
                end
            end
            
            if itemType == 'item_account' then
                local playerAccountMoney = xPlayer.getAccount(item).money
                if playerAccountMoney >= qtty then
                    xPlayer.removeAccountMoney(item, qtty)
                    putInTrunk(plate, qtty, item, name, itemType, ownedV)
					TriggerEvent("DiscordBot:Gepek", GetPlayerName(_source).."[".._source.."] je stavio u gepek "..qtty.." "..item..". Tablica vozila: "..plate)
                end
            end
            
            if itemType == 'item_weapon' then
                currentLoadout = xPlayer.getLoadout()
                for i = 1, #currentLoadout, 1 do
                    if currentLoadout[i].name == item then
                        xPlayer.removeWeapon(item, qtty)
                        if item ~= "WEAPON_HEAVYSNIPER" then
                        putInTrunk(plate, qtty, item, name, itemType, ownedV)
						TriggerEvent("DiscordBot:Gepek", GetPlayerName(_source).."[".._source.."] je stavio u gepek "..qtty.." "..item..". Tablica vozila: "..plate)
                        end
                    end
                end
            end
        end
    end
end)

ESX.RegisterServerCallback('gepek:DohvatiTezine', function(source, cb)
    cb(arrayWeight)
end)

ESX.RegisterServerCallback('esx_truck:checkvehicle', function(source, cb, vehicleplate)
    local isFound = false
    local _source = source
    local plate = vehicleplate
	local moze = true
	for a = 1, #Tablice, 1 do
        if Tablice[a].plate == plate then
			if Tablice[a].id ~= _source then
				if GetGameTimer()-Tablice[a].vrijeme < 2000 then
					moze = false
				end
			end
		end
	end
	if moze then
		if plate ~= " " or plate ~= nil or plate ~= "" then
			for _, v in pairs(VehicleList) do
				if (plate == v.vehicleplate) then
					isFound = true
					break
				end
			end
		else
			isFound = true
		end
	else
		isFound = true
	end
    cb(isFound)
end)

RegisterServerEvent('gepeke:AddVehicleList')
AddEventHandler('gepeke:AddVehicleList', function(plate)
    local plateisfound = false
	local _source = source
    if plate ~= " " or plate ~= nil or plate ~= "" then
        for _, v in pairs(VehicleList) do
            if (plate == v.vehicleplate) then
                plateisfound = true
                break
            end
        end
        if not plateisfound then
            table.insert(VehicleList, {vehicleplate = plate, id = _source})
        end
		table.insert(Tablice, {plate = plate, id = _source, vrijeme = GetGameTimer()})
    end
end)

RegisterServerEvent('gepeke:RemoveVehicleList')
AddEventHandler('gepeke:RemoveVehicleList', function(plate)
    for i = 1, #VehicleList, 1 do
        if VehicleList[i].vehicleplate == plate then
            if VehicleList[i].vehicleplate ~= " " or plate ~= " " or VehicleList[i].vehicleplate ~= nil or plate ~= nil or VehicleList[i].vehicleplate ~= "" or plate ~= "" then
                table.remove(VehicleList, i)
                break
            end
        end
    end
	for a = 1, #Tablice, 1 do
		if Tablice[a] ~= nil then
			if Tablice[a].plate == plate then
				table.remove(Tablice, a)
			end
		end
	end
end)

AddEventHandler('onMySQLReady', function()
    MySQL.Async.execute('DELETE FROM `truck_inventory` WHERE `count` = 0 AND `itemt` != "item_weapon" ', {})
end)

MySQL.ready(function()
	MySQL.Async.fetchAll(
        'SELECT name, weight FROM items', {},
        function(result)
            if result ~= nil and #result > 0 then
                for _, v in pairs(result) do
					table.insert(arrayWeight, {Item = v.name, Tezina = v.weight})
                end
				TriggerClientEvent("gepek:EoTiTezine", -1, arrayWeight)
            end
		end
	)
end)

function getInventoryWeight(inventory)
    local weight = 0
    local itemWeight = 0
    
    if inventory ~= nil then
        for i = 1, #inventory, 1 do
            if inventory[i] ~= nil then
                itemWeight = Config.DefaultWeight
				for a = 1, #arrayWeight, 1 do
					if arrayWeight[a].Item == inventory[i].name and arrayWeight[a].Tezina > 0 then
						itemWeight = arrayWeight[a].Tezina
					end
				end
                weight = weight + (itemWeight * inventory[i].count)
            end
        end
    end
    return weight
end

function putInTrunk(plate, qtty, item, name, itemType, ownedV)
    MySQL.Async.execute('INSERT INTO truck_inventory (item,count,plate,name,itemt,owned) VALUES (@item,@qty,@plate,@name,@itemt,@owned) ON DUPLICATE KEY UPDATE count=count+ @qty',
        {
            ['@plate'] = plate,
            ['@qty'] = qtty,
            ['@item'] = item,
            ['@name'] = name,
            ['@itemt'] = itemType,
            ['@owned'] = ownedV,
        })
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
