ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('spasioc:isplata')
AddEventHandler('spasioc:isplata', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.job.name == 'spasioc' then
		xPlayer.addMoney(400)
		TriggerEvent("biznis:StaviUSef", "spasioc", math.ceil(250*0.30))
    else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac spasioca, a nije zaposljen kao spasioc!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
