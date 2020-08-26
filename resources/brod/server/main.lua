ESX = nil

local NetID = {}
local Kutije = {}
local Pedovi = {}

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
	TriggerClientEvent('esx:showNotification', -1, "[EVENT] Event brod je zapoceo, sretno svima!")
end)

RegisterNetEvent("brod:StaviBlip")
AddEventHandler('brod:StaviBlip', function()
	TriggerClientEvent("brod:PostaviBlip", -1)
end)

RegisterNetEvent("prodajoruzje:SpremiNetID")
AddEventHandler('prodajoruzje:SpremiNetID', function(pid)
	NetID = pid
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

ESX.RegisterServerCallback('prodajoruzje:DajNetID', function(source, cb)
	local vracaj = {Net = NetID, Kut = Kutije}
	cb(vracaj)
end)

--Kad bude spremno prebaci te registere negdje dalje
ESX.RegisterUsableItem('weapon_appistol', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste AP pistolj iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_appistol", 1)
	xPlayer.addWeapon("weapon_appistol", 250)
end)

ESX.RegisterUsableItem('weapon_assaultrifle', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste kalas iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_assaultrifle", 1)
	xPlayer.addWeapon("weapon_assaultrifle", 250)
end)

ESX.RegisterUsableItem('weapon_combatpistol', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste combat pistolj iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_combatpistol", 1)
	xPlayer.addWeapon("weapon_combatpistol", 250)
end)

ESX.RegisterUsableItem('weapon_pumpshotgun', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste sacmu iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_pumpshotgun", 1)
	xPlayer.addWeapon("weapon_pumpshotgun", 250)
end)

ESX.RegisterUsableItem('weapon_smg', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste SMG iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_smg", 1)
	xPlayer.addWeapon("weapon_smg", 250)
end)

ESX.RegisterUsableItem('weapon_pistol', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste pistolj iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_pistol", 1)
	xPlayer.addWeapon("weapon_pistol", 250)
end)

ESX.RegisterUsableItem('weapon_heavypistol', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste heavy pistolj iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_heavypistol", 1)
	xPlayer.addWeapon("weapon_heavypistol", 250)
end)

ESX.RegisterUsableItem('weapon_microsmg', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste micro SMG iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_microsmg", 1)
	xPlayer.addWeapon("weapon_microsmg", 250)
end)

ESX.RegisterUsableItem('weapon_assaultsmg', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste assault SMG iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_assaultsmg", 1)
	xPlayer.addWeapon("weapon_assaultsmg", 250)
end)

ESX.RegisterUsableItem('weapon_minismg', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste mini SMG iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_minismg", 1)
	xPlayer.addWeapon("weapon_minismg", 250)
end)

ESX.RegisterUsableItem('weapon_sawnoffshotgun', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste sawnoff sacmu iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_sawnoffshotgun", 1)
	xPlayer.addWeapon("weapon_sawnoffshotgun", 250)
end)

ESX.RegisterUsableItem('weapon_musket', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste musket iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_musket", 1)
	xPlayer.addWeapon("weapon_musket", 250)
end)

ESX.RegisterUsableItem('weapon_carbinerifle', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste carbine rifle iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_carbinerifle", 1)
	xPlayer.addWeapon("weapon_carbinerifle", 250)
end)

ESX.RegisterUsableItem('weapon_advancedrifle', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste advanced rifle iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_advancedrifle", 1)
	xPlayer.addWeapon("weapon_advancedrifle", 250)
end)

ESX.RegisterUsableItem('weapon_specialcarbine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste special carbine iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_specialcarbine", 1)
	xPlayer.addWeapon("weapon_specialcarbine", 250)
end)

ESX.RegisterUsableItem('weapon_bullpuprifle', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste bullpup rifle iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_bullpuprifle", 1)
	xPlayer.addWeapon("weapon_bullpuprifle", 250)
end)

ESX.RegisterUsableItem('weapon_compactrifle', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste compact rifle iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_compactrifle", 1)
	xPlayer.addWeapon("weapon_compactrifle", 250)
end)

ESX.RegisterUsableItem('weapon_gusenberg', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste gusenberg iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_gusenberg", 1)
	xPlayer.addWeapon("weapon_gusenberg", 250)
end)

ESX.RegisterUsableItem('weapon_carbinerifle_mk2', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste carbine rifle mk2 iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_carbinerifle_mk2", 1)
	xPlayer.addWeapon("weapon_carbinerifle_mk2", 250)
end)

ESX.RegisterUsableItem('weapon_assaultrifle_mk2', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, "Uzeli ste assault rifle mk2 iz inventoryja!")
	xPlayer.removeInventoryItem("weapon_assaultrifle_mk2", 1)
	xPlayer.addWeapon("weapon_assaultrifle_mk2", 250)
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