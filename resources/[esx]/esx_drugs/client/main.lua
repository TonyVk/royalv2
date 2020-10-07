Keys = {
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

ESX = nil
local menuOpen = false
local menuOpen2 = false
local wasOpen = false
local wasOpen2 = false
local weedPlants = {}
local Travica = {}
local isPickingUp, isProcessing = false, false
local Sadnice = {}
local Blipovi = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ProvjeriPosao()
end)

function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local connected = false

AddEventHandler("playerSpawned", function()
	if not connected then
		while ESX.PlayerData.job == nil do
			Citizen.Wait(100)
		end
		TriggerServerEvent("trava:ProvjeriSadnice")
		connected = true
	end
end)

Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		while ESX.PlayerData.job == nil do
			Citizen.Wait(100)
		end
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if GetDistanceBetweenCoords(coords, Config.CircleZones.DrugDealer.coords, true) < 100.0 then
			DrawMarker(0, Config.CircleZones.DrugDealer.coords.x, Config.CircleZones.DrugDealer.coords.y, Config.CircleZones.DrugDealer.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
			naso = 1
			waitara = 0
		end
		if GetDistanceBetweenCoords(coords, Config.CircleZones.DrugDealer.coords, true) < 0.5 then
			naso = 1
			waitara = 0
			if not menuOpen then
				ESX.ShowHelpNotification(_U('dealer_prompt'))

				if IsControlJustReleased(0, Keys['E']) then
					wasOpen = true
					OpenDrugShop()
				end
			end
		else
			if wasOpen then
				wasOpen = false
				ESX.UI.Menu.CloseAll()
				menuOpen = false
			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		while ESX.PlayerData.job == nil do
			Citizen.Wait(100)
		end
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if GetDistanceBetweenCoords(coords, Config.CircleZones.Prodaja.coords, true) < 100.0 then
			naso = 1
			waitara = 0
			DrawMarker(0, Config.CircleZones.Prodaja.coords.x, Config.CircleZones.Prodaja.coords.y, Config.CircleZones.Prodaja.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if GetDistanceBetweenCoords(coords, Config.CircleZones.Prodaja.coords, true) < 0.5 then
			naso = 1
			waitara = 0
			if not menuOpen2 then
				ESX.ShowHelpNotification(_U('dealer_prompt2'))

				if IsControlJustReleased(0, Keys['E']) then
					wasOpen2 = true
					OpenSellShop()
				end
			end
		else
			if wasOpen2 then
				wasOpen2 = false
				ESX.UI.Menu.CloseAll()
				menuOpen2 = false
			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

function OpenDrugShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true
	table.insert(elements, {
					label = ('%s - <span style="color:green;">%s</span>'):format("Sjeme", 200),
					name = "seed",
					price = 200,

					-- menu properties
					type = 'slider',
					value = 1,
					min = 1,
					max = 5
	})
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = _U('dealer_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('droge:prodajih', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

function OpenSellShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen2 = true
	local naso = 0

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.DrugDealerItems[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(price))),
				name = v.name,
				price = price,

				-- menu properties
				type = 'slider',
				value = 1,
				min = 1,
				max = v.count
			})
			naso = 1
		end
	end
	if naso == 0 then
		table.insert(elements, {
			label = "Nemate marihuane",
			name = "Nemate marihuane",
			price = 0,

			-- menu properties
			type = 'slider',
			value = 0,
			min = 0,
			max = 0
		})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = _U('dealer_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if naso == 1 then
			TriggerServerEvent('droge:prodajih', data.current.name, data.current.value)
		end
	end, function(data, menu)
		menu.close()
		menuOpen2 = false
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen or menuOpen2 then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

function OpenBuyLicenseMenu(licenseName)
	menuOpen = true
	local license = Config.LicensePrices[licenseName]

	local elements = {
		{
			label = _U('license_no'),
			value = 'no'
		},

		{
			label = ('%s - <span style="color:green;">%s</span>'):format(license.label, _U('dealer_item', ESX.Math.GroupDigits(license.price))),
			value = licenseName,
			price = license.price,
			licenseName = license.label
		}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'license_shop', {
		title    = _U('license_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value ~= 'no' then
			ESX.TriggerServerCallback('esx_drugs:buyLicense', function(boughtLicense)
				if boughtLicense then
					ESX.ShowNotification(_U('license_bought', data.current.licenseName, ESX.Math.GroupDigits(data.current.price)))
				else
					ESX.ShowNotification(_U('license_bought_fail', data.current.licenseName))
				end
			end, data.current.value)
		else
			menu.close()
		end

	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

RegisterNetEvent("trava:PratiRast")
AddEventHandler('trava:PratiRast', function(netid, stanje, co)
	if NetworkDoesEntityExistWithNetworkId(netid) then
		local ObjID = NetworkGetEntityFromNetworkId(netid)
		FreezeEntityPosition(ObjID, true)
	end
	if stanje == 3 then
		table.insert(weedPlants, netid)
		ESX.ShowNotification("[Marihuana] Stabljika je spremna za branje!")
		Blipovi[netid] = AddBlipForCoord(co.x,  co.y,  co.z)
		SetBlipSprite (Blipovi[netid], 140)
		SetBlipDisplay(Blipovi[netid], 2)
		SetBlipColour (Blipovi[netid], 2)
		SetBlipScale  (Blipovi[netid], 0.8)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Izrasla stabljika")
		EndTextCommandSetBlipName(Blipovi[netid])
	else
		Citizen.CreateThread(function()
			local Idic = netid
			local stanjic = stanje
			Citizen.Wait(10000)
			TriggerServerEvent("trava:Izrasti", Idic, stanjic+1)
		end)
	end
end)

RegisterNetEvent("esx_drugs:Animacija")
AddEventHandler('esx_drugs:Animacija', function()
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, false)
	AddArmourToPed(PlayerPedId(), 30)
	local retval = GetPedArmour(PlayerPedId())
	if retval > 100 then
	SetPedArmour(PlayerPedId(), 100)
	end
	Wait(10000)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("trava:MakniSadnicu")
AddEventHandler('trava:MakniSadnicu', function(nid)
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			if Sadnice[i].NetID == nid then
				table.remove(Sadnice, i)
				break
			end
		end
	end
	for a=1, #Travica, 1 do
		if Travica[a] ~= nil then
			if Travica[a].NetID == nid then
				table.remove(Travica, a)
				break
			end
		end
	end
	for b=1, #weedPlants, 1 do
		if weedPlants[b] == nid then
			table.remove(weedPlants, b)
			break
		end
	end
end)

RegisterNetEvent("trava:SpawnSadnicu")
AddEventHandler('trava:SpawnSadnicu', function(br, co)
	local mara
	if br == 1 then
		mara = "bkr_prop_weed_01_small_01a"
	elseif br == 2 then
		mara = "bkr_prop_weed_med_01a"
	else
		mara = "bkr_prop_weed_lrg_01a"
	end
	RequestModel(GetHashKey(mara))
    while not HasModelLoaded(GetHashKey(mara)) do
        Wait(100)
    end
	local playerCoords
	if co == nil then
		playerCoords = GetEntityCoords(PlayerPedId())
	else
		playerCoords = co
	end
	local Marih
	if co == nil then
		Marih = CreateObjectNoOffset(GetHashKey(mara), playerCoords.x,  playerCoords.y,  playerCoords.z-1.0, true, true, false)
	else
		Marih = CreateObjectNoOffset(GetHashKey(mara), playerCoords.x,  playerCoords.y,  playerCoords.z, true, true, false)
	end
	while not DoesEntityExist(Marih) do
		Wait(1)
	end
	Wait(200)
	local netid = NetworkGetNetworkIdFromEntity(Marih)
	NetworkSetNetworkIdDynamic(netid, false)
    SetNetworkIdCanMigrate(netid, true)
    SetNetworkIdExistsOnAllMachines(netid, true)
	table.insert(Sadnice, {NetID = netid, Stanje = br})
	table.insert(Travica, {NetID = netid})
	TriggerEvent("trava:PratiRast", netid, br, playerCoords)
	TriggerServerEvent("trava:EoTiSadnica", netid, br)
	SetModelAsNoLongerNeeded(GetHashKey(mara))
end)

RegisterNetEvent("trava:MakniBlip")
AddEventHandler('trava:MakniBlip', function(nid)
	if DoesBlipExist(Blipovi[nid]) then
		RemoveBlip(Blipovi[nid])
	end
end)

Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		while ESX.PlayerData.job == nil do
			Citizen.Wait(100)
		end
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 100.0 then
			naso = 1
			waitara = 0
			DrawMarker(0, Config.CircleZones.WeedProcessing.coords.x, Config.CircleZones.WeedProcessing.coords.y, Config.CircleZones.WeedProcessing.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 1 then
			naso = 1
			waitara = 0
			if not isProcessing then
				ESX.ShowHelpNotification(_U('weed_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessWeed()
						else
							OpenBuyLicenseMenu('weed_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'weed_processing')
				else
					ProcessWeed()
				end

			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

function ProcessWeed()
	isProcessing = true

	ESX.ShowNotification(_U('weed_processingstarted'))
	TriggerServerEvent('esx_drugs:PreradiGa')
	local timeLeft = Config.Delays.WeedProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 4 then
			ESX.ShowNotification(_U('weed_processingtoofar'))
			TriggerServerEvent('esx_drugs:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		while ESX.PlayerData.job == nil do
			Citizen.Wait(100)
		end
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject = nil
		local nearbyID = nil
		local Travara = false

		for i=1, #weedPlants, 1 do
			if NetworkDoesEntityExistWithNetworkId(weedPlants[i]) then
				local ObjID = NetworkGetEntityFromNetworkId(weedPlants[i])
				if IsEntityAnObject(ObjID) and GetEntityModel(ObjID) == GetHashKey("bkr_prop_weed_lrg_01a") then
					if GetDistanceBetweenCoords(coords, GetEntityCoords(ObjID), false) < 1 then
						nearbyObject, nearbyID = ObjID, i
					end
				end
			end
		end
		
		if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "sipa" then
			for i=1, #Travica, 1 do
				if NetworkDoesEntityExistWithNetworkId(Travica[i].NetID) then
					local ObjID = NetworkGetEntityFromNetworkId(Travica[i].NetID)
					if IsEntityAnObject(ObjID) and (GetEntityModel(ObjID) == GetHashKey("bkr_prop_weed_lrg_01a") or GetEntityModel(ObjID) == GetHashKey("bkr_prop_weed_med_01a") or GetEntityModel(ObjID) == GetHashKey("bkr_prop_weed_01_small_01a")) then
						if GetDistanceBetweenCoords(coords, GetEntityCoords(ObjID), false) < 1 then
							nearbyObject, nearbyID = ObjID, i
							Travara = true
						end
					end
				end
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) and nearbyObject ~= nil then
			local netid = NetworkGetNetworkIdFromEntity(nearbyObject)
			if not isPickingUp then
				if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "sipa" then
					ESX.ShowHelpNotification('Pritisnite ~INPUT_CONTEXT~ da zapljenite stabljiku ~g~kanabisa~s~.')
				else
					ESX.ShowHelpNotification(_U('weed_pickupprompt'))
				end
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true
				if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "sipa" then
					FreezeEntityPosition(playerPed, true)
					TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

					Citizen.Wait(2000)
					ClearPedTasks(playerPed)
					Citizen.Wait(1500)
					FreezeEntityPosition(playerPed, false)
			
					for a=1, #Sadnice, 1 do
						if Sadnice[a] ~= nil then
							if Sadnice[a].NetID == netid then
								TriggerServerEvent("trava:ObrisiSadnicu", netid)
								break
							end
						end
					end
					isPickingUp = false
				else
					ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)

						if canPickUp then
							FreezeEntityPosition(playerPed, true)
							TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

							Citizen.Wait(2000)
							ClearPedTasks(playerPed)
							Citizen.Wait(1500)
							FreezeEntityPosition(playerPed, false)
			
							--ESX.Game.DeleteObject(nearbyObject)
							if DoesBlipExist(Blipovi[netid]) then
								RemoveBlip(Blipovi[netid])
							end
			
							TriggerServerEvent('esx_drugs:EoTiKanabisa')

							for a=1, #Sadnice, 1 do
								if Sadnice[a] ~= nil then
									if Sadnice[a].NetID == netid then
										TriggerServerEvent("trava:ObrisiSadnicu", netid)
										break
									end
								end
							end
						else
							ESX.ShowNotification(_U('weed_inventoryfull'))
						end

						isPickingUp = false

					end, 'cannabis')
				end
			end

		else
			Citizen.Wait(500)
		end

	end

end)