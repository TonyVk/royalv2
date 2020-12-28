ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local copsConnected 		= 0
local robberPlayers 		= {}
local isCurrentlyRobbed = false
local Cooldown 			= false
local IsDead			= false
local Hakiro = {}
local KrenilaPljacka = {}
local PljackaID = nil
local JelZatvoreno = false

RegisterNetEvent('esx_pljacke:Broji')
AddEventHandler('esx_pljacke:Broji', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'sipa' then
		copsConnected = copsConnected+1
	end
end)

ESX.RegisterServerCallback("BrojPolicajacaDuznost",function(source,cb)
	cb(copsConnected)
end)

ESX.RegisterServerCallback("banke:JelImasLaptop",function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local laptop = xPlayer.getInventoryItem("net_cracker").count
	if laptop > 0 then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("JelTrajePljacka",function(source,cb)
	local Kurac = {}
	if PljackaID ~= nil then
		if KrenilaPljacka[PljackaID] ~= nil then
			Kurac[1] = PljackaID
			Kurac[2] = KrenilaPljacka[PljackaID]
			cb(Kurac)
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("banke:JesteZatvorene",function(source,cb)
	cb(JelZatvoreno)
end)

function CountCops()
	copsConnected = 0
	TriggerClientEvent('esx_policejob:DajNaDuznosti', -1)
	SetTimeout(1000, function()
		TriggerClientEvent('esx_advanced_holdup:copsConnected', -1, copsConnected)
    end)
	SetTimeout(60000, CountCops)
end

RegisterNetEvent('esx_pljacke:Hakiro')
AddEventHandler('esx_pljacke:Hakiro', function(bank, br)
	Hakiro[bank] = br
	TriggerClientEvent("HakiraoJu", -1, bank, br)
end)

function AddMoneyToStores()

	for _, v in pairs(Config.Zones) do
		if v.MoneyRegeneration ~= nil then
			local MaxMoney		= v.MaxMoney
			local MoneyRegen	= v.MoneyRegeneration
			if v.CurrentMoney < MaxMoney then
				v.CurrentMoney = v.CurrentMoney + MoneyRegen
			else
				v.CurrentMoney = MaxMoney
			end
		end
	end

	SetTimeout(Config.AddMoneyToStoresTimeOut * 60000, AddMoneyToStores)

end

function AddMoneyToBanks()

	for _, v in pairs(Config.Zones) do
		if v.MoneyRegeneration ~= nil then
			local partOfCurrentMoney 	= ESX.Round(v.CurrentMoney * Config.PercentCurrentMoney / 100)
			--local randomMoneyToBank 	= math.random(partOfCurrentMoney, partOfCurrentMoney * Config.MaxRandomMultiplier)
			v.CurrentMoney = v.CurrentMoney - partOfCurrentMoney
			Config.Zones[v.BankToDeliver].CurrentMoney = Config.Zones[v.BankToDeliver].CurrentMoney + partOfCurrentMoney
			if Config.Zones[v.BankToDeliver].CurrentMoney > Config.Zones[v.BankToDeliver].MaxMoney then
				Config.Zones[v.BankToDeliver].CurrentMoney = Config.Zones[v.BankToDeliver].MaxMoney
			end
		end
	end

	SetTimeout(Config.AddMoneyToBanksTimeOut * 60000, AddMoneyToBanks)

end

RegisterNetEvent('pljacka:VratiDeath')
AddEventHandler('pljacka:VratiDeath', function(ba)
	isDead = ba
end)

RegisterNetEvent('pljacka:SaljiZatvaranje')
AddEventHandler('pljacka:SaljiZatvaranje', function(be)
	JelZatvoreno = be
	TriggerClientEvent("ZatvoreneBanke", -1, JelZatvoreno)
	if be == true then
		Citizen.CreateThread(function()
			SetTimeout(600000, function()
				JelZatvoreno = false
				TriggerClientEvent("ZatvoreneBanke", -1, JelZatvoreno)
			end)
		end)
	end
end)

RegisterServerEvent('esx_advanced_holdup:robberyCanceled')
AddEventHandler('esx_advanced_holdup:robberyCanceled', function(zone)
	local _source 	= source
	local xPlayer		= ESX.GetPlayerFromId(_source)
	local xPlayers 	= ESX.GetPlayers()

	isCurrentlyRobbed = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sipa' then
			TriggerClientEvent('esx_advanced_holdup:robCompleteAtNotification', xPlayer.source, zone, false)
			TriggerClientEvent('esx_advanced_holdup:killBlip', xPlayer.source)
		end
	end

	if robberPlayers[_source] then
		robberPlayers[_source] = nil
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('robbery_has_cancelled'))
	end
end)

RegisterServerEvent('pljacka:PratiGa')
AddEventHandler('pljacka:PratiGa', function(id)
	TriggerClientEvent("PratiPljackasa", -1, id)
end)

function PaliBrojacOtvaranja()
	Citizen.CreateThread(function()
		SetTimeout(600000, function()
			JelZatvoreno = false
			TriggerClientEvent("ZatvoreneBanke", -1, JelZatvoreno)
		end)
	end)
end

RegisterServerEvent('pljacka:NastaviDalje')
AddEventHandler('pljacka:NastaviDalje', function(mainZone, tip)
	local _source 	= source
	local xPlayer		= ESX.GetPlayerFromId(_source)
	local xPlayers 	= ESX.GetPlayers()

	if Config.Zones[mainZone] then

		local zone = Config.Zones[mainZone]

		if not isCurrentlyRobbed then
			if not Cooldown then
				Cooldown = true
				isCurrentlyRobbed = true
				TriggerClientEvent('esx_advanced_holdup:robPoliceNotification', source, mainZone)
				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer ~= nil then
						if xPlayer.job.name == 'police' or xPlayer.job.name == 'sipa' then
							--TriggerClientEvent('esx_advanced_holdup:robPoliceNotification', xPlayer.source, mainZone)
							TriggerClientEvent('esx_advanced_holdup:setBlip', xPlayer.source, Config.Zones[mainZone].Pos)
						end
					end
				end

				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob'))
				TriggerClientEvent('esx_advanced_holdup:startRobberingTimer', _source, mainZone)
				KrenilaPljacka[mainZone] = true
				TriggerClientEvent("TrajePljackaa", -1, mainZone, true)
				PljackaID = mainZone

				Config.Zones[mainZone].Robbed = os.time()
				robberPlayers[_source]	= mainZone
				local savedSource 			= _source

				SetTimeout(zone.TimeToRob * 1000, function()

					if robberPlayers[savedSource] then
						isCurrentlyRobbed = false
						if xPlayer then
								xPlayer.addMoney(zone.CurrentMoney)
								ESX.SavePlayer(xPlayer, function() 
								end)
								if tip == 2 then
									JelZatvoreno = true
									TriggerClientEvent("ZatvoreneBanke", -1, JelZatvoreno)
									PaliBrojacOtvaranja()
								end
								TriggerClientEvent('esx_advanced_holdup:robCompleteNotification', xPlayer.source)
								for i=1, #xPlayers, 1 do
									local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
									if xPlayer ~= nil then
										if xPlayer.job.name == 'police' or xPlayer.job.name == 'sipa' then
											TriggerClientEvent('esx_advanced_holdup:robCompleteAtNotification', xPlayer.source, robberPlayers[savedSource], true)
											TriggerClientEvent('esx_advanced_holdup:killBlip', xPlayer.source)
										end
									end
								end
						else
							for i=1, #xPlayers, 1 do
								local xPlayera = ESX.GetPlayerFromId(xPlayers[i])
								if xPlayera.job.name == 'police' or xPlayer.job.name == 'sipa' then
									--TriggerClientEvent('esx_advanced_holdup:robCompleteAtNotification', xPlayer.source, robberPlayers[savedSource], true)
									TriggerClientEvent('esx_advanced_holdup:killBlip', xPlayera.source)
								end
							end
						end
					end
				end)
				--1200000
				SetTimeout(1200000, function()
					KrenilaPljacka[mainZone] = false
					PljackaID = nil
					TriggerClientEvent("TrajePljackaa", -1, mainZone, false)
					TriggerClientEvent("VratiVrata", -1, mainZone)
					Cooldown = false
				end)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Ne mozete trenutno pljackat!")
			end

		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('robbery_already_in_progress'))
		end

	end
end)

