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
local Kolicina = 0
local Minuta = -1
local MinutaKr = -1
local StartajWar = 0
local PoceoWar = 0
local UWaru = false
local TrajeWar = 0
local LastPosX = 0.0
local LastPosY = 0.0
local LastPosZ = 0.0
local Tim = 0
local Tim1Igr = 0
local Tim2Igr = 0
local Tim1 = false
local Tim2 = false
local T1 = 0
local T2 = 0
local T1Spawn = 0
local T2Spawn = 0
local Kill = 0
local Death = 0
local Tim1Score = 0
local Tim2Score = 0
local Poslao1 = 0
local Poslao2 = 0
local Minute = 0
local PrviSpawn = false

ESX                             = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent("War:Vrime")
AddEventHandler('War:Vrime', function(vr)
    Minuta = vr
end)

RegisterNetEvent("War:VrimeKraj")
AddEventHandler('War:VrimeKraj', function(vr)
    MinutaKr = vr
	local str
	if vr == 2 or vr == 3 or vr == 4 then
		str = vr.." minute"
	else
		str = vr.." minuta"
	end
	SendNUIMessage({
		vrijeme = true,
		minuta = str
	})
end)

RegisterNetEvent("War:VratiScore")
AddEventHandler('War:VratiScore', function(t1, t2)
	if UWaru == true then
		Tim1Score = t1
		Tim2Score = t2
		local str1 = "Crveni: "..t1
		local str2 = "Plavi: "..t2
		SendNUIMessage({
			team1 = true,
			team2 = true,
			score1 = str1,
			score2 = str2,
		})
	end
end)

RegisterNetEvent("War:VratiPoruku")
AddEventHandler('War:VratiPoruku', function(str)
	if UWaru == true then
		ESX.ShowNotification(str)
	end
end)

RegisterNetEvent("War:VratiKill")
AddEventHandler('War:VratiKill', function(id, isti)
	if UWaru == true then
		Kill = Kill+1
		if isti == 0 then
			if Tim == 1 then
				Tim1Score = Tim1Score+5
				local str = "[Crveni] ~r~"..GetPlayerName(PlayerId()).." ~w~je ubio [Plavi] ~r~"..GetPlayerName(GetPlayerFromServerId(id)).." ~w~(+5 bodova za crvene)"
				TriggerServerEvent("War:PosaljiPoruku", str)
				TriggerServerEvent("War:SyncajScore", Tim1Score, Tim2Score)
			elseif Tim == 2 then
				Tim2Score = Tim2Score+5
				local str = "[Plavi] ~r~"..GetPlayerName(PlayerId()).." ~w~je ubio [Crveni] ~r~"..GetPlayerName(GetPlayerFromServerId(id)).." ~w~(+5 bodova za plave)"
				TriggerServerEvent("War:PosaljiPoruku", str)
				TriggerServerEvent("War:SyncajScore", Tim1Score, Tim2Score)
			end
		else
			if Tim == 1 then
				Tim1Score = Tim1Score-2
				local str = "[Crveni] ~r~"..GetPlayerName(PlayerId()).." ~w~je ubio svoga clana tima (-2 boda za crvene)"
				TriggerServerEvent("War:PosaljiPoruku", str)
				TriggerServerEvent("War:SyncajScore", Tim1Score, Tim2Score)
			elseif Tim == 2 then
				Tim2Score = Tim2Score-2
				local str = "[Plavi] ~r~"..GetPlayerName(PlayerId()).." ~w~je ubio svoga clana tima (-2 boda za plave)"
				TriggerServerEvent("War:PosaljiPoruku", str)
				TriggerServerEvent("War:SyncajScore", Tim1Score, Tim2Score)
			end
		end
		local str1 = "Crveni: "..Tim1Score
		local str2 = "Plavi: "..Tim2Score
		SendNUIMessage({
			team1 = true,
			team2 = true,
			score1 = str1,
			score2 = str2,
			ubio = true,
			kill = Kill
		})
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if UWaru == true then
		DoScreenFadeOut(1)
		SetEntityInvincible(PlayerPedId(), true)
		Death = Death+1
		SendNUIMessage({
			mrtav = true,
			death = Death
		})
		if data.killedByPlayer == true then
			TriggerServerEvent("War:PosaljiKill", data.killerServerId, GetPlayerServerId(PlayerId()))
		else
			if Tim == 1 then
				Tim1Score = Tim1Score-1
				local str = "[Crveni] ~r~"..GetPlayerName(PlayerId()).." ~w~se ubio sam (-1 bod za crvene)"
				TriggerServerEvent("War:PosaljiPoruku", str)
			elseif Tim == 2 then
				Tim2Score = Tim2Score-1
				local str = "[Plavi] ~r~"..GetPlayerName(PlayerId()).." ~w~se ubio sam (-1 bod za plave)"
				TriggerServerEvent("War:PosaljiPoruku", str)
			end
			TriggerServerEvent("War:SyncajScore", Tim1Score, Tim2Score)
		end
		local ped = PlayerPedId()
		Wait(2000)
		if Tim == 1 then
			SetEntityCoordsNoOffset(ped, -1057.9150390625, 4944.314453125, 209.8247680664, false, false, false, true)
			NetworkResurrectLocalPlayer(-1057.9150390625, 4944.314453125, 209.8247680664, 129.49896240234, true, false)
			SetPlayerInvincible(ped, false)
			ClearPedBloodDamage(ped)
		elseif Tim == 2 then
			SetEntityCoordsNoOffset(ped, -1169.3131103516, 4898.5942382812, 216.0304107666, false, false, false, true)
			NetworkResurrectLocalPlayer(-1169.3131103516, 4898.5942382812, 216.0304107666, 299.87637329102, true, false)
			SetPlayerInvincible(ped, false)
			ClearPedBloodDamage(ped)
		end
		SetEntityInvincible(PlayerPedId(), false)
		DoScreenFadeIn(1)
		TriggerServerEvent("War:DajOruzja")
		TriggerEvent('esx_basicneeds:healPlayer')
	end
end)

