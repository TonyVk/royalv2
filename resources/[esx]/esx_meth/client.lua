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
local started = false
local displayed = false
local progress = 0
local CurrentVehicle 
local pause = false
local selection = 0
local quality = 0
ESX = nil

local LastCar

local GUI                       = {}

GUI.Time                        = 0
local Vozilo = nil
local Blip = nil
local Spawnovi = {
	{x = -1070.9866943359, y = -1669.6142578125, z = 3.9302122592926, h = 38.19}
}

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
		local waitara = 1000
		while true do
			local naso = 0
			local koord = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(koord, -1076.8598632813, -1677.7924804688, 4.575234413147, true) <= 20 then
				naso = 1
				waitara = 0
				DrawMarker(0, -1076.8598632813, -1677.7924804688, 4.575234413147, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
			end
			if GetDistanceBetweenCoords(koord, -1076.8598632813, -1677.7924804688, 4.575234413147, true) <= 2.0 then
				SetTextComponentFormat('STRING')
				AddTextComponentString("Pritisnite E da otvorite rent menu!")
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 150 then
					GUI.Time = GetGameTimer()
					local elements = {}
					table.insert(elements, {label = "Kamper(500$)", value = 'journey'})


					ESX.UI.Menu.Open(
					  'default', GetCurrentResourceName(), 'rentkam',
					  {
						title    = "Izaberite kamper",
						align    = 'top-left',
						elements = elements,
					  },
					  function(data, menu)
						ESX.TriggerServerCallback('rentkampera:ImalPara', function(platio)
							if platio then
								if Vozilo ~= nil then
									ESX.Game.DeleteVehicle(Vozilo)
									Vozilo = nil
								end
								local Mjesto = false
								for i=1, #Spawnovi, 1 do
									if ESX.Game.IsSpawnPointClear({
										x = Spawnovi[i].x,
										y = Spawnovi[i].y,
										z = Spawnovi[i].z
									}, 5.0) then
										Mjesto = true
										ESX.Game.SpawnVehicle(data.current.value, {
											x = Spawnovi[i].x,
											y = Spawnovi[i].y,
											z = Spawnovi[i].z
										}, Spawnovi[i].h, function(callback_vehicle)
											Vozilo = callback_vehicle
											TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
										end)
										TriggerServerEvent("rentkampera:SviSuTuljani")
										ESX.ShowNotification("Unrentati mozete sa /kunrent")
										break
									end
								end
								if Mjesto == false then
									ESX.ShowNotification("Trenutno nema slobodnog mjesta za gliser!")
								end
							else
								ESX.ShowNotification("Nemate dovoljno novca!")
							end
						end)
						menu.close()
					  end,
					  function(data, menu)
						menu.close()
					  end
					)
				end
			end
			
			local kordic = GetEntityCoords(PlayerPedId())
			if (GetDistanceBetweenCoords(-1913.9028320313, 1388.9566650391, 219.3586730957,  kordic.x,  kordic.y,  kordic.z,  true) <= 50.0) then
				waitara = 0
				naso = 1
				DrawMarker(27, -1913.9028320313, 1388.9566650391, 219.3586730957, 0, 0, 0, 0, 0, 0, 2.25, 2.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
			end
			
			local isInMarker  = false
			local currentZone = nil

			if(GetDistanceBetweenCoords(kordic, -1913.9028320313, 1388.9566650391, 219.3586730957, true) < 2.25) then
				isInMarker  = true
				currentZone = "prodaja"
			end
			
			if (GetDistanceBetweenCoords(1065.3234863281, -1999.6342773438, 30.907497406006,  kordic.x,  kordic.y,  kordic.z,  true) <= 50.0) then
				waitara = 0
				naso = 1
				DrawMarker(27, 1065.3234863281, -1999.6342773438, 29.907497406006, 0, 0, 0, 0, 0, 0, 2.25, 2.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
			end

			if(GetDistanceBetweenCoords(kordic, 1065.3234863281, -1999.6342773438, 30.907497406006, true) < 2.25) then
				isInMarker  = true
				currentZone = "kupimeth"
			end
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('meth:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('meth:hasExitedMarker', lastZone)
			end
			
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustPressed(0, 38) then
					if CurrentAction == 'prodaj' then
						TriggerServerEvent("meth:ProdajMeth")
					end
					if CurrentAction == 'kupimeth' then
						local torba = 0
						TriggerEvent('skinchanger:getSkin', function(skin)
							torba = skin['bags_1']
						end)
						if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
							TriggerServerEvent('meth:KupiMeth', true)	
						else
							TriggerServerEvent('meth:KupiMeth', false)	
						end
					end
					CurrentAction = nil
				end
			end
			
			if naso == 0 then
				waitara = 1000
			end
		Citizen.Wait(waitara)
		end
end)

AddEventHandler('meth:hasEnteredMarker', function(zone)
	if zone == 'prodaja' then
		CurrentAction     = 'prodaj'
        CurrentActionMsg  = "Pritisnite E da prodate meth!"
	elseif zone == "kupimeth" then
		CurrentAction     = 'kupimeth'
        CurrentActionMsg  = "Pritisnite E da kupite laboratorij za meth!"
	end
end)

AddEventHandler('meth:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

RegisterCommand("kunrent", function(source, args, rawCommandString)
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
		ESX.ShowNotification("Unrentali ste kamper!")
	else
		ESX.ShowNotification("Nemate rentan kamper!")
	end
end, false)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('esx_methcar:stop')
AddEventHandler('esx_methcar:stop', function()
	started = false
	DisplayHelpText("~r~Kuhanje prekinuto...")
	FreezeEntityPosition(LastCar, false)
end)
RegisterNetEvent('esx_methcar:stopfreeze')
AddEventHandler('esx_methcar:stopfreeze', function(id)
	FreezeEntityPosition(id, false)
end)
RegisterNetEvent('esx_methcar:notify')
AddEventHandler('esx_methcar:notify', function(message)
	ESX.ShowNotification(message)
end)

RegisterNetEvent('esx_methcar:startprod')
AddEventHandler('esx_methcar:startprod', function()
	DisplayHelpText("~g~Kuhanje zapoceto")
	started = true
	FreezeEntityPosition(CurrentVehicle,true)
	displayed = false
	print('Kuhanje metha zapoceto')
	ESX.ShowNotification("~r~Kuhanje metha zapoceto")	
	SetPedIntoVehicle(GetPlayerPed(-1), CurrentVehicle, 3)
	SetVehicleDoorOpen(CurrentVehicle, 2)
end)

RegisterNetEvent('esx_methcar:blowup')
AddEventHandler('esx_methcar:blowup', function(posx, posy, posz)
	AddExplosion(posx, posy, posz + 2,23, 20.0, true, false, 1.0, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(1)
		end
	end
	SetPtfxAssetNextCall("core")
	local fire = StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire", posx, posy, posz-0.8 , 0.0, 0.0, 0.0, 0.8, false, false, false, false)
	Citizen.Wait(6000)
	StopParticleFxLooped(fire, 0)
	
end)


RegisterNetEvent('esx_methcar:smoke')
AddEventHandler('esx_methcar:smoke', function(posx, posy, posz, bool)

	if bool == 'a' then

		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local smoke = StartParticleFxLoopedAtCoord("exp_grd_flare", posx, posy, posz + 1.7, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.8)
		SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
		Citizen.Wait(22000)
		StopParticleFxLooped(smoke, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end

end)
RegisterNetEvent('esx_methcar:drugged')
AddEventHandler('esx_methcar:drugged', function()
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)

	Citizen.Wait(300000)
	ClearTimecycleModifier()
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if IsPedInAnyVehicle(playerPed) then
			
			
			CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId())

			car = GetVehiclePedIsIn(playerPed, false)
			LastCar = GetVehiclePedIsUsing(playerPed)
	
			local model = GetEntityModel(CurrentVehicle)
			local modelName = GetDisplayNameFromVehicleModel(model)
			
			if modelName == 'JOURNEY' and car then
				
					if GetPedInVehicleSeat(car, -1) == playerPed then
						if started == false then
							if displayed == false then
								DisplayHelpText("Pritisni ~INPUT_THROW_GRENADE~ da bi zapoceli kuhanje metha")
								displayed = true
							end
						end
						if IsControlJustReleased(0, Keys['G']) then
							if pos.y >= 3500 then
								if IsVehicleSeatFree(CurrentVehicle, 3) then
									local torba = 0
									TriggerEvent('skinchanger:getSkin', function(skin)
										torba = skin['bags_1']
									end)
									if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
										TriggerServerEvent('esx_methcar:start', true)	
									else
										TriggerServerEvent('esx_methcar:start', false)	
									end
									progress = 0
									pause = false
									selection = 0
									quality = 0
									
								else
									DisplayHelpText('~r~Automobil je vec zauzet')
								end
							else
								ESX.ShowNotification('~r~Previse ste blizu grada, krenite dalje prema sjeveru da biste zapoceli proizvodnju metha')
							end
							
							
							
							
		
						end
					end
					
				
				
			
			end
			
		else

				
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('Zaustavljena kuhanje metha')
					FreezeEntityPosition(LastCar,false)
				end
		end
		
		if started == true then
			
			if progress < 96 then
				Citizen.Wait(6000)
				if not pause and IsPedInAnyVehicle(playerPed) then
					progress = progress +  1
					ESX.ShowNotification('~r~Kuhanje metha: ~g~~h~' .. progress .. '%')
					Citizen.Wait(6000) 
				end

				--
				--   EVENT 1
				--
				if progress > 22 and progress < 24 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Propanska cijev curi, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Popravite pomocu trake')
						ESX.ShowNotification('~o~2. Ne dirajte nista ')
						ESX.ShowNotification('~o~3. Zamijenite ga')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Traka je nekako zaustavila curenje')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Spremnik za propan je eksplodirao, a ti si zabrljao...')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('Zaustavljena proizvodnja metha')
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~Dobar posao, cijev nije bila u dobrom stanju')
						pause = false
						quality = quality + 5
					end
				end
				--
				--   EVENT 5
				--
				if progress > 30 and progress < 32 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Prosuli ste bocu acetona na pod, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Otvorite prozore da biste se rijesili mirisa')
						ESX.ShowNotification('~o~2. Necete nista uraditi')
						ESX.ShowNotification('~o~3. Stavite masku sa filterom za vazduh')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Otvorili ste prozore da biste se rijesili mirisa')
						quality = quality - 1
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Osjecate se lose od previse udisanja acetona')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~To je jednostavan nacin da se problem rijesi .. pretpostavljam')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 2
				--
				if progress > 38 and progress < 40 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Meth prebrzo postaje cvrst, sta uraditi? ')	
						ESX.ShowNotification('~o~1. Podignite pritisak')
						ESX.ShowNotification('~o~2. Podignite temperaturu')
						ESX.ShowNotification('~o~3. Smanjite pritisak')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Podigli ste pritisak i propan je poceo izlaziti, spustili ste ga i zasad je u redu')
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Podizanje temperature je pomoglo...')
						quality = quality + 5
						pause = false
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~Snizavanje pritiska samo ga je pogorsalo...')
						pause = false
						quality = quality -4
					end
				end
				--
				--   EVENT 8 - 3
				--
				if progress > 41 and progress < 43 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Slucajno ulijete previse acetona, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Ne radi nista')
						ESX.ShowNotification('~o~2. Pokusajte ga isisati pomocu sprica')
						ESX.ShowNotification('~o~3. Dodajte jos litijuma da to uravnotezite')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Vas meth se osjeti na aceton, sto nije dobro')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~To je nekako uspjelo, ali jos uvijek je previse')
						pause = false
						quality = quality - 1
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~Uspjesno ste uravnotezili i kemikalije i one su opet dobre')
						pause = false
						quality = quality + 3
					end
				end
				--
				--   EVENT 3
				--
				if progress > 46 and progress < 49 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Pronasli ste kofein u prahu, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Dodajte ga')
						ESX.ShowNotification('~o~2. Ostavite ga')
						ESX.ShowNotification('~o~3. Popijte ga')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Odlicna ideja, kofein poboljsava jacinu vaseg proizvoda')
						quality = quality + 4
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Da, to bi moglo unistiti kvalitet metha')
						pause = false
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~Pomalo ste cudni i vrti vam se u glavi, ali sve je u redu')
						pause = false
					end
				end
				--
				--   EVENT 4
				--
				if progress > 55 and progress < 58 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Filter je zacepljen, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Ocistite ga komprimiranim zrakom')
						ESX.ShowNotification('~o~2. Zamijenite filter')
						ESX.ShowNotification('~o~3. Ocistite ga cetkicom za zube')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Komprimirani zrak rasprsio je tekuci meth po vama')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Zamjena je vjerojatno najbolja opcija')
						pause = false
						quality = quality + 3
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~Ovo je djelovalo prilicno dobro, ali jos uvijek je nekako prljavo')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 5
				--
				if progress > 58 and progress < 60 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Prosuli ste bocu acetona na pod, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Otvorite prozore da biste se rijesili mirisa')
						ESX.ShowNotification('~o~2. Necete nista uraditi')
						ESX.ShowNotification('~o~3. Stavite masku sa filterom za vazduh')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Otvorili ste prozore da biste se rijesili mirisa')
						quality = quality - 1
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Osjecate se lose od previse udisanja acetona')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						print("Opcija3")
						ESX.ShowNotification('~r~To je jednostavan nacin da se problem rijesi .. pretpostavljam')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 1 - 6
				--
				if progress > 63 and progress < 65 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Propanska cijev curi, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Popravite pomocu trake')
						ESX.ShowNotification('~o~2. Ne dirajte nista')
						ESX.ShowNotification('~o~3. Zamijenite ga')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Traka je nekako zaustavila curenje')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Spremnik za propan je eksplodirao, zabrljali ste ...')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('Prestali ste kuhati meth')
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~Dobar posao, cijev nije bila u dobrom stanju')
						pause = false
						quality = quality + 5
					end
				end
				--
				--   EVENT 4 - 7
				--
				if progress > 71 and progress < 73 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Filter je zacepljen, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Ocistite ga komprimiranim zrakom')
						ESX.ShowNotification('~o~2. Zamijenite filter')
						ESX.ShowNotification('~o~3. Ocistite ga cetkicom za zube')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Komprimirani zrak rasprsio je tekuci meth po vama')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Zamjena je vjerojatno najbolja opcija')
						pause = false
						quality = quality + 3
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~Ovo je djelovalo prilično dobro, ali jos uvijek je nekako prljavo')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 8
				--
				if progress > 76 and progress < 78 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Slucajno ulijete previse acetona, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Ne radi nista')
						ESX.ShowNotification('~o~2. Pokusajte ga isisati pomocu sprica')
						ESX.ShowNotification('~o~3. Dodajte jos litijuma da to uravnotezite')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Vas meth se osjeti na aceton, sto nije dobro')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~To je nekako uspjelo, ali jos uvijek je previse')
						pause = false
						quality = quality - 1
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~Uspjesno ste uravnotezili i kemikalije i one su opet dobre')
						pause = false
						quality = quality + 3
					end
				end
				--
				--   EVENT 9
				--
				if progress > 82 and progress < 84 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Trebate se ici posrati, sta cete uraditi?')	
						ESX.ShowNotification('~o~1. Strpit cete se')
						ESX.ShowNotification('~o~2. Izadite van i poserite se iza gume')
						ESX.ShowNotification('~o~3. Poserite se unutra')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Dobar posao, prvo treba raditi, sranje kasnije')
						quality = quality + 1
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Dok ste bili vani, casa je pala sa stola i prosula se po podu ...')
						pause = false
						quality = quality - 2
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~Zrak sada smrdi na sranje, meth se osjeti na vasa govna')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 10
				--
				if progress > 88 and progress < 90 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Dodajete li nekoliko komada stakla methu, tako da izgleda da ga imate vise?')	
						ESX.ShowNotification('~o~1. Da!')
						ESX.ShowNotification('~o~2. Ne')
						ESX.ShowNotification('~o~3. Sta ce se desiti ako dodam dvije kese stakla u meth?')
						ESX.ShowNotification('~c~Pritisnite broj opcije koju zelite uciniti')
					end
					if selection == 1 then
						print("Opcija 1")
						ESX.ShowNotification('~r~Sad ste izvukli jos nekoliko vrecica')
						quality = quality + 1
						pause = false
					end
					if selection == 2 then
						print("Opcija 2")
						ESX.ShowNotification('~r~Dobar ste proizvodac lijekova, vas je proizvod visoke kvalitete')
						pause = false
						quality = quality + 1
					end
					if selection == 3 then
						print("Opcija 3")
						ESX.ShowNotification('~r~To je malo previse, vise je stakla od metha, ali ok')
						pause = false
						quality = quality - 1
					end
				end
				
				
				
				
				
				
				
				if IsPedInAnyVehicle(playerPed) then
					TriggerServerEvent('esx_methcar:make', pos.x,pos.y,pos.z)
					if pause == false then
						selection = 0
						quality = quality + 1
						progress = progress +  math.random(1, 2)
						ESX.ShowNotification('~r~Kuhanje metha: ~g~~h~' .. progress .. '%')
					end
				else
					TriggerEvent('esx_methcar:stop')
				end

			else
				TriggerEvent('esx_methcar:stop')
				progress = 100
				ESX.ShowNotification('~r~Kuhanje metha: ~g~~h~' .. progress .. '%')
				ESX.ShowNotification('~g~~h~Kuhanje zavrseno')
				TriggerServerEvent('esx_methcar:finish', quality)
				FreezeEntityPosition(LastCar, false)
			end	
			
		end
		
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			else
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('Kuhanje prekinuto')
					FreezeEntityPosition(LastCar,false)
				end		
			end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)		
		if pause == true then
			if IsControlJustReleased(0, Keys['1']) then
				selection = 1
				ESX.ShowNotification('~g~Odabrana opcija broj 1')
			end
			if IsControlJustReleased(0, Keys['2']) then
				selection = 2
				ESX.ShowNotification('~g~Odabrana opcija broj 2')
			end
			if IsControlJustReleased(0, Keys['3']) then
				selection = 3
				ESX.ShowNotification('~g~Odabrana opcija broj 3')
			end
		end

	end
end)




