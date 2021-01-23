ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Vozila = {}

MySQL.ready(function()
	UcitajVozila()
end)

function UcitajVozila()
	MySQL.Async.fetchAll('SELECT seller, vehicleProps, plate, price FROM vehicles_for_sale WHERE prodan = 0', {}, function(result)
		for i=1, #result, 1 do
			table.insert(Vozila, { Vlasnik = result[i].seller, Tablica = result[i].plate, Props = json.decode(result[i].vehicleProps), Cijena = result[i].price })
		end
	end)
end

RegisterServerEvent('pijaca:ProvjeriProdane')
AddEventHandler('pijaca:ProvjeriProdane', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT id, price FROM vehicles_for_sale WHERE seller = @id AND prodan = 1', 
	{
		['@id'] = xPlayer.identifier
	}, function(result)
		for i=1, #result, 1 do
			xPlayer.showNotification("Prodali ste vozilo na pijaci za $"..result[i].price.."!")
			xPlayer.addMoney(result[i].price)
			MySQL.Async.execute('DELETE from vehicles_for_sale WHERE id = @id', 
			{
				['@id'] = result[i].id
			}, function(rowsChanged)
			end)
			Wait(100)
		end
	end)
end)

RegisterServerEvent('pijaca:StaviNaProdaju')
AddEventHandler('pijaca:StaviNaProdaju', function(vehicle, cijena, mj, br)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute('INSERT INTO vehicles_for_sale (seller, vehicleProps, plate, price, mjenjac, prodan) VALUES (@owner, @props, @plate, @price, @mj, @prodan)', {
		['@owner']   = xPlayer.identifier,
		['@props']   = json.encode(vehicle),
		['@plate']   = vehicle.plate,
		['@price'] = cijena,
		['@mj'] = mj,
		['@prodan'] = 0
	}, function(rowsChanged)
	end)
	table.insert(Vozila, { Vlasnik = xPlayer.identifier, NetID = netid, Tablica = vehicle.plate, Props = vehicle, Cijena = cijena })
	TriggerClientEvent("pijaca:EoTiVozila", -1, Vozila)
end)

RegisterServerEvent('pijaca:Tuljani')
AddEventHandler('pijaca:Tuljani', function(plate, prop, mj)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local naso = 0
	for i=1, #Vozila, 1 do
		if Vozila[i].Tablica == plate then
			naso = 1
			if Vozila[i].Vlasnik ~= xPlayer.identifier then
				if xPlayer.getMoney() >= Vozila[i].Cijena then
					xPlayer.removeMoney(Vozila[i].Cijena)
					local tPlayer = ESX.GetPlayerFromIdentifier(Vozila[i].Vlasnik)
					if tPlayer then
						tPlayer.addMoney(Vozila[i].Cijena)
						tPlayer.showNotification('Prodali ste vozilo za $'..Vozila[i].Cijena)
						MySQL.Async.execute('DELETE from vehicles_for_sale WHERE plate = @pl AND seller = @ow', {
							['@pl'] = Vozila[i].Tablica,
							['@ow'] = Vozila[i].Vlasnik
						}, function(rowsChanged)
						end)
					else
						MySQL.Async.execute('UPDATE vehicles_for_sale SET prodan = @br WHERE plate = @pl', {
							['@br'] = 1,
							['@pl'] = Vozila[i].Tablica
						})
					end
					MySQL.Async.execute('UPDATE owned_vehicles SET owner = @ow WHERE plate = @pl', {
						['@ow'] = xPlayer.identifier,
						['@pl'] = Vozila[i].Tablica
					})
					xPlayer.showNotification("Kupili ste vozilo za $"..Vozila[i].Cijena)
					local co = vector3(-32.124626159668, -1692.5814208984, 27.528295516968)
					SpawnMiVozilo(prop, co, 201.81, plate, mj)
					TriggerEvent("DiscordBot:Vozila", GetPlayerName(_source).." je kupio vozilo["..plate.."] na pijaci za $"..Vozila[i].Cijena)
					--TriggerClientEvent("pijaca:OdmrzniGa", _source, netid)
					table.remove(Vozila, i)
					TriggerClientEvent("pijaca:EoTiVozila", -1, Vozila)
					break
				else
					xPlayer.showNotification("Nemate dovoljno novca!")
				end
			else
				xPlayer.showNotification('Maknuli ste vozilo sa pijace!')
				MySQL.Async.execute('DELETE from vehicles_for_sale WHERE plate = @pl AND seller = @ow', {
					['@pl'] = Vozila[i].Tablica,
					['@ow'] = xPlayer.identifier
				}, function(rowsChanged)
				end)
				local co = vector3(-32.124626159668, -1692.5814208984, 27.528295516968)
				SpawnMiVozilo(prop, co, 201.81, plate, mj)
				--TriggerClientEvent("pijaca:OdmrzniGa", _source, netid)
				table.remove(Vozila, i)
				TriggerClientEvent("pijaca:EoTiVozila", -1, Vozila)
				break
			end
		end
	end
	if naso == 0 then
		xPlayer.showNotification("Nazalost vozilo je vec prodano!")
	end
end)

function SpawnMiVozilo(vehicle, co, he, plate, mj)
	local _source = source
	local veh = CreateVehicle(vehicle.model, co, he, true, false)
	while not DoesEntityExist(veh) do
		Wait(100)
	end
	local netid = NetworkGetNetworkIdFromEntity(veh)
	Wait(500)
	TriggerClientEvent("pijaca:VratiVozilo", _source, netid, vehicle, plate, mj, co)
end

ESX.RegisterServerCallback('pijaca:DohvatiVozila', function(source, cb)
    cb(Vozila)
end)

ESX.RegisterServerCallback('pijaca:JelNaProdaju', function(source, cb, tablica)
	MySQL.Async.fetchAll('SELECT 1 FROM vehicles_for_sale WHERE plate = @pl AND prodan = 0', 
	{
		['@pl'] = tablica
	}, function(result)
		if result[1] ~= nil then
			cb(true)
		else
			cb(false)
		end
	end)
end)