ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_vlak:platiTuljanu')
AddEventHandler('esx_vlak:platiTuljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'vlak' then
		xPlayer.addMoney(500)
		TriggerEvent("biznis:StaviUSef", "vlak", math.ceil(500*0.30))
    end
end)