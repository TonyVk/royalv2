ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("vockice:BetsAndMoney")
AddEventHandler("vockice:BetsAndMoney", function(bets)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local xItem = xPlayer.getInventoryItem('zeton')
        if xItem.count < 10 then
            TriggerClientEvent('esx:showNotification', _source, "Trebate minimalno 10 zetona!")
        else
            MySQL.Sync.execute("UPDATE users SET zeton=@zetony WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier, ['@zetony'] = xItem.count})
            TriggerClientEvent("vockice:UpdateSlots", _source, xItem.count)
            xPlayer.removeInventoryItem('zeton', xItem.count)
			TriggerEvent("DiscordBot:Zetoni", xPlayer.name.."["..xPlayer.source.."] je poceo igrati vockice sa "..xItem.count.." zetona.")
        end
    end
end)

RegisterServerEvent("vockice:updateCoins")
AddEventHandler("vockice:updateCoins", function(bets)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        MySQL.Sync.execute("UPDATE users SET zeton=@zetony WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier, ['@zetony'] = bets})
    end
end)

RegisterServerEvent("vockice:PayOutRewards")
AddEventHandler("vockice:PayOutRewards", function(amount)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        amount = math.floor(tonumber(amount))
        if amount > 0 then
            xPlayer.addInventoryItem('zeton', amount)
			TriggerEvent("DiscordBot:Zetoni", xPlayer.name.."["..xPlayer.source.."] je izaso iz vockica sa "..amount.." zetona.")
        end
        MySQL.Sync.execute("UPDATE users SET zeton=0 WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
    end
end)

RegisterServerEvent("vockice:WymienZetony")
AddEventHandler("vockice:WymienZetony", function(count)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local xItem = xPlayer.getInventoryItem('zeton')
        if xItem.count < count then
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'Nemate toliko zetona!', layout = "bottomCenter"})
        elseif xItem.count >= count then
            local kwota = math.floor(count * 5)
            xPlayer.removeInventoryItem('zeton', count)
            xPlayer.addMoney(kwota)
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'Dobili ste $'..kwota..' za '..count..' zetona.', layout = "bottomCenter"})
			TriggerEvent("DiscordBot:Zetoni", xPlayer.name.."["..xPlayer.source.."] je dobio $"..kwota.." za "..count.." zetona.")
        end
    end
end)

RegisterServerEvent("vockice:KupZetony")
AddEventHandler("vockice:KupZetony", function(count)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local cash = xPlayer.getMoney()
        local kwota = math.floor(count * 5)
        if kwota > cash then
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'Nemate toliko novca!', layout = "bottomCenter"})
        elseif kwota <= cash then
            xPlayer.addInventoryItem('zeton', count)
            xPlayer.removeMoney(kwota)
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'Dobili ste '..count..' zetona za $'..kwota..'.', layout = "bottomCenter"})
			TriggerEvent("DiscordBot:Zetoni", xPlayer.name.."["..xPlayer.source.."] je kupio "..count.." zetona za $"..kwota..".")
        end
    end
end)

RegisterServerEvent("vockice:KupAlkohol")
AddEventHandler("vockice:KupAlkohol", function(count, item)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local cash = xPlayer.getMoney()
        local kwota = math.floor(count * 10)
        if kwota > cash then
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'Nemate toliko novca!', layout = "bottomCenter"})
        elseif kwota <= cash then
            xPlayer.addInventoryItem(item, count)
            xPlayer.removeMoney(kwota)
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'Dobili ste '..count..' predmeta za $'..count..'.', layout = "bottomCenter"})
        end
    end
end)

RegisterServerEvent("vockice:getJoinChips")
AddEventHandler("vockice:getJoinChips", function()
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT zeton FROM users WHERE @identifier=identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
            local zetony = result[1].zeton
            if zetony > 0 then
                TriggerClientEvent('pNotify:SendNotification', _source, {text = 'Dobili ste '..tostring(zetony)..' zetona, zato sto ste izasli iz igre za vrijeme kladjenja.', layout = "bottomCenter"})
                xPlayer.addInventoryItem('zeton', zetony)
                MySQL.Sync.execute("UPDATE users SET zeton=0 WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
            end
		end
	end)
end)