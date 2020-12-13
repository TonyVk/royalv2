local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["-"] = 84,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


ESX                           = nil
local GUI      = {}
local PlayerData                = {}
local lastVehicle = nil
local lastOpen = false
GUI.Time                      = 0
local vehiclePlate = {}
local arrayWeight = Config.localWeight
local CloseToVehicle = false
local entityWorld = nil
local globalplate = nil
local GPSID 	  = 1
local inTrunk = false

usingKeyPress = false -- Allow use of a key press combo (default Ctrl + E) to open trunk/hood from outside
togKey = 38 -- E

function getItemyWeight(item)
  local weight = 0
  local itemWeight = 0

  if item ~= nil then
	   itemWeight = Config.DefaultWeight
	   if arrayWeight[item] ~= nil then
	        itemWeight = arrayWeight[item]
	   end
	end
  return itemWeight
end

--- Code ---

function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterCommand("gepek", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(closecar), 1)
    local door = 5

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
        else	
            SetVehicleDoorOpen(veh, door, false, false)
        end
    else
        if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) and distanceToVeh <= 4.0 then
			local locked = GetVehicleDoorsLockedForPlayer(closecar, PlayerId())
            if GetVehicleDoorAngleRatio(closecar, door) > 0 then
                SetVehicleDoorShut(closecar, door, false)
            else
				if not locked then
					SetVehicleDoorOpen(closecar, door, false, false)
					TriggerEvent("gepeke:OtvoriGa", closecar)
				else
					ShowInfo("Vozilo je zakljucano.")
				end
            end
        else
            ShowInfo("Previse ste udaljeni od vozila.")
        end
    end
end)

RegisterCommand("hauba", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(closecar), 1)
    local door = 4

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
        else	
            SetVehicleDoorOpen(veh, door, false, false)
        end
    else
        if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) and distanceToVeh <= 4.0 then
			local locked = GetVehicleDoorsLockedForPlayer(closecar, PlayerId())
            if GetVehicleDoorAngleRatio(closecar, door) > 0 then
                SetVehicleDoorShut(closecar, door, false)
            else
				if not locked then
					SetVehicleDoorOpen(closecar, door, false, false)
				else
					ShowInfo("Vozilo je zakljucano.")
				end
            end
        else
            ShowInfo("Previse ste udaljeni od vozila.")
        end
    end
end)

RegisterCommand("vrata", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(closecar), 1)
    
    if args[1] == "1" then -- Front Left Door
        door = 0
    elseif args[1] == "2" then -- Front Right Door
        door = 1
    elseif args[1] == "3" then -- Back Left Door
        door = 2
    elseif args[1] == "4" then -- Back Right Door
        door = 3
    else
        door = nil
        ShowInfo("Usage: ~n~~b~/vrata [vrata]")
        ShowInfo("~y~Moguce vrata:")
        ShowInfo("1(Prednja ljeva), 2(Prednja desna)")
        ShowInfo("3(Straznja ljeva), 4(Straznja desna)")
    end

    if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if GetVehicleDoorAngleRatio(veh, door) > 0 then
                SetVehicleDoorShut(veh, door, false)
            else	
                SetVehicleDoorOpen(veh, door, false, false)
            end
        else
            if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) and distanceToVeh <= 4.0 then
				local locked = GetVehicleDoorsLockedForPlayer(closecar, PlayerId())
                if GetVehicleDoorAngleRatio(closecar, door) > 0 then
                    SetVehicleDoorShut(closecar, door, false)
                else
					if not locked then
						SetVehicleDoorOpen(closecar, door, false, false)
					else
						ShowInfo("Vozilo je zakljucano.")
					end
                end
            else
                ShowInfo("Previse ste udaljeni od vozila.")
            end
        end
    end
end)

RegisterCommand("prozor", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    
    if args[1] == "1" then -- Front Left Door
        door = 0
    elseif args[1] == "2" then -- Front Right Door
        door = 1
    elseif args[1] == "3" then -- Back Left Door
        door = 2
    elseif args[1] == "4" then -- Back Right Door
        door = 3
    else
        door = nil
        ShowInfo("Koristite: ~n~~b~/prozor [broj]")
        ShowInfo("~y~Moguci prozori:")
        ShowInfo("1(Prednji lijevi), 2(Prednji desni)")
        ShowInfo("3(Straznji lijevi), 4(Straznji desni)")
    end

    if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if IsVehicleWindowIntact(veh, door) then
				RollDownWindow(veh, door)
            else	
                RollUpWindow(veh, door)
            end
        end
    end
end)

