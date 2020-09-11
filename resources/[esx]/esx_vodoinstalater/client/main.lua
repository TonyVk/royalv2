ESX = nil
local Radis = false
local Vozilo = nil
local TrajeIntervencija = false
local Blipara = nil
local NoviObj = nil
local NoviObj2 = nil
local NoviObj3 = nil
local NoviObj4 = nil
local NoviObj5 = nil
local Lokacija = nil
local SpawnMarker = false

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
--------------------------------------------------------------------------------
-- NE RIEN MODIFIER
--------------------------------------------------------------------------------
local isInService = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil

local plaquevehicule = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
--------------------------------------------------------------------------------
function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
end
-- MENUS
function MenuCloakRoom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			elements = {
				{label = _U('job_wear'), value = 'job_wear'},
				{label = _U('citizen_wear'), value = 'citizen_wear'}
			}
		},
		function(data, menu)
			if data.current.value == 'citizen_wear' then
				isInService = false
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	    			TriggerEvent('skinchanger:loadSkin', skin)
				end)
				MakniKvar()
			end
			if data.current.value == 'job_wear' then
				isInService = true
				setUniform(PlayerPedId())
				--[[ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    			if skin.sex == 0 then
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end
				end)]]
				menu.close()
				if TrajeIntervencija == false then
					Wait(20000)
					SpawnajKvar()
				end
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function MenuVehicleSpawner()
	local elements = {}

	for i=1, #Config.Trucks, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Trucks[i])), value = Config.Trucks[i]})
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "utillitruck3" then
			if Vozilo ~= nil then
				ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
			end
			ESX.Streaming.RequestModel(data.current.value)
			Vozilo = CreateVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 178.63403320313, true, false)
			SetModelAsNoLongerNeeded(GetHashKey(data.current.value))
			platenum = math.random(10000, 99999)
			SetVehicleNumberPlateText(Vozilo, "SIK"..platenum)             
			plaquevehicule = "SIK"..platenum			
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vozilo, -1)
			ESX.ShowNotification("Pricekajte dojavu o kvaru!")
			Radis = true
		end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function setUniform(playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms.EUP == false or Config.Uniforms.EUP == nil then
				if Config.Uniforms["uniforma"].male then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms["uniforma"].male)
				else
					ESX.ShowNotification("Nema postavljene uniforme!")
				end
			else
				local jobic = "EUPuniforma"
				local outfit = Config.Uniforms[jobic].male
				local ped = playerPed

				RequestModel(outfit.ped)

				while not HasModelLoaded(outfit.ped) do
					Wait(0)
				end

				if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
					SetPlayerModel(PlayerId(), outfit.ped)
				end

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
			end
			
		else
			if Config.Uniforms.EUP == false then
				if Config.Uniforms["uniforma"].female then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms["uniforma"].female)
				else
					ESX.ShowNotification(_U('no_outfit'))
				end
			else
				local jobic = "EUPuniforma"
				local outfit = Config.Uniforms[jobic].female
				local ped = playerPed

				RequestModel(outfit.ped)

				while not HasModelLoaded(outfit.ped) do
					Wait(0)
				end

				if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
					SetPlayerModel(PlayerId(), outfit.ped)
				end

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
			end


		end
	end)
end

function IsATruck()
	local isATruck = false
	local playerPed = GetPlayerPed(-1)
	for i=1, #Config.Trucks, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(playerPed), Config.Trucks[i]) then
			isATruck = true
			break
		end
	end
	return isATruck
end

function IsJobVodoinstalater()
	if ESX.PlayerData.job ~= nil then
		local vatr = false
		if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'vodoinstalater' then
			vatr = true
		end
		return vatr
	end
end

