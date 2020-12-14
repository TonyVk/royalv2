local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local Blip 						= nil
local Vehicles 					= {}
local OdradioTo					= false
local Vozila 					= {}

ESX                             = nil

local Lokacije = {
	{x = 897.39471435547, y = -73.840759277344, z = 78.223876953125, h = 57.113529205322}, --mjesto1
	{x = 899.37408447266, y = -70.670104980469, z = 78.223770141602, h = 57.697650909424}, --mjesto2
	{x = 901.20269775391, y = -67.738151550293, z = 78.223793029785, h = 58.33179473877}, --mjesto3
	{x = 902.96380615234, y = -64.748306274414, z = 78.223808288574, h = 57.740776062012}, --mjesto4
	{x = 904.80084228516, y = -61.831848144531, z = 78.223846435547, h = 57.39688873291}, --mjesto5
	{x = 906.63806152344, y = -58.716709136963, z = 78.223976135254, h = 58.452045440674}, --mjesto6
	{x = 908.40502929688, y = -55.989116668701, z = 78.223686218262, h = 58.20686340332}, --mjesto7
	{x = 910.41711425781, y = -53.19612121582, z = 78.223808288574, h = 56.633651733398}, --mjesto8
	{x = 912.07922363281, y = -50.140312194824, z = 78.223823547363, h = 58.322368621826}, --mjesto9
	{x = 913.84106445313, y = -47.288665771484, z = 78.223770141602, h = 57.286602020264}, --mjesto10
	{x = 915.79498291016, y = -44.492713928223, z = 78.223823547363, h = 58.228252410889}, --mjesto11
	{x = 917.61340332031, y = -41.570022583008, z = 78.223747253418, h = 56.527641296387}, --mjesto12
	{x = 919.67987060547, y = -38.454807281494, z = 78.223648071289, h = 58.487590789795}, --mjesto13
	{x = 908.11291503906, y = -31.545877456665, z = 78.223701477051, h = 237.83882141113}, --mjesto14
	{x = 906.27215576172, y = -34.905948638916, z = 78.223754882813, h = 238.55699157715}, --mjesto15
	{x = 904.48736572266, y = -37.782585144043, z = 78.223693847656, h = 237.47985839844}, --mjesto16
	{x = 902.45263671875, y = -40.606674194336, z = 78.223770141602, h = 237.82391357422}, --mjesto17
	{x = 900.70947265625, y = -43.644153594971, z = 78.223777770996, h = 237.19450378418}, --mjesto18
	{x = 898.93103027344, y = -46.556648254395, z = 78.223731994629, h = 237.77868652344}, --mjesto19
	{x = 897.11517333984, y = -49.507202148438, z = 78.223762512207, h = 237.70567321777}, --mjesto20
	{x = 895.29998779297, y = -52.395126342773, z = 78.223648071289, h = 239.08903503418}, --mjesto21
	{x = 893.41979980469, y = -55.320140838623, z = 78.223861694336, h = 237.78500366211}, --mjesto22
	{x = 891.66394042969, y = -58.307960510254, z = 78.223709106445, h = 238.35643005371}, --mjesto23
	{x = 889.72900390625, y = -61.109397888184, z = 78.223976135254, h = 239.26565551758}, --mjesto24
	{x = 887.90374755859, y = -64.03946685791, z = 78.224235534668, h = 237.68322753906}, --mjesto25
	{x = 886.11840820313, y = -67.078979492188, z = 78.223770141602, h = 239.32939147949} --mjesto26
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	KreirajBlip()
	Citizen.Wait(10000)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function(vehicles)
		Vehicles = vehicles
	end)
	
	ESX.TriggerServerCallback('pijaca:DohvatiVozila', function(vehicles)
		Vozila = vehicles
	end)
end)

AddEventHandler('playerSpawned', function(spawn)
	ESX.TriggerServerCallback('pijaca:DohvatiVozila', function(vehicles)
		Vozila = vehicles
	end)
	TriggerServerEvent("pijaca:ProvjeriProdane")
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function(vehicles)
	Vehicles = vehicles
end)

