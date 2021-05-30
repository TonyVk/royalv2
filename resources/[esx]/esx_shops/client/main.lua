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

ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local CurrentID 			  = nil
local blip = {}
local NoveCijene = {}
local PrviSpawn = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)

	ESX.TriggerServerCallback('esx_shops:requestDBItems', function(ShopItems, kjurac)
		for k,v in pairs(ShopItems) do
			--if k ~= "Bar" then
				Config.Zones[k].Items = v
			--end
		end
		NoveCijene = kjurac
	end)
	Citizen.Wait(1000)
	ReloadBlip()
end)

function OpenCijeneMenu(zone, st)
			local elements2 = {}
			for i=1, #Config.Zones[zone].Items, 1 do
				local item = Config.Zones[zone].Items[i]
				
				if #NoveCijene > 0 then
					local naso = false
					for j=1, #NoveCijene, 1 do
						if NoveCijene[j].store == st and NoveCijene[j].item == item.item then
							naso = true
							table.insert(elements2, {
								label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(NoveCijene[j].cijena))),
								item       = item.item,
								price      = NoveCijene[j].cijena,
							})
						end
					end
					if not naso then
						table.insert(elements2, {
							label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
							item       = item.item,
							price      = item.price,
						})
					end
				else
					table.insert(elements2, {
						label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
						item       = item.item,
						price      = item.price,
					})
				end
			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shopc', {
				title    = "Izaberite proizvod",
				align    = 'bottom-right',
				elements = elements2
			}, function(data5, menu5)
				ESX.UI.Menu.Open(
				  'dialog', GetCurrentResourceName(), 'shops_pr_cijenu',
				  {
					title = "Unesite novu cijenu proizvoda"
				  },
				  function(data6, menu6)
					menu5.close()
					local count = tonumber(data6.value)

					if count == nil then
						ESX.ShowNotification("Kriva vrijednost!")
					else
						menu6.close()
						TriggerServerEvent("esx_shops:PromjeniCijenu", zone, st, data5.current.item, count)
						Wait(1000)
						OpenCijeneMenu(zone, st)
					end
				  end,
				  function(data6, menu6)
					menu6.close()
				  end
				)
			end, function(data5, menu5)
				menu5.close()
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {zone = zone}
			end)
end

RegisterNetEvent('trgovine:PitajProdaju')
AddEventHandler('trgovine:PitajProdaju', function(ime, cijena, pid)
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'trgovara',
		{
				title    = "Zelite li kupiti trgovinu "..ime.." za $"..cijena.."?",
				align    = 'top-left',
				elements = {
					{label = "Da", value = 'da'},
					{label = "Ne", value = 'ne'}
				},
		},
		function(data69, menu69)
			menu69.close()
			if data69.current.value == 'da' then
				TriggerServerEvent("trgovine:PrihvatioProdaju", ime, cijena, pid)
			end

			if data69.current.value == 'ne' then
				ESX.ShowNotification("Odbili ste ponudu za kupnju trgovine!")
				TriggerServerEvent("trgovine:OdbioProdaju", pid)
				menu69.close()
			end
		end,
		function(data69, menu69)
			 menu69.close()
		end
	)
end)

