ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ralica:platiTuljanu')
AddEventHandler('esx_ralica:platiTuljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'ralica' then
		xPlayer.addMoney(65)
		TriggerEvent("biznis:StaviUSef", "ralica", math.ceil(65*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac cistaca snijega, a nije zaposlen kao cistac snijega!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
