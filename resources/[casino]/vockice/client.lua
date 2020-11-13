ESX                             = nil
local PlayerData                = {}
local open 						= false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        TriggerEvent("esx:getSharedObject", function(xPlayer)
            ESX = xPlayer
        end)
    end

    while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end

    if ESX.IsPlayerLoaded() then
        PlayerData = ESX.GetPlayerData()
		TriggerServerEvent('vockice:getJoinChips')
    end
end)

Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local Igrac = GetPlayerPed(-1)
		local PozicijaIgraca = GetEntityCoords(Igrac)
		local Udaljenost = GetDistanceBetweenCoords(PozicijaIgraca, 1115.9971923828, 219.96560668945, -49.435085296631, true)
		if Udaljenost <= 10.0 then
			waitara = 0
			naso = 1
			local PozicijaTeksta = {
				["x"] = 1115.9971923828,
				["y"] = 219.96560668945,
				["z"] = -49.435085296631
			}
			ESX.Game.Utils.DrawText3D(PozicijaTeksta, "Pritisnite [~g~E~s~] da kupite zetone", 0.55, 1.5, "~b~CASHIER", 0.7)
			if IsControlJustReleased(0, 38) and Udaljenost <= 1.5 then
				OtvoriMenuBlagajna()
			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

function OtvoriMenuBlagajna()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'zetoni',
      {
          title    = 'Blagajna',
          align    = 'top-left',
          elements = {
			{label = "Kupite zetone", value = "buy"},
			{label = "Prodajte zetone", value = "sell"},
		  }
      },
	  function(data, menu)
		local akcja = data.current.value
		if akcja == 'buy' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_item_count', {
				title = 'Kolicina - $5/zeton'
			}, function(data2, menu2)

				local quantity = tonumber(data2.value)

				if quantity == nil then
					TriggerEvent("pNotify:SendNotification", {text = 'Kriva kolicina!', layout = "bottomCenter"})
				else
					TriggerServerEvent('vockice:KupZetony', quantity)
					menu2.close()
					menu.close()
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif akcja == 'sell' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
				title = 'Kolicina - $5/zeton'
			}, function(data2, menu2)

				local quantity = tonumber(data2.value)

				if quantity == nil then
					TriggerEvent("pNotify:SendNotification", {text = 'Kriva kolicina!', layout = "bottomCenter"})
				else
					TriggerServerEvent('vockice:WymienZetony', quantity)
					menu2.close()
					menu.close()
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		end
      end,
      function(data, menu)
		menu.close()
	  end
  )
end

local function drawHint(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNUICallback('wygrana', function(data)
	TriggerEvent('pNotify:SendNotification', {text = 'Dobili ste '..data.win..' zetona!', layout = "bottomCenter"})
end)

RegisterNUICallback('updateBets', function(data)
	TriggerServerEvent('vockice:updateCoins', data.bets)
end)

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end

RegisterNetEvent("vockice:UpdateSlots")
AddEventHandler("vockice:UpdateSlots", function(lei)
	SetNuiFocus(true, true)
	open = true
	PokreniGa()
	SendNUIMessage({
		showPacanele = "open",
		coinAmount = tonumber(lei)
	})
end)

RegisterNUICallback('exitWith', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	open = false
	TriggerServerEvent("vockice:PayOutRewards", math.floor(data.coinAmount))
end)

function PokreniGa()
	Citizen.CreateThread(function ()
		while open do
			Citizen.Wait(1)
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 24, true) -- Attack
			DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		end
	end)
end

Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.Sloty do
			local dis = GetDistanceBetweenCoords(coords, Config.Sloty[i].x, Config.Sloty[i].y, Config.Sloty[i].z, true)
			if dis <= 2.0 then
				naso = 1
				waitara = 0
				ESX.ShowHelpNotification('Pritisnite ~INPUT_PICKUP~ da pocnete igrati.')
				DrawMarker(1, Config.Sloty[i].x, Config.Sloty[i].y, Config.Sloty[i].z - 0.8, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 4.0, 4.0, 4.0, 70, 163, 76, 50, false, true, 2, nil, nil, false)
				if IsControlJustReleased(1, 38) then
					TriggerServerEvent('vockice:BetsAndMoney')
				end
			elseif dis <= 20.0 then
				naso = 1
				waitara = 0
				DrawMarker(1, Config.Sloty[i].x, Config.Sloty[i].y, Config.Sloty[i].z - 0.8, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 4.0, 4.0, 4.0, 158, 52, 235, 50, false, true, 2, nil, nil, false)
			end
		end
		for i=1, #Config.Ruletka do
			local dis = GetDistanceBetweenCoords(coords, Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z, true)
			if dis <= 2.0 then
				naso = 1
				waitara = 0
				ESX.ShowHelpNotification('Pritisnite ~INPUT_PICKUP~ da pocnete igrati rulet.')
				DrawMarker(1, Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z - 0.8, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 3.5, 3.5, 3.5, 70, 163, 76, 50, false, true, 2, nil, nil, false)
				if IsControlJustReleased(1, 38) then
					TriggerEvent('route68_ruletka:start')
				end
			elseif dis <= 20.0 then
				naso = 1
				waitara = 0
				DrawMarker(1, Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z - 0.8, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 3.5, 3.5, 3.5, 158, 52, 235, 50, false, true, 2, nil, nil, false)
			end
		end
		for i=1, #Config.Blackjack do
			local dis = GetDistanceBetweenCoords(coords, Config.Blackjack[i].x, Config.Blackjack[i].y, Config.Blackjack[i].z, true)
			if dis <= 2.0 then
				naso = 1
				waitara = 0
				ESX.ShowHelpNotification('Pritisnite ~INPUT_PICKUP~ da pocnete igrati blackjack.')
				DrawMarker(1, Config.Blackjack[i].x, Config.Blackjack[i].y, Config.Blackjack[i].z - 0.8, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 3.5, 3.5, 3.5, 70, 163, 76, 50, false, true, 2, nil, nil, false)
				if IsControlJustReleased(1, 38) then
					TriggerEvent('route68_blackjack:start')
				end
			elseif dis <= 20.0 then
				naso = 1
				waitara = 0
				DrawMarker(1, Config.Blackjack[i].x, Config.Blackjack[i].y, Config.Blackjack[i].z - 0.8, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 3.5, 3.5, 3.5, 158, 52, 235, 50, false, true, 2, nil, nil, false)
			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

