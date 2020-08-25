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
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0
local SpawnajDropMarker 		= false
local DropCoord
local PokupioCrate 				= false
local DostavaBlip 				= nil
local ZatrazioOruzje = {}
local ZOBr = 0
local BVozilo 					= nil
local Mafije = {}
local Rankovi = {}
local Koord = {}
local Vozila = {}
local Oruzja = {}
local Blipovi = {}
local Boje = {}
local OruzarnicaMenu = false
local Vratio = nil

local parachute, crate, pickup, blipa, soundID
local requiredModels = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "prop_box_wood05a"} -- parachute, pickup case, plane, pilot, crate

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
	ESX.TriggerServerCallback('mafije:DohvatiMafije', function(mafija)
		Mafije = mafija.maf
		Koord = mafija.kor
		Vozila = mafija.voz
		Oruzja = mafija.oruz
		Boje = mafija.boj
		Rankovi = mafija.rank
	end)
	Wait(5000)
	if Config.Blipovi == true then
		SpawnBlipove()
	end
end

function SpawnBlipove()
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil and Koord[i].Ime == "Lider" then
			local x,y,z = table.unpack(Koord[i].Coord)
			if x ~= 0 and x ~= nil then
				Blipovi[Koord[i].Mafija] = AddBlipForCoord(x,y,z)

				SetBlipSprite (Blipovi[Koord[i].Mafija], 378)
				SetBlipDisplay(Blipovi[Koord[i].Mafija], 4)
				SetBlipScale  (Blipovi[Koord[i].Mafija], 1.2)
				for a=1, #Boje, 1 do
					if Boje[a] ~= nil and Boje[a].Mafija == Koord[i].Mafija and Boje[a].Ime == "Blip" then
						SetBlipColour(Blipovi[Koord[i].Mafija], tonumber(Boje[a].Boja))
						break
					end
				end
				SetBlipAsShortRange(Blipovi[Koord[i].Mafija], true)

				BeginTextCommandSetBlipName("STRING")
				for j=1, #Mafije, 1 do
					if Mafije[j] ~= nil and Mafije[j].Ime == Koord[i].Mafija then
						AddTextComponentString(firstToUpper(Mafije[j].Label))
						break
					end
				end
				--AddTextComponentString(firstToUpper(Koord[i].Mafija))
				EndTextCommandSetBlipName(Blipovi[Koord[i].Mafija])
			end
		end
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 2,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
	windowTint      = 1,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

