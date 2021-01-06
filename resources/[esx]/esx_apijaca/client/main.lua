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
local Vozila 					= {}
local IsInShopMenu 				= false
local Mjenjac 					= nil
local GarazaV 				  = nil
local Vblip 				  = nil

ESX                             = nil

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
	
	ESX.TriggerServerCallback('pijaca:DohvatiVozila', function(vehicles)
		Vozila = vehicles
	end)
	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function(vozila)
		Vehicles = vozila
	end)
end)

function StartShopRestriction()
	Citizen.CreateThread(function()
		while IsInShopMenu do
			Citizen.Wait(0)

			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)
end

AddEventHandler('playerSpawned', function(spawn)
	ESX.TriggerServerCallback('pijaca:DohvatiVozila', function(vehicles)
		Vozila = vehicles
	end)
	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function(vozila)
		Vehicles = vozila
	end)
	Wait(10000)
	TriggerServerEvent("pijaca:ProvjeriProdane")
end)

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(_U('shop_awaiting_model'))
		EndTextCommandBusyspinnerOn(4)
		SendNUIMessage({
			zabrani = true
		})
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end
		BusyspinnerOff()
		SendNUIMessage({
			zabrani = true
		})
	end
end

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function(vehicles)
	Vehicles = vehicles
end)

RegisterNetEvent('pijaca:EoTiVozila')
AddEventHandler('pijaca:EoTiVozila', function(vehicles)
	Vozila = vehicles
end)

function KreirajBlip()
	Blip = AddBlipForCoord(Config.Prodaja)
	SetBlipSprite (Blip, 147)
	SetBlipDisplay(Blip, 2)
	SetBlipScale  (Blip, 1.2)
	SetBlipColour (Blip, 3)
	SetBlipAsShortRange(Blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Auto pijaca")
	EndTextCommandSetBlipName(Blip)
end

local Pozicija = 1
local currentDisplayVehicle = nil

function OpenKupiMenu()
	IsInShopMenu = true

	StartShopRestriction()
	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, -50.966648101807, -1685.2100830078, 28.785751342773)
	local vehicleData = Vozila[Pozicija].Props
	WaitForVehicleToLoad(vehicleData.model)
	if currentDisplayVehicle ~= nil then
		ESX.Game.DeleteVehicle(currentDisplayVehicle)
		currentDisplayVehicle = nil
	end
	local Ime = nil
	local posa = vector3(-50.966648101807, -1685.2100830078, 28.785751342773)
	ESX.Game.SpawnLocalVehicle(vehicleData.model, posa, 313.19, function(vehicle)
		currentDisplayVehicle = vehicle
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
		SetVehicleDirtLevel(vehicle, 0)
		for k,v in ipairs(Vehicles) do
			if GetHashKey(v.model) == vehicleData.model then
				Ime = v.name
				break
			end
		end
		ESX.Game.SetVehicleProperties(vehicle, vehicleData)
	end)
	while Ime == nil do
		Wait(1)
	end
	while currentDisplayVehicle == nil do
		Wait(1)
	end
	SendNUIMessage({
		postaviime = true,
		imevozila = Ime,
		cijenavozila = Vozila[Pozicija].Cijena.."$"
	})
	SendNUIMessage({
		prikazi = true
	})
	local turbo = "Ne"
	if IsToggleModOn(currentDisplayVehicle, 18) then
		turbo = "Da"
	end
	local mjenjac2 = "Automatik"
	ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
		Mjenjac = mj
		if mj == 2 then
			mjenjac2 = "Rucni"
		end
		local armor
		local kocnice
		local mjenjac
		local motor
		local suspenzija
		if GetVehicleMod(currentDisplayVehicle, 16) == -1 then
			armor = "Default"
		else
			armor = "Level "..GetVehicleMod(currentDisplayVehicle, 16)
		end
		if GetVehicleMod(currentDisplayVehicle, 12) == -1 then
			kocnice = "Default"
		else
			kocnice = "Level "..GetVehicleMod(currentDisplayVehicle, 12)
		end
		if GetVehicleMod(currentDisplayVehicle, 13) == -1 then
			mjenjac = "Default"
		else
			mjenjac = "Level "..GetVehicleMod(currentDisplayVehicle, 13)
		end
		if GetVehicleMod(currentDisplayVehicle, 11) == -1 then
			motor = "Default"
		else
			motor = "Level "..GetVehicleMod(currentDisplayVehicle, 11)
		end
		if GetVehicleMod(currentDisplayVehicle, 15) == -1 then
			suspenzija = "Default"
		else
			suspenzija = "Level "..GetVehicleMod(currentDisplayVehicle, 15)
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
	end, ESX.Math.Trim(GetVehicleNumberPlateText(currentDisplayVehicle)))
	SetNuiFocus(true, true)
