ESX = nil

local Metle = {}
local Markeri = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('es:addGroupCommand', 'kazna', 'admin', function(source, args, user)
	if args[1] and GetPlayerName(args[1]) ~= nil and tonumber(args[2]) and args[3] ~= nil then
		local _source = source
		local razlog = table.concat(args, " ", 3)
		TriggerEvent('esx_markeras:sendToCommunityService', tonumber(args[1]), tonumber(args[2]), razlog)
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
			TriggerEvent('esx_markeras:endCommunityServiceCommand', tonumber(args[1]))
			TriggerEvent("DiscordBot:Markeri", GetPlayerName(args[1]).."["..args[1].."] su maknuti markeri od admina "..GetPlayerName(_source))
		else
			TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id')  } } )
		end
	else
		TriggerEvent('esx_markeras:endCommunityServiceCommand', source)
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
	for i=1, #Markeri, 1 do
		if Markeri[i] ~= nil then
			if Markeri[i].ID == src then
				table.remove(Markeri, i)
				break
			end
		end
	end
end)

RegisterServerEvent('esx_markeras:endCommunityServiceCommand')
AddEventHandler('esx_markeras:endCommunityServiceCommand', function(source)
	if source ~= nil then
		releaseFromCommunityService(source)
	end
end)

-- unjail after time served
RegisterServerEvent('esx_markeras:finishCommunityService')
AddEventHandler('esx_markeras:finishCommunityService', function()
	releaseFromCommunityService(source)
end)





RegisterServerEvent('esx_markeras:completeService')
AddEventHandler('esx_markeras:completeService', function()

	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]
	
	local br = 0
	local naso = false
	
	for i=1, #Markeri, 1 do
		if Markeri[i] ~= nil then
			if Markeri[i].ID == _source then
				naso = true
				Markeri[i].Broj = Markeri[i].Broj-1
				br = Markeri[i].Broj
				break
			end
		end
	end

	if naso then
		MySQL.Async.fetchScalar('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)

			if result then
				MySQL.Async.execute('UPDATE communityservice SET actions_remaining = @broj WHERE identifier = @identifier', {
					['@broj'] = br,
					['@identifier'] = identifier
				})
			else
				print ("esx_markeras :: Problem matching player identifier in database to reduce actions.")
			end
		end)
	else
		print("Markeri: Problem sa pronalaskom igraca u tablici: "..identifier)
	end
end)




RegisterServerEvent('esx_markeras:extendService')
AddEventHandler('esx_markeras:extendService', function()

	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	MySQL.Async.fetchScalar('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)

		if result then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining + @extension_value WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@extension_value'] = 500
			})
		else
			print ("esx_markeras :: Problem matching player identifier in database to reduce actions.")
		end
	end)
end)






RegisterServerEvent('esx_markeras:sendToCommunityService')
AddEventHandler('esx_markeras:sendToCommunityService', function(target, actions_count, razlog)

	local identifier = GetPlayerIdentifiers(target)[1]

	MySQL.Async.fetchScalar('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result then
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
	TriggerClientEvent('esx_markeras:inCommunityService', target, actions_count)
	local naso = false
	for i=1, #Markeri, 1 do
		if Markeri[i] ~= nil then
			if Markeri[i].ID == target then
				Markeri[i].Broj = actions_count
				naso = true
				break
			end
		end
	end
	if not naso then
		table.insert(Markeri, {ID = target, Broj = actions_count})
	end
end)


















RegisterServerEvent('esx_markeras:checkIfSentenced')
AddEventHandler('esx_markeras:checkIfSentenced', function()
	local _source = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(_source)[1] -- get steam identifier

	MySQL.Async.fetchScalar('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result ~= nil and result > 0 then
			--TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('jailed_msg', GetPlayerName(_source), ESX.Math.Round(result[1].jail_time / 60)) }, color = { 147, 196, 109 } })
			local naso = false
			for i=1, #Markeri, 1 do
				if Markeri[i] ~= nil then
					if Markeri[i].ID == _source then
						Markeri[i].Broj = tonumber(result)
						naso = true
						break
					end
				end
			end
			if not naso then
				table.insert(Markeri, {ID = _source, Broj = tonumber(result)})
			end
			TriggerClientEvent('esx_markeras:inCommunityService', _source, tonumber(result))
		end
	end)
end)



ESX.RegisterServerCallback('esx_markeras:ProvjeriMarkere', function(source, cb)
	local _source = source -- cannot parse source to client trigger for some weird reason

	for i=1, #Markeri, 1 do
		if Markeri[i] ~= nil then
			if Markeri[i].ID == _source then
				cb(Markeri[i].Broj)
				break
			end
		end
	end
end)

ESX.RegisterServerCallback('esx_markeras:DohvatiMarkere', function(source, cb)
	local _source = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(_source)[1] -- get steam identifier

	MySQL.Async.fetchScalar('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result ~= nil then
			cb(result)
		else
			cb(nil)
		end
	end)
end)

function releaseFromCommunityService(target)

	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchScalar('SELECT actions_remaining FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result then
			MySQL.Async.execute('DELETE from communityservice WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})

			TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('comserv_finished', GetPlayerName(target)) }, color = { 147, 196, 109 } })
		end
	end)

	TriggerClientEvent('esx_markeras:finishCommunityService', target)
	
	for i=1, #Markeri, 1 do
		if Markeri[i] ~= nil then
			if Markeri[i].ID == target then
				table.remove(Markeri, i)
				break
			end
		end
	end
end