RegisterCommand("uredimafiju", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			local elements = {}
			
			for i=1, #Mafije, 1 do
				if Mafije[i] ~= nil then
					table.insert(elements, {label = Mafije[i].Label, value = Mafije[i].Ime})
				end
			end
			
			table.insert(elements, {label = "Kreiraj mafiju", value = "novamaf"})

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'umafiju',
				{
					title    = "Izaberite mafiju",
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)
					if data.current.value == "novamaf" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
							title = "Upisite ime mafije",
						}, function (datari, menuri)
							local mIme = datari.value
														
							if mIme == nil then
								ESX.ShowNotification('Greska.')
							else
								menuri.close()
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ranklabel', {
									title = "Upisite label mafije",
								}, function (datarl, menurl)
									local mLabel = datarl.value
																
									if mLabel == nil then
										ESX.ShowNotification('Greska.')
									else
										menurl.close()
										menu.close()
										TriggerServerEvent("mafije:NapraviMafiju", mIme, mLabel)
									end
								end, function (datarl, menurl)
									menurl.close()
								end)
							end
						end, function (datari, menuri)
							menuri.close()
						end)
					else
						local ImeMafije = data.current.value
						elements = {}
						table.insert(elements, {label = "Rankovi", value = "rankovi"})
						table.insert(elements, {label = "Vozila", value = "vozila"})
						table.insert(elements, {label = "Oruzja", value = "oruzja"})
						table.insert(elements, {label = "Koordinate", value = "koord"})
						table.insert(elements, {label = "Boje", value = "boje"})
						--table.insert(elements, {label = "Promjeni ime", value = "ime"})
						table.insert(elements, {label = "Obrisi mafiju", value = "obrisi"})
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'umafiju2',
							{
								title    = "Izaberite opciju",
								align    = 'top-left',
								elements = elements,
							},
							function(data2, menu2)
								if data2.current.value == "rankovi" then
									elements = {}
									
									for i=1, #Rankovi, 1 do
										if Rankovi[i] ~= nil and Rankovi[i].Mafija == ImeMafije then
											table.insert(elements, {label = Rankovi[i].Ime, value = Rankovi[i].ID})
										end
									end
									
									table.insert(elements, {label = "Napravi novi rank", value = "novi"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == 'novi' then
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
												title = "Upisite rank ID",
											}, function (datar, menur)
												local rID = tonumber(datar.value)
												
												if rID == nil then
													ESX.ShowNotification('Greska.')
												else
													menur.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite ime ranka",
													}, function (datari, menuri)
														local rIme = datari.value
														
														if rIme == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ranklabel', {
																title = "Upisite label ranka",
															}, function (datarl, menurl)
																local rLabel = datarl.value
																
																if rLabel == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menurl.close()
																	TriggerServerEvent("mafije:NapraviRank", ImeMafije, rID, rIme, rLabel)
																end
															end, function (datarl, menurl)
																menurl.close()
															end)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end
											end, function (datar, menur)
												menur.close()
											end)
										else
											local rankid = datalr.current.value
											menulr.close()
											elements = {}
											table.insert(elements, {label = "Uredi rank", value = 'uredi'})
											table.insert(elements, {label = 'Obrisi rank',  value = 'obrisi'})

											ESX.UI.Menu.Open(
											  'default', GetCurrentResourceName(), 'birasranka',
											  {
												title    = "Izaberite opciju",
												align    = 'top-left',
												elements = elements,
											  },
											  function(datauo, menuuo)
												if datauo.current.value == 'uredi' then
													menuuo.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite ime ranka",
													}, function (datari, menuri)
														local rIme = datari.value
														
														if rIme == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ranklabel', {
																title = "Upisite label ranka",
															}, function (datarl, menurl)
																local rLabel = datarl.value
																
																if rLabel == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menurl.close()
																	TriggerServerEvent("mafije:NapraviRank", ImeMafije, rankid, rIme, rLabel)
																end
															end, function (datarl, menurl)
																menurl.close()
															end)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end

												if datauo.current.value == 'obrisi' then
													menuuo.close()
													TriggerServerEvent("mafije:ObrisiRank", rankid, ImeMafije)
												end
											  end,
											  function(datauo, menuuo)
												menuuo.close()
											  end
											)
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "vozila" then
									elements = {}
									
									for i=1, #Vozila, 1 do
										if Vozila[i].Mafija == ImeMafije then
											table.insert(elements, {label = Vozila[i].Label, value = Vozila[i].Ime})
										end
									end
									
									table.insert(elements, {label = "Dodaj novo vozilo", value = "novi"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == 'novi' then
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
												title = "Upisite spawn ime vozila",
											}, function (datar, menur)
												local vIme = datar.value
												
												if vIme == nil then
													ESX.ShowNotification('Greska.')
												else
													menur.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite naziv vozila(label)",
													}, function (datari, menuri)
														local vLabel = datari.value
														
														if vLabel == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															TriggerServerEvent("mafije:DodajVozilo", ImeMafije, vIme, vLabel)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end
											end, function (datar, menur)
												menur.close()
											end)
										else
											local voziloime = datalr.current.value
											menulr.close()
											elements = {}
											table.insert(elements, {label = "Uredi vozilo", value = 'uredi'})
											table.insert(elements, {label = 'Obrisi vozilo',  value = 'obrisi'})

											ESX.UI.Menu.Open(
											  'default', GetCurrentResourceName(), 'birasranka',
											  {
												title    = "Izaberite opciju",
												align    = 'top-left',
												elements = elements,
											  },
											  function(datauo, menuuo)
												if datauo.current.value == 'uredi' then
													menuuo.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
														title = "Upisite spawn ime vozila",
													}, function (datar, menur)
														local vIme = datar.value
														
														if vIme == nil then
															ESX.ShowNotification('Greska.')
														else
															menur.close()
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
																title = "Upisite naziv vozila(label)",
															}, function (datari, menuri)
																local vLabel = datari.value
																
																if vLabel == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menuri.close()
																	TriggerServerEvent("mafije:DodajVozilo", ImeMafije, vIme, vLabel, voziloime)
																end
															end, function (datari, menuri)
																menuri.close()
															end)
														end
													end, function (datar, menur)
														menur.close()
													end)
												end

												if datauo.current.value == 'obrisi' then
													menuuo.close()
													TriggerServerEvent("mafije:ObrisiVozilo", voziloime, ImeMafije)
												end
											  end,
											  function(datauo, menuuo)
												menuuo.close()
											  end
											)
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "oruzja" then
									elements = {}
									
									for i=1, #Oruzja, 1 do
										if Oruzja[i].Mafija == ImeMafije then
											table.insert(elements, {label = ESX.GetWeaponLabel(Oruzja[i].Ime), value = Oruzja[i].Ime})
										end
									end
									
									table.insert(elements, {label = "Dodaj novo oruzje", value = "novi"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == 'novi' then
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
												title = "Upisite spawn ime oruzja(weapon_)",
											}, function (datar, menur)
												local orIme = datar.value
												
												if orIme == nil then
													ESX.ShowNotification('Greska.')
												else
													menur.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite cijenu oruzja",
													}, function (datari, menuri)
														local orCijena = tonumber(datari.value)
														
														if orCijena == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															TriggerServerEvent("mafije:DodajOruzje", ImeMafije, orIme, orCijena)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end
											end, function (datar, menur)
												menur.close()
											end)
										else
											local oruzjeime = datalr.current.value
											menulr.close()
											elements = {}
											table.insert(elements, {label = "Uredi oruzje", value = 'uredi'})
											table.insert(elements, {label = 'Obrisi oruzje',  value = 'obrisi'})

											ESX.UI.Menu.Open(
											  'default', GetCurrentResourceName(), 'birasranka',
											  {
												title    = "Izaberite opciju",
												align    = 'top-left',
												elements = elements,
											  },
											  function(datauo, menuuo)
												if datauo.current.value == 'uredi' then
													menuuo.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
														title = "Upisite spawn ime oruzja(weapon_)",
													}, function (datar, menur)
														local orIme = datar.value
														
														if orIme == nil then
															ESX.ShowNotification('Greska.')
														else
															menur.close()
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
																title = "Upisite cijenu oruzja",
															}, function (datari, menuri)
																local orCijena = tonumber(datari.value)
																
																if orCijena == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menuri.close()
																	TriggerServerEvent("mafije:DodajOruzje", ImeMafije, orIme, orCijena, oruzjeime)
																end
															end, function (datari, menuri)
																menuri.close()
															end)
														end
													end, function (datar, menur)
														menur.close()
													end)
												end

												if datauo.current.value == 'obrisi' then
													menuuo.close()
													TriggerServerEvent("mafije:ObrisiOruzje", oruzjeime, ImeMafije)
												end
											  end,
											  function(datauo, menuuo)
												menuuo.close()
											  end
											)
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "koord" then
									elements = {}
									
									table.insert(elements, {label = "Postavi koordinate oruzarnice", value = "1"})
									table.insert(elements, {label = "Postavi koordinate lider menua", value = "2"})
									table.insert(elements, {label = "Postavi koordinate spawna vozila(marker)", value = "3"})
									table.insert(elements, {label = "Postavi koordinate brisanja vozila(marker)", value = "4"})
									table.insert(elements, {label = "Postavi koordinate spawna vozila", value = "5"})
									table.insert(elements, {label = "Postavi koordinate crate dropa", value = "6"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										local mid = datalr.current.value
										local coord = GetEntityCoords(PlayerPedId())
										local head = GetEntityHeading(PlayerPedId())
										TriggerServerEvent("mafije:SpremiCoord", ImeMafije, coord, tonumber(mid), head)
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "boje" then
									elements = {}
									
									table.insert(elements, {label = "Postavi boju vozila", value = "1"})
									if Config.Blipovi == true then
										table.insert(elements, {label = "Postavi boju blipa", value = "2"})
									end

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Izaberite opciju",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == "1" then
											local br = datalr.current.value
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
												title = "Upisite R boju (Rgb)",
											}, function (datar, menur)
												local bojR = tonumber(datar.value)
												
												if bojR == nil then
													ESX.ShowNotification('Greska.')
												else
													menur.close()
													ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
														title = "Upisite G boju (rGb)",
													}, function (datari, menuri)
														local bojG = tonumber(datari.value)
														
														if bojG == nil then
															ESX.ShowNotification('Greska.')
														else
															menuri.close()
															
															ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankznj', {
																title = "Upisite B boju (rgB)",
															}, function (datarz, menurz)
																local bojB = tonumber(datarz.value)
																
																if bojB == nil then
																	ESX.ShowNotification('Greska.')
																else
																	menurz.close()
																	TriggerServerEvent("mafije:DodajBoju", ImeMafije, br, 2, bojR, bojG, bojB)
																end
															end, function (datarz, menurz)
																menurz.close()
															end)
														end
													end, function (datari, menuri)
														menuri.close()
													end)
												end
											end, function (datar, menur)
												menur.close()
											end)
										elseif datalr.current.value == "2" then
											local br = datalr.current.value
											menulr.close()
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nestatamo', {
												title = "Upisite ID blip boje",
											}, function (datazn, menuzn)
												local bojID = tonumber(datazn.value)
																	
												if bojID == nil then
													ESX.ShowNotification('Greska.')
												else
													menuzn.close()
													TriggerServerEvent("mafije:DodajBoju", ImeMafije, br, bojID)
												end
											end, function (datazn, menuzn)
												menuzn.close()
											end)
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								elseif data2.current.value == "ime" then
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankid', {
										title = "Upisite label ime mafije",
									}, function (datar, menur)
										local mafIme = datar.value
										if mafIme == nil then
											ESX.ShowNotification('Greska.')
										else
											menur.close()
											menu2.close()
											menu.close()
											TriggerServerEvent("mafije:PromjeniIme", ImeMafije, mafIme)
										end
									end, function (datar, menur)
										menur.close()
									end)
								elseif data2.current.value == "obrisi" then
									elements = {}
									
									table.insert(elements, {label = "Da", value = "da"})
									table.insert(elements, {label = "Ne", value = "ne"})

									ESX.UI.Menu.Open(
									  'default', GetCurrentResourceName(), 'listarankova',
									  {
										title    = "Zelite li obrisati mafiju?",
										align    = 'top-left',
										elements = elements,
									  },
									  function(datalr, menulr)
										if datalr.current.value == "da" then
											menulr.close()
											menu2.close()
											menu.close()
											TriggerServerEvent("mafije:ObrisiMafiju", ImeMafije)
										else
											menulr.close()
										end
									  end,
									  function(datalr, menulr)
										menulr.close()
									  end
									)
								end
							end,
							function(data2, menu2)
								
								menu2.close()
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