RegisterNetEvent("War:ZavrsiIgracu")
AddEventHandler('War:ZavrsiIgracu', function()
	if UWaru == true then
		PoceoWar = 0
		UWaru = false
		FreezeEntityPosition(PlayerPedId(), false)
		Tim = 0
		TrajeWar = 0
		if Tim1 == true then
			Tim1Igr = Tim1Igr-1
		elseif Tim2 == true then
			Tim2Igr = Tim2Igr-1
		end
		TriggerServerEvent("War:SyncTimove", Tim1Igr, Tim2Igr)
		Tim1 = false
		Tim2 = false
		T1 = 0
		T2 = 0
		Minuta = -1
		MinutaKr = -1
		--RemoveAllPedWeapons(PlayerId(), false)
		for i=1, #Config.Weapons, 1 do
			local weaponHash = GetHashKey(Config.Weapons[i].name)

			if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
				TriggerServerEvent("War:ObrisiGovno", Config.Weapons[i].name, ammo)
				Wait(500)
			end
		end
		Wait(200)
		--TriggerServerEvent("War:Zaustavi2")
		SetEntityCoords(PlayerPedId(), LastPosX, LastPosY, LastPosZ)
		TriggerEvent("esx_ambulancejob:PostaviGa", false)
		TriggerEvent("pullout:PostaviGa", false)
		TriggerEvent("esx:ZabraniInv", false)
		TriggerEvent("Muvaj:PostaviGa", false)
		TriggerEvent("dpemotes:Radim", false)
		TriggerEvent("glava:NemojGa", false)
		TriggerServerEvent("War:ObrisiLoadout")
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
        end)
		Wait(200)
		--TriggerEvent('esx:restoreLoadout')
		TriggerServerEvent("War:Zaustavi2")
		for i=1, #Config.Weapons, 1 do
			local weaponHash = GetHashKey(Config.Weapons[i].name)
			if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
				TriggerServerEvent("War:SpremiLoadout", Config.Weapons[i].name, ammo)
				Wait(500)
			end
		end
		ESX.ShowNotification("Izbaceni ste sa wara!")
		SendNUIMessage({
			zatvoriscore = true
		})
	end
end)

