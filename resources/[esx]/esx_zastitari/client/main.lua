local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
local Tablice
local Vezan = 0
local Odradio = false
local MosKrenit = false
dragStatus.isDragged = false
local animation = false
local Mrtav = 0
local Cufan = false
local BVozilo = nil
local PostavioEUP = false
local PlayerLoaded = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerLoaded = true
	PlayerData = ESX.GetPlayerData()
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	PlayerLoaded = true
end)

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].EUP == false or Config.Uniforms[job].EUP == nil then
				if Config.Uniforms[job].male and PostavioEUP == false then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
				end
			else
				local jobic = "EUP"..job
				local outfit = Config.Uniforms[jobic].male
				local ped = playerPed

				RequestModel(outfit.ped)

				while not HasModelLoaded(outfit.ped) do
					Wait(0)
				end

				if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
					SetPlayerModel(PlayerId(), outfit.ped)
				end
				SetModelAsNoLongerNeeded(outfit.ped)
				ped = PlayerPedId()

				for _, comp in ipairs(outfit.components) do
				   SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
				end

				for _, comp in ipairs(outfit.props) do
					if comp[2] == 0 then
						ClearPedProp(ped, comp[1])
					else
						SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
					end
				end
				PostavioEUP = true
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.Uniforms[job].EUP == false or Config.Uniforms[job].EUP == nil then
				if Config.Uniforms[job].female  and PostavioEUP == false then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
				end
			else
				local jobic = "EUP"..job
				local outfit = Config.Uniforms[jobic].female
				local ped = playerPed

				RequestModel(outfit.ped)

				while not HasModelLoaded(outfit.ped) do
					Wait(0)
				end

				if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
					SetPlayerModel(PlayerId(), outfit.ped)
				end
				SetModelAsNoLongerNeeded(outfit.ped)
				ped = PlayerPedId()

				for _, comp in ipairs(outfit.components) do
				   SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
				end

				for _, comp in ipairs(outfit.props) do
					if comp[2] == 0 then
						ClearPedProp(ped, comp[1])
					else
						SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
					end
				end
				PostavioEUP = true
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		end
	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' }
	}

	local val = grade.."_wear"
	table.insert(elements, {label = _U('police_wear'), value = val})

	if Config.EnableNonFreemodePeds then
		table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		table.insert(elements, {label = 'Swat wear', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0
					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
				PostavioEUP = false
			end

			if Config.MaxInService ~= -1 then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'zastitar')

						TriggerServerEvent('esx_service:disableService', 'zastitar')
						TriggerEvent('esx_zastitari:updateBlip')
						ESX.ShowNotification(_U('service_out'))
						RemoveAllPedWeapons(PlayerId(), false)
					end
				end, 'zastitar')
			end
		else
			setUniform(data.current.value, PlayerPedId())
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else
							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'zastitar')
							TriggerEvent('esx_zastitari:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'zastitar')

				else
					serviceOk = true
				end
			end, 'zastitar')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)
	local elements = {
		{label = _U('buy_weapons'), value = 'buy_weapons'}
	}

	if Config.EnableArmoryManagement then
		if PlayerData.job.grade > 1 then
			table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
		end
		table.insert(elements, {label = _U('put_weapon'),     value = 'put_weapon'})
		if PlayerData.job.grade > 1 then
			table.insert(elements, {label = 'Uzmi stvar',  value = 'get_stock'})
		end
		table.insert(elements, {label = 'Ostavi stvar', value = 'put_stock'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = _U('armory'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

				if data.current.value == 'get_weapon' then
					OpenGetWeaponMenu()
				elseif data.current.value == 'put_weapon' then
					OpenPutWeaponMenu()
				elseif data.current.value == 'buy_weapons' then
					OpenBuyWeaponsMenu()
				elseif data.current.value == 'put_stock' then
					OpenPutStocksMenu()
				elseif data.current.value == 'get_stock' then
					OpenGetStocksMenu()
				end

			end, function(data, menu)
				menu.close()

				CurrentAction     = 'menu_armory'
				CurrentActionMsg  = _U('open_armory')
				CurrentActionData = {station = station}
	end)
end

function OpenVehicleSpawnerMenu(station, partNum)

  local vehicles = Config.ZastitarStations[station].Vehicles

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('vehicle_menu'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value

          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
            ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
            local playerPed = GetPlayerPed(-1)
            TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
			SetVehicleCustomSecondaryColour(vehicle, 0, 0, 0)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mafia', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('garage_prompt')
          CurrentActionData = {station = station, partNum = partNum}

        end
      )

    end, 'zastitar')

  else

    local elements = {}

    for i=1, #Config.ZastitarStations[station].AuthorizedVehicles, 1 do
      local vehicle = Config.ZastitarStations[station].AuthorizedVehicles[i]
      table.insert(elements, {label = vehicle.label, value = vehicle.name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

          if Config.MaxInService == -1 then
			if BVozilo ~= nil then
				ESX.Game.DeleteVehicle(BVozilo)
				BVozilo = nil
			end
			ESX.Streaming.RequestModel(model)
			BVozilo = CreateVehicle(model, vehicles[partNum].SpawnPoint.x, vehicles[partNum].SpawnPoint.y, vehicles[partNum].SpawnPoint.z, vehicles[partNum].Heading, true, false)
            TaskWarpPedIntoVehicle(playerPed,  BVozilo,  -1)
            SetVehicleMaxMods(BVozilo)
            SetVehicleCustomPrimaryColour(BVozilo, 0, 0, 0)
			SetVehicleCustomSecondaryColour(BVozilo, 0, 0, 0)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                  SetVehicleMaxMods(vehicle)
				  SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
			      SetVehicleCustomSecondaryColour(vehicle, 0, 0, 0)
                end)

              else
                ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'zastitar')

          end

        else
          ESX.ShowNotification(_U('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('garage_prompt')
        CurrentActionData = {station = station, partNum = partNum}

      end
    )

  end

end

function StoreNearbyVehicle(playerCoords)
	if ESX.Math.Trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))) == Tablice then
	ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
	else
	ESX.ShowNotification("Niste u vozilu sa kojim ste otisli na posao!")
	end