AddEventHandler('esx_vodoinstalater:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobVodoinstalater() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'kvar' then
		if isInService and IsJobVodoinstalater() and Radis == true and not IsPedInAnyVehicle(PlayerPedId(), false) then
			SpawnMarker = false
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BUM_WASH", 0, false)
			Wait(20000)
			TrajeIntervencija = false
			local retval = false
			local x,y,z = table.unpack(Lokacija)
			retval = IsExplosionActiveInArea(13, x, y, z, x, y, z)
			while retval do
				Wait(500)
				retval = IsExplosionActiveInArea(13, x, y, z, x, y, z)
			end
			ClearPedTasks(PlayerPedId())
			ESX.ShowNotification("Uspjesno popravljen kvar! Dobili ste 150 dolara!")
			TriggerServerEvent("vodaa:platituljanu")
			TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.job.name)
			ESX.Game.DeleteObject(NoviObj)
			ESX.Game.DeleteObject(NoviObj2)
			ESX.Game.DeleteObject(NoviObj3)
			ESX.Game.DeleteObject(NoviObj4)
			ESX.Game.DeleteObject(NoviObj5)
			RemoveBlip(Blipara)
			TriggerServerEvent("vodoinstalater:MaknutKvar", GetPlayerServerId(PlayerId()))
			NoviObj = nil
			NoviObj2 = nil
			NoviObj3 = nil
			NoviObj4 = nil
			NoviObj5 = nil
			Blipara = nil
			Wait(20000)
			SpawnajKvar()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobVodoinstalater() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

AddEventHandler('esx_vodoinstalater:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20)
		if IsJobVodoinstalater() then
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) then

					if CurrentAction == 'Obrisi' then
						if Vozilo ~= nil then
							ESX.Game.DeleteVehicle(Vozilo)
							Vozilo = nil
						end
						Radis = false
					end
					CurrentAction = nil
				end
			end
		end
    end
end)

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		if IsJobVodoinstalater() then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if Radis == true and SpawnMarker == true and (GetDistanceBetweenCoords(coords, Lokacija, true) < 2.0) then
				isInMarker  = true
				currentZone = "kvar"
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_vodoinstalater:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_vodoinstalater:hasExitedMarker', lastZone)
			end

		
			if SpawnMarker and GetDistanceBetweenCoords(coords, Lokacija, true) < Config.DrawDistance then
				waitara = 0
				naso = 1
				local x,y,z = table.unpack(Lokacija)
				DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			
			for k,v in pairs(Config.Zones) do

				if isInService and (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					waitara = 0
					naso = 1
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end

			end

			for k,v in pairs(Config.Cloakroom) do

				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					waitara = 0
					naso = 1
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end

			end
		end
	end
end)

function MakniKvar()
	TrajeIntervencija = false
	Radis = false
	ESX.Game.DeleteObject(NoviObj)
	ESX.Game.DeleteObject(NoviObj2)
	ESX.Game.DeleteObject(NoviObj3)
	ESX.Game.DeleteObject(NoviObj4)
	ESX.Game.DeleteObject(NoviObj5)
	RemoveBlip(Blipara)
	NoviObj = nil
	NoviObj2 = nil
	NoviObj3 = nil
	NoviObj4 = nil
	NoviObj5 = nil
	Blipara = nil
	SpawnMarker = false
	Lokacija = nil
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
	end
	TriggerServerEvent("vodoinstalater:MaknutKvar", GetPlayerServerId(PlayerId()))
end

