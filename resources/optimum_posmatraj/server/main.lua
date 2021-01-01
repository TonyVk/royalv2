ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[ESX.RegisterCommand('posmatraj', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx_spectate:spectate')
end, false, {help = 'Posmatraj', validate = true, arguments = {
}})

ESX.RegisterCommand('izadjispec', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx_spectate:leavespectate')
end, false, {help = 'Posmatraj', validate = true, arguments = {
}})]]

ESX.RegisterServerCallback('esx_spectate:getPlayerData', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(id)
	cb(xPlayer)
end)

RegisterNetEvent('esx_spectate:kick')
AddEventHandler('esx_spectate:kick', function(target, msg)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() ~= 'user' then
		DropPlayer(target, msg)
	else
		DropPlayer(source, "Ide hakuj negde drugde.")
	end
end)