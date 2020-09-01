ESX                             = nil

local Tim = 0
local MinutaKr = -1
local Koord
local T1Spawn = 0
local T2Spawn = 0
local Tim1Score = 0
local Tim2Score = 0
local Odjeca
local Tim1Igr = 0
local Tim2Igr = 0
local MojSpawn = nil

local forceTypes = {
    MinForce = 0,
    MaxForceRot = 1,
    MinForce2 = 2,
    MaxForceRot2 = 3,
    ForceNoRot = 4,
    ForceRotPlusForce = 5
}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  while ESX.GetPlayerData().job == nil do
	Citizen.Wait(100)
  end
  --ProvjeriPosao()
end)

local Lopta
local NLopta = nil

RegisterCommand("lopta", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			Lopta = CreateObject(GetHashKey("stt_prop_stunt_soccer_ball"), 231.90512084961, -791.50927734375, 29.607139587402,true,false,false)
			ESX.ShowNotification("Spawno sam ti loptu")
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	end)
end, false)

RegisterCommand("npozovi", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			local id = tonumber(args[1])
			local tim = tonumber(args[2])
			if id ~= nil and tim ~= nil then
				if tim > 0 and tim < 3 then
					local brojic = 0
					if tim == 1 then
						brojic = Tim1Igr+1
					else
						brojic = Tim2Igr+1
					end
					if tonumber(brojic) <= 3 then
						TriggerServerEvent("nogomet:pozovi", id, tim)
					else
						ESX.ShowNotification("Vec imate max broj igraca u tome timu!")
					end
				else
					name = "System"..":"
					message = " /npozovi [ID igraca][Tim(1 ili 2)]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end
			else
				name = "System"..":"
				message = " /npozovi [ID igraca][Tim(1 ili 2)]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	end)
end, false)

RegisterNetEvent("nogomet:VrimeKraj")
AddEventHandler('nogomet:VrimeKraj', function(vr)
	if Tim > 0 then
		MinutaKr = vr
		SendNUIMessage({
			vrijeme = true,
			minuta = SecondsToClock(vr)
		})
	end
end)

RegisterNetEvent("nogomet:stop")
AddEventHandler('nogomet:stop', function()
	if Tim > 0 then
		ESX.Game.DeleteObject(NLopta)
		SendNUIMessage({
			zatvoriscore = true
		})
		PoceoNogomet = 0
		if Tim1Score > Tim2Score then
			ESX.ShowNotification("Tim 1 je pobjedio tim 2 sa "..Tim1Score..":"..Tim2Score)
		elseif Tim2Score > Tim1Score then
			ESX.ShowNotification("Tim 2 je pobjedio tim 1 sa "..Tim2Score..":"..Tim1Score)
		else
			ESX.ShowNotification("Utakmica je zavrsila izjednaceno "..Tim1Score..":"..Tim2Score)
		end
		Tim1Score = 0
		Tim2Score = 0
		T1Spawn = 0
		T2Spawn = 0
		Tim1Igr = 0
		Tim2Igr = 0
		Tim = 0
		MojSpawn = nil
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerEvent('skinchanger:loadClothes', skin, Odjeca)
		end)
		SetEntityCoords(GetPlayerPed(-1), Koord, 1, 0, 0, 1)
	end
end)

function PratiKraj()
	Citizen.CreateThread(function()
		while PoceoNogomet == 1 do
			Citizen.Wait(0)
			if MinutaKr == 0 then
				MinutaKr = -1
				TriggerServerEvent("nogomet:Zaustavi")
			end
		end
	end)
end

RegisterCommand("nzaustavi", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			TriggerServerEvent("nogomet:Zaustavi")
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	end)
end, false)

function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return mins..":"..secs
  end
end

