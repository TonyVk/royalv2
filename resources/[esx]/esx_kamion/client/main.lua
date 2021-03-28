ESX = nil
local Radis = false
local Vozilo = nil
local Blipara = nil
local kont = nil
local prikolica = nil
local kamion = nil
local zakacio = false
local utovario = false
local zakacioprikolicu = false
local Lokacija = nil
local Pumpe = {}
local Gorivo = false
local Pumpa = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ProvjeriPosao()
	Wait(5000)
	ESX.TriggerServerCallback('pumpe:DohvatiPumpe', function(pumpe)
		Pumpe = pumpe
	end)
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
				ZavrsiPosao()
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
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

RegisterNetEvent('pumpe:SaljiPumpe')
AddEventHandler('pumpe:SaljiPumpe', function(pumpe) 
	Pumpe = pumpe
end)

function MenuVehicleSpawner()
	local elements = {}
	
	table.insert(elements, {label = "Dostava kontenjera", value = "handler"})
	table.insert(elements, {label = "Dostava goriva", value = "phantom"})


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "handler" then
			if Vozilo ~= nil then
				ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
			end
			ESX.Streaming.RequestModel(data.current.value)
			local pronaso = false
			for i=1, #Config.VehicleSpawnPoint, 1 do
				if ESX.Game.IsSpawnPointClear({
					x = Config.VehicleSpawnPoint[i].Prikolica.x,
					y = Config.VehicleSpawnPoint[i].Prikolica.y,
					z = Config.VehicleSpawnPoint[i].Prikolica.z
				}, 10.0) then
					pronaso = true
					Vozilo = CreateVehicle(data.current.value, Config.VehicleSpawnPoint[i].Pos.x, Config.VehicleSpawnPoint[i].Pos.y, Config.VehicleSpawnPoint[i].Pos.z, 0, true, false)
					SetModelAsNoLongerNeeded(GetHashKey(data.current.value))
					platenum = math.random(10000, 99999)
					SetVehicleNumberPlateText(Vozilo, "SIK"..platenum)             
					plaquevehicule = "SIK"..platenum			
					TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vozilo, -1)
					ESX.ShowNotification("Utovarite kontenjer na prikolicu!")
					StartajPosao(i)
					Radis = true
					break
				end
			end
			if pronaso == false then
				ESX.ShowNotification("Trenutno nemamo slobodnih mjesta za utovar!")
			end
		elseif data.current.value == "phantom" then
			local naso = false
			for i=1, #Pumpe, 1 do
				if Pumpe[i] ~= nil then
					if Pumpe[i].Narudzba == 1 then
						naso = true
						break
					end
				end
			end
			if naso then
				if Vozilo ~= nil then
					ESX.Game.DeleteVehicle(Vozilo)
					Vozilo = nil
				end
				ESX.Streaming.RequestModel(data.current.value)
				local pronaso = false
				for i=1, #Config.VehicleSpawnPoint, 1 do
					if ESX.Game.IsSpawnPointClear({
						x = Config.VehicleSpawnPoint[i].Prikolica.x,
						y = Config.VehicleSpawnPoint[i].Prikolica.y,
						z = Config.VehicleSpawnPoint[i].Prikolica.z
					}, 10.0) then
						pronaso = true
						Vozilo = CreateVehicle(data.current.value, Config.VehicleSpawnPoint[i].Pos.x, Config.VehicleSpawnPoint[i].Pos.y, Config.VehicleSpawnPoint[i].Pos.z, 0, true, false)
						SetModelAsNoLongerNeeded(GetHashKey(data.current.value))
						platenum = math.random(10000, 99999)
						SetVehicleNumberPlateText(Vozilo, "SIK"..platenum)             
						plaquevehicule = "SIK"..platenum			
						TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vozilo, -1)
						ESX.Streaming.RequestModel("tanker")
						prikolica = CreateVehicle(GetHashKey("tanker"), Config.VehicleSpawnPoint[i].Pos.x, Config.VehicleSpawnPoint[i].Pos.y, Config.VehicleSpawnPoint[i].Pos.z, 0, true, false)
						SetModelAsNoLongerNeeded(GetHashKey("tanker"))
						AttachVehicleToTrailer(Vozilo, prikolica, 5)
						StartajPosao2()
						Radis = true
						break
					end
				end
				if pronaso == false then
					ESX.ShowNotification("Trenutno nemamo slobodnih mjesta za utovar!")
				end
			else
				ESX.ShowNotification("Trenutno nema narudzbi za dostavu goriva!")
			end
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

