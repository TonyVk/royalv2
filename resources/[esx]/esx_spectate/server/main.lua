ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

TriggerEvent('es:addGroupCommand', 'spec', "admin", function(source, args, user)
    TriggerClientEvent('esx_spectate:spectate', source, target)
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Nemate ovlasti!")
end)

ESX.RegisterServerCallback('esx_spectate:getPlayerData', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(tonumber(id))
	local kord = GetEntityCoords(GetPlayerPed(tonumber(id)))
    if xPlayer ~= nil then
        cb(xPlayer, kord, GetPlayerPed(tonumber(id)), tonumber(id))
    end
end)

RegisterServerEvent('esx_spectate:kick')
AddEventHandler('esx_spectate:kick', function(target, msg)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() ~= 'user' then
		DropPlayer(target, msg)
	else
		print(('esx_spectate: %s attempted to kick a player!'):format(xPlayer.identifier))
		DropPlayer(source, "esx_spectate: nemate ovlasti za kickati igraca.")
	end
end)

ESX.RegisterServerCallback('esx_spectate:DohvatiIgrace', function(source, cb)
	local igraci = {}
	for _, playerId in ipairs(GetPlayers()) do
		local name = GetPlayerName(playerId)
		table.insert(igraci, {ID = playerId, Ime = Sanitize(name)})
	end
	cb(igraci)
end)

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

ESX.RegisterServerCallback('esx_spectate:getOtherPlayerData', function(source, cb, target)
        
        local xPlayer = ESX.GetPlayerFromId(target)
        if xPlayer ~= nil then
            local identifier = GetPlayerIdentifiers(target)[1]
            
            local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
                ['@identifier'] = identifier
            })
            
            local user = result[1]
            local firstname = user['firstname']
            local lastname = user['lastname']
            local sex = user['sex']
            local dob = user['dateofbirth']
            local height = user['height'] .. " Centimetri"
            local money = user['money']
            local bank = user['bank']
            
            local data = {
                name = xPlayer.getName(),
                job = xPlayer.job,
                inventory = xPlayer.inventory,
                accounts = xPlayer.accounts,
                weapons = xPlayer.loadout,
                firstname = firstname,
                lastname = lastname,
                sex = sex,
                dob = dob,
                height = height,
                money = money,
                bank = bank
            }
            
            TriggerEvent('esx_license:getLicenses', target, function(licenses)
                data.licenses = licenses
                cb(data)
            end)
        end
end)
