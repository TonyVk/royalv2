ESX = nil
local Objekti = {}
local Radis = false
local ObjBr = 1
local UzmiCiglu = false
local OstaviCiglu = false
local ZadnjaCigla = nil
local PrvaCigla = nil
local OstaviKoord = nil
local prop = nil
local RandomPosao = 0

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
				ZavrsiPosao()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	    			TriggerEvent('skinchanger:loadSkin', skin)
				end)
				TriggerEvent("dpemotes:Radim", false)
			end
			if data.current.value == 'job_wear' then
				if not Radis then
					isInService = true
					setUniform(PlayerPedId())
					PokreniPosao()
				else
					ESX.ShowNotification("Vec imas uniformu na sebi!")
				end
				--[[ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    			if skin.sex == 0 then
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end
				end)]]
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function PokreniPosao()
	ObjBr = 1
	Radis = true
	TriggerEvent("dpemotes:Radim", true)
	Objekti = {}
	UzmiCiglu = true
	RandomPosao = math.random(1,2)
	if RandomPosao == 1 then
		OstaviKoord = vector3(1373.4049072266, -781.62121582031, 66.773597717285)
	elseif RandomPosao == 2 then
		OstaviKoord = vector3(1367.0717773438, -780.54565429688, 66.745780944824)
	end
	ESX.ShowNotification("Idite do markera da uzmete blok!")
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

function IsJobGradjevinar()
	if ESX.PlayerData.job ~= nil then
		local gradj = false
		if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'gradjevinar' then
			gradj = true
		end
		return gradj
	end
end

AddEventHandler('esx_gradjevinar:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end
	
	if zone == 'Uzmiciglu' then
		UzmiCiglu = false
		OstaviCiglu = true
		ESX.Streaming.RequestAnimDict('creatures@rottweiler@tricks@', function()
			FreezeEntityPosition(PlayerPedId(), true)
			TaskPlayAnim(PlayerPedId(), 'creatures@rottweiler@tricks@', 'petting_franklin', 8.0, -8, -1, 36, 0, 0, 0, 0)
			Citizen.Wait(2000)
			ClearPedSecondaryTask(PlayerPedId())
			FreezeEntityPosition(PlayerPedId(), false)
			RemoveAnimDict("creatures@rottweiler@tricks@")
		end)
		ESX.Streaming.RequestAnimDict('amb@world_human_bum_freeway@male@base', function()
			TaskPlayAnim(PlayerPedId(), 'amb@world_human_bum_freeway@male@base', 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)
		end)
		local playerPed = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		prop = CreateObject(GetHashKey("prop_wallbrick_01"), x, y, z+2, false, false, false)
		local boneIndex = GetPedBoneIndex(playerPed, 57005)
		AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.068, -0.241, 0.0, 90.0, 20.0, true, true, false, true, 1, true)
		ESX.ShowNotification("Idite do markera da ostavite blok!")
	end
	
	if zone == 'Ostaviciglu' then
		OstaviCiglu = false
		if ObjBr == 1 then
			ESX.Streaming.RequestAnimDict('random@domestic', function()
				FreezeEntityPosition(PlayerPedId(), true)
				TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, -8, -1, 36, 0, 0, 0, 0)
				Wait(500)
				DeleteObject(prop)
				prop = nil
				Citizen.Wait(1700)
				ClearPedSecondaryTask(PlayerPedId())
				FreezeEntityPosition(PlayerPedId(), false)
				RemoveAnimDict("random@domestic")
			end)
			if RandomPosao == 1 then
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
							x = 1373.352,
							y =  -781.0687,
							z = 66.01108
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					ZadnjaCigla = obj
					PrvaCigla = obj
					local prvioffset = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) --lijevo
					OstaviKoord = prvioffset
				end)
			elseif RandomPosao == 2 then
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
							x = 1367.143,
							y =  -779.98,
							z = 66.02597
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					ZadnjaCigla = obj
					PrvaCigla = obj
					local prvioffset = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) --lijevo
					OstaviKoord = prvioffset
				end)
			end
			ObjBr = ObjBr+1
			UzmiCiglu = true
			TriggerServerEvent("gradjevinar:tuljaniplivaju")
			TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.job.name)
		else
			if ObjBr > 1 and ObjBr ~= 16 and ObjBr ~= 31 and ObjBr ~= 46 and ObjBr ~= 61 then
				local prvioffset = GetOffsetFromEntityInWorldCoords(ZadnjaCigla, -0.42, 0.0, -0.073) --lijevo
				ESX.Streaming.RequestAnimDict('random@domestic', function()
					FreezeEntityPosition(PlayerPedId(), true)
					TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, -8, -1, 36, 0, 0, 0, 0)
					Wait(500)
					DeleteObject(prop)
					prop = nil
					Citizen.Wait(1700)
					ClearPedSecondaryTask(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
					RemoveAnimDict("random@domestic")
				end)
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
							x = prvioffset.x,
							y =  prvioffset.y,
							z = prvioffset.z
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					ZadnjaCigla = obj
					if ObjBr == 16 or ObjBr == 31 or ObjBr == 46 or ObjBr == 61 then
						if RandomPosao == 1 then
							OstaviKoord = vector3(1373.4049072266, -781.62121582031, 66.773597717285)
						elseif RandomPosao == 2 then
							OstaviKoord = vector3(1367.0717773438, -780.54565429688, 66.745780944824)
						end
					else
						local prvioffset2 = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) --lijevo
						OstaviKoord = prvioffset2
					end
				end)
				ObjBr = ObjBr+1
				if ObjBr == 76 then
					ESX.ShowNotification("Zavrsili ste sa poslom!")
					ESX.ShowNotification("Da pocnete ponovno raditi ostavite i uzmite opremu!")
				else
					UzmiCiglu = true
				end
				TriggerServerEvent("gradjevinar:tuljaniplivaju")
				TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.job.name)
			elseif ObjBr == 16 or ObjBr == 31 or ObjBr == 46 or ObjBr == 61 then
				local prvioffset = GetOffsetFromEntityInWorldCoords(PrvaCigla, 0.0, 0.0, 0.07) --gore
				ESX.Streaming.RequestAnimDict('random@domestic', function()
					FreezeEntityPosition(PlayerPedId(), true)
					TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, -8, -1, 36, 0, 0, 0, 0)
					Wait(500)
					DeleteObject(prop)
					prop = nil
					Citizen.Wait(1700)
					ClearPedSecondaryTask(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
					RemoveAnimDict("random@domestic")
				end)
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
					x = prvioffset.x,
					y =  prvioffset.y,
					z = prvioffset.z
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					ZadnjaCigla = obj
					PrvaCigla = obj
					local prvioffset2 = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) --lijevo
					OstaviKoord = prvioffset2
				end)
				ObjBr = ObjBr+1
				UzmiCiglu = true
				TriggerServerEvent("gradjevinar:tuljaniplivaju")
				TriggerServerEvent("biznis:DodajTuru", ESX.PlayerData.job.name)
			end
		end
	end
