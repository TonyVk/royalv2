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

local CurrentAction = nil
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local times 			= 0
local vozila = {}

local this_Garage = {}
for k,v in pairs(Config.Garages) do
	if v.Ime == "Garaza Centar" then
		this_Garage = v	
		break
	end
end	

-- Init ESX
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--- Blips Management
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    --PlayerData = xPlayer
    --TriggerServerEvent('esx_jobs:giveBackCautionInCaseOfDrop')
    refreshBlips()
end)

function refreshBlips()
	local zones = {}
	local blipInfo = {}	

	for zoneKey,zoneValues in pairs(Config.Garages)do
		if zoneValues.PrikaziBlip == 1 then
			local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
			SetBlipSprite (blip, Config.BlipInfos.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.2)
			SetBlipColour (blip, Config.BlipInfos.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(zoneValues.Ime)
			EndTextCommandSetBlipName(blip)
		
			local blip = AddBlipForCoord(zoneValues.MunicipalPoundPoint.Pos.x, zoneValues.MunicipalPoundPoint.Pos.y, zoneValues.MunicipalPoundPoint.Pos.z)
			SetBlipSprite (blip, Config.BlipPound.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.2)
			SetBlipColour (blip, Config.BlipPound.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('impound_yard'))
			EndTextCommandSetBlipName(blip)
		end
	end
end

function GetVehicle(ply,doesNotNeedToBeDriver)
	local found = false
	local ped = GetPlayerPed((ply and ply or -1))
	local veh = 0
	if IsPedInAnyVehicle(ped) then
		 veh = GetVehiclePedIsIn(ped, false)
	end
	if veh ~= 0 then
		if GetPedInVehicleSeat(veh, -1) == ped or doesNotNeedToBeDriver then
			found = true
		end
	end
	return found, veh, (veh ~= 0 and GetEntityModel(veh) or 0)
end

local lock_fancyteleport = false
local function FancyTeleport(ent,x,y,z,h,fOut,hold,fIn,resetCam)
    if not lock_fancyteleport then
        lock_fancyteleport = true
        Citizen.CreateThread(function() Citizen.Wait(15000) DoScreenFadeIn(500) end)
        Citizen.CreateThread(function()
            FreezeEntityPosition(ent, true)

            DoScreenFadeOut(fOut or 500)
            while IsScreenFadingOut() do Citizen.Wait(0) end

            SetEntityCoords(ent, x, y, z)
            if h then SetEntityHeading(ent, h) SetGameplayCamRelativeHeading(0) end
            if GetVehicle() then SetVehicleOnGroundProperly(ent) end
            FreezeEntityPosition(ent, false)

            Citizen.Wait(hold or 5000)

            DoScreenFadeIn(fIn or 500)
            while IsScreenFadingIn() do Citizen.Wait(0) end

            lock_fancyteleport = false
        end)
    end
end

local function ToCoord(t,withHeading)
    if withHeading == true then
        local h = (t[4]+0.0) or 0.0
        return (t[1]+0.0),(t[2]+0.0),(t[3]+0.0),h
    elseif withHeading == "only" then
        local h = (t[4]+0.0) or 0.0
        return h
    else
        return (t[1]+0.0),(t[2]+0.0),(t[3]+0.0)
    end
end

AddEventHandler('instance:loaded', function()
	TriggerEvent('instance:registerType', 'garaza', function(instance)
		
	end, function(instance)
		
	end)
end)

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance)
	if instance.type == 'garaza' then
		ESX.ShowNotification("Usli ste u svoju garazu!")
	end
end)

RegisterNetEvent('instance:onLeave')
AddEventHandler('instance:onLeave', function(instance)
	if instance.type == 'garaza' then
		ESX.ShowNotification("Izasli ste iz svoje garaze!")
	end
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	if instance.type == 'garaza' then
		TriggerEvent('instance:enter', instance)
	end
end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(instance, player)
	if player == instance.host then
		TriggerEvent('instance:leave')
	end
end)

--Menu function

