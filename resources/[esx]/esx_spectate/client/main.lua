ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Wait(0)
	end
end)

local InSpectatorMode	= false
local TargetSpectate	= nil
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			= -3.5;
--local cam 				= nil
local PlayerDate		= {}
local ShowInfos			= false
local group

function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
	-- convert degrees to radians
	local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0

	local pos = {
		x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
		y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
		z = entityPosition.z - radius * math.cos(azimuthAngleRad)
	}

	return pos
end

function spectate(target)
	ESX.TriggerServerCallback('esx_spectate:getPlayerData', function(player, kord, ped, id)
		if not InSpectatorMode then
			LastPosition = GetEntityCoords(GetPlayerPed(-1))
		else
			resetNormalCamera()
		end

		local playerPed = GetPlayerPed(-1)

		SetEntityCollision(playerPed, false, false)
		SetEntityVisible(playerPed, false)
		local xa, ya, za = table.unpack(kord)
		SetEntityCoords(playerPed, xa, ya, za - 5)
		SetPedMaxTimeUnderwater(playerPed, 2000.00)
		local komando = "/spec "..target
		TriggerServerEvent("DiscordBot:RegCmd", GetPlayerServerId(PlayerId()), komando)

		PlayerData = player
		if ShowInfos then
			SendNUIMessage({
				type = 'infos',
				data = PlayerData
			})	
		end

		--Citizen.CreateThread(function()
			--[[while not DoesCamExist(cam) do
			--if not DoesCamExist(cam) then
				Wait(0)
				cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			end

			SetCamCoord(cam,  xa, ya, za)
			SetCamActive(cam, true)
			RenderScriptCams(true, false, 0, true, true)]]
			local pedara = GetPlayerPed(GetPlayerFromServerId(id))
			while pedara == PlayerPedId() do
				Wait(100)
				pedara = GetPlayerPed(GetPlayerFromServerId(id))
			end
			RequestCollisionAtCoord(xa, ya, za)
			NetworkSetInSpectatorMode(true, pedara)

			TargetSpectate  = target
			InSpectatorMode = true
		--end)
	end, target)

end

function resetNormalCamera()
	InSpectatorMode = false
	local targetPlayerId = GetPlayerFromServerId(TargetSpectate)
	local ped = GetPlayerPed(targetPlayerId)
	NetworkSetInSpectatorMode(false, ped)
	TargetSpectate  = nil
	local playerPed = GetPlayerPed(-1)

	--SetCamActive(cam,  false)
	--RenderScriptCams(false, false, 0, true, true)

	SetEntityCollision(playerPed, true, true)
	SetEntityVisible(playerPed, true)
	RequestCollisionAtCoord(LastPosition.x, LastPosition.y, LastPosition.z)
	SetEntityCoords(playerPed, LastPosition.x, LastPosition.y, LastPosition.z)
	SetPedMaxTimeUnderwater(playerPed, 10.0)
end

function getPlayersList()
	ESX.TriggerServerCallback('esx_spectate:DohvatiIgrace', function(igraci)
		local data = {}
		for i,igrac in ipairs(igraci) do
			if tonumber(igrac.ID) ~= GetPlayerServerId(PlayerId()) then
				local _data = {
					id = igrac.ID,
					name = igrac.Ime
				}
				table.insert(data, _data)
			end
		end
		SendNUIMessage({
			type = 'show',
			data = data,
			player = data.id
		})
	end)
end

