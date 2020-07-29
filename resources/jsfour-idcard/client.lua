local open = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil

local Coord = { x = 0, y = 0, z = 0 }

ESX              = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

-- Key events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)

function MenuKupovina()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'kosobna',
		{
			title    = "Zelite li kupiti osobnu?",
			elements = {
				{label = "Da", value = 'yes'},
				{label = "Ne", value = 'no'}
			}
		},
		function(data, menu)
			if data.current.value == 'yes' then
				TriggerServerEvent("osobna:dajlicencu")
			end
			if data.current.value == 'no' then
				menu.close()
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

AddEventHandler('osobna:hasEnteredMarker', function(zone)
	if zone == 'osobna' then
		MenuKupovina()
	end
end)

AddEventHandler('osobna:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local isInMarker  = false
		local currentZone = nil
		local coords = GetEntityCoords(GetPlayerPed(-1))
		if(GetDistanceBetweenCoords(coords, Coord.x, Coord.y, Coord.z, true) < 50) then
			DrawMarker(1, Coord.x, Coord.y, Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
		end	
		if(GetDistanceBetweenCoords(coords, Coord.x, Coord.y, Coord.z, true) < 3.0) then
			isInMarker  = true
			currentZone = "osobna"
		end
		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone                = currentZone
			TriggerEvent('osobna:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('osobna:hasExitedMarker', lastZone)
		end
	end
end)
