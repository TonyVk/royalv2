local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local Zone						= {}
local Mafije 					= {}
local Mere 						= false
local Osvajam 					= Config.VrijemeZauzimanja --minute do osvajanja
local Zauzima					= false

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  while ESX.GetPlayerData().job == nil do
	Citizen.Wait(100)
  end
  Wait(5000)
  ProvjeriPosao()
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
	ESX.TriggerServerCallback('zone:DohvatiZone', function(data)
		Zone = data.zone
		Mafije = data.maf
	end)
	Wait(5000)
	SpawnBlipove()
end

function SpawnBlipove()
	while Zone == nil do
		Wait(100)
	end
	local naso = false
	for i=1, #Mafije, 1 do
		if PlayerData.job.name == Mafije[i].Ime then
			naso = true
			break
		end
	end
	if naso then
		Mere = true
		for i=1, #Zone, 1 do
			if Zone[i] ~= nil then
				if Zone[i].ID == nil then
					local a = tonumber(Zone[i].Velicina)+0.0
					local VBlip = AddBlipForArea(Zone[i].Koord.x, Zone[i].Koord.y, Zone[i].Koord.z, a, a)
					SetBlipRotation(VBlip, Zone[i].Rotacija)
					SetBlipColour (VBlip, Zone[i].Boja)
					SetBlipAlpha(VBlip, 115)
					SetBlipAsShortRange(VBlip, true)
					SetBlipDisplay(VBlip, 8)
					Zone[i].ID = VBlip
				end
			end
		end
	end
end

RegisterNetEvent("zone:SpawnZonu")
AddEventHandler('zone:SpawnZonu', function(ime, koord, vel, rot)
	table.insert(Zone, {ID = nil, Ime = ime, Koord = koord, Velicina = vel, Rotacija = rot})
	if PlayerData.job ~= nil then
		SpawnBlipove()
	end
end)

RegisterNetEvent("zone:DodajMafiju")
AddEventHandler('zone:DodajMafiju', function(ime, boja)
	table.insert(Mafije, {Ime = ime, Boja = boja})
	if PlayerData.job ~= nil then
		if PlayerData.job.name == ime then
			SpawnBlipove()
		end
	end
end)

RegisterNetEvent("zone:SmanjiVrijeme")
AddEventHandler('zone:SmanjiVrijeme', function(ime, vrijeme)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				Zone[i].Vrijeme = vrijeme
				break
			end
		end
	end
end)

RegisterNetEvent("zone:UpdateZonu")
AddEventHandler('zone:UpdateZonu', function(ime, koord, rot)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				Zone[i].Koord = koord
				Zone[i].Rotacija = rot
				local naso = false
				for a=1, #Mafije, 1 do
					if PlayerData.job.name == Mafije[a].Ime then
						naso = true
						break
					end
				end
				if naso then
					SetBlipRotation(Zone[i].ID, rot)
					SetBlipCoords(Zone[i].ID, koord.x, koord.y, koord.z)
				end
				break
			end
		end
	end
end)

RegisterNetEvent("zone:NapadnutaZona")
AddEventHandler('zone:NapadnutaZona', function(ime, br, vr)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				if br then
					SetBlipFlashes(Zone[i].ID, true)
					if Zone[i].Vlasnik == PlayerData.job.name then
						ESX.ShowNotification("[Teritoriji] Vas teritorij je napadnut!")
					end
				else
					SetBlipFlashes(Zone[i].ID, false)
					Zone[i].Vrijeme = vr
				end
				break
			end
		end
	end
end)

RegisterNetEvent("zone:UpdateBoju")
AddEventHandler('zone:UpdateBoju', function(ime, boja, maf)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				Zone[i].Boja = boja
				Zone[i].Vlasnik = maf
				local naso = false
				for a=1, #Mafije, 1 do
					if PlayerData.job.name == Mafije[a].Ime then
						naso = true
						break
					end
				end
				if naso then
					SetBlipColour(Zone[i].ID, boja)
				end
				break
			end
		end
	end
end)

