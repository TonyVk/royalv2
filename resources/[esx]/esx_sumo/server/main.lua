ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ZadnjaPozicija = 1
local PokrenutSumo = false
local TrajeSumo = false
local Igraci = {}
local USumo = {}

RegisterNetEvent("sumo:SyncajVrijeme")
AddEventHandler('sumo:SyncajVrijeme', function(sec)
	Citizen.CreateThread(function()
		while sec ~= 0 do
			Citizen.Wait(1000)
			sec = sec-1
			TriggerClientEvent('sumo:Vrime', -1, sec)
		end
	end)
end)

TriggerEvent('es:addGroupCommand', 'pokrenisumo', "admin", function(source, args, user)
    if not PokrenutSumo then
		Igraci = {}
		PokrenutSumo = true
		ZadnjaPozicija = 1
		TriggerEvent("sumo:Poruka1")
		TriggerEvent("sumo:SyncajVrijeme", 60)
		SetTimeout(30000, function()
			if PokrenutSumo then
				TriggerEvent("sumo:Poruka2")
			end
		end)
	else
		TriggerClientEvent('esx:showNotification', source, "Vec je pokrenut sumo!")
	end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Nemate ovlasti za ovu komandu!")
end)

TriggerEvent('es:addGroupCommand', 'zaustavisumo', "admin", function(source, args, user)
   if PokrenutSumo then
		PokrenutSumo = false
		TrajeSumo = false
		ZadnjaPozicija = 1
		TriggerClientEvent('esx:showNotification', source, "Sumo je zaustavljen!")
		TriggerEvent("sumo:ZavrsiSumo")
	else
		TriggerClientEvent('esx:showNotification', source, "Nema pokrenutog sumoa!")
	end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Nemate ovlasti za ovu komandu!")
end)

RegisterCommand("sjoin", function(source, args, rawCommandString)
	if PokrenutSumo and not TrajeSumo then
		TriggerClientEvent("sumo:Joinaj", source)
	else
		TriggerClientEvent('esx:showNotification', source, "Nema pokrenutog sumoa!")
	end
end, false)

RegisterNetEvent("sumo:Poruka1")
AddEventHandler('sumo:Poruka1', function()
	ZadnjaPozicija = 1
	TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Sumo', 'Zapocelo je popunjavanje sumoa, da se pridruzite upisite /sjoin!', 'CHAR_PLANESITE', 1)
	TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Sumo', 'Sumo ce poceti za 60 sekundi!', 'CHAR_PLANESITE', 1)
end)

RegisterNetEvent("sumo:Poruka2")
AddEventHandler('sumo:Poruka2', function()
	if ZadnjaPozicija < 21 then
		TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Sumo', 'U sumou jos ima mjesta, ukoliko zelite sudjelovati upisite /sjoin!', 'CHAR_PLANESITE', 1)
		TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Sumo', 'Sumo ce poceti za 30 sekundi!', 'CHAR_PLANESITE', 1)
	end
	SetTimeout(30000, function()
		if PokrenutSumo then
			TrajeSumo = true
			if #Igraci == 0 then
				TrajeSumo = false
				PokrenutSumo = false
				ZadnjaPozicija = 1
			end
		end
	end)
end)

RegisterNetEvent("sumo:PovecajPoziciju")
AddEventHandler('sumo:PovecajPoziciju', function()
	local _source = source
	ZadnjaPozicija = ZadnjaPozicija+1
	table.insert(Igraci, {id = _source})
	USumo[_source] = true
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	for _, v in pairs(Igraci) do
        if (playerID == v.id) then
			ZadnjaPozicija = ZadnjaPozicija-1
			if ZadnjaPozicija == 2 then
				PokrenutSumo = false
				TrajeSumo = false
				TriggerClientEvent("sumo:Zavrsi", -1)
				ZadnjaPozicija = 1
			elseif ZadnjaPozicija == 1 then
				PokrenutSumo = false
				TrajeSumo = false
			end
            break
        end
    end
end)

RegisterNetEvent("sumo:SmanjiPoziciju")
AddEventHandler('sumo:SmanjiPoziciju', function()
	local src = source
	ZadnjaPozicija = ZadnjaPozicija-1
	for i = 1, #Igraci, 1 do
        if src == Igraci[i].id then
			table.remove(Igraci, i)
            break
        end
    end
	if ZadnjaPozicija == 2 then
		PokrenutSumo = false
		TrajeSumo = false
		TriggerClientEvent("sumo:Zavrsi", -1)
		ZadnjaPozicija = 1
	else
		USumo[src] = false
	end
	if ZadnjaPozicija == 1 then
		PokrenutSumo = false
		TrajeSumo = false
	end
end)

RegisterNetEvent("sumo:ZavrsiSumo")
AddEventHandler('sumo:ZavrsiSumo', function()
	ZadnjaPozicija = 1
	TriggerClientEvent("sumo:Prekini", -1)
end)

ESX.RegisterServerCallback('sumo:DohvatiPoziciju', function(source, cb)
	cb(ZadnjaPozicija)
end)

RegisterNetEvent("sumo:Tuljan")
AddEventHandler('sumo:Tuljan', function()
	local src = source
	if USumo[src] == true then
		local xPlayer = ESX.GetPlayerFromId(src)
		xPlayer.addMoney(5000)
		USumo[src] = false
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Cestitamo!! Prezivjeli ste sumo i dobili $5000!")
		local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(src).."("..xPlayer.identifier..") je dobio $5000"
		TriggerEvent("SpremiLog", por)
	else
		TriggerEvent("DiscordBot:Anticheat", GetPlayerName(src).."["..src.."] je pokusao pozvati event za novac od sumo, a nije u sumo!")
	    TriggerEvent("AntiCheat:Citer", src)
	end
end)