end

function DeleteDisplayVehicleInsideShop()
	if currentDisplayVehicle and DoesEntityExist(currentDisplayVehicle) then
		ESX.Game.DeleteVehicle(currentDisplayVehicle)
		currentDisplayVehicle = nil
	end
end

RegisterNetEvent('esx_property:ProsljediVozilo')
AddEventHandler('esx_property:ProsljediVozilo', function(voz, bl)
	if bl == nil then
		if DoesEntityExist(Vblip) then
			RemoveBlip(Vblip)
		end
	end
	GarazaV = voz
	Vblip = bl
end)

RegisterNetEvent('pijaca:VratiVozilo')
AddEventHandler('pijaca:VratiVozilo', function(nid, vehicle, plate, mj, co)
	local attempt = 0
	while not NetworkDoesEntityExistWithNetworkId(nid) and attempt < 100 do
		Wait(1)
		attempt = attempt+1
	end
	if attempt < 100 then
		local callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		while not DoesEntityExist(callback_vehicle) do
			Wait(1)
			callback_vehicle = NetworkGetEntityFromNetworkId(nid)
		end
		local playerPed = PlayerPedId()
		--SetEntityHeading(callback_vehicle, he)
		TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		Wait(100)
		SetVehicleNumberPlateText(callback_vehicle, plate)
		SetVehicleDirtLevel(callback_vehicle, 0)
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		TriggerEvent("EoTiIzSalona", mj)
		
		GarazaV = nid
		local propse = ESX.Game.GetVehicleProperties(callback_vehicle)
		local pla = propse.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, propse.model)
		
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	else
		print("Greska prilikom kreiranja vozila. NetID: "..nid)
		local ped = GetPlayerPed(-1)
		SetEntityCoords(ped, co)
		local coords = GetEntityCoords(ped)
		local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
		local callback_vehicle = veh
		local playerPed = ped
		--SetEntityHeading(callback_vehicle, he)
		TaskWarpPedIntoVehicle(playerPed, callback_vehicle, -1)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		Wait(100)
		SetVehicleNumberPlateText(callback_vehicle, plate)
		SetVehicleDirtLevel(callback_vehicle, 0)
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		TriggerEvent("EoTiIzSalona", mj)
		
		GarazaV = nid
		local propse = ESX.Game.GetVehicleProperties(callback_vehicle)
		local pla = propse.plate:gsub("^%s*(.-)%s*$", "%1")
		TriggerServerEvent("garaza:SpremiModel", pla, propse.model)
		
		Vblip = AddBlipForEntity(callback_vehicle)
		SetBlipSprite (Vblip, 225)
		SetBlipDisplay(Vblip, 4)
		SetBlipScale  (Vblip, 1.0)
		SetBlipColour (Vblip, 30)
		SetBlipAsShortRange(Vblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vase vozilo")
		EndTextCommandSetBlipName(Vblip)
		TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
	end
end)

RegisterNUICallback(
    "kupi",
    function()
		SetNuiFocus(false)
		SendNUIMessage({
			prikazi = true
		})
		IsInShopMenu = false
		if GarazaV ~= nil then
			TriggerServerEvent("garaza:ObrisiVozilo", GarazaV)
			GarazaV = nil
			if Vblip ~= nil then
				RemoveBlip(Vblip)
				Vblip = nil
			end
		end
		DeleteDisplayVehicleInsideShop()
		local waitara = math.random(200, 800)
		Wait(waitara)
		TriggerServerEvent("pijaca:Tuljani", Vozila[Pozicija].Tablica, Vozila[Pozicija].Props, Mjenjac)
		Mjenjac = nil
		Pozicija = 1
	end
)

RegisterNUICallback(
    "svijetla",
    function(data, cb)
		if data.svijetla == true then
			SetVehicleLights(currentDisplayVehicle, 2)
		else
			SetVehicleLights(currentDisplayVehicle, 0)
		end
    end
)

RegisterNUICallback(
    "vrata",
    function(data, cb)
		if data.otvori == true then
			SetVehicleDoorOpen(currentDisplayVehicle, 0, false, false) --vrata
			SetVehicleDoorOpen(currentDisplayVehicle, 1, false, false) --vrata
			SetVehicleDoorOpen(currentDisplayVehicle, 2, false, false) --vrata
			SetVehicleDoorOpen(currentDisplayVehicle, 3, false, false) --vrata
			SetVehicleDoorOpen(currentDisplayVehicle, 4, false, false) --hauba
			SetVehicleDoorOpen(currentDisplayVehicle, 5, false, false) --gepek
		else
			SetVehicleDoorsShut(currentDisplayVehicle, false)
		end
    end
)

