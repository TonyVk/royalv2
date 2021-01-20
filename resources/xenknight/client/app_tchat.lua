--====================================================================================
-- # Discord XenKnighT#7085
--====================================================================================

function hasPhone (cb)
	if (ESX == nil) then return cb(false) end
	ESX.TriggerServerCallback('xenknight:getItemAmount', function(imal)
		cb(imal)
	end)
end

RegisterNetEvent("xenknight:tchat_receive")
AddEventHandler("xenknight:tchat_receive", function(message)
	hasPhone(function (hasPhone)
        if hasPhone == true then
			SendNUIMessage({event = 'tchat_receive', message = message})
		end
	end)
end)

RegisterNetEvent("xenknight:tchat_channel")
AddEventHandler("xenknight:tchat_channel", function(channel, messages)
  SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
  TriggerServerEvent('xenknight:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
  TriggerServerEvent('xenknight:tchat_channel', data.channel)
end)
