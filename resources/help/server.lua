RegisterCommand("help", function(source, args, rawCommandString)
	local Source = source
	local Vrati = 0
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available or user.getGroup() == "admin" then
				Vrati = 1
			else
				Vrati = 0
			end
		end)
	end)
    TriggerClientEvent("otvorihelp", source, Vrati)
end, false)