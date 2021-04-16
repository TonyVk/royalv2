ESX = nil
local Ima = 0
local vlasnik
local cijena = 0
local tablica
local GarazaV = nil
local Vblip = nil
local Vozilo = nil
local Vehicles = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	Citizen.Wait(10000)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_contract:PoslaoMu')
AddEventHandler('esx_contract:PoslaoMu', function(br, tabl, cij, igr, veh)
	Ima = br
	tablica = tabl
	cijena = cij
	vlasnik = igr
	Vozilo = veh
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function(vehicles)
	Vehicles = vehicles
end)

RegisterNetEvent('contract:ZamjenaVozila')
AddEventHandler('contract:ZamjenaVozila', function(plate)
	if GarazaV ~= nil then
		TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
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
		Ima = 0
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
			local nid = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerEvent("esx_property:ProsljediVozilo", nid, Vblip)
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
			local JelDonatorski = false
			for i=1, #Vehicles, 1 do
				if GetHashKey(Vehicles[i].model) == GetEntityModel(vehicle) then
					if Vehicles[i].category == "donatorski" or Vehicles[i].category == "razz" then
						JelDonatorski = true
						if Vehicles[i].category == "razz" and ESX.PlayerData.job.name == 'mechanic' and ESX.PlayerData.job.grade == 5 then
							JelDonatorski = false
						end
						break
					end
				end
			end
			if not JelDonatorski then
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
						end, vehProps.plate, vehProps.model)
					end
				end, function(data, menu)
					menu.close()
				end)
			else
				ESX.ShowNotification("Ne smijete prodavati donatorsko vozilo!")
			end
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