end

function GetAvailableVehicleSpawnPoint(station, part, partNum)
	local spawnPoints = Config.ZastitarStations[station][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('vehicle_blocked'))
		return false
	end
end

function SetVehicleMaxMods(vehicle, tip)
	local props = {}
	if tip == 2 then
		props = {
			modEngine       = 2,
			modBrakes       = 2,
			modTransmission = 2,
			modSuspension   = 3,
			modTurbo        = true,
			wheels 			= 7,
			modFrontWheels  = 2
		}
	else
		props = {
			modEngine       = 2,
			modBrakes       = 2,
			modTransmission = 2,
			modSuspension   = 3,
			modTurbo        = true
		}
	end

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('vehicleshop_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),
			align    = 'top-left',
			elements = {
				{label = _U('confirm_no'), value = 'no'},
				{label = _U('confirm_yes'), value = 'yes'}
		}}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate
				Tablice = newPlate



					isInShopMenu = false
					ESX.UI.Menu.CloseAll()
					DeleteSpawnedVehicles()
					FreezeEntityPosition(playerPed, false)
					SetEntityVisible(playerPed, true)

					ESX.Game.Teleport(playerPed, restoreCoords)
					local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(LastStation, LastPart, LastPartNum)

					if foundSpawn then
							menu2.close()
							
							if BVozilo ~= nil then
								ESX.Game.DeleteVehicle(BVozilo)
								BVozilo = nil
							end
							ESX.Streaming.RequestModel(data.current.model)
							BVozilo = CreateVehicle(data.current.model, spawnPoint.coords, spawnPoint.heading, true, false)
							SetModelAsNoLongerNeeded(data.current.model)
							ESX.Game.SetVehicleProperties(BVozilo, props)
							SetVehicleMaxMods(BVozilo, 1)

							ESX.ShowNotification(_U('garage_released'))
					end
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()

		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			SetModelAsNoLongerNeeded(data.current.model)
			SetVehicleMaxMods(vehicle, 1)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)

			if data.current.livery then
				SetVehicleModKit(vehicle, 0)
				SetVehicleLivery(vehicle, data.current.livery)
			end
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		SetModelAsNoLongerNeeded(elements[1].model)
		SetVehicleMaxMods(vehicle, 1)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)

		if elements[1].livery then
			SetVehicleModKit(vehicle, 0)
			SetVehicleLivery(vehicle,elements[1].livery)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)

			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

function OpenZastitarActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zastitar_actions', {
		title    = 'Zastitar',
		align    = 'top-left',
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'), value = 'vehicle_interaction'}
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('id_card'), value = 'identity_card'},
				{label = _U('search'), value = 'body_search'},
				{label = "[Cuff] Stavi lisice", value = 'handcuff'},
				{label = "[Cuff] Oslobodi", value = 'handcuff3'},
				{label = _U('drag'), value = 'drag'},
				{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('esx_zastitari:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('esx_zastitari:handcuff', GetPlayerServerId(closestPlayer), 1)
					elseif action == 'handcuff3' then
						TriggerServerEvent('esx_zastitari:handcuff', GetPlayerServerId(closestPlayer), 3)
					elseif action == 'drag' then
						TriggerServerEvent('esx_zastitari:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_zastitari:putInVehicle', GetPlayerServerId(closestPlayer))
						ClearPedTasks(PlayerPedId())
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_zastitari:OutVehicle', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title    = _U('vehicle_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value

				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('esx_zastitari:getOtherPlayerData', function(data)
		local elements = {}
		local nameLabel = _U('name', data.name)
		local jobLabel, sexLabel, dobLabel, heightLabel, idLabel

		if data.job.grade_label and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end

		if Config.EnableESXIdentity then
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)

			if data.sex then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end

			if data.dob then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end

			if data.height then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end

			if data.name then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
		end

		local elements = {
			{label = nameLabel},
			{label = jobLabel}
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel})
			table.insert(elements, {label = dobLabel})
			table.insert(elements, {label = heightLabel})
			table.insert(elements, {label = idLabel})
		end

		if data.drunk then
			table.insert(elements, {label = _U('bac', data.drunk)})
		end

		if data.licenses then
			table.insert(elements, {label = _U('license_label')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx_zastitari:getOtherPlayerData', function(data)
		local elements = {}

		if data.novac > 0 then
			table.insert(elements, {
				label    = "Novac",
				value    = 'money',
				itemType = 'item_account',
				amount   = data.novac
			})
		end
		table.insert(elements, {label = _U('guns_label')})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = _U('search'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('zastitari:zapljeni9', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				menu.close()
				Wait(500)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_zastitari:getVehicleInfos', function(retrivedInfo)
		local elements = {{label = _U('plate', retrivedInfo.plate)}}

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_zastitari:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_zastitari:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_zastitari:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	PlayerData = ESX.GetPlayerData()
	local num = 0
	for k,v in ipairs(Config.AuthorizedWeapons[PlayerData.job.grade_name]) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i=1, #v.components do
				if v.components[i] then
					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

					if hasComponent then
						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_owned'))
					else
						if v.components[i] > 0 then
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_item', ESX.Math.GroupDigits(v.components[i])))
						else
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_free'))
						end
					end
					if v.components[i] ~= nil then
						table.insert(components, {
							label = label,
							componentLabel = component.label,
							hash = component.hash,
							name = component.name,
							price = v.components[i],
							hasComponent = hasComponent,
							componentNum = i
						})
					end
					num = i
				end
			end
		end

		if hasWeapon and v.components then
			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_owned'))
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_item', ESX.Math.GroupDigits(v.price)))
			else
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_free'))
			end
		end
		if v.components then
					table.insert(components, {
						label = "Kupi metke",
						componentLabel = "Metci",
						hash = "a",
						name = "metci",
						price = 0,
						hasComponent = false,
						componentNum = num
					})
		end

		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end
	table.insert(elements, {
		label = "Armor",
		name = "armor"
	})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title    = _U('armory_weapontitle'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.name == "armor" then
			SetPedArmour(PlayerPedId(), 100)
		else
			if data.current.hasWeapon then
				if #data.current.components > 0 then
					OpenWeaponComponentShop(data.current.components, data.current.name, menu)
				end
			else
				ESX.TriggerServerCallback('esx_zastitari:buyWeapon', function(bought)
					if bought then
						if data.current.price > 0 then
							ESX.ShowNotification(_U('armory_bought', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
						end

						menu.close()
						OpenBuyWeaponsMenu()
					else
						ESX.ShowNotification(_U('armory_money'))
					end
				end, data.current.name, 1)
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		title    = _U('armory_componenttitle'),
		align    = 'top-left',
		elements = components
	}, function(data, menu)
		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('esx_zastitari:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.componentLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					parentShop.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum, data.current.name)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_zastitari:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('police_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_zastitari:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_zastitari:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_zastitari:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_zastitari:VratiAnimv2')
AddEventHandler('esx_zastitari:VratiAnimv2', function()
	ESX.Streaming.RequestAnimDict("combat@drag_ped@", function()
		TaskPlayAnim(PlayerPedId(), "combat@drag_ped@", "injured_pickup_front_plyr", 8.0, -8, -1, 33, 0, 0, 0, 0)
		Wait(1000)
		--AnimationComplete(PlayerPedId(), "combat@drag_ped@", "injured_pickup_front_plyr", 0.85, 85)
		TaskPlayAnim(PlayerPedId(), "combat@drag_ped@", "injured_drag_plyr", 8.0, -8, -1, 33, 0, 0, 0, 0)
	end)
end)

RegisterNetEvent('esx_zastitari:VratiAnim')
AddEventHandler('esx_zastitari:VratiAnim', function(tip)
	if tip == 1 then
		ESX.Streaming.RequestAnimDict("mp_arrest_paired", function()
				TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 8.0, -8, 3750 , 2, 0, 0, 0, 0)
		end)
		Citizen.Wait(3760)
		ClearPedTasks(PlayerPedId())
		ClearPedSecondaryTask(PlayerPedId())
	else
		ESX.Streaming.RequestAnimDict("mp_arresting", function()
				TaskPlayAnim(PlayerPedId(), "mp_arresting", "a_uncuff", 8.0, -8,-1, 2, 0, 0, 0, 0)
		end)
		Citizen.Wait(5500)
		ClearPedTasks(PlayerPedId())
		ClearPedSecondaryTask(PlayerPedId())
	end
end)

AddEventHandler('esx_zastitari:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'VehicleDeleter' then
		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

		  local vehicle = GetVehiclePedIsIn(playerPed, false)

		  if DoesEntityExist(vehicle) then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_vehicle')
			CurrentActionData = {vehicle = vehicle}
		  end

		end
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_zastitari:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

RegisterNetEvent('esx_zastitari:oslobodiga')
AddEventHandler('esx_zastitari:oslobodiga', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
		Odradio = false
		Cufan = false
		ClearPedTasks(playerPed)
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
		IsHandcuffed = false
		TriggerServerEvent("policija:Cuffan", GetPlayerServerId(PlayerId()), false)
	end
end)

RegisterNetEvent('esx_zastitari:handcuff')
AddEventHandler('esx_zastitari:handcuff', function(id, tip)
	if tip == 1 then
		IsHandcuffed = true
	elseif tip == 2 then
		IsHandcuffed = true
	else
		IsHandcuffed = false
	end
	TriggerServerEvent("policija:Cuffan", GetPlayerServerId(PlayerId()), IsHandcuffed)
	local playerPed = PlayerPedId()
	local playerIdx = GetPlayerFromServerId(id)
	local ped = GetPlayerPed(playerIdx)
	Vezan = tip

	Citizen.CreateThread(function()
		if IsHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end
			if tip == 1 then
			TriggerServerEvent("esx_zastitari:SaljiAnim", id, 1)
			ESX.Streaming.RequestAnimDict("mp_arrest_paired", function()
				TaskPlayAnim(playerPed, "mp_arrest_paired", "crook_p2_back_right", 8.0, -8, 3750 , 2, 0, 0, 0, 0)
			end)
			Citizen.Wait(3000)
			TriggerServerEvent('InteractSounda_SV:PlayWithinDistance', 10, 'Cuff', 0.1)
			Odradio = true
			Citizen.Wait(3760)
			MosKrenit = true
			Cufan = true
			end
			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			if tip == 1 then
				FreezeEntityPosition(playerPed, true)
			elseif tip == 1 and Cufan == true then
				FreezeEntityPosition(playerPed, false)
			end
			DisplayRadar(false)

			if Config.EnableHandcuffTimer then
				if handcuffTimer.active then
					ESX.ClearTimeout(handcuffTimer.task)
				end

				StartHandcuffTimer()
			end
		else
			if Config.EnableHandcuffTimer and handcuffTimer.active then
				ESX.ClearTimeout(handcuffTimer.task)
			end
			TriggerServerEvent("esx_zastitari:SaljiAnim", id, 2)
			ESX.Streaming.RequestAnimDict("mp_arresting", function()
				TaskPlayAnim(playerPed, "mp_arresting", "b_uncuff", 8.0, -8,-1, 2, 0, 0, 0, 0)
			end)
			TriggerServerEvent('InteractSounda_SV:PlayWithinDistance', 10, 'Uncuff', 0.1)
			Citizen.Wait(5500)
			Odradio = false
			Cufan = false
			TriggerEvent("esx_cartel:oslobodiga")
			TriggerEvent("esx_grovejob:oslobodiga")
			TriggerEvent("esx_ballasjob:oslobodiga")
			TriggerEvent("esx_mafiajob:oslobodiga")
			TriggerEvent("esx_yakuza:oslobodiga")
			TriggerEvent("esx_sipa:unrestrain")
			ClearPedTasks(playerPed)
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)
end)

RegisterNetEvent('esx_zastitari:unrestrain')
AddEventHandler('esx_zastitari:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false
		TriggerServerEvent("policija:Cuffan", GetPlayerServerId(PlayerId()), false)

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)
				
RegisterNetEvent('esx_zastitari:undragga')
AddEventHandler('esx_zastitari:undragga', function()
	dragStatus.isDragged = false
	dragStatus.CopId = nil
end)

RegisterNetEvent('esx_zastitari:drag')
AddEventHandler('esx_zastitari:drag', function(copId)
	local playerPed = PlayerPedId()
	if not IsHandcuffed and not IsPedDeadOrDying(playerPed, true) then
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

local function AnimationComplete( player, animationD, animationN, time, cycles )
	local anim = true
	local count = 0
	repeat 
		if ( GetEntityAnimCurrentTime( player, animationD, animationN ) < time ) then
			Citizen.Wait(0)
		end
		count = count + 1
		anim = IsEntityPlayingAnim(player, animationD, animationN , 3)
	until (not anim or count == cycles)

	return true
end

function LoadAnimationDictionary(animationD) -- Simple way to load animation dictionaries to save lines.
	while(not HasAnimDictLoaded(animationD)) do
		RequestAnimDict(animationD)
		Citizen.Wait(1)
	end
end

Citizen.CreateThread(function()
	local playerPed
	local targetPed
	while true do
		Citizen.Wait(1)
		playerPed = PlayerPedId()
		targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
		if dragStatus.isDragged then
			if IsPedDeadOrDying(playerPed, true) and animation == false then
				TriggerEvent("pullout:PostaviGa", true)
				TriggerServerEvent("esx_zastitari:SaljiAnimv2", dragStatus.CopId)
				local loc = GetEntityCoords(playerPed, false)
				NetworkResurrectLocalPlayer(loc.x, loc.y, loc.z, true, true, false)
				--AttachEntityToEntity(playerPed, targetPed, 11816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				ESX.Streaming.RequestAnimDict("combat@drag_ped@", function()
					TaskPlayAnim(playerPed, "combat@drag_ped@", "injured_drag_ped", 8.0, -8, -1, 33, 0, 0, 0, 0)
				end)
				TriggerEvent("esx_ambulancejob:NemojOdbrojavat", 1)
				Mrtav = 1
				SetPlayerInvincible(playerPed, true)
				animation = true
				IsHandcuffed = true
				TriggerServerEvent("policija:Cuffan", GetPlayerServerId(PlayerId()), true)
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					animation = false
					dragStatus.isDragged = false
					dragStatus.CopId = nil
					DetachEntity(playerPed, true, false)
					ClearPedTasks(targetPed)
					ClearPedSecondaryTask(playerPed)
					ClearPedSecondaryTask(targetPed)
					DetachEntity(playerPed, 1, true)
					SetPlayerInvincible(playerPed, false)
					DetachEntity(targetPed, 1, true)
					SetPedCanRagdoll(playerPed, true)
					SetPedToRagdoll(playerPed, 1, 1, 0, false, false, false)
				end
				if IsPedDeadOrDying(targetPed, true) then
					animation = false
					dragStatus.isDragged = false
					dragStatus.CopId = nil
					DetachEntity(playerPed, true, false)
					ClearPedTasks(targetPed)
					ClearPedSecondaryTask(playerPed)
					SetPlayerInvincible(playerPed, false)
					DetachEntity(playerPed, 1, true)
					SetPedCanRagdoll(playerPed, true)
					SetPedToRagdoll(playerPed, 1, 1, 0, false, false, false)
				end
				Citizen.Wait(500)
			end
		else
			if animation == true then
				animation = false
				dragStatus.isDragged = false
				dragStatus.CopId = nil
				DetachEntity(playerPed, true, false)
				ClearPedSecondaryTask(playerPed)
				ClearPedSecondaryTask(targetPed)
				ClearPedTasks(targetPed)
				SetPlayerInvincible(playerPed, false)
				DetachEntity(playerPed, 1, true)
				DetachEntity(targetPed, 1, true)
				SetPedCanRagdoll(playerPed, true)
				SetPedToRagdoll(playerPed, 1, 1, 0, false, false, false)
				SetEntityHealth(playerPed, 0)
				--animation = false
				Citizen.Wait(500)
			else
				if dragStatus.CopId ~= nil then
					dragStatus.isDragged = false
					dragStatus.CopId = nil
					DetachEntity(playerPed, true, false)
					ClearPedSecondaryTask(playerPed)
					ClearPedSecondaryTask(targetPed)
					ClearPedTasks(targetPed)
					SetPlayerInvincible(playerPed, false)
				end
			end
		end
		if IsHandcuffed and not IsPedDeadOrDying(playerPed, true) then

			if dragStatus.isDragged then

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					--AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					AttachEntityToEntity(playerPed, targetPed, 11816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					dragStatus.isDragged = false
					dragStatus.CopId = nil
					DetachEntity(playerPed, true, false)
					ClearPedSecondaryTask(targetPed)
					ClearPedTasks(targetPed)
				end

				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					dragStatus.CopId = nil
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_zastitari:putInVehicle')
AddEventHandler('esx_zastitari:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				if animation == true then
					DetachEntity(playerPed, true, false)
					ClearPedSecondaryTask(playerPed)
					DetachEntity(playerPed, 1, true)
					SetPedCanRagdoll(playerPed, true)
					SetPedToRagdoll(playerPed, 1, 1, 0, false, false, false)
					animation = false
				end
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
				dragStatus.CopId = nil
			end
		end
	end
end)

RegisterNetEvent('esx_zastitari:Mrtav')
AddEventHandler('esx_zastitari:Mrtav', function(br)
	Mrtav = br
end)

RegisterNetEvent('esx_zastitari:OutVehicle')
AddEventHandler('esx_zastitari:OutVehicle', function(id)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(id))

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
	--Wait(200)
	if Mrtav == 1 then 
		dragStatus.isDragged = true
		dragStatus.CopId = id
		TriggerServerEvent("esx_zastitari:SaljiAnimv2", id)
		Wait(200)
		ESX.Streaming.RequestAnimDict("combat@drag_ped@", function()
			TaskPlayAnim(playerPed, "combat@drag_ped@", "injured_drag_ped", 8.0, -8, -1, 33, 0, 0, 0, 0)
		end)
		SetPlayerInvincible(playerPed, true)
		animation = true
		IsHandcuffed = true
		TriggerServerEvent("policija:Cuffan", GetPlayerServerId(PlayerId()), true)
		AttachEntityToEntity(playerPed, targetPed, 11816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	end
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsHandcuffed then
			local playerPed = PlayerPedId()
			if Vezan == 1 then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			end
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			if Vezan == 1 then
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D
			end

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 and MosKrenit then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()

	for k,v in pairs(Config.ZastitarStations) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.Blip.Naziv)
		EndTextCommandSetBlipName(blip)
	end

end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if PlayerData.job and PlayerData.job.name == 'zastitar' then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.ZastitarStations) do

				for i=1, #v.Cloakrooms, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Cloakrooms[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(20, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
					end
				end

				for i=1, #v.Armories, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Armories[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(21, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
					end
				end

				for i=1, #v.Vehicles, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner, true)

					if distance < Config.DrawDistance then
						DrawMarker(36, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
					end
				end
				
				for i=1, #v.VehicleDeleters, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.VehicleDeleters[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(1, v.VehicleDeleters[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end
				
					if distance < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'VehicleDeleter'
						currentPartNum = i
					end
				end

				if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(22, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_zastitari:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_zastitari:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_zastitari:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end

		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			
			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'zastitar' then

				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				elseif CurrentAction == 'menu_armory' then
					if Config.MaxInService == -1 then
						OpenArmoryMenu(CurrentActionData.station)
					elseif playerInService then
						OpenArmoryMenu(CurrentActionData.station)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'delete_vehicle' then
				  ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				  BVozilo = nil
				elseif CurrentAction == 'menu_vehicle_spawner' then
					if Config.MaxInService == -1 then
						OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
					elseif playerInService then
						OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', 'zastitar', function(data, menu)
						menu.close()

						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false }) -- disable washing money
				end

				CurrentAction = nil
			end
		end -- CurrentAction end

		if PlayerData.job and PlayerData.job.name == 'zastitar' then
			if IsControlJustReleased(0, 167) and not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'zastitar_actions') then
				if Config.MaxInService == -1 then
					OpenZastitarActionsMenu()
				elseif playerInService then
					OpenZastitarActionsMenu()
				else
					ESX.ShowNotification(_U('service_not'))
				end
			end
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_zastitari:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_zastitari:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_zastitari:unrestrain')

		if Config.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'zastitar')
		end

		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true

	handcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_zastitari:unrestrain')
		handcuffTimer.active = false
	end)
end