function OpenAdminActionMenu(player)

    ESX.TriggerServerCallback('esx_spectate:getOtherPlayerData', function(data)

      local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil
	  local Money		= 0
	  local Bank		= 0
	  local blackMoney	= 0
	  local Inventory	= nil
	  
    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

	  if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Posao : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Posao : ' .. data.job.label
      end

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Musko'
        else
          sex = 'Zensko'
        end
        sexLabel = 'Spol : ' .. sex
      else
        sexLabel = 'Spol : Nepoznat'
      end
	  
	  if data.money ~= nil then
		Money = data.money
		else
		Money = 'Nema podataka'
	  end

 	  if data.bank ~= nil then
		Bank = data.bank
		else
		Bank = 'Nema podataka'
	  end
	  
      if data.dob ~= nil then
        dobLabel = 'Dob : ' .. data.dob
      else
        dobLabel = 'Dob : Nepoznata'
      end

      if data.height ~= nil then
        heightLabel = 'Visina : ' .. data.height
      else
        heightLabel = 'Visina : Nepoznata'
      end

      if data.name ~= nil then
        idLabel = 'Steam ID : ' .. data.name
      else
        idLabel = 'Steam ID : Nepoznat'
      end
	  
      local elements = {
        {label = 'Ime: ' .. data.firstname .. " " .. data.lastname, value = nil},
        {label = 'Novac: '.. data.money, value = nil},
        {label = 'Banka: '.. data.bank, value = nil},
        {label = 'Prljav novac: '.. blackMoney, value = nil, itemType = 'item_account', amount = blackMoney},
		{label = jobLabel,    value = nil},
        {label = idLabel,     value = nil},
    }
	
    table.insert(elements, {label = '--- Inventory ---', value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = data.inventory[i].label .. ' x ' .. data.inventory[i].count,
          value          = nil,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end
	
    table.insert(elements, {label = '--- Oruzja ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = ESX.GetWeaponLabel(data.weapons[i].name),
        value          = nil,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end
      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Dozvole ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = 'Kontrola igraca',
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

--[[Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(1, 163) or IsDisabledControlJustReleased(1, 163) then
			ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
				if br == 1 then
					TriggerEvent('esx_spectate:spectate')
				end
			end)
		end
	end
end)]]

RegisterCommand('+spectate', function()
    ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			TriggerEvent('esx_spectate:spectate')
		end
	end)
end, false)
RegisterKeyMapping('+spectate', 'Spectate menu', 'keyboard', '9')

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	print('group setted ' .. g)
	group = g
end)

RegisterNetEvent('esx_spectate:spectate')
AddEventHandler('esx_spectate:spectate', function()

	SetNuiFocus(true, true)
	getPlayersList()
end)

RegisterNUICallback('select', function(data, cb)
	spectate(data.id)
	SetNuiFocus(false)
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

RegisterNUICallback('quit', function(data, cb)
	SetNuiFocus(false)
	resetNormalCamera()
end)

RegisterNUICallback('kick', function(data, cb)
	SetNuiFocus(false)
	TriggerServerEvent('esx_spectate:kick', data.id, data.reason)
	TriggerEvent('esx_spectate:spectate')
end)

Citizen.CreateThread(function()
  	while true do
		Wait(0)
		if InSpectatorMode then
			local targetPlayerId = GetPlayerFromServerId(TargetSpectate)
			local playerPed	  = GetPlayerPed(-1)
			local targetPed	  = GetPlayerPed(targetPlayerId)
			local coords	 = GetEntityCoords(targetPed)

			for i=0, 255, 1 do
				if i ~= PlayerId() then
					local otherPlayerPed = GetPlayerPed(i)
					SetEntityNoCollisionEntity(playerPed,  otherPlayerPed,  true)
					SetEntityVisible(playerPed, false)
				end
			end

			--[[if IsControlPressed(2, 241) then
				radius = radius + 2.0;
			end

			if IsControlPressed(2, 242) then
				radius = radius - 2.0;
			end

			if radius > -1 then
				radius = -1
			end

			local xMagnitude = GetDisabledControlNormal(0, 1);
			local yMagnitude = GetDisabledControlNormal(0, 2);

			polarAngleDeg = polarAngleDeg + xMagnitude * 10;

			if polarAngleDeg >= 360 then
				polarAngleDeg = 0
			end

			azimuthAngleDeg = azimuthAngleDeg + yMagnitude * 10;

			if azimuthAngleDeg >= 360 then
				azimuthAngleDeg = 0;
			end

			local nextCamLocation = polar3DToWorld3D(coords, radius, polarAngleDeg, azimuthAngleDeg)

			SetCamCoord(cam,  nextCamLocation.x,  nextCamLocation.y,  nextCamLocation.z)
			PointCamAtEntity(cam,  targetPed)]]
			SetEntityCoords(playerPed,  coords.x, coords.y, coords.z - 5)
			--NetworkSetTalkerProximity(19.0)

			if IsControlPressed(2, 47) then
				OpenAdminActionMenu(targetPlayerId)
			end
			
-- taken from Easy Admin (thx to Bluethefurry)  --
			local text = {}
			-- cheat checks
			local targetGod = GetPlayerInvincible(targetPlayerId)
			if targetGod then
				table.insert(text,"Godmode: ~r~Pronadjen~w~")
			else
				table.insert(text,"Godmode: ~g~Nije pronadjen~w~")
			end
			-- health info
			table.insert(text,"Health"..": "..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
			table.insert(text,"Armor"..": "..GetPedArmour(targetPed))

			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
-- end of taken from easyadmin -- 
		end
  	end
end)