function IsJobKamion()
	if ESX.PlayerData.job ~= nil then
		local vatr = false
		if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'kamion' then
			vatr = true
		end
		return vatr
	end
end

AddEventHandler('esx_kamion:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end
	
	if zone == 'dostava' then
		local corde = GetEntityCoords(prikolica)
		if #(corde-Lokacija) <= 10.0 then
		--if GetDistanceBetweenCoords(corde, Lokacija, true) <= 10.0 then
			RemoveBlip(Blipara)
			Blipara = nil
			if not Gorivo then
				FreezeEntityPosition(kamion, true)
				DoScreenFadeOut(2000)
				while not IsScreenFadedOut() do
					Wait(100)
				end
				ESX.Game.DeleteObject(kont)
				kont = nil
				DoScreenFadeIn(500)
				FreezeEntityPosition(kamion, false)
				Lokacija = nil
				Blipara = AddBlipForCoord(1156.4053955078, -3287.73046875, 5.901026725769)
				SetBlipSprite (Blipara, 68)
				SetBlipDisplay(Blipara, 8)
				SetBlipColour (Blipara, 47)
				SetBlipScale  (Blipara, 1.4)
				SetBlipRoute(Blipara, true)
				ESX.ShowNotification("Vratite kamion nazad do firme!")
				TriggerServerEvent("kamiooon:platituljanu")
				TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.job.name)
				TriggerServerEvent("kamion:MaknutObjekt", GetPlayerServerId(PlayerId()))
			else
				FreezeEntityPosition(Vozilo, true)
				DoScreenFadeOut(2000)
				while not IsScreenFadedOut() do
					Wait(100)
				end
				DoScreenFadeIn(500)
				FreezeEntityPosition(Vozilo, false)
				Lokacija = nil
				Blipara = AddBlipForCoord(1156.4053955078, -3287.73046875, 5.901026725769)
				SetBlipSprite (Blipara, 68)
				SetBlipDisplay(Blipara, 8)
				SetBlipColour (Blipara, 47)
				SetBlipScale  (Blipara, 1.4)
				SetBlipRoute(Blipara, true)
				ESX.ShowNotification("Vratite kamion nazad do firme!")
				TriggerServerEvent("pumpe:DostavioGorivo", Pumpa)
				TriggerServerEvent("kamiooon:platituljanu2")
				TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.job.name)
				Gorivo = false
				Pumpa = nil
			end
		else
			ESX.ShowNotification("Dosli ste bez prikolice!")
		end
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobKamion() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobKamion() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

RegisterNetEvent('kamion:ObrisiObjekte')
AddEventHandler('kamion:ObrisiObjekte', function(obj1)
	NetworkRequestControlOfNetworkId(obj1)
	ESX.Game.DeleteObject(NetToObj(obj1))
end)