RegisterCommand("npokreni", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			local vrijeme = tonumber(args[1])
			if vrijeme ~= nil then
				if vrijeme > 0 then
					local loptee = "p_ld_soc_ball_01"
					ESX.Streaming.RequestModel(loptee)
					NLopta = CreateObject(GetHashKey(loptee), 771.25549316406, -233.44470214844, 65.114479064941,true,false,false)
					SetEntityAsMissionEntity(NLopta, true, true)
					NetworkRegisterEntityAsNetworked(NLopta)
					local netid = ObjToNet(NLopta)
					NetworkSetNetworkIdDynamic(netid, false)
					SetNetworkIdCanMigrate(netid, true)
					SetNetworkIdExistsOnAllMachines(netid, true)
					TriggerServerEvent("SpawnLoptu", netid)
					SetModelAsNoLongerNeeded(GetHashKey(loptee))
					TriggerServerEvent("nogomet:pokreni", vrijeme*60)
				else
					name = "System"..":"
					message = " /npokreni [Vrijeme trajanja(minute)]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end
			else
				name = "System"..":"
				message = " /npokreni [Vrijeme trajanja]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	end)
end, false)

RegisterNetEvent("nogomet:VratioSpawnove")
AddEventHandler('nogomet:VratioSpawnove', function(tim, br)
    if tim == 1 then
		T1Spawn = br
	elseif tim == 2 then
		T2Spawn = br
	end
end)

