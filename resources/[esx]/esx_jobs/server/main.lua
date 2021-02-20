local PlayersWorking = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function Work(source, item)

	SetTimeout(item[1].time, function()

		if PlayersWorking[source] == true then

			local xPlayer = ESX.GetPlayerFromId(source)
			if xPlayer == nil then
				return
			end

			for i=1, #item, 1 do
				local itemQtty = 0
				if item[i].name ~= _U('delivery') then
					itemQtty = xPlayer.getInventoryItem(item[i].db_name).count
				end

				local requiredItemQtty = 0
				if item[1].requires ~= "nothing" then
					requiredItemQtty = xPlayer.getInventoryItem(item[1].requires).count
				end

				if item[i].name ~= _U('delivery') and itemQtty >= item[i].max then
					TriggerClientEvent('esx:showNotification', source, _U('max_limit', item[i].name))
					TriggerClientEvent('poslici:MakniAnimaciju', source)
				elseif item[i].requires ~= "nothing" and requiredItemQtty <= 0 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough', item[1].requires_name))
				else
					if item[i].name ~= _U('delivery') then
						-- Chances to drop the item
						if item[i].drop == 100 then
							xPlayer.addInventoryItem(item[i].db_name, item[i].add)
							local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(source).."("..xPlayer.identifier..") je dobio item "..item[i].db_name.." x "..item[i].add
							TriggerEvent("SpremiLog", por)
						else
							local chanceToDrop = math.random(100)
							if chanceToDrop <= item[i].drop then
								xPlayer.addInventoryItem(item[i].db_name, item[i].add)
								local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(source).."("..xPlayer.identifier..") je dobio item "..item[i].db_name.." x "..item[i].add
								TriggerEvent("SpremiLog", por)
							end
						end
					else
						xPlayer.addMoney(item[i].price)
					end
				end
			end

			if item[1].requires ~= "nothing" then
				local itemToRemoveQtty = xPlayer.getInventoryItem(item[1].requires).count
				if itemToRemoveQtty > 0 then
					xPlayer.removeInventoryItem(item[1].requires, item[1].remove)
				end
			end

			Work(source, item)

		end
	end)
end

RegisterServerEvent('poslici:startWork')
AddEventHandler('poslici:startWork', function(item)
	if not PlayersWorking[source] then
		PlayersWorking[source] = true
		Work(source, item)
	else
		print(('esx_jobs: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

RegisterServerEvent('poslici:stopWork')
AddEventHandler('poslici:stopWork', function()
	PlayersWorking[source] = false
end)