RegisterNetEvent("War:Zavrsi")
AddEventHandler('War:Zavrsi', function(nest)
	if UWaru == true then
		if tonumber(Tim1Score) > tonumber(Tim2Score) then
			local str = "~r~Crveni ~w~su pobjedili ~b~plave ~w~("..Tim1Score..":"..Tim2Score..")"
			ESX.ShowNotification(str)
			if Tim == 1 then
				if Poslao1 == 0 then
					if nest == nil then
						ESX.TriggerServerCallback('War:DohvatiPosao', function(job)
							TriggerServerEvent("War:SpremiGa", job, 1)
						end)
					end
				end
				Poslao1 = 1
				TriggerServerEvent("War:SyncajPoslao", 1, Poslao1)
			elseif Tim == 2 then
				if Poslao2 == 0 then
					if nest == nil then
						ESX.TriggerServerCallback('War:DohvatiPosao', function(job)
							TriggerServerEvent("War:SpremiGa", job, 2)
						end)
					end
				end
				Poslao2 = 1
				TriggerServerEvent("War:SyncajPoslao", 2, Poslao2)
			end
		elseif tonumber(Tim1Score) < tonumber(Tim2Score) then
			local str = "~b~Plavi ~w~su pobjedili ~r~crvene ~w~("..Tim2Score..":"..Tim1Score..")"
			ESX.ShowNotification(str)
			if Tim == 1 then
				if Poslao1 == 0 then
					if nest == nil then
						ESX.TriggerServerCallback('War:DohvatiPosao', function(job)
							TriggerServerEvent("War:SpremiGa", job, 2)
						end)
					end
				end
				Poslao1 = 1
				TriggerServerEvent("War:SyncajPoslao", 1, Poslao1)
			elseif Tim == 2 then
				if Poslao2 == 0 then
					if nest == nil then
						ESX.TriggerServerCallback('War:DohvatiPosao', function(job)
							TriggerServerEvent("War:SpremiGa", job, 1)
						end)
					end
				end
				Poslao2 = 1
				TriggerServerEvent("War:SyncajPoslao", 2, Poslao2)
			end
		else
			if nest == nil then
				local str = "War je zavrsio izjednaceno ("..Tim1Score..":"..Tim2Score..")"
				ESX.ShowNotification(str)
			end
			if Tim == 1 then
				if Poslao1 == 0 then
					if nest == nil then
						ESX.TriggerServerCallback('War:DohvatiPosao', function(job)
							TriggerServerEvent("War:SpremiGa", job, 1)
						end)
					end
				end
				Poslao1 = 1
				TriggerServerEvent("War:SyncajPoslao", 1, Poslao1)
			elseif Tim == 2 then
				if Poslao2 == 0 then
					if nest == nil then
						ESX.TriggerServerCallback('War:DohvatiPosao', function(job)
							TriggerServerEvent("War:SpremiGa", job, 1)
						end)
					end
				end
				Poslao2 = 1
				TriggerServerEvent("War:SyncajPoslao", 2, Poslao2)
			end
		end
		PoceoWar = 0
		TriggerServerEvent("War:SpremiPocela", PoceoWar)
		FreezeEntityPosition(PlayerPedId(), false)
		Tim = 0
		TrajeWar = 0
		TriggerServerEvent("War:SyncajTraje", TrajeWar)
		Tim1Igr = 0
		Tim2Igr = 0
		Tim1 = false
		Tim2 = false
		T1 = 0
		T2 = 0
		Minuta = -1
		MinutaKr = -1
		SetEntityCoords(PlayerPedId(), LastPosX, LastPosY, LastPosZ)
		TriggerEvent("esx_ambulancejob:PostaviGa", false)
		TriggerEvent("pullout:PostaviGa", false)
		TriggerEvent("esx:ZabraniInv", false)
		TriggerEvent("glava:NemojGa", false)
		TriggerEvent("dpemotes:Radim", false)
		TriggerEvent("Muvaj:PostaviGa", false)
		for i=1, #Config.Weapons, 1 do
			local weaponHash = GetHashKey(Config.Weapons[i].name)

			if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
				TriggerServerEvent("War:ObrisiGovno", Config.Weapons[i].name, ammo)
				Wait(500)
			end
		end
		Wait(200)
		TriggerServerEvent("War:ObrisiLoadout")
		UWaru = false
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
        end)
		Wait(200)
		--RemoveAllPedWeapons(PlayerId(), false)
        --TriggerEvent('esx:restoreLoadout')
		TriggerServerEvent("War:Zaustavi2")
		Wait(200)
		for i=1, #Config.Weapons, 1 do
			local weaponHash = GetHashKey(Config.Weapons[i].name)

			if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
				TriggerServerEvent("War:SpremiLoadout", Config.Weapons[i].name, ammo)
				Wait(500)
			end
		end
		SendNUIMessage({
			zatvoriscore = true
		})
	end