key_to_teleport = 38

positions = {
    --[[
    {{Teleport1 X, Teleport1 Y, Teleport1 Z, Teleport1 Heading}, {Teleport2 X, Teleport 2Y, Teleport 2Z, Teleport2 Heading}, {Red, Green, Blue}, "Text for Teleport"}
    ]]
    {{925.0, 47.0, 80.00, 0}, {1090.00, 207.00, -49.9, 358},{36,237,157}, "Casino Diamond"},
    --{{1086.00, 215.0, -50.00, 312}, {980.00, 57.0, 115.0, 52},{255, 157, 0}, "Penthouse"},
}

-----------------------------------------------------------------------------
-------------------------DO NOT EDIT BELOW THIS LINE-------------------------
-----------------------------------------------------------------------------
Citizen.CreateThread(function ()
	local waitara = 1000
    while true do
        Citizen.Wait(waitara)
		local naso = 0
        local player = GetPlayerPed(-1)
        local playerLoc = GetEntityCoords(player)
		
        for _,location in ipairs(positions) do
            teleport_text = location[4]
            loc1 = {
                x=location[1][1],
                y=location[1][2],
                z=location[1][3],
                heading=location[1][4]
            }
            loc2 = {
                x=location[2][1],
                y=location[2][2],
                z=location[2][3],
                heading=location[2][4]
            }
            Red = location[3][1]
            Green = location[3][2]
            Blue = location[3][3]
			
			if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 30) then
				naso = 1
				waitara = 5
				DrawMarker(1, loc1.x, loc1.y, loc1.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 0)
			elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 30) then
				naso = 1
				waitara = 5
				DrawMarker(1, loc2.x, loc2.y, loc2.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 0)
			end

            if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 2) then 
                alert(teleport_text)
                
                if IsControlJustReleased(1, key_to_teleport) then
                    if IsPedInAnyVehicle(player, true) then
                        ESX.ShowNotification("Ne mozete uci u kasino sa vozilom!")
                    else
                        SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(player, loc2.heading)
                    end
                end

            elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 2) then
                alert(teleport_text)

                if IsControlJustReleased(1, key_to_teleport) then
                    if IsPedInAnyVehicle(player, true) then
                        ESX.ShowNotification("Ne mozete izaci iz kasina sa vozilom!")
                    else
                        SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(player, loc1.heading)
                    end
                end
            end            
        end
		if naso == 0 then
			waitara = 1000
		end
    end
end)

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

local coordonate = {
    {1149.4820556641, 269.10504150391, -51.840812683105, nil, 34.95, nil, 469792763},
    {1151.1827392578, 267.38442993164, -51.840812683105, nil, 220.19, nil, -1371020112},
	
    {1142.6461181641, 249.89082336426, -51.035724639893, nil, 327.13, nil, -245247470},
	{1149.8604736328, 248.96577453613, -51.03572845459, nil, 153.95, nil, 691061163},

	{1134.8520507813, 262.32635498047, -51.035724639893, nil, 121.48, nil, -886023758},
	{1128.4698486328, 266.32366943359, -51.035717010498, nil, 302.70, nil, -1922568579},
	
	{1117.7579345703, 220.05899047852, -49.435176849365, nil, 89.74, nil, 1535236204},
	
	{1143.89, 263.71, -51.85, nil, 45.5, nil, 999748158},
	{1145.77, 261.883, -51.85, nil, 222.5, nil, -254493138},
}

Citizen.CreateThread(function()

    for _,v in pairs(coordonate) do
      RequestModel(v[7])
      while not HasModelLoaded(v[7]) do
        Wait(1)
      end
  
      RequestAnimDict("mini@strip_club@idles@bouncer@base")
      while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
      end
      ped =  CreatePed(4, v[7],v[1],v[2],v[3]-1, 3374176, false, true)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	  SetModelAsNoLongerNeeded(v[7])
	end

end)