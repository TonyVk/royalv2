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
local Zemljista = {}
local Kuce = {}
local Kuca = nil
local brojic = 1
local ButtonsScaleform = nil
Scaleforms    = mLibs:Scaleforms()

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
	ESX.TriggerServerCallback('zemljista:DohvatiZemljista', function(zemlj)
		Zemljista = zemlj.voc
		Koord = zemlj.kor
	end)
	Wait(5000)
	for i=1, #Zemljista, 1 do
		if Zemljista[i] ~= nil and Zemljista[i].Kuca ~= nil then
			SpawnKucu(Zemljista[i])
		end
	end
end

function SpawnKucu(data)
	local model = GetHashKey(data.Kuca)
	RequestModel(model)
	Kuca = CreateObject(model, data.KKoord.x, data.KKoord.y, data.KKoord.z, false, false, false)
	table.insert(Kuce, {Zemljiste = data.Ime, Objekt = Kuca})
	FreezeEntityPosition(Kuca, true)
	SetEntityCoords(Kuca, data.KKoord.x, data.KKoord.y, data.KKoord.z)
	SetEntityHeading(Kuca, data.Heading)
	SetModelAsNoLongerNeeded(model)
end

RegisterNetEvent('zemljista:ObrisiKucu')
AddEventHandler('zemljista:ObrisiKucu', function(ime)
	for i=1, #Kuce, 1 do
		if Kuce[i] ~= nil and Kuce[i].Zemljiste == ime then
			ESX.Game.DeleteObject(Kuce[i].Objekt)
			table.remove(Kuce, i)
			break
		end
	end
end)

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

CreateControls = function()
  local controls
  controls = {
      [1] = Config.Controls["direction"],
      [2] = Config.Controls["heading"],
      [3] = Config.Controls["height"],
      [4] = Config.Controls["camera"],
      [5] = Config.Controls["zoom"],
  }

  return controls
end

Instructional = {}

Instructional.Init = function()
  local scaleform = Scaleforms.LoadMovie('INSTRUCTIONAL_BUTTONS')

  Scaleforms.PopVoid(scaleform,'CLEAR_ALL')
  Scaleforms.PopInt(scaleform,'SET_CLEAR_SPACE',200) 

  return scaleform
end

Instructional.SetControls = function(scaleform,controls)
  for i=1,#controls,1 do
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(i-1)
    for k=1,#controls[i].codes,1 do
      ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, controls[i].codes[k], true))
    end
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(controls[i].text)
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()
  end

  Scaleforms.PopVoid(scaleform,'DRAW_INSTRUCTIONAL_BUTTONS')
  --Scaleforms.PopMulti(scaleform,'SET_BACKGROUND_COLOUR',1,1,1,1)
end

Instructional.Create = function(controls)
  local scaleform = Instructional.Init()
  Instructional.SetControls(scaleform,controls)
  return scaleform
end

