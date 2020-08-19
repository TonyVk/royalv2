ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Biznisi = {}

MySQL.ready(function()
	UcitajBiznise()
end)

function UcitajBiznise()
	Biznisi = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM biznisi',
      {},
      function(result)
        for i=1, #result, 1 do
			local data2 = json.decode(result[i].Koord)
			if result[i].Vlasnik == nil then
				table.insert(Biznisi, {Ime = result[i].Ime, Label = result[i].Label, Posao = result[i].Posao, Kupljen = false, Sef = result[i].Sef, VlasnikIme = "Nema", Coord = data2})
			else
				GetRPName(result[i].Vlasnik, function(Firstname, Lastname)
					local im = Firstname.." "..Lastname
					table.insert(Biznisi, {Ime = result[i].Ime, Label = result[i].Label, Posao = result[i].Posao, Kupljen = true, Sef = result[i].Sef, VlasnikIme = im, Coord = data2})
				end)
			end
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
	local vracaj = {biz = Biznisi}
	cb(vracaj)
end)

RegisterNetEvent('biznis:NapraviBiznis')
AddEventHandler('biznis:NapraviBiznis', function(ime,label)
	MySQL.Async.execute('INSERT INTO biznisi (Ime, Label) VALUES (@ime, @lab)',{
		['@ime'] = ime,
		['@lab'] = label
	})
	table.insert(Biznisi, {Ime = ime, Label = label, Posao = "Nema", Kupljen = false, Sef = 0, VlasnikIme = "Nema"})
	TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
end)

function GetRPName(ident, data)
	local Identifier = ident

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		data(result[1].firstname, result[1].lastname)
	end)
end

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
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
			Biznisi[i].Coord = cordara
		end
	end
	TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
	TriggerClientEvent("biznis:KreirajBlip", -1, cordara, ime)
end)

RegisterNetEvent('biznis:ObrisiBiznis')
AddEventHandler('biznis:ObrisiBiznis', function(ime)
	local src = source
	MySQL.Async.execute('DELETE FROM biznisi WHERE Ime = @ime',{
		['@ime'] = ime
	})
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
			table.remove(Biznisi, i)
		end
	end
	TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
	TriggerClientEvent("biznis:UpdateBlip", -1, ime)
	TriggerClientEvent('esx:showNotification', src, "Obrisali ste biznis "..ime.."!")
end)

RegisterNetEvent('biznis:PostaviVlasnika')
AddEventHandler('biznis:PostaviVlasnika', function(ime, id)
	local src = source
	if tonumber(id) == 0 then
		MySQL.Async.execute('UPDATE biznisi SET Vlasnik = null WHERE Ime = @im', {
			['@im'] = ime
		})
		for i=1, #Biznisi, 1 do
			if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
				Biznisi[i].Kupljen = false
				Biznisi[i].VlasnikIme = "Nema"
				TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
				TriggerClientEvent("biznis:UpdateBlip", -1, ime)
				break
			end
		end
	else
		local xPlayer = ESX.GetPlayerFromId(id)
		if xPlayer ~= nil then
			MySQL.Async.execute('UPDATE biznisi SET Vlasnik = @vl WHERE Ime = @im', {
				['@vl'] = xPlayer.identifier,
				['@im'] = ime
			})
			for i=1, #Biznisi, 1 do
				if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
					Biznisi[i].Kupljen = true
					GetRPName(xPlayer.identifier, function(Firstname, Lastname)
						local im = Firstname.." "..Lastname
						Biznisi[i].VlasnikIme = im
						TriggerClientEvent("biznis:UpdateBiznise", -1, Biznisi)
						TriggerClientEvent("biznis:DajVlasnika", id, ime)
						TriggerClientEvent("biznis:UpdateBlip", -1, ime)
						TriggerClientEvent('esx:showNotification', src, "Postavili ste vlasnika igracu "..GetPlayerName(id).."["..id.."]!")
					end)
					break
				end
			end
		else
			TriggerClientEvent('esx:showNotification', src, "Igrac nije online!")
		end
	end
end)

RegisterNetEvent('biznis:PostaviPosao')
AddEventHandler('biznis:PostaviPosao', function(ime, posao)
	MySQL.Async.execute('UPDATE biznisi SET Posao = @po WHERE Ime = @im', {
		['@po'] = posao,
		['@im'] = ime
	})
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
			Biznisi[i].Posao = posao
		end
	end
end)

RegisterNetEvent('biznis:DajStanje')
AddEventHandler('biznis:DajStanje', function(ime)
	local src = source
	MySQL.Async.fetchAll(
      'SELECT Sef FROM biznisi WHERE Ime = @im',
      { ['@im'] = ime },
      function(result)
        for i=1, #result, 1 do
			TriggerClientEvent('esx:showNotification', src, "Stanje na racunu firme je $"..result[i].Sef)
        end
      end
    )
end)

RegisterNetEvent('biznis:UzmiIzSefa')
AddEventHandler('biznis:UzmiIzSefa', function(ime, cifra)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
			if Biznisi[i].Sef >= cifra then
				Biznisi[i].Sef = Biznisi[i].Sef-cifra
				MySQL.Async.execute('UPDATE biznisi SET Sef = @se WHERE Ime = @im', {
					['@se'] = Biznisi[i].Sef,
					['@im'] = ime
				})
				xPlayer.addMoney(cifra)
				TriggerClientEvent('esx:showNotification', src, "Podigli ste $"..cifra.." sa racuna firme!")
				break
			end
		end
	end
end)

RegisterNetEvent('biznis:StaviUSef')
AddEventHandler('biznis:StaviUSef', function(posao, cifra)
	for i=1, #Biznisi, 1 do
		if Biznisi[i] ~= nil and Biznisi[i].Posao == posao then
			Biznisi[i].Sef = Biznisi[i].Sef+cifra
			MySQL.Async.execute('UPDATE biznisi SET Sef = @se WHERE Posao = @im', {
				['@se'] = Biznisi[i].Sef,
				['@im'] = posao
			})
			break
		end
	end
end)