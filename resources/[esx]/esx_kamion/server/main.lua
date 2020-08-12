ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Objekti = {}

RegisterServerEvent('kamiooon:platituljanu')
AddEventHandler('kamiooon:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == "kamion" then
		xPlayer.addMoney(2150)
	end
end)

RegisterServerEvent('kamion:PosaljiObjekte')
AddEventHandler('kamion:PosaljiObjekte', function(obj)
	for i=1, #obj, 1 do
		if obj[i] ~= nil then
			table.insert(Objekti, {ID = obj[i].ID, Obj1 = obj[i].Obj1})
		end
	end
end)

RegisterServerEvent('kamion:MaknutObjekt')
AddEventHandler('kamion:MaknutObjekt', function(id)
	for i=1, #Objekti, 1 do
		if Objekti[i] ~= nil and Objekti[i].ID == id then
			Objekti[i].ID = nil
			Objekti[i].Obj1 = nil
			Objekti[i] = nil
			break
		end
	end
end)

AddEventHandler('playerDropped', function()
	for i=1, #Objekti, 1 do
		if Objekti[i] ~= nil and Objekti[i].ID == source then
			TriggerClientEvent("kamion:ObrisiObjekte", -1, Objekti[i].Obj1)
			Objekti[i].ID = nil
			Objekti[i].Obj1 = nil
			Objekti[i] = nil
			break
		end
	end
end)