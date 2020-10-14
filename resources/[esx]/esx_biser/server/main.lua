ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingKoda    = {}
local PlayersTransformingKoda  = {}
local PlayersSellingKoda       = {}
local TrajeTimer 			   = {}
local TrajeTimer2 			   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()
	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sipa' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

--kodeina
local function HarvestKoda(source, torba)
	if not TrajeTimer2[source] then
		TrajeTimer2[source] = true
		SetTimeout(Config.TimeToFarm, function()
			TrajeTimer2[source] = false
			if PlayersHarvestingKoda[source] then
				local xPlayer = ESX.GetPlayerFromId(source)
				local koda = xPlayer.getInventoryItem('skoljka')

				if torba then
					if koda.limit ~= -1 and koda.count >= koda.limit*2 then
						TriggerClientEvent('esx:showNotification', source, _U('mochila_full'))
					else
						xPlayer.addInventoryItem('skoljka', 1)
						HarvestKoda(source)
					end
				else
					if koda.limit ~= -1 and koda.count >= koda.limit then
						TriggerClientEvent('esx:showNotification', source, _U('mochila_full'))
					else
						xPlayer.addInventoryItem('skoljka', 1)
						HarvestKoda(source)
					end
				end
			end
		end)
	end
end

RegisterServerEvent('esx_biser:startHarvestKoda')
AddEventHandler('esx_biser:startHarvestKoda', function(torba)
	local _source = source

	if not PlayersHarvestingKoda[_source] then
		PlayersHarvestingKoda[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('pegar_frutos'))
		HarvestKoda(_source, torba)
	else
		print(('esx_biser: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_biser:stopHarvestKoda')
AddEventHandler('esx_biser:stopHarvestKoda', function()
	local _source = source

	PlayersHarvestingKoda[_source] = false
end)

local function TransformKoda(source, torba)

	SetTimeout(Config.TimeToProcess, function()
		if PlayersTransformingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local kodaQuantity = xPlayer.getInventoryItem('skoljka').count
			local pooch = xPlayer.getInventoryItem('biser')

			if torba then
				if pooch.limit ~= -1 and pooch.count >= pooch.limit*2 then
					TriggerClientEvent('esx:showNotification', source, _U('nao_tens_frutos_suficientes'))
				elseif kodaQuantity < 1 then
					TriggerClientEvent('esx:showNotification', source, _U('nao_tens_mais_frutos'))
				else
					xPlayer.removeInventoryItem('skoljka', 1)
					xPlayer.addInventoryItem('biser', 2)

					TransformKoda(source)
				end
			else
				if pooch.limit ~= -1 and pooch.count >= pooch.limit then
					TriggerClientEvent('esx:showNotification', source, _U('nao_tens_frutos_suficientes'))
				elseif kodaQuantity < 1 then
					TriggerClientEvent('esx:showNotification', source, _U('nao_tens_mais_frutos'))
				else
					xPlayer.removeInventoryItem('skoljka', 1)
					xPlayer.addInventoryItem('biser', 2)

					TransformKoda(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_biser:startTransformKoda')
AddEventHandler('esx_biser:startTransformKoda', function(torba)
	local _source = source

	if not PlayersTransformingKoda[_source] then
		PlayersTransformingKoda[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('colocar_frutos_dentro_dos_sacos'))
		TransformKoda(_source, torba)
	else
		print(('esx_biser: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_biser:stopTransformKoda')
AddEventHandler('esx_biser:stopTransformKoda', function()
	local _source = source

	PlayersTransformingKoda[_source] = false
end)

local function SellKoda(source)
	if not TrajeTimer[source] then
		TrajeTimer[source] = true
		SetTimeout(Config.TimeToSell, function()
			TrajeTimer[source] = false
			if PlayersSellingKoda[source] then
				local xPlayer = ESX.GetPlayerFromId(source)
				local poochQuantity = xPlayer.getInventoryItem('biser').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('nao_tens_sacos_com_frutos'))
				else
					xPlayer.removeInventoryItem('biser', 1)
					xPlayer.addAccountMoney('bank', 1000)
					TriggerClientEvent('esx:showNotification', source, _U('vendeste_sacos'))
					SellKoda(source)
				end
			end
		end)
	end
end

RegisterServerEvent('esx_biser:startSellKoda')
AddEventHandler('esx_biser:startSellKoda', function()
	local _source = source

	if not PlayersSellingKoda[_source] then
		PlayersSellingKoda[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('venda_do_sacos'))
		SellKoda(_source, torba)
	else
		print(('esx_biser: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_biser:stopSellKoda')
AddEventHandler('esx_biser:stopSellKoda', function()
	local _source = source

	PlayersSellingKoda[_source] = false
end)

RegisterServerEvent('esx_biser:GetUserInventory')
AddEventHandler('esx_biser:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_biser:ReturnInventory',
		_source,
		xPlayer.getInventoryItem('skoljka').count,
		xPlayer.getInventoryItem('biser').count,
		xPlayer.job.name,
		currentZone
	)
end)