function OpenShopMenu(zone)
	local elements = {}
	local st = zone..CurrentID
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		if item.limit == -1 then
			item.limit = 100
		end
		
		if #NoveCijene > 0 then
			local naso = false
			for j=1, #NoveCijene, 1 do
				if NoveCijene[j].store == st and NoveCijene[j].item == item.item then
					naso = true
					table.insert(elements, {
						label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(NoveCijene[j].cijena))),
						label_real = item.label,
						item       = item.item,
						price      = NoveCijene[j].cijena,

						-- menu properties
						value      = 1,
						type       = 'slider',
						min        = 1,
						max        = item.limit
					})
				end
			end
			if not naso then
				table.insert(elements, {
					label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
					label_real = item.label,
					item       = item.item,
					price      = item.price,

					-- menu properties
					value      = 1,
					type       = 'slider',
					min        = 1,
					max        = item.limit
				})
			end
		else
			table.insert(elements, {
				label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
				label_real = item.label,
				item       = item.item,
				price      = item.price,

				-- menu properties
				value      = 1,
				type       = 'slider',
				min        = 1,
				max        = item.limit
			})
		end
	end
	local lova = 0
	ESX.TriggerServerCallback('esx_shops:DajSef', function(lov)
		lova = lov
	end, st)
	Wait(400)
	ESX.TriggerServerCallback('esx_shops:DajDostupnost', function(jelje)
			if jelje == 1 then
				table.insert(elements, {
					label      = "Kupite trgovinu ($2000000)",
					label_real = "kupi",
					item       = "kupit",
					price      = 2000000,
				})
			else
				ESX.TriggerServerCallback('esx_shops:DalJeVlasnik', function(jelje2)
						if jelje2 == 1 then
							table.insert(elements, {
								label      = "Podignite novac $"..lova,
								label_real = "podigni",
								item       = "podignin",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Promjenite cijene proizvoda",
								label_real = "prcijene",
								item       = "prc",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Prodaj igracu",
								label_real = "prodaj2",
								item       = "prodajt2",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Prodaj ($1000000)",
								label_real = "prodaj",
								item       = "prodajt",
								price      = 0,
							})
						end
				end, st)
			end
	end, st)
	Wait(1000)

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = _U('shop'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.item == 'kupit' then
			TriggerServerEvent('ducan:piku2', zone, CurrentID)
			menu.close()
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {zone = zone}
		elseif data.current.item == 'podignin' then
			ESX.UI.Menu.Open(
			  'dialog', GetCurrentResourceName(), 'shops_daj_lovu',
			  {
				title = "Unesite koliko novca zelite podici"
			  },
			  function(data3, menu3)

				local count = tonumber(data3.value)

				if count == nil then
					ESX.ShowNotification("Kriva vrijednost!")
				elseif lova < count then
					ESX.ShowNotification("Nemate toliko u sefu!")
				else
					menu3.close()
					menu.close()
					TriggerServerEvent("esx_shops:OduzmiFirmi", st, count)
					CurrentAction     = 'shop_menu'
					CurrentActionMsg  = _U('press_menu')
					CurrentActionData = {zone = zone}
				end

			  end,
			  function(data3, menu3)
				menu3.close()
			  end
			)
		elseif data.current.item == 'prodajt' then
			menu.close()
			TriggerServerEvent("esx_shops:ProdajFirmu", st)
		elseif data.current.item == 'prodajt2' then
			local player, distance = ESX.Game.GetClosestPlayer()
			if distance ~= -1 and distance <= 3.0 then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'trg_prodaj_igr',
					{
						title = "Unesite cijenu za koju zelite prodati trgovinu"
					},
					function(data3, menu3)

					local count = tonumber(data3.value)

					if count == nil then
						ESX.ShowNotification("Kriva vrijednost!")
					else
						menu3.close()
						menu.close()
						TriggerServerEvent("trgovine:ProdajIgracu", st, GetPlayerServerId(player), count)
					end
					end,
					function(data3, menu3)
						menu3.close()
						menu.close()
					end
				)
			else
				ESX.ShowNotification('Nema igraca u blizini!')
			end
		elseif data.current.item == 'prc' then
			menu.close()
			OpenCijeneMenu(zone, st)
		else
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title    = _U('shop_confirm', data.current.value, data.current.label_real, ESX.Math.GroupDigits(data.current.price * data.current.value)),
				align    = 'bottom-right',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				if data2.current.value == 'yes' then
					local torba = 0
					TriggerEvent('skinchanger:getSkin', function(skin)
						torba = skin['bags_1']
					end)
					if torba == 40 or torba == 41 or torba == 44 or torba == 45 then
						TriggerServerEvent('ducan:piku', data.current.item, data.current.value, zone, CurrentID, true)
					else
						TriggerServerEvent('ducan:piku', data.current.item, data.current.value, zone, CurrentID, false)
					end
				end

				menu2.close()
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {zone = zone}
	end)
end

AddEventHandler('esx_shops:hasEnteredMarker', function(zone, id)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {zone = zone}
	CurrentID = id
end)

AddEventHandler('esx_shops:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

function ReloadBlip()
	for k,v in pairs(Config.Zones) do
		for i = 1, #v.Pos, 1 do
			local st = k..i
			ESX.TriggerServerCallback('esx_shops:DalJeVlasnik', function(jelje2)
				if jelje2 == 1 then
					RemoveBlip(blip[st])
					blip[st] = AddBlipForCoord(v.Pos[i])
					if k == "Bar" then
						SetBlipSprite (blip[st], 93)
					else
						SetBlipSprite (blip[st], 52)
					end
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 67)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					if k == "Bar" then
						AddTextComponentString("Bar")
					else
						AddTextComponentString(_U('shops'))
					end
					EndTextCommandSetBlipName(blip[st])
				else
					RemoveBlip(blip[st])
					blip[st] = AddBlipForCoord(v.Pos[i])
					if k == "Bar" then
						SetBlipSprite (blip[st], 93)
					else
						SetBlipSprite (blip[st], 52)
					end
					SetBlipDisplay(blip[st], 4)
					SetBlipScale  (blip[st], 1.0)
					SetBlipColour (blip[st], 2)
					SetBlipAsShortRange(blip[st], true)
					BeginTextCommandSetBlipName("STRING")
					if k == "Bar" then
						AddTextComponentString("Bar")
					else
						AddTextComponentString(_U('shops'))
					end
					EndTextCommandSetBlipName(blip[st])
				end
			end, st)
		end
	end
end

RegisterNetEvent('esx_shops:ReloadBlip')
AddEventHandler('esx_shops:ReloadBlip', function()
	ReloadBlip()
end)

RegisterNetEvent('esx_shops:UpdateCijene')
AddEventHandler('esx_shops:UpdateCijene', function(cij)
	NoveCijene = cij
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local nasosta = 0
		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil
		local ID = nil
		
		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(Config.Type ~= -1 and #(coords-v.Pos[i]) < Config.DrawDistance) then
					waitara = 0
					nasosta = 1
					DrawMarker(Config.Type, v.Pos[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if #(coords-v.Pos[i]) < Config.Size.x then
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
					ID = i
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_shops:hasEnteredMarker', currentZone, ID)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_shops:hasExitedMarker', LastZone)
		end
		
		if nasosta == 0 then
			waitara = 500
		end
	end
end)

AddEventHandler("playerSpawned", function()
	if not PrviSpawn then
		ReloadBlip()
		PrviSpawn = true
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu(CurrentActionData.zone)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
