ESX = nil

local Koord = {}
local Njive = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'britvasi', Config.MaxInService)
end

MySQL.ready(function()
	UcitajNjive()
end)

function UcitajNjive()
	Njive = {}
	Koord = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM njive',
      {},
      function(result)
        for i=1, #result, 1 do
			table.insert(Njive, {Ime = result[i].Ime})
			local data = json.decode(result[i].Koord1)
			local data2 = json.decode(result[i].Koord2)
			table.insert(Koord, {Njiva = result[i].Ime, Coord = data, Coord2 = data2})
        end
      end
    )
end

RegisterCommand("obrisinjivu", function(source, args, raw)
	if args[1] then
		local Postoji = 0
		for i=1, #Njive, 1 do
			if Njive[i] ~= nil and Njive[i].Ime == args[1] then
				Postoji = 1
			end
		end
		if Postoji == 1 then
			MySQL.Async.execute('DELETE FROM njive WHERE Ime = @ime',{
				['@ime'] = args[1]
			})
			
			for i=1, #Njive, 1 do
				if Njive[i] ~= nil and Njive[i].Ime == args[1] then
					Njive[i].Ime = nil
					Njive[i] = nil
				end
			end
			
			for i=1, #Koord, 1 do
				if Koord[i] ~= nil and Koord[i].Njiva == args[1] then
					Koord[i].Njiva = nil
					Koord[i] = nil
				end
			end
			
			TriggerClientEvent("njive:UpdateKoord", -1, Koord)
			UcitajNjive()
			TriggerClientEvent("njive:UpdateNjive", -1, Njive)
			TriggerClientEvent('esx:showNotification', source, 'Njiva '..args[1]..' uspjesno obrisana!')
		else
			TriggerClientEvent('esx:showNotification', source, 'Njiva sa tim imenom ne postoji!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, '/obrisinjivu [Ime njive]')
	end
end, true)

RegisterCommand("napravinjivu", function(source, args, raw)
	if args[1] then
		local Postoji = 0
		for i=1, #Njive, 1 do
			if Njive[i] ~= nil and Njive[i].Ime == args[1] then
				Postoji = 1
			end
		end
		if Postoji == 1 then
			ESX.ShowNotification("Njiva sa tim imenom vec postoji")
		else
			MySQL.Async.execute('INSERT INTO njive (Ime) VALUES (@ime)',{
				['@ime'] = args[1]
			})
			table.insert(Njive, {Ime = args[1]})
			TriggerClientEvent("njive:UpdateNjive", -1, Njive)
			TriggerClientEvent('esx:showNotification', source, 'Njiva '..args[1]..' uspjesno kreirana!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, '/napravinjivu [Ime njive]')
	end
end, false)

ESX.RegisterServerCallback('njive:DohvatiNjive', function(source, cb)
	local vracaj = {njiv = Njive, kor = Koord}
	cb(vracaj)
end)

RegisterNetEvent('njive:SpremiCoord')
AddEventHandler('njive:SpremiCoord', function(ime, coord, br)
	local x,y,z = table.unpack(coord)
	z = z-1
	coord = table.pack(x,y,z)
	if br == 1 then
		MySQL.Async.execute('UPDATE njive SET Koord1 = @cor WHERE Ime = @im', {
			['@cor'] = json.encode(coord),
			['@im'] = ime
		})
		local Postoji = 0
		for i=1, #Koord, 1 do
			if Koord[i] ~= nil and Koord[i].Njiva == ime then
				Koord[i].Coord = coord
				Postoji = 1
			end
		end
		if Postoji == 0 then
			table.insert(Koord, {Njiva = ime, Coord = coord, Coord2 = nil})
		end
		TriggerClientEvent('esx:showNotification', source, 'Koordinate x1,y1 su uspjesno spremljene za njivu '..ime..'!')
		TriggerClientEvent("njive:UpdateKoord", -1, Koord)
	else
		MySQL.Async.execute('UPDATE njive SET Koord2 = @cor WHERE Ime = @im', {
			['@cor'] = json.encode(coord),
			['@im'] = ime
		})
		local Postoji = 0
		for i=1, #Koord, 1 do
			if Koord[i] ~= nil and Koord[i].Njiva == ime then
				Koord[i].Coord2 = coord
				Postoji = 1
			end
		end
		if Postoji == 0 then
			table.insert(Koord, {Njiva = ime, Coord = nil, Coord2 = coord})
		end
		TriggerClientEvent('esx:showNotification', source, 'Koordinate x2,y2 su uspjesno spremljene za njivu '..ime..'!')
		TriggerClientEvent("njive:UpdateKoord", -1, Koord)
	end
end)
