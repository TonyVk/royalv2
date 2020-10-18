ESX = nil

local Vozila = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('autobomba', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem('autobomba').count > 0 then
        TriggerClientEvent('RNG_CarBomb:CheckIfRequirementsAreMet', source)
    end
end)

RegisterServerEvent('RNG_CarBomb:RemoveBombFromInv')
AddEventHandler('RNG_CarBomb:RemoveBombFromInv', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem('autobomba').count > 0 then
        xPlayer.removeInventoryItem('autobomba', 1)
    end
end)

RegisterServerEvent('bomba:SpremiVozilo')
AddEventHandler('bomba:SpremiVozilo', function(tablica)
    table.insert(Vozila, {Tablica = tablica})
end)

RegisterServerEvent('bomba:MakniVozilo')
AddEventHandler('bomba:MakniVozilo', function(tablica)
	for i=#Vozila, 1, -1 do
		if Vozila[i] ~= nil then
			if Vozila[i].Tablica == tablica then
				table.remove(Vozila, i)
			end
		end
	end
end)

ESX.RegisterServerCallback('bomba:ProvjeriVozilo', function(source, cb, tablica)
	for i=1, #Vozila, 1 do
		if Vozila[i] ~= nil then
			if Vozila[i].Tablica == tablica then
				cb(true)
				break
			end
		end
	end
	cb(false)
end)