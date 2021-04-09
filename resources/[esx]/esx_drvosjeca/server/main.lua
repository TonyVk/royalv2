ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('drvosjeca:platituljanu')
AddEventHandler('drvosjeca:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'drvosjeca' then
		xPlayer.addMoney(100)
		TriggerEvent("biznis:StaviUSef", "drvosjeca", math.ceil(100*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac drvosjece, a nije zaposlen kao drvosjeca!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