RegisterNUICallback(
    "pogled",
    function(data, cb)
		if data.pogled == true then
			SetNuiFocus(false)
			SendNUIMessage({
				prikazi = true
			})
			CurrentAction     = 'shop_pregled'
			CurrentActionMsg  = "Pritisnite ~INPUT_FRONTEND_RRIGHT~ da izadjete iz pregleda vozila!"
			CurrentActionData = {}
		end
    end
)

RegisterNUICallback(
    "zatvori",
    function()
		SetNuiFocus(false)
		local playerPed = PlayerPedId()
		Pozicija = 1
		
		DeleteDisplayVehicleInsideShop()

		CurrentAction     = 'menu_kupi'
		CurrentActionMsg  = "Pritisnite E da vidite listu vozila!"
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, -41.069328308105, -1675.1540527344, 28.443593978882)

		IsInShopMenu = false
    end
)

RegisterNUICallback(
    "lijevo",
    function()
		if Pozicija-1 ~= 0 then
			Pozicija = Pozicija-1
			local vehicleData = Vozila[Pozicija].Props
			local playerPed   = PlayerPedId()
			DeleteDisplayVehicleInsideShop()
			WaitForVehicleToLoad(vehicleData.model)
			if currentDisplayVehicle ~= nil then
				ESX.Game.DeleteVehicle(currentDisplayVehicle)
				currentDisplayVehicle = nil
			end
			local Ime = nil
			local posa = vector3(-50.966648101807, -1685.2100830078, 28.785751342773)
			ESX.Game.SpawnLocalVehicle(vehicleData.model, posa, 313.19, function(vehicle)
				currentDisplayVehicle = vehicle
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				FreezeEntityPosition(vehicle, true)
				SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
				SetVehicleDirtLevel(vehicle, 0)
				for k,v in ipairs(Vehicles) do
					if GetHashKey(v.model) == vehicleData.model then
						Ime = v.name
						break
					end
				end
				ESX.Game.SetVehicleProperties(vehicle, vehicleData)
			end)
			while Ime == nil do
				Wait(1)
			end
			while currentDisplayVehicle == nil do
				Wait(1)
			end
			SendNUIMessage({
				postaviime = true,
				imevozila = Ime,
				cijenavozila = Vozila[Pozicija].Cijena.."$"
			})
			local turbo = "Ne"
			if IsToggleModOn(currentDisplayVehicle, 18) then
				turbo = "Da"
			end
			local mjenjac2 = "Automatik"
			ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
				Mjenjac = mj
				if mj == 2 then
					mjenjac2 = "Rucni"
				end
				local armor
				local kocnice
				local mjenjac
				local motor
				local suspenzija
				if GetVehicleMod(currentDisplayVehicle, 16) == -1 then
					armor = "Default"
				else
					armor = "Level "..GetVehicleMod(currentDisplayVehicle, 16)
				end
				if GetVehicleMod(currentDisplayVehicle, 12) == -1 then
					kocnice = "Default"
				else
					kocnice = "Level "..GetVehicleMod(currentDisplayVehicle, 12)
				end
				if GetVehicleMod(currentDisplayVehicle, 13) == -1 then
					mjenjac = "Default"
				else
					mjenjac = "Level "..GetVehicleMod(currentDisplayVehicle, 13)
				end
				if GetVehicleMod(currentDisplayVehicle, 11) == -1 then
					motor = "Default"
				else
					motor = "Level "..GetVehicleMod(currentDisplayVehicle, 11)
				end
				if GetVehicleMod(currentDisplayVehicle, 15) == -1 then
					suspenzija = "Default"
				else
					suspenzija = "Level "..GetVehicleMod(currentDisplayVehicle, 15)
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
			end, ESX.Math.Trim(GetVehicleNumberPlateText(currentDisplayVehicle)))
		end
    end
)

