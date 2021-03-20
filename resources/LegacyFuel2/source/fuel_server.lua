ESX = nil
local Pumpe = {}

if Config.UseESX then

	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	RegisterServerEvent('gorivo:foka')
	AddEventHandler('gorivo:foka', function(price, ime)
		local xPlayer = ESX.GetPlayerFromId(source)
		local amount = ESX.Math.Round(price)

		if price > 0 then
			xPlayer.removeMoney(amount)
			for i=1, #Pumpe, 1 do
				if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
					Pumpe[i].Sef = Pumpe[i].Sef+amount
					MySQL.Async.execute('UPDATE pumpe SET sef = @se WHERE ime = @im', {
						['@se'] = Pumpe[i].Sef,
						['@im'] = ime
					})
					break
				end
			end
		end
	end)
end

MySQL.ready(function()
	UcitajPumpe()
end)

function UcitajPumpe()
	Pumpe = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM pumpe',
      {},
      function(result)
        for i=1, #result, 1 do
			local data2 = json.decode(result[i].koord)
			local vecta = vector3(data2.x, data2.y, data2.z)
			if result[i].vlasnik == nil then
				table.insert(Pumpe, {Ime = result[i].ime, Vlasnik = nil, Sef = result[i].sef, VlasnikIme = "Nema", Koord = vecta, Cijena = result[i].cijena, GCijena = result[i].gcijena, KCijena = result[i].kcijena})
			else
				GetRPName(result[i].vlasnik, function(Firstname, Lastname)
					local im = Firstname.." "..Lastname
					table.insert(Pumpe, {Ime = result[i].ime, Vlasnik = result[i].vlasnik, Sef = result[i].sef, VlasnikIme = im, Koord = vecta, Cijena = result[i].cijena, GCijena = result[i].gcijena, KCijena = result[i].kcijena})
				end)
			end
        end
      end
    )
end

ESX.RegisterServerCallback('pumpe:DohvatiPumpe', function(source, cb)
	cb(Pumpe)
end)

function GetRPName(ident, data)
	local Identifier = ident

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		data(result[1].firstname, result[1].lastname)
	end)
end

RegisterServerEvent('SyncajToGorivo')
AddEventHandler('SyncajToGorivo', function(nid, gorivo)
	TriggerClientEvent("EoSvimaGorivo", -1, nid, gorivo)
end)

ESX.RegisterServerCallback('pumpe:JelVlasnik', function(source, cb, ime)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local naso = false
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil and Pumpe[i].Ime == ime and Pumpe[i].Vlasnik ~= nil then
			if Pumpe[i].Vlasnik == xPlayer.identifier then
				naso = true
				cb(true)
			end
		end
	end
	if not naso then
		cb(false)
	end
end)

RegisterNetEvent('pumpe:DajStanje')
AddEventHandler('pumpe:DajStanje', function(ime)
	local src = source
	MySQL.Async.fetchAll(
      'SELECT sef FROM pumpe WHERE ime = @im',
      { ['@im'] = ime },
      function(result)
        for i=1, #result, 1 do
			TriggerClientEvent('esx:showNotification', src, "Stanje na racunu firme je $"..result[i].sef)
        end
      end
    )
end)

RegisterNetEvent('pumpe:UzmiIzSefa')
AddEventHandler('pumpe:UzmiIzSefa', function(ime, cifra)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
			if Pumpe[i].Sef >= cifra then
				Pumpe[i].Sef = Pumpe[i].Sef-cifra
				MySQL.Async.execute('UPDATE pumpe SET sef = @se WHERE ime = @im', {
					['@se'] = Pumpe[i].Sef,
					['@im'] = ime
				})
				xPlayer.addMoney(cifra)
				TriggerClientEvent('esx:showNotification', src, "Podigli ste $"..cifra.." sa racuna firme!")
				break
			else
				xPlayer.showNotification("Nemate toliko u sefu firme!")
			end
		end
	end
end)

RegisterNetEvent('pumpe:PostaviCijenu')
AddEventHandler('pumpe:PostaviCijenu', function(br, ime, cifra)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if br == 1 then
		for i=1, #Pumpe, 1 do
			if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
				if cifra >= 1.5 then
					Pumpe[i].GCijena = cifra
					MySQL.Async.execute('UPDATE pumpe SET gcijena = @se WHERE ime = @im', {
						['@se'] = Pumpe[i].GCijena,
						['@im'] = ime
					})
					TriggerClientEvent('esx:showNotification', src, "Postavili ste cijenu goriva na $"..cifra.."!")
					TriggerClientEvent("pumpe:SaljiPumpe", -1, Pumpe)
					break
				else
					xPlayer.showNotification("Cijena ne moze biti manja od 1.5$!")
				end
			end
		end
	elseif br == 2 then
		for i=1, #Pumpe, 1 do
			if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
				if cifra >= 250 then
					Pumpe[i].KCijena = cifra
					MySQL.Async.execute('UPDATE pumpe SET kcijena = @se WHERE ime = @im', {
						['@se'] = Pumpe[i].KCijena,
						['@im'] = ime
					})
					TriggerClientEvent('esx:showNotification', src, "Postavili ste cijenu kanistera na $"..cifra.."!")
					TriggerClientEvent("pumpe:SaljiPumpe", -1, Pumpe)
					break
				else
					xPlayer.showNotification("Cijena ne moze biti manja od 250$!")
				end
			end
		end
	end
end)