RegisterNetEvent('pijaca:EoTiVozila')
AddEventHandler('pijaca:EoTiVozila', function(vehicles)
	Vozila = vehicles
end)

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, modelName, netId)
	if OdradioTo then
		for i=1, #Vozila, 1 do
			if netId == Vozila[i].NetID then
				local elements = {}
				table.insert(elements, {
					label = 'Da $'..Vozila[i].Cijena,
					value = 'da'
				})
				
				table.insert(elements, {
					label = 'Ne',
					value = 'ne'
				})
				local turbo = "Ne"
				if IsToggleModOn(currentVehicle, 18) then
					turbo = "Da"
				end
				local mjenjac2 = "Automatik"
				ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
					if mj == 2 then
						mjenjac2 = "Rucni"
					end
					local armor
					local kocnice
					local mjenjac
					local motor
					local suspenzija
					if GetVehicleMod(currentVehicle, 16) == -1 then
						armor = "Default"
					else
						armor = "Level "..GetVehicleMod(currentVehicle, 16)
					end
					if GetVehicleMod(currentVehicle, 12) == -1 then
						kocnice = "Default"
					else
						kocnice = "Level "..GetVehicleMod(currentVehicle, 12)
					end
					if GetVehicleMod(currentVehicle, 13) == -1 then
						mjenjac = "Default"
					else
						mjenjac = "Level "..GetVehicleMod(currentVehicle, 13)
					end
					if GetVehicleMod(currentVehicle, 11) == -1 then
						motor = "Default"
					else
						motor = "Level "..GetVehicleMod(currentVehicle, 11)
					end
					if GetVehicleMod(currentVehicle, 15) == -1 then
						suspenzija = "Default"
					else
						suspenzija = "Level "..GetVehicleMod(currentVehicle, 15)
					end
					SendNUIMessage({
						postavisve = true,
						armor = armor,
						kocnice = kocnice,
						mjenjac = mjenjac,
						vmjenjac = mjenjac2,
						motor = motor,
						suspenzija = suspenzija,
						turbo = turbo
					})
					SendNUIMessage({
						prikazi = true
					})
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upit_kupnja_menu', {
						title    = "Zelite li kupiti vozilo za $"..Vozila[i].Cijena.."?",
						align    = 'top-left',
						elements = elements
					}, function(data, menu)
						if data.current.value == "da" then
							SendNUIMessage({
								prikazi = true
							})
							TriggerServerEvent("pijaca:Tuljani", Vozila[i].Tablica, netId)
						elseif data.current.value == "ne" then
							TaskLeaveVehicle(PlayerPedId(), NetworkGetEntityFromNetworkId(Vozila[i].NetID), 1)
							SendNUIMessage({
								prikazi = true
							})
						end
						menu.close()
					end, function(data, menu)
						menu.close()
						TaskLeaveVehicle(PlayerPedId(), NetworkGetEntityFromNetworkId(Vozila[i].NetID), 1)
						SendNUIMessage({
							prikazi = true
						})
					end)
				end, ESX.Math.Trim(GetVehicleNumberPlateText(currentVehicle)))
			end
		end
	end
	--[[
		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),
		modTurbo          = IsToggleModOn(vehicle, 18),
	]]
end)

function KreirajBlip()
	Blip = AddBlipForCoord(890.08746337891, -72.900863647461, 78.223815917969)
	SetBlipSprite (Blip, 147)
	SetBlipDisplay(Blip, 2)
	SetBlipScale  (Blip, 1.2)
	SetBlipColour (Blip, 3)
	SetBlipAsShortRange(Blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Auto pijaca")
	EndTextCommandSetBlipName(Blip)
end

function OpenPijacaMenu()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		ESX.UI.Menu.CloseAll()
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle)
			if isOwnedVehicle then
				local JelDonatorski = false
				for i=1, #Vehicles, 1 do
					if GetHashKey(Vehicles[i].model) == GetEntityModel(vehicle) then
						if Vehicles[i].category == "donatorski" then
							JelDonatorski = true
							break
						end
					end
				end
				if not JelDonatorski then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cijenica_vozila', {
							title = "Upisite cijenu vozila"
						}, function(data, menu)

							local amount = tonumber(data.value)

							if amount == nil then
								ESX.ShowNotification("Niste unjeli cijenu")
							else
								menu.close()
								local vehProps = ESX.Game.GetVehicleProperties(vehicle)
								local naso = 0
								for i=1, #Lokacije, 1 do
									if ESX.Game.IsSpawnPointClear({
										x = Lokacije[i].x,
										y = Lokacije[i].y,
										z = Lokacije[i].z
									}, 3.0) then
										ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
											ESX.Game.DeleteVehicle(vehicle)
											TriggerServerEvent('pijaca:StaviNaProdaju', vehProps, amount, mj, i)
										end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
										naso = 1
										break
									end
								end
								if naso == 0 then
									ESX.ShowNotification("Nema mjesta na pijaci!")
								end
							end
						end, function(data, menu)
						menu.close()
					end)
				else
					ESX.ShowNotification("Ne mozete prodavati donatorsko vozilo!")
				end
			else
				ESX.ShowNotification("Ovo vozilo nije vase!")
			end
		end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
	else
		ESX.ShowNotification("Morate biti u vozilu!")
	end
