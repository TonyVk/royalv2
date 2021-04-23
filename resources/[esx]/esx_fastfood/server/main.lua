ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('fastfood:isplata')
AddEventHandler('fastfood:isplata', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.job.name == 'fastfood' then
		xPlayer.addMoney(320)
		TriggerEvent("biznis:StaviUSef", "fastfood", math.ceil(320*0.30))
    else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac fastfooda, a nije zaposljen kao dostavljac!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
