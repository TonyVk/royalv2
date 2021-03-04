----------------------------------------------------------------
-- Copyright © 2019 by Guy Shefer
-- Made By: Guy293
-- GitHub: https://github.com/Guy293
-- Fivem Forum: https://forum.fivem.net/u/guy293/
-- Tweaked by: Campinchris & Jougito
----------------------------------------------------------------

--- DO NOT EDIT THIS --
local ESX      	 = nil
local holstered  = true
local blocked	 = false
local zadnjeoruzje = GetHashKey("WEAPON_UNARMED")
local PlayerData = {}

local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
      -- melee:
      --["prop_golf_iron_01"] = 1141786504, -- positioning still needs work
      ["w_me_bat"] = -1786099057,
      ["prop_ld_jerrycan_01"] = 883325847,
      -- assault rifles:
      ["w_ar_carbinerifle"] = -2084633992,
      ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_Mk2"),
      ["w_ar_assaultrifle"] = -1074790547,
      ["w_ar_specialcarbine"] = -1063057011,
      ["w_ar_bullpuprifle"] = 2132975508,
      ["w_ar_advancedrifle"] = -1357824103,
      -- sub machine guns:
      ["w_sb_microsmg"] = 324215364,
      ["w_sb_assaultsmg"] = -270015777,
      ["w_sb_smg"] = 736523883,
      ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMGMk2"),
      ["w_sb_gusenberg"] = 1627465347,
      -- sniper rifles:
      ["w_sr_sniperrifle"] = 100416529,
      -- shotguns:
      ["w_sg_assaultshotgun"] = -494615257,
      ["w_sg_bullpupshotgun"] = -1654528753,
      ["w_sg_pumpshotgun"] = 487013001,
      ["w_ar_musket"] = -1466123874,
      ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
      -- ["w_sg_sawnoff"] = 2017895192 don't show, maybe too small?
      -- launchers:
      ["w_lr_firework"] = 2138347493
    }
}

local attached_weapons = {}
------------------------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  	PlayerData.job = job
end)

--[[Citizen.CreateThread(function()
  while true do
      local me = GetPlayerPed(-1)
      ---------------------------------------
      -- attach if player has large weapon --
      ---------------------------------------
      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
          if HasPedGotWeapon(me, wep_hash, false) then
              if not attached_weapons[wep_name] then
                  AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
              end
          end
      end
      --------------------------------------------
      -- remove from back if equipped / dropped --
      --------------------------------------------
      for name, attached_object in pairs(attached_weapons) do
          -- equipped? delete it from back:
          if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
      end
  Wait(0)
  end
end)]]

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end
	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end

 Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		loadAnimDict("rcmjosh4")
		loadAnimDict("reaction@intimidation@cop@unarmed")
		loadAnimDict("reaction@intimidation@1h")
		local ped = PlayerPedId()
		if GetSelectedPedWeapon(ped) ~= zadnjeoruzje then
			if not IsPedInAnyVehicle(ped, false) then
				if GetVehiclePedIsTryingToEnter(ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
					if CheckWeapon(ped) then
						--if IsPedArmed(ped, 4) then
						if holstered then
							blocked   = true
							SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
							TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0 )
							--TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 30, 0, 0, 0, 0 ) Use this line if you want to stand still when removing weapon
							Citizen.Wait(1250)
							SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
							Citizen.Wait(Config.cooldown)
							ClearPedTasks(ped)
							holstered = false
							blocked = false
							for name, attached_object in pairs(attached_weapons) do
								-- equipped? delete it from back:
								if GetSelectedPedWeapon(ped) ==  attached_object.hash or not HasPedGotWeapon(ped, attached_object.hash, false) then -- equipped or not in weapon wheel
									DeleteObject(attached_object.handle)
									attached_weapons[name] = nil
								end
							end
						elseif GetSelectedPedWeapon(ped) ~= zadnjeoruzje then
							blocked   = true
							SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
							TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0 )
							--TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 30, 0, 0, 0, 0 ) Use this line if you want to stand still when removing weapon
							Citizen.Wait(1250)
							SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
							Citizen.Wait(Config.cooldown)
							ClearPedTasks(ped)
							holstered = false
							blocked = false
							for name, attached_object in pairs(attached_weapons) do
								-- equipped? delete it from back:
								if GetSelectedPedWeapon(ped) ==  attached_object.hash or not HasPedGotWeapon(ped, attached_object.hash, false) then -- equipped or not in weapon wheel
									DeleteObject(attached_object.handle)
									attached_weapons[name] = nil
								end
							end
							for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
								if zadnjeoruzje == wep_hash then
									if not attached_weapons[wep_name] then
										AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
									end
								end
							end
						end
					else
					--elseif not IsPedArmed(ped, 4) then
						if not holstered then
							TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0 ) -- Change 50 to 30 if you want to stand still when holstering weapon
							--TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 30, 0, 0, 0.125, 0 ) Use this line if you want to stand still when holstering weapon
							Citizen.Wait(1700)
							ClearPedTasks(ped)
							holstered = true
							for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
								if zadnjeoruzje == wep_hash then
									if not attached_weapons[wep_name] then
										AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
									end
								end
							end
						end
					end
				else
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
				end
			else
				if not holstered then
					holstered = true
				end
			end
			zadnjeoruzje = GetSelectedPedWeapon(ped)
		end
	end
