ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_delivererposo:platiljantu')
AddEventHandler('esx_delivererposo:platiljantu', function(dest)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(tonumber(dest.Paye))
	TriggerEvent("biznis:StaviUSef", "deliverer", math.ceil(tonumber(dest.Paye)*0.30))
end)
