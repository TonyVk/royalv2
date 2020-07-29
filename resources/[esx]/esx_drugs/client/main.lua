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
local wasOpen = false
local spawnedWeeds = 0
local weedPlants = {}
local isPickingUp, isProcessing = false, false
local br = 1
local blip = {}
local Mafije = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ESX.TriggerServerCallback('mafije:DohvatiMafijev2', function(mafija)
		Mafije = mafija
	end)
	ProvjeriPosao()
end)

function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
	local naso = 0
	for i=1, #Mafije, 1 do
		if Mafije[i] ~= nil and Mafije[i].Ime == ESX.PlayerData.job.name then
			naso = 1
			break
		end
	end
	if naso == 1 or ESX.PlayerData.job.name == "ballas" then
		local i = 1
		for k,zone in pairs(Config.CircleZones) do
			if not DoesBlipExist(blip[i]) then
				CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
			end
			i = i+2
		end
	else
		for i=1, br, 1 do
			if DoesBlipExist(blip[i]) then
				RemoveBlip(blip[i])
			end
		end
		br = 1
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	local naso = 0
	for i=1, #Mafije, 1 do
		if Mafije[i] ~= nil and Mafije[i].Ime == ESX.PlayerData.job.name then
			naso = 1
			break
		end
	end
	if naso == 1 or ESX.PlayerData.job.name == "ballas" then
		local i = 1
		for k,zone in pairs(Config.CircleZones) do
			if not DoesBlipExist(blip[i]) then
				CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
			end
			i = i+2
		end
	else
		for i=1, br, 1 do
			if DoesBlipExist(blip[i]) then
				RemoveBlip(blip[i])
			end
		end
		br = 1
	end
end)

local connected = false

AddEventHandler("playerSpawned", function()
	if not connected then
		while ESX.PlayerData.job == nil do
			Citizen.Wait(100)
		end
		ESX.TriggerServerCallback('mafije:DohvatiMafijev2', function(mafija)
			Mafije = mafija
		end)
		Wait(500)
		local naso = 0
		for i=1, #Mafije, 1 do
			if Mafije[i] ~= nil and Mafije[i].Ime == ESX.PlayerData.job.name then
				naso = 1
				break
			end
		end
		if naso == 1 or ESX.PlayerData.job.name == "ballas" then
			print("tri")
			local i = 1
			for k,zone in pairs(Config.CircleZones) do
				if not DoesBlipExist(blip[i]) then
					CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
					print("cetri")
				end
				i = i+2
			end
		else
			for i=1, br, 1 do
				if DoesBlipExist(blip[i]) then
					RemoveBlip(blip[i])
				end
			end
			br = 1
		end
		connected = true
	end
end)

RegisterNetEvent('mafije:UpdateMafije')
AddEventHandler('mafije:UpdateMafije', function(maf)
	Mafije = maf
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		while ESX.PlayerData.job == nil do
			Citizen.Wait(100)
		end
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.DrugDealer.coords, true) < 0.5 then
			if not menuOpen then
				local naso = 0
				for i=1, #Mafije, 1 do
					if Mafije[i] ~= nil and Mafije[i].Ime == ESX.PlayerData.job.name then
						naso = 1
						break
					end
				end
				if naso == 1 or ESX.PlayerData.job.name == "ballas" then
					ESX.ShowHelpNotification(_U('dealer_prompt'))

					if IsControlJustReleased(0, Keys['E']) then
						wasOpen = true
						OpenDrugShop()
					end
				end
			else
				Citizen.Wait(500)
			end
		else
			if wasOpen then
				wasOpen = false
				ESX.UI.Menu.CloseAll()
				menuOpen = false
			end

			Citizen.Wait(500)
		end
	end
end)

function OpenDrugShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

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
		end
	end
	table.insert(elements, {
					label = ('%s - <span style="color:green;">%s</span>'):format("Sjeme", 45),
					name = "seed",
					price = 45,

					-- menu properties
					type = 'slider',
					value = 1,
					min = 1,
					max = 10
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

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
		for k, v in pairs(weedPlants) do
			ESX.Game.DeleteObject(v)
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

RegisterCommand("posadi", function(source, args, rawCommandString)
	local naso = 0
	for i=1, #Mafije, 1 do
		if Mafije[i] ~= nil and Mafije[i].Ime == ESX.PlayerData.job.name then
			naso = 1
			break
		end
	end
	if naso == 1 or ESX.PlayerData.job.name == "ballas" then
		for k, v in pairs(ESX.GetPlayerData().inventory) do
			if v.name == "seed" then
				if v.count > 0 then
					local coords = GetEntityCoords(PlayerPedId())
					if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 50 then
						SpawnWeedPlants()
					end
				end
			end
		end
	end
end, false)

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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 1 then
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
		else
			Citizen.Wait(500)
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
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('weed_pickupprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)

					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(weedPlants, nearbyID)
						spawnedWeeds = spawnedWeeds - 1
		
						TriggerServerEvent('esx_drugs:EoTiKanabisa')
					else
						ESX.ShowNotification(_U('weed_inventoryfull'))
					end

					isPickingUp = false

				end, 'cannabis')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

function SpawnWeedPlants()
		Citizen.Wait(0)
		local weedCoords = GetEntityCoords(PlayerPedId())
		TriggerServerEvent('esx_drugs:MakniSeed')
		--local weedCoords = GenerateWeedCoords()
		local travca
		ESX.Game.SpawnObject('prop_weed_02', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			spawnedWeeds = spawnedWeeds + 1
			travca = obj
		end)
		Wait(60000)
		ESX.Game.DeleteObject(travca)
		ESX.Game.SpawnObject('prop_weed_01', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			table.insert(weedPlants, obj)
		end)
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeeds > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		weedCoordX = Config.CircleZones.WeedField.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField.coords.y + modY

		local coordZ = GetCoordZ(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end

function CreateBlipCircle(coords, text, radius, color, sprite)
	blip[br] = AddBlipForRadius(coords, radius)

	SetBlipHighDetail(blip[br], true)
	SetBlipColour(blip[br], 1)
	SetBlipAlpha (blip[br], 128)
	
	br = br+1

	-- create a blip in the middle
	blip[br] = AddBlipForCoord(coords)

	SetBlipHighDetail(blip[br], true)
	SetBlipSprite (blip[br], sprite)
	SetBlipScale  (blip[br], 1.0)
	SetBlipColour (blip[br], color)
	SetBlipAsShortRange(blip[br], true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip[br])
	br = br+1
end