function OpenZemljisteMenu(ime)
    local elements = {}
	local cijena = 0
	ESX.TriggerServerCallback('zemljista:JelVlasnik', function(br, cij, vl, kuca, vrata)
		if br and vl then
			if not kuca then
				table.insert(elements, {label = "Izgradi kucu (100000$)", value = 'kuca'})
			else
				table.insert(elements, {label = "Srusi kucu(30000$)", value = 'kuca2'})
			end
			if kuca then
				if not vrata then
					table.insert(elements, {label = "Postavi ulaz u kucu", value = 'ulaz'})
				else
					table.insert(elements, {label = "Uredi ulaz u kucu", value = 'ulaz2'})
				end
			end
			table.insert(elements, {label = "Prodaj drzavi ("..(cij/2).."$)", value = 'prodaj'})
		elseif not br and not vl then
			table.insert(elements, {label = "Kupi za $"..cij, value = 'kupi'})
		else
			table.insert(elements, {label = "Ovo zemljiste je kupljeno", value = 'error'})
		end
		cijena = cij
	end, ime)
	while #elements == 0 do
		Wait(100)
	end
	brojic = 1
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'zemljiste',
      {
        title    = "Izaberite opciju",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		if data.current.value == 'kuca' then
			menu.close()
			local cord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0)
			local x,y,z = table.unpack(cord)
			local kord1 = nil
			local kord2 = nil
			for i=1, #Koord, 1 do
				if Koord[i] ~= nil and Koord[i].Zemljiste == ime then
					kord1 = Koord[i].Coord
					if Koord[i].Coord2 ~= nil then
						kord2 = Koord[i].Coord2
					end
				end
			end
			local a,b,c = table.unpack(kord1)
			local d,e,f = table.unpack(kord2)
			if a < d then
				x = math.random(math.floor(a), math.floor(d))
				if b < e then
					y = math.random(math.floor(b), math.floor(e))
				else
					y = math.random(math.floor(e), math.floor(b))
				end
			else
				x = math.random(math.floor(d), math.floor(a))
				if b < e then
					y = math.random(math.floor(b), math.floor(e))
				else
					y = math.random(math.floor(e), math.floor(b))
				end
			end
			x = x+0.0
			y = y+0.0
			local model = GetHashKey(Config.Kuce[brojic])
			RequestModel(model)
			Kuca = CreateObject(model, x, y, z, false, false, false)
			FreezeEntityPosition(Kuca, true)
			PlaceObjectOnGroundProperly(Kuca)
			FreezeEntityPosition(PlayerPedId(), true)
			SetModelAsNoLongerNeeded(model)
			local controls = CreateControls()
			ButtonsScaleform = Instructional.Create(controls)
			local kordac = GetEntityCoords(Kuca)
			Citizen.CreateThread(function()
				while Kuca ~= nil do
					DrawScaleformMovieFullscreen(ButtonsScaleform,255,255,255,255,0)
						if IsControlJustPressed(0, 175) then
							if (brojic+1) <= 15 then
								brojic = brojic+1
								local kordara = GetEntityCoords(Kuca)
								local model = GetHashKey(Config.Kuce[brojic])
								DeleteObject(Kuca)
								RequestModel(model)
								Kuca = CreateObject(model, kordara.x, kordara.y, kordara.z, false, false, false)
								FreezeEntityPosition(Kuca, true)
								Wait(100)
								PlaceObjectOnGroundProperly(Kuca)
								FreezeEntityPosition(PlayerPedId(), true)
								SetModelAsNoLongerNeeded(model)
							end
						end
						if IsControlJustPressed(0, 174) then
							if (brojic-1) >= 1 then
								brojic = brojic-1
								local kordara = GetEntityCoords(Kuca)
								local model = GetHashKey(Config.Kuce[brojic])
								DeleteObject(Kuca)
								RequestModel(model)
								Kuca = CreateObject(model, kordara.x, kordara.y, kordara.z, false, false, false)
								FreezeEntityPosition(Kuca, true)
								Wait(100)
								PlaceObjectOnGroundProperly(Kuca)
								FreezeEntityPosition(PlayerPedId(), true)
								SetModelAsNoLongerNeeded(model)
							end
						end
						if IsControlPressed(0, 172) then
							local korde1 = nil
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 0.0, 0.01)
							if corde.z < kordac.z+0.5 then
								SetEntityCoords(Kuca, corde)
								--PlaceObjectOnGroundProperly(Kuca)
							end
						end
						if IsControlPressed(0, 173) then
							local korde1 = nil
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 0.0, -0.01)
							if corde.z > kordac.z-0.5 then
								SetEntityCoords(Kuca, corde)
								--PlaceObjectOnGroundProperly(Kuca)
							end
						end
						if IsControlPressed(0, 32) then
							local korde1 = nil
							local korde2 = nil
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 0.1, 0.0)
							local cordea = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, 10.0, 0.0)
							local x,y,z = table.unpack(kord1)
							local x2,y2,z2 = table.unpack(kord2)
							if x < x2 then
								korde1 = kord1
								korde2 = kord2
							else
								korde2 = kord1
								korde1 = kord2
							end
							x,y,z = table.unpack(korde1)
							x2,y2,z2 = table.unpack(korde2)
							if cordea.x >= x and cordea.y >= y and cordea.x <= x2 and cordea.y <= y2 then
								SetEntityCoords(Kuca, corde)
								PlaceObjectOnGroundProperly(Kuca)
							end
						end
						if IsControlPressed(0, 33) then
							local korde1 = nil
							local korde2 = nil
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, -0.1, 0.0)
							local cordea = GetOffsetFromEntityInWorldCoords(Kuca, 0.0, -10.0, 0.0)
							local x,y,z = table.unpack(kord1)
							local x2,y2,z2 = table.unpack(kord2)
							if x < x2 then
								korde1 = kord1
								korde2 = kord2
							else
								korde2 = kord1
								korde1 = kord2
							end
							x,y,z = table.unpack(korde1)
							x2,y2,z2 = table.unpack(korde2)
							if cordea.x >= x and cordea.y >= y and cordea.x <= x2 and cordea.y <= y2 then
								SetEntityCoords(Kuca, corde)
								PlaceObjectOnGroundProperly(Kuca)
							end
						end
						if IsControlPressed(0, 34) then
							local korde1 = nil
							local korde2 = nil
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, 0.1, 0.0, 0.0)
							local cordea = GetOffsetFromEntityInWorldCoords(Kuca, 10.0, 0.0, 0.0)
							local x,y,z = table.unpack(kord1)
							local x2,y2,z2 = table.unpack(kord2)
							if x < x2 then
								korde1 = kord1
								korde2 = kord2
							else
								korde2 = kord1
								korde1 = kord2
							end
							x,y,z = table.unpack(korde1)
							x2,y2,z2 = table.unpack(korde2)
							if cordea.x >= x and cordea.y >= y and cordea.x <= x2 and cordea.y <= y2 then
								SetEntityCoords(Kuca, corde)
								PlaceObjectOnGroundProperly(Kuca)
							end
						end
						if IsControlPressed(0, 35) then
							local korde1 = nil
							local korde2 = nil
							local corde = GetOffsetFromEntityInWorldCoords(Kuca, -0.1, 0.0, 0.0)
							local cordea = GetOffsetFromEntityInWorldCoords(Kuca, -10.0, 0.0, 0.0)
							local x,y,z = table.unpack(kord1)
							local x2,y2,z2 = table.unpack(kord2)
							if x < x2 then
								korde1 = kord1
								korde2 = kord2
							else
								korde2 = kord1
								korde1 = kord2
							end
							x,y,z = table.unpack(korde1)
							x2,y2,z2 = table.unpack(korde2)
							if cordea.x >= x and cordea.y >= y and cordea.x <= x2 and cordea.y <= y2 then
								SetEntityCoords(Kuca, corde)
								PlaceObjectOnGroundProperly(Kuca)
							end
						end
						if IsControlPressed(0, 52) then
							local head = GetEntityHeading(Kuca)
							SetEntityHeading(Kuca, head+1.0)
							--PlaceObjectOnGroundProperly(Kuca)
						end
						if IsControlPressed(0, 51) then
							local head = GetEntityHeading(Kuca)
							SetEntityHeading(Kuca, head-1.0)
							--PlaceObjectOnGroundProperly(Kuca)
						end
						if IsControlJustPressed(0, 191) then
							FreezeEntityPosition(PlayerPedId(), false)
							local korda = GetEntityCoords(Kuca)
							local heading = GetEntityHeading(Kuca)
							table.insert(Kuce, {Zemljiste = ime, Objekt = Kuca})
							TriggerServerEvent("zemljista:SpremiKucu", ime, korda, heading, Config.Kuce[brojic])
							break
						end
						if IsControlJustPressed(0, 73) then
							FreezeEntityPosition(PlayerPedId(), false)
							DeleteObject(Kuca)
							Kuca = nil
							break
						end
						Citizen.Wait(1)
				end
			end)
		elseif data.current.value == 'prodaj' then
			menu.close()
			TriggerServerEvent("zemljista:ProdajZemljiste", ime)
		elseif data.current.value == 'kuca2' then
			menu.close()
			TriggerServerEvent("zemljista:SrusiKucu", ime)
		elseif data.current.value == 'ulaz' then
			menu.close()
			local trazi = true
			ESX.ShowNotification("Prosetajte do ulaza u kucu i pritisnite lijevu tipku misa kako bih ste spremili koordinate!")
			ESX.ShowNotification("Ukoliko ne zelite spremiti koordinate, pritisnite X!")
			Citizen.CreateThread(function()
				while trazi do
					Citizen.Wait(1)
					if IsControlJustPressed(0, 24) then
						local korde = GetEntityCoords(PlayerPedId())
						TriggerServerEvent("zemljista:PostaviUlaz", ime, korde)
						trazi = false
					end
					if IsControlPressed(0, 186) then
						trazi = false
						ESX.ShowNotification("Odustali ste od postavljanja ulaza u kucu!")
					end
				end
			end)
		elseif data.current.value == 'ulaz2' then
			menu.close()
			local trazi = true
			ESX.ShowNotification("Prosetajte do ulaza u kucu i pritisnite lijevu tipku misa kako bih ste spremili koordinate!")
			ESX.ShowNotification("Ukoliko ne zelite spremiti koordinate, pritisnite X!")
			Citizen.CreateThread(function()
				while trazi do
					Citizen.Wait(1)
					if IsControlJustPressed(0, 24) then
						local korde = GetEntityCoords(PlayerPedId())
						TriggerServerEvent("zemljista:UrediUlaz", ime, korde)
						trazi = false
					end
					if IsControlPressed(0, 186) then
						trazi = false
						ESX.ShowNotification("Odustali ste od postavljanja ulaza u kucu!")
					end
				end
			end)
		elseif data.current.value == 'kupi' then
			ESX.TriggerServerCallback('loaf_housing:ImalKucu', function(imal)
				if not imal then
					local elements2 = {
						{label = "Da", value = 'da'},
						{label = "Ne", value = 'ne'}
					}
					ESX.UI.Menu.Open(
					  'default', GetCurrentResourceName(), 'zemljiste2',
					  {
						title    = "Zelite li kupiti zemljiste za $"..cijena.."?",
						align    = 'top-left',
						elements = elements2,
					  },
					  function(data2, menu2)
						if data2.current.value == 'da' then
							TriggerServerEvent("zemljista:Kupi", ime)
							menu2.close()
							menu.close()
							CurrentAction     = 'menu_zemljiste'
							CurrentActionMsg  = "Pritisnite E da vidite opcije zemljista"
							CurrentActionData = {ime = ime}
						elseif data2.current.value == 'ne' then
							menu2.close()
							menu.close()
							CurrentAction     = 'menu_zemljiste'
							CurrentActionMsg  = "Pritisnite E da vidite opcije zemljista"
							CurrentActionData = {ime = ime}
						end
					  end,
					  function(data2, menu2)

						menu2.close()

						CurrentAction     = 'menu_zemljiste'
						CurrentActionMsg  = "Pritisnite E da vidite opcije zemljista"
						CurrentActionData = {ime = ime}
					  end
					)
				else
					ESX.ShowNotification("Vec imate kupljenu kucu!")
				end
			end)
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_zemljiste'
		CurrentActionMsg  = "Pritisnite E da vidite opcije zemljista"
		CurrentActionData = {ime = ime}
      end
    )
