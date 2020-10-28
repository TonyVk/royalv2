ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_bread'))
end)

ESX.RegisterUsableItem('burek', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('burek', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Satro burek')
end)

ESX.RegisterUsableItem('pizza', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pizza', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 220000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Satro pizzu')
end)

-- Bar stuff
ESX.RegisterUsableItem('wine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('wine', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 100000)
	TriggerClientEvent('esx_basicneeds:onDrinkWine', source)
	TriggerClientEvent('esx:showNotification', source, "Popili ste vino!")
end)

ESX.RegisterUsableItem('beer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('beer', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 150000)
	TriggerClientEvent('esx_basicneeds:onDrinkBeer', source)
	TriggerClientEvent('esx:showNotification', source, "Popili ste pivo!")
end)

ESX.RegisterUsableItem('vodka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('vodka', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 350000)
	TriggerClientEvent('esx_basicneeds:onDrinkVodka', source)
	TriggerClientEvent('esx:showNotification', source, "Popili ste vodku!")
end)

ESX.RegisterUsableItem('rakija', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('rakija', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 700000)
	TriggerClientEvent('esx_basicneeds:onDrinkVodka', source)
	TriggerClientEvent('esx:showNotification', source, 'Sabio rakiju')
end)

ESX.RegisterUsableItem('kola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('kola', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 220000)
	TriggerClientEvent('esx_basicneeds:onDrinkVodka', source)
	TriggerClientEvent('esx:showNotification', source, 'Pregazio kolu')
end)

ESX.RegisterUsableItem('whisky', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('whisky', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_basicneeds:onDrinkWhisky', source)
	TriggerClientEvent('esx:showNotification', source, "Popili ste viski!")
end)

ESX.RegisterUsableItem('tequila', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('tequila', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 200000)
	TriggerClientEvent('esx_basicneeds:onDrinkTequila', source)
	TriggerClientEvent('esx:showNotification', source, "Popili ste tekilu!")
end)

ESX.RegisterUsableItem('milk', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('milk', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', -100000)
	TriggerClientEvent('esx_basicneeds:onDrinkMilk', source)
	TriggerClientEvent('esx:showNotification', source, "Popili ste mlijeko!")
end)

-- Disco Stuff
ESX.RegisterUsableItem('gintonic', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('gintonic', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 150000)
	TriggerClientEvent('esx_basicneeds:onDrinkGin', source)
	TriggerClientEvent('esx:showNotification', source, "Popili ste gin tonik")
end)

ESX.RegisterUsableItem('absinthe', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('absinthe', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 400000)
	TriggerClientEvent('esx_basicneeds:onDrinkAbsinthe', source)
	TriggerClientEvent('esx:showNotification', source, "Popili ste pelin!")
end)

ESX.RegisterUsableItem('champagne', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('champagne', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 50000)
	TriggerClientEvent('esx_basicneeds:onDrinkChampagne', source)
	TriggerClientEvent('esx:showNotification', source, "Popili ste sampanjac!")
end)

-- Cigarett
ESX.RegisterUsableItem('cigarett', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	
		if lighter.count > 0 then
			xPlayer.removeInventoryItem('cigarett', 1)
			TriggerClientEvent('esx_cigarett:startSmoke', source)
		else
			TriggerClientEvent('esx:showNotification', source, "Nemate upaljac kod sebe!")
		end
end)

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_water'))
end)

TriggerEvent('es:addGroupCommand', 'heal', 'admin', function(source, args, user)
	-- heal another player - don't heal source
	if args[1] then
		local playerId = tonumber(args[1])

		-- is the argument a number?
		if playerId then
			-- is the number a valid player?
			if GetPlayerName(playerId) then
				print(('esx_basicneeds: %s healed %s'):format(GetPlayerIdentifier(source, 0), GetPlayerIdentifier(playerId, 0)))
				TriggerClientEvent('esx_basicneeds:healPlayer', playerId)
				TriggerClientEvent('chat:addMessage', playerId, { args = { '^5HEAL', 'Healani ste od admina.' } })
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Igrac nije online.' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Krivi ID igraca.' } })
		end
	else
		print(('esx_basicneeds: %s healed self'):format(GetPlayerIdentifier(source, 0)))
		TriggerClientEvent('esx_basicneeds:healPlayer', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Nemate pristup ovoj komandi.' } })
end, {help = 'Heal igraca ili sebe - puni zeđ, glad i heal.', params = {{name = 'playerId', help = '(neobavezno) player id'}}})