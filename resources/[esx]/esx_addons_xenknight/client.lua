ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_addons_xenknight:call')
AddEventHandler('esx_addons_xenknight:call', function(data)
  local playerPed   = GetPlayerPed(-1)
  local coords      = GetEntityCoords(playerPed)
  local message     = data.message
  local number      = data.number
  if message == nil then
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
      message =  GetOnscreenKeyboardResult()
    end
  end
  if message ~= nil and message ~= "" then
    TriggerServerEvent('esx_addons_gcphone:startCall', number, message, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })
  end
end)

local Prikazi = false

RegisterNetEvent('mobitel:Testiraj')
AddEventHandler('mobitel:Testiraj', function(num, poruka, coords)
	SendNUIMessage({
		salji = true,
		broj = num,
		tekst = poruka,
		koord = coords
	})
	if Prikazi then
		ESX.ShowNotification("[CENTRALA] Dosla je nova prijava!")
	end
end)

RegisterCommand("centrala", function(source, args, rawCommandString)
	SendNUIMessage({
		prikazi = true 
	})
	if Prikazi == false then
		SetNuiFocus(true, true)
		Prikazi = true
	else
		SetNuiFocus(false)
		Prikazi = false
	end
end, false)

RegisterNUICallback(
    "salji",
    function(data, cb)
		local broj = data.broj;
		local tekst = string.gsub(data.tekst, '"', "&quot;")
		local koord = vector3(tonumber(data.x), tonumber(data.y), tonumber(data.z))
		tekst = string.gsub(tekst, '<', "&lt;")
		tekst = string.gsub(tekst, '>', "&gt;")
		TriggerServerEvent("murja:SaljiGa", broj, tekst, koord)
		cb("ok")
    end
)

RegisterNUICallback(
    "zatvori",
    function()
		SetNuiFocus(false)
		Prikazi = false
    end
)
