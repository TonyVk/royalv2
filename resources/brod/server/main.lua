ESX = nil

local NetID = {}
local Kutije = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("prodajoruzje:SpremiNetID")
AddEventHandler('prodajoruzje:SpremiNetID', function(pid)
	NetID = pid
end)

RegisterNetEvent("brod:PosaljiKutije")
AddEventHandler('brod:PosaljiKutije', function(kut)
	Kutije = kut
	TriggerClientEvent("brod:VratiKutije", -1, kut)
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
AddEventHandler('prodajoruzje:DajOruzjeItem', function(weap)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addInventoryItem(weap, math.random(1,3))
end)