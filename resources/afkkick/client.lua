-- CONFIG --
ESX = nil
local perm = nil
local isDead = false
local NeKickaj = false
local prvispawn = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		perm = br
	end)
end)

AddEventHandler("playerSpawned", function()
	if not prvispawn then
		ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
			perm = br
		end)
		prvispawn = true
	end
	isDead = false
end)

RegisterNetEvent("NeKickaj")
AddEventHandler("NeKickaj", function(br)
	NeKickaj = br
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 600

-- Warn players if 3/4 of the Time Limit ran up
kickWarning = true

-- CODE --

Citizen.CreateThread(function()
	while true do
		Wait(1000)

		playerPed = GetPlayerPed(-1)
		if playerPed then
			currentPos = GetEntityCoords(playerPed, true)

			if currentPos == prevPos and NeKickaj == false then
				if perm == 0 then
					if not isDead then
						if time > 0 then
							if kickWarning and time == math.ceil(secondsUntilKick / 4) then
								TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1Biti cete kickani za " .. time .. " sekundi zbog toga sto ste AFK!")
							end

							time = time - 1
						else
							TriggerServerEvent("kickForBeingAnAFKDouchebag")
						end
					end
				end
			else
				time = secondsUntilKick
			end

			prevPos = currentPos
		end
	end
end)