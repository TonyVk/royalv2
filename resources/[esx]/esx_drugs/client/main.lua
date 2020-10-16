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
					max = 20
	})
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = _U('dealer_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local torba = 0
		TriggerEvent('skinchanger:getSkin', function(skin)
			torba = skin['bags_1']
		end)
		if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
			TriggerServerEvent('droge:prodajih', data.current.name, data.current.value, true)
		else
			TriggerServerEvent('droge:prodajih', data.current.name, data.current.value, false)
		end
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

RegisterNetEvent("trava:EoTiNetID")
AddEventHandler('trava:EoTiNetID', function(netid,co, stanje, src)
	table.insert(Sadnice, {NetID = netid, Stanje = stanje, Koord = co, ID = src})
	table.insert(Travica, {NetID = netid, ID = src, Koord = co})
end)

RegisterNetEvent("trava:PromjeniNetID")
AddEventHandler('trava:PromjeniNetID', function(oldnet, newnet, stanje, src)
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			if Sadnice[i].NetID == oldnet and Sadnice[i].ID == src then
				Sadnice[i].NetID = newnet
				for a=1, #Travica, 1 do
					if Travica[a] ~= nil then
						if Travica[a].NetID == oldnet then
							Travica[a].NetID = newnet
							break
						end
					end
				end
				if stanje == 3 then
					table.insert(weedPlants, {NetID = newnet, Koord = Sadnice[i].Koord})
				end
				break
			end
		end
	end
end)

RegisterNetEvent("trava:NoviNetID")
AddEventHandler('trava:NoviNetID', function(oldnet, newnet, stanje, src)
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			if Sadnice[i].NetID == oldnet and Sadnice[i].ID == src then
				Sadnice[i].NetID = newnet
				for a=1, #Travica, 1 do
					if Travica[a] ~= nil and Travica[a].ID == src then
						if Travica[a].NetID == oldnet then
							Travica[a].NetID = newnet
							break
						end
					end
				end
				if stanje == 3 then
					for g=1, #weedPlants, 1 do
						local x,y,z = table.unpack(weedPlants[g].Koord)
						local x2,y2,z2 = table.unpack(Sadnice[i].Koord)
						if weedPlants[g].NetID == oldnet and round(x, 3) == round(x2, 3) and round(y, 3) == round(y2, 3)and round(z, 3) == round(z2, 3) then
							table.remove(weedPlants, g)
							break
						end
					end
					table.insert(weedPlants, {NetID = newnet, Koord = Sadnice[i].Koord})
				end
				break
			end
		end
	end
end)

RegisterNetEvent("trava:PratiRast")
AddEventHandler('trava:PratiRast', function(netid, stanje, co)
	if NetworkDoesEntityExistWithNetworkId(netid) then
		local ObjID = NetworkGetEntityFromNetworkId(netid)
		FreezeEntityPosition(ObjID, true)
	end
	if stanje == 3 then
		table.insert(weedPlants, {NetID = netid, Koord = co})
		ESX.ShowNotification("[Marihuana] Stabljika je spremna za branje!")
	else
		Citizen.CreateThread(function()
			local Idic = netid
			local stanjic = stanje
			Citizen.Wait(10000) --3600000
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

RegisterNetEvent("trava:NemosBrati")
AddEventHandler('trava:NemosBrati', function(nid, co)
	for b=1, #weedPlants, 1 do
		local x,y,z = table.unpack(weedPlants[b].Koord)
		local x2,y2,z2 = table.unpack(co)
		if weedPlants[b].NetID == nid and round(x, 3) == round(x2, 3) and round(y, 3) == round(y2, 3)and round(z, 3) == round(z2, 3) then
			table.remove(weedPlants, b)
			break
		end
	end
end)

RegisterNetEvent("trava:MakniSadnicu")
AddEventHandler('trava:MakniSadnicu', function(nid, co)
	for i=1, #Sadnice, 1 do
		if Sadnice[i] ~= nil then
			local x,y,z = table.unpack(Sadnice[i].Koord)
			local x2,y2,z2 = table.unpack(co)
			if Sadnice[i].NetID == nid and round(x, 3) == round(x2, 3) and round(y, 3) == round(y2, 3)and round(z, 3) == round(z2, 3) then
				table.remove(Sadnice, i)
				break
			end
		end
	end
	for a=1, #Travica, 1 do
		if Travica[a] ~= nil then
			local x,y,z = table.unpack(Travica[a].Koord)
			local x2,y2,z2 = table.unpack(co)
			if Travica[a].NetID == nid and round(x, 3) == round(x2, 3) and round(y, 3) == round(y2, 3)and round(z, 3) == round(z2, 3) then
				table.remove(Travica, a)
				break
			end
		end
	end
	for b=1, #weedPlants, 1 do
		local x,y,z = table.unpack(weedPlants[b].Koord)
		local x2,y2,z2 = table.unpack(co)
		if weedPlants[b].NetID == nid and round(x, 3) == round(x2, 3) and round(y, 3) == round(y2, 3)and round(z, 3) == round(z2, 3) then
			table.remove(weedPlants, b)
			break
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

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterCommand("ispisisadnice", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			print("Broj sadnica:"..#Sadnice)
			for i=1, #Sadnice, 1 do
				if Sadnice[i] ~= nil then
					print("Br:"..i)
					print("NetID:"..Sadnice[i].NetID)
				end
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

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
			if NetworkDoesEntityExistWithNetworkId(weedPlants[i].NetID) then
				local ObjID = NetworkGetEntityFromNetworkId(weedPlants[i].NetID)
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
			local kordara = GetEntityCoords(nearbyObject)
			local xa,ya,za = table.unpack(kordara)
			local kordara2 = vector3(xa,ya,za)
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
							local x,y,z = table.unpack(Sadnice[a].Koord)
							local x2,y2,z2 = table.unpack(kordara2)
							if round(x, 3) == round(x2, 3) and round(y, 3) == round(y2, 3)and round(z, 3) == round(z2, 3) then
								TriggerServerEvent("trava:ObrisiSadnicu", netid, kordara2)
								break
							end
						end
					end
					isPickingUp = false
				else
					ESX.TriggerServerCallback('esx_drugs:canPickUp', function(canPickUp)

						if canPickUp then
							TriggerServerEvent("trava:MakniBranje", netid, kordara2)
							FreezeEntityPosition(playerPed, true)
							TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

							Citizen.Wait(2000)
							ClearPedTasks(playerPed)
							Citizen.Wait(1500)
							FreezeEntityPosition(playerPed, false)
			
							--ESX.Game.DeleteObject(nearbyObject)
			
							TriggerServerEvent('esx_drugs:EoTiKanabisa')

							for a=1, #Sadnice, 1 do
								if Sadnice[a] ~= nil then
									local x,y,z = table.unpack(Sadnice[a].Koord)
									local x2,y2,z2 = table.unpack(kordara2)
									if round(x, 3) == round(x2, 3) and round(y, 3) == round(y2, 3)and round(z, 3) == round(z2, 3) then
										TriggerServerEvent("trava:ObrisiSadnicu", netid, kordara2)
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