function OpenMenuGarage(PointType)

	ESX.UI.Menu.CloseAll()

	local elements = {}

	
	if PointType == 'spawn' then
		local spawnInLocation = {228,-1003.7,-99,0}
		local x,y,z,h = ToCoord(spawnInLocation, true)
        FancyTeleport(GetPlayerPed(-1), x,y,z,h)
		local ime = "Garaza"..GetPlayerServerId(PlayerId())
		TriggerEvent('instance:create', 'garaza', {property = ime, owner = ESX.GetPlayerData().identifier})
        Citizen.Wait(1000)
		--table.insert(elements,{label = _U('list_vehicles'), value = 'list_vehicles'})
		local br = 1
		ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)
			for _,v in pairs(vehicles) do
				if br ~= 11 then
					if v.state then
						local hashVehicule = v.vehicle.model
						local xa,ya,za,ha = ToCoord(Config.carLocations[br], true)
						ESX.Streaming.RequestModel(hashVehicule)

						vozila[br] = CreateVehicle(hashVehicule, xa, ya, za+1, ha, false, false)

						SetEntityAsMissionEntity(vozila[br], true, false)
						SetVehicleHasBeenOwnedByPlayer(vozila[br], true)
						SetVehicleNeedsToBeHotwired(vozila[br], false)
						SetModelAsNoLongerNeeded(hashVehicule)
						RequestCollisionAtCoord(xa, ya, za)
						FreezeEntityPosition(vozila[br], true)
						ESX.Game.SetVehicleProperties(vozila[br], v.vehicle)
						SetVehRadioStation(vozila[br], "OFF")
						local plate = GetVehicleNumberPlateText(vozila[br])
						TriggerServerEvent("ls:mainCheck", plate, vozila[br], true)
						while not HasCollisionLoadedAroundEntity(vozila[br]) do
							RequestCollisionAtCoord(xa, ya, za)
							Citizen.Wait(0)
						end
						br = br+1
					end
				end
			end
		end)
		return
	end

	if PointType == 'delete' then
		table.insert(elements,{label = _U('stock_vehicle'), value = 'stock_vehicle'})
	end

	if PointType == 'pound' then
		table.insert(elements,{label = _U('return_vehicle', Config.Price), value = 'return_vehicle'})
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'garage_menu',
		{
			title    = _U('garage'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'list_vehicles') then
				ListVehiclesMenu()
			end
			if(data.current.value == 'stock_vehicle') then
				StockVehicleMenu()
			end
			if(data.current.value == 'return_vehicle') then
				ReturnVehicleMenu()
			end

			local playerPed = GetPlayerPed(-1)
			SpawnVehicle(data.current.value)

		end,
		function(data, menu)
			menu.close()
			
		end
	)	
end

Trim = function(word)
	if word ~= nil then
		return word:match("^%s*(.-)%s*$")
	else
		return nil
	end
end

-- View Vehicle Listings
function ListVehiclesMenu()
	local elements = {}

	ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)
 	for _,v in pairs(vehicles) do

        	local hashVehicule = v.vehicle.model
        	local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
        	local labelvehicle
        	if(v.state)then
        	labelvehicle = vehicleName _U('status_in_garage', GetLabelText(vehicleName))
        
        	else
        	labelvehicle = vehicleName _U('status_impounded', GetLabelText(vehicleName))
        	end    
			local pom = 0
			for i=1, 10, 1 do
				if vozila[i] ~= nil then
					local tabl = GetVehicleNumberPlateText(vozila[i])
					if Trim(tabl) == Trim(v.plate) then
						pom = 1
					end
				end
			end
			if pom == 0 then
				table.insert(elements, {label =labelvehicle , value = v})
			end
   	 end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_vehicle',
		{
			title    = _U('garage'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			if(data.current.value.state)then
				menu.close()
				SpawnVehicle(data.current.value.vehicle)
			else
					exports.pNotify:SendNotification({ text = _U('notif_car_impounded'), queue = "right", timeout = 3000, layout = "centerLeft" })
			end
		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_action'
		end
	)	
	end)
