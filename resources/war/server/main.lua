ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("War:Posalji")
AddEventHandler('War:Posalji', function(id, id2, kol)
	TriggerClientEvent("War:Saljem", id, kol, 1)
	TriggerClientEvent("War:Saljem", id2, kol, 2)
	TriggerClientEvent('esx_basicneeds:healPlayer', id)
	TriggerClientEvent('esx_basicneeds:healPlayer', id2)
end)

RegisterNetEvent("War:SyncSpawnove")
AddEventHandler('War:SyncSpawnove', function(tim, br)
	TriggerClientEvent("War:VratioSpawnove", -1, tim, br)
end)

ESX.RegisterServerCallback('War:DohvatiMiLidera', function(source, cb)
	local targetXPlayer = ESX.GetPlayerFromId(source)
	if targetXPlayer.job.grade_name == 'boss' or targetXPlayer.job.grade_name == 'vlasnik' then
		cb(1)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('War:DohvatiLidera', function(source, cb, id, id2)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	local targetXPlayer2 = ESX.GetPlayerFromId(id2)
	if targetXPlayer ~= nil and targetXPlayer2 ~= nil then
		local result = MySQL.Sync.fetchAll('SELECT job,job_grade FROM users WHERE identifier = @identifier', {
			['@identifier'] = targetXPlayer.identifier
		})
		local result2 = MySQL.Sync.fetchAll('SELECT job,job_grade FROM users WHERE identifier = @identifier', {
			['@identifier'] = targetXPlayer2.identifier
		})
		local result3 = MySQL.Sync.fetchAll('SELECT name FROM job_grades WHERE grade = @gra AND job_name = @jname', {
			['@gra'] = result[1].job_grade,
			['@jname'] = result[1].job
		})
		local result4 = MySQL.Sync.fetchAll('SELECT name FROM job_grades WHERE grade = @gra AND job_name = @jname', {
			['@gra'] = result2[1].job_grade,
			['@jname'] = result2[1].job
		})
		if (result3[1].name == 'boss' or result3[1].name == 'vlasnik') and (result4[1].name == 'boss' or result4[1].name == 'vlasnik') then
			cb(1)
		else
			cb(0)
		end
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('War:DohvatiPosao', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.job.name)
end)

ESX.RegisterServerCallback('War:DohvatiIgraca', function(source, cb, id)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	local xPlayer = ESX.GetPlayerFromId(source)
	if targetXPlayer ~= nil then
		if targetXPlayer.job.name == xPlayer.job.name then
			cb(1)
		else
			cb(0)
		end
	else
		cb(0)
	end
end)

RegisterNetEvent("War:Pozovi")
AddEventHandler('War:Pozovi', function(id, tim)
	if tim == 1 then
		TriggerClientEvent("War:Pozivam", id, 1)
	elseif tim == 2 then
		TriggerClientEvent("War:Pozivam", id, 2)
	end
	TriggerClientEvent('esx_basicneeds:healPlayer', id)
end)

RegisterNetEvent("War:ProvjeriBroj")
AddEventHandler('War:ProvjeriBroj', function()
	TriggerClientEvent('War:ProvjeraBroja', -1)
end)

RegisterNetEvent("War:Povecaj")
AddEventHandler('War:Povecaj', function(br)
	if br == 1 then
		TriggerClientEvent('War:PovecajTim', -1, 1)
	elseif br == 2 then
		TriggerClientEvent('War:PovecajTim', -1, 2)
	end
end)

RegisterNetEvent("War:Resetiraj")
AddEventHandler('War:Resetiraj', function()
	TriggerClientEvent('War:Resetira', -1)
end)

RegisterNetEvent("War:Zaustavi")
AddEventHandler('War:Zaustavi', function()
	TriggerClientEvent('War:Zavrsi', -1)
end)

RegisterNetEvent("War:SyncajPoslao")
AddEventHandler('War:SyncajPoslao', function(tip, br)
	if tip == 1 then
	TriggerClientEvent('War:VratiPoslao', -1, 1, br)
	else
	TriggerClientEvent('War:VratiPoslao', -1, 2, br)
	end
end)

RegisterNetEvent("War:ZaustaviIgracu")
AddEventHandler('War:ZaustaviIgracu', function(id)
	TriggerClientEvent('War:ZavrsiIgracu', id)
end)

RegisterNetEvent("War:DajOruzja")
AddEventHandler('War:DajOruzja', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon("WEAPON_PUMPSHOTGUN", 500)
	xPlayer.addWeapon("WEAPON_ASSAULTRIFLE", 500)
	xPlayer.addWeapon("WEAPON_MICROSMG", 500)
	xPlayer.addWeapon("WEAPON_PISTOL", 500)
end)

RegisterNetEvent("War:ObrisiLoadout")
AddEventHandler('War:ObrisiLoadout', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local weapons = {}
	MySQL.Async.execute('UPDATE users SET `loadout` = @loadout WHERE identifier = @identifier', {
			['@loadout']    = json.encode(weapons),
			['@identifier'] = xPlayer.identifier
	})
end)

RegisterNetEvent("War:SpremiLoadout")
AddEventHandler('War:SpremiLoadout', function(weaponName, am)
	local xPlayer = ESX.GetPlayerFromId(source)
	local weapons = nil
	local result = MySQL.Sync.fetchAll('SELECT loadout FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	Wait(50)
	if result[1].data ~= nil then
		weapons = json.decode(result[1].data)
	end
	if weapons == nil then
      weapons = {}
	end
    table.insert(weapons, {
        name  = weaponName,
        ammo = am
    })
	MySQL.Async.execute('UPDATE users SET `loadout` = @loadout WHERE identifier = @identifier', {
			['@loadout']    = json.encode(weapons),
			['@identifier'] = xPlayer.identifier
	})
end)

ESX.RegisterServerCallback('War:ImalIsta', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll('SELECT 1 FROM waroruzja WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	if result[1] == nil or result[1] == 0 then
		cb(0)
	else
		cb(1)
	end
end)

RegisterNetEvent("War:Zaustavi2")
AddEventHandler('War:Zaustavi2', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM waroruzja WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	if result[1] == nil or result[1] == 0 then
		print("Nije pronaso")
	else
		local weapons  = json.decode(result[1].data)
		for j=1, #weapons, 1 do
			xPlayer.addWeapon(weapons[j].name, weapons[j].ammo)
		end
		MySQL.Async.execute('DELETE FROM waroruzja WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})
	end
	ESX.SavePlayer(xPlayer, function()
	end)
end)

RegisterNetEvent("War:ObrisiGovno")
AddEventHandler('War:ObrisiGovno', function(weaponName, am)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeWeapon(weaponName)
end)

RegisterNetEvent("War:DajInv")
AddEventHandler('War:DajInv', function(weaponName, am)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeWeapon(weaponName)
	local weapons = nil
	local result = MySQL.Sync.fetchAll('SELECT data FROM waroruzja WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	if #result == 0 then
	MySQL.Sync.execute('INSERT INTO waroruzja (ID, identifier, data) VALUES (NULL, @identifier, \'{}\')', {
		['@identifier'] = xPlayer.identifier
	})
	end
	result = MySQL.Sync.fetchAll('SELECT data FROM waroruzja WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	Wait(50)
	weapons = json.decode(result[1].data)
	if weapons == nil then
      weapons = {}
	end
    table.insert(weapons, {
        name  = weaponName,
        ammo = am
    })
	MySQL.Async.execute('UPDATE waroruzja SET data = @data WHERE identifier = @identifier', {
		['@data'] = json.encode(weapons),
		['@identifier'] = xPlayer.identifier,
	})
end)

RegisterNetEvent("War:SpremiGa")
AddEventHandler('War:SpremiGa', function(banda, tip)
	SpremiPodatke(banda, tip)
end)

function SpremiPodatke(banda, tip)
	local win = 0
	local lose = 0
	local result = MySQL.Sync.fetchAll('SELECT * FROM warovi WHERE Ime = @identifier', {
		['@identifier'] = banda
	})
	if #result == 0 then
	MySQL.Sync.execute('INSERT INTO warovi (ID, Ime, Win, Lose) VALUES (NULL, @identifier, 0, 0)', {
		['@identifier'] = banda
	})
	end
	result = MySQL.Sync.fetchAll('SELECT * FROM warovi WHERE Ime = @identifier', {
		['@identifier'] = banda
	})
	win = result[1].Win
	lose = result[1].Lose
	if tip == 1 then
		win = win+1
	elseif tip == 2 then
		lose = lose+1
	end
	MySQL.Async.execute('UPDATE warovi SET Win = @wina, Lose = @los WHERE Ime = @identifier', {
		['@wina'] = win,
		['@los'] = lose,
		['@identifier'] = banda
	})
end

RegisterNetEvent("War:SpremiPocela")
AddEventHandler('War:SpremiPocela', function(br)
	TriggerClientEvent('War:VratiPocela', -1, br)
end)

RegisterNetEvent("War:SyncajTraje")
AddEventHandler('War:SyncajTraje', function(br)
	TriggerClientEvent('War:VratiTraje', -1, br)
end)

RegisterNetEvent("War:SyncTimove")
AddEventHandler('War:SyncTimove', function(t1, t2)
	TriggerClientEvent('War:VratiTimove', -1, t1, t2)
end)

RegisterNetEvent("War:SyncVrijeme")
AddEventHandler('War:SyncVrijeme', function(mi)
	TriggerClientEvent('War:VratiVrijeme', -1, mi)
end)

RegisterNetEvent("War:SyncajVrijeme")
AddEventHandler('War:SyncajVrijeme', function(sec)
	Citizen.CreateThread(function()
	while sec ~= 0 do
    Citizen.Wait(1000)
	sec = sec-1
    TriggerClientEvent('War:Vrime', -1, sec)
	end
	end)
end)

RegisterNetEvent("War:PosaljiKill")
AddEventHandler('War:PosaljiKill', function(id, id2)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	local targetXPlayer2 = ESX.GetPlayerFromId(id2)
	local Isti = 0
	if targetXPlayer.job.name == targetXPlayer2.job.name then
		Isti = 1
	else
		Isti = 0
	end
    TriggerClientEvent('War:VratiKill', id, id2, Isti)
end)

RegisterNetEvent("War:PosaljiPoruku")
AddEventHandler('War:PosaljiPoruku', function(str)
    TriggerClientEvent('War:VratiPoruku', -1, str)
end)

RegisterNetEvent("War:SyncajScore")
AddEventHandler('War:SyncajScore', function(tim1, tim2)
    TriggerClientEvent('War:VratiScore', -1, tim1, tim2)
end)

RegisterNetEvent("War:SyncajKraj")
AddEventHandler('War:SyncajKraj', function(mina)
	Citizen.CreateThread(function()
	while mina ~= 0 do
    Citizen.Wait(60000)
	mina = mina-1
	TriggerClientEvent('War:VrimeKraj', -1, mina)
	end
	end)
end)