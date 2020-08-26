local GUI                       = {}

GUI.Time                        = 0
local Vozilo = nil
local Blip = nil
local Spawnovi = {
	{x = -999.11291503906, y = -1400.1403808594, z = 0.29306834936142, h = 20.268524169922}, --spawnvozila
	{x = -990.41900634766, y = -1397.63671875, z = 0.32235115766525, h = 21.303436279297}, --spawn2
	{x = -981.62341308594, y = -1394.7960205078, z = 0.26907229423523, h = 19.966035842896}, --spawn3
	{x = -973.55328369141, y = -1391.3395996094, z = 0.30388006567955, h = 20.50302696228}, --spawn4
	{x = -964.90197753906, y = -1388.7297363281, z = 0.30299228429794, h = 19.273345947266}, --spawn5
	{x = -954.75231933594, y = -1385.0946044922, z = 0.27771404385567, h = 19.083749771118}, --spawn6
	{x = -946.68768310547, y = -1381.6982421875, z = 0.32856410741806, h = 19.446186065674}, --spawn7
	{x = -937.97387695313, y = -1378.8669433594, z = 0.31743547320366, h = 20.496671676636}, --spawn7
	{x = -929.65881347656, y = -1375.3037109375, z = 0.30395010113716, h = 21.080327987671}, --spawn9
	{x = -921.25415039063, y = -1372.5773925781, z = 0.292709171772, h = 19.627565383911}
}

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Citizen.Wait(5000)
	Blip = AddBlipForCoord(-995.19537353516, -1415.3653564453, 5.1942825317383)
	SetBlipSprite (Blip, 427)
	SetBlipDisplay(Blip, 2)
	SetBlipScale  (Blip, 1.2)
	SetBlipColour (Blip, 57)
	SetBlipAsShortRange(Blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rent glisera")
	EndTextCommandSetBlipName(Blip)
end)

Citizen.CreateThread(function()
		local waitara = 1000
		while true do
			local naso = 0
			local koord = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(koord, -995.19537353516, -1415.3653564453, 5.1942825317383, true) <= 20 then
				naso = 1
				waitara = 0
				DrawMarker(35, -995.19537353516, -1415.3653564453, 5.1942825317383, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 0, 204, 204, 200, 0, 0, 0, 0)
			end
			if GetDistanceBetweenCoords(koord, -995.19537353516, -1415.3653564453, 5.1942825317383, true) <= 2.0 then
				SetTextComponentFormat('STRING')
				AddTextComponentString("Pritisnite E da otvorite rent menu!")
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 150 then
					GUI.Time = GetGameTimer()
					local elements = {}
					table.insert(elements, {label = "Dinghy(700$)", value = 'dinghy'})
					table.insert(elements, {label = 'Jetmax(700$)',  value = 'jetmax'})
					table.insert(elements, {label = 'Speeder(700$)',  value = 'speeder'})
					table.insert(elements, {label = 'Tropic(700$)',  value = 'tropic'})


					ESX.UI.Menu.Open(
					  'default', GetCurrentResourceName(), 'rentb',
					  {
						title    = "Izaberite brod",
						align    = 'top-left',
						elements = elements,
					  },
					  function(data, menu)
						ESX.TriggerServerCallback('rentbroda:OduzmiPare', function(platio)
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
										ESX.ShowNotification("Unrentati mozete sa /bunrent")
										break
									end
								end
								if Mjesto == false then
									ESX.ShowNotification("Trenutno nema slobodnog mjesta za gliser!")
									TriggerServerEvent("rentbroda:SviSuTuljani")
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
			if naso == 0 then
				waitara = 1000
			end
		Citizen.Wait(waitara)
		end
end)

RegisterCommand("bunrent", function(source, args, rawCommandString)
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
		ESX.ShowNotification("Unrentali ste brod!")
	else
		ESX.ShowNotification("Nemate rentan brod!")
	end
end, false)