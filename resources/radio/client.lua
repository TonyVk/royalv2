local Ugaseno = 0

RegisterNetEvent("playradio")
AddEventHandler("playradio", function(url)
	if Ugaseno == 0 then
		SendNUIMessage({
			playradio = true,
			sound = url
		})
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Da ugasite youtube pisite /youtubeoff' } })
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Da ugasite pjesme skroz upisite /ugasiradio' } })
	end
end)

RegisterNUICallback( "RadioB", function( data, cb )
    TriggerServerEvent( 'radio:SyncajVrijeme',  data.vol, data.id)

    if ( cb ) then cb( 'ok' ) end 
end )

RegisterNetEvent("radio:SyncGa")
AddEventHandler("radio:SyncGa", function(id)
	SendNUIMessage({
		syncajsve = true,
		idsyncera = id
	})
end)

RegisterNetEvent("radio:SyncVr")
AddEventHandler("radio:SyncVr", function(vr, id)
	if id ~= GetPlayerServerId(PlayerId()) then
		SendNUIMessage({
			syncmp = true,
			sound = vr
		})
	end
end)

RegisterNetEvent("playboomboxyt")
AddEventHandler("playboomboxyt", function(url)
	if Ugaseno == 0 then
		SendNUIMessage({
			playboomboxyt = true,
			sound = url
		})
	end
end)

RegisterNetEvent("playtwitch")
AddEventHandler("playtwitch", function(url)
	if Ugaseno == 0 then
		SendNUIMessage({
			playtwitch = true,
			sound = url
		})
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Da ugasite twitch pisite /twitchoff' } })
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Da ugasite skroz upisite /ugasiradio' } })
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Da stisate upisite /twitchvol [0.0-1.0]' } })
	end
end)

RegisterCommand("ugasiradio", function(source, args, rawCommandString)
	if Ugaseno == 0 then
		Ugaseno = 1
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Ugasili ste pustanje glazbe' } })
	else
		Ugaseno = 0
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Upalili ste pustanje glazbe' } })
	end
end, false)

RegisterNetEvent("loadmp3")
AddEventHandler("loadmp3", function(url)
	if Ugaseno == 0 then
		SendNUIMessage({
			loadmp3 = true,
			sound = url
		})
	end
end)

RegisterNetEvent("playboombox")
AddEventHandler("playboombox", function(url)
	if Ugaseno == 0 then
		SendNUIMessage({
			playboombox = true,
			sound = url
		})
	end
end)

RegisterNetEvent("playmp3")
AddEventHandler("playmp3", function(url)
	if Ugaseno == 0 then
		SendNUIMessage({
			playmp3 = true,
			sound = url
		})
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Da ugasite pjesmu pisite /mp3off' } })
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Da ugasite pjesme skroz upisite /ugasiradio' } })
		TriggerEvent('chat:addMessage', { args = { '^[SERVER]', 'Da stisate upisite /mp3vol [0.1-1.0]' } })
	end
end)

RegisterNetEvent("voltwitch")
AddEventHandler("voltwitch", function(vol)
	SendNUIMessage({
		voltwitch = true,
		zvuk = vol
	})
end)

RegisterNetEvent("volmp3")
AddEventHandler("volmp3", function(vol)
	SendNUIMessage({
		volmp3 = true,
		zvuk = vol
	})
end)

RegisterNetEvent("pausemp3")
AddEventHandler("pausemp3", function()
	SendNUIMessage({
		pausemp3 = true
	})
end)

RegisterNetEvent("resumemp3")
AddEventHandler("resumemp3", function()
	SendNUIMessage({
		resumemp3 = true
	})
end)

RegisterNetEvent("stopmp3")
AddEventHandler("stopmp3", function()
	SendNUIMessage({
		stopmp3 = true
	})
end)

RegisterNetEvent("stoptwitch")
AddEventHandler("stoptwitch", function()
	SendNUIMessage({
		stoptwitch = true
	})
end)

RegisterNetEvent("stopradio")
AddEventHandler("stopradio", function()
	SendNUIMessage({
		stopradio = true
	})
end)

RegisterNetEvent("sakrijyoutube")
AddEventHandler("sakrijyoutube", function()
	SendNUIMessage({
		sakrijradio = true
	})
end)

RegisterNetEvent("prikaziyoutube")
AddEventHandler("prikaziyoutube", function()
	SendNUIMessage({
		prikaziradio = true
	})
end)
