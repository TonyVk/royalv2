ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Biznisi = {}
local Koord = {}

MySQL.ready(function()
	UcitajBiznise()
end)

function UcitajBiznise()
	Biznisi = {}
	Koord = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM biznisi',
      {},
      function(result)
        for i=1, #result, 1 do
			if result[i].Vlasnik == nil then
				table.insert(Biznisi, {Ime = result[i].Ime, Label = result[i].Label, Kupljen = false})
			else
				table.insert(Biznisi, {Ime = result[i].Ime, Label = result[i].Label, Kupljen = true})
			end
			table.insert(Biznisi, {Ime = result[i].Ime, Label = result[i].Label})
			local data2 = json.decode(result[i].Koord)
			table.insert(Koord, {Biznis = result[i].Ime, Coord = data2})
        end
      end
    )
end

ESX.RegisterServerCallback('biznis:DohvatiVlasnika', function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local Ime = nil
	MySQL.Async.fetchAll(
      'SELECT Ime FROM biznisi WHERE Vlasnik = @ident',
      { ['@ident'] = xPlayer.identifier },
      function(result)
        for i=1, #result, 1 do
			Ime = result[i].Ime
        end
		cb(Ime)
      end
    )
end)

ESX.RegisterServerCallback('biznis:DohvatiBiznise', function(source, cb)
	local vracaj = {biz = Biznisi, kor = Koord}
	cb(vracaj)
end)

RegisterNetEvent('biznis:NapraviBiznis')
AddEventHandler('biznis:NapraviBiznis', function(ime,label)
	MySQL.Async.execute('INSERT INTO biznisi (Ime, Label) VALUES (@ime, @lab)',{
		['@ime'] = ime,
		['@lab'] = label
	})
	table.insert(Biznisi, {Ime = ime, Label = label, Kupljen = false})
	TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
end)

RegisterNetEvent('biznis:PostaviKoord')
AddEventHandler('biznis:PostaviKoord', function(ime, koord)
	local x,y,z = table.unpack(koord)
	z = z-1
	local cordara = {}
	table.insert(cordara, x)
	table.insert(cordara, y)
	table.insert(cordara, z)
	MySQL.Async.execute('UPDATE biznisi SET Koord = @kor WHERE Ime = @im', {
		['@kor'] = json.encode(cordara),
		['@im'] = ime
	})
	local Postoji = 0
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil and Koord[i].Biznis == ime then
			Koord[i].Coord = cordara
			Postoji = 1
		end
	end
	if Postoji == 0 then
		table.insert(Koord, {Biznis = ime, Coord = cordara})
	end
	TriggerClientEvent("biznis:UpdateKoord", -1, Koord)
end)