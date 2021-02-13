ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('elektricar:platituljanu')
AddEventHandler('elektricar:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'elektricar' then
		xPlayer.addMoney(850)
		TriggerEvent("biznis:StaviUSef", "elektricar", math.ceil(850*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac elektricara, a nije zaposlen kao elektricar!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