RegisterNetEvent("zone:ObrisiZonu")
AddEventHandler('zone:ObrisiZonu', function(ime)
	for i=1, #Zone, 1 do
		if Zone[i] ~= nil then
			if Zone[i].Ime == ime then
				local naso = false
				for a=1, #Mafije, 1 do
					if PlayerData.job.name == Mafije[a].Ime then
						naso = true
						break
					end
				end
				if naso then
					RemoveBlip(Zone[i].ID)
					Zone[i].ID = nil
				end
				table.remove(Zone, i)
				break
			end
		end
	end
end)

RegisterNetEvent("zone:ObrisiMafiju")
AddEventHandler('zone:ObrisiMafiju', function(ime)
	for i=1, #Mafije, 1 do
		if Mafije[i] ~= nil then
			if Mafije[i].Ime == ime then
				if PlayerData.job.name == Mafije[i].Ime then
					for a=1, #Zone, 1 do
						if Zone[a] ~= nil then
							RemoveBlip(Zone[a].ID)
							Zone[i].ID = nil
						end
					end
				end
				table.remove(Mafije, i)
				break
			end
		end
	end
end)

RegisterCommand("uredizone", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			ESX.UI.Menu.CloseAll()
			local elements = {
				{label = "Lista zona", value = "lzona"},
				{label = "Dodaj zonu", value = "nzona"},
				{label = "Uredi postavke", value = "postavke"}
			}

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'uzone',
				{
					title    = "Izaberite opciju",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)
					if data.current.value == "nzona" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vzone', {
							title = "Upisite velicinu zone(npr. 100.0)",
						}, function (datari, menuri)
							local vZone = datari.value
							if vZone == nil then
								ESX.ShowNotification('Greska.')
							else
								local a = tonumber(vZone)+0.0
								local coords = GetEntityCoords(PlayerPedId())
								local retval = GetEntityRotation(PlayerPedId(), 2)
								TriggerServerEvent("zone:DodajZonu", coords, a, Ceil(retval.z))
								menuri.close()
								menu.close()
							end
						end, function (datari, menuri)
							menuri.close()
						end)
					elseif data.current.value == "lzona" then
						local elements = {}
						for i=1, #Zone, 1 do
							if Zone[i] ~= nil then
								table.insert(elements, {label = Zone[i].Ime, value = Zone[i].Ime})
							end
						end
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'lzone',
							{
								title    = "Izaberite zonu",
								align    = 'top-left',
								elements = elements,
							},
							function(data2, menu2)
								local elements = {
									{label = "Premjesti zonu", value = "premj"},
									{label = "Obrisi zonu", value = "brisi"}
								}
								ESX.UI.Menu.Open(
									'default', GetCurrentResourceName(), 'lzone2',
									{
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									},
									function(data3, menu3)
										if data3.current.value == "premj" then
											local korda = GetEntityCoords(PlayerPedId())
											local retval = GetEntityRotation(PlayerPedId(), 2)
											TriggerServerEvent("zone:Premjesti", data2.current.value, korda, Ceil(retval.z))
											menu3.close()
											ESX.ShowNotification("Premjestili ste zonu "..data2.current.value)
										else
											TriggerServerEvent("zone:Obrisi", data2.current.value)
											menu3.close()
											menu2.close()
											ESX.ShowNotification("Obrisali ste zonu "..data2.current.value)
										end
									end,
									function(data3, menu3)
										menu3.close()
									end
								)
							end,
							function(data2, menu2)
								menu2.close()
							end
						)
					else
						local elements = {
							{label = "Uredi mafije", value = "maf"},
							{label = "Uredi vrijeme do ponovnog osvajanja", value = "vrij"}
						}
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'pzone',
							{
								title    = "Izaberite opciju",
								align    = 'top-left',
								elements = elements,
							},
							function(data4, menu4)
								if data4.current.value == "maf" then
									local elements = {
										{label = "Dodaj mafiju", value = "dodaj"},
										{label = "Obrisi mafiju", value = "obr"}
									}
									ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'pmzone6',
										{
											title    = "Izaberite opciju",
											align    = 'top-left',
											elements = elements,
										},
										function(data7, menu7)
											if data7.current.value == "dodaj" then
												ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pmzone', {
													title = "Upisite ime mafije(job_name)",
												}, function (data5, menu5)
													local vIme = data5.value
													if vIme == nil then
														ESX.ShowNotification('Greska.')
													else
														local ime = vIme
														menu5.close()
														ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pmzoneaaa', {
															title = "Upisite ID blip boje",
														}, function (data69, menu69)
															local vBoja = data69.value
															if vBoja == nil or tonumber(vBoja) < 0 then
																ESX.ShowNotification('Greska.')
															else
																TriggerServerEvent("zone:DodajMafiju", ime, tonumber(vBoja))
																menu69.close()
															end
														end, function (data69, menu69)
															menu69.close()
														end)
													end
												end, function (data5, menu5)
													menu5.close()
												end)
											else
												local elements = {}
												for i=1, #Mafije, 1 do
													if Mafije[i] ~= nil then
														table.insert(elements, {label = Mafije[i].Ime, value = Mafije[i].Ime})
													end
												end
												ESX.UI.Menu.Open(
													'default', GetCurrentResourceName(), 'pmzone7',
													{
														title    = "Izaberite mafiju",
														align    = 'top-left',
														elements = elements,
													},
													function(data8, menu8)
														TriggerServerEvent("zone:ObrisiMafiju", data8.current.value)
														ESX.ShowNotification("Obrisali ste mafiju "..data8.current.value)
														menu8.close()
													end,
													function(data8, menu8)
														menu8.close()
													end
												)
											end
										end,
										function(data7, menu7)
											menu7.close()
										end
									)
								else
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pvzone', {
										title = "Upisite sate do ponovnog osvajanja",
									}, function (data6, menu6)
										local vBr = data6.value
										if vBr == nil or tonumber(vBr) <= 0 then
											ESX.ShowNotification('Greska.')
										else
											TriggerServerEvent("zone:UrediVrijeme", vBr)
											ESX.ShowNotification("Promjenili ste vrijeme do ponovnog osvajanja na "..vBr.." sati!")
											menu6.close()
										end
									end, function (data6, menu6)
										menu6.close()
									end)
								end
							end,
							function(data4, menu4)
								menu4.close()
							end
						)
					end
				end,
				function(data, menu)
					menu.close()
				end
			)
		end
	end)
