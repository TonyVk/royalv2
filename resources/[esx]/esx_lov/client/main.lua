ESX                             = nil

local hasAlreadyEnteredMarker = false
local lastZone                = nil

local CurrentAction           = nil
local CurrentActionMsg        = ''
local Time                    = 0

local Lovis = false
local Zivotinja = nil
local zBlip = nil
local ZadnjiRand = -1
local Vozilo = nil
local BrojZivotinja = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

local spojen = false
AddEventHandler("playerSpawned", function()
	if not spojen then
		UcitajBlipove()
		spojen = true
	end
end)

function UcitajBlipove()
	local StartBlip = AddBlipForCoord(-769.23773193359, 5595.6215820313, 33.48571395874)
	SetBlipSprite(StartBlip, 442)
	SetBlipColour(StartBlip, 75)
	SetBlipScale(StartBlip, 0.7)
	SetBlipAsShortRange(StartBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Lovacko drustvo')
	EndTextCommandSetBlipName(StartBlip)
	
	StartBlip = AddBlipForCoord(969.16375732422, -2107.9033203125, 31.475671768188)
	SetBlipSprite(StartBlip, 442)
	SetBlipColour(StartBlip, 75)
	SetBlipScale(StartBlip, 0.7)
	SetBlipAsShortRange(StartBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Prodaja mesa')
	EndTextCommandSetBlipName(StartBlip)
end

local Zivotinje = {
	vector3(-1505.2, 4887.39, 78.38),
	vector3(-1164.68, 4806.76, 223.11),
	vector3(-1410.63, 4730.94, 44.0369),
	vector3(-1377.29, 4864.31, 134.162),
	vector3(-1697.63, 4652.71, 22.2442),
	vector3(-1259.99, 5002.75, 151.36),
	vector3(-960.91, 5001.16, 183.0)
}

local AnimalsInSession = {}

AddEventHandler('esx_lov:hasEnteredMarker', function(zone)
	if zone == 'lov' then
		CurrentAction     = 'lov'
		if not Lovis then
			CurrentActionMsg  = "Pritisnite E da zapocnete loviti (250$)"
		else
			CurrentActionMsg  = "Pritisnite E da zavrsite sa lovom"
		end
	end
	
	if zone == 'prodaja' then
		CurrentAction     = 'prodaja'
		CurrentActionMsg  = "Pritisnite E da prodate meso i kožu"
	end
end)

AddEventHandler('esx_lov:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

local lov = vector3(-769.23773193359, 5595.6215820313, 32.48571395874)
local sell = vector3(969.16375732422, -2107.9033203125, 30.475671768188)

Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil
			
		if #(coords-lov) < 2.0 then
			isInMarker  = true
			currentZone = "lov"
		end
		
		if #(coords-sell) < 2.0 then
			isInMarker  = true
			currentZone = "prodaja"
		end
			
		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone                = currentZone
			TriggerEvent('esx_lov:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_lov:hasExitedMarker', lastZone)
		end
		
		if #(coords-lov) < 50.0 then
			waitara = 0
			naso = 1
			DrawMarker(1, lov, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
		end
		
		if #(coords-sell) < 50.0 then
			waitara = 0
			naso = 1
			DrawMarker(1, sell, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
		end
			
		if CurrentAction ~= nil then
			waitara = 0
			naso = 1
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			
			if IsControlPressed(0,  38) and (GetGameTimer() - Time) > 150 then
				if CurrentAction == 'lov' then
					PokreniLov()
				end

				if CurrentAction == 'prodaja' then
					TriggerServerEvent('esx_lov:prodajtuljana')
				end

				CurrentAction = nil
				Time      = GetGameTimer()
			end
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)

function PokreniLov()
	if Lovis then
		Lovis = false
		RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HEAVYSNIPER"), true, true)
		RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), true, true)
		if DoesEntityExist(Zivotinja) then
			DeleteEntity(Zivotinja)
		end
		if zBlip ~= nil then
			RemoveBlip(zBlip)
		end
		if Vozilo ~= nil then
			ESX.Game.DeleteVehicle(Vozilo)
			Vozilo = nil
		end
		ESX.ShowNotification("Zavrsili ste sa lovom!")
	else
		ESX.TriggerServerCallback('ex_lov:ImasLiLove', function(imal)
			if imal then
				Lovis = true
				BrojZivotinja = 0
				ESX.ShowNotification("Zapoceli ste lov na zivotinje. Imate pravo na 5 zivotinja!")
				GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HEAVYSNIPER"),45, true, false)
				GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"),0, true, false)
				RequestModel(GetHashKey('a_c_deer'))
				while not HasModelLoaded(GetHashKey('a_c_deer')) do
					RequestModel(GetHashKey('a_c_deer'))
					Citizen.Wait(10)
				end
				local rand = math.random(#Zivotinje)
				ZadnjiRand = rand
				Zivotinja = CreatePed(5, GetHashKey('a_c_deer'), Zivotinje[rand].x, Zivotinje[rand].y, Zivotinje[rand].z, 0.0, false, false)
				TaskWanderStandard(Zivotinja, true, true)
				SetEntityAsMissionEntity(Zivotinja, true, true)

				zBlip = AddBlipForEntity(Zivotinja)
				SetBlipSprite(zBlip, 153)
				SetBlipColour(zBlip, 1)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Jelen')
				EndTextCommandSetBlipName(zBlip)
				SetModelAsNoLongerNeeded(GetHashKey('a_c_deer'))
				ESX.Game.SpawnVehicle("sanchez", {
					x = -769.63067626953,
					y = 5592.7573242188,
					z = 33.48571395874
				}, 169.79, function(callback_vehicle)
					Vozilo = callback_vehicle
					TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
				end)
				Citizen.CreateThread(function()
					while Lovis do
						local sleep = 500
						local PlyCoords = GetEntityCoords(PlayerPedId())
						if DoesEntityExist(Zivotinja) then
							local AnimalCoords = GetEntityCoords(Zivotinja)
							local AnimalHealth = GetEntityHealth(Zivotinja)
								
							local PlyToAnimal = #(PlyCoords-AnimalCoords)

							if AnimalHealth <= 0 then
								SetBlipColour(zBlip, 3)
								if PlyToAnimal < 2.0 then
									sleep = 5

									ESX.Game.Utils.DrawText3D({x = AnimalCoords.x, y = AnimalCoords.y, z = AnimalCoords.z + 1}, 'Pritisnite E da raskomadate zivotinju', 0.4)

									if IsControlJustReleased(0, 38) then
										if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE')  then
											if DoesEntityExist(Zivotinja) then
												Raskomadaj(Zivotinja, zBlip)
											end
										else
											ESX.ShowNotification('Morate koristiti nož!')
										end
									end
								end
							end
						end
						if IsEntityDead(PlayerPedId()) then
							Lovis = false
							RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HEAVYSNIPER"), true, true)
							RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), true, true)
							if DoesEntityExist(Zivotinja) then
								DeleteEntity(Zivotinja)
							end
							if zBlip ~= nil then
								RemoveBlip(zBlip)
							end
							if Vozilo ~= nil then
								ESX.Game.DeleteVehicle(Vozilo)
								Vozilo = nil
							end
							ESX.ShowNotification("Umrli ste i zavrsili sa lovom!")
						end
						if PlyCoords.x < -2000.0 or PlyCoords.x > -500.0 then
							ESX.ShowNotification("Napustili ste zonu lova, te vam je vozilo i oruzje oduzeto!")
							RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HEAVYSNIPER"), true, true)
							RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), true, true)
							if DoesEntityExist(Zivotinja) then
								DeleteEntity(Zivotinja)
							end
							if zBlip ~= nil then
								RemoveBlip(zBlip)
							end
							if Vozilo ~= nil then
								ESX.Game.DeleteVehicle(Vozilo)
								Vozilo = nil
							end
						end
						Citizen.Wait(sleep)
					end
				end)
			else
				ESX.ShowNotification("Nemate dovoljno novca!")
			end
		end)
	end
