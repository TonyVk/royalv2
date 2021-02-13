ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('seljacina:platituljanu')
AddEventHandler('seljacina:platituljanu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'farmer' then
		xPlayer.addMoney(25)
		TriggerEvent("biznis:StaviUSef", "farmer", math.ceil(25*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac farmera, a nije zaposlen kao farmer!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)

RegisterServerEvent('seljacina:platituljanu2')
AddEventHandler('seljacina:platituljanu2', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'farmer' then
		xPlayer.addMoney(26)
		TriggerEvent("biznis:StaviUSef", "farmer", math.ceil(26*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac farmera, a nije zaposlen kao farmer!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