end, false)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	local naso = false
	for i=1, #Mafije, 1 do
		if job.name == Mafije[i].Ime then
			naso = true
			break
		end
	end
	if naso then
		Mere = true
		for i=1, #Zone, 1 do
			if Zone[i] ~= nil then
				if Zone[i].ID == nil then
					local a = tonumber(Zone[i].Velicina)+0.0
					local VBlip = AddBlipForArea(Zone[i].Koord.x, Zone[i].Koord.y, Zone[i].Koord.z, a, a)
					SetBlipRotation(VBlip, Zone[i].Rotacija)
					SetBlipColour (VBlip, Zone[i].Boja)
					SetBlipAlpha(VBlip, 115)
					SetBlipAsShortRange(VBlip, true)
					SetBlipDisplay(VBlip, 8)
					Zone[i].ID = VBlip
				end
			end
		end
	else
		Mere = false
		for i=1, #Zone, 1 do
			if Zone[i] ~= nil then
				if Zone[i].ID ~= nil then
					RemoveBlip(Zone[i].ID)
					Zone[i].ID = nil
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local waitara = 5000
	while true do
		Citizen.Wait(waitara)
		while PlayerData.job == nil do
			Wait(100)
		end
		if Mere then
			waitara = 5000
			for i=1, #Zone, 1 do
				if Zone[i] ~= nil then
					local korda = GetEntityCoords(PlayerPedId())
					if #(korda-Zone[i].Koord) <= tonumber(Zone[i].Velicina)/2 then
						SetBlipDisplay(Zone[i].ID, 8)
					else
						SetBlipDisplay(Zone[i].ID, 3)
					end
				end
			end
		else
			waitara = 10000
		end
	end