if usingKeyPress then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsUsing(ped)
            local vehLast = GetPlayersLastVehicle()
            local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
            local door = 5
            if IsControlPressed(1, 224) and IsControlJustPressed(1, togKey) then
                if not IsPedInAnyVehicle(ped, false) then
                    if distanceToVeh < 4 then
                        if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                            SetVehicleDoorShut(vehLast, door, false)
                        else	
                            SetVehicleDoorOpen(vehLast, door, false, false)
                        end
                    else
                        ShowInfo("Previse ste udaljeni od vozila.")
                    end
                end
            end
        end
    end)
end

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
    TriggerServerEvent("gepeke:getOwnedVehicule")
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('gepeke:setOwnedVehicule')
AddEventHandler('gepeke:setOwnedVehicule', function(vehicle)
    vehiclePlate = vehicle
end)

RegisterNetEvent('gepeke:OtvoriGa')
AddEventHandler('gepeke:OtvoriGa', function(vehid)
    openmenuvehicle(vehid)
end)

RegisterNetEvent('gepeke:OdjebiGa')
AddEventHandler('gepeke:OdjebiGa', function(br)
  GPSID = br
end)

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function VehicleMaxSpeed(vehicle,weight,maxweight)
  local percent = (weight/maxweight)*100
  local hashk= GetEntityModel(vehicle)
  if percent > 80  then
    SetEntityMaxSpeed(vehFront,GetVehicleModelMaxSpeed(hashk)/1.4)
  elseif percent > 50 then
    SetEntityMaxSpeed(vehFront,GetVehicleModelMaxSpeed(hashk)/1.2)
  else
    SetEntityMaxSpeed(vehFront,GetVehicleModelMaxSpeed(hashk))
  end
end

function openmenuvehicle(vehid)
	if GPSID == 1 then
		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
		globalplate  = GetVehicleNumberPlateText(vehid)
		if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
			ESX.TriggerServerCallback('esx_truck:checkvehicle',function(valid)
				if (not valid) then
					-- CloseToVehicle = true
					-- TriggerServerEvent('gepeke:AddVehicleList', globalplate)
					local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
					local closecar = vehid
					if closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) then
						lastVehicle = closecar
						local model = GetDisplayNameFromVehicleModel(GetEntityModel(closecar))
						local locked = GetVehicleDoorsLockedForPlayer(closecar, PlayerId())
						local class = GetVehicleClass(closecar)
						ESX.UI.Menu.CloseAll()
						if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'inventory') then
						  --SetVehicleDoorShut(closecar, 5, false)
						else
							if not locked or class == 15 or class == 16 or class == 14 then
								SetVehicleDoorOpen(closecar, 5, false, false)
								CloseToVehicle = true
								TriggerServerEvent('gepeke:AddVehicleList', globalplate)
								TriggerServerEvent("gepeke:getInventory", GetVehicleNumberPlateText(closecar))
							else
								ESX.ShowNotification('Gepek je zakljucan!')
							end
						end
					else
						ESX.ShowNotification('Nema vozila u blizini!')
					end
					lastOpen = true
					GUI.Time  = GetGameTimer()
				else
					TriggerEvent('esx:showNotification', "Netko vec gleda gepek tog vozila!")
				end
			end, globalplate)
		end
	else
		ESX.ShowNotification("Ne mozete otvarati gepek dok radite posao!")
	end
