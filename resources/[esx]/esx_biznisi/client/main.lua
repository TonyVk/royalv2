ESX                             = nil

local Biznisi = {}
local Koord = {}
local MojBiznis = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	Wait(5000)
	ESX.TriggerServerCallback('biznis:DohvatiBiznise', function(biznis)
		Biznisi = biznis.biz
		Koord = biznis.kor
	end)
	Wait(2000)
	ESX.TriggerServerCallback('biznis:DohvatiVlasnika', function(ime)
		MojBiznis = ime
	end)
end)

RegisterCommand("napravibiznis", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] ~= nil and args[2] ~= nil then
				local ime = args[1]
				local naso = 0
				for i=1, #Biznisi, 1 do
					if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
						naso = 1
						break
					end
				end
				if naso == 0 then
					table.remove(args, 1)
					local label = table.concat(args, ' ')
					TriggerServerEvent("biznis:NapraviBiznis", ime, label)
				else
					ESX.ShowNotification("Biznis sa tim imenom vec postoji!")
				end
			else
				ESX.ShowNotification("[System] /napravibiznis [Ime][Label]")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

RegisterCommand("bizniskoord", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] ~= nil then
				local ime = args[1]
				local naso = 0
				for i=1, #Biznisi, 1 do
					if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
						naso = 1
						local koord = GetEntityCoords(PlayerPedId())
						TriggerServerEvent("biznis:PostaviKoord", ime, koord)
						break
					end
				end
				if naso == 0 then
					ESX.ShowNotification("Biznis sa tim imenom ne postoji!")
				end
			else
				ESX.ShowNotification("[System] /bizniskoord [Ime]")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

RegisterCommand("biznisvlasnik", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] ~= nil and args[2] ~= nil then
				local ime = args[1]
				local id = args[2]
				local naso = 0
				for i=1, #Biznisi, 1 do
					if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
						naso = 1
						TriggerServerEvent("biznis:PostaviVlasnika", ime, id)
						break
					end
				end
				if naso == 0 then
					ESX.ShowNotification("Biznis sa tim imenom ne postoji!")
				end
			else
				ESX.ShowNotification("[System] /biznisvlasnik [Ime][ID]")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

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

      if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_biznis' then
          OpenBiznisMenu(CurrentActionData.ime)
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

	local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)
	
	local isInMarker     = false
	local currentStation = nil
    local currentPart    = nil
    local currentPartNum = nil
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil then
			local x,y,z = table.unpack(Koord[i].Coord)
			if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
				if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
					waitara = 0
					naso = 1
					DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
				end
				if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
					isInMarker     = true
					currentStation = Koord[i].Biznis
					currentPart    = 'Biznis'
					currentPartNum = i
				end
			end
		end
	end
	local hasExited = false

	if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
		waitara = 0
		naso = 1
		if
			(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
			(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
		then
			TriggerEvent('biznis:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
		end

		HasAlreadyEnteredMarker = true
		LastStation             = currentStation
		LastPart                = currentPart
		LastPartNum             = currentPartNum

		TriggerEvent('biznis:hasEnteredMarker', currentStation, currentPart, currentPartNum)
	end

	if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
		waitara = 0
		naso = 1
		HasAlreadyEnteredMarker = false

		TriggerEvent('biznis:hasExitedMarker', LastStation, LastPart, LastPartNum)
	end
	if naso == 0 then
		waitara = 500
	end
  end
end)

function OpenBiznisMenu(ime)
  local elements = {}

  ESX.UI.Menu.CloseAll()
  
  local Kupljen = false
  for i=1, #Biznisi, 1 do
	if Biznisi[i] ~= nil and Biznisi[i].Ime == ime then
		if Biznisi[i].Kupljen == true then
			Kupljen = true
		end
		break
	end
  end
  if Kupljen == true then
	if MojBiznis == ime then
		table.insert(elements, {label = "Stanje sefa", value = 'stanje'})
		table.insert(elements, {label = "Uzmi iz sefa", value = 'sef'})
	else
		table.insert(elements, {label = "Ovaj biznis nije tvoj!", value = 'error'})
	end
  end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'biznis',
      {
        title    = "Biznis",
        align    = 'top-left',
        elements = elements,
        },

        function(data, menu)

      menu.close()

      if data.current.value == 'stanje' then
		
      end

      if data.current.value == 'sef' then
		
      end
	  
      CurrentAction     = 'menu_biznis'
      CurrentActionMsg  = "Pritisnite E da otvorite biznis menu!"
	  CurrentActionData = { ime = ime }

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_biznis'
      CurrentActionMsg  = "Pritisnite E da otvorite biznis menu!"
	  CurrentActionData = { ime = ime }
    end
  )

end

AddEventHandler('biznis:hasEnteredMarker', function(station, part, partNum)
  if part == 'Biznis' then
    CurrentAction     = 'menu_biznis'
    CurrentActionMsg  = "Pritisnite E da otvorite biznis menu!"
    CurrentActionData = { ime = station }
  end
end)

AddEventHandler('biznis:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('biznis:UpdateBiznise')
AddEventHandler('biznis:UpdateBiznise', function(biz)
	Biznisi = biz
end)

RegisterNetEvent('biznis:UpdateKoord')
AddEventHandler('biznis:UpdateKoord', function(kor)
	Koord = kor
end)