RegisterNUICallback(
    "desno",
    function()
		if Pozicija+1 <= #Vozila then
			Pozicija = Pozicija+1
			local vehicleData = Vozila[Pozicija].Props
			local playerPed   = PlayerPedId()
			DeleteDisplayVehicleInsideShop()
			WaitForVehicleToLoad(vehicleData.model)
			if currentDisplayVehicle ~= nil then
				ESX.Game.DeleteVehicle(currentDisplayVehicle)
				currentDisplayVehicle = nil
			end
			local Ime = nil
			local posa = vector3(-50.966648101807, -1685.2100830078, 28.785751342773)
			ESX.Game.SpawnLocalVehicle(vehicleData.model, posa, 313.19, function(vehicle)
				currentDisplayVehicle = vehicle
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				FreezeEntityPosition(vehicle, true)
				SetModelAsNoLongerNeeded(GetHashKey(vehicleData.model))
				SetVehicleDirtLevel(vehicle, 0)
				for k,v in ipairs(Vehicles) do
					if GetHashKey(v.model) == vehicleData.model then
						Ime = v.name
						break
					end
				end
				ESX.Game.SetVehicleProperties(vehicle, vehicleData)
			end)
			while Ime == nil do
				Wait(1)
			end
			while currentDisplayVehicle == nil do
				Wait(1)
			end
			SendNUIMessage({
				postaviime = true,
				imevozila = Ime,
				cijenavozila = Vozila[Pozicija].Cijena.."$"
			})
			local turbo = "Ne"
			if IsToggleModOn(currentDisplayVehicle, 18) then
				turbo = "Da"
			end
			local mjenjac2 = "Automatik"
			ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
				Mjenjac = mj
				if mj == 2 then
					mjenjac2 = "Rucni"
				end
				local armor
				local kocnice
				local mjenjac
				local motor
				local suspenzija
				if GetVehicleMod(currentDisplayVehicle, 16) == -1 then
					armor = "Default"
				else
					armor = "Level "..GetVehicleMod(currentDisplayVehicle, 16)
				end
				if GetVehicleMod(currentDisplayVehicle, 12) == -1 then
					kocnice = "Default"
				else
					kocnice = "Level "..GetVehicleMod(currentDisplayVehicle, 12)
				end
				if GetVehicleMod(currentDisplayVehicle, 13) == -1 then
					mjenjac = "Default"
				else
					mjenjac = "Level "..GetVehicleMod(currentDisplayVehicle, 13)
				end
				if GetVehicleMod(currentDisplayVehicle, 11) == -1 then
					motor = "Default"
				else
					motor = "Level "..GetVehicleMod(currentDisplayVehicle, 11)
				end
				if GetVehicleMod(currentDisplayVehicle, 15) == -1 then
					suspenzija = "Default"
				else
					suspenzija = "Level "..GetVehicleMod(currentDisplayVehicle, 15)
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
			end, ESX.Math.Trim(GetVehicleNumberPlateText(currentDisplayVehicle)))
		end
    end
)

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
								ESX.TriggerServerCallback('mjenjac:ProvjeriVozilo',function(mj)
									ESX.Game.DeleteVehicle(vehicle)
									TriggerServerEvent('pijaca:StaviNaProdaju', vehProps, amount, mj, i)
								end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
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

AddEventHandler('esx_apijaca:hasEnteredMarker', function(station, part, partNum)

  if part == 'StaviProdat' then
    CurrentAction     = 'menu_staviprodat'
    CurrentActionMsg  = "Pritisnite E da stavite vozilo na prodaju!"
    CurrentActionData = {}
  end
  
  if part == 'Kupi' then
    CurrentAction     = 'menu_kupi'
    CurrentActionMsg  = "Pritisnite E da vidite listu vozila!"
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
	  
		if IsControlJustReleased(0, 202) then
			if CurrentAction == 'shop_pregled' then
				SendNUIMessage({
					prikazi = true
				})
				SetNuiFocus(true, true)
				CurrentAction = nil
			end
		end

      if IsControlPressed(0,  Keys['E']) then

        if CurrentAction == 'menu_staviprodat' then
          OpenPijacaMenu()
        end
		
		if CurrentAction == 'menu_kupi' then
			if #Vozila ~= 0 then
				OpenKupiMenu()
			else
				ESX.ShowNotification("Nema vozila na pijaci!")
			end
        end

		if CurrentAction ~= "shop_pregled" then
			CurrentAction = nil
		end

      end

    end
	
	local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)
	local isInMarker     = false
    local currentStation = nil
    local currentPart    = nil
    local currentPartNum = nil
	  
	if #(coords-Config.Prodaja) < 1.5 then
		waitara = 0
		naso = 1
		isInMarker     = true
		currentStation = 1
		currentPart    = 'StaviProdat'
		CurrentPartNum = 1
	end
	
	if #(coords-Config.Kupovina) < 1.5 then
		waitara = 0
		naso = 1
		isInMarker     = true
		currentStation = 1
		currentPart    = 'Kupi'
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

    if #(coords-Config.Prodaja) < Config.DrawDistance then
		waitara = 0
		naso = 1
        DrawMarker(Config.MarkerType, Config.Prodaja, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
	end
	
	if #(coords-Config.Kupovina) < Config.DrawDistance then
		waitara = 0
		naso = 1
        DrawMarker(Config.MarkerType, Config.Kupovina, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
	end
	
	if naso == 0 then
		waitara = 2000
	end
  end
end)