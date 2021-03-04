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
			table.insert(Vocnjaci, {Ime = result[i].Ime, Cijena = result[i].Cijena, Vlasnik = result[i].Vlasnik})
			local data = json.decode(result[i].Koord1)
			local data2 = json.decode(result[i].Koord2)
			table.insert(Koord, {Vocnjak = result[i].Ime, Coord = data, Coord2 = data2})
        end
		TriggerClientEvent("vocnjaci:UpdateKoord", -1, Koord)
		TriggerClientEvent("vocnjaci:UpdateVocnjake", -1, Vocnjaci)
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
	if args[1] and args[2] then
		local Postoji = 0
		for i=1, #Vocnjaci, 1 do
			if Vocnjaci[i] ~= nil and Vocnjaci[i].Ime == args[1] then
				Postoji = 1
			end
		end
		if Postoji == 1 then
			ESX.ShowNotification("Vocnjak sa tim imenom vec postoji")
		else
			MySQL.Async.execute('INSERT INTO vocnjaci (Ime, Cijena) VALUES (@ime, @cijena)',{
				['@ime'] = args[1],
				['@cijena'] = args[2]
			})
			table.insert(Vocnjaci, {Ime = args[1], Cijena = args[2], Vlasnik = nil})
			TriggerClientEvent("vocnjaci:UpdateVocnjake", -1, Vocnjaci)
			TriggerClientEvent('esx:showNotification', source, 'Vocnjak '..args[1]..' uspjesno kreiran za $'..args[2]..'!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, '/napravivocnjak [Ime vocnjaka][Cijena]')
	end
end, false)

ESX.RegisterServerCallback('vocnjaci:DohvatiVocnjake', function(source, cb)
	local vracaj = {voc = Vocnjaci, kor = Koord}
	cb(vracaj)
end)

ESX.RegisterServerCallback('vocnjaci:JelVlasnik', function(source, cb, ime)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Postoji = 0
	local cijena = 0
	for i=1, #Vocnjaci, 1 do
		if Vocnjaci[i] ~= nil and Vocnjaci[i].Ime == ime then
			cijena = Vocnjaci[i].Cijena
			if Vocnjaci[i].Vlasnik == xPlayer.identifier then
				Postoji = 1
				cb(true, cijena)
			end
		end
	end
	if Postoji == 0 then
		cb(false, cijena)
	end
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

RegisterNetEvent('vocnjaci:Kupi')
AddEventHandler('vocnjaci:Kupi', function(ime)
	print(ime)
	local xPlayer = ESX.GetPlayerFromId(source)
	local kupio = false
	for i=1, #Vocnjaci, 1 do
		if Vocnjaci[i] ~= nil and Vocnjaci[i].Ime == ime then
			if xPlayer.getMoney() >= tonumber(Vocnjaci[i].Cijena) then
				xPlayer.removeMoney(Vocnjaci[i].Cijena)
				Vocnjaci[i].Vlasnik = xPlayer.identifier
				kupio = true
				MySQL.Async.execute('UPDATE vocnjaci SET Vlasnik = @vl WHERE Ime = @im', {
					['@vl'] = xPlayer.identifier,
					['@im'] = ime
				})
				xPlayer.showNotification("Uspjesno ste kupili vocnjak za $"..Vocnjaci[i].Cijena.."!")
				TriggerClientEvent("vocnjaci:UpdateVocnjake", -1, Vocnjaci)
			end
		end
	end
	if not kupio then
		xPlayer.showNotification("Nemate dovoljno novca za ovaj vocnjak!")
	end
end)