end

RegisterCommand("uredizemljiste", function(source, args, raw)
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
								TriggerServerEvent("zemljista:NapraviMafiju", mIme, mLabel)
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
															TriggerServerEvent("zemljista:NapraviRank", Imenjive, rID, rIme, rLabel)
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
															TriggerServerEvent("zemljista:NapraviRank", Imenjive, rankid, rIme, rLabel)
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
											TriggerServerEvent("zemljista:ObrisiRank", rankid, Imenjive)
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
													TriggerServerEvent("zemljista:DodajVozilo", Imenjive, vIme, vLabel)
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
															TriggerServerEvent("zemljista:DodajVozilo", Imenjive, vIme, vLabel, voziloime)
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
											TriggerServerEvent("zemljista:ObrisiVozilo", voziloime, Imenjive)
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
													TriggerServerEvent("zemljista:DodajOruzje", Imenjive, orIme, orCijena)
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
															TriggerServerEvent("zemljista:DodajOruzje", Imenjive, orIme, orCijena, oruzjeime)
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
											TriggerServerEvent("zemljista:ObrisiOruzje", oruzjeime, Imenjive)
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
								TriggerServerEvent("zemljista:SpremiCoord", Imenjive, coord, tonumber(mid), head)
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
															TriggerServerEvent("zemljista:DodajBoju", Imenjive, br, 2, bojR, bojG, bojB)
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
											TriggerServerEvent("zemljista:DodajBoju", Imenjive, br, bojID)
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
									TriggerServerEvent("zemljista:PromjeniIme", Imenjive, mafIme)
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
									TriggerServerEvent("zemljista:ObrisiMafiju", Imenjive)
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

RegisterCommand("napravizemljiste", function(source, args, raw)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			if args[1] then
				local korda = GetEntityCoords(PlayerPedId())
				TriggerServerCallback("zemljista:NapraviZemljiste", args[1], korda)
			else
				TriggerClientEvent('esx:showNotification', source, '/napravizemljiste [Cijena]')
			end
		end
	end)
end, false)

