ESX = nil

local UZombi = false
local StareKoord = nil
local Minuta = -1
local TipIgraca = 0
local Armor = 0
local MinutaKr = -1

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("zombi:Vrime")
AddEventHandler('zombi:Vrime', function(vr)
    Minuta = vr
end)

RegisterNetEvent("zombi:VrimeKraj")
AddEventHandler('zombi:VrimeKraj', function(vr)
    MinutaKr = tonumber(vr)
	local str
	if MinutaKr == 2 or MinutaKr == 3 or MinutaKr == 4 then
		str = MinutaKr.." minute"
	else
		str = MinutaKr.." minuta"
	end
	SendNUIMessage({
		vrijeme = true,
		minuta = str
	})
end)

RegisterNetEvent("zombi:PromjeniStr")
AddEventHandler('zombi:PromjeniStr', function(cov, zom)
    SendNUIMessage({
		zombie = true,
		brzom = zom,
		human = true,
		brhum = cov
	})
end)

function PratiKraj()
	Citizen.CreateThread(function()
		while UZombi do
			Citizen.Wait(0)
			if MinutaKr == 0 then
				MinutaKr = -1
				TriggerServerEvent("zombi:ZavrsiZombi")
			end
		end
	end)
end

RegisterNetEvent("zombi:Kraj")
AddEventHandler('zombi:Kraj', function()
    if UZombi then
        UZombi = false
		SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
		StareKoord = nil
		FreezeEntityPosition(PlayerPedId(), false)
		SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 1.0)
		TriggerEvent("esx_ambulancejob:PostaviGa", false)
		TriggerEvent("pullout:PostaviGa", false)
		TriggerEvent("esx:ZabraniInv", false)
		TriggerEvent("Muvaj:PostaviGa", false)
		TriggerEvent("dpemotes:Radim", false)
		TriggerEvent("glava:NemojGa", false)
		TriggerEvent('esx_basicneeds:healPlayer')
		SetPedArmour(PlayerPedId(), Armor)
		if TipIgraca == 2 then
			TriggerServerEvent("zombi:Tuljan")
		end
		TipIgraca = 0
		Minuta = -1
		MinutaKr = -1
		SendNUIMessage({
			zatvoriscore = true
		})
		Wait(5000)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local isMale = skin.sex == 0
			TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
					Wait(3000)
					for i=1, #Config.Weapons, 1 do
						local weaponHash = GetHashKey(Config.Weapons[i].name)

						if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
							local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
							TriggerServerEvent("War:ObrisiGovno", Config.Weapons[i].name, ammo)
							Wait(500)
						end
					end
					Wait(1000)
					TriggerServerEvent("War:Zaustavi2")
					for i=1, #Config.Weapons, 1 do
						local weaponHash = GetHashKey(Config.Weapons[i].name)
						if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
							local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
							TriggerServerEvent("War:SpremiLoadout", Config.Weapons[i].name, ammo)
							Wait(500)
						end
					end
				end)
			end)
		end)
		SetPlayerInvincible(PlayerId(), false)
	end
end)

RegisterNetEvent("zombi:Zavrsi")
AddEventHandler('zombi:Zavrsi', function()
    if UZombi then
        UZombi = false
		SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
		StareKoord = nil
		FreezeEntityPosition(PlayerPedId(), false)
		SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 1.0)
		TriggerEvent("esx_ambulancejob:PostaviGa", false)
		TriggerEvent("pullout:PostaviGa", false)
		TriggerEvent("esx:ZabraniInv", false)
		TriggerEvent("Muvaj:PostaviGa", false)
		TriggerEvent("dpemotes:Radim", false)
		TriggerEvent("glava:NemojGa", false)
		TriggerEvent('esx_basicneeds:healPlayer')
		SetPedArmour(PlayerPedId(), Armor)
		TipIgraca = 0
		Minuta = -1
		MinutaKr = -1
		SendNUIMessage({
			zatvoriscore = true
		})
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local isMale = skin.sex == 0
			TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
					Wait(3000)
					for i=1, #Config.Weapons, 1 do
						local weaponHash = GetHashKey(Config.Weapons[i].name)

						if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
							local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
							TriggerServerEvent("War:ObrisiGovno", Config.Weapons[i].name, ammo)
							Wait(500)
						end
					end
					Wait(1000)
					TriggerServerEvent("War:Zaustavi2")
					for i=1, #Config.Weapons, 1 do
						local weaponHash = GetHashKey(Config.Weapons[i].name)
						if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
							local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
							TriggerServerEvent("War:SpremiLoadout", Config.Weapons[i].name, ammo)
							Wait(500)
						end
					end
				end)
			end)
		end)
		SetPlayerInvincible(PlayerId(), false)
	end
