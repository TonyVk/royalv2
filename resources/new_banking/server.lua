-- ================================================================================================--
-- ==                                VARIABLES - DO NOT EDIT                                     ==--
-- ================================================================================================--
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('banka:predaj')
AddEventHandler('banka:predaj', function(amount)
    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)
    if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
        TriggerClientEvent('chatMessage', _source, _U('invalid_amount'))
    else
        xPlayer.removeMoney(amount)
        xPlayer.addAccountMoney('bank', tonumber(amount))
		ESX.SavePlayer(xPlayer, function() 
		end)
    end
end)

RegisterServerEvent('banka:VratiKredit')
AddEventHandler('banka:VratiKredit', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local base = xPlayer.getAccount('bank').money
	MySQL.Async.fetchAll('SELECT kredit FROM users WHERE identifier = @ident', {
		['@ident'] = xPlayer.identifier
	}, function(result)
		if result[1].kredit <= base then
			xPlayer.removeAccountMoney('bank', tonumber(result[1].kredit))
			MySQL.Async.execute("UPDATE users SET kredit=0, rata=0 WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier})
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Banka',
                               'Zatvaranje kredita',
                               'Kredit uspjesno zatvoren!',
                               'CHAR_BANK_MAZE', 9)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Banka',
                               'Zatvaranje kredita',
                               'Nemate dovoljno novca na racunu za zatvaranje kredita!',
                               'CHAR_BANK_MAZE', 9)
		end
	end)
end)

ESX.RegisterServerCallback('banka:DohvatiKredit', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT kredit, rata, brplaca FROM users WHERE identifier = @ident', {
		['@ident'] = xPlayer.identifier
	}, function(result)
		cb(result[1])
	end)
end)

RegisterServerEvent('banka:podignikredit')
AddEventHandler('banka:podignikredit', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    amount = tonumber(amount)
    if amount == nil or (amount ~= 25000 and amount ~= 50000 and amount ~= 75000 and amount ~= 100000) then
        TriggerClientEvent('chatMessage', _source, "Krivi iznos kredita!")
    else
        xPlayer.addAccountMoney('bank', amount)
		local amounte = 0
		local rata = 0
		if amount == 25000 then
			amounte = amount*1.10
			rata = 25000/100
		elseif amount == 50000 then
			amounte = amount*1.15
			rata = 50000/100
		elseif amount == 75000 then
			amounte = amount*1.20
			rata = 75000/100
		elseif amount == 100000 then
			amounte = amount*1.25
			rata = 100000/100
		end
		MySQL.Async.execute("UPDATE users SET kredit=@kr, rata=@rat WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@kr'] = amounte, ['@rat'] = rata})
		ESX.SavePlayer(xPlayer, function() 
		end)
		local tekse = "Kredit od $"..amount.." uspjesno podignut!"
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Banka',
                               'Podizanje kredita',
                               tekse,
                               'CHAR_BANK_MAZE', 9)
    end
end)

RegisterServerEvent('banka:podigni')
AddEventHandler('banka:podigni', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local base = 0
    amount = tonumber(amount)
    base = xPlayer.getAccount('bank').money
    if amount == nil or amount <= 0 or amount > base then
        TriggerClientEvent('chatMessage', _source, _U('invalid_amount'))
    else
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
		ESX.SavePlayer(xPlayer, function() 
		end)
    end
end)

RegisterNetEvent('bank:balance')
AddEventHandler('bank:balance', function(target)
	if target == nil then
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		balance = xPlayer.getAccount('bank').money
		TriggerClientEvent('currentbalance1', _source, balance)
		TriggerClientEvent("banka:balans", _source, balance)
	else
		local xPlayer = ESX.GetPlayerFromId(target)
		balance = xPlayer.getAccount('bank').money
		TriggerClientEvent('currentbalance1', target, balance)
		TriggerClientEvent("banka:balans", target, balance)
	end
end)

RegisterServerEvent('banka:prebaci')
AddEventHandler('banka:prebaci', function(to, amountt)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0
    if zPlayer ~= nil then
        balance = xPlayer.getAccount('bank').money
        zbalance = zPlayer.getAccount('bank').money
        if tonumber(_source) == tonumber(to) then
            -- advanced notification with bank icon
            TriggerClientEvent('esx:showAdvancedNotification', _source, 'Banka',
                               'Transfer Novca',
                               'Ne mozete prebacit novac samom sebi!',
                               'CHAR_BANK_MAZE', 9)
        else
            if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <=0 then
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Banka', 'Transfer Novca',
                                   'Nemate dovoljno novca za transfer!',
                                   'CHAR_BANK_MAZE', 9)
            else
				amountt = ESX.Math.Round(amountt)
                xPlayer.removeAccountMoney('bank', tonumber(amountt))
                zPlayer.addAccountMoney('bank', tonumber(amountt))
				
				TriggerEvent("DiscordBot:Inventory", GetPlayerName(_source).." je transfer igracu "..GetPlayerName(to).." $"..amountt)
				
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Banka', 'Transfer Novca',
                                   'Prebacili ste ~r~$' .. amountt ..
                                       '~s~ osobi ~r~' .. GetPlayerName(to) .. ' .',
                                   'CHAR_BANK_MAZE', 9)
                TriggerClientEvent('esx:showAdvancedNotification', to, 'Banka',
                                   'Transfer Novca', 'Primili ste ~r~$' ..
                                       amountt .. '~s~ od ~r~' .. GetPlayerName(_source) ..
                                       ' .', 'CHAR_BANK_MAZE', 9)
            end

        end
    end

end)
