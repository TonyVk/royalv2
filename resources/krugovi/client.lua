ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local playerNamesDist = 10

Citizen.CreateThread(function()
	while ESX == nil do
		Wait(500)
	end
	local Cekaj = 500
    while true do
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance < 10.0 then
			Cekaj = 10
			for _,id in ipairs(GetActivePlayers()) do
				if GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then
	 
					x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
					x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
					distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
					local takeaway = 0.95

					if ((distance < playerNamesDist) and IsEntityVisible(GetPlayerPed(id))) then
						if NetworkIsPlayerTalking(id) then
							DrawMarker(25,x2,y2,z2 - takeaway, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 10.3, 55, 160, 205, 105, 0, 0, 2, 0, 0, 0, 0)
						end
					end
				end
			end
		else
			Cekaj = 500
		end
        Citizen.Wait(Cekaj)
    end
end)