end)

RegisterNetEvent("War:VratiTraje")
AddEventHandler('War:VratiTraje', function(br)
	TrajeWar = br
end)

RegisterNetEvent("War:VratiVrijeme")
AddEventHandler('War:VratiVrijeme', function(br)
	Minute = br
end)

RegisterNetEvent("War:VratiPoslao")
AddEventHandler('War:VratiPoslao', function(tip, br)
	if tip == 1 then
		Poslao1 = br
	else
		Poslao2 = br
	end
end)

RegisterCommand("warpozovi", function(source, args, rawCommandString)
	local igrac = args[1]
	local playerIdx = GetPlayerFromServerId(tonumber(igrac))
	if PoceoWar == 1 and UWaru == true then
		ESX.TriggerServerCallback('War:DohvatiMiLidera', function(br)
			if br == 1 then
				if playerIdx ~= -1 then
					ESX.TriggerServerCallback('War:DohvatiIgraca', function(br)
						if br == 1 then
							local brojic = 0
							if Tim == 1 then
								brojic = Tim1Igr+1
							else
								brojic = Tim2Igr+1
							end
							if tonumber(brojic) <= tonumber(Kolicina) then
								TriggerServerEvent("War:Pozovi", tonumber(igrac), Tim)
							else
								ESX.ShowNotification("Vec imate max broj igraca u waru!")
							end
						else
							ESX.ShowNotification("Igrac nije u vasoj mafiji!")
							name = "Admin"..":"
							message = "/warpozovi [ID igraca]"
							TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
						end
					end, igrac)
				else
					ESX.ShowNotification("Igrac nije online!")
					name = "Admin"..":"
					message = "/warpozovi [ID igraca]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end
			else
				ESX.ShowNotification("Niste lider!")
			end
		end)
	else
		ESX.ShowNotification("Ne traje war ili niste u waru!")
	end
end, false)

RegisterCommand("warizbaci", function(source, args, rawCommandString)
	local igrac = args[1]
	local playerIdx = GetPlayerFromServerId(tonumber(igrac))
	if PoceoWar == 1 and UWaru == true then
		ESX.TriggerServerCallback('War:DohvatiMiLidera', function(br)
			if br == 1 then
				if playerIdx ~= -1 then
					ESX.TriggerServerCallback('War:DohvatiIgraca', function(br)
						if br == 1 then
							TriggerServerEvent("War:ZaustaviIgracu", tonumber(igrac))
						else
							ESX.ShowNotification("Igrac nije u vasoj mafiji!")
							name = "Admin"..":"
							message = "/warizbaci [ID igraca]"
							TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
						end
					end, igrac)
				else
					ESX.ShowNotification("Igrac nije online")
					name = "Admin"..":"
					message = "/warizbaci [ID igraca]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end
			else
				ESX.ShowNotification("Niste lider!")
			end
		end)
	else
		ESX.ShowNotification("Nema pokrenutog wara ili niste u waru!")
	end
end, false)

AddEventHandler("playerSpawned", function()
	if not PrviSpawn then
		ESX.TriggerServerCallback('War:ImalIsta', function(br)
			if br == 1 then
				for i=1, #Config.Weapons, 1 do
					local weaponHash = GetHashKey(Config.Weapons[i].name)
					if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
						local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
						TriggerServerEvent("War:ObrisiGovno", Config.Weapons[i].name, ammo)
						Wait(500)
					end
				end
				Wait(2000)
				TriggerServerEvent("War:Zaustavi2")
			end
		end)
		PrviSpawn = true
	end
end)

