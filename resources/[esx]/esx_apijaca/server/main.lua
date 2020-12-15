ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Vozila = {}

local Lokacije = {
	{x = 897.39471435547, y = -73.840759277344, z = 78.223876953125, h = 57.113529205322}, --mjesto1
	{x = 899.37408447266, y = -70.670104980469, z = 78.223770141602, h = 57.697650909424}, --mjesto2
	{x = 901.20269775391, y = -67.738151550293, z = 78.223793029785, h = 58.33179473877}, --mjesto3
	{x = 902.96380615234, y = -64.748306274414, z = 78.223808288574, h = 57.740776062012}, --mjesto4
	{x = 904.80084228516, y = -61.831848144531, z = 78.223846435547, h = 57.39688873291}, --mjesto5
	{x = 906.63806152344, y = -58.716709136963, z = 78.223976135254, h = 58.452045440674}, --mjesto6
	{x = 908.40502929688, y = -55.989116668701, z = 78.223686218262, h = 58.20686340332}, --mjesto7
	{x = 910.41711425781, y = -53.19612121582, z = 78.223808288574, h = 56.633651733398}, --mjesto8
	{x = 912.07922363281, y = -50.140312194824, z = 78.223823547363, h = 58.322368621826}, --mjesto9
	{x = 913.84106445313, y = -47.288665771484, z = 78.223770141602, h = 57.286602020264}, --mjesto10
	{x = 915.79498291016, y = -44.492713928223, z = 78.223823547363, h = 58.228252410889}, --mjesto11
	{x = 917.61340332031, y = -41.570022583008, z = 78.223747253418, h = 56.527641296387}, --mjesto12
	{x = 919.67987060547, y = -38.454807281494, z = 78.223648071289, h = 58.487590789795}, --mjesto13
	{x = 908.11291503906, y = -31.545877456665, z = 78.223701477051, h = 237.83882141113}, --mjesto14
	{x = 906.27215576172, y = -34.905948638916, z = 78.223754882813, h = 238.55699157715}, --mjesto15
	{x = 904.48736572266, y = -37.782585144043, z = 78.223693847656, h = 237.47985839844}, --mjesto16
	{x = 902.45263671875, y = -40.606674194336, z = 78.223770141602, h = 237.82391357422}, --mjesto17
	{x = 900.70947265625, y = -43.644153594971, z = 78.223777770996, h = 237.19450378418}, --mjesto18
	{x = 898.93103027344, y = -46.556648254395, z = 78.223731994629, h = 237.77868652344}, --mjesto19
	{x = 897.11517333984, y = -49.507202148438, z = 78.223762512207, h = 237.70567321777}, --mjesto20
	{x = 895.29998779297, y = -52.395126342773, z = 78.223648071289, h = 239.08903503418}, --mjesto21
	{x = 893.41979980469, y = -55.320140838623, z = 78.223861694336, h = 237.78500366211}, --mjesto22
	{x = 891.66394042969, y = -58.307960510254, z = 78.223709106445, h = 238.35643005371}, --mjesto23
	{x = 889.72900390625, y = -61.109397888184, z = 78.223976135254, h = 239.26565551758}, --mjesto24
	{x = 887.90374755859, y = -64.03946685791, z = 78.224235534668, h = 237.68322753906}, --mjesto25
	{x = 886.11840820313, y = -67.078979492188, z = 78.223770141602, h = 239.32939147949} --mjesto26
}

local Spawnana = false

function SpawnVozilo(vehicle, i)
	local veh = CreateVehicle(vehicle.model, Lokacije[i].x, Lokacije[i].y, Lokacije[i].z, Lokacije[i].h, true, false)
	while not DoesEntityExist(veh) do
		Wait(100)
	end
	local netid = NetworkGetNetworkIdFromEntity(veh)
	Wait(500)
	Vozila[i].NetID = netid
	SetVehicleNumberPlateText(veh, vehicle.plate)
	TriggerClientEvent("pijaca:EoTiVozila", -1, Vozila)
	TriggerClientEvent("pijaca:OdradiTuning", -1)
