ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Objekti = {}

RegisterServerEvent('vodaa:platituljanu')
AddEventHandler('vodaa:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(550)
	TriggerEvent("biznis:StaviUSef", "vodoinstalater", math.ceil(550*0.30))
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
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj1))
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj2))
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj3))
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj4))
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj5))
			table.remove(Objekti, i)
			break
		end
	end
end)

AddEventHandler('playerDropped', function()
	for i=1, #Objekti, 1 do
		if Objekti[i] ~= nil and Objekti[i].ID == source then
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj1))
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj2))
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj3))
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj4))
			DeleteEntity(NetworkGetEntityFromNetworkId(Objekti[i].Obj5))
			table.remove(Objekti, i)
			break
		end
	end
end)
