ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
        local identity = result[1]
        return identity
    else
        return nil
    end
end


--[[ESX.RegisterServerCallback('esx_phone:getItemAmount', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local qtty = xPlayer.getInventoryItem(item).count
    cb(qtty)
end)]]

--[[RegisterServerEvent('esx_dowod:dajitemOdznaka')
AddEventHandler('esx_dowod:dajitemOdznaka', function()
	local XPlayer = ESX.GetPlayerFromId(source)

	local qtty = XPlayer.getInventoryItem('odznaka').count
	if qtty > 1 then
		XPlayer.removeInventoryItem('odznaka', 1)

	elseif qtty < 1 then
		XPlayer.addInventoryItem('odznaka', 1)
	end
end)]]

RegisterServerEvent('esx_dowod:pokaznacke')
AddEventHandler('esx_dowod:pokaznacke', function()	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local job = xPlayer.job
	local name = getIdentity(source)
	local czy_wazna
	if job.name == "police" or "fbi" then
		czy_wazna = "~g~DA"
	else
		job.grade_label = "~r~Nema dostupnih podataka"
		czy_wazna = "~r~NE"
	end
	if job.name == "police" or "fbi" then
	TriggerClientEvent("gln:plateanim", _source)
	Citizen.Wait(3000)
	--TriggerClientEvent('esx:dowod_pokazOdznake', -1,_source, '~h~'..name.firstname..' '..name.lastname, 'Znacka LSPD' , 'Stopień ~b~'..job.grade_label..'~s~~n~Znacka jest ważna '..czy_wazna)
	TriggerClientEvent('esx:dowod_pokazZnacka', -1,_source, '~h~'..name.firstname..' '..name.lastname, 'Znacka' , 'Polozaj ~b~'..job.grade_label)
	else
		TriggerClientEvent('esx:showNotification', _source, ('~r~Ne radite u ~s~Policije!'))
	end

end)
