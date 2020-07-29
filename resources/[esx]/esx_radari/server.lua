ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('kaznicaaa')
AddEventHandler('kaznicaaa', function(mphspeed)
	local _source = source
	local truespeed = mphspeed
	if truespeed >= 90 and truespeed <= 100 then
		TriggerEvent('esx_billing:posaljiTuljana', _source, 'society_police', "Policija: Kazna za prebrzu voznju", Config.Fine)
	end
	if truespeed >= 100 and truespeed <= 110 then
		TriggerEvent('esx_billing:posaljiTuljana', _source, 'society_police', "Policija: Kazna za prebrzu voznju", Config.Fine2)
	end
	if truespeed >= 110 and truespeed <= 120 then
		TriggerEvent('esx_billing:posaljiTuljana', _source, 'society_police', "Policija: Kazna za prebrzu voznju", Config.Fine3)
	end
	if truespeed >= 120 and truespeed <= 500 then
		TriggerEvent('esx_billing:posaljiTuljana', _source, 'society_police', "Policija: Kazna za prebrzu voznju", Config.Fine4)
	end
	CancelEvent()
end)
