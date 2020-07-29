ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("weazel:DodajClanak")
AddEventHandler("weazel:DodajClanak", function(ime, naziv, clanak)
	MySQL.Async.execute('INSERT INTO vijesti (Naziv, Clanak, Autor) VALUES (@naz, @cl, @au)',
	{
		['@naz'] = naziv,
		['@cl']  = clanak,
		['@au']  = ime
	})
	TriggerClientEvent("weazel:SaljiClanak", -1, ime, naziv, clanak)
end)

RegisterNetEvent("weazel:DohvatiVijesti")
AddEventHandler("weazel:DohvatiVijesti", function()
	local _source = source
	MySQL.Async.fetchAll('SELECT * FROM vijesti', {}, function(result)
		for i=1, #result, 1 do
			local rez = result[i]
			TriggerClientEvent("weazel:SaljiClanak", _source, rez.Autor, rez.Naziv, rez.Clanak, 1)
		end
	end)
end)