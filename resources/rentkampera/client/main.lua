local GUI                       = {}

GUI.Time                        = 0
local Vozilo = nil
local Blip = nil
local Spawnovi = {
	{x = -1070.9866943359, y = -1669.6142578125, z = 3.9302122592926, h = 38.19}
}

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
		local waitara = 1000
		while true do
			local naso = 0
			local koord = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(koord, -1076.8598632813, -1677.7924804688, 4.575234413147, true) <= 20 then
				naso = 1
				waitara = 0
				DrawMarker(0, -1076.8598632813, -1677.7924804688, 4.575234413147, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
			end
			if GetDistanceBetweenCoords(koord, -1076.8598632813, -1677.7924804688, 4.575234413147, true) <= 2.0 then
				SetTextComponentFormat('STRING')
				AddTextComponentString("Pritisnite E da otvorite rent menu!")
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 150 then
					GUI.Time = GetGameTimer()
					local elements = {}
					table.insert(elements, {label = "Kamper(500$)", value = 'journey'})


					ESX.UI.Menu.Open(
					  'default', GetCurrentResourceName(), 'rentkam',
					  {
						title    = "Izaberite kamper",
						align    = 'top-left',
						elements = elements,
					  },
					  function(data, menu)
						ESX.TriggerServerCallback('rentkampera:ImalPara', function(platio)
							if platio then
								if Vozilo ~= nil then
									ESX.Game.DeleteVehicle(Vozilo)
									Vozilo = nil
								end
								local Mjesto = false
								for i=1, #Spawnovi, 1 do
									if ESX.Game.IsSpawnPointClear({
										x = Spawnovi[i].x,
										y = Spawnovi[i].y,
										z = Spawnovi[i].z
									}, 5.0) then
										Mjesto = true
										ESX.Game.SpawnVehicle(data.current.value, {
											x = Spawnovi[i].x,
											y = Spawnovi[i].y,
											z = Spawnovi[i].z
										}, Spawnovi[i].h, function(callback_vehicle)
											Vozilo = callback_vehicle
											TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
										end)
										TriggerServerEvent("rentkampera:SviSuTuljani")
										ESX.ShowNotification("Unrentati mozete sa /kunrent")
										break
									end
								end
								if Mjesto == false then
									ESX.ShowNotification("Trenutno nema slobodnog mjesta za gliser!")
								end
							else
								ESX.ShowNotification("Nemate dovoljno novca!")
							end
						end)
						menu.close()
					  end,
					  function(data, menu)
						menu.close()
					  end
					)
				end
			end
			
			local kordic = GetEntityCoords(PlayerPedId())
			if (GetDistanceBetweenCoords(-1913.9028320313, 1388.9566650391, 219.3586730957,  kordic.x,  kordic.y,  kordic.z,  true) <= 50.0) then
				waitara = 0
				naso = 1
				DrawMarker(27, -1913.9028320313, 1388.9566650391, 219.3586730957, 0, 0, 0, 0, 0, 0, 2.25, 2.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
			end
			
			local isInMarker  = false
			local currentZone = nil

			if(GetDistanceBetweenCoords(kordic, -1913.9028320313, 1388.9566650391, 219.3586730957, true) < 2.25) then
				isInMarker  = true
				currentZone = "prodaja"
			end
			
			local kordic = GetEntityCoords(PlayerPedId())
			if (GetDistanceBetweenCoords(1065.3234863281, -1999.6342773438, 30.907497406006,  kordic.x,  kordic.y,  kordic.z,  true) <= 50.0) then
				waitara = 0
				naso = 1
				DrawMarker(27, 1065.3234863281, -1999.6342773438, 29.907497406006, 0, 0, 0, 0, 0, 0, 2.25, 2.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
			end

			if(GetDistanceBetweenCoords(kordic, 1065.3234863281, -1999.6342773438, 30.907497406006, true) < 2.25) then
				isInMarker  = true
				currentZone = "kupimeth"
			end
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('meth:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('meth:hasExitedMarker', lastZone)
			end
			
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) then
					if CurrentAction == 'kupimeth' then
						TriggerServerEvent("meth:KupiMeth")
					end
					CurrentAction = nil
				end
			end
			
			if naso == 0 then
				waitara = 1000
			end
		Citizen.Wait(waitara)
		end
end)

AddEventHandler('meth:hasEnteredMarker', function(zone)
	if zone == 'prodaja' then
		CurrentAction     = 'prodaj'
        CurrentActionMsg  = "Pritisnite E da prodate meth!"
	elseif zone == "kupimeth" then
		CurrentAction     = 'kupimeth'
        CurrentActionMsg  = "Pritisnite E da kupite laboratorij za meth!"
	end
end)

AddEventHandler('meth:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

RegisterCommand("kunrent", function(source, args, rawCommandString)
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
		ESX.ShowNotification("Unrentali ste kamper!")
	else
		ESX.ShowNotification("Nemate rentan kamper!")
	end
end, false)