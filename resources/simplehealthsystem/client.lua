-----------------------
-- Damaged Walk Mode --
-----------------------

local Neces = false

local hurt = false
Citizen.CreateThread(function()
	local waitara = 500
    while true do
        Citizen.Wait(waitara)
		if not Neces then
			if GetEntityHealth(GetPlayerPed(-1)) <= 159 then
				waitara = 0
				setHurt()
			elseif hurt and GetEntityHealth(GetPlayerPed(-1)) > 160 then
				waitara = 500
				setNotHurt()
			end
		end
    end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	DisableControlAction(0, 21) 
	DisableControlAction(0,22)
end

function setNotHurt()
    hurt = false
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    ResetPedMovementClipset(GetPlayerPed(-1))
    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
    ResetPedStrafeClipset(GetPlayerPed(-1))
end

RegisterNetEvent('Muvaj:PostaviGa')
AddEventHandler('Muvaj:PostaviGa', function(br)
  Neces = br
end)