RegisterServerEvent('pumpe:KupiPumpu')
AddEventHandler('pumpe:KupiPumpu', function(ime)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local naso = false
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
			if tonumber(Pumpe[i].Cijena) <= xPlayer.getMoney() then
				xPlayer.removeMoney(tonumber(Pumpe[i].Cijena))
				Pumpe[i].Vlasnik = xPlayer.identifier
				GetRPName(xPlayer.identifier, function(Firstname, Lastname)
					local im = Firstname.." "..Lastname
					Pumpe[i].VlasnikIme = im
					TriggerClientEvent("pumpe:SaljiPumpe", -1, Pumpe)
				end)
				naso = true
			end
			break
		end
	end
	if naso then
		MySQL.Async.execute('UPDATE pumpe SET vlasnik = @vl WHERE ime = @ime',{
			['@ime'] = ime,
			['@vl'] = xPlayer.identifier
		})
		xPlayer.showNotification("Kupili ste benzinsku pumpu!")
	else
		xPlayer.showNotification("Nemate dovoljno novca!")
	end
end)

RegisterServerEvent('pumpe:ProdajPumpu')
AddEventHandler('pumpe:ProdajPumpu', function(ime)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local naso = false
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
			xPlayer.addMoney(math.floor(Pumpe[i].Cijena/2))
			Pumpe[i].Vlasnik = nil
			Pumpe[i].VlasnikIme = "Nema"
			TriggerClientEvent("pumpe:SaljiPumpe", -1, Pumpe)
			naso = true
			break
		end
	end
	if naso then
		MySQL.Async.execute('UPDATE pumpe SET vlasnik = @vl WHERE ime = @ime',{
			['@ime'] = ime,
			['@vl'] = nil
		})
		xPlayer.showNotification("Prodali ste benzinsku pumpu!")
	end
end)

RegisterServerEvent('pumpe:DodajPumpu')
AddEventHandler('pumpe:DodajPumpu', function(coords, cijena)
	local str = "Pumpa "..#Pumpe+1
	table.insert(Pumpe, {Ime = str, Koord = coords, Vlasnik = nil, Cijena = cijena, Sef = 0, VlasnikIme = "Nema", GCijena = 1.5, KCijena = 250})
	MySQL.Async.execute('INSERT INTO pumpe (ime, koord, vlasnik, cijena, sef, gcijena, kcijena) VALUES (@ime, @koord, @vl, @cij, @sef, @gcij, @kcij)',{
		['@ime'] = str,
		['@koord'] = json.encode(coords),
		['@vl'] = nil,
		['@cij'] = cijena,
		['@sef'] = 0,
		['@gcij'] = 1.5,
		['@kcij'] = 250
	})
	TriggerClientEvent("pumpe:SaljiPumpe", -1, Pumpe)
end)

RegisterServerEvent('pumpe:Premjesti')
AddEventHandler('pumpe:Premjesti', function(ime, koord)
	local naso = false
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
			Pumpe[i].Koord = koord
			naso = true
			break
		end
	end
	TriggerClientEvent("pumpe:SaljiPumpe", -1, Pumpe)
	if naso then
		MySQL.Async.execute('UPDATE pumpe SET koord = @koord WHERE ime = @ime',{
			['@ime'] = ime,
			['@koord'] = json.encode(koord)
		})
	end
end)

RegisterServerEvent('pumpe:MakniVlasnika')
AddEventHandler('pumpe:MakniVlasnika', function(ime)
	local naso = false
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
			Pumpe[i].Vlasnik = nil
			Pumpe[i].VlasnikIme = "Nema"
			TriggerClientEvent("pumpe:SaljiPumpe", -1, Pumpe)
			naso = true
			break
		end
	end
	if naso then
		MySQL.Async.execute('UPDATE pumpe SET vlasnik = @vl WHERE ime = @ime',{
			['@ime'] = ime,
			['@vl'] = nil
		})
	end
end)

RegisterServerEvent('pumpe:UrediCijenu')
AddEventHandler('pumpe:UrediCijenu', function(ime, cij)
	local naso = false
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil and Pumpe[i].Ime == ime then
			Pumpe[i].Cijena = cij
			naso = true
			break
		end
	end
	TriggerClientEvent("pumpe:SaljiPumpe", -1, Pumpe)
	if naso then
		MySQL.Async.execute('UPDATE pumpe SET cijena = @cj WHERE ime = @ime',{
			['@ime'] = ime,
			['@cj'] = cij
		})
	end
end)

RegisterServerEvent('pumpe:Obrisi')
AddEventHandler('pumpe:Obrisi', function(ime)
	for i=1, #Pumpe, 1 do
		if Pumpe[i].Ime == ime then
			table.remove(Pumpe, i)
			break
		end
	end
	TriggerClientEvent("pumpe:SaljiPumpe", -1, Pumpe)
	MySQL.Async.execute('DELETE FROM pumpe WHERE ime = @ime',{
		['@ime'] = ime
	})
end)