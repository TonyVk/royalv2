ESX = nil

local Metle = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('es:addGroupCommand', 'kazna', 'admin', function(source, args, user)
	if args[1] and GetPlayerName(args[1]) ~= nil and tonumber(args[2]) and args[3] ~= nil then
		local _source = source
		local razlog = table.concat(args, " ", 3)
		TriggerEvent('esx_communityservice:sendToCommunityService', tonumber(args[1]), tonumber(args[2]), razlog)
		TriggerEvent("DiscordBot:Markeri", GetPlayerName(args[1]).."["..args[1].."] je stavljen na "..args[2].." markera od admina "..GetPlayerName(_source)..". Razlog: "..razlog)
	else
		TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id_or_actions') } } )
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('insufficient_permissions') } })
end, {help = _U('give_player_community'), params = {{name = "id", help = _U('target_id')}, {name = "actions", help = _U('action_count_suggested')}, {name = "reason", help = _U('action_razlog')}}})


TriggerEvent('es:addGroupCommand', 'maknikaznu', 'admin', function(source, args, user)
	if args[1] then
		if GetPlayerName(args[1]) ~= nil then
			local _source = source
			TriggerEvent('esx_communityservice:endCommunityServiceCommand', tonumber(args[1]))
			TriggerEvent("DiscordBot:Markeri", GetPlayerName(args[1]).."["..args[1].."] su maknuti markeri od admina "..GetPlayerName(_source))
		else
			TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id')  } } )
		end
	else
		TriggerEvent('esx_communityservice:endCommunityServiceCommand', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('insufficient_permissions') } })
end, {help = _U('unjail_people'), params = {{name = "id", help = _U('target_id')}}})


RegisterServerEvent('ciscenje:DodajObjekt')
AddEventHandler('ciscenje:DodajObjekt', function(nid)
	local src = source
	table.insert(Metle, {ID = src, NetID = nid})
end)

RegisterServerEvent('ciscenje:MakniObjekt')
AddEventHandler('ciscenje:MakniObjekt', function(nid)
	local src = source
	for i=1, #Metle, 1 do
		if Metle[i] ~= nil then
			if Metle[i].ID == src and Metle[i].NetID == nid then
				table.remove(Metle, i)
				break
			end
		end
	end
end)

AddEventHandler('playerDropped', function()
	local src = source
	for i=1, #Metle, 1 do
		if Metle[i] ~= nil then
			if Metle[i].ID == src then
				local ObjID = NetworkGetEntityFromNetworkId(Metle[i].NetID)
				DeleteEntity(ObjID)
			end
		end
	end
end)

RegisterServerEvent('esx_communityservice:endCommunityServiceCommand')
AddEventHandler('esx_communityservice:endCommunityServiceCommand', function(source)
	if source ~= nil then
		releaseFromCommunityService(source)
	end
end)

-- unjail after time served
RegisterServerEvent('esx_communityservice:finishCommunityService')
AddEventHandler('esx_communityservice:finishCommunityService', function()
	releaseFromCommunityService(source)
end)





RegisterServerEvent('esx_communityservice:completeService')
AddEventHandler('esx_communityservice:completeService', function()

	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)

		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining - 1 WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
		else
			print ("ESX_CommunityService :: Problem matching player identifier in database to reduce actions.")
		end
	end)
end)




RegisterServerEvent('esx_communityservice:extendService')
AddEventHandler('esx_communityservice:extendService', function()

	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)

		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining + @extension_value WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@extension_value'] = Config.ServiceExtensionOnEscape
			})
		else
			print ("ESX_CommunityService :: Problem matching player identifier in database to reduce actions.")
		end
	end)
end)






RegisterServerEvent('esx_communityservice:sendToCommunityService')
AddEventHandler('esx_communityservice:sendToCommunityService', function(target, actions_count, razlog)

	local identifier = GetPlayerIdentifiers(target)[1]

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = @actions_remaining WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count
			})
		else
			MySQL.Async.execute('INSERT INTO communityservice (identifier, actions_remaining) VALUES (@identifier, @actions_remaining)', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count
			})
		end
	end)

	TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('comserv_msg', GetPlayerName(target), actions_count) }, color = { 147, 196, 109 } })
	TriggerClientEvent('chat:addMessage', target, { args = { _U('judge'), "Razlog osudjivanja: "..razlog }, color = { 147, 196, 109 } })
	TriggerClientEvent('esx_policejob:unrestrain', target)
	TriggerClientEvent('esx_communityservice:inCommunityService', target, actions_count)
end)


















RegisterServerEvent('esx_communityservice:checkIfSentenced')
AddEventHandler('esx_communityservice:checkIfSentenced', function()
	local _source = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(_source)[1] -- get steam identifier

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] ~= nil and result[1].actions_remaining > 0 then
			--TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('jailed_msg', GetPlayerName(_source), ESX.Math.Round(result[1].jail_time / 60)) }, color = { 147, 196, 109 } })
			TriggerClientEvent('esx_communityservice:inCommunityService', _source, tonumber(result[1].actions_remaining))
		end
	end)
end)







function releaseFromCommunityService(target)

	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE from communityservice WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})

			TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('comserv_finished', GetPlayerName(target)) }, color = { 147, 196, 109 } })
		end
	end)

	TriggerClientEvent('esx_communityservice:finishCommunityService', target)
end