RegisterCommand("pokreniwar", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			local igrac = args[1]
			local igrac2 = args[2]
			local broj = args[3]
			local vrijeme  = args[4]
			local playerIdx = GetPlayerFromServerId(tonumber(igrac))
			local playerIdx2 = GetPlayerFromServerId(tonumber(igrac2))
			if PoceoWar == 0 then
				if playerIdx ~= -1 and playerIdx2 ~= -1 then
					ESX.TriggerServerCallback('War:DohvatiLidera', function(br)
						if br == 1 then
							if broj ~= nil and tonumber(broj) > 0 then
								if vrijeme ~= nil and tonumber(vrijeme) > 0 then
								local Sekundice = 60
								TriggerServerEvent("War:SyncajVrijeme", Sekundice)
								Minute = tonumber(vrijeme)
								TriggerServerEvent("War:SyncVrijeme", Minute)
								ESX.ShowNotification("Pokrenuli ste war!")
								PoceoWar = 1
								T1Spawn = 0
								T2Spawn = 0
								TriggerServerEvent("War:SyncSpawnove", 1, T1Spawn)
								TriggerServerEvent("War:SyncSpawnove", 2, T2Spawn)
								TriggerServerEvent("War:SpremiPocela", PoceoWar)
								TriggerServerEvent("War:SyncajPoslao", 1, 0)
								TriggerServerEvent("War:SyncajPoslao", 2, 0)
								TriggerServerEvent("War:Posalji", tonumber(igrac), tonumber(igrac2), broj)
								else
									name = "Admin"..":"
									message = "/pokreniwar [ID lidera 1][ID lidera 2][Broj u waru(3 za 3v3, 5 za 5v5...)][Vrijeme]"
									TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
								end

							else
								name = "Admin"..":"
								message = "/pokreniwar [ID lidera 1][ID lidera 2][Broj u waru(3 za 3v3, 5 za 5v5...)][Vrijeme]"
								TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
							end
						else
							ESX.ShowNotification("Netko od igraca nije lider")
							name = "Admin"..":"
							message = "/pokreniwar [ID lidera 1][ID lidera 2][Broj u waru(3 za 3v3, 5 za 5v5...)][Vrijeme]"
							TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
						end
					end, igrac, igrac2)
				else
					ESX.ShowNotification("Netko od lidera nije online")
					name = "Admin"..":"
					message = "/pokreniwar [ID lidera 1][ID lidera 2][Broj u waru(3 za 3v3, 5 za 5v5...)][Vrijeme]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end
			else
				ESX.ShowNotification("Vec traje jedan war!")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

RegisterCommand("zavrsiwar", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if br == 1 then
			if PoceoWar == 1 then
				TriggerServerEvent("War:Zaustavi")
			else
				ESX.ShowNotification("Ne traje war!")
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	end)
end, false)

function PratiPocetak()
	local Aha1 = 0
	local Aha2 = 0
	local Aha3 = 0
	local AhaGo = 0
	Citizen.CreateThread(function()
		while StartajWar == 1 and UWaru == true do
			Citizen.Wait(0)
			if Minuta == 3 and Aha1 == 0 then
				TriggerEvent("pNotify:SendNotification", {text = "3", type = "info", timeout = 1000, layout = "bottomCenter"})
				PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
				Aha1 = 1
			end
			if Minuta == 2 and Aha2 == 0 then
				TriggerEvent("pNotify:SendNotification", {text = "2", type = "info", timeout = 1000, layout = "bottomCenter"})
				PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
				Aha2 = 1
			end
			if Minuta == 1 and Aha3 == 0 then
				TriggerEvent("pNotify:SendNotification", {text = "1", type = "info", timeout = 1000, layout = "bottomCenter"})
				PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
				Aha3 = 1
			end
			if Minuta == 0 and AhaGo == 0 then
				TriggerEvent("pNotify:SendNotification", {text = "GO", type = "info", timeout = 1000, layout = "bottomCenter"})
				PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
				AhaGo = 1
				Minuta = -1
				FreezeEntityPosition(PlayerPedId(), false)
				--if Tim1Igr ~= Tim2Igr then
					--TriggerEvent("War:Zavrsi", 1)
					--ESX.ShowNotification("War nije poceo zato sto nije bio isti broj igraca u timovima!")
				--else
					TrajeWar = 1
					TriggerServerEvent("War:SyncajTraje", TrajeWar)
					TriggerServerEvent("War:SyncajKraj", Minute)
					PratiKraj()
					StartajWar = 0
					local str1 = "Crveni: "..Tim1Score
					local str2 = "Plavi: "..Tim2Score
					local str
					if Minute == 2 or Minute == 3 or Minute == 4 then
						str = Minute.." minute"
					else
						str = Minute.." minuta"
					end
					SendNUIMessage({
						vrijeme = true,
						minuta = str,
						prikaziscore = true,
						team1 = true,
						team2 = true,
						score1 = str1,
						score2 = str2,
						ubio = true,
						kill = Kill,
						mrtav = true,
						death = Death
					})
					TriggerServerEvent("War:DajOruzja")
				--end
			end
		end
	end)
