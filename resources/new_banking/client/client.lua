--================================================================================================--
--==                                VARIABLES - DO NOT EDIT                                     ==--
--================================================================================================--
ESX                         = nil
inMenu                      = true
local atbank = false
local bankMenu = true
local JelZatvoreno = false
local PrviSpawn = false
local NemaStruje = false

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

--================================================================================================
--==                                THREADING - DO NOT EDIT                                     ==
--================================================================================================

--===============================================
--==           Base ESX Threading              ==
--===============================================
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('elektricar:NemaStruje')
AddEventHandler('elektricar:NemaStruje', function(br)
	NemaStruje = br
end)

AddEventHandler("playerSpawned", function()
	if not PrviSpawn then
		ESX.TriggerServerCallback('banke:JesteZatvorene', function(br)
			JelZatvoreno = br
		end)
		PrviSpawn = true
	end
end)


--===============================================
--==             Core Threading                ==
--===============================================
if bankMenu then
	Citizen.CreateThread(function()
		local waitara = 500
		while true do
			Citizen.Wait(waitara)
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				if nearBank() or nearATM() then
					waitara = 0
					DisplayHelpText(_U('atm_open'))
					if IsControlJustPressed(1, 38) then
						if JelZatvoreno == false then
							if not NemaStruje then
								playAnim('mp_common', 'givetake1_a', 2500)
								Citizen.Wait(2500)
								inMenu = true
								SetNuiFocus(true, true)
								SendNUIMessage({type = 'openGeneral'})
								ESX.TriggerServerCallback('banka:DohvatiKredit', function(br)
									SendNUIMessage({
										type = "narediKredit",
										kredit = br.kredit,
										rata = br.rata
									})
								end)
								TriggerServerEvent('bank:balance')
							else
								waitara = 500
								ESX.ShowAdvancedNotification('BANKA', 'Obavijest', 'Ne mozemo odradivati transakcije posto trenutno nemamo struje!', "CHAR_BANK_FLEECA", 2)
							end
						else
							waitara = 500
							ESX.ShowAdvancedNotification('BANKA', 'Obavijest', 'Zbog pljacke jedne od nasih poslovnica nismo u stanju trenutno odradjivati transakcije novca!', "CHAR_BANK_FLEECA", 2)
						end
					end
				else
					waitara = 500
				end
				if inMenu == true then
					if IsControlJustPressed(1, 322) then
						inMenu = false
						SetNuiFocus(false, false)
						SendNUIMessage({type = 'close'})
					end
				end
			else
				waitara = 500
			end
		end
	end)
end


--===============================================
--==             Map Blips	                   ==
--===============================================

--BANK
Citizen.CreateThread(function()
	if Config.ShowBlips then
	  for k,v in ipairs(Config.Bank)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (blip, v.id)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.9)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('bank_blip'))
		EndTextCommandSetBlipName(blip)
	  end
	end
end)

--ATM
Citizen.CreateThread(function()
	if Config.ShowBlips and Config.OnlyBank == false then
	  for k,v in ipairs(Config.ATM)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (blip, v.id)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.9)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('atm_blip'))
		EndTextCommandSetBlipName(blip)
	  end
	end
end)

RegisterNetEvent('ZatvoreneBanke')
AddEventHandler('ZatvoreneBanke', function(br)
	JelZatvoreno = br
	if br == true then
		ESX.ShowAdvancedNotification('BANKA', 'Obavijest', 'Zbog pljacke jedne od nasih poslovnica nismo u stanju trenutno obradjivati transakcije novca!', "CHAR_BANK_FLEECA", 2)
	else
		ESX.ShowAdvancedNotification('BANKA', 'Obavijest', 'Transakcije novca su osposobljene i nase usluge se mogu koristiti opet!', "CHAR_BANK_FLEECA", 2)
	end
end)

--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)

	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = Sanitize(playerName)
		})
end)

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

RegisterNUICallback('vratikredit', function()
	ESX.TriggerServerCallback('banka:DohvatiKredit', function(br)
		if br.kredit == 0 then
			ESX.ShowNotification("Nemate podignut kredit!")
		else
			TriggerServerEvent("banka:VratiKredit")
			TriggerServerEvent('bank:balance')
			Wait(200)
			ESX.TriggerServerCallback('banka:DohvatiKredit', function(br)
				SendNUIMessage({
					type = "narediKredit",
					kredit = br.kredit,
					rata = br.rata
				})
			end)
		end
	end)
end)

RegisterNUICallback('kredit', function(data)
	ESX.TriggerServerCallback('banka:DohvatiKredit', function(br)
		if br.kredit == 0 then
			PlayerData = ESX.GetPlayerData()
			if PlayerData.job.name ~= "unemployed" then
				if br.brplaca >= 400 then
					TriggerServerEvent('banka:podignikredit', tonumber(data.amount))
					TriggerServerEvent('bank:balance')
					Wait(200)
					ESX.TriggerServerCallback('banka:DohvatiKredit', function(br)
						SendNUIMessage({
							type = "narediKredit",
							kredit = br.kredit,
							rata = br.rata
						})
					end)
				else
					local brojic = 400-br.brplaca
					if brojic >= 1 and brojic <= 4 then
						ESX.ShowNotification("Nije vam jos dozvoljeno podizati kredit, moci cete nakon "..brojic.." primljene place!")
					else
						ESX.ShowNotification("Nije vam jos dozvoljeno podizati kredit, moci cete nakon "..brojic.." primljenih placa!")
					end
				end
			else
				ESX.ShowNotification("Ne mozete podici kredit ako ste nezaposleni!")
			end
		else
			ESX.ShowNotification("Vec imate podignut kredit koji nije vracen do kraja!")
		end
	end)
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('banka:predaj', tonumber(data.amount))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==          Withdraw Event                   ==
--===============================================
RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('banka:podigni', tonumber(data.amountw))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)


--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('banka:prebaci', data.to, data.amountt)
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Result   Event                    ==
--===============================================
RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)

--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
			playAnim('mp_common', 'givetake1_a', 2500)
			Citizen.Wait(2500)
	SendNUIMessage({type = 'closeAll'})
end)


--===============================================
--==            Capture Bank Distance          ==
--===============================================
function nearBank()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)

	for _, search in pairs(Config.Bank) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

		if distance <= 3 then
			return true
		end
	end
end

function nearATM()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	local veh = IsPedInAnyVehicle(PlayerPedId(), false)

	for _, search in pairs(Config.ATM) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

		if distance <= 2 and not veh then
			return true
		end
	end
end


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
