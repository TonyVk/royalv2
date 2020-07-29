if Config.UseESX then
	local ESX = nil

	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	RegisterServerEvent('gorivo:foka')
	AddEventHandler('gorivo:foka', function(price)
		local xPlayer = ESX.GetPlayerFromId(source)
		local amount = ESX.Math.Round(price)

		if price > 0 then
			xPlayer.removeMoney(amount)
		end
	end)
end

RegisterServerEvent('SyncajToGorivo')
AddEventHandler('SyncajToGorivo', function(nid, gorivo)
	TriggerClientEvent("EoSvimaGorivo", -1, nid, gorivo)
end)