end)

function ZavrsiPosao()
	if Radis == true then
		for i=1, #Objekti, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
			end
		end
		Radis = false
		TriggerEvent("dpemotes:Radim", false)
		OstaviCiglu = false
		UzmiCiglu = false
		ZadnjaCigla = nil
		OstaviKoord = nil
	end
end

AddEventHandler('esx_gradjevinar:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		if IsJobGradjevinar() then
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil
			
			for k,v in pairs(Config.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if Radis and UzmiCiglu and (GetDistanceBetweenCoords(coords, 1380.8416748047, -773.89587402344, 66.999649047852, true) < 1.5) then
				isInMarker  = true
				currentZone = "Uzmiciglu"
			end
			
			if Radis and OstaviCiglu and (GetDistanceBetweenCoords(coords, OstaviKoord, false) < 0.5) then
				isInMarker  = true
				currentZone = "Ostaviciglu"
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_gradjevinar:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_gradjevinar:hasExitedMarker', lastZone)
			end

		
			if Radis and UzmiCiglu and GetDistanceBetweenCoords(coords, 1380.8416748047, -773.89587402344, 66.999649047852, true) < Config.DrawDistance then
				waitara = 0
				naso = 1
				DrawMarker(1, 1380.8416748047, -773.89587402344, 65.999649047852, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			
			if Radis and OstaviCiglu and GetDistanceBetweenCoords(coords, OstaviKoord, true) < Config.DrawDistance then
				waitara = 0
				naso = 1
				DrawMarker(0, OstaviKoord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end

			for k,v in pairs(Config.Cloakroom) do

				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					waitara = 0
					naso = 1
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end

			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

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