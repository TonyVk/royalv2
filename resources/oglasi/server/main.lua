RegisterCommand("oglas", function(source, args, rawCommandString)
	if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
		local identifier = GetPlayerIdentifiers(source)[1]
		local result = MySQL.Sync.fetchAll("SELECT phone_number FROM users WHERE identifier = @identifier", {
			['@identifier'] = identifier
		})
		local brojic = result[1].phone_number
		print(brojic)
		TriggerClientEvent("oglasi:PrikaziNui", source, args[1], args[2], args[3], brojic)
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^[SERVER] ', '/oglas [Marka][Model][Cijena]' } })
	end	
end, false)