end
local count = 0
-- Key controls
Citizen.CreateThread(function()
  while true do
    Wait(0)
	if CloseToVehicle then
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local vehicle = GetClosestVehicle(pos['x'], pos['y'], pos['z'], 2.0, 0, 70)
		if DoesEntityExist(vehicle) then
			CloseToVehicle = true
		else
			TriggerServerEvent('gepeke:RemoveVehicleList', globalplate)
			CloseToVehicle = false
			lastOpen = false
			ESX.UI.Menu.CloseAll()
			--SetVehicleDoorShut(lastVehicle, 5, false)
		end
	end
	if inTrunk then
        local vehicle = GetEntityAttachedTo(PlayerPedId())
        if DoesEntityExist(vehicle) or not IsPedDeadOrDying(PlayerPedId()) or not IsPedFatallyInjured(PlayerPedId()) then
            local coords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'boot'))
            SetEntityCollision(PlayerPedId(), false, false)

            if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
				SetEntityVisible(PlayerPedId(), false, false)
            else
                if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 3) then
                    loadDict('timetable@floyd@cryingonbed@base')
                    TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

                    SetEntityVisible(PlayerPedId(), true, false)
                end
            end
            if IsControlJustReleased(0, 38) and inTrunk then
                SetCarBootOpen(vehicle)
                SetEntityCollision(PlayerPedId(), true, true)
                Wait(750)
                inTrunk = false
                DetachEntity(PlayerPedId(), true, true)
                SetEntityVisible(PlayerPedId(), true, false)
                ClearPedTasks(PlayerPedId())
                SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
                Wait(250)
                SetVehicleDoorShut(vehicle, 5)
            end
        else
            SetEntityCollision(PlayerPedId(), true, true)
            DetachEntity(PlayerPedId(), true, true)
            SetEntityVisible(PlayerPedId(), true, false)
            ClearPedTasks(PlayerPedId())
            SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
        end
    end
    if lastOpen and IsControlPressed(0, Keys["BACKSPACE"]) and (GetGameTimer() - GUI.Time) > 150 then
	  CloseToVehicle = false
      lastOpen = false
      if lastVehicle > 0 then
      	--SetVehicleDoorShut(lastVehicle, 5, false)
		local lastvehicleplatetext = GetVehicleNumberPlateText(lastVehicle)
		TriggerServerEvent('gepeke:RemoveVehicleList', lastvehicleplatetext)
      	lastVehicle = 0
      end
      GUI.Time  = GetGameTimer()
    end
  end
end)

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