AddEventHandler('esx_kamion:hasExitedMarker', function(zone)
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
		if IsJobKamion() then
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) then

					if CurrentAction == 'Obrisi' then
						ZavrsiPosao()
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
		if IsJobKamion() then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if #(coords-v.Pos) < v.Size.x then
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if #(coords-v.Pos) < v.Size.x then
				--if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if kont ~= nil then
				if Vozilo ~= nil then
					if GetVehiclePedIsIn(PlayerPedId(), false) == Vozilo and zakacio == false and utovario == false then
						waitara = 0
						naso = 1
						local corde = GetEntityCoords(kont)
						local x,y,z = table.unpack(corde)
						DrawMarker(0, x, y, z+4.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
					end
				end
			end
			
			if zakacio == true and utovario == false then
				waitara = 0
				naso = 1
				local corde = GetEntityCoords(prikolica)
				local x,y,z = table.unpack(corde)
				DrawMarker(0, x, y, z+2.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			
			if kamion ~= nil and utovario == true then
				if GetVehiclePedIsIn(PlayerPedId(), false) ~= kamion then
					waitara = 0
					naso = 1
					local corde = GetEntityCoords(kamion)
					local x,y,z = table.unpack(corde)
					DrawMarker(0, x, y, z+4.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
				else
					if zakacioprikolicu == false then
						waitara = 0
						naso = 1
						local corde = GetEntityCoords(kont)
						local x,y,z = table.unpack(corde)
						DrawMarker(0, x, y, z+4.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
					end
				end
			end
			
			if Lokacija ~= nil then
				if #(coords-Lokacija) < 100 then
				--if GetDistanceBetweenCoords(coords, Lokacija, true) < 100 then
					waitara = 0
					naso = 1
					local x,y,z = table.unpack(Lokacija)
					if Gorivo then
						DrawMarker(1, x, y, z-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
					else
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
					end
				end
			end
			
			if Radis == true and Lokacija ~= nil and (#(coords-Lokacija) < 2.0) then
				isInMarker  = true
				currentZone = "dostava"
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_kamion:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_kamion:hasExitedMarker', lastZone)
			end
			
			for k,v in pairs(Config.Zones) do
					if isInService and (v.Type ~= -1 and #(coords-v.Pos) < Config.DrawDistance) then
						waitara = 0
						naso = 1
						DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					end
			end

			for k,v in pairs(Config.Cloakroom) do

				if(v.Type ~= -1 and #(coords-v.Pos) < Config.DrawDistance) then
					waitara = 0
					naso = 1
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end

			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

function ZavrsiPosao()
	Radis = false
	RemoveBlip(Blipara)
	Blipara = nil
	if kamion ~= nil then
		ESX.Game.DeleteVehicle(kamion)
		kamion = nil
	end
	if prikolica ~= nil then
		ESX.Game.DeleteVehicle(prikolica)
		prikolica = nil
	end
	if kont ~= nil then
		ESX.Game.DeleteObject(kont)
		kont = nil
	end
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
	end
	TriggerServerEvent("kamion:MaknutObjekt", GetPlayerServerId(PlayerId()))
end

function StartajPosao2()
	for i=1, #Pumpe, 1 do
		if Pumpe[i] ~= nil then
			if Pumpe[i].Narudzba == 1 then
				Blipara = AddBlipForCoord(Pumpe[i].Dostava.x, Pumpe[i].Dostava.y, Pumpe[i].Dostava.z)
				SetBlipSprite (Blipara, 68)
				SetBlipDisplay(Blipara, 8)
				SetBlipColour (Blipara, 47)
				SetBlipScale  (Blipara, 1.4)
				SetBlipRoute(Blipara, true)
				ESX.ShowNotification("Odvezite gorivo na oznacenu lokaciju!")
				Lokacija = vector3(Pumpe[i].Dostava.x, Pumpe[i].Dostava.y, Pumpe[i].Dostava.z)
				Gorivo = true
				Pumpa = Pumpe[i].Ime
				break
			end
		end
	end
end

function StartajPosao(br)
	if isInService then
		zakacio = false
		utovario = false
		zakacioprikolicu = false
		ESX.Game.SpawnObject('prop_contr_03b_ld', {
			x = Config.Spawnovi[br].Kontenjer.x,
			y = Config.Spawnovi[br].Kontenjer.y,
			z = Config.Spawnovi[br].Kontenjer.z
		}, function(obj)
			SetEntityHeading(obj, Config.Spawnovi[br].Kontenjer.h)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			kont = obj
			local neid = ObjToNet(obj)
			SetNetworkIdExistsOnAllMachines(neid, true)
			SetNetworkIdCanMigrate(neid, true)
			local Obj = {}
			table.insert(Obj, {ID = GetPlayerServerId(PlayerId()), Obj1 = neid})
			TriggerServerEvent("kamion:PosaljiObjekte", Obj)
		end)
		ESX.Game.SpawnVehicle("TRFlat", {
			x = Config.Spawnovi[br].Prikolica.x,
			y = Config.Spawnovi[br].Prikolica.y,
			z = Config.Spawnovi[br].Prikolica.z
		}, Config.Spawnovi[br].Prikolica.h, function(callback_vehicle)
			prikolica = callback_vehicle
		end)
		ESX.Game.SpawnVehicle("phantom", {
			x = Config.Spawnovi[br].Kamion.x,
			y = Config.Spawnovi[br].Kamion.y,
			z = Config.Spawnovi[br].Kamion.z
		}, Config.Spawnovi[br].Kamion.h, function(callback_vehicle)
			kamion = callback_vehicle
		end)
		Blipara = AddBlipForCoord(Config.Spawnovi[br].Kontenjer.x, Config.Spawnovi[br].Kontenjer.y, Config.Spawnovi[br].Kontenjer.z)
		SetBlipSprite (Blipara, 68)
		SetBlipDisplay(Blipara, 8)
		SetBlipColour (Blipara, 47)
		SetBlipScale  (Blipara, 1.4)
		Citizen.CreateThread(function()
			while not zakacio do
				Citizen.Wait(300)
				if IsHandlerFrameAboveContainer(GetVehiclePedIsIn(PlayerPedId(), false), kont) then
					Citizen.InvokeNative(0x6a98c2ecf57fa5d4, GetVehiclePedIsIn(PlayerPedId(), false), kont)
					FreezeEntityPosition(kont, false)
					zakacio = true
					RemoveBlip(Blipara)
				end
			end
			while not utovario do
				Citizen.Wait(300)
				if not IsEntityAttachedToHandlerFrame(Vozilo, kont) then
					zakacio = false
					while not zakacio do
						Wait(300)
						if IsHandlerFrameAboveContainer(Vozilo, kont) then
							Citizen.InvokeNative(0x6a98c2ecf57fa5d4, Vozilo, kont)
							FreezeEntityPosition(kont, false)
							zakacio = true
							RemoveBlip(Blipara)
						end
					end
				end
				local corda = GetEntityCoords(prikolica)
				local corda2 = GetEntityCoords(kont)
				if #(corda-corda2) <= 1.0 then
				--if GetDistanceBetweenCoords(corda, corda2, true) <= 1.0 then
					DetachContainerFromHandlerFrame(GetVehiclePedIsIn(PlayerPedId(), false))
					AttachEntityToEntity(kont, prikolica, 0, 0.0, 0.0, 0.4, 0.0, 0.0, 0.0, false, false, true, false, 20, true)
					utovario = true
					zakacio = false
					ESX.ShowNotification("Udjite u kamion i zakacite prikolicu")
				end
			end
			while IsPedInAnyVehicle(PlayerPedId(), false) do
				Citizen.Wait(100)
			end
			local retval, trailer = GetVehicleTrailerVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
			while not retval do
				Citizen.Wait(100)
				retval, trailer = GetVehicleTrailerVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
			end
			zakacioprikolicu = true
			if trailer ~= prikolica then
				ESX.ShowNotification("Zakacili ste krivu prikolicu i posao vam je prekinut")
				ZavrsiPosao()
			else
				ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
				Blipara = AddBlipForCoord(-500.92709350586, -2842.4367675781, 6.0003814697266)
				SetBlipSprite (Blipara, 68)
				SetBlipDisplay(Blipara, 8)
				SetBlipColour (Blipara, 47)
				SetBlipScale  (Blipara, 1.4)
				SetBlipRoute(Blipara, true)
				ESX.ShowNotification("Odvezite kontenjer na oznacenu lokaciju!")
				Lokacija = vector3(-500.92709350586, -2842.4367675781, 5.0003814697266)
			end
		end)
	end
end
-------------------------------------------------
-- Fonctions
-------------------------------------------------
-- Fonction selection nouvelle mission livraison
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)