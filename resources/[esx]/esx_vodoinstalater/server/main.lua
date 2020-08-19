ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Objekti = {}

RegisterServerEvent('vodaa:platituljanu')
AddEventHandler('vodaa:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(350)
	TriggerEvent("biznis:StaviUSef", "vodoinstalater", math.ceil(350*0.30))
end)

RegisterServerEvent('vodoinstalater:PosaljiObjekte')
AddEventHandler('vodoinstalater:PosaljiObjekte', function(obj)
	for i=1, #obj, 1 do
		if obj[i] ~= nil then
			table.insert(Objekti, {ID = obj[i].ID, Obj1 = obj[i].Obj1, Obj2 = obj[i].Obj2, Obj3 = obj[i].Obj3, Obj4 = obj[i].Obj4, Obj5 = obj[i].Obj5})
		end
	end
end)

RegisterServerEvent('vodoinstalater:MaknutKvar')
AddEventHandler('vodoinstalater:MaknutKvar', function(id)
	for i=1, #Objekti, 1 do
		if Objekti[i] ~= nil and Objekti[i].ID == id then
			Objekti[i].ID = nil
			Objekti[i].Obj1 = nil
			Objekti[i].Obj2 = nil
			Objekti[i].Obj3 = nil
			Objekti[i].Obj4 = nil
			Objekti[i].Obj5 = nil
			Objekti[i] = nil
		end
	end
end)

AddEventHandler('playerDropped', function()
	for i=1, #Objekti, 1 do
		if Objekti[i] ~= nil and Objekti[i].ID == source then
			TriggerClientEvent("vodoinstalater:ObrisiObjekte", -1, Objekti[i].Obj1, Objekti[i].Obj2, Objekti[i].Obj3, Objekti[i].Obj4, Objekti[i].Obj5)
			Objekti[i].ID = nil
			Objekti[i].Obj1 = nil
			Objekti[i].Obj2 = nil
			Objekti[i].Obj3 = nil
			Objekti[i].Obj4 = nil
			Objekti[i].Obj5 = nil
			Objekti[i] = nil
			break
		end
	end
end)