RegisterNetEvent('gepeke:getInventoryLoaded')
AddEventHandler('gepeke:getInventoryLoaded', function(inventory,weight)
	local elements = {}
	local vehFrontBack = VehicleInFront()
  TriggerServerEvent("gepeke:getOwnedVehicule")

	table.insert(elements, {
      label     = 'Ostavi u gepek',
      count     = 0,
      value     = 'deposit',
    })
	
	table.insert(elements, {
      label     = 'Sakrij se u gepek',
      count     = 0,
      value     = 'skrivanje',
    })

	if inventory ~= nil and #inventory > 0 then
		for i=1, #inventory, 1 do
		if inventory[i].type == 'item_standard' then
		      table.insert(elements, {
		        label     = inventory[i].label .. ' x' .. inventory[i].count,
		        count     = inventory[i].count,
		        value     = inventory[i].name,
				type	  = inventory[i].type
		      })			
			elseif inventory[i].type == 'item_weapon' then
			  table.insert(elements, {
				label     = inventory[i].label .. ' | metci: ' .. inventory[i].count,
				count     = inventory[i].count,
				value     = inventory[i].name,
				type	  = inventory[i].type
			  })	
			elseif inventory[i].type == 'item_account' then
			  table.insert(elements, {
				label     = inventory[i].label .. ' [ $' .. inventory[i].count..' ]',
				count     = inventory[i].count,
				value     = inventory[i].name,
				type	  = inventory[i].type
			  })	
			end
		end
	end
	
	

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'inventory_deposit',
	  {
	    title    = 'Sadrzaj gepeka',
	    align    = 'top-left',
	    elements = elements,
	  },
	  function(data, menu)
		if data.current.value == 'skrivanje' then
			local player = ESX.Game.GetClosestPlayer()
            local playerPed = GetPlayerPed(player)
			if DoesEntityExist(playerPed) then
				if not IsEntityAttached(playerPed) or GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(PlayerPedId()), true) >= 5.0 then
					menu.close()
					SetCarBootOpen(vehFrontBack)
					Wait(350)
					AttachEntityToEntity(PlayerPedId(), vehFrontBack, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)	
					loadDict('timetable@floyd@cryingonbed@base')
					TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
					Wait(50)
					inTrunk = true
					Wait(1500)
					SetVehicleDoorShut(vehFrontBack, 5)
					ESX.ShowNotification("Pritisnite E kako bih ste izasli iz gepeka!")
				else
					ESX.ShowNotification('Netko je vec u gepeku vozila!')
				end
			end
	  	elseif data.current.value == 'deposit' then
	  		local elem = {}
			-- xPlayer.getAccount('black_money').money
			-- table.insert(elements, {label = 'Argent sale: ' .. inventory.blackMoney, type = 'item_account', value = 'black_money'})
			
	  		PlayerData = ESX.GetPlayerData()
			for i=1, #PlayerData.accounts, 1 do
				if PlayerData.accounts[i].name == 'black_money' then
				  -- if PlayerData.accounts[i].money > 0 then
				    table.insert(elem, {
				      label     = PlayerData.accounts[i].label .. ' [ $'.. math.floor(PlayerData.accounts[i].money+0.5) ..' ]',
				      count     = PlayerData.accounts[i].money,
				      value     = PlayerData.accounts[i].name,
				      name      = PlayerData.accounts[i].label,
					  limit     = PlayerData.accounts[i].limit,
					  type		= 'item_account',
				    })
				  -- end
				end
			end
			
			for i=1, #PlayerData.inventory, 1 do
				if PlayerData.inventory[i].count > 0 then
				    table.insert(elem, {
				      label     = PlayerData.inventory[i].label .. ' x' .. PlayerData.inventory[i].count,
				      count     = PlayerData.inventory[i].count,
				      value     = PlayerData.inventory[i].name,
				      name      = PlayerData.inventory[i].label,
					  limit     = PlayerData.inventory[i].limit,
					  type		= 'item_standard',
				    })
				end
			end
			
		local playerPed  = GetPlayerPed(-1)
		local weaponList = ESX.GetWeaponList()

		if PlayerData.job.name ~= "police" and PlayerData.job.name ~= "sipa" and PlayerData.job.name ~= "zastitar" and PlayerData.job.name ~= "Gradonacelnik" then
			for i=1, #weaponList, 1 do

			  local weaponHash = GetHashKey(weaponList[i].name)
			  

			  if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
				table.insert(elem, {label = weaponList[i].label .. ' [' .. ammo .. ']',name = weaponList[i].label, type = 'item_weapon', value = weaponList[i].name, count = ammo})
			  end

			end
		end

			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'inventory_player',
			  {
			    title    = 'Sadrzaj kod vas',
			    align    = 'top-left',
			    elements = elem,
			  },function(data3, menu3)
			  if data3.current.type ~= "item_weapon" then
				ESX.UI.Menu.Open(
				  'dialog', GetCurrentResourceName(), 'inventory_item_count_give',
				  {
				    title = 'Kolicina'
				  },
				  function(data4, menu4)
            local quantity = tonumber(data4.value)
            local Itemweight =tonumber(getItemyWeight(data3.current.value)) * quantity
            local totalweight = tonumber(weight) + Itemweight
            vehFront = VehicleInFront()

            local typeVeh = GetVehicleClass(vehFront)

            if totalweight > Config.VehicleLimit[typeVeh] then
              max = true
            else
              max = false
            end

            ownedV = 0
            while vehiclePlate == '' do
              Wait(1000)
            end
            for i=1, #vehiclePlate do
              if vehiclePlate[i].plate == GetVehicleNumberPlateText(vehFront) then
                ownedV = 1
                break
              else
                ownedV = 0
              end
            end

            --fin test

            if quantity > 0 and quantity <= tonumber(data3.current.count) and vehFront > 0  then
              local MaxVh =(tonumber(Config.VehicleLimit[typeVeh])/1000)
              local Kgweight =  totalweight/1000
              if not max then
              	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  				    	local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
						local tablica = GetVehicleNumberPlateText(closecar)

              --  VehicleMaxSpeed(closecar,totalweight,Config.VehicleLimit[GetVehicleClass(closecar)])
				if tablica ~= nil then
					TriggerServerEvent('gepeke:addInventoryItem', GetVehicleClass(closecar), GetDisplayNameFromVehicleModel(GetEntityModel(closecar)), tablica, data3.current.value, quantity, data3.current.name, data3.current.type, ownedV)
					ESX.ShowNotification('Tezina gepeka : ~g~'.. Kgweight .. ' Kg / '..MaxVh..' Kg')
					Citizen.Wait(500)
					TriggerServerEvent("gepeke:getInventory", GetVehicleNumberPlateText(closecar))
				else
					ESX.ShowNotification('Dogodila se greska!')
				end
              else
                ESX.ShowNotification('Dosegli ste ogranicenje od ~r~ '..MaxVh..' Kg')
              end
			else
				ESX.ShowNotification('~r~ Krivi iznos')
			end

				    ESX.UI.Menu.CloseAll()
					local vehFront = VehicleInFront()
					if vehFront > 0 then
						ESX.SetTimeout(500, function()
							TriggerServerEvent("gepeke:getInventory", GetVehicleNumberPlateText(vehFront))
						end)
					else
					  --SetVehicleDoorShut(vehFrontBack, 5, false)
					end


				  end,
				  function(data4, menu4)
		            --SetVehicleDoorShut(vehFrontBack, 5, false)
				    ESX.UI.Menu.CloseAll()
					local lastvehicleplatetext = GetVehicleNumberPlateText(vehFrontBack)
					TriggerServerEvent('gepeke:RemoveVehicleList', lastvehicleplatetext)
				  end
				)
				else
					local Itemweight =tonumber(getItemyWeight(data3.current.value)) * data3.current.count
					local totalweight = tonumber(weight) + Itemweight
					vehFront = VehicleInFront()

					local typeVeh = GetVehicleClass(vehFront)

					if totalweight > Config.VehicleLimit[typeVeh] then
					  max = true
					else
					  max = false
					end

					ownedV = 0
					while vehiclePlate == '' do
					  Wait(1000)
					end
					for i=1, #vehiclePlate do
					  if vehiclePlate[i].plate == GetVehicleNumberPlateText(vehFront) then
						ownedV = 1
						break
					  else
						ownedV = 0
					  end
					end

					--fin test

					if vehFront > 3 then
					  local MaxVh =(tonumber(Config.VehicleLimit[typeVeh])/1000)
					  local Kgweight =  totalweight/1000
					  if not max then
						local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
						local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
						local tablica = GetVehicleNumberPlateText(closecar)
					  --  VehicleMaxSpeed(closecar,totalweight,Config.VehicleLimit[GetVehicleClass(closecar)])
						if tablica ~= nil then
							TriggerServerEvent('gepeke:addInventoryItem', GetVehicleClass(closecar), GetDisplayNameFromVehicleModel(GetEntityModel(closecar)), tablica, data3.current.value, data3.current.count, data3.current.name, data3.current.type, ownedV)
							ESX.ShowNotification('Tezina gepeka : ~g~'.. Kgweight .. ' Kg / '..MaxVh..' Kg')
							Citizen.Wait(500)
							TriggerServerEvent("gepeke:getInventory", GetVehicleNumberPlateText(closecar))
						else
							ESX.ShowNotification('Dogodila se greska!')
						end
					  else
						ESX.ShowNotification('Dosegli ste ogranicenje od ~r~ '..MaxVh..' Kg')
					  end
					else
						ESX.ShowNotification('~r~ Krivi iznos')
					end

				    ESX.UI.Menu.CloseAll()
					local vehFront = VehicleInFront()
					if vehFront > 0 then
						ESX.SetTimeout(500, function()
							TriggerServerEvent("gepeke:getInventory", GetVehicleNumberPlateText(vehFront))
						end)
					else
					  --SetVehicleDoorShut(vehFrontBack, 5, false)
					end
				end
			end,
				function(data, menu)
					menu.close()
				end)
		elseif data.current.type == 'cancel' then
			menu.close()
	  	else
			if data.current.type ~= "item_weapon" then
			ESX.UI.Menu.Open(
			  'dialog', GetCurrentResourceName(), 'inventory_item_count_give',
			  {
			    title = 'Kolicina'
			  },
			  function(data2, menu2)

			    local quantity = tonumber(data2.value)
				PlayerData = ESX.GetPlayerData()
			    vehFront = VehicleInFront()

				--test
				local Itemweight =tonumber(getItemyWeight(data.current.value)) * quantity
				local poid = weight - Itemweight


			
				for i=1, #PlayerData.inventory, 1 do
			
					if PlayerData.inventory[i].name == data.current.value then
						local torba = 0
						TriggerEvent('skinchanger:getSkin', function(skin)
							torba = skin['bags_1']
						end)
						if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
							if tonumber(PlayerData.inventory[i].limit)*2 < tonumber(PlayerData.inventory[i].count) + quantity and PlayerData.inventory[i].limit ~= -1 then
								max = true
							else
								max = false
							end
						else
							if tonumber(PlayerData.inventory[i].limit) < tonumber(PlayerData.inventory[i].count) + quantity and PlayerData.inventory[i].limit ~= -1 then
								max = true
							else
								max = false
							end
						end
					end
				end

				--fin test


				if quantity > 0 and quantity <= tonumber(data.current.count) and vehFront > 0 then
					if not max then
						local waitara = math.random(200,800)
						Wait(waitara)
						TriggerServerEvent('gepeke:removeInventoryItem', GetVehicleNumberPlateText(vehFront), data.current.value, data.current.type, quantity)
						local typeVeh = GetVehicleClass(vehFront)
						local MaxVh =(tonumber(Config.VehicleLimit[typeVeh])/1000)
						local Itemweight =tonumber(getItemyWeight(data.current.value)) * quantity
						local totalweight = tonumber(weight) - Itemweight
						local Kgweight =  totalweight/1000
						ESX.ShowNotification('Vasa tezina : ~g~'.. Kgweight .. ' Kg / '..MaxVh..' Kg')
					else
						ESX.ShowNotification('~r~ Vec nosite previse stvari!')
					end
			    else
					ESX.ShowNotification('~r~ Kriva kolicina')
			    end

			    ESX.UI.Menu.CloseAll()

	        	local vehFront = VehicleInFront()
	          	if vehFront > 0 then
	          		ESX.SetTimeout(500, function()
	              		TriggerServerEvent("gepeke:getInventory", GetVehicleNumberPlateText(vehFront))
	          		end)
	            else
	              --SetVehicleDoorShut(vehFrontBack, 5, false)
	            end
			  end,
			  function(data2, menu2)
                        --SetVehicleDoorShut(vehFrontBack, 5, false)
                        ESX.UI.Menu.CloseAll()
                        local lastvehicleplatetext = GetVehicleNumberPlateText(vehFrontBack)
                        TriggerServerEvent('gepeke:RemoveVehicleList', lastvehicleplatetext)
                    end
                )
				else
						local quantity = tonumber(data.current.count)
							PlayerData = ESX.GetPlayerData()
							vehFront = VehicleInFront()

						  --test
						  local Itemweight =tonumber(getItemyWeight(data.current.value)) * quantity
						  local poid = weight - Itemweight


							
						  for i=1, #PlayerData.inventory, 1 do
							
							if PlayerData.inventory[i].name == data.current.value then
							  if tonumber(PlayerData.inventory[i].limit) < tonumber(PlayerData.inventory[i].count) + quantity and PlayerData.inventory[i].limit ~= -1 then
								max = true
							  else
								max = false
							  end
							end
						  end

						  --fin test


							if quantity >= 0 and quantity <= tonumber(data.current.count) and vehFront > 0 then
							if not max then
								local waitara = math.random(200,800)
								Wait(waitara)
								TriggerServerEvent('gepeke:removeInventoryItem', GetVehicleNumberPlateText(vehFront), data.current.value, data.current.type, quantity)
								local typeVeh = GetVehicleClass(vehFront)
								local MaxVh =(tonumber(Config.VehicleLimit[typeVeh])/1000)
								local Itemweight =tonumber(getItemyWeight(data.current.value)) * quantity
								local totalweight = tonumber(weight) - Itemweight
								local Kgweight =  totalweight/1000
								ESX.ShowNotification('Vasa tezina : ~g~'.. Kgweight .. ' Kg / '..MaxVh..' Kg')
							else
							  ESX.ShowNotification('~r~ Vec nosite previse stvari!')
							end
								else
								  ESX.ShowNotification('~r~ Kriva kolicina')
								end

								ESX.UI.Menu.CloseAll()

								local vehFront = VehicleInFront()
								if vehFront > 0 then
									ESX.SetTimeout(500, function()
										TriggerServerEvent("gepeke:getInventory", GetVehicleNumberPlateText(vehFront))
									end)
								else
								  --SetVehicleDoorShut(vehFrontBack, 5, false)
								end
				end
            end
        end,
		function(data, menu)
			local vehFront = VehicleInFront()
			SetVehicleDoorShut(vehFront, 5, false)
			menu.close()
		end
	)
end)


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
