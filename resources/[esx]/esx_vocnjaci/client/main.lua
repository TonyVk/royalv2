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
local Koord = {}
local Vocnjaci = {}
local Drvo = nil

local parachute, crate, pickup, blipa, soundID
local requiredModels = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "prop_box_wood05a"} -- parachute, pickup case, plane, pilot, crate

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  ProvjeriPosao()
end)

function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
	ESX.TriggerServerCallback('vocnjaci:DohvatiVocnjake', function(vocnjak)
		Vocnjaci = vocnjak.voc
		Koord = vocnjak.kor
	end)
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenVocnjakMenu()
    local elements = {}
	table.insert(elements, {label = "Posadi drvo", value = 'posadi'})
	table.insert(elements, {label = "Beri drvo", value = 'beri'})
	
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vocnjak',
      {
        title    = "Izaberite opciju",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if data.current.value == 'posadi' then
			local cord = GetEntityCoords(PlayerPedId())
			local x,y,z = table.unpack(cord)
			local model = GetHashKey("prop_pot_plant_05b")
			RequestModel(model)
			Drvo = CreateObject(model, x, y, z-1.6, true, true, false)
			FreezeEntityPosition(Drvo, true)
			Wait(5000)
			DeleteObject(Drvo)
			local model = GetHashKey("prop_tree_birch_05")
			RequestModel(model)
			Drvo = CreateObject(model, x, y, z-1.6, true, true, false)
			FreezeEntityPosition(Drvo, true)
		elseif data.current.value == 'beri' then
			local br = 0
			while br < 5 do
				TaskPlayAnim(GetPlayerPed(-1), "random@mugging5", "001445_01_gangintimidation_1_female_idle_b", 2.0, 2.0, 3000, false, 0, false, false, false)
				Wait(3000)
				br = br+1
			end
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vocnjak'
		CurrentActionMsg  = "Pritisnite E da vidite opcije vocnjaka"
		CurrentActionData = {}
      end
    )
end

RegisterCommand("uredimafiju", function(source, args, raw)
	local elements = {}
	
	for i=1, #njive, 1 do
		if njive[i] ~= nil then
			table.insert(elements, {label = njive[i].Label, value = njive[i].Ime})
		end
	end
	
	table.insert(elements, {label = "Kreiraj mafiju", value = "nova"})

    ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'umafiju',
		{
			title    = "Izaberite mafiju",
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			if data.current.value == "nova" then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rankime', {
					title = "Upisite ime njive",
				}, function (datari, menuri)
					local mIme = datari.value
												
					if mIme == nil then
						ESX.ShowNotification('Greska.')
					else
						menuri.close()
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ranklabel', {
							title = "Upisite label njive",
						}, function (datarl, menurl)
							local mLabel = datarl.value
														
							if mLabel == nil then
								ESX.ShowNotification('Greska.')
							else
								menurl.close()
								menu.close()
								TriggerServerEvent("vocnjaci:NapraviMafiju", mIme, mLabel)
							end
						end, function (datarl, menurl)
							menurl.close()
						end)
					end
				end, function (datari, menuri)
					menuri.close()
				end)
			else
				local Imenjive = data.current.value
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
								if Rankovi[i] ~= nil and Rankovi[i].Mafija == Imenjive then
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
															TriggerServerEvent("vocnjaci:NapraviRank", Imenjive, rID, rIme, rLabel)
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
															TriggerServerEvent("vocnjaci:NapraviRank", Imenjive, rankid, rIme, rLabel)
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
											TriggerServerEvent("vocnjaci:ObrisiRank", rankid, Imenjive)
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
								if Vozila[i].Mafija == Imenjive then
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
													TriggerServerEvent("vocnjaci:DodajVozilo", Imenjive, vIme, vLabel)
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
															TriggerServerEvent("vocnjaci:DodajVozilo", Imenjive, vIme, vLabel, voziloime)
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
											TriggerServerEvent("vocnjaci:ObrisiVozilo", voziloime, Imenjive)
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
								if Oruzja[i].Mafija == Imenjive then
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
													TriggerServerEvent("vocnjaci:DodajOruzje", Imenjive, orIme, orCijena)
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
															TriggerServerEvent("vocnjaci:DodajOruzje", Imenjive, orIme, orCijena, oruzjeime)
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
											TriggerServerEvent("vocnjaci:ObrisiOruzje", oruzjeime, Imenjive)
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
								TriggerServerEvent("vocnjaci:SpremiCoord", Imenjive, coord, tonumber(mid), head)
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
															TriggerServerEvent("vocnjaci:DodajBoju", Imenjive, br, 2, bojR, bojG, bojB)
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
											TriggerServerEvent("vocnjaci:DodajBoju", Imenjive, br, bojID)
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
								title = "Upisite label ime njive",
							}, function (datar, menur)
								local mafIme = datar.value
								if mafIme == nil then
									ESX.ShowNotification('Greska.')
								else
									menur.close()
									menu2.close()
									menu.close()
									TriggerServerEvent("vocnjaci:PromjeniIme", Imenjive, mafIme)
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
									TriggerServerEvent("vocnjaci:ObrisiMafiju", Imenjive)
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
end, false)

RegisterCommand("postavikoord", function(source, args, raw)
	if args[1] and args[2] then
		local Postoji = 0
		for i=1, #Vocnjaci, 1 do
			if Vocnjaci[i] ~= nil and Vocnjaci[i].Ime == args[1] then
				Postoji = 1
			end
		end
		if Postoji == 1 and (tonumber(args[2]) > 0 and tonumber(args[2]) < 3) then
			local coord = GetEntityCoords(PlayerPedId())
			TriggerServerEvent("vocnjaci:SpremiCoord", args[1], coord, tonumber(args[2]))
		else
			ESX.ShowNotification("Vocnjak ne postoji")
		end
	else
		ESX.ShowNotification("/postavikoord [Ime vocnjaka][1 - x1,y1 | 2 - x2,y2]")
	end
end, false)

RegisterCommand("debug", function(source, args, raw)
	if Drvo ~= nil then
		DeleteObject(Drvo)
		Drvo = nil
	end
end, false)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('vocnjaci:hasEnteredMarker', function(station, part, partNum)
  if part == 'Vocnjak' then
    CurrentAction     = 'menu_vocnjak'
    CurrentActionMsg  = "Pritisnite E da vidite opcije vocnjaka"
    CurrentActionData = {}
  end
end)

AddEventHandler('vocnjaci:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('vocnjaci:UpdateKoord')
AddEventHandler('vocnjaci:UpdateKoord', function(koor)
	Koord = koor
end)

RegisterNetEvent('vocnjaci:UpdateVocnjake')
AddEventHandler('vocnjaci:UpdateVocnjake', function(njiv)
	Vocnjaci = njiv
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then

				if CurrentAction == 'menu_vocnjak' then
					OpenVocnjakMenu()
				end
				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		end

		local playerPed = GetPlayerPed(-1)
		
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil
		for i=1, #Koord, 1 do
			if Koord[i] ~= nil then
				local x,y,z = table.unpack(Koord[i].Coord)
				if Koord[i].Coord2 ~= nil then
					local x2,y2,z2 = table.unpack(Koord[i].Coord2)
					if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
						if IsEntityInArea(PlayerPedId(), x, y, z, x2, y2, z2, false, false, 0) then
							isInMarker     = true
							currentStation = 1
							currentPart    = 'Vocnjak'
							currentPartNum = i
						end
					end
				end
			end
		end
		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

			if
				(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('vocnjaci:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('vocnjaci:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

			HasAlreadyEnteredMarker = false

			TriggerEvent('vocnjaci:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end
	end
end)