RegisterNetEvent("nogomet:pozvao")
AddEventHandler("nogomet:pozvao", function(tim)
	if Tim == 0 then
		Koord = GetEntityCoords(PlayerPedId())
		Tim = tim
		if tim == 1 then
			if T1Spawn == 0 then
				SetEntityCoords(GetPlayerPed(-1), 799.01550292969, -239.68855285645, 65.114234924316, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 61.88)
				MojSpawn = 0
			elseif T1Spawn == 1 then
				SetEntityCoords(GetPlayerPed(-1), 793.00500488281, -251.85321044922, 65.114234924316, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 63.08)
				MojSpawn = 1
			elseif T1Spawn == 2 then
				SetEntityCoords(GetPlayerPed(-1), 789.25994873047, -242.23332214355, 65.114265441895, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 62.87)
				MojSpawn = 2
			end
			T1Spawn = T1Spawn+1
			TriggerServerEvent("nogomet:SyncSpawnove", tim, T1Spawn)
			TriggerEvent('skinchanger:getSkin', function(skin)
				Odjeca = skin
				local clothesSkin = {
					['tshirt_1'] = 1, ['tshirt_2'] = 1,
					['torso_1'] = 7, ['torso_2'] = 5
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end)
			Tim1Igr = Tim1Igr+1
		elseif tim == 2 then
			if T2Spawn == 0 then
				SetEntityCoords(GetPlayerPed(-1), 743.09509277344, -227.79415893555, 65.121788024902, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 243.74)
				MojSpawn = 0
			elseif T2Spawn == 1 then
				SetEntityCoords(GetPlayerPed(-1), 749.19232177734, -215.3184967041, 65.114479064941, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 244.80)
				MojSpawn = 1
			elseif T2Spawn == 2 then
				SetEntityCoords(GetPlayerPed(-1), 754.91931152344, -225.63809204102, 65.120269775391, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 241.86)
				MojSpawn = 2
			end
			T2Spawn = T2Spawn+1
			TriggerServerEvent("nogomet:SyncSpawnove", tim, T2Spawn)
			TriggerEvent('skinchanger:getSkin', function(skin)
				Odjeca = skin
				local clothesSkin = {
					['tshirt_1'] = 1, ['tshirt_2'] = 1,
					['torso_1'] = 7, ['torso_2'] = 3
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end)
			Tim2Igr = Tim2Igr+1
		end
		TriggerServerEvent("nogomet:SyncTimove", Tim1Igr, Tim2Igr)
		FreezeEntityPosition(GetPlayerPed(-1), true)
		ESX.ShowNotification("Pozvani ste u tim "..tim.." na nogometu!")
		StartProvjeru()
	end
end)

RegisterNetEvent("nogomet:VratiTimove")
AddEventHandler('nogomet:VratiTimove', function(t1, t2)
    Tim1Igr = t1
	Tim2Igr = t2
end)

RegisterNetEvent("nogomet:start")
AddEventHandler("nogomet:start", function(vr)
	if Tim > 0 then
		MinutaKr = vr
		SendNUIMessage({
			vrijeme = true,
			minuta = SecondsToClock(vr),
			prikaziscore = true,
			team1 = true,
			team2 = true,
			score1 = 0,
			score2 = 0
		})
		PoceoNogomet = 1
		FreezeEntityPosition(GetPlayerPed(-1), false)
		PratiKraj()
		ESX.ShowNotification("Poceo je nogomet!")
		ESX.ShowNotification("Loptu napucavate sa lijevom i desnom tipkom misa!")
		Citizen.CreateThread(function()
			while PoceoNogomet == 1 do
				Citizen.Wait(1)
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 22, true)
				DisablePlayerFiring(GetPlayerPed(-1),true)
				SetCurrentPedWeapon(GetPlayerPed(-1),GetHashKey("WEAPON_UNARMED"),true)
			end
		end)
	end
end)

RegisterNetEvent("EoTiLopta")
AddEventHandler("EoTiLopta", function(net)
	if NetworkDoesNetworkIdExist(net) then
		NLopta = NetToObj(net)
	end
end)

RegisterNetEvent("nogomet:PoslaoPoruku")
AddEventHandler("nogomet:PoslaoPoruku", function(poruka)
	if Tim > 0 then
		ESX.ShowNotification(poruka)
	end
end)

RegisterNetEvent("nogomet:VratiScore")
AddEventHandler('nogomet:VratiScore', function(t1, t2)
	if Tim > 0 then
		Tim1Score = t1
		Tim2Score = t2
		SendNUIMessage({
			team1 = true,
			team2 = true,
			score1 = t1,
			score2 = t2,
		})
		if Tim == 1 then
			if MojSpawn == 0 then
				SetEntityCoords(GetPlayerPed(-1), 799.01550292969, -239.68855285645, 65.114234924316, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 61.88)
			elseif MojSpawn == 1 then
				SetEntityCoords(GetPlayerPed(-1), 793.00500488281, -251.85321044922, 65.114234924316, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 63.08)
			elseif MojSpawn == 2 then
				SetEntityCoords(GetPlayerPed(-1), 789.25994873047, -242.23332214355, 65.114265441895, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 62.87)
			end
		elseif Tim == 2 then
			if MojSpawn == 0 then
				SetEntityCoords(GetPlayerPed(-1), 743.09509277344, -227.79415893555, 65.121788024902, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 243.74)
			elseif MojSpawn == 1 then
				SetEntityCoords(GetPlayerPed(-1), 749.19232177734, -215.3184967041, 65.114479064941, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 244.80)
			elseif MojSpawn == 2 then
				SetEntityCoords(GetPlayerPed(-1), 754.91931152344, -225.63809204102, 65.120269775391, 1, 0, 0, 1)
				SetEntityHeading(GetPlayerPed(-1), 241.86)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Tim > 0 then
			if IsDisabledControlJustPressed(0, 24) then
				if NLopta ~= nil then
					local cor = GetEntityCoords(NLopta)
					local cora = GetEntityCoords(PlayerPedId())
					if GetDistanceBetweenCoords(cor, cora, false) <= 1.0 then
						while not NetworkHasControlOfEntity(NLopta) do 
							NetworkRequestControlOfEntity(NLopta)
							Citizen.Wait(0)
						end
						local cordsa = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 22.0 , 0.0)
						local fcor = cor-cordsa
						local forceType = forceTypes.MaxForceRot2
						local direction = vector3(cordsa.x-cor.x, cordsa.y-cor.y, 0.0)
						local rotation = vector3(0.0, 0.0, 0.0)
						local boneIndex = 0
						local isDirectionRel = false
						local ignoreUpVec = true
						local isForceRel = true
						local p12 = false
						local p13 = true
						ApplyForceToEntity(NLopta,forceType,direction,rotation,boneIndex,isDirectionRel,ignoreUpVec,isForceRel,p12,p13)
					end
				end
			end
			if IsDisabledControlJustPressed(0, 25) then
				if NLopta ~= nil then
					local cor = GetEntityCoords(NLopta)
					local cora = GetEntityCoords(PlayerPedId())
					if GetDistanceBetweenCoords(cor, cora, false) <= 1.0 then
						while not NetworkHasControlOfEntity(NLopta) do 
							NetworkRequestControlOfEntity(NLopta)
							Citizen.Wait(0)
						end
						local cordsa = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 22.0 , 7.0)
						local fcor = cor-cordsa
						local forceType = forceTypes.MaxForceRot2
						local direction = vector3(cordsa.x-cor.x, cordsa.y-cor.y, cordsa.z-cor.z)
						local rotation = vector3(0.0, 0.0, 0.0)
						local boneIndex = 0
						local isDirectionRel = false
						local ignoreUpVec = true
						local isForceRel = true
						local p12 = false
						local p13 = true
						ApplyForceToEntity(NLopta,forceType,direction,rotation,boneIndex,isDirectionRel,ignoreUpVec,isForceRel,p12,p13)
					end
				end
			end
		end
	end
