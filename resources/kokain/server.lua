ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx_drogica:get")
AddEventHandler("esx_drogica:get", function(torba)
    local _source = source
	if #(GetEntityCoords(GetPlayerPed(_source))-Config.PickupBlip) <= 200 then
		local xPlayer = ESX.GetPlayerFromId(_source)
		local list = xPlayer.getInventoryItem('coke')
		if torba then
			if list.count < list.limit*2 then
				local randa = math.random(1,2)
				if list.count+randa > list.limit*2 then
					xPlayer.addInventoryItem("coke", 1)
					local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item coke x 1"
					TriggerEvent("SpremiLog", por)
				else
					xPlayer.addInventoryItem("coke", randa)
					local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item coke x "..randa
					TriggerEvent("SpremiLog", por)
				end
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Ne mozete imati vise listova koke')
			end
		else
			if list.count < list.limit then
				local randa = math.random(1,2)
				if list.count+randa > list.limit then
					xPlayer.addInventoryItem("coke", 1)
					local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item coke x 1"
					TriggerEvent("SpremiLog", por)
				else
					xPlayer.addInventoryItem("coke", randa)
					local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(_source).."("..xPlayer.identifier..") je dobio item coke x "..randa
					TriggerEvent("SpremiLog", por)
				end
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Ne mozete imati vise listova koke')
			end
		end	
	else
		TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za dobijanje listova kokaina, a nije blizu lokacije!")
	    TriggerEvent("AntiCheat:Citer", _source)
	end
end)

ESX.RegisterUsableItem('cocaine', function(source)
	--local xPlayer = ESX.GetPlayerFromId(source)
	--xPlayer.removeInventoryItem('cocaine', 1)
	
	TriggerClientEvent('esx_drogica:useItem', source, 'cocaine')

	Citizen.Wait(1000)
end)

ESX.RegisterServerCallback('esx_drogica:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_drogica:removeItem')
AddEventHandler('esx_drogica:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)
end)