end)

RegisterNetEvent("baseevents:onPlayerKilled")
AddEventHandler('baseevents:onPlayerKilled', function(kid, ostalo)
	if UZombi then
		if TipIgraca == 1 then
			if ostalo.weaponhash == GetHashKey("WEAPON_UNARMED") then
				TriggerServerEvent("zombi:SmanjiPoziciju", 1)
				TipIgraca = 3
				DoScreenFadeOut(1)
				FreezeEntityPosition(PlayerPedId(), true)
				SetEntityInvincible(PlayerPedId(), true)
				TriggerServerEvent("zombi:PovecajPoziciju", 2)
				local model = GetHashKey("u_m_y_zombie_01")
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(1)
				end
				SetPlayerModel(PlayerId(), model)
				local rndm = math.random(1, #Config.Zombiji)
				SetEntityCoordsNoOffset(PlayerPedId(), Config.Zombiji[rndm].x, Config.Zombiji[rndm].y, Config.Zombiji[rndm].z, false, false, false)
				NetworkResurrectLocalPlayer(Config.Zombiji[rndm].x, Config.Zombiji[rndm].y, Config.Zombiji[rndm].z, true, false)
				SetPlayerInvincible(PlayerId(), false)
				SetEntityInvincible(PlayerPedId(), false)
				SetEntityHeading(PlayerPedId(), Config.Zombiji[rndm].h)
				SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 5.0)
				SetEntityMaxHealth(PlayerPedId(), 200)
				TriggerEvent('esx_basicneeds:healPlayer')
				SetPedArmour(PlayerPedId(), 100)
				Wait(2000)
				FreezeEntityPosition(PlayerPedId(), false)
				DoScreenFadeIn(1)
				ESX.ShowNotification("Postali ste zombi!")
				Citizen.CreateThread(function()
					while UZombi do
						SetPedMoveRateOverride(PlayerPedId(), 1.5)
						Citizen.Wait(1)
					end
				end)
			else
				DoScreenFadeOut(1)
				FreezeEntityPosition(PlayerPedId(), true)
				SetEntityInvincible(PlayerPedId(), true)
				local rndm = math.random(1, #Config.Ljudi)
				SetEntityCoordsNoOffset(PlayerPedId(), Config.Ljudi[rndm].x, Config.Ljudi[rndm].y, Config.Ljudi[rndm].z, false, false, false)
				NetworkResurrectLocalPlayer(Config.Ljudi[rndm].x, Config.Ljudi[rndm].y, Config.Ljudi[rndm].z, true, false)
				SetEntityHeading(PlayerPedId(), Config.Ljudi[rndm].h)
				SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 5.0)
				TriggerEvent('esx_basicneeds:healPlayer')
				SetPedArmour(PlayerPedId(), 100)
				Wait(5000)
				FreezeEntityPosition(PlayerPedId(), false)
				SetEntityInvincible(PlayerPedId(), false)
				DoScreenFadeIn(1)
			end
		else
			DoScreenFadeOut(1)
			FreezeEntityPosition(PlayerPedId(), true)
			SetEntityInvincible(PlayerPedId(), true)
			local rndm = math.random(1, #Config.Zombiji)
			SetEntityCoordsNoOffset(PlayerPedId(), Config.Zombiji[rndm].x, Config.Zombiji[rndm].y, Config.Zombiji[rndm].z, false, false, false)
			NetworkResurrectLocalPlayer(Config.Zombiji[rndm].x, Config.Zombiji[rndm].y, Config.Zombiji[rndm].z, true, false)
			SetEntityHeading(PlayerPedId(), Config.Zombiji[rndm].h)
			SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 5.0)
			TriggerEvent('esx_basicneeds:healPlayer')
			SetPedArmour(PlayerPedId(), 100)
			Wait(5000)
			FreezeEntityPosition(PlayerPedId(), false)
			SetEntityInvincible(PlayerPedId(), false)
			DoScreenFadeIn(1)
		end
	end
end)

