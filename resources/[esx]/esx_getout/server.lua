ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_getout:DohvatiPermisiju', function(source, cb)
    local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if user ~= nil then
			TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
				if available or user.getGroup() == "admin" then
					Vrati = 1
				else
					Vrati = 0
				end
				cb(Vrati)
			end)
		end
	end)
end)

RegisterServerEvent("esx_getout:DajAdmina")
AddEventHandler("esx_getout:DajAdmina", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
		if user ~= nil then
			TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
				if available or user.getGroup() == "admin" then
					Vrati = 1
				else
					Vrati = 0
				end
				TriggerClientEvent("esx_getout:VratiAdmina", source, Vrati)
			end)
		end
	end)
end)