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

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0
local SpawnajDropMarker 		= false
local DropCoord
local PokupioCrate 				= false
local DostavaBlip 				= nil
local ZatrazioOruzje = {}
local ZOBr = 0
local BVozilo 					= nil

local parachute, crate, pickup, blipa, soundID
local requiredModels = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "prop_box_wood02a_pu"} -- parachute, pickup case, plane, pilot, crate

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  ProvjeriPosao()
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
end

function OpenBuyStvarMenu(station)
    local elements = {}
    table.insert(elements, {label = 'Laptop za hakiranje (25000$)', value = 'laptop'})
	table.insert(elements, {label = 'Termitna bomba (5000$)', value = 'termit'})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_stvari',
      {
        title    = "Kupovina stvari",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		ESX.TriggerServerCallback('kupistvari', function(hasEnoughMoney)
			  if hasEnoughMoney then
					ESX.ShowNotification("Uspjesno kupljeno!")
			  else
					ESX.ShowNotification("Nemate dovoljno novca ili vec imate dovoljno u inventoryju!")
			  end
		end, data.current.value)
      end,
      function(data, menu)
        menu.close()
		CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )
end

function OpenNewMenu(station)

  if Config.EnableArmoryManagement then
    local elements = {}
	table.insert(elements, {label = "Kupovina stvari", value = 'buy_stvar'})
	table.insert(elements, {label = 'Oruzarnica',  value = 'buy_oruzje'})


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if data.current.value == 'buy_stvar' then
          OpenBuyStvarMenu(station)
        end

        if data.current.value == 'buy_oruzje' then
          OpenArmoryMenu(CurrentActionData.station)
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )
  end

end

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 2,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function SetVehicleMaxMods2(vehicle)

  local props = {
    modEngine       = 2,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
	modArmor 		= 1,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function OpenCloakroomMenu()

  local elements = {
    {label = _U('citizen_wear'), value = 'citizen_wear'},
    {label = _U('mafia_wear'), value = 'mafia_wear'}
  }

  ESX.UI.Menu.CloseAll()

  if Config.EnableNonFreemodePeds then
      table.insert(elements, {label = _U('sheriff_wear'), value = 'sheriff_wear'})
    table.insert(elements, {label = _U('lieutenant_wear'), value = 'lieutenant_wear'})
    table.insert(elements, {label = _U('commandant_wear'), value = 'commandant_wear'})
  end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = _U('cloakroom'),
        align    = 'top-left',
        elements = elements,
        },

        function(data, menu)

      menu.close()

      --Taken from SuperCoolNinja
      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end)
      end

      if data.current.value == 'mafia_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

          if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
          else
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
          end

        end)

      end

      if data.current.value == 'mafia_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
			
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'lieutenant_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'commandant_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end


      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function OpenArmoryMenu(station)

  if Config.EnableArmoryManagement then

    local elements = {}
	if PlayerData.job.grade > 1 then
		table.insert(elements, {label = "Prodaj oruzje", value = 'sell_weapon'})
		table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
	end
	table.insert(elements, {label = _U('put_weapon'), value = 'put_weapon'})
	if PlayerData.job.grade > 1 then
		table.insert(elements, {label = 'Uzmi stvar',  value = 'get_stock'})
	end
	table.insert(elements, {label = 'Ostavi stvar',  value = 'put_stock'})

    if PlayerData.job.grade_name == 'vlasnik' then
      table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if data.current.value == 'sell_weapon' then
          OpenSellWeaponMenu(station)
        end

        if data.current.value == 'get_weapon' then
          OpenGetWeaponMenu()
        end

        if data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        end

        if data.current.value == 'buy_weapons' then
          OpenBuyWeaponsMenu(station)
        end

        if data.current.value == 'put_stock' then
              OpenPutStocksMenu()
            end

            if data.current.value == 'get_stock' then
              OpenGetStocksMenu()
            end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )

  else

    local elements = {}

    for i=1, #Config.CartelStations[station].AuthorizedWeapons, 1 do
      local weapon = Config.CartelStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
        local weapon = data.current.value
        TriggerServerEvent('esx_cartel:giveWeapon', weapon,  1000)
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}

      end
    )

  end

end