end

RegisterServerEvent('pijaca:ProvjeriProdane')
AddEventHandler('pijaca:ProvjeriProdane', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT * FROM vehicles_for_sale WHERE seller = @id AND prodan = 1', 
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
		end
	end)
end)

RegisterServerEvent('pijaca:SpawnVozila')
AddEventHandler('pijaca:SpawnVozila', function()
	local src = source
	if Spawnana == false then
		MySQL.Async.fetchAll('SELECT * FROM vehicles_for_sale WHERE prodan = 0', {}, function(result)
			for i=1, #result, 1 do
				table.insert(Vozila, { Vlasnik = result[i].seller, NetID = 0, Tablica = result[i].plate, Props = json.decode(result[i].vehicleProps), Cijena = result[i].price })
				SpawnVozilo(json.decode(result[i].vehicleProps), i)
			end
		end)
		Spawnana = true
	end
end)

RegisterServerEvent('pijaca:StaviNaProdaju')
AddEventHandler('pijaca:StaviNaProdaju', function(vehicle, cijena, mj, br)
	local _source = source
	local veh = CreateVehicle(vehicle.model, Lokacije[br].x, Lokacije[br].y, Lokacije[br].z, Lokacije[br].h, true, false)
	while not DoesEntityExist(veh) do
		Wait(100)
	end
	local netid = NetworkGetNetworkIdFromEntity(veh)
	Wait(500)
	TriggerClientEvent("pijaca:VratiGa", _source, netid, vehicle)
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
	TriggerClientEvent("pijaca:OdradiTuning", -1)
end)

RegisterServerEvent('pijaca:Tuljani')
AddEventHandler('pijaca:Tuljani', function(plate, netid)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	for i=1, #Vozila, 1 do
		if Vozila[i].Tablica == plate then
			if Vozila[i].Vlasnik ~= xPlayer.identifier then
				if xPlayer.getMoney() >= Vozila[i].Cijena then
					xPlayer.removeMoney(Vozila[i].Cijena)
					local tPlayer = ESX.GetPlayerFromIdentifier(Vozila[i].Vlasnik)
					if tPlayer then
						tPlayer.addMoney(Vozila[i].Cijena)
						tPlayer.showNotification('Prodali ste vozilo za $'..Vozila[i].Cijena)
						MySQL.Async.execute('DELETE from vehicles_for_sale WHERE plate = @pl', {
							['@pl'] = Vozila[i].Tablica
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
					TriggerEvent("DiscordBot:Vozila", GetPlayerName(_source).." je kupio vozilo["..plate.."] na pijaci za $"..Vozila[i].Cijena)
					TriggerClientEvent("pijaca:OdmrzniGa", _source, netid)
					table.remove(Vozila, i)
					TriggerClientEvent("pijaca:EoTiVozila", -1, Vozila)
					break
				else
					xPlayer.showNotification("Nemate dovoljno novca!")
				end
			else
				xPlayer.showNotification('Maknuli ste vozilo sa pijace!')
				MySQL.Async.execute('DELETE from vehicles_for_sale WHERE plate = @pl', {
					['@pl'] = Vozila[i].Tablica
				}, function(rowsChanged)
				end)
				TriggerClientEvent("pijaca:OdmrzniGa", _source, netid)
				table.remove(Vozila, i)
				TriggerClientEvent("pijaca:EoTiVozila", -1, Vozila)
				break
			end
		end
	end
end)

ESX.RegisterServerCallback('pijaca:DohvatiVozila', function(source, cb)
    cb(Vozila)
end)

ESX.RegisterServerCallback('pijaca:JelNaProdaju', function(source, cb, tablica)
	MySQL.Async.fetchAll('SELECT 1 FROM vehicles_for_sale WHERE plate = @pl', 
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