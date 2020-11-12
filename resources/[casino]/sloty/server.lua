ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx_slots:BetsAndMoney")
AddEventHandler("esx_slots:BetsAndMoney", function(bets)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local xItem = xPlayer.getInventoryItem('zeton')
        if xItem.count < 10 then
            TriggerClientEvent('esx:showNotification', _source, "You need at least 10 chips to play!")
        else
            MySQL.Sync.execute("UPDATE users SET zeton=@zetony WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier, ['@zetony'] = xItem.count})
            TriggerClientEvent("esx_slots:UpdateSlots", _source, xItem.count)
            xPlayer.removeInventoryItem('zeton', xItem.count)
        end
    end
end)

RegisterServerEvent("esx_slots:updateCoins")
AddEventHandler("esx_slots:updateCoins", function(bets)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        MySQL.Sync.execute("UPDATE users SET zeton=@zetony WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier, ['@zetony'] = bets})
    end
end)

RegisterServerEvent("esx_slots:PayOutRewards")
AddEventHandler("esx_slots:PayOutRewards", function(amount)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        amount = math.floor(tonumber(amount))
        if amount > 0 then
            xPlayer.addInventoryItem('zeton', amount)
        end
        MySQL.Sync.execute("UPDATE users SET zeton=0 WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
    end
end)

RegisterServerEvent("route68_kasyno:WymienZetony")
AddEventHandler("route68_kasyno:WymienZetony", function(count)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local xItem = xPlayer.getInventoryItem('zeton')
        if xItem.count < count then
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You don`t have that mush chips!'})
        elseif xItem.count >= count then
            local kwota = math.floor(count * 5)
            xPlayer.removeInventoryItem('zeton', count)
            xPlayer.addMoney(kwota)
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You got $'..kwota..' for '..count..' chips.'})
        end
    end
end)

RegisterServerEvent("route68_kasyno:KupZetony")
AddEventHandler("route68_kasyno:KupZetony", function(count)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local cash = xPlayer.getMoney()
        local kwota = math.floor(count * 5)
        if kwota > cash then
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You don`t have that much money!'})
        elseif kwota <= cash then
            xPlayer.addInventoryItem('zeton', count)
            xPlayer.removeMoney(kwota)
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You got '..count..' chips for $'..kwota..'.'})
        end
    end
end)

RegisterServerEvent("route68_kasyno:KupAlkohol")
AddEventHandler("route68_kasyno:KupAlkohol", function(count, item)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local cash = xPlayer.getMoney()
        local kwota = math.floor(count * 10)
        if kwota > cash then
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You don`t have that much money!'})
        elseif kwota <= cash then
            xPlayer.addInventoryItem(item, count)
            xPlayer.removeMoney(kwota)
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You got '..count..' items for $'..count..'.'})
        end
    end
end)

RegisterServerEvent("route68_kasyno:getJoinChips")
AddEventHandler("route68_kasyno:getJoinChips", function()
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT zeton FROM users WHERE @identifier=identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
            local zetony = result[1].zeton
            if zetony > 0 then
                TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You got '..tostring(zetony)..' chips, because you left during slots game.'})
                xPlayer.addInventoryItem('zeton', zetony)
                MySQL.Sync.execute("UPDATE users SET zeton=0 WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
            end
		end
	end)
end)