function OpenSellWeaponMenu(station)

  ESX.TriggerServerCallback('esx_cartel:getArmoryWeapons', function(weapons)

    local elements = {}
	local ammo = 0

	for i=1, #Config.CartelStations[station].AuthorizedWeapons, 1 do
		local weapon = Config.CartelStations[station].AuthorizedWeapons[i]
		for i=1, #weapons, 1 do
			if weapons[i].name == weapon.name then
				if weapons[i].count > 0 then
					table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name).."("..weapons[i].ammo..")", value = weapons[i].name, metci = weapons[i].ammo, kolicina = weapons[i].count})
				end
			end
		end
    end
	table.insert(elements, {label = "Zapocni prodaju", value = "sell_pocni"})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = "Prodaja oruzja",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()
		if data.current.value == 'sell_pocni' then
			TriggerEvent("prodajamb:PokreniProdaju", PlayerData.job.name)
		else
			if data.current.kolicina > 1 then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'kolicina', {
							title = "Kolicina oruzja"
						}, function(data2, menu2)
							local amount = tonumber(data2.value)

							if amount == nil then
								ESX.ShowNotification("Krivi iznos!")
							else
								if amount <= data.current.kolicina then
										menu2.close()
										menu.close()
										ESX.TriggerServerCallback('prodajamb:BrisiOruzja', function()
											OpenSellWeaponMenu(station)
										end, data.current.value, 250, amount, PlayerData.job.name)
								else
									menu2.close()
									ESX.ShowNotification("Nema toliko oruzja!")
								end
							end
						end, function(data2, menu2)
							menu2.close()
						end)
			else
				ESX.TriggerServerCallback('prodajamb:BrisiOruzja', function()
					OpenSellWeaponMenu(station)
				end, data.current.value, 250, 1, PlayerData.job.name)
			end
		end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenVehicleSpawnerMenu(station, partNum)

  local vehicles = Config.CartelStations[station].Vehicles

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
	    SetVehicleCustomPrimaryColour(vehicle, 242,164,12)
	    SetVehicleCustomSecondaryColour(vehicle, 242,164,12)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mafia', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {station = station, partNum = partNum}

        end
      )

    end, 'cartel')

  else

    local elements = {}

    for i=1, #Config.CartelStations[station].AuthorizedVehicles, 1 do
      local vehicle = Config.CartelStations[station].AuthorizedVehicles[i]
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
			if model == "gle63c" then
				SetVehicleMaxMods2(BVozilo)
			else
				SetVehicleMaxMods(BVozilo)
			end
            SetVehicleCustomPrimaryColour(BVozilo, 242,164,12)
			SetVehicleCustomSecondaryColour(BVozilo, 242,164,12)

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
		  SetVehicleCustomPrimaryColour(vehicle, 242,164,12)
	          SetVehicleCustomSecondaryColour(vehicle, 242,164,12)
                end)

              else
                ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'cartel')

          end

        else
          ESX.ShowNotification(_U('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {station = station, partNum = partNum}

      end
    )

  end

end

function OpenMafiaActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cartel_actions',
    {
      title    = 'Cartel',
      align    = 'top-left',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'},
        {label = _U('vehicle_interaction'), value = 'vehicle_interaction'}
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('citizen_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('id_card'),       value = 'identity_card'},
              {label = _U('search'),        value = 'body_search'},
              {label = _U('handcuff'),    value = 'handcuff'},
              {label = _U('drag'),      value = 'drag'},
              {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
              --{label = _U('fine'),            value = 'fine'}
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                OpenBodySearchMenu(player)
              end

              if data2.current.value == 'handcuff' then
                TriggerServerEvent('esx_cartel:handcuff', GetPlayerServerId(player))
              end

              if data2.current.value == 'drag' then
                TriggerServerEvent('esx_cartel:drag', GetPlayerServerId(player))
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('esx_cartel:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                  TriggerServerEvent('esx_cartel:OutVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'fine' then
                OpenFineMenu(player)
              end

            else
              ESX.ShowNotification(_U('no_players_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'vehicle_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'vehicle_interaction',
          {
            title    = _U('vehicle_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('vehicle_info'), value = 'vehicle_infos'},
              {label = _U('pick_lock'),    value = 'hijack_vehicle'},
            },
          },
          function(data2, menu2)

            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

            if DoesEntityExist(vehicle) then

              local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

              if data2.current.value == 'vehicle_infos' then
                OpenVehicleInfosMenu(vehicleData)
              end

              if data2.current.value == 'hijack_vehicle' then

                local playerPed = GetPlayerPed(-1)
                local coords    = GetEntityCoords(playerPed)

                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

                  if DoesEntityExist(vehicle) then

                    Citizen.CreateThread(function()

                      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

                      Wait(20000)

                      ClearPedTasksImmediately(playerPed)

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)

                      TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))

                    end)

                  end

                end

              end

            else
              ESX.ShowNotification(_U('no_vehicles_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_cartel:getOtherPlayerData', function(data)

      local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Male'
        else
          sex = 'Female'
        end
        sexLabel = 'Sex : ' .. sex
      else
        sexLabel = 'Sex : Unknown'
      end

      if data.dob ~= nil then
        dobLabel = 'DOB : ' .. data.dob
      else
        dobLabel = 'DOB : Unknown'
      end

      if data.height ~= nil then
        heightLabel = 'Height : ' .. data.height
      else
        heightLabel = 'Height : Unknown'
      end

      if data.name ~= nil then
        idLabel = 'ID : ' .. data.name
      else
        idLabel = 'ID : Unknown'
      end

      local elements = {
        {label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
        {label = sexLabel,    value = nil},
        {label = dobLabel,    value = nil},
        {label = heightLabel, value = nil},
        {label = jobLabel,    value = nil},
        {label = idLabel,     value = nil},
      }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  else

    ESX.TriggerServerCallback('esx_cartel:getOtherPlayerData', function(data)

      local jobLabel = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

        local elements = {
          {label = _U('name') .. data.name, value = nil},
          {label = jobLabel,              value = nil},
        }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  end

end

function OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('esx_cartel:getOtherPlayerData', function(data)

    local elements = {}

    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label          = _U('confiscate_dirty') .. blackMoney,
      value          = 'black_money',
      itemType       = 'item_account',
      amount         = blackMoney
    })

    table.insert(elements, {label = '--- Armes ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = _U('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = _U('search'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('cart:zapljeni6', GetPlayerServerId(player), itemType, itemName, amount)

          OpenBodySearchMenu(player)

        end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end

function OpenFineMenu(player)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fine',
    {
      title    = _U('fine'),
      align    = 'top-left',
      elements = {
        {label = _U('traffic_offense'),   value = 0},
        {label = _U('minor_offense'),     value = 1},
        {label = _U('average_offense'),   value = 2},
        {label = _U('major_offense'),     value = 3}
      },
    },
    function(data, menu)

      OpenFineCategoryMenu(player, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_cartel:getFineList', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' $' .. fines[i].amount,
        value     = fines[i].id,
        amount    = fines[i].amount,
        fineLabel = fines[i].label
      })
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fine_category',
      {
        title    = _U('fine'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local label  = data.current.fineLabel
        local amount = data.current.amount

        menu.close()

        if Config.EnablePlayerManagement then
          TriggerServerEvent('esx_billing:posaljiTuljana', GetPlayerServerId(player), 'society_cartel', _U('fine_total') .. label, amount)
        else
          TriggerServerEvent('esx_billing:posaljiTuljana', GetPlayerServerId(player), '', _U('fine_total') .. label, amount)
        end

        ESX.SetTimeout(300, function()
          OpenFineCategoryMenu(player, category)
        end)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, category)

end

function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('esx_cartel:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = _U('owner_unknown'), value = nil})
    else
      table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = _U('vehicle_info'),
        align    = 'top-left',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_cartel:getArmoryWeapons', function(weapons)

    local elements = {}
	local ammo = 0

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name).."("..weapons[i].ammo..")", value = weapons[i].name, metci = weapons[i].ammo, kolicina = weapons[i].count})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()
		if data.current.kolicina > 1 then
			if data.current.metci > 0 then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'kolicina', {
						title = "Kolicina metaka"
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification("Krivi iznos!")
						else
							if amount <= data.current.metci then
								if amount <= 250 then
									menu2.close()
									menu.close()
									ESX.TriggerServerCallback('esx_cartel:removeArmoryWeapon', function()
										OpenGetWeaponMenu()
									end, data.current.value, amount)
								else
									ESX.ShowNotification("Ne mozete vise od 250!")
								end
							else
								menu2.close()
								ESX.ShowNotification("Nema toliko metaka!")
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
			else
				ESX.TriggerServerCallback('esx_cartel:removeArmoryWeapon', function()
					OpenGetWeaponMenu()
				end, data.current.value, data.current.metci)
			end
		else
			ESX.TriggerServerCallback('esx_cartel:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value, data.current.metci)
		end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()
  local ammo = 0

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name, metci = ammo})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_cartel:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value, data.current.metci)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenBuyWeaponsMenu(station)

  ESX.TriggerServerCallback('esx_cartel:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #Config.CartelStations[station].AuthorizedWeapons, 1 do

      local weapon = Config.CartelStations[station].AuthorizedWeapons[i]
      local count  = 0

      for i=1, #weapons, 1 do
        if weapons[i].name == weapon.name then
          count = weapons[i].count
          break
        end
      end

      table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title    = _U('buy_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if ZatrazioOruzje[10] ~= nil or ZOBr >= 10 then
			ESX.ShowNotification("Vec imate naruceno 10 oruzja!")
		else
			ESX.TriggerServerCallback('cart:piku4', function(hasEnoughMoney)

			  if hasEnoughMoney then
					ZatrazioOruzje[ZOBr] = data.current.value
					TriggerServerEvent('esx_cartel:SpremiIme', ZatrazioOruzje[ZOBr], ZOBr)
					ZOBr = ZOBr+1
					if ZOBr == 1 then
						ESX.ShowNotification("Uzmite Big 4x4(Guardian) i odite na zeleni kofer oznacen na mapi kako bi ste pokupili paket")
						TriggerEvent("esx_cartel:crateDrop", data.current.value, 250, true, 400.0, {["x"] = 1886.2536621094 , ["y"] = 422.84442138672, ["z"] = 161.86665344238})
					end
			  else
					ESX.ShowNotification(_U('not_enough_money'))
			  end

			end, data.current.price)
		end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

RegisterNetEvent("esx_cartel:crateDrop")

AddEventHandler("esx_cartel:crateDrop", function(weapon, ammo, roofCheck, planeSpawnDistance, dropCoords) -- all of the error checking is done here before passing the parameters to the function itself
    Citizen.CreateThread(function()

        -- print("WEAPON: " .. string.lower(weapon))

        local ammo = (ammo and tonumber(ammo)) or 250
        if ammo > 9999 then
            ammo = 9999
        elseif ammo < -1 then
            ammo = -1
        end

        -- print("AMMO: " .. ammo)

        if dropCoords.x and dropCoords.y and dropCoords.z and tonumber(dropCoords.x) and tonumber(dropCoords.y) and tonumber(dropCoords.z) then
            -- print(("DROP COORDS: success, X = %.4f; Y = %.4f; Z = %.4f"):format(dropCoords.x, dropCoords.y, dropCoords.z))
        else
            dropCoords = {0.0, 0.0, 72.0}
            -- print("DROP COORDS: fail, defaulting to X = 0; Y = 0")
        end
        -- print("ROOFCHECK: false")
        CrateDrop(weapon, ammo, planeSpawnDistance, dropCoords)

    end)
end)

function CrateDrop(weapon, ammo, planeSpawnDistance, dropCoords)
    local crateSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) -- crate will drop to the exact position as planned, not at the plane's current position
	local id = GetPlayerServerId(PlayerId())
	TriggerServerEvent('esx_cartel:SaljiCrate', crate,  crateSpawn, PlayerData.job.name, id)
end

function CrateDrop2(parachute)
    --Citizen.CreateThread(function()
		crate = CreateObject(GetHashKey("prop_box_wood05a"), parachute, false, true, true) -- a breakable crate to be spawned directly under the plane, probably could be spawned closer to the plane
	
        soundID = GetSoundId() -- we need a sound ID for calling the native below, otherwise we won't be able to stop the sound later
        PlaySoundFromEntity(soundID, "Crate_Beeps", crate, "MP_CRATE_DROP_SOUNDS", true, 0) -- crate beep sound emitted from the pickup
		
        blipa = AddBlipForEntity(crate)
        SetBlipSprite(blipa, 408) -- 351 or 408 are both fine, 408 is just bigger
        SetBlipNameFromTextFile(blipa, "AMD_BLIPN")
        SetBlipScale(blipa, 0.7)
        SetBlipColour(blipa, 2)
        SetBlipAlpha(blipa, 255) -- make the blip fully visible
		
		DropCoord = vector3(GetEntityCoords(crate))
		SpawnajDropMarker = true

        while PokupioCrate == false do -- wait till the pickup gets picked up, then the script can continue
            Wait(0)
        end
		
		local id = GetPlayerServerId(PlayerId())
		TriggerServerEvent('esx_cartel:BrisiCrate', id)

        if DoesBlipExist(blipa) then -- remove the blip, should get removed when the pickup gets picked up anyway, but isn't a bad idea to make sure of it
            RemoveBlip(blipa)
        end

        StopSound(soundID) -- stop the crate beeping sound
        ReleaseSoundId(soundID) -- won't need this sound ID any longer

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

        RemoveWeaponAsset(GetHashKey("weapon_flare"))
    --end)
end

RegisterNetEvent('esx_cartel:VratiCrate')
AddEventHandler('esx_cartel:VratiCrate', function(cr, par, job, id)
	local ida = GetPlayerServerId(PlayerId())
	--if ida ~= id then
		if PlayerData.job.name == job then
			crate = cr
			parachute = par
			CrateDrop2(parachute)
		end
	--end
end)

RegisterNetEvent('esx_cartel:ObrisiCrate')
AddEventHandler('esx_cartel:ObrisiCrate', function(id)
	local ida = GetPlayerServerId(PlayerId())
	if ida ~= id then
		if DoesEntityExist(crate) then
			DeleteEntity(crate)
			StopSound(soundID)
			ReleaseSoundId(soundID)
			SpawnajDropMarker = false
		end
	end
end)

RegisterNetEvent('esx_cartel:ResetOruzja')
AddEventHandler('esx_cartel:ResetOruzja', function()
	if PlayerData.job.name == "cartel" then
		for i=0, 10, 1 do
			ZatrazioOruzje[i] = nil
		end
		ZOBr = 0
	end
end)

RegisterNetEvent('esx_cartel:VratiIme')
AddEventHandler('esx_cartel:VratiIme', function(ime, br)
	ZatrazioOruzje[br] = ime
	ZOBr = br+1
end)

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_cartel:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = "Uzmi stvari",
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()

              TriggerServerEvent('esx_cartel:getStockItem', itemName, count)
			  OpenGetStocksMenu()
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_cartel:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)
			if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
			else
				for i=1, #inventory.items, 1 do

				  local item = inventory.items[i]

				  if itemName == item.name then
					if item.count >= count then
						menu2.close()
						menu.close()
						TriggerServerEvent('esx_cartel:putStockItems', itemName, count)
						OpenPutStocksMenu()
					else
						ESX.ShowNotification("Nemate toliko "..itemName)
					end
				  end

				end
			end
          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- RegisterNetEvent('esx_phone:loaded')
-- AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

--   local specialContact = {
--     name       = 'cartel',
--     number     = 'cartel',
--     base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTV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'
--   }

--   TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

-- end)

AddEventHandler('esx_cartel:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end
  
  if part == 'Ulaz' then
    CurrentAction     = 'ulaz'
    CurrentActionMsg  = "Pritisnite E da udjete u kucu"
    CurrentActionData = {station = station}
  end
  
  if part == 'Izlaz' then
    CurrentAction     = 'izlaz'
    CurrentActionMsg  = "Pritisnite E da izadjete iz kuce"
    CurrentActionData = {station = station}
  end
  
  if part == 'Drop' then
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehara = GetVehiclePedIsUsing(PlayerPedId())
		local retval = GetDisplayNameFromVehicleModel(GetEntityModel(vehara))
		if retval == "GUARDIAN" then
			--DeleteEntity(crate)
			PokupioCrate = true
			SpawnajDropMarker = false
			DeleteEntity(crate)
			crate = CreateObject(GetHashKey("prop_box_wood05a"), crateSpawn, true, true, true) -- a breakable crate to be spawned directly under the plane, probably could be spawned closer to the plane
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			local ent = GetEntityBoneIndexByName(veh, "boot")
			AttachEntityToEntity(crate, GetVehiclePedIsIn(PlayerPedId(), false), ent, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1, 0, 0, 0, 2, 1)
			ESX.ShowNotification("Odvezite paket do oznacene lokacije!")
			for k,v in pairs(Config.CartelStations) do
				for i=1, #v.VehicleDeleters, 1 do
					DostavaBlip = AddBlipForCoord(v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z)
					SetBlipSprite(DostavaBlip, 1)
					SetBlipRoute(DostavaBlip,  true) -- waypoint to blip
				end
			end
		end
	end
  end

  if part == 'VehicleSpawner' then
	CurrentAction     = 'menu_vehicle_spawner'
	CurrentActionMsg  = _U('vehicle_spawner')
	CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'HelicopterSpawner' then

    local helicopters = Config.CartelStations[station].Helicopters

    if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then

      ESX.Game.SpawnVehicle('maverick', {
        x = helicopters[partNum].SpawnPoint.x,
        y = helicopters[partNum].SpawnPoint.y,
        z = helicopters[partNum].SpawnPoint.z
      }, helicopters[partNum].Heading, function(vehicle)
        SetVehicleModKit(vehicle, 0)
        SetVehicleLivery(vehicle, 0)
      end)

    end

  end

  if part == 'VehicleDeleter' then
	if PokupioCrate == true then
		local vehara = GetVehiclePedIsUsing(PlayerPedId())
		local retval = GetDisplayNameFromVehicleModel(GetEntityModel(vehara))
		if retval == "GUARDIAN" then
			PokupioCrate = false
			DeleteEntity(crate)
			RemoveBlip(DostavaBlip)
			ESX.ShowNotification("Oruzje vam je dodano u sef mafije!")
			for i=0, 10, 1 do
				if ZatrazioOruzje[i] ~= nil then
					ESX.TriggerServerCallback('esx_cartel:addArmoryWeapon', function()
						  --OpenBuyWeaponsMenu(station)
					end, ZatrazioOruzje[i], 300)
					ZatrazioOruzje[i] = nil
				end
			end
			TriggerServerEvent('esx_cartel:ResetirajOruzje')
			ZOBr = 0
		else
			ESX.ShowNotification("Morate biti u Guardianu!")
		end
	else
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
	end
  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_cartel:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_cartel:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'cartel' and not IsPedInAnyVehicle(playerPed, false) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('remove_object')
    CurrentActionData = {entity = entity}
  end

  if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed)

      for i=0, 7, 1 do
        SetVehicleTyreBurst(vehicle,  i,  true,  1000)
      end

    end

  end

end)

AddEventHandler('esx_cartel:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

RegisterNetEvent('esx_cartel:oslobodiga')
AddEventHandler('esx_cartel:oslobodiga', function()
	local playerPed = GetPlayerPed(-1)
    if IsHandcuffed then
	  IsHandcuffed = false
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)
    end
end)

RegisterNetEvent('esx_cartel:handcuff')
AddEventHandler('esx_cartel:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)

    else
	  TriggerEvent("esx_grovejob:oslobodiga")
	  TriggerEvent("esx_ballasjob:oslobodiga")
	  TriggerEvent("esx_yakuza:oslobodiga")
	  TriggerEvent("esx_mafiajob:oslobodiga")
	  TriggerEvent("esx_policejob:oslobodiga")
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)

RegisterNetEvent('esx_cartel:drag')
AddEventHandler('esx_cartel:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

RegisterNetEvent('esx_cartel:putInVehicle')
AddEventHandler('esx_cartel:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('esx_cartel:OutVehicle')
AddEventHandler('esx_cartel:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

-- Create blips
Citizen.CreateThread(function()

  for k,v in pairs(Config.CartelStations) do

    local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

    SetBlipSprite (blip, v.Blip.Sprite)
    SetBlipDisplay(blip, v.Blip.Display)
    SetBlipScale  (blip, v.Blip.Scale)
    SetBlipColour (blip, v.Blip.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blip)

  end

end)

-- Display markers
Citizen.CreateThread(function()
  while true do

    Wait(0)
	if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
	
	if IsHandcuffed then
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
	  DisableControlAction(0, 167, true) -- f6
    end
	
	if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'cartel' and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          OpenNewMenu(CurrentActionData.station)
        end
		
		if CurrentAction == 'ulaz' then
			for k,v in pairs(Config.CartelStations) do
				for i=1, #v.Izlazi, 1 do
					SetEntityCoords(GetPlayerPed(-1), v.Izlazi[i].x, v.Izlazi[i].y, v.Izlazi[i].z, 1, 0, 0, 1)
					SetEntityHeading(GetPlayerPed(-1), v.Izlazi[i].h)
				end
			end
        end
		
		if CurrentAction == 'izlaz' then
			for k,v in pairs(Config.CartelStations) do
				for i=1, #v.Ulazi, 1 do
					SetEntityCoords(GetPlayerPed(-1), v.Ulazi[i].x, v.Ulazi[i].y, v.Ulazi[i].z, 1, 0, 0, 1)
					SetEntityHeading(GetPlayerPed(-1), v.Ulazi[i].h)
				end
			end
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'cartel', vehicleProps)

          else

            if
              GetEntityModel(vehicle) == GetHashKey('schafter3')  or
              GetEntityModel(vehicle) == GetHashKey('kuruma2') or
              GetEntityModel(vehicle) == GetHashKey('sandking') or
              GetEntityModel(vehicle) == GetHashKey('mule3') or
              GetEntityModel(vehicle) == GetHashKey('guardian') or
              GetEntityModel(vehicle) == GetHashKey('burrito3') or
              GetEntityModel(vehicle) == GetHashKey('mesa')
            then
              TriggerServerEvent('esx_service:disableService', 'cartel')
            end

          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
		  BVozilo = nil
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'cartel', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end)

        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

   if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'cartel' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'cartel_actions') and (GetGameTimer() - GUI.Time) > 150 then
     OpenMafiaActionsMenu()
     GUI.Time = GetGameTimer()
    end
	
    if PlayerData.job ~= nil and PlayerData.job.name == 'cartel' then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)
	  local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.CartelStations) do
		if SpawnajDropMarker == true then
			if GetDistanceBetweenCoords(coords,  DropCoord.x,  DropCoord.y+2,  DropCoord.z,  true) < Config.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'Drop'
				currentPartNum = 1
			  end
		end
		
        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end
		
		for i=1, #v.Ulazi, 1 do
          if GetDistanceBetweenCoords(coords,  v.Ulazi[i].x,  v.Ulazi[i].y,  v.Ulazi[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Ulaz'
            currentPartNum = i
          end
        end
		
		for i=1, #v.Izlazi, 1 do
          if GetDistanceBetweenCoords(coords,  v.Izlazi[i].x,  v.Izlazi[i].y,  v.Izlazi[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Izlaz'
            currentPartNum = i
          end
        end

        for i=1, #v.Vehicles, 1 do

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.Helicopters, 1 do

          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'HelicopterSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'HelicopterSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleDeleter'
            currentPartNum = i
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'cartel' and (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'vlasnik') then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
              isInMarker     = true
              currentStation = k
              currentPart    = 'BossActions'
              currentPartNum = i
            end
          end

        end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_cartel:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_cartel:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_cartel:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

      for k,v in pairs(Config.CartelStations) do

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Vehicles, 1 do
          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end
		
		for i=1, #v.Ulazi, 1 do
          if GetDistanceBetweenCoords(coords,  v.Ulazi[i].x,  v.Ulazi[i].y,  v.Ulazi[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Ulazi[i].x, v.Ulazi[i].y, v.Ulazi[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end
		
		for i=1, #v.Izlazi, 1 do
          if GetDistanceBetweenCoords(coords,  v.Izlazi[i].x,  v.Izlazi[i].y,  v.Izlazi[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Izlazi[i].x, v.Izlazi[i].y, v.Izlazi[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end
		
        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end
		
		if SpawnajDropMarker == true then
			if GetDistanceBetweenCoords(coords,  DropCoord.x,  DropCoord.y+2,  DropCoord.z,  true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, DropCoord.x,  DropCoord.y+2,  DropCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'cartel' and (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'vlasnik') then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
              DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end

  end
end)

---------------------------------------------------------------------------------------------------------
--NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:openMenuMafia')
AddEventHandler('NB:openMenuMafia', function()
	OpenMafiaActionsMenu()
end)