end

function reparation(prix,vehicle,vehicleProps)
	
	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = _U('reparation_yes', prix), value = 'yes'},
		{label = _U('reparation_no', prix), value = 'no'},
	}
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'delete_menu',
		{
			title    = _U('reparation'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'yes') then
				TriggerServerEvent('garaza:tuljanizirajhealth', prix)
				ranger(vehicle,vehicleProps)
			end
			if(data.current.value == 'no') then
				ESX.ShowNotification(_U('reparation_no_notif'))
			end

		end,
		function(data, menu)
			menu.close()
			
		end
	)	
end

RegisterNetEvent('eden_garage:deletevehicle_cl')
AddEventHandler('eden_garage:deletevehicle_cl', function(plate)
	local _plate = plate:gsub("^%s*(.-)%s*$", "%1")
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
		local vehicle =GetVehiclePedIsIn(playerPed,false)
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local usedPlate = vehicleProps.plate:gsub("^%s*(.-)%s*$", "%1")
		if usedPlate == _plate then
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)


function ranger(vehicle,vehicleProps)
	TriggerServerEvent('eden_garage:deletevehicle_sv', vehicleProps.plate)

	TriggerServerEvent('eden_garage:modifystate', vehicleProps, true)
	exports.pNotify:SendNotification({ text = _U('ranger'), queue = "right", timeout = 3000, layout = "centerLeft" })
end

-- Function that allows player to enter a vehicle
function StockVehicleMenu()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then

		local playerPed = GetPlayerPed(-1)
    	local coords    = GetEntityCoords(playerPed)
    	local vehicle =GetVehiclePedIsIn(playerPed,false)     
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local current 	    = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth  = GetVehicleEngineHealth(current)

		ESX.TriggerServerCallback('eden_garage:stockv',function(valid)

			if (valid) then
				ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicules)
					local plate = vehicleProps.plate:gsub("^%s*(.-)%s*$", "%1")
					local owned = false
					for _,v in pairs(vehicules) do
						if plate == v.plate then
							owned = true
							TriggerServerEvent('eden_garage:debug', "vehicle plate returned to the garage: "  .. vehicleProps.plate)
							TriggerServerEvent('eden_garage:logging',"vehicle returned to the garage: " .. engineHealth)
							if engineHealth < 1000 then
								local fraisRep= math.floor((1000 - engineHealth)*Config.RepairMultiplier)
								reparation(fraisRep,vehicle,vehicleProps)
							else
								ranger(vehicle,vehicleProps)
							end
						end
					end
					if owned == false then
						exports.pNotify:SendNotification({ text = _U('stockv_not_owned'), queue = "right", timeout = 3000, layout = "centerLeft" })
					end
				end)
			else
				exports.pNotify:SendNotification({ text = _U('stockv_not_owned'), queue = "right", timeout = 3000, layout = "centerLeft" })
			end
		end,vehicleProps)
	else		
		exports.pNotify:SendNotification({ text = _U('stockv_not_in_veh'), queue = "right", timeout = 3000, layout = "centerLeft" })
	end

end



--Function for spawning vehicle
function SpawnVehicle(vehicle)

	ESX.Game.SpawnVehicle(vehicle.model,{
		x=this_Garage.SpawnPoint.Pos.x ,
		y=this_Garage.SpawnPoint.Pos.y,
		z=this_Garage.SpawnPoint.Pos.z + 1											
		},this_Garage.SpawnPoint.Heading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		end)
		

	TriggerServerEvent('eden_garage:modifystate', vehicle, false)

end

--Function for spawning vehicle
function SpawnPoundedVehicle(vehicle)

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnMunicipalPoundPoint.Pos.x ,
		y = this_Garage.SpawnMunicipalPoundPoint.Pos.y,
		z = this_Garage.SpawnMunicipalPoundPoint.Pos.z + 1											
		},180, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		end)
	TriggerServerEvent('eden_garage:modifystate', vehicle, true)

	ESX.SetTimeout(10000, function()
		TriggerServerEvent('eden_garage:modifystate', vehicle, false)
	end)

