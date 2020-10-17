ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ralica:platiTuljanu')
AddEventHandler('esx_ralica:platiTuljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'ralica' then
		xPlayer.addMoney(65)
		TriggerEvent("biznis:StaviUSef", "ralica", math.ceil(65*0.30))
    end
end)