function SpawnajKvar()
	if isInService then
		local novacor = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 350.0, 0.0)
		local xa,ya,za = table.unpack(novacor)
		local retval, outPosition = GetClosestVehicleNode(xa, ya, za, 0, 3.0, 0)
		local JelKoBlizu = false
		local KodGlavne = false
		if GetDistanceBetweenCoords(228.61502075195, -793.43957519531, 30.63419342041, outPosition, false) <= 80.0 then
			KodGlavne = true
		end
		if KodGlavne == false then
			for _,player in ipairs(GetActivePlayers()) do
				Wait(1)
				local kore = GetEntityCoords(GetPlayerPed(player))
				if GetDistanceBetweenCoords(kore, outPosition, false) <= 50.0 then
					JelKoBlizu = true
				end
			end
		end
		if JelKoBlizu == false and KodGlavne == false then
			ESX.ShowNotification("Imamo dojavu o puknucu cijevi, oznacena vam je lokacija na GPS-u!")
			Lokacija = outPosition
			SpawnMarker = true
			Blipara = AddBlipForCoord(outPosition)
			SetBlipSprite (Blipara, 402)
			SetBlipDisplay(Blipara, 8)
			SetBlipColour (Blipara, 49)
			SetBlipScale  (Blipara, 1.4)
			
			local x,y,z = table.unpack(outPosition)
			AddExplosion(x, y, z, 13, 1.0, true, false, 0.0, true)
			ESX.Game.SpawnObject('prop_cs_dildo_01', 
			{
				x = x,
				y = y,
				z = z-1.0
			}, function(obj)
				FreezeEntityPosition(obj, true)
				NoviObj = obj
			end)
			while NoviObj == nil do
				Wait(1)
			end
			local prvioffset = GetOffsetFromEntityInWorldCoords(NoviObj, 0.0, 2.0, 1.0)
			local drugioffset = GetOffsetFromEntityInWorldCoords(NoviObj, 0.0, -2.0, 1.0)
			local trecioffset = GetOffsetFromEntityInWorldCoords(NoviObj, 2.0, 0.0, 1.0)
			local cetvrtioffset = GetOffsetFromEntityInWorldCoords(NoviObj, -2.0, 0.0, 1.0)
			local heading = GetEntityHeading(NoviObj)
			ESX.Game.SpawnObject('prop_barrier_work06b', prvioffset, function(obj)
				--PlaceObjectOnGroundProperly_2(obj)
				FreezeEntityPosition(obj, true)
				SetEntityHeading(obj, heading+180)
				NoviObj2 = obj
			end)
			ESX.Game.SpawnObject('prop_barrier_work06b', drugioffset, function(obj)
				--PlaceObjectOnGroundProperly_2(obj)
				FreezeEntityPosition(obj, true)
				NoviObj3 = obj
			end)
			ESX.Game.SpawnObject('prop_barrier_work06b', trecioffset, function(obj)
				--PlaceObjectOnGroundProperly_2(obj)
				FreezeEntityPosition(obj, true)
				SetEntityHeading(obj, heading+90)
				NoviObj4 = obj
			end)
			ESX.Game.SpawnObject('prop_barrier_work06b', cetvrtioffset, function(obj)
				--PlaceObjectOnGroundProperly_2(obj)
				FreezeEntityPosition(obj, true)
				SetEntityHeading(obj, heading-90)
				NoviObj5 = obj
			end)
			Wait(200)
			SetNetworkIdExistsOnAllMachines(ObjToNet(NoviObj), true)
			SetNetworkIdExistsOnAllMachines(ObjToNet(NoviObj2), true)
			SetNetworkIdExistsOnAllMachines(ObjToNet(NoviObj3), true)
			SetNetworkIdExistsOnAllMachines(ObjToNet(NoviObj4), true)
			SetNetworkIdExistsOnAllMachines(ObjToNet(NoviObj5), true)
			SetNetworkIdCanMigrate(ObjToNet(NoviObj), true)
			SetNetworkIdCanMigrate(ObjToNet(NoviObj2), true)
			SetNetworkIdCanMigrate(ObjToNet(NoviObj3), true)
			SetNetworkIdCanMigrate(ObjToNet(NoviObj4), true)
			SetNetworkIdCanMigrate(ObjToNet(NoviObj5), true)
			local Obj = {}
			table.insert(Obj, {ID = GetPlayerServerId(PlayerId()), Obj1 = ObjToNet(NoviObj), Obj2 = ObjToNet(NoviObj2), Obj3 = ObjToNet(NoviObj3), Obj4 = ObjToNet(NoviObj4), Obj5 = ObjToNet(NoviObj5)})
			TriggerServerEvent("vodoinstalater:PosaljiObjekte", Obj)
			
			TrajeIntervencija = true
			
			Citizen.CreateThread(function()
				while TrajeIntervencija do
					Citizen.Wait(10000)
					AddExplosion(x, y, z, 13, 1.0, true, false, 0.0, true)
				end
			end)
		else
			Wait(5000)
			SpawnajKvar()
		end
	end
end
-------------------------------------------------
-- Fonctions
-------------------------------------------------
RegisterNetEvent('vodoinstalater:ObrisiObjekte')
AddEventHandler('vodoinstalater:ObrisiObjekte', function(obj1, obj2, obj3, obj4, obj5)
	NetworkRequestControlOfNetworkId(obj1)
	ESX.Game.DeleteObject(NetToObj(obj1))
	NetworkRequestControlOfNetworkId(obj2)
	ESX.Game.DeleteObject(NetToObj(obj2))
	NetworkRequestControlOfNetworkId(obj3)
	ESX.Game.DeleteObject(NetToObj(obj3))
	NetworkRequestControlOfNetworkId(obj4)
	ESX.Game.DeleteObject(NetToObj(obj4))
	NetworkRequestControlOfNetworkId(obj5)
	ESX.Game.DeleteObject(NetToObj(obj5))
end)
-- Fonction selection nouvelle mission livraison
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)