function OpenNewMenu()

  if Config.EnableArmoryManagement then
    local elements = {}
	table.insert(elements, {label = "Kupovina stvari", value = 'buy_stvar'})
	table.insert(elements, {label = 'Oruzarnica',  value = 'buy_oruzje'})


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if data.current.value == 'buy_stvar' then
          OpenBuyStvarMenu()
        end

        if data.current.value == 'buy_oruzje' then
          OpenArmoryMenu()
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {}
      end
    )
  end

end

function OpenCloakroomMenu()

  local elements = {
    {label = _U('citizen_wear'), value = 'citizen_wear'},
    {label = _U('mafia_wear'), value = 'mafia_wear'}
  }

  ESX.UI.Menu.CloseAll()

  if Config.EnableNonFreemodePeds then
      table.insert(elements, {label = _U('sheriff_wear'), value = 'sheriff_wear'})
    table.insert(elements, {label = _U('lieutenant_wear'), value = 'lieutenant_wear'})
    table.insert(elements, {label = _U('commandant_wear'), value = 'commandant_wear'})
  end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = _U('cloakroom'),
        align    = 'top-left',
        elements = elements,
        },

        function(data, menu)

      menu.close()

      --Taken from SuperCoolNinja
      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end)
      end

      if data.current.value == 'mafia_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

          if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
          else
            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
          end

        end)

      end

      if data.current.value == 'mafia_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
			
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'lieutenant_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'commandant_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = GetHashKey("G_M_M_ArmBoss_01")

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end


      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function OpenArmoryMenu()
	OruzarnicaMenu = false
	local g,h=ESX.Game.GetClosestPlayer()
	if g~=-1 and h<=3.0 then 
		TriggerServerEvent("mafije:ImalKoga", GetPlayerServerId(PlayerId()), GetPlayerServerId(g))
		while Vratio == nil do
			Wait(100)
		end
	end
	Vratio = nil
	if OruzarnicaMenu == false then
		local elements = {}
		if PlayerData.job.grade > 1 then
			--table.insert(elements, {label = "Prodaj oruzje", value = 'sell_weapon'})
			table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
		end
		table.insert(elements, {label = _U('put_weapon'), value = 'put_weapon'})
		if PlayerData.job.grade > 1 then
			table.insert(elements, {label = 'Uzmi stvar',  value = 'get_stock'})
		end
		table.insert(elements, {label = 'Ostavi stvar',  value = 'put_stock'})

		if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'vlasnik' then
		  table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
		end

		ESX.UI.Menu.CloseAll()
		local armoryime = "armory"..PlayerData.job.name
		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), armoryime,
		  {
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements,
		  },
		  function(data, menu)
			if data.current.value == 'sell_weapon' then
			  OpenSellWeaponMenu()
			end

			if data.current.value == 'get_weapon' then
			  OpenGetWeaponMenu()
			end

			if data.current.value == 'put_weapon' then
			  OpenPutWeaponMenu()
			end

			if data.current.value == 'buy_weapons' then
			  OpenBuyWeaponsMenu()
			end

			if data.current.value == 'put_stock' then
				  OpenPutStocksMenu()
				end

				if data.current.value == 'get_stock' then
				  OpenGetStocksMenu()
				end

		  end,
		  function(data, menu)

			menu.close()

			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = _U('open_armory')
			CurrentActionData = {}
		  end
		)
	end
