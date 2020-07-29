ESX = nil
local Ima = 0
local vlasnik
local cijena = 0
local tablica
local GarazaV = nil
local Vblip = nil
local Vozilo = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_contract:PoslaoMu')
AddEventHandler('esx_contract:PoslaoMu', function(br, tabl, cij, igr, veh)
	Ima = br
	tablica = tabl
	cijena = cij
	vlasnik = igr
	Vozilo = veh
end)

RegisterNetEvent('contract:ZamjenaVozila')
AddEventHandler('contract:ZamjenaVozila', function(plate)
	local pla = plate:gsub("^%s*(.-)%s*$", "%1")
	TriggerServerEvent("garaza:SpremiModel", pla, nil)
	if GarazaV ~= nil and DoesEntityExist(GarazaV) then
		local prop = ESX.Game.GetVehicleProperties(GarazaV)
		local pla = prop.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, nil)
		GarazaV = nil
		if Vblip ~= nil then
			RemoveBlip(Vblip)
			Vblip = nil
		end
	end
	TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
end)

RegisterNetEvent('esx_property:ProsljediVozilo')
AddEventHandler('esx_property:ProsljediVozilo', function(voz, bl)
	GarazaV = voz
	Vblip = bl
end)

RegisterCommand("prihvativozilo", function(source, args, rawCommandString)
	if Ima == 1 then
		TriggerServerEvent('ugovor:prodajtuljanu', vlasnik, tablica, cijena)
		TriggerEvent("garaza:ObrisiProslo")
		TriggerEvent("esx_property:ProsljediVozilo", nil, nil)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = ESX.Game.GetClosestVehicle(coords)
		local vehiclecoords = GetEntityCoords(vehicle)
		local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)
		if DoesEntityExist(vehicle) and (vehDistance <= 3) then
			Vblip = AddBlipForEntity(vehicle)
			SetBlipSprite (Vblip, 225)
			SetBlipDisplay(Vblip, 4)
			SetBlipScale  (Vblip, 1.0)
			SetBlipColour (Vblip, 30)
			SetBlipAsShortRange(Vblip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Vase vozilo")
			EndTextCommandSetBlipName(Vblip)
			local props = ESX.Game.GetVehicleProperties(vehicle)
			local pla = props.plate:gsub("^%s*(.-)%s*$", "%1")
			TriggerServerEvent("garaza:SpremiModel", pla, props.model)
			TriggerEvent("esx_property:ProsljediVozilo", vehicle, Vblip)
		end
	else
		ESX.ShowNotification("Nemate ponudu za vozilo!")
	end
end, false)

RegisterNetEvent('esx_contract:getVehicle')
AddEventHandler('esx_contract:getVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local closestPlayer, playerDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and playerDistance <= 3.0 then
		local vehicle = ESX.Game.GetClosestVehicle(coords)
		local vehiclecoords = GetEntityCoords(vehicle)
		local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)
		if DoesEntityExist(vehicle) and (vehDistance <= 3) then
			TriggerEvent("esx_invh:closeinv")
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cijenica_vozila', {
				title = "Upisite cijenu vozila"
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification("Niste unjeli cijenu")
				else
					menu.close()
					local vehProps = ESX.Game.GetVehicleProperties(vehicle)
					ESX.TriggerServerCallback('garaza:JelIstiModel', function(dane)
						if (dane) then
							ESX.ShowNotification(_U('writingcontract', vehProps.plate))
							TriggerServerEvent('ugovor:prodajtuljanu2', GetPlayerServerId(closestPlayer), vehProps.plate, amount, GarazaV)
						end
					end, vehProps.model)
				end
			end, function(data, menu)
				menu.close()
			end)
		else
			ESX.ShowNotification(_U('nonearby'))
		end
	else
		ESX.ShowNotification(_U('nonearbybuyer'))
	end
	
end)

RegisterNetEvent('esx_contract:showAnim')
AddEventHandler('esx_contract:showAnim', function(player)
	loadAnimDict('anim@amb@nightclub@peds@')
	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, false)
	Citizen.Wait(20000)
	ClearPedTasks(PlayerPedId())
end)


function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end