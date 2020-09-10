ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ugovor:prodajtuljanu2')
AddEventHandler('ugovor:prodajtuljanu2', function(target, plate, price, veh)
	local _target = target
	local _source = source
	TriggerClientEvent('esx:showNotification', _target, "Zelite li kupiti vozilo sa tablicom "..plate.." za $"..price)
	TriggerClientEvent('esx:showNotification', _target, "Upisite /prihvativozilo da kupite vozilo!")
	TriggerClientEvent('esx_contract:PoslaoMu', _target, 1, plate, price, _source, veh)
end)

RegisterServerEvent('ugovor:prodajtuljanu')
AddEventHandler('ugovor:prodajtuljanu', function(target, plate, price)
	local _source = target
	local xPlayer = ESX.GetPlayerFromId(_source)
	local _target = source
	local tPlayer = ESX.GetPlayerFromId(_target)
	if tPlayer.getMoney() >= price then
		local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
				['@identifier'] = xPlayer.identifier,
				['@plate'] = plate
			})
		if result[1] ~= nil then
			MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
				['@owner'] = xPlayer.identifier,
				['@plate'] = plate,
				['@target'] = tPlayer.identifier
			}, function (rowsChanged)
				if rowsChanged ~= 0 then
					xPlayer.addMoney(price)
					tPlayer.removeMoney(price)
					TriggerClientEvent('esx_contract:showAnim', _source)
					Wait(22000)
					TriggerClientEvent('esx_contract:showAnim', _target)
					Wait(22000)
					TriggerClientEvent('esx:showNotification', _source, _U('soldvehicle', plate))
					TriggerClientEvent('esx:showNotification', _target, _U('boughtvehicle', plate))
					TriggerClientEvent("contract:ZamjenaVozila", _source, plate)
					xPlayer.removeInventoryItem('contract', 1)
					ESX.SavePlayer(xPlayer, function() 
					end)
					ESX.SavePlayer(tPlayer, function() 
					end)
					TriggerEvent("DiscordBot:Vozila", GetPlayerName(_source).." je prodao vozilo sa tablicama "..plate.." igracu "..GetPlayerName(_target).." za $"..price)
				end
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('notyourcar'))
		end
	else
		TriggerClientEvent('esx:showNotification', _source, "Igrac nema toliko novca!")
		TriggerClientEvent('esx:showNotification', _target, "Nemate toliko novca!")
	end
end)

ESX.RegisterUsableItem('contract', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_contract:getVehicle', _source)
end)