end)

AddEventHandler('zone:hasEnteredMarker', function(station, part, partNum)
  if part == 'Zona' then
    CurrentAction     = 'Zona'
    CurrentActionMsg  = "Pritisnite E da zapocnete sa osvajanjem zone"
    CurrentActionData = {zona = partNum}
  end
end)

AddEventHandler('zone:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
  local waitara = 500
  while true do
    Citizen.Wait(waitara)
	local naso = 0
	if PlayerData.job ~= nil and Mere then
		if CurrentAction ~= nil then
		  waitara = 0
		  naso = 1
		  
		  SetTextComponentFormat('STRING')
		  AddTextComponentString(CurrentActionMsg)
		  DisplayHelpTextFromStringLabel(0, 0, 1, -1)

		  if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 150 then
			if CurrentAction == 'Zona' then
				local id = CurrentActionData.zona
				ESX.TriggerServerCallback('zone:JelZauzeta', function(br)
					if not br then
						if Zone[id].Vlasnik == nil or Zone[id].Vlasnik ~= PlayerData.job.name then
							if Zone[id].Vrijeme == 0 then
								Osvajam = Config.VrijemeZauzimanja
								TriggerServerEvent("zone:ZapocniZauzimanje", Zone[id].Ime)
								Zauzima = true
								ESX.ShowNotification("Zapoceli ste sa zauzimanjem teritorija!")
								Citizen.CreateThread(function ()
									local sec = Osvajam*60
									local br = 0
									while sec > 0 and #(GetEntityCoords(PlayerPedId())-Zone[id].Koord) <= tonumber(Zone[id].Velicina)/2 do
										Citizen.Wait(1000)
										sec = sec-1
										br = br+1
										if br == 60 then
											br = 0
											Osvajam = Osvajam-1
											ESX.ShowNotification("Do osvajanja vam je preostalo jos "..Osvajam.." minuta!")
										end
									end
									if not IsEntityDead(PlayerPedId()) and #(GetEntityCoords(PlayerPedId())-Zone[id].Koord) <= tonumber(Zone[id].Velicina)/2 then
										local boja = 0
										for i=1, #Mafije, 1 do
											if PlayerData.job.name == Mafije[i].Ime then
												boja = Mafije[i].Boja
												break
											end
										end
										Zauzima = false
										TriggerServerEvent("zone:ZavrsiZauzimanje", Zone[id].Ime)
										ESX.ShowNotification("Uspjesno ste osvojili teritorij!")
										TriggerServerEvent("zone:UpdateBoju", Zone[id].Ime, boja, PlayerData.job.name)
									else
										Zauzima = false
										ESX.ShowNotification("Niste uspjeli osvojiti teritorij!")
										TriggerServerEvent("zone:ZavrsiZauzimanje", Zone[id].Ime)
									end
								end)
							else
								ESX.ShowNotification("Ova zona se ne može zauzimati još "..Zone[id].Vrijeme.." minuta!")
							end
						else
							ESX.ShowNotification("Ovo je vasa zona!")
						end
					else
						ESX.ShowNotification("Netko vec zauzima teritorij!")
					end
				end, Zone[id].Ime)
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
		if not Zauzima then
			for i=1, #Zone, 1 do
				if Zone[i] ~= nil then
					if #(coords-Zone[i].Koord) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(31, Zone[i].Koord.x, Zone[i].Koord.y, Zone[i].Koord.z+0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
					end
					if #(coords-Zone[i].Koord) < 1.5 then
						isInMarker     = true
						currentStation = 1
						currentPart    = 'Zona'
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
				TriggerEvent('zone:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('zone:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			waitara = 0
			naso = 1
			HasAlreadyEnteredMarker = false

			TriggerEvent('zone:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end

    end
	
	if naso == 0 then
		waitara = 500
	end
  end
end)
