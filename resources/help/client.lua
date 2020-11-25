SetNuiFocus( false )

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		DisablePlayerVehicleRewards(PlayerId())	
	end
end)

RegisterNetEvent("otvorihelp")
AddEventHandler("otvorihelp", function(url)
	if url == 1 then
		SendNUIMessage({
			otvorihelparu = true,
			admin = true
		})
	else
		SendNUIMessage({
			otvorihelparu = true
		})
	end
	SetNuiFocus( true, true )
end)

RegisterNUICallback( "Help", function( data )
if ( data == "close" ) then 
        SendNUIMessage({
		zatvorihelparu = true,
		admin = false
	})
	SetNuiFocus( false )
    end
end )

RegisterCommand("discord", function(source, args, rawCommandString)
	TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 153, 204, 0.6); border-radius: 3px;"><i class="fas fa-user-circle"></i> {0}:<br> {1}</div>',
            args = { "Discord", "https://discord.gg/rAWxYmp" }
	})
end, false)