end

function PratiKraj()
Citizen.CreateThread(function()
	while PoceoWar == 1 do
		Citizen.Wait(0)
		if MinutaKr == 0 then
			MinutaKr = -1
			TriggerServerEvent("War:Zaustavi")
		end
	end
end)
end

RegisterNetEvent("War:VratiPocela")
AddEventHandler('War:VratiPocela', function(br)
    PoceoWar = br
end)

RegisterNetEvent("War:VratiTimove")
AddEventHandler('War:VratiTimove', function(t1, t2)
    Tim1Igr = t1
	Tim2Igr = t2
end)

RegisterNetEvent("War:VratioSpawnove")
AddEventHandler('War:VratioSpawnove', function(tim, br)
    if tim == 1 then
		T1Spawn = br
	elseif tim == 2 then
		T2Spawn = br
	end
end)

RegisterNetEvent("War:ProvjeraBroja")
AddEventHandler('War:ProvjeraBroja', function()
    if Tim1 == true then
		TriggerServerEvent("War:Povecaj", 1)
	elseif Tim2 == true then
		TriggerServerEvent("War:Povecaj", 2)
	end
end)

RegisterNetEvent("War:Resetira")
AddEventHandler('War:Resetira', function()
    T1 = 0
	T2 = 0
end)

RegisterNetEvent("War:PovecajTim")
AddEventHandler('War:PovecajTim', function(br)
	if br == 1 then
		T1 = T1+1
	elseif br == 2 then
		T2 = T2+1
	end
end)

Citizen.CreateThread(function()
	while TrajeWar == 1 do
		if T1 ~= 0 then
			if T1 < Tim1Igr then
				Tim1Igr = T1
				TriggerServerEvent("War:SyncTimove", Tim1Igr, Tim2Igr)
			end
		end
		if T2 ~= 0 then
			if T2 < Tim2Igr then
				Tim2Igr = T2
				TriggerServerEvent("War:SyncTimove", Tim1Igr, Tim2Igr)
			end
		end
		Citizen.Wait(10000)
		TriggerServerEvent("War:Resetiraj")
		TriggerServerEvent("War:ProvjeriBroj")
	end
end)