end

function OpenSellWeaponMenu()

  ESX.TriggerServerCallback('mafije:getArmoryWeapons', function(weapons)

    local elements = {}
	local ammo = 0

	for i=1, #Oruzja, 1 do
		if Oruzja[i].Mafija == PlayerData.job.name then
			local weapon = Oruzja[i]
			for i=1, #weapons, 1 do
				if weapons[i].name == weapon.Ime then
					if weapons[i].count > 0 then
						table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name).."("..weapons[i].ammo..")", value = weapons[i].name, metci = weapons[i].ammo, kolicina = weapons[i].count})
					end
				end
			end
		end
    end
	table.insert(elements, {label = "Zapocni prodaju", value = "sell_pocni"})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = "Prodaja oruzja",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()
		if data.current.value == 'sell_pocni' then
			TriggerEvent("prodajamb:PokreniProdaju", PlayerData.job.name)
		else
			if data.current.kolicina > 1 then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'kolicina', {
							title = "Kolicina oruzja"
						}, function(data2, menu2)
							local amount = tonumber(data2.value)

							if amount == nil then
								ESX.ShowNotification("Krivi iznos!")
							else
								if amount <= data.current.kolicina then
										menu2.close()
										menu.close()
										ESX.TriggerServerCallback('prodajamb:BrisiOruzja', function()
											OpenSellWeaponMenu()
										end, data.current.value, 250, amount, PlayerData.job.name)
								else
									menu2.close()
									ESX.ShowNotification("Nema toliko oruzja!")
								end
							end
						end, function(data2, menu2)
							menu2.close()
						end)
			else
				ESX.TriggerServerCallback('prodajamb:BrisiOruzja', function()
					OpenSellWeaponMenu()
				end, data.current.value, 250, 1, PlayerData.job.name)
			end
		end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end, PlayerData.job.name)

end

function OpenVehicleSpawnerMenu()

	ESX.UI.Menu.CloseAll()

    local elements = {}

    for i=1, #Vozila, 1 do
		if Vozila[i].Mafija == PlayerData.job.name then
			table.insert(elements, {label = Vozila[i].Label, value = Vozila[i].Ime})
		end
    end
	
	local x,y,z,h
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil then
			if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "LokVozila" then
				x,y,z,h = table.unpack(Koord[i].Coord)
				break
			end
		end
    end
	if (x == 0 or x == nil) and (y == 0 or y == nil) and (z == 0 or z == nil) then
		ESX.ShowNotification("Vasoj mafiji nije postavljena lokacija spawna vozila, javite se adminu!")
		return
	end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        --local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        --if not DoesEntityExist(vehicle) then

        local playerPed = GetPlayerPed(-1)

		if BVozilo ~= nil then
			ESX.Game.DeleteVehicle(BVozilo)
			BVozilo = nil
		end
		ESX.Streaming.RequestModel(model)
		BVozilo = CreateVehicle(model, x,y,z,h, true, false)
        TaskWarpPedIntoVehicle(playerPed,  BVozilo,  -1)
        SetVehicleMaxMods(BVozilo)
		for i=1, #Boje, 1 do
			if Boje[i].Mafija == PlayerData.job.name and Boje[i].Ime == "Vozilo" then
				SetVehicleCustomPrimaryColour(BVozilo, tonumber(Boje[i].R), tonumber(Boje[i].G), tonumber(Boje[i].B))
				SetVehicleCustomSecondaryColour(BVozilo, tonumber(Boje[i].R), tonumber(Boje[i].G), tonumber(Boje[i].B))
				break
			end
		end

        --else
         -- ESX.ShowNotification(_U('vehicle_out'))
        --end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}

      end
    )
end

function OpenMafiaActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mafia_actions',
    {
      title    = firstToUpper(PlayerData.job.name),
      align    = 'top-left',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'},
        {label = _U('vehicle_interaction'), value = 'vehicle_interaction'}
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('citizen_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('id_card'),       value = 'identity_card'},
              {label = _U('search'),        value = 'body_search'},
              {label = _U('handcuff'),    value = 'handcuff'},
              {label = _U('drag'),      value = 'drag'},
              {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                OpenBodySearchMenu(player)
              end

              if data2.current.value == 'handcuff' then
                TriggerServerEvent('mafije:handcuff', GetPlayerServerId(player))
              end

              if data2.current.value == 'drag' then
                TriggerServerEvent('mafije:drag', GetPlayerServerId(player))
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('mafije:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                  TriggerServerEvent('mafije:OutVehicle', GetPlayerServerId(player))
              end

            else
              ESX.ShowNotification(_U('no_players_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'vehicle_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'vehicle_interaction',
          {
            title    = _U('vehicle_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('vehicle_info'), value = 'vehicle_infos'},
              {label = _U('pick_lock'),    value = 'hijack_vehicle'},
            },
          },
          function(data2, menu2)

            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

            if DoesEntityExist(vehicle) then

              local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

              if data2.current.value == 'vehicle_infos' then
                OpenVehicleInfosMenu(vehicleData)
              end

              if data2.current.value == 'hijack_vehicle' then

                local playerPed = GetPlayerPed(-1)
                local coords    = GetEntityCoords(playerPed)

                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

                  if DoesEntityExist(vehicle) then

                    Citizen.CreateThread(function()

                      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

                      Wait(20000)

                      ClearPedTasksImmediately(playerPed)

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)

                      TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))

                    end)

                  end

                end

              end

            else
              ESX.ShowNotification(_U('no_vehicles_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

    ESX.TriggerServerCallback('mafije:getOtherPlayerData', function(data)

      local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Posao : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Posao : ' .. data.job.label
      end

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Musko'
        else
          sex = 'Zensko'
        end
        sexLabel = 'Sex : ' .. sex
      else
        sexLabel = 'Sex : Unknown'
      end

      if data.dob ~= nil then
        dobLabel = 'DOB : ' .. data.dob
      else
        dobLabel = 'DOB : Nepoznata'
      end

      if data.height ~= nil then
        heightLabel = 'Visina : ' .. data.height
      else
        heightLabel = 'Visina : Nepoznata'
      end

      if data.name ~= nil then
        idLabel = 'ID : ' .. data.name
      else
        idLabel = 'ID : Nepoznat'
      end

      local elements = {
        {label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
        {label = sexLabel,    value = nil},
        {label = dobLabel,    value = nil},
        {label = heightLabel, value = nil},
        {label = jobLabel,    value = nil},
        {label = idLabel,     value = nil},
      }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Dozvole ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  else

    ESX.TriggerServerCallback('mafije:getOtherPlayerData', function(data)

      local jobLabel = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

        local elements = {
          {label = _U('name') .. data.name, value = nil},
          {label = jobLabel,              value = nil},
        }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Dozvole ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  end

end

function OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('mafije:getOtherPlayerData', function(data)

    local elements = {}

    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label          = _U('confiscate_dirty') .. blackMoney,
      value          = 'black_money',
      itemType       = 'item_account',
      amount         = blackMoney
    })

    table.insert(elements, {label = '--- Oruzja ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = _U('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = _U('search'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('mafije:zapljeni6', GetPlayerServerId(player), itemType, itemName, amount)

          OpenBodySearchMenu(player)

        end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end


function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('mafije:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = _U('owner_unknown'), value = nil})
    else
      table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = _U('vehicle_info'),
        align    = 'top-left',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('mafije:getArmoryWeapons', function(weapons)

    local elements = {}
	local ammo = 0

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name).."("..weapons[i].ammo..")", value = weapons[i].name, ammo = weapons[i].ammo})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()
		if data.current.ammo >= 250 then
			ESX.TriggerServerCallback('mafije:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value, 250, PlayerData.job.name)
		else
			ESX.TriggerServerCallback('mafije:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value, data.current.ammo, PlayerData.job.name)
		end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end, PlayerData.job.name)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()
  local ammo = 0

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name, metci = ammo})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('mafije:addArmoryWeapon', function()
		Wait(200)
        OpenPutWeaponMenu()
      end, data.current.value, data.current.metci, PlayerData.job.name)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenBuyWeaponsMenu()

  ESX.TriggerServerCallback('mafije:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #Oruzja, 1 do
		if Oruzja[i].Mafija == PlayerData.job.name then
			local weapon = Oruzja[i]
			local count  = 0

			for j=1, #weapons, 1 do
				if weapons[j].name == weapon.Ime then
				  count = weapons[j].count
				  break
				end
			end

			table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.Ime) .. ' $' .. weapon.Cijena, value = weapon.Ime, price = weapon.Cijena})
		end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title    = _U('buy_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if ZatrazioOruzje[10] ~= nil or ZOBr >= 10 then
			ESX.ShowNotification("Vec imate naruceno 10 oruzja!")
		else
			local x,y,z
			for i=1, #Koord, 1 do
				if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "CrateDrop" then
					x,y,z = table.unpack(Koord[i].Coord)
					break
				end
			end
			if x ~= nil then
				ESX.TriggerServerCallback('mafije:piku4', function(hasEnoughMoney)
					if hasEnoughMoney then
						ZatrazioOruzje[ZOBr] = data.current.value
						TriggerServerEvent('mafije:SpremiIme', ZatrazioOruzje[ZOBr], ZOBr)
						ZOBr = ZOBr+1
						if ZOBr == 1 then
							ESX.ShowNotification("Uzmite Big 4x4(Guardian) i odite na zeleni kofer oznacen na mapi kako bi ste pokupili paket")
							TriggerEvent("mafije:crateDrop", data.current.value, 250, true, 400.0, {["x"] = x, ["y"] = y, ["z"] = z})
						end
					else
						ESX.ShowNotification(_U('not_enough_money'))
					end
				end, data.current.price, PlayerData.job.name)
			else
				ESX.ShowNotification("Vasoj mafiji jos nisu postavljene koordinate spawna crate dropa, javite adminima!")
			end
		end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end, PlayerData.job.name)

end

RegisterNetEvent("mafije:crateDrop")

AddEventHandler("mafije:crateDrop", function(weapon, ammo, roofCheck, planeSpawnDistance, dropCoords)
    Citizen.CreateThread(function()

        -- print("WEAPON: " .. string.lower(weapon))

        local ammo = (ammo and tonumber(ammo)) or 250
        if ammo > 9999 then
            ammo = 9999
        elseif ammo < -1 then
            ammo = -1
        end

        -- print("AMMO: " .. ammo)

        if dropCoords.x and dropCoords.y and dropCoords.z and tonumber(dropCoords.x) and tonumber(dropCoords.y) and tonumber(dropCoords.z) then
            -- print(("DROP COORDS: success, X = %.4f; Y = %.4f; Z = %.4f"):format(dropCoords.x, dropCoords.y, dropCoords.z))
        else
            dropCoords = {0.0, 0.0, 72.0}
            -- print("DROP COORDS: fail, defaulting to X = 0; Y = 0")
        end
        -- print("ROOFCHECK: false")
        CrateDrop(weapon, ammo, planeSpawnDistance, dropCoords)

    end)
end)

function CrateDrop(weapon, ammo, planeSpawnDistance, dropCoords)
    local crateSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z)
	local id = GetPlayerServerId(PlayerId())
	TriggerServerEvent('mafije:SaljiCrate', crate,  crateSpawn, PlayerData.job.name, id)
end

function CrateDrop2(parachute)
    --Citizen.CreateThread(function()
		crate = CreateObject(GetHashKey("prop_box_wood05a"), parachute, false, true, true)
	
        soundID = GetSoundId()
        PlaySoundFromEntity(soundID, "Crate_Beeps", crate, "MP_CRATE_DROP_SOUNDS", true, 0)
		local x,y,z = table.unpack(parachute)
		blipa = AddBlipForCoord(x,y,z)
        SetBlipSprite(blipa, 408)
        SetBlipNameFromTextFile(blipa, "AMD_BLIPN")
        SetBlipScale(blipa, 0.7)
        SetBlipColour(blipa, 2)
        SetBlipAlpha(blipa, 255)
		
		DropCoord = vector3(GetEntityCoords(crate))
		SpawnajDropMarker = true

        while PokupioCrate == false do
            Wait(0)
        end
		
		local id = GetPlayerServerId(PlayerId())
		TriggerServerEvent('mafije:BrisiCrate', id)

        if DoesBlipExist(blipa) then
            RemoveBlip(blipa)
        end

        StopSound(soundID)
        ReleaseSoundId(soundID)

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

        RemoveWeaponAsset(GetHashKey("weapon_flare"))
    --end)
end

RegisterNetEvent('mafije:JelTiOtvoren')
AddEventHandler('mafije:JelTiOtvoren', function(id)
	local armoryime = "armory"..PlayerData.job.name
	local menu = ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), armoryime)
	TriggerServerEvent("mafije:SaljemOtvoren", id, menu)
end)

RegisterNetEvent('mafije:VracamOtvoren')
AddEventHandler('mafije:VracamOtvoren', function(menu)
	Vratio = true
	OruzarnicaMenu = menu
end)

RegisterNetEvent('mafije:VratiCrate')
AddEventHandler('mafije:VratiCrate', function(cr, par, job, id)
	local ida = GetPlayerServerId(PlayerId())
	--if ida ~= id then
		if PlayerData.job.name == job then
			crate = cr
			parachute = par
			CrateDrop2(parachute)
		end
	--end
end)

RegisterNetEvent('mafije:ObrisiCrate')
AddEventHandler('mafije:ObrisiCrate', function(id)
	local ida = GetPlayerServerId(PlayerId())
	if ida ~= id then
		if DoesEntityExist(crate) then
			DeleteEntity(crate)
			StopSound(soundID)
			ReleaseSoundId(soundID)
			SpawnajDropMarker = false
		end
	end
end)

RegisterNetEvent('mafije:ResetOruzja')
AddEventHandler('mafije:ResetOruzja', function(maf)
	if PlayerData.job.name == maf then
		for i=0, 10, 1 do
			ZatrazioOruzje[i] = nil
		end
		ZOBr = 0
	end
end)

RegisterNetEvent('mafije:VratiIme')
AddEventHandler('mafije:VratiIme', function(ime, br)
	ZatrazioOruzje[br] = ime
	ZOBr = br+1
end)

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('mafije:getStockItems', function(items)

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = "Uzmi stvari",
		align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
			  local brojic = tonumber(PlayerId())
			  if brojic >= 1 and brojic <= 4 then
				brojic = brojic*100
			  elseif brojic > 4 and brojic < 10 then
				brojic = brojic*50
			  elseif brojic >= 10 and brojic <= 50 then
				brojic = brojic*10
			  elseif brojic > 50 and brojic < 100 then
				brojic = brojic*5
			  end
			  Wait(brojic)
              TriggerServerEvent('mafije:getStockItem', itemName, count, PlayerData.job.name)
			  OpenGetStocksMenu()
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, PlayerData.job.name)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('mafije:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
		align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)
			if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
			else
				for i=1, #inventory.items, 1 do

				  local item = inventory.items[i]

				  if itemName == item.name then
					if item.count >= count then
						menu2.close()
						menu.close()
						if string.find(itemName, "weapon") == nil then
							TriggerServerEvent('mafije:putStockItems', itemName, count, PlayerData.job.name)
							Wait(200)
							OpenPutStocksMenu()
						else
							for i=1, count, 1 do
								ESX.TriggerServerCallback('mafije:addArmoryWeapon', function()
									Wait(200)
									OpenPutStocksMenu()
								end, itemName, 250, PlayerData.job.name)
							end
							TriggerServerEvent("mafije:makniOruzjeItem", itemName, count)
						end
					else
						ESX.ShowNotification("Nemate toliko "..itemName)
					end
				  end

				end
			end
          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('mafije:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end
  
  if part == 'Drop' then
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehara = GetVehiclePedIsUsing(PlayerPedId())
		local retval = GetDisplayNameFromVehicleModel(GetEntityModel(vehara))
		if retval == "GUARDIAN" then
			--DeleteEntity(crate)
			PokupioCrate = true
			SpawnajDropMarker = false
			DeleteEntity(crate)
			crate = CreateObject(GetHashKey("prop_box_wood05a"), crateSpawn, true, true, true)
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			local ent = GetEntityBoneIndexByName(veh, "boot")
			AttachEntityToEntity(crate, GetVehiclePedIsIn(PlayerPedId(), false), ent, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1, 0, 0, 0, 2, 1)
			ESX.ShowNotification("Odvezite paket do oznacene lokacije!")
			for i=1, #Koord, 1 do
				if Koord[i].Mafija == PlayerData.job.name and Koord[i].Ime == "DeleteV" then
					local x,y,z = table.unpack(Koord[i].Coord)
					DostavaBlip = AddBlipForCoord(x,y,z)
					SetBlipSprite(DostavaBlip, 1)
					SetBlipRoute(DostavaBlip,  true)
				end
			end
		end
	end
  end

  if part == 'VehicleSpawner' then
	CurrentAction     = 'menu_vehicle_spawner'
	CurrentActionMsg  = _U('vehicle_spawner')
	CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'VehicleDeleter' then
	if PokupioCrate == true then
		local vehara = GetVehiclePedIsUsing(PlayerPedId())
		local retval = GetDisplayNameFromVehicleModel(GetEntityModel(vehara))
		if retval == "GUARDIAN" then
			PokupioCrate = false
			DeleteEntity(crate)
			RemoveBlip(DostavaBlip)
			ESX.ShowNotification("Oruzje vam je dodano u sef mafije!")
			for i=0, 10, 1 do
				if ZatrazioOruzje[i] ~= nil then
					ESX.TriggerServerCallback('mafije:addArmoryWeapon', function()
						  --OpenBuyWeaponsMenu(station)
					end, ZatrazioOruzje[i], 250, PlayerData.job.name)
					ZatrazioOruzje[i] = nil
				end
			end
			TriggerServerEvent('mafije:ResetirajOruzje', PlayerData.job.name)
			ZOBr = 0
		else
			ESX.ShowNotification("Morate biti u Guardianu!")
		end
	else
		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

		  local vehicle = GetVehiclePedIsIn(playerPed, false)

		  if DoesEntityExist(vehicle) then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_vehicle')
			CurrentActionData = {vehicle = vehicle}
		  end

		end
	end
  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('mafije:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('mafije:oslobodiga')
AddEventHandler('mafije:oslobodiga', function()
	local playerPed = GetPlayerPed(-1)
    if IsHandcuffed then
	  IsHandcuffed = false
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)
    end
end)

RegisterNetEvent('mafije:handcuff')
AddEventHandler('mafije:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)

    else
	  TriggerEvent("esx_grovejob:oslobodiga")
	  TriggerEvent("esx_ballasjob:oslobodiga")
	  TriggerEvent("esx_yakuza:oslobodiga")
	  TriggerEvent("esx_mafiajob:oslobodiga")
	  TriggerEvent("esx_policejob:oslobodiga")
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)

RegisterNetEvent('mafije:drag')
AddEventHandler('mafije:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

RegisterNetEvent('mafije:putInVehicle')
AddEventHandler('mafije:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('mafije:OutVehicle')
AddEventHandler('mafije:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

RegisterNetEvent('mafije:PosaljiVozila')
AddEventHandler('mafije:PosaljiVozila', function(maf, voz)
	Vozila = voz
end)

RegisterNetEvent('mafije:UpdateKoord')
AddEventHandler('mafije:UpdateKoord', function(koor)
	Koord = koor
end)

RegisterNetEvent('mafije:UpdateMafije')
AddEventHandler('mafije:UpdateMafije', function(maf)
	Mafije = maf
end)

RegisterNetEvent('mafije:UpdateRankove')
AddEventHandler('mafije:UpdateRankove', function(ran)
	Rankovi = ran
end)

RegisterNetEvent('mafije:UpdateImeBlipa')
AddEventHandler('mafije:UpdateImeBlipa', function(maf, ime)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(firstToUpper(ime))
	EndTextCommandSetBlipName(Blipovi[maf])
end)

RegisterNetEvent('mafije:UpdateBoje')
AddEventHandler('mafije:UpdateBoje', function(br, maf, boj)
	Boje = boj
	if Config.Blipovi == true then
		if br == 2 then
			for i=1, #Boje, 1 do
				if Boje[i] ~= nil and Boje[i].Mafija == maf and Boje[i].Ime == "Blip" then
					SetBlipColour (Blipovi[maf], tonumber(Boje[i].Boja))
					break
				end
			end
		end
		if br == 3 then
			RemoveBlip(Blipovi[maf])
			Blipovi[maf] = nil
		end
	end
end)

RegisterNetEvent('mafije:PosaljiOruzja')
AddEventHandler('mafije:PosaljiOruzja', function(maf, oruz)
	Oruzja = oruz
end)

RegisterNetEvent('mafije:KreirajBlip')
AddEventHandler('mafije:KreirajBlip', function(co, maf)
	local x,y,z = table.unpack(co)
	if Blipovi[maf] ~= nil then
		RemoveBlip(Blipovi[maf])
		Blipovi[maf] = nil
	end
	if x ~= 0 and x ~= nil then
		Blipovi[maf] = AddBlipForCoord(x,y,z)

		SetBlipSprite (Blipovi[maf], 378)
		SetBlipDisplay(Blipovi[maf], 4)
		SetBlipScale  (Blipovi[maf], 1.2)
		for i=1, #Boje, 1 do
			if Boje[i] ~= nil and Boje[i].Mafija == maf and Boje[i].Ime == "Blip" then
				SetBlipColour (Blipovi[maf], tonumber(Boje[i].Boja))
				break
			end
		end
		SetBlipColour (Blipovi[maf], 39)
		SetBlipAsShortRange(Blipovi[maf], true)

		BeginTextCommandSetBlipName("STRING")
		for j=1, #Mafije, 1 do
			if Mafije[j] ~= nil and Mafije[j].Ime == maf then
				AddTextComponentString(firstToUpper(Mafije[j].Label))
				break
			end
		end
		EndTextCommandSetBlipName(Blipovi[maf])
	end
end)

function OpenBuyStvarMenu(station)
    local elements = {}
    table.insert(elements, {label = 'Laptop za hakiranje (25000$)', value = 'laptop'})
	table.insert(elements, {label = 'Termitna bomba (5000$)', value = 'termit'})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_stvari',
      {
        title    = "Kupovina stvari",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		ESX.TriggerServerCallback('kupistvari', function(hasEnoughMoney)
			  if hasEnoughMoney then
					ESX.ShowNotification("Uspjesno kupljeno!")
			  else
					ESX.ShowNotification("Nemate dovoljno novca ili vec imate dovoljno u inventoryju!")
			  end
		end, data.current.value)
      end,
      function(data, menu)
        menu.close()
		CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') and (GetGameTimer() - GUI.Time) > 150 then
			for i=1, #Mafije, 1 do
				if Mafije[i] ~= nil and Mafije[i].Ime == PlayerData.job.name then
					OpenMafiaActionsMenu()
					GUI.Time = GetGameTimer()
					break
				end
			end
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
  local waitara = 500
  while true do
    Citizen.Wait(waitara)
	local naso = 0
	if IsHandcuffed then
		waitara = 0
		naso = 1
		if IsDragged then
			local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
			local myped = GetPlayerPed(-1)
			AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
			DetachEntity(GetPlayerPed(-1), true, false)
		end
    end
	if IsHandcuffed then
	  waitara = 0
	  naso = 1
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
	  DisableControlAction(0, 167, true) -- f6
    end
	
	if CurrentAction ~= nil then
	  waitara = 0
	  naso = 1
	  
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          OpenNewMenu()
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu()
        end

        if CurrentAction == 'delete_vehicle' then
          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
		  BVozilo = nil
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end)

        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
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
	while PlayerData.job == nil do
		Wait(1)
	end
	for i=1, #Koord, 1 do
		if Koord[i] ~= nil and Koord[i].Mafija == PlayerData.job.name then
			if Koord[i].Ime == "Oruzarnica" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 1
						currentPart    = 'Armory'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "Lider" and (PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'vlasnik') then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 2
						currentPart    = 'BossActions'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "SpawnV" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 3
						currentPart    = 'VehicleSpawner'
						currentPartNum = i
					end
				end
			end
			if Koord[i].Ime == "DeleteV" then
				local x,y,z = table.unpack(Koord[i].Coord)
				if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 100.0 then
						waitara = 0
						naso = 1
						DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
					end
					if GetDistanceBetweenCoords(coords, x, y, z, true) < 1.5 then
						isInMarker     = true
						currentStation = 4
						currentPart    = 'VehicleDeleter'
						currentPartNum = i
					end
				end
			end
		end
	end

    if PlayerData.job ~= nil then

		if SpawnajDropMarker == true then
			if GetDistanceBetweenCoords(coords,  DropCoord.x,  DropCoord.y+2,  DropCoord.z,  true) < 100.0 then
				waitara = 0
				naso = 1
				DrawMarker(1, DropCoord.x,  DropCoord.y+2,  DropCoord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 50, 204, 100, false, true, 2, false, false, false, false)
			end
			if GetDistanceBetweenCoords(coords,  DropCoord.x,  DropCoord.y+2,  DropCoord.z,  false) < 1.5 then
				isInMarker     = true
				currentStation = 5
				currentPart    = 'Drop'
				currentPartNum = 69
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
				TriggerEvent('mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('mafije:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			waitara = 0
			naso = 1
			HasAlreadyEnteredMarker = false

			TriggerEvent('mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end

    end
	
	if naso == 0 then
		waitara = 500
	end
  end
end)
---------------------------------------------------------------------------------------------------------
--NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:openMenuMafia')
AddEventHandler('NB:openMenuMafia', function()
	OpenMafiaActionsMenu()
end)
