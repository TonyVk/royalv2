ESX = nil

local NetID = {}
local Kutije = {}
local Pedovi = {}
local TrajeEvent = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	UcitajKutije()
end)

function UcitajKutije()
	Kutije = {}
	Pedovi = {}
	MySQL.Async.fetchAll(
      'SELECT * FROM brod',
      {},
      function(result)
		if result[1] ~= nil then
			if result[1].Kutije ~= "{}" then
				Kutije = json.decode(result[1].Kutije)
				TriggerClientEvent("brod:VratiKutije", -1, Kutije)
			end
			if result[1].Pedovi ~= "{}" then
				Pedovi = json.decode(result[1].Pedovi)
				TriggerClientEvent("brod:VratiPedove", -1, Pedovi)
			end
		end
      end
    )
end

RegisterNetEvent("brod:UpdatePedove")
AddEventHandler('brod:UpdatePedove', function(ped)
	Pedovi = ped
	MySQL.Async.fetchScalar(
      'SELECT Pedovi FROM brod',
      {},
      function(result)
		if result ~= nil then
			MySQL.Async.execute('UPDATE brod SET Pedovi = @ped', {
				['@ped'] = json.encode(ped)
			})
		else
			MySQL.Async.execute('INSERT INTO brod (Pedovi) VALUES (@ped)',{
				['@ped'] = json.encode(ped)
			})
		end
      end
    )
end)

RegisterNetEvent("brod:Obavijest")
AddEventHandler('brod:Obavijest', function()
	TrajeEvent = true
	TriggerClientEvent('esx:showNotification', -1, "[EVENT] Event brod je zapoceo, sretno svima!")
end)

RegisterNetEvent("brod:StaviBlip")
AddEventHandler('brod:StaviBlip', function()
	TriggerClientEvent("brod:PostaviBlip", -1)
end)

RegisterNetEvent("prodajoruzje:SpremiNetID")
AddEventHandler('prodajoruzje:SpremiNetID', function(pid)
	NetID = pid
	TriggerClientEvent("brod:VratiNetID", -1, pid)
end)

RegisterNetEvent("brod:PosaljiKutije")
AddEventHandler('brod:PosaljiKutije', function(kut)
	Kutije = kut
	TriggerClientEvent("brod:VratiKutije", -1, kut)
	MySQL.Async.fetchScalar(
      'SELECT Kutije FROM brod',
      {},
      function(result)
		if result ~= nil then
			MySQL.Async.execute('UPDATE brod SET Kutije = @kut', {
				['@kut'] = json.encode(kut)
			})
		else
			MySQL.Async.execute('INSERT INTO brod (Kutije) VALUES (@kut)',{
				['@kut'] = json.encode(kut)
			})
		end
      end
    )
end)

ESX.RegisterServerCallback('brod:JelTraje', function(source, cb)
	cb(TrajeEvent)
end)

ESX.RegisterServerCallback('prodajoruzje:DajNetID', function(source, cb)
	local vracaj = {Net = NetID, Kut = Kutije}
	cb(vracaj)
end)

RegisterServerEvent('prodajoruzje:DajOruzjeItem')
AddEventHandler('prodajoruzje:DajOruzjeItem', function(weap, i)
  local xPlayer = ESX.GetPlayerFromId(source)
  local rand = math.random(1,3)
  local xItem = xPlayer.getInventoryItem(weap)
  local label = xPlayer.getInventoryItem(weap).label
  if xItem.limit ~= -1 and (xItem.count + rand) > xItem.limit then
	if xItem.limit == xItem.count then
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Ne stane vam vise "..label.." u inventory!")
		Kutije[i].Pokupljeno = false
		TriggerEvent("brod:PosaljiKutije", Kutije)
	else
		rand = xItem.limit-xItem.count
		xPlayer.addInventoryItem(weap, rand)
	end
  else
	xPlayer.addInventoryItem(weap, rand)
  end
end)