end)

local Cekaj = false

function StartProvjeru()
	while Tim > 0 do
		Wait(500)
		if Cekaj == false then
			local retval = NetworkHasControlOfEntity(NLopta)
			local retval2 = IsEntityOnScreen(NLopta)
			if retval and retval2 then
				local gol = IsEntityInArea(NLopta, 742.28167724609, -215.1989440918, 66.114486694336, 734.28143310547, -220.08067321777, 69.113777160645, false, false, 0)
				local gol2 = IsEntityInArea(NLopta, 809.60778808594, -256.48187255859, 62.874031066895, 803.73907470703, -245.51196289063, 69.09415435791, false, false, 0)
				local vani = IsEntityInArea(NLopta, 800.07263183594, -252.25970458984, 66.099967956543, 797.50408935547, -257.26220703125, 66.099182128906, false, false, 0)
				local vani19 = IsEntityInArea(NLopta, 797.50408935547, -257.26220703125, 66.099182128906, 792.55206298828, -266.5778503418, 66.099159240723, false, false, 0)
				local vani2 = IsEntityInArea(NLopta, 803.56158447266, -245.02055358887, 66.110748291016, 806.02685546875, -240.16007995605, 66.112663269043, false, false, 0)
				local vani20 = IsEntityInArea(NLopta, 806.02685546875, -240.16007995605, 66.112663269043, 810.25854492188, -232.25086975098, 66.114311218262, false, false, 0)
				local vani3 = IsEntityInArea(NLopta, 810.73413085938, -232.31889343262, 66.114250183105, 800.98071289063, -223.56741333008, 66.114479064941, false, false, 0)
				local vani4 = IsEntityInArea(NLopta, 800.35864257813, -227.17292785645, 66.114326477051, 788.35382080078, -217.53463745117, 66.114959716797, false, false, 0)
				local vani5 = IsEntityInArea(NLopta, 787.78033447266, -220.88629150391, 66.114471435547, 780.34973144531, -213.84632873535, 66.114959716797, false, false, 0)
				local vani6 = IsEntityInArea(NLopta, 780.99951171875, -217.38479614258, 66.116081237793, 773.98846435547, -210.69906616211, 66.114547729492, false, false, 0)
				local vani7 = IsEntityInArea(NLopta, 772.37475585938, -213.16264343262, 66.114471435547, 764.97894287109, -205.45324707031, 66.114463806152, false, false, 0)
				local vani8 = IsEntityInArea(NLopta, 763.12811279297, -208.49501037598, 66.114471435547, 750.32922363281, -199.26696777344, 66.114471435547, false, false, 0)
				local vani9 = IsEntityInArea(NLopta, 749.29156494141, -201.60958862305, 66.11450958252, 745.34820556641, -209.63987731934, 66.114524841309, false, false, 0)
				local vani10 = IsEntityInArea(NLopta, 745.86346435547, -207.70182800293, 66.114517211914, 742.31488037109, -214.99786376953, 66.114517211914, false, false, 0)
				local vani11 = IsEntityInArea(NLopta, 738.95184326172, -222.11335754395, 66.114456176758, 736.35113525391, -227.5719909668, 66.117561340332, false, false, 0)
				local vani12 = IsEntityInArea(NLopta, 736.35113525391, -227.5724029541, 66.117561340332, 732.294921875, -235.74157714844, 66.116310119629, false, false, 0)
				local vani13 = IsEntityInArea(NLopta, 732.35681152344, -236.11094665527, 66.115158081055, 741.30096435547, -240.63354492188, 66.115242004395, false, false, 0)
				local vani14 = IsEntityInArea(NLopta, 741.29437255859, -240.57112121582, 66.115280151367, 751.86920166016, -246.00730895996, 66.114280700684, false, false, 0)
				local vani15 = IsEntityInArea(NLopta, 751.86920166016, -246.00730895996, 66.114280700684, 761.90258789063, -251.17573547363, 66.114280700684, false, false, 0)
				local vani16 = IsEntityInArea(NLopta, 761.90258789063, -251.17573547363, 66.114280700684, 772.10485839844, -256.47100830078, 66.114280700684, false, false, 0)
				local vani17 = IsEntityInArea(NLopta, 772.10485839844, -256.47100830078, 66.114280700684, 779.69812011719, -260.39468383789, 66.114196777344, false, false, 0)
				local vani18 = IsEntityInArea(NLopta, 779.69812011719, -260.39468383789, 66.114196777344, 792.31658935547, -266.61093139648, 66.100509643555, false, false, 0)
				if gol then --gol od tima 2
					Cekaj = true
					FreezeEntityPosition(NLopta, true)
					SetEntityCoords(NLopta, 771.25549316406, -233.44470214844, 65.214479064941, 0, 0, 0, true)
					FreezeEntityPosition(NLopta, false)
					Tim1Score = Tim1Score+1
					TriggerServerEvent("nogomet:SyncajScore", Tim1Score, Tim2Score)
					TriggerServerEvent("nogomet:SaljiPoruku", "Gooool! Tim 1 je zabio timu 2!")
					--TriggerEvent("nogomet:VratiScore", Tim1Score, Tim2Score)
					Wait(100)
					Cekaj = false
				end
				if gol2 then --gol od tima 1
					Cekaj = true
					FreezeEntityPosition(NLopta, true)
					SetEntityCoords(NLopta, 771.25549316406, -233.44470214844, 65.214479064941, 0, 0, 0, true)
					FreezeEntityPosition(NLopta, false)
					Tim2Score = Tim2Score+1
					TriggerServerEvent("nogomet:SyncajScore", Tim1Score, Tim2Score)
					--TriggerEvent("nogomet:VratiScore", Tim1Score, Tim2Score)
					TriggerServerEvent("nogomet:SaljiPoruku", "Gooool! Tim 2 je zabio timu 1!")
					Wait(100)
					Cekaj = false
				end
				if vani or vani2 or vani3 or vani4 or vani5 or vani6 or vani7 or vani8 or vani9 or vani10 or vani11 or vani12 or vani13 or vani14 or vani15 or vani16 or vani17 or vani18 or vani19 or vani20 then
					TriggerServerEvent("nogomet:SaljiPoruku", "Lopta je izasla izvan terena! Spawnana je na sredini terena!")
					FreezeEntityPosition(NLopta, true)
					SetEntityCoords(NLopta, 771.25549316406, -233.44470214844, 65.214479064941, 0, 0, 0, true)
					FreezeEntityPosition(NLopta, false)
				end
			end
		end
	end
end