RegisterNetEvent("War:Pozivam")
AddEventHandler('War:Pozivam', function(tim)
	UWaru = true
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
	LastPosX = x
	LastPosY = y
	LastPosZ = z
	Tim = tim
	for i=1, #Config.Weapons, 1 do
		local weaponHash = GetHashKey(Config.Weapons[i].name)

		if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
			local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
			TriggerServerEvent("War:DajInv", Config.Weapons[i].name, ammo)
			Wait(500)
		end
	end
	if tim == 1 then
		if T1Spawn == 0 then
			SetEntityCoords(GetPlayerPed(-1), -1057.9150390625, 4944.314453125, 209.8247680664, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 129.49896240234)
		elseif T1Spawn == 1 then
			SetEntityCoords(GetPlayerPed(-1), -1059.1833496094, 4947.5693359375, 210.82870483398, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 123.06597137452)
		elseif T1Spawn == 2 then
			SetEntityCoords(GetPlayerPed(-1), -1055.2409667968, 4947.83984375, 210.5191040039, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 128.36541748046)
		elseif T1Spawn == 3 then
			SetEntityCoords(GetPlayerPed(-1), -1056.6395263672, 4950.921875, 210.21948242188, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 124.7791519165)
		elseif T1Spawn == 4 then
			SetEntityCoords(GetPlayerPed(-1), -1059.679321289, 4952.1337890625, 210.5486907959, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 139.77880859375)
		end
		T1Spawn = T1Spawn+1
		TriggerServerEvent("War:SyncSpawnove", tim, T1Spawn)
		Tim1Igr = Tim1Igr+1
		Tim1 = true
		local clothesSkin = {
				['tshirt_1'] = 0, ['tshirt_2'] = 2,
				['torso_1'] = 7, ['torso_2'] = 5
			}
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
		--[[local model = GetHashKey("ig_claypain")

        RequestModel(model)
        while not HasModelLoaded(model) do
           RequestModel(model)
           Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)]]
	elseif tim == 2 then
		if T2Spawn == 0 then
			SetEntityCoords(GetPlayerPed(-1), -1169.3131103516, 4898.5942382812, 216.0304107666, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 299.87637329102)
		elseif T2Spawn == 1 then
			SetEntityCoords(GetPlayerPed(-1), -1171.5206298828, 4901.8862304688, 217.22869873046, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 300.95999145508)
		elseif T2Spawn == 2 then
			SetEntityCoords(GetPlayerPed(-1), -1174.0954589844, 4900.0385742188, 216.12692260742, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 302.12118530274)
		elseif T2Spawn == 3 then
			SetEntityCoords(GetPlayerPed(-1), -1171.8341064454, 4897.9067382812, 216.31495666504, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 303.04583740234)
		elseif T2Spawn == 4 then
			SetEntityCoords(GetPlayerPed(-1), -1168.3704833984, 4894.1899414062, 216.25135803222, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 333.31900024414)
		end
		T2Spawn = T2Spawn+1
		TriggerServerEvent("War:SyncSpawnove", tim, T2Spawn)
		Tim2Igr = Tim2Igr+1
		Tim2 = true
		local clothesSkin = {
				['tshirt_1'] = 0, ['tshirt_2'] = 2,
				['torso_1'] = 7, ['torso_2'] = 3
			}
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
		--[[local model = GetHashKey("s_m_y_dealer_01")

        RequestModel(model)
        while not HasModelLoaded(model) do
           RequestModel(model)
           Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)]]
	end
	TriggerServerEvent("War:SyncTimove", Tim1Igr, Tim2Igr)
	if TrajeWar == 0 then
		FreezeEntityPosition(PlayerPedId(), true)
		PlaceObjectOnGroundProperly(PlayerPedId())
		StartajWar = 1
		PratiPocetak()
	end
	Kill = 0
	Death = 0
	if TrajeWar == 1 then
		PratiKraj()
		TriggerServerEvent("War:DajOruzja")
		local str
		if MinutaKr == 2 or MinutaKr == 3 or MinutaKr == 4 then
			str = MinutaKr.." minute"
		else
			str = MinutaKr.." minuta"
		end
		local str1 = "Crveni: "..Tim1Score
		local str2 = "Plavi: "..Tim2Score
		SendNUIMessage({
			vrijeme = true,
			minuta = str,
			prikaziscore = true,
			team1 = true,
			team2 = true,
			score1 = str1,
			score2 = str2,
			ubio = true,
			kill = Kill,
			mrtav = true,
			death = Death
		})
	end
	TriggerEvent("esx_ambulancejob:PostaviGa", true)
	TriggerEvent("pullout:PostaviGa", true)
	TriggerEvent("Muvaj:PostaviGa", true)
	TriggerEvent("dpemotes:Radim", true)
	TriggerEvent("esx:ZabraniInv", true)
	TriggerEvent("glava:NemojGa", true)
	ESX.ShowNotification("Pozvani ste u war!")
end)