RegisterCommand("postavikoord", function(source, args, raw)
	if args[1] and args[2] then
		local Postoji = 0
		for i=1, #Zemljista, 1 do
			if Zemljista[i] ~= nil and Zemljista[i].Ime == args[1] then
				Postoji = 1
			end
		end
		if Postoji == 1 and (tonumber(args[2]) > 0 and tonumber(args[2]) < 3) then
			local coord = GetEntityCoords(PlayerPedId())
			TriggerServerEvent("zemljista:SpremiCoord", args[1], coord, tonumber(args[2]))
		else
			ESX.ShowNotification("Zemljiste ne postoji")
		end
	else
		ESX.ShowNotification("/postavikoord [Ime zemljista][1 - x1,y1 | 2 - x2,y2]")
	end
end, false)

RegisterCommand("debug", function(source, args, raw)
	if Kuca ~= nil then
		DeleteObject(Kuca)
		Kuca = nil
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

AddEventHandler('zemljista:hasEnteredMarker', function(station, part, partNum)
  if part == 'Zemljiste' then
    CurrentAction     = 'menu_zemljiste'
    CurrentActionMsg  = "Pritisnite E da vidite opcije zemljista"
    CurrentActionData = {ime = partNum}
  end
end)

AddEventHandler('zemljista:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('zemljista:UpdateKoord')
AddEventHandler('zemljista:UpdateKoord', function(koor)
	Koord = koor
end)

RegisterNetEvent('zemljista:UpdateZemljista')
AddEventHandler('zemljista:UpdateZemljista', function(njiv)
	Zemljista = njiv
end)

-- Display markers
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		
		if CurrentAction ~= nil then
			naso = 1
			waitara = 1
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then
				if CurrentAction == 'menu_zemljiste' then
					OpenZemljisteMenu(CurrentActionData.ime)
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
		
		for i=1, #Zemljista, 1 do
			if Zemljista[i] ~= nil then
				if #(coords-Zemljista[i].MKoord) < 100.0 then
					waitara = 1
					naso = 1
					DrawMarker(0, Zemljista[i].MKoord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
				end
				if #(coords-Zemljista[i].MKoord) < 3.0 then
					waitara = 1
					naso = 1
					isInMarker     = true
					currentStation = 1
					currentPart    = 'Zemljiste'
					currentPartNum = Zemljista[i].Ime
				end
			end
		end
		
		--[[for i=1, #Koord, 1 do
			if Koord[i] ~= nil then
				local x,y,z = table.unpack(Koord[i].Coord)
				if Koord[i].Coord2 ~= nil then
					local x2,y2,z2 = table.unpack(Koord[i].Coord2)
					if (x ~= 0 and x ~= nil) and (y ~= 0 and y ~= nil) and (z ~= 0 and z ~= nil) then
						if IsEntityInArea(PlayerPedId(), x, y, z, x2, y2, z2, false, false, 0) then
							naso = 1
							waitara = 1
							isInMarker     = true
							currentStation = 1
							currentPart    = 'Zemljiste'
							currentPartNum = Koord[i].Zemljiste
						end
					end
				end
			end
		end]]
		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

			if
				(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('zemljista:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('zemljista:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

			HasAlreadyEnteredMarker = false

			TriggerEvent('zemljista:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end
		if naso == 0 then
			waitara = 500
		end
	end
end)
