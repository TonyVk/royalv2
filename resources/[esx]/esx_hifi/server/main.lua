ESX = nil
local PermLvl = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("hifi", function(source, args, rawCommandString)
	TriggerEvent("DajMiPermLevel2", source)
	if PermLvl > 0 then
		TriggerClientEvent('esx_hifi:place_hifi', source)
		TriggerClientEvent('esx:showNotification', source, _U('put_hifi'))
	else
		name = "System"..":"
		message = " Nemate pristup ovoj komandi"
		TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })	
	end
end, false)

RegisterNetEvent('VratiPermLevel2')
AddEventHandler('VratiPermLevel2', function(perm)
	PermLvl = perm
end)

RegisterServerEvent('esx_hifi:remove_hifi')
AddEventHandler('esx_hifi:remove_hifi', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem('hifi').count < xPlayer.getInventoryItem('hifi').limit then
		xPlayer.addInventoryItem('hifi', 1)
	end
	TriggerClientEvent('esx_hifi:stop_music', -1, coords)
end)

RegisterServerEvent('esx_hifi:play_music2')
AddEventHandler('esx_hifi:play_music2', function(id, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:play_music2', -1, id, coords)
end)

RegisterNetEvent('radio:SyncajVrijeme')
AddEventHandler('radio:SyncajVrijeme', function(vr, id)
	TriggerClientEvent("radio:SyncVr", -1, vr, id)
end)

RegisterServerEvent('esx_hifi:play_music')
AddEventHandler('esx_hifi:play_music', function(id, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:play_music', -1, id, coords)
end)

RegisterServerEvent('esx_hifi:stop_music')
AddEventHandler('esx_hifi:stop_music', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:stop_music', -1, coords)
end)

RegisterServerEvent('esx_hifi:setVolume')
AddEventHandler('esx_hifi:setVolume', function(volume, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:setVolume', -1, volume, coords)
end)