RegisterNetEvent("War:Saljem")
AddEventHandler('War:Saljem', function(kol, tim)
    Kolicina = kol
	UWaru = true
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
	LastPosX = x
	LastPosY = y
	LastPosZ = z
	Tim = tim
	for i=1, #Config.Weapons, 1 do
		local weaponHash = GetHashKey(Config.Weapons[i].name)

		if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
			local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
			TriggerServerEvent("War:DajInv", Config.Weapons[i].name, ammo)
			Wait(500)
		end
	end
	if tim == 1 then
		if T1Spawn == 0 then
			SetEntityCoords(GetPlayerPed(-1), -1057.9150390625, 4944.314453125, 209.8247680664, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 129.49896240234)
		elseif T1Spawn == 1 then
			SetEntityCoords(GetPlayerPed(-1), -1059.1833496094, 4947.5693359375, 210.82870483398, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 123.06597137452)
		elseif T1Spawn == 2 then
			SetEntityCoords(GetPlayerPed(-1), -1055.2409667968, 4947.83984375, 210.5191040039, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 128.36541748046)
		elseif T1Spawn == 3 then
			SetEntityCoords(GetPlayerPed(-1), -1056.6395263672, 4950.921875, 210.21948242188, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 124.7791519165)
		elseif T1Spawn == 4 then
			SetEntityCoords(GetPlayerPed(-1), -1059.679321289, 4952.1337890625, 210.5486907959, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 139.77880859375)
		end
		T1Spawn = T1Spawn+1
		TriggerServerEvent("War:SyncSpawnove", tim, T1Spawn)
		Tim1Igr = Tim1Igr+1
		Tim1 = true
		local clothesSkin = {
				['tshirt_1'] = 0, ['tshirt_2'] = 2,
				['torso_1'] = 7, ['torso_2'] = 5
			}
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
		--[[local model = GetHashKey("ig_claypain")

        RequestModel(model)
        while not HasModelLoaded(model) do
           RequestModel(model)
           Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)]]
	elseif tim == 2 then
		if T2Spawn == 0 then
			SetEntityCoords(GetPlayerPed(-1), -1169.3131103516, 4898.5942382812, 216.0304107666, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 299.87637329102)
		elseif T2Spawn == 1 then
			SetEntityCoords(GetPlayerPed(-1), -1171.5206298828, 4901.8862304688, 217.22869873046, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 300.95999145508)
		elseif T2Spawn == 2 then
			SetEntityCoords(GetPlayerPed(-1), -1174.0954589844, 4900.0385742188, 216.12692260742, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 302.12118530274)
		elseif T2Spawn == 3 then
			SetEntityCoords(GetPlayerPed(-1), -1171.8341064454, 4897.9067382812, 216.31495666504, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 303.04583740234)
		elseif T2Spawn == 4 then
			SetEntityCoords(GetPlayerPed(-1), -1168.3704833984, 4894.1899414062, 216.25135803222, 1, 0, 0, 1)
			SetEntityHeading(GetPlayerPed(-1), 333.31900024414)
		end
		T2Spawn = T2Spawn+1
		TriggerServerEvent("War:SyncSpawnove", tim, T2Spawn)
		Tim2Igr = Tim2Igr+1
		Tim2 = true
		local clothesSkin = {
				['tshirt_1'] = 0, ['tshirt_2'] = 2,
				['torso_1'] = 7, ['torso_2'] = 3
			}
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
		--local model = GetHashKey("s_m_y_dealer_01")

        --RequestModel(model)
        --while not HasModelLoaded(model) do
           --RequestModel(model)
           --Citizen.Wait(0)
        --end

        --SetPlayerModel(PlayerId(), model)
        --SetModelAsNoLongerNeeded(model)
	end
	Tim1Score = 0
	Tim2Score = 0
	Kill = 0
	Death = 0
	TriggerServerEvent("War:SyncTimove", Tim1Igr, Tim2Igr)
	FreezeEntityPosition(PlayerPedId(), true)
	PlaceObjectOnGroundProperly(PlayerPedId())
	ESX.ShowNotification("War ce poceti za 60 sekundi!")
	ESX.ShowNotification("Da pozovete clanove svoje mafije u war pisite /warpozovi! Da nekoga izbacite iz wara pisite /warizbaci!")
	StartajWar = 1
	TriggerEvent("esx_ambulancejob:PostaviGa", true)
	TriggerEvent("pullout:PostaviGa", true)
	TriggerEvent("dpemotes:Radim", true)
	TriggerEvent("Muvaj:PostaviGa", true)
	TriggerEvent("glava:NemojGa", true)
	TriggerEvent("esx:ZabraniInv", true)
	PratiPocetak()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)
