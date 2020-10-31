ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ZadnjaPozicija = 1
local PokrenutZombi = false
local TrajeZombi = false
local Igraci = {}
local ZombiBr = 0
local CovjekBr = 0
local Minuta = 0
local PokrenuoTimer = false

RegisterNetEvent("zombi:SyncajVrijeme")
AddEventHandler('zombi:SyncajVrijeme', function(sec)
	Citizen.CreateThread(function()
		while sec ~= 0 do
			Citizen.Wait(1000)
			sec = sec-1
			TriggerClientEvent('zombi:Vrime', -1, sec)
		end
	end)
end)

TriggerEvent('es:addGroupCommand', 'pokrenizombi', "admin", function(source, args, user)
    if not PokrenutZombi then
		Igraci = {}
		PokrenutZombi = true
		ZadnjaPozicija = 1
		ZombiBr = 0
		CovjekBr = 0
		PokrenuoTimer = false
		TriggerEvent("zombi:Poruka1")
		TriggerEvent("zombi:SyncajVrijeme", 60)
		SetTimeout(30000, function()
			if PokrenutZombi then
				TriggerEvent("zombi:Poruka2")
			end
		end)
	else
		TriggerClientEvent('esx:showNotification', source, "Vec je pokrenut zombi event!")
	end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Nemate ovlasti za ovu komandu!")
end)

TriggerEvent('es:addGroupCommand', 'zaustavizombi', "admin", function(source, args, user)
   if PokrenutZombi then
		PokrenutZombi = false
		TrajeZombi = false
		ZadnjaPozicija = 1
		ZombiBr = 0
		CovjekBr = 0
		TriggerClientEvent('esx:showNotification', source, "Zombi event je zaustavljen!")
		TriggerEvent("zombi:ZavrsiZombi")
	else
		TriggerClientEvent('esx:showNotification', source, "Nema pokrenutog zombi eventa!")
	end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Nemate ovlasti za ovu komandu!")
end)

RegisterCommand("zjoin", function(source, args, rawCommandString)
	if PokrenutZombi and not TrajeZombi then
		TriggerClientEvent("zombi:Joinaj", source)
	else
		TriggerClientEvent('esx:showNotification', source, "Nema pokrenutog zombi eventa!")
	end
end, false)

RegisterNetEvent("zombi:Poruka1")
AddEventHandler('zombi:Poruka1', function()
	ZadnjaPozicija = 1
	ZombiBr = 0
	CovjekBr = 0
	TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Zombi', 'Zapocelo je popunjavanje zombi eventa, da se pridruzite upisite /zjoin!', 'CHAR_PLANESITE', 1)
	TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Zombi', 'Zombi event ce poceti za 60 sekundi!', 'CHAR_PLANESITE', 1)
end)

RegisterNetEvent("zombi:Poruka2")
AddEventHandler('zombi:Poruka2', function()
	if ZadnjaPozicija < 61 then
		TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Zombi', 'U zombi eventu jos ima mjesta, ukoliko zelite sudjelovati upisite /zjoin!', 'CHAR_PLANESITE', 1)
		TriggerClientEvent('esx:showAdvancedNotification', -1, 'Event System', 'Zombi', 'Zombi event ce poceti za 30 sekundi!', 'CHAR_PLANESITE', 1)
	end
	SetTimeout(30000, function()
		if PokrenutZombi then
			TrajeZombi = true
			if #Igraci == 0 then
				TrajeZombi = false
				PokrenutZombi = false
				PokrenuoTimer = false
				ZadnjaPozicija = 1
			end
		end
	end)
end)

RegisterNetEvent("zombi:PovecajPoziciju")
AddEventHandler('zombi:PovecajPoziciju', function(br)
	local _source = source
	if br == 1 then
		CovjekBr = CovjekBr+1
	else
		ZombiBr = ZombiBr+1
	end
	ZadnjaPozicija = ZadnjaPozicija+1
	table.insert(Igraci, {id = _source, Tip = br})
	TriggerClientEvent("zombi:PromjeniStr", -1, CovjekBr, ZombiBr)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	for _, v in pairs(Igraci) do
        if (playerID == v.id) then
			ZadnjaPozicija = ZadnjaPozicija-1
			if v.Tip == 1 then
				CovjekBr = CovjekBr-1
			else
				ZombiBr = ZombiBr-1
			end
			TriggerClientEvent("zombi:PromjeniStr", -1, CovjekBr, ZombiBr)
			if CovjekBr == 0 then
				PokrenutZombi = false
				TrajeZombi = false
				TriggerClientEvent("zombi:Kraj", -1)
				ZadnjaPozicija = 1
				ZombiBr = 0
				CovjekBr = 0
			elseif ZombiBr == 0 then
				PokrenutZombi = false
				TrajeZombi = false
				TriggerClientEvent("zombi:Prekini", -1)
				ZadnjaPozicija = 1
			elseif ZadnjaPozicija == 1 then
				PokrenutZombi = false
				TrajeZombi = false
			end
            break
        end
    end
end)

RegisterNetEvent("zombi:SyncajKraj")
AddEventHandler('zombi:SyncajKraj', function(mina)
	if PokrenuoTimer == false then
		PokrenuoTimer = true
		Minuta = tonumber(mina)
		Citizen.CreateThread(function()
			while Minuta ~= 0 do
				Citizen.Wait(60000)
				Minuta = Minuta-1
				TriggerClientEvent('zombi:VrimeKraj', -1, Minuta)
			end
		end)
	end
end)

RegisterNetEvent("zombi:DajOruzja")
AddEventHandler('zombi:DajOruzja', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon("WEAPON_ASSAULTRIFLE", 500)
	xPlayer.addWeapon("WEAPON_PISTOL", 500)
end)

RegisterNetEvent("zombi:SmanjiPoziciju")
AddEventHandler('zombi:SmanjiPoziciju', function(br)
	local src = source
	ZadnjaPozicija = ZadnjaPozicija-1
	if br == 1 then
		CovjekBr = CovjekBr-1
	else
		ZombiBr = ZombiBr-1
	end
	for i = 1, #Igraci, 1 do
        if src == Igraci[i].id then
			table.remove(Igraci, i)
            break
        end
    end
	TriggerClientEvent("zombi:PromjeniStr", -1, CovjekBr, ZombiBr)
	if CovjekBr == 0 then
		PokrenutZombi = false
		TrajeZombi = false
		CovjekBr = 0
		Minuta = 0
		ZombiBr = 0
		TriggerClientEvent("zombi:Kraj", -1)
		ZadnjaPozicija = 1
	end
end)

RegisterNetEvent("zombi:ZavrsiZombi")
AddEventHandler('zombi:ZavrsiZombi', function()
	ZadnjaPozicija = 1
	ZombiBr = 0
	CovjekBr = 0
	Minuta = 0
	TriggerClientEvent("zombi:Prekini", -1)
end)

ESX.RegisterServerCallback('zombi:DohvatiPoziciju', function(source, cb)
	local vrati = {poz = ZadnjaPozicija, igr = CovjekBr, zom = ZombiBr}
	cb(vrati)
end)

RegisterNetEvent("zombi:Tuljan")
AddEventHandler('zombi:Tuljan', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.addMoney(10000)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Cestitamo!! Pobjedili ste zombi event i dobili $10000!")
end)