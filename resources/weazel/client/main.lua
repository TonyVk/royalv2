local Prikazi = false
local PrviSpawn = false
local PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ProvjeriGa()
end)

function ProvjeriGa()
	TriggerServerEvent("weazel:DohvatiVijesti")
	PrviSpawn = true
end

AddEventHandler("playerSpawned", function()
	if not PrviSpawn then
		TriggerServerEvent("weazel:DohvatiVijesti")
		PrviSpawn = true
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterCommand("vijesti", function(source, args, rawCommandString)
	SendNUIMessage({
		prikazi = true,
		posao = PlayerData.job.name 
	})
	if Prikazi == false then
		SetNuiFocus(true, true)
		Prikazi = true
	else
		SetNuiFocus(false)
		Prikazi = false
	end
end, false)

RegisterNetEvent("weazel:SaljiClanak")
AddEventHandler("weazel:SaljiClanak", function(ime, naziv, clanak, nest)
	if nest ~= 1 then
		ESX.ShowAdvancedNotification('Weazel News', 'Vijesti', 'Dodana je nova vijest na /vijesti', "CHAR_LIFEINVADER", 2)
	end
	SendNUIMessage({
		salji = true,
		autor = ime,
		naslov = naziv,
		opis = clanak
	})
end)

RegisterNUICallback(
    "dodaj",
    function(data, cb)
		local clanak = string.gsub(data.clanak, '"', "&quot;")
		local naziv = string.gsub(data.naziv, '"', "&quot;")
		if (naziv == nil or naziv == '') then
			ESX.ShowNotification("Niste upisali naslov!")
		elseif (clanak == nil or clanak == '') then
			ESX.ShowNotification("Niste napisali clanak!")
		else
			naziv = string.gsub(naziv, '<', "&lt;")
			naziv = string.gsub(naziv, '>', "&gt;")
			TriggerServerEvent("weazel:DodajClanak", GetPlayerName(PlayerId()), naziv, clanak)
		end
		cb("ok")
    end
)

RegisterNUICallback(
    "zatvori",
    function()
		SetNuiFocus(false)
		Prikazi = false
		SendNUIMessage({
			prikazi = true
		})
    end
)