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

local kodaQTE       			= 0
ESX 			    			= nil
local koda_poochQTE 			= 0
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_biser:hasEnteredMarker', function(zone)
	if myJob == 'police' or myJob == 'ambulance' or myJob == 'sipa' then
		return
	end

	ESX.UI.Menu.CloseAll()
	
	if zone == 'BiserSkupljanje' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('carrega_para_apanhares_frutos')
		CurrentActionData = {}
	elseif zone == 'Prerada' then
		if kodaQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('carrega_para_colocares_frutos_dentro_dos_sacos')
			CurrentActionData = {}
		end
	elseif zone == 'Biser' then
		if koda_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('carrega_para_venderes_os_sacos')
			CurrentActionData = {}
		end
	end
end)

AddEventHandler('esx_biser:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()

	if zone == 'BiserSkupljanje' then
		TriggerServerEvent('esx_biser:stopHarvestKoda')
	elseif zone == 'Prerada' then
	TriggerServerEvent('esx_biser:stopTransformKoda')
	elseif zone == 'Biser' then
		TriggerServerEvent('esx_biser:stopSellKoda')
	end
end)

-- marker
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local nasosta = 0
		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if #(coords-v.Pos) < Config.DrawDistance then
				waitara = 0
				nasosta = 1
				DrawMarker(Config.MarkerType, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
		
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(#(coords-v.Pos) < Config.ZoneSize.x / 2) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerServerEvent('esx_biser:GetUserInventory', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_biser:hasExitedMarker', lastZone)
		end
		if nasosta == 0 then
			waitara = 500
		end
	end
end)

if Config.ShowBlips then
	-- oznaczenie
	Citizen.CreateThread(function()
		for k,v in pairs(Config.Zones) do
			local blip = AddBlipForCoord(v.Pos)

			SetBlipSprite (blip, v.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.9)
			SetBlipColour (blip, v.color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
		end
	end)
end


-- itemsy
RegisterNetEvent('esx_biser:ReturnInventory')
AddEventHandler('esx_biser:ReturnInventory', function(kodaNbr, kodapNbr, jobName, currentZone)
	print(kodaNbr)
	kodaQTE			= kodaNbr
	koda_poochQTE	= kodapNbr
	myJob			= jobName
	TriggerEvent('esx_biser:hasEnteredMarker', currentZone)
end)

-- klawisze
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) and IsPedOnFoot(PlayerPedId()) then
				local coords = GetEntityCoords(PlayerPedId())
				if CurrentAction == 'BiserSkupljanje' then
					for k,v in pairs(Config.Zones) do
						if k == "BiserSkupljanje" then
							if(#(coords-v.Pos) < Config.ZoneSize.x / 2) then
								local torba = 0
								TriggerEvent('skinchanger:getSkin', function(skin)
									torba = skin['bags_1']
								end)
								if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
									TriggerServerEvent('esx_biser:startHarvestKoda', true)
								else
									TriggerServerEvent('esx_biser:startHarvestKoda', false)
								end
							else
								TriggerEvent('esx_biser:hasExitedMarker', lastZone)
							end
							break
						end
					end
				elseif CurrentAction == 'Prerada' then
					local torba = 0
					TriggerEvent('skinchanger:getSkin', function(skin)
						torba = skin['bags_1']
					end)
					if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
						TriggerServerEvent('esx_biser:startTransformKoda', true)
					else
						TriggerServerEvent('esx_biser:startTransformKoda', false)
					end
				elseif CurrentAction == 'Biser' then
					for k,v in pairs(Config.Zones) do
						if k == "Biser" then
							if(#(coords-v.Pos) < Config.ZoneSize.x / 2) then
								TriggerServerEvent('esx_biser:startSellKoda')
							else
								TriggerEvent('esx_biser:hasExitedMarker', lastZone)
							end
							break
						end
					end
				end
				
				CurrentAction = nil
			end
		end
	end
end)