RegisterNetEvent("baseevents:onPlayerDied")
AddEventHandler('baseevents:onPlayerDied', function(kid, ostalo)
	if UZombi then
		if TipIgraca == 1 then
			DoScreenFadeOut(1)
			FreezeEntityPosition(PlayerPedId(), true)
			SetEntityInvincible(PlayerPedId(), true)
			local rndm = math.random(1, #Config.Ljudi)
			SetEntityCoordsNoOffset(PlayerPedId(), Config.Ljudi[rndm].x, Config.Ljudi[rndm].y, Config.Ljudi[rndm].z, false, false, false)
			NetworkResurrectLocalPlayer(Config.Ljudi[rndm].x, Config.Ljudi[rndm].y, Config.Ljudi[rndm].z, true, false)
			SetEntityHeading(PlayerPedId(), Config.Ljudi[rndm].h)
			TriggerEvent('esx_basicneeds:healPlayer')
			TriggerServerEvent("zombi:DajOruzja")
			Wait(5000)
			FreezeEntityPosition(PlayerPedId(), false)
			SetEntityInvincible(PlayerPedId(), false)
			DoScreenFadeIn(1)
		else
			DoScreenFadeOut(1)
			FreezeEntityPosition(PlayerPedId(), true)
			SetEntityInvincible(PlayerPedId(), true)
			local rndm = math.random(1, #Config.Zombiji)
			SetEntityCoordsNoOffset(PlayerPedId(), Config.Zombiji[rndm].x, Config.Zombiji[rndm].y, Config.Zombiji[rndm].z, false, false, false)
			NetworkResurrectLocalPlayer(Config.Zombiji[rndm].x, Config.Zombiji[rndm].y, Config.Zombiji[rndm].z, true, false)
			SetEntityHeading(PlayerPedId(), Config.Zombiji[rndm].h)
			SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 5.0)
			TriggerEvent('esx_basicneeds:healPlayer')
			SetPedArmour(PlayerPedId(), 100)
			Wait(5000)
			SetEntityInvincible(PlayerPedId(), false)
			FreezeEntityPosition(PlayerPedId(), false)
			DoScreenFadeIn(1)
		end
	end
end)

RegisterNetEvent("zombi:Joinaj")
AddEventHandler('zombi:Joinaj', function()
	ESX.TriggerServerCallback('esx_markeras:ProvjeriMarkere', function(jelje)
		if not jelje then
			ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
				if not inJail then
					if not UZombi then
						local brojic = tonumber(PlayerId())
						if brojic >= 1 and brojic <= 4 then
							brojic = brojic*100
						elseif brojic > 4 and brojic < 10 then
							brojic = brojic*50
						elseif brojic >= 10 and brojic <= 50 then
							brojic = brojic*10
						elseif brojic > 50 and brojic < 100 then
							brojic = brojic*5
						end
						Wait(brojic)
						ESX.TriggerServerCallback('zombi:DohvatiPoziciju', function(br)
							if br.poz > 60 then
								ESX.ShowNotification("Nema vise mjesta!")
							else
								if br.poz%2 == 0 then
									TriggerServerEvent("zombi:PovecajPoziciju", 1)
									UZombi = true
									TipIgraca = 1
									StareKoord = GetEntityCoords(PlayerPedId())
									ESX.ShowNotification("Usli ste u zombi event!")
									ESX.ShowNotification("Da napustite zombi event pisite /napustizombi!")
									TriggerEvent('esx_basicneeds:healPlayer')
									SetEntityCoordsNoOffset(PlayerPedId(), Config.Ljudi[br.igr+1].x, Config.Ljudi[br.igr+1].y, Config.Ljudi[br.igr+1].z, false, false, false)
									SetEntityHeading(PlayerPedId(), Config.Ljudi[br.igr+1].h)
									FreezeEntityPosition(PlayerPedId(), true)
									for i=1, #Config.Weapons, 1 do
										local weaponHash = GetHashKey(Config.Weapons[i].name)

										if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
											local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
											TriggerServerEvent("War:DajInv", Config.Weapons[i].name, ammo)
											Wait(500)
										end
									end
									TriggerServerEvent("zombi:DajOruzja")
									Startajj = 1
									PratiPocetak()
								else
									--zombi
									TriggerServerEvent("zombi:PovecajPoziciju", 2)
									UZombi = true
									TipIgraca = 2
									StareKoord = GetEntityCoords(PlayerPedId())
									ESX.ShowNotification("Usli ste u zombi event!")
									ESX.ShowNotification("Da napustite zombi event pisite /napustizombi!")
									for i=1, #Config.Weapons, 1 do
										local weaponHash = GetHashKey(Config.Weapons[i].name)
										if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
											local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
											TriggerServerEvent("War:DajInv", Config.Weapons[i].name, ammo)
											Wait(500)
										end
									end
									local model = GetHashKey("u_m_y_zombie_01")
									RequestModel(model)
									while not HasModelLoaded(model) do
										Wait(1)
									end
									SetPlayerModel(PlayerId(), model)
									SetEntityCoordsNoOffset(PlayerPedId(), Config.Zombiji[br.igr+1].x, Config.Zombiji[br.igr+1].y, Config.Zombiji[br.igr+1].z, false, false, false)
									SetEntityHeading(PlayerPedId(), Config.Zombiji[br.igr+1].h)
									FreezeEntityPosition(PlayerPedId(), true)
									SetEntityMaxHealth(PlayerPedId(), 200)
									TriggerEvent('esx_basicneeds:healPlayer')
									SetPedArmour(PlayerPedId(), 100)
									Startajj = 1
									PratiPocetak()
									SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 5.0)
									Citizen.CreateThread(function()
										while UZombi do
											SetPedMoveRateOverride(PlayerPedId(), 1.5)
											Citizen.Wait(1)
										end
									end)
								end
								SendNUIMessage({
									vrijeme = true,
									minuta = "10 minuta",
									prikaziscore = true
								})
								SetPlayerInvincible(PlayerId(), true)
								Armor = GetPedArmour(PlayerPedId())
								TriggerEvent("esx_ambulancejob:PostaviGa", true)
								TriggerEvent("pullout:PostaviGa", true)
								TriggerEvent("Muvaj:PostaviGa", true)
								TriggerEvent("dpemotes:Radim", true)
								TriggerEvent("esx:ZabraniInv", true)
								TriggerEvent("glava:NemojGa", true)
							end
						end)
					else
						ESX.ShowNotification("Vec ste u zombi eventu!")
					end
				else
					ESX.ShowNotification("Vi ste u zatvoru!")
				end
			end)
		else
			ESX.ShowNotification("Vi ste na markerima!")
		end
	end)
end)

RegisterNetEvent("zombi:Prekini")
AddEventHandler('zombi:Prekini', function()
    if UZombi then
		UZombi = false
		SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
		FreezeEntityPosition(PlayerPedId(), false)
		StareKoord = nil
		if TipIgraca == 1 then
			TriggerServerEvent("zombi:Tuljan")
		end
		TipIgraca = 0
		TriggerEvent("esx_ambulancejob:PostaviGa", false)
		TriggerEvent("pullout:PostaviGa", false)
		TriggerEvent("esx:ZabraniInv", false)
		TriggerEvent("Muvaj:PostaviGa", false)
		TriggerEvent("dpemotes:Radim", false)
		TriggerEvent("glava:NemojGa", false)
		TriggerEvent('esx_basicneeds:healPlayer')
		Minuta = -1
		MinutaKr = -1
		SetPedArmour(PlayerPedId(), Armor)
		SendNUIMessage({
			zatvoriscore = true
		})
		Wait(5000)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local isMale = skin.sex == 0
			TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
					Wait(3000)
					for i=1, #Config.Weapons, 1 do
						local weaponHash = GetHashKey(Config.Weapons[i].name)

						if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
							local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
							TriggerServerEvent("War:ObrisiGovno", Config.Weapons[i].name, ammo)
							Wait(500)
						end
					end
					Wait(1000)
					TriggerServerEvent("War:Zaustavi2")
					for i=1, #Config.Weapons, 1 do
						local weaponHash = GetHashKey(Config.Weapons[i].name)
						if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
							local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
							TriggerServerEvent("War:SpremiLoadout", Config.Weapons[i].name, ammo)
							Wait(500)
						end
					end
				end)
			end)
		end)
		SetPlayerInvincible(PlayerId(), false)
		SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 1.0)
	end
end)

--[[RegisterCommand("napustizombi", function(source, args, rawCommandString)
	if UZombi then
		if TipIgraca == 3 then
			TriggerServerEvent("zombi:SmanjiPoziciju", 2)
		else
			TriggerServerEvent("zombi:SmanjiPoziciju", TipIgraca)
		end
		UZombi = false
		TipIgraca = 0
		SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
		StareKoord = nil
		FreezeEntityPosition(PlayerPedId(), false)
		ESX.ShowNotification("Izaso si iz zombi eventa!")
		TriggerEvent("esx_ambulancejob:PostaviGa", false)
		TriggerEvent("pullout:PostaviGa", false)
		TriggerEvent("esx:ZabraniInv", false)
		TriggerEvent("Muvaj:PostaviGa", false)
		TriggerEvent("dpemotes:Radim", false)
		TriggerEvent("glava:NemojGa", false)
		TriggerEvent('esx_basicneeds:healPlayer')
		SetPedArmour(PlayerPedId(), Armor)
		Minuta = -1
		MinutaKr = -1
		SendNUIMessage({
			zatvoriscore = true
		})
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local isMale = skin.sex == 0
			TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
					Wait(3000)
					for i=1, #Config.Weapons, 1 do
						local weaponHash = GetHashKey(Config.Weapons[i].name)

						if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
							local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
							TriggerServerEvent("War:ObrisiGovno", Config.Weapons[i].name, ammo)
							Wait(500)
						end
					end
					Wait(1000)
					TriggerServerEvent("War:Zaustavi2")
					for i=1, #Config.Weapons, 1 do
						local weaponHash = GetHashKey(Config.Weapons[i].name)
						if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
							local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
							TriggerServerEvent("War:SpremiLoadout", Config.Weapons[i].name, ammo)
							Wait(500)
						end
					end
				end)
			end)
		end)
		SetPlayerInvincible(PlayerId(), false)
		SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 1.0)
	else
		ESX.ShowNotification("Niste u zombi eventu!")
	end
end, false)]]

function PratiPocetak()
	local Aha1 = 0
	local Aha2 = 0
	local Aha3 = 0
	local AhaGo = 0
	Citizen.CreateThread(function()
		while Startajj == 1 do
			Citizen.Wait(0)
			if UZombi then
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
					ESX.TriggerServerCallback('zombi:DohvatiPoziciju', function(br)
						if br.poz == 2 then
							UZombi = false
							Startajj = 0
							FreezeEntityPosition(PlayerPedId(), false)
							TriggerServerEvent("zombi:SmanjiPoziciju", TipIgraca)
							TipIgraca = 0
							SetEntityCoords(PlayerPedId(), StareKoord, false, false, false, false)
							StareKoord = nil
							TriggerEvent("esx_ambulancejob:PostaviGa", false)
							TriggerEvent("pullout:PostaviGa", false)
							TriggerEvent("esx:ZabraniInv", false)
							TriggerEvent("Muvaj:PostaviGa", false)
							TriggerEvent("dpemotes:Radim", false)
							TriggerEvent("glava:NemojGa", false)
							TriggerEvent('esx_basicneeds:healPlayer')
							SetPedArmour(PlayerPedId(), Armor)
							Minuta = -1
							MinutaKr = -1
							SendNUIMessage({
								zatvoriscore = true
							})
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
								local isMale = skin.sex == 0
								TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
									ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
										TriggerEvent('skinchanger:loadSkin', skin)
										Wait(3000)
										for i=1, #Config.Weapons, 1 do
											local weaponHash = GetHashKey(Config.Weapons[i].name)

											if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
												local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
												TriggerServerEvent("War:ObrisiGovno", Config.Weapons[i].name, ammo)
												Wait(500)
											end
										end
									end)
								end)
								Wait(1000)
								TriggerServerEvent("War:Zaustavi2")
								for i=1, #Config.Weapons, 1 do
									local weaponHash = GetHashKey(Config.Weapons[i].name)
									if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
										local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
										TriggerServerEvent("War:SpremiLoadout", Config.Weapons[i].name, ammo)
										Wait(500)
									end
								end
							end)
							SetPlayerInvincible(PlayerId(), false)
							SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 1.0)
							ESX.ShowNotification("Zombi event je zavrsio zato sto ste sami bili!")
						else
							FreezeEntityPosition(PlayerPedId(), false)
							Startajj = 0
							TriggerServerEvent("zombi:SyncajKraj", 3)
							PratiKraj()
						end
						SetPlayerInvincible(PlayerId(), false)
					end)
				end
			else
				Startajj = 0
			end
		end
	end)
end

