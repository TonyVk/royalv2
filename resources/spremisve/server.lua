ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("restartsrw", function(source, args, rawCommandString)
	local Source = source
	local Vrati = 0
	if Source ~= 0 then
		TriggerEvent('es:getPlayerFromId', source, function(user)
			TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
				if available or user.getGroup() == "admin" then
					Vrati = 1
				else
					Vrati = 0
				end
			end)
		end)
	else
		Vrati = 1
	end
	if Vrati == 1 then
		ESX.SavePlayers()
		if Source == 0 then
			print("Spremili ste sve")
		else
			TriggerClientEvent('esx:showNotification', source, "Spremili ste sve!")
		end
	end
end, false)