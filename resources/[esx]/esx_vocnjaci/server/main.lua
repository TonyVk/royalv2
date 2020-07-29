ESX = nil

local Koord = {}
local Vocnjaci = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	UcitajVocnjake()
end)

function UcitajVocnjake()
	Vocnjaci = {}
	Koord = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM vocnjaci',
      {},
      function(result)
        for i=1, #result, 1 do
			table.insert(Vocnjaci, {Ime = result[i].Ime})
			local data = json.decode(result[i].Koord1)
			local data2 = json.decode(result[i].Koord2)
			table.insert(Koord, {Vocnjak = result[i].Ime, Coord = data, Coord2 = data2})
        end
      end
    )
end

RegisterCommand("obrisivocnjak", function(source, args, raw)
	if args[1] then
		local Postoji = 0
		for i=1, #Vocnjaci, 1 do
			if Vocnjaci[i] ~= nil and Vocnjaci[i].Ime == args[1] then
				Postoji = 1
			end
		end
		if Postoji == 1 then
			MySQL.Async.execute('DELETE FROM vocnjaci WHERE Ime = @ime',{
				['@ime'] = args[1]
			})
			
			for i=1, #Vocnjaci, 1 do
				if Vocnjaci[i] ~= nil and Vocnjaci[i].Ime == args[1] then
					Vocnjaci[i].Ime = nil
					Vocnjaci[i] = nil
				end
			end
			
			for i=1, #Koord, 1 do
				if Koord[i] ~= nil and Koord[i].Vocnjak == args[1] then
					Koord[i].Vocnjak = nil
					Koord[i] = nil
				end
			end
			
			TriggerClientEvent("vocnjaci:UpdateKoord", -1, Koord)
			UcitajVocnjake()
			TriggerClientEvent("vocnjaci:UpdateVocnjake", -1, Vocnjaci)
			TriggerClientEvent('esx:showNotification', source, 'Vocnjak '..args[1]..' uspjesno obrisan!')
		else
			TriggerClientEvent('esx:showNotification', source, 'Vocnjak sa tim imenom ne postoji!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, '/obrisivocnjak [Ime vocnjaka]')
	end
end, true)

RegisterCommand("napravivocnjak", function(source, args, raw)
	if args[1] then
		local Postoji = 0
		for i=1, #Vocnjaci, 1 do
			if Vocnjaci[i] ~= nil and Vocnjaci[i].Ime == args[1] then
				Postoji = 1
			end
		end
		if Postoji == 1 then
			ESX.ShowNotification("Vocnjak sa tim imenom vec postoji")
		else
			MySQL.Async.execute('INSERT INTO vocnjaci (Ime) VALUES (@ime)',{
				['@ime'] = args[1]
			})
			table.insert(Vocnjaci, {Ime = args[1]})
			TriggerClientEvent("vocnjaci:UpdateVocnjake", -1, Vocnjaci)
			TriggerClientEvent('esx:showNotification', source, 'Vocnjak '..args[1]..' uspjesno kreiran!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, '/napravivocnjak [Ime vocnjaka]')
	end
end, false)

ESX.RegisterServerCallback('vocnjaci:DohvatiVocnjake', function(source, cb)
	local vracaj = {voc = Vocnjaci, kor = Koord}
	cb(vracaj)
end)

RegisterNetEvent('vocnjaci:SpremiCoord')
AddEventHandler('vocnjaci:SpremiCoord', function(ime, coord, br)
	local x,y,z = table.unpack(coord)
	z = z-1
	coord = table.pack(x,y,z)
	if br == 1 then
		MySQL.Async.execute('UPDATE vocnjaci SET Koord1 = @cor WHERE Ime = @im', {
			['@cor'] = json.encode(coord),
			['@im'] = ime
		})
		local Postoji = 0
		for i=1, #Koord, 1 do
			if Koord[i] ~= nil and Koord[i].Vocnjak == ime then
				Koord[i].Coord = coord
				Postoji = 1
			end
		end
		if Postoji == 0 then
			table.insert(Koord, {Vocnjak = ime, Coord = coord, Coord2 = nil})
		end
		TriggerClientEvent('esx:showNotification', source, 'Koordinate x1,y1 su uspjesno spremljene za vocnjak '..ime..'!')
		TriggerClientEvent("vocnjaci:UpdateKoord", -1, Koord)
	else
		MySQL.Async.execute('UPDATE vocnjaci SET Koord2 = @cor WHERE Ime = @im', {
			['@cor'] = json.encode(coord),
			['@im'] = ime
		})
		local Postoji = 0
		for i=1, #Koord, 1 do
			if Koord[i] ~= nil and Koord[i].Vocnjak == ime then
				Koord[i].Coord2 = coord
				Postoji = 1
			end
		end
		if Postoji == 0 then
			table.insert(Koord, {Vocnjak = ime, Coord = nil, Coord2 = coord})
		end
		TriggerClientEvent('esx:showNotification', source, 'Koordinate x2,y2 su uspjesno spremljene za vocnjak '..ime..'!')
		TriggerClientEvent("vocnjaci:UpdateKoord", -1, Koord)
	end
end)