end

-- Marker actions
AddEventHandler('eden_garage:hasEnteredMarker', function(zone)

	if zone == 'spawn' then
		CurrentAction     = 'spawn'
		CurrentActionMsg  = _U('spawn')
		CurrentActionData = {}
	end
	
	if zone == 'izadji' then
		CurrentAction     = 'izlaz'
		CurrentActionMsg  = "Pritisnite E da izadjete iz garaze"
		CurrentActionData = {}
	end
	
	if zone == 'druga' then
		CurrentAction     = 'drugi'
		CurrentActionMsg  = "Pritisnite E da pogledate listu ostalih vozila"
		CurrentActionData = {}
	end

	if zone == 'delete' then
		CurrentAction     = 'delete'
		CurrentActionMsg  = _U('delete')
		CurrentActionData = {}
	end
	
	if zone == 'pound' then
		CurrentAction     = 'pound_action_menu'
		CurrentActionMsg  = _U('pound_action_menu')
		CurrentActionData = {}
	end
end)

AddEventHandler('eden_garage:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

function ReturnVehicleMenu()

	ESX.TriggerServerCallback('eden_garage:getOutVehicles', function(vehicles)

		local elements = {}

		for _,v in pairs(vehicles) do

		local hashVehicule = v.model
		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
		local labelvehicle

		labelvehicle = vehicleName _U('impound_list', GetLabelText(vehicleName))
	
		table.insert(elements, {label =labelvehicle , value = v})
		
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'return_vehicle',
		{
			title    = _U('impound_yard'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
	
			ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
				if hasEnoughMoney then
					
					if times == 0 then
						TriggerServerEvent('garaza:tuljaniziraj')
						SpawnPoundedVehicle(data.current.value)
						times=times+1
						ESX.SetTimeout(15000, function()
						times=0
						end)
					elseif times > 0 then
						ESX.SetTimeout(15000, function()
						times=0
						end)
					end
				else
					exports.pNotify:SendNotification({ text = _U('impound_not_enough_money'), queue = "right", timeout = 3000, layout = "centerLeft" })
				end
			end)
		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_action'
		end)	
	end)
end

-- Display markers 
Citizen.CreateThread(function()
	while true do
		Wait(0)		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k,v in pairs(Config.Garages) do
			local ox,oy,oz = ToCoord(v.outMarker.Pos)		
			if(GetDistanceBetweenCoords(coords, ox,oy,oz, true) < Config.DrawDistance) then	
				if v == this_Garage then
					DrawMarker(1, ox,oy,oz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)	
				end
			end
			local oax,oay,oaz = ToCoord(v.SpawnVozila.Pos)		
			if(GetDistanceBetweenCoords(coords, oax,oay,oaz, true) < Config.DrawDistance) then	
				if v == this_Garage then
					DrawMarker(1, oax,oay,oaz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 30, 144, 255, 100, false, true, 2, false, false, false, false)	
				end
			end
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then		
				DrawMarker(v.SpawnPoint.Marker, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnPoint.Size.x, v.SpawnPoint.Size.y, v.SpawnPoint.Size.z, v.SpawnPoint.Color.r, v.SpawnPoint.Color.g, v.SpawnPoint.Color.b, 100, false, true, 2, false, false, false, false)	
				DrawMarker(v.DeletePoint.Marker, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.DeletePoint.Size.x, v.DeletePoint.Size.y, v.DeletePoint.Size.z, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, false, true, 2, false, false, false, false)	
			end
			if v.MunicipalPoundPoint ~= nil then
				if(GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.MunicipalPoundPoint.Marker, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.MunicipalPoundPoint.Size.x, v.MunicipalPoundPoint.Size.y, v.MunicipalPoundPoint.Size.z, v.MunicipalPoundPoint.Color.r, v.MunicipalPoundPoint.Color.g, v.MunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)	
					DrawMarker(v.SpawnMunicipalPoundPoint.Marker, v.SpawnMunicipalPoundPoint.Pos.x, v.SpawnMunicipalPoundPoint.Pos.y, v.SpawnMunicipalPoundPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnMunicipalPoundPoint.Size.x, v.SpawnMunicipalPoundPoint.Size.y, v.SpawnMunicipalPoundPoint.Size.z, v.SpawnMunicipalPoundPoint.Color.r, v.SpawnMunicipalPoundPoint.Color.g, v.SpawnMunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)
				end		
			end
		end	
	end
end)

-- Open/close menus
Citizen.CreateThread(function()
	local currentZone = 'garage'
	while true do

		Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		for _,v in pairs(Config.Garages) do
			if(GetDistanceBetweenCoords(coords, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, true) < v.Size.x) then
				if not IsPedInAnyVehicle(PlayerPedId(), false) then
					isInMarker  = true
					this_Garage = v
					currentZone = 'spawn'
				end
			end
			local ox,oy,oz = ToCoord(v.outMarker.Pos)	
			if(GetDistanceBetweenCoords(coords, ox,oy,oz, true) < 3.0) then
				isInMarker  = true
				--this_Garage = v
				currentZone = 'izadji'
			end
			local oax,oay,oaz = ToCoord(v.SpawnVozila.Pos)	
			if(GetDistanceBetweenCoords(coords, oax,oay,oaz, true) < 3.0) then
				isInMarker  = true
				--this_Garage = v
				currentZone = 'druga'
			end
			if(GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < v.Size.x) then
				if IsPedInAnyVehicle(PlayerPedId(),  false) then
					isInMarker  = true
					this_Garage = v
					currentZone = 'delete'
				end
			end
			if v.MunicipalPoundPoint ~= nil then
				if(GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < v.MunicipalPoundPoint.Size.x) then
					isInMarker  = true
					this_Garage = v
					currentZone = 'pound'
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('eden_garage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('eden_garage:hasExitedMarker', LastZone)
		end

	end
end)


-- Button press
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		if IsControlPressed(0,  Keys['W']) and (GetGameTimer() - GUI.Time) > 150 then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				local voz = GetVehiclePedIsIn(PlayerPedId(), false)
				local prop = ESX.Game.GetVehicleProperties(voz)
				for i=1, 10, 1 do
					if vozila[i] ~= nil then
						if vozila[i] == voz then
							SpawnVehicle(prop)
							break
						end
					end
				end
				for i=1, 10, 1 do
					if vozila[i] ~= nil then
						ESX.Game.DeleteVehicle(vozila[i])
						vozila[i] = nil
					end
				end
				TriggerEvent('instance:leave')
				TriggerEvent('instance:close')
				GUI.Time = GetGameTimer()
			end
		end
		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then

				if CurrentAction == 'pound_action_menu' then
					OpenMenuGarage('pound')
				end
				if CurrentAction == 'spawn' then
					OpenMenuGarage('spawn')
				end
				if CurrentAction == 'drugi' then
					ListVehiclesMenu()
				end
				if CurrentAction == 'izlaz' then
					--OpenMenuGarage('spawn')
					local spawnOutLocation = {this_Garage.SpawnPoint.Pos.x, this_Garage.SpawnPoint.Pos.y, this_Garage.SpawnPoint.Pos.z + 1}
					for i=1, 10, 1 do
						if vozila[i] ~= nil then
							ESX.Game.DeleteVehicle(vozila[i])
							vozila[i] = nil
						end
					end
					local x,y,z = ToCoord(spawnOutLocation,false)
					local h = this_Garage.SpawnPoint.Heading
					local ent = isInVehicle and veh or GetPlayerPed(-1)
					FancyTeleport(ent, x,y,z,h, 500,2000,500, true)
					TriggerEvent('instance:leave')
					TriggerEvent('instance:close')
				end
				if CurrentAction == 'delete' then
					OpenMenuGarage('delete')
				end


				CurrentAction = nil
				GUI.Time      = GetGameTimer()

			end
		end
	end
end)
-- Fin controle touche