end

function Raskomadaj(id, blip)
	LoadAnimDict('amb@medic@standing@kneel@base')
	LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
	TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

	Citizen.Wait(5000)
	RemoveAnimDict('amb@medic@standing@kneel@base')
	RemoveAnimDict('anim@gangops@facility@servers@bodysearch@')
	ClearPedTasksImmediately(PlayerPedId())

	TriggerServerEvent('esx_lov:dajtuljana')

	RemoveBlip(blip)
	DeleteEntity(id)
	BrojZivotinja = BrojZivotinja+1
	if BrojZivotinja < 5 then
		RequestModel('a_c_deer')
		while not HasModelLoaded('a_c_deer') do
			RequestModel('a_c_deer')
			Citizen.Wait(10)
		end
		local rand = math.random(#Zivotinje)
		if ZadnjiRand ~= -1 then
			while ZadnjiRand == rand do
				rand = math.random(#Zivotinje)
				Wait(50)
			end
		end
		ZadnjiRand = rand
		Zivotinja = CreatePed(5, GetHashKey('a_c_deer'), Zivotinje[rand].x, Zivotinje[rand].y, Zivotinje[rand].z, 0.0, true, false)
		TaskWanderStandard(Zivotinja, true, true)
		SetEntityAsMissionEntity(Zivotinja, true, true)

		zBlip = AddBlipForEntity(Zivotinja)
		SetBlipSprite(zBlip, 153)
		SetBlipColour(zBlip, 1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Jelen')
		EndTextCommandSetBlipName(zBlip)
		SetModelAsNoLongerNeeded(GetHashKey('a_c_deer'))
	else
		ESX.ShowNotification("Ubili ste 5 zivotinja, vratite se do lovackog drustva kako bih ste ostavili vozilo i oruzje ili produzili clanarinu!")
	end
end

function LoadAnimDict(dict)
	RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end