end

RegisterNetEvent('pijaca:VratiGa')
AddEventHandler('pijaca:VratiGa', function(nid, vehicle)
	local attempt = 0
	while not NetworkDoesEntityExistWithNetworkId(nid) and attempt < 100 do
		Wait(1)
		attempt = attempt+1
	end
	local callback_vehicle = NetworkGetEntityFromNetworkId(nid)
	while not DoesEntityExist(callback_vehicle) do
		Wait(1)
		callback_vehicle = NetworkGetEntityFromNetworkId(nid)
	end
	ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
	FreezeEntityPosition(callback_vehicle, true)
end)

RegisterNetEvent('pijaca:OdmrzniGa')
AddEventHandler('pijaca:OdmrzniGa', function(nid)
	FreezeEntityPosition(NetworkGetEntityFromNetworkId(nid), false)
end)

RegisterNetEvent('pijaca:OdradiTuning')
AddEventHandler('pijaca:OdradiTuning', function()
	OdradiTuning()
end)

AddEventHandler('esx_apijaca:hasEnteredMarker', function(station, part, partNum)

  if part == 'StaviProdat' then
    CurrentAction     = 'menu_staviprodat'
    CurrentActionMsg  = "Pritisnite E da stavite vozilo na prodaju!"
    CurrentActionData = {}
  end
  
end)

AddEventHandler('esx_apijaca:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
  local waitara = 500
  while true do
    Citizen.Wait(waitara)
	local naso = 0
	
	if CurrentAction ~= nil then
	  waitara = 0
	  naso = 1
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) then

        if CurrentAction == 'menu_staviprodat' then
          OpenPijacaMenu()
        end

        CurrentAction = nil

      end

    end
	
	local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)
	local isInMarker     = false
    local currentStation = nil
    local currentPart    = nil
    local currentPartNum = nil
	  
	if GetDistanceBetweenCoords(coords, 890.08746337891, -72.900863647461, 77.223815917969,  true) < 1.5 then
		waitara = 0
		naso = 1
		isInMarker     = true
		currentStation = 1
		currentPart    = 'StaviProdat'
		CurrentPartNum = 1
	end

    local hasExited = false

    if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
		waitara = 0
		naso = 1
        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_apijaca:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_apijaca:hasEnteredMarker', currentStation, currentPart, currentPartNum)
    end

    if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
		waitara = 0
		naso = 1
        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_apijaca:hasExitedMarker', LastStation, LastPart, LastPartNum)
    end

    if GetDistanceBetweenCoords(coords, 890.08746337891, -72.900863647461, 77.223815917969,  true) < Config.DrawDistance then
		waitara = 0
		naso = 1
        DrawMarker(Config.MarkerType, 890.08746337891, -72.900863647461, 77.723815917969, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
		if OdradioTo == false then
			TriggerServerEvent("pijaca:SpawnVozila")
			OdradioTo = true
		end
	else
		OdradioTo = false
	end
	
	if naso == 0 then
		waitara = 500
	end
  end
end)

function OdradiTuning()
	for i=1, #Vozila, 1 do
		if NetworkDoesEntityExistWithNetworkId(Vozila[i].NetID) then
			ESX.Game.SetVehicleProperties(NetworkGetEntityFromNetworkId(Vozila[i].NetID), Vozila[i].Props)
			FreezeEntityPosition(NetworkGetEntityFromNetworkId(Vozila[i].NetID), true)
		end
	end
end