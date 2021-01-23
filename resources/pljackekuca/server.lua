ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local itemi = {
    [1] = { ime = 'lancic', label = "Lancic", kolicina = math.random(1,3)},
    [2]  = { ime = 'narukvica', label = "Narukvica", kolicina = math.random(1,4)},
    [3] = { ime = 'cocaine', label = "Vrecica kokaina", kolicina = 1},
    [4] = { ime = 'diamond', label = "Dijamant", kolicina = math.random(1,2)},
    [5] = { ime = 'clip', label = "Sarzer", kolicina = 1}
}

RegisterNetEvent('pkuca:DajItem')
AddEventHandler('pkuca:DajItem', function()
	local rand = math.random(1, 5)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local kolic = itemi[rand].kolicina
	xPlayer.addInventoryItem(itemi[rand].ime, kolic)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Pronasli ste "..kolic.."x "..itemi[rand].label..".")
end)

RegisterNetEvent('pkuca:ProdajStvari')
AddEventHandler('pkuca:ProdajStvari', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local naso = 0
	local lanciccount = xPlayer.getInventoryItem('lancic').count
	if lanciccount > 0 then
		local cijena = lanciccount*500
		xPlayer.removeInventoryItem('lancic', lanciccount)
		xPlayer.addMoney(cijena)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Prodali ste "..lanciccount.."x lancic za $"..cijena..".")
		naso = 1
	end
	local narukvicacount = xPlayer.getInventoryItem('narukvica').count
	if narukvicacount > 0 then
		local cijena2 = narukvicacount*350
		xPlayer.removeInventoryItem('narukvica', narukvicacount)
		xPlayer.addMoney(cijena2)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Prodali ste "..narukvicacount.."x narukvica za $"..cijena2..".")
		naso = 1
	end
	local dijamantcount = xPlayer.getInventoryItem('diamond').count
	if dijamantcount > 0 then
		local cijena3 = dijamantcount*500
		xPlayer.removeInventoryItem('diamond', dijamantcount)
		xPlayer.addMoney(cijena3)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Prodali ste "..dijamantcount.."x dijamant za $"..cijena3..".")
		naso = 1
	end
	if naso == 0 then
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Nemate nakita za prodati!")
	end
end)

RegisterNetEvent('pkuca:SpremiVrijeme')
AddEventHandler('pkuca:SpremiVrijeme', function(minute)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.execute('UPDATE users SET kpljacka = @count WHERE identifier = @ident', {
		['@count'] = tonumber(minute),
		['@ident'] = xPlayer.identifier
	})
end)

ESX.RegisterServerCallback('pkuca:DohvatiVrijeme', function (source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchScalar('SELECT kpljacka FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
        cb(result)
    end)
end)