end)

local connected = false

AddEventHandler("playerSpawned", function()
	Wait(500)
	if not connected then
		  local me = GetPlayerPed(-1)
		  ---------------------------------------
		  -- attach if player has large weapon --
		  ---------------------------------------
		  for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
			  if HasPedGotWeapon(me, wep_hash, false) then
				  if not attached_weapons[wep_name] then
					  AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
				  end
			  end
		  end
		  --------------------------------------------
		  -- remove from back if equipped / dropped --
		  --------------------------------------------
		  for name, attached_object in pairs(attached_weapons) do
			  -- equipped? delete it from back:
			  if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
				DeleteObject(attached_object.handle)
				attached_weapons[name] = nil
			  end
		  end
		  connected = true
	end
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler("esx:addWeapon", function(source, weaponName, ammo)
	local me = GetPlayerPed(-1)
	---------------------------------------
	-- attach if player has large weapon --
	---------------------------------------
	for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
		if HasPedGotWeapon(me, wep_hash, false) then
			if not attached_weapons[wep_name] then
				AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
			end
		end
	end
	--------------------------------------------
	-- remove from back if equipped / dropped --
	--------------------------------------------
	for name, attached_object in pairs(attached_weapons) do
		-- equipped? delete it from back:
		if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
			DeleteObject(attached_object.handle)
			attached_weapons[name] = nil
		end
	end
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler("esx:removeWeapon", function(source, weaponName, ammo)
	local me = GetPlayerPed(-1)
	---------------------------------------
	-- attach if player has large weapon --
	---------------------------------------
	for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
		if HasPedGotWeapon(me, wep_hash, false) then
			if not attached_weapons[wep_name] then
				AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
			end
		end
	end
	--------------------------------------------
	-- remove from back if equipped / dropped --
	--------------------------------------------
	for name, attached_object in pairs(attached_weapons) do
		-- equipped? delete it from back:
		if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
			DeleteObject(attached_object.handle)
			attached_weapons[name] = nil
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if blocked then
			DisableControlAction(1, 25, true )
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 23, true)
			DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
			DisablePlayerFiring(ped, true) -- Disable weapon firing
		end
	end
end)


function CheckWeapon(ped)
	--[[if IsPedArmed(ped, 4) then
		return true
	end]]
	if IsEntityDead(ped) then
		blocked = false
		return false
	else
		for i = 1, #Config.Weapons do
			if GetHashKey(Config.Weapons[i]) == GetSelectedPedWeapon(ped) then
				return true
			end
		end
		return false
	end
end

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end