RegisterServerEvent('pljacka:UTijeku')
AddEventHandler('pljacka:UTijeku', function(mainZone, tip)

	local _source 	= source
	local xPlayer		= ESX.GetPlayerFromId(_source)
	local xPlayers 	= ESX.GetPlayers()

	if Config.Zones[mainZone] then

		local zone = Config.Zones[mainZone]

		if not isCurrentlyRobbed then
			if not Cooldown then
				if zone.Robbed ~= 0 and (os.time() - zone.Robbed) < zone.TimeBeforeNewRob then
					local timerNewRob = zone.TimeBeforeNewRob - (os.time() - zone.Robbed)
					TriggerClientEvent('esx:showNotification', _source, _U('already_robbed_1'))
					TriggerClientEvent('esx:showNotification', _source, _U('already_robbed_2', timerNewRob))
					return
				elseif copsConnected < zone.PoliceRequired then
					TriggerClientEvent('esx:showNotification', _source, _U('police_required', zone.PoliceRequired))
					return
				end
				if tip == 1 then
					TriggerClientEvent("esx_pljacke:OdradiLockPick", _source, mainZone, tip)
					return
				end
				Cooldown = true
				isCurrentlyRobbed = true
				TriggerClientEvent('esx_advanced_holdup:robPoliceNotification', source, mainZone)
				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer ~= nil then
						if xPlayer.job.name == 'police' or xPlayer.job.name == 'sipa' then
							--TriggerClientEvent('esx_advanced_holdup:robPoliceNotification', xPlayer.source, mainZone)
							TriggerClientEvent('esx_advanced_holdup:setBlip', xPlayer.source, Config.Zones[mainZone].Pos)
						end
					end
				end

				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob'))
				TriggerClientEvent('esx_advanced_holdup:startRobberingTimer', _source, mainZone)
				KrenilaPljacka[mainZone] = true
				TriggerClientEvent("TrajePljackaa", -1, mainZone, true)
				PljackaID = mainZone

				Config.Zones[mainZone].Robbed = os.time()
				robberPlayers[_source]	= mainZone
				local savedSource 			= _source

				SetTimeout(zone.TimeToRob * 1000, function()

					if robberPlayers[savedSource] then
						isCurrentlyRobbed = false
						if xPlayer then
								xPlayer.addMoney(zone.CurrentMoney)
								ESX.SavePlayer(xPlayer, function() 
								end)
								if tip == 2 then
									JelZatvoreno = true
									TriggerClientEvent("ZatvoreneBanke", -1, JelZatvoreno)
									PaliBrojacOtvaranja()
								end
								TriggerClientEvent('esx_advanced_holdup:robCompleteNotification', xPlayer.source)
								for i=1, #xPlayers, 1 do
									local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
									if xPlayer ~= nil then
										if xPlayer.job.name == 'police' or xPlayer.job.name == 'sipa' then
											TriggerClientEvent('esx_advanced_holdup:robCompleteAtNotification', xPlayer.source, robberPlayers[savedSource], true)
											TriggerClientEvent('esx_advanced_holdup:killBlip', xPlayer.source)
										end
									end
								end
						else
							for i=1, #xPlayers, 1 do
								local xPlayera = ESX.GetPlayerFromId(xPlayers[i])
								if xPlayera.job.name == 'police' or xPlayer.job.name == 'sipa' then
									--TriggerClientEvent('esx_advanced_holdup:robCompleteAtNotification', xPlayer.source, robberPlayers[savedSource], true)
									TriggerClientEvent('esx_advanced_holdup:killBlip', xPlayera.source)
								end
							end
						end
					end
				end)
				--1200000
				SetTimeout(1200000, function()
					KrenilaPljacka[mainZone] = false
					PljackaID = nil
					TriggerClientEvent("TrajePljackaa", -1, mainZone, false)
					TriggerClientEvent("VratiVrata", -1, mainZone)
					Cooldown = false
				end)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Ne mozete trenutno pljackat!")
			end

		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('robbery_already_in_progress'))
		end

	end

end)

CountCops()
AddMoneyToStores()
AddMoneyToBanks()
