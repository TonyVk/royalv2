ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Text               = {}
local lastduree          = ""
local lasttarget         = ""
local BanList            = {}
local BanListLoad        = false
local BanListHistory     = {}
local BanListHistoryLoad = false

--[[ AC COMMAND TO TOGGLE ANTICHEAT ]]--
RegisterCommand("ac", function(thePlayer, args, rawCommand)
	local Source = source
	local Vrati = 0
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available or user.getGroup() == "admin" then
				Vrati = 1
			else
				Vrati = 0
			end
		end)
	end)
	if Vrati == 1 then
		TriggerClientEvent('AntiCheat:Toggle', Source, 1)
	end
end)

--Sikora

local ExplosionTypes = {
    "EXPLOSION_GRENADE",  
    "EXPLOSION_GRENADELAUNCHER",  
    "EXPLOSION_STICKYBOMB",  
    "EXPLOSION_MOLOTOV",  
    "EXPLOSION_ROCKET",  
    "EXPLOSION_TANKSHELL",  
    "EXPLOSION_HI_OCTANE",  
    "EXPLOSION_CAR",  
    "EXPLOSION_PLANE",  
    "EXPLOSION_PETROL_PUMP",  
    "EXPLOSION_BIKE",  
    "EXPLOSION_DIR_STEAM",  
    "EXPLOSION_DIR_FLAME",  
    "EXPLOSION_DIR_WATER_HYDRANT",  
    "EXPLOSION_DIR_GAS_CANISTER",  
    "EXPLOSION_BOAT",  
    "EXPLOSION_SHIP_DESTROY",  
    "EXPLOSION_TRUCK",  
    "EXPLOSION_BULLET",  
    "EXPLOSION_SMOKEGRENADELAUNCHER",  
    "EXPLOSION_SMOKEGRENADE",  
    "EXPLOSION_BZGAS",  
    "EXPLOSION_FLARE",  
    "EXPLOSION_GAS_CANISTER",  
    "EXPLOSION_EXTINGUISHER",  
    "EXPLOSION_PROGRAMMABLEAR",  
    "EXPLOSION_TRAIN",  
    "EXPLOSION_BARREL",  
    "EXPLOSION_PROPANE",  
    "EXPLOSION_BLIMP",  
    "EXPLOSION_DIR_FLAME_EXPLODE",  
    "EXPLOSION_TANKER",  
    "EXPLOSION_PLANE_ROCKET",  
    "EXPLOSION_VEHICLE_BULLET",  
    "EXPLOSION_GAS_TANK",  
    "EXPLOSION_BIRD_CRAP " 
}

local BlockedExplosions = {1, 2, 4, 5, 18, 25, 29, 32, 33, 35, 36, 37, 38}

AddEventHandler('explosionEvent', function(sender, ev)
	if ev.explosionType ~= 0 and ev.explosionType ~= 13 and ev.explosionType ~= 30 and ev.explosionType ~= 12 and ev.explosionType ~= 34 and ev.explosionType ~= 22 and ev.explosionType ~= 61 then
		if ExplosionTypes[ev.explosionType+1] ~= nil then
			TriggerEvent("DiscordBot:Anticheat", GetPlayerName(sender).."("..sender..") je napravio eksploziju (Tip eksplozije: "..ExplosionTypes[ev.explosionType+1].."["..ev.explosionType.."])")
		else
			TriggerEvent("DiscordBot:Anticheat", GetPlayerName(sender).."("..sender..") je napravio eksploziju (Tip eksplozije: "..ev.explosionType..")")
		end
	end
	for _, v in ipairs(BlockedExplosions) do
		if ev.explosionType == v then
			TriggerEvent("AntiCheat:Citer", sender)
			CancelEvent()
		end
    end
end)

AddEventHandler("clearPedTasksEvent", function(sender, data)
	TriggerEvent("DiscordBot:Anticheat", "[TESTIRANJE] "..GetPlayerName(sender).."("..sender..") je izbacio iz vozila!")
end)

WeaponNames = {
			   [tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
			   [tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
			   [tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
			   [tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
			   [tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
			   [tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
			   [tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
			   [tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
			   [tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
			   [tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
			   [tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50',
			   [tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
			   [tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
			   [tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
			   [tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
			   [tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
			   [tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
			   [tostring(GetHashKey('WEAPON_MG'))] = 'MG',
			   [tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
			   [tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
			   [tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-Off Shotgun',
			   [tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
			   [tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
			   [tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stun Gun',
			   [tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
			   [tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
			   [tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
			   [tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
			   [tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
			   [tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
			   [tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
			   [tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
			   [tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
			   [tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
			   [tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
			   [tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
			   [tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
			   [tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
			   [tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
			   [tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
			   [tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
			   [tostring(GetHashKey('OBJECT'))] = 'Object',
			   [tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
			   [tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',
			   [tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
			   [tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
			   [tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
			   [tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
			   [tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
			   [tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
			   [tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
			   [tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
			   [tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
			   [tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
			   [tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
			   [tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
			   [tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
			   [tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
			   [tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
			   [tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
			   [tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
			   [tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
			   [tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
			   [tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
			   [tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
			   [tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
			   [tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
			   [tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
			   [tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
			   [tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
			   [tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
			   [tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
			   [tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
			   [tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
			   [tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
			   [tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',
			   [tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
			   [tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
			   [tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
			   [tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
			   [tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
			   [tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
			   [tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
			   [tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
			   [tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
			   [tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
			   [tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
			   [tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
			   [tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
			   [tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
			   [tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
			   [tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',
			   [tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
			   [tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
			   [tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
			   [tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
			   [tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battle Axe',
			   [tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
			   [tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
			   [tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipebomb',
			   [tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
			   [tostring(GetHashKey('WEAPON_WRENCH'))] = 'Wrench',
			   [tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
			   [tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
			   [tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar'
			  }

AddEventHandler("weaponDamageEvent", function(sender, data)
	local sourceIsAttacker = data.f135
	local oruzje = data.weaponType
	local ime = WeaponNames[tostring(oruzje)]
	if sourceIsAttacker and data.willKill then
		local attacker = data.parentGlobalId
		local victim = data.hitGlobalId
		print(GetPlayerName(attacker).." killed "..GetPlayerName(victim).." with "..ime)
	end
end)

--[[AddEventHandler("entityCreated",  function(entity)
	local entID = NetworkGetNetworkIdFromEntity(entity)
	TriggerClientEvent("anticheat:ObrisiPeda", NetworkGetEntityOwner(entity), NetworkGetEntityOwner(entity), entID, GetPlayerName(NetworkGetEntityOwner(entity)))
end)]]

BlObjs = {
	"s_m_y_swat_01",
	"prop_gold_cont_01",
	"p_cablecar_s",
	"stt_prop_stunt_tube_l",
	"stt_prop_stunt_track_dwuturn",
	"prop_fnclink_05crnr1",
	"cargoplane",
	"prop_beach_fire",
	"stt_prop_stunt_soccer_ball",
	"xs_prop_hamburgher_wl",
	"sr_prop_spec_tube_xxs_01a",
	"armytanker",
	-145066854,
	"stt_prop_stunt_track_dwslope30",
	"a_m_o_acult_01",
	"a_m_y_skater_01",
	"a_m_y_skater_02"
}

AddEventHandler("entityCreating",  function(entity)
	for i=1,#BlObjs do
		local model = (type(BlObjs[i]) == 'number' and BlObjs[i] or GetHashKey(BlObjs[i]))
		if GetEntityModel(entity) == model then
			local ime = GetPlayerName(NetworkGetEntityOwner(entity))
			local id = NetworkGetEntityOwner(entity)
			TriggerEvent("DiscordBot:Anticheat", ime.."["..id.."] je spawn zabranjen objekt/NPC-a ("..BlObjs[i]..")")
			CancelEvent()
		end
	end
end)

--Fake eventi
RegisterServerEvent('esx_drugs:pickedUpCannabis')
AddEventHandler('esx_drugs:pickedUpCannabis', function()
    TriggerEvent('AntiCheat:FakeEvent', source)
end)

RegisterServerEvent('esx_drugs:processCannabis')
AddEventHandler('esx_drugs:processCannabis', function()
	TriggerEvent('AntiCheat:FakeEvent', source)
end)

--[[ CHECK USER FOR ADMIN OR WHITELIST ]]--
RegisterServerEvent('Anticheat:Whitelist')
AddEventHandler('Anticheat:Whitelist', function(playerId)
	local _source = source
	local deets = getIdentity(playerId)
	if deets.group == 'admin' or deets.group == 'superadmin' or inArray(deets.identifier, Config.whitelist) then
		TriggerClientEvent('Anticheat:WLReturn', _source, true)
	end
end)

RegisterServerEvent('AntiCheat:Citer')
AddEventHandler('AntiCheat:Citer', function(id)
	local _source = id
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	print("[AntiCheat] | " ..xPlayer.name.. "[" ..xPlayer.identifier.. "] Citer")
	TriggerClientEvent('chatMessage', -1, '^3[AntiCheat]', {255, 0, 0}, "^3" ..xPlayer.name.. "^1 je banan | Razlog: Citer")
	--DropPlayer(source, _U('drop_player_superjump_notification')..Config.Discord)
	bandata = {}
	bandata.reason = "Citer. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: "..Config.Discord -- drop/ban reason
	bandata.period = '0' -- days, 0 for permanent
	TriggerEvent('Anticheat:AutoBan', _source, bandata)
	local message = (xPlayer.name .." ".. xPlayer.identifier .. _U('permabanned_for') .. "citer" .. " " .. _U('by') .. " server")
	sendToDiscord(Config.webhookban, "BanSql", message, Config.red)
end)

RegisterServerEvent('AntiCheat:FakeEvent')
AddEventHandler('AntiCheat:FakeEvent', function(id)
	local _source = id
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	print("[AntiCheat] | " ..xPlayer.name.. "[" ..xPlayer.identifier.. "] Pokusao pozvati fake event")
	TriggerClientEvent('chatMessage', -1, '^3[AntiCheat]', {255, 0, 0}, "^3" ..xPlayer.name.. "^1 je banan | Razlog: Pokusao pozvati fake event")
	--DropPlayer(source, _U('drop_player_superjump_notification')..Config.Discord)
	bandata = {}
	bandata.reason = "Pokusaj pozivanja fake eventa. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: "..Config.Discord -- drop/ban reason
	bandata.period = '0' -- days, 0 for permanent
	TriggerEvent('Anticheat:AutoBan', _source, bandata)
	local message = (xPlayer.name .." ".. xPlayer.identifier .. _U('permabanned_for') .. "pokusaj pozivanja fake eventa" .. " " .. _U('by') .. " server")
	sendToDiscord(Config.webhookban, "BanSql", message, Config.red)
end)

RegisterServerEvent('AntiCheat:Dumper')
AddEventHandler('AntiCheat:Dumper', function(id)
	local _source = id
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	print("[AntiCheat] | " ..xPlayer.name.. "[" ..xPlayer.identifier.. "] Pokusao dump server fileove")
	TriggerClientEvent('chatMessage', -1, '^3[AntiCheat]', {255, 0, 0}, "^3" ..xPlayer.name.. "^1 je banan | Razlog: Pokusao dump server fileove")
	--DropPlayer(source, _U('drop_player_superjump_notification')..Config.Discord)
	bandata = {}
	bandata.reason = "Pokusaj dumpanja server fileova. Ukoliko mislite da je doslo do pogreske kontaktirajte nas na: "..Config.Discord -- drop/ban reason
	bandata.period = '0' -- days, 0 for permanent
	TriggerEvent('Anticheat:AutoBan', _source, bandata)
	local message = (xPlayer.name .." ".. xPlayer.identifier .. _U('permabanned_for') .. "pokusaj dumpanja server fileova" .. " " .. _U('by') .. " server")
	sendToDiscord(Config.webhookban, "BanSql", message, Config.red)
end)

--[[ BLACKLISTED CARS - KICK AND BAN ]]--
RegisterServerEvent('AntiCheat:Cars')
AddEventHandler('AntiCheat:Cars', function(blacklistedCar)
	local blcar = blacklistedCar
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)    
	print("[AntiCheat] | " ..xPlayer.name.. "["..xPlayer.identifier.. "] ".._U('was_dropped_blcars'))
	TriggerClientEvent('chatMessage', -1, '^3[AntiCheat]', {255, 0, 0}, "^3" ..xPlayer.name.. "^1 ".._U('was_dropped_blcars'))
	--DropPlayer(source, _U('drop_player_blcars_notification')..Config.Discord)
	bandata = {}
	bandata.reason = _U('drop_player_blcars_notification', blcar)..Config.Discord -- drop/ban reason
	bandata.period = '0' -- days, 0 for permanent
	--TriggerEvent('Anticheat:AutoBan', _source, bandata)
end)

--[[ SUPERJUMP - KICK AND BAN ]]--
RegisterServerEvent('AntiCheat:Jump')
AddEventHandler('AntiCheat:Jump', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	print("[AntiCheat] | " ..xPlayer.name.. "[" ..xPlayer.identifier.. "] ".._U('was_dropped_superjump'))
	TriggerClientEvent('chatMessage', -1, '^3[AntiCheat]', {255, 0, 0}, "^3" ..xPlayer.name.. "^1 ".._U('was_dropped_superjump'))
	--DropPlayer(source, _U('drop_player_superjump_notification')..Config.Discord)
	bandata = {}
	bandata.reason = _U('drop_player_superjump_notification')..Config.Discord -- drop/ban reason
	bandata.period = '0' -- days, 0 for permanent
	TriggerEvent('Anticheat:AutoBan', _source, bandata)
end)

RegisterNetEvent('ac:IzasoVezan')
AddEventHandler('ac:IzasoVezan', function(ime)
	print("[AntiCheat] | " ..ime.. " je napustio server dok je bio vezan")
	TriggerClientEvent('chatMessage', -1, '^3[AntiCheat]', {255, 0, 0}, "^3" ..ime.. "^1 je napustio server dok je bio vezan (1 dan ban)")
	bandata = {}
	bandata.reason = "AntiCheat: ( Izaso dok si bio vezan ). Ukoliko je doslo do greske, javite se na discordu: "..Config.Discord -- drop/ban reason
	bandata.period = '1' -- days, 0 for permanent
	TriggerEvent('Anticheat:OffABan', ime, bandata)
	local message = (ime .. _U('banned_for') .. 1 .. _U('days_for') .. "izaso dok je bio vezan".." ".. _U('by') .." server")
	sendToDiscord(Config.webhookban, "BanSql", message, Config.red)
end)

RegisterNetEvent('ac:MjenjanjeModela')
AddEventHandler('ac:MjenjanjeModela', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	print("[AntiCheat] | " ..xPlayer.name.. "[" ..xPlayer.identifier.. "] je mjenjao model vozila sa CheatEngineom")
	TriggerClientEvent('chatMessage', -1, '^3[AntiCheat]', {255, 0, 0}, "^3" ..xPlayer.name.. "^1 je mjenjao modele vozila")
	--DropPlayer(source, _U('drop_player_superjump_notification')..Config.Discord)
	bandata = {}
	bandata.reason = "AntiCheat: ( Mjenjanje modela vozila sa CheatEngineom ). Ukoliko je doslo do greske, javite se na discordu: "..Config.Discord -- drop/ban reason
	bandata.period = '0' -- days, 0 for permanent
	TriggerEvent('Anticheat:AutoBan', _source, bandata)
end)

RegisterServerEvent('Anticheat:OffABan')
AddEventHandler('Anticheat:OffABan', function(ime, args) 
	--print('Source: ',ESX.DumpTable(_source))
	--print('Arguments: ',ESX.DumpTable(args))
	--print ('period: '..args.period)
	--print ('reason: '..args.reason)
	local deets = DajMiPotrebno(ime)
	local message
	if deets ~= nil then
		local identifier = deets.identifier
		local license = deets.license
		local liveid    = ""
		local xblid     = ""
		local discord   = ""
		local playerip
		local duree = tonumber(args.period)
		local reason = args.reason
		local targetplayername = ime
		local sourceplayername = 'autobanned'
			
		if reason == "" then
			reason = _U('no_reason')
		end
		if duree > 0 then
			local permanent = 0
			ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
			message = (targetplayername .. identifier .." | ".. license .." | ".. liveid .." | ".. xblid .." | ".. discord .." | ".. playerip .." " .. _U('banned_for') .. duree .. _U('days_for') .. reason.." ".. _U('by') .." ".. sourceplayername)
			--DropPlayer(_source, reason)
		else
			local permanent = 1
			ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
			message = (targetplayername .. identifier .. " | " .. license .. " | " .. liveid .. " | " .. xblid .. " | " .. discord .. " | " .. playerip .." " .. _U('permabanned_for') .. reason .. " " .. _U('by') .. " " .. sourceplayername)
			--DropPlayer(_source, reason)
		end
		sendToDiscord(Config.webhookban, "BanSql", message, Config.red)
	end
end)

RegisterServerEvent('Anticheat:AutoBan')
AddEventHandler('Anticheat:AutoBan', function(source, args)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	--print('Source: ',ESX.DumpTable(_source))
	--print('Arguments: ',ESX.DumpTable(args))
	--print ('period: '..args.period)
	--print ('reason: '..args.reason)
	local identifier
	local license
	local liveid    = ""
	local xblid     = ""
	local discord   = ""
	local playerip
	local duree = tonumber(args.period)
	local reason = args.reason
	local targetplayername = xPlayer.name
	local sourceplayername = 'autobanned'
		
	if reason == "" then
		reason = _U('no_reason')
	end
	
	for k,v in ipairs(GetPlayerIdentifiers(_source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifier = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	if duree > 0 then
		local permanent = 0
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	else
		local permanent = 1
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	end
end)

function ProvjeraResursa()
	local broj = GetNumResources()-1
	local imena = {}
	for i = 0, broj do
		local str = GetResourceByFindIndex(i)
		table.insert(imena, str)
	end
	TriggerClientEvent("anticheat:ProvjeriImena", -1, imena)
	SetTimeout(120000, ProvjeraResursa)
end

RegisterNetEvent('ac:Provjeraresursa')
AddEventHandler('ac:Provjeraresursa', function(imena)
	local _source = source
	local broj = GetNumResources()-1
	local nepoznati = nil
	for i = 1, #imena do
		local naso = 0
		for j = 0, broj do
			local str = GetResourceByFindIndex(j)
			if str == imena[i] then
				naso = 1
			end
		end
		if naso == 0 then
			nepoznati = imena[i]
		end
	end
	if nepoznati ~= nil then
		TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je koristio lua injector ("..nepoznati..")")
		TriggerEvent("AntiCheat:Citer", _source)
	end
end)

RegisterCommand("rconbanreload", function(source, args, rawCommandString)
	if source == 0 then
		BanListLoad        = false
		BanListHistoryLoad = false
		Wait(5000)
		if BanListLoad == true then
			print(_U('banlist_loaded'))
			if BanListHistoryLoad == true then
				print(_U('banhistory_loaded'))
			end
		else
			print(_U('banlist_starterror'))
		end
	end
end, false)

function ProvjeraResursa2(id)
	local broj = GetNumResources()-1
	local imena = {}
	for i = 0, broj do
		local str = GetResourceByFindIndex(i)
		table.insert(imena, str)
	end
	TriggerClientEvent("anticheat:ProvjeriImena", id, imena)
end

TriggerEvent('es:addGroupCommand', 'provjeriresurse', Config.permission, function (source, args, user)
	if args[1] ~= nil then
		ProvjeraResursa2(tonumber(args[1]))
		TriggerEvent('bansql:sendMessage', source, "Igrac je provjeren!")
	else
		TriggerEvent('bansql:sendMessage', source, "/provjeriresurse [ID igraca]")
	end
end)

TriggerEvent('es:addGroupCommand', 'banreload', Config.permission, function (source)
  BanListLoad        = false
  BanListHistoryLoad = false
  Wait(5000)
  if BanListLoad == true then
	TriggerEvent('bansql:sendMessage', source, _U('banlist_loaded'))
	if BanListHistoryLoad == true then
		TriggerEvent('bansql:sendMessage', source, _U('banhistory_loaded'))
	end
  else
	TriggerEvent('bansql:sendMessage', source, _U('banlist_starterror'))
  end
end)

TriggerEvent('es:addGroupCommand', 'banhistory', Config.permission, function (source, args, user)
 if args[1] ~= nil and BanListHistory ~= {} then
	local nombre = (tonumber(args[1]))
	local name   = table.concat(args, " ",1)
	if name ~= "" then

			if nombre ~= nil and nombre > 0 and BanListHistory[nombre] ~= nil then
					local expiration = BanListHistory[nombre].expiration
					local timeat     = BanListHistory[nombre].timeat
					local calcul1    = expiration - timeat
					local calcul2    = calcul1 / 86400
					local calcul2 	 =  math.ceil(calcul2)
					local resultat   = (tostring(BanListHistory[nombre].targetplayername)) .. " , " .. (tostring(BanListHistory[nombre].sourceplayername)) .. " , " .. (tostring(BanListHistory[nombre].reason)) .. " , " .. calcul2 .. _U('days')
					
					TriggerEvent('bansql:sendMessage', source, (nombre .." : ".. resultat))
			else
					for i = 1, #BanListHistory, 1 do
						if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
							local expiration = BanListHistory[i].expiration
							local timeat     = BanListHistory[i].timeat
							local calcul1    = expiration - timeat
							local calcul2    = calcul1 / 86400
							local calcul2 	 =  math.ceil(calcul2)					
							local resultat   = (tostring(BanListHistory[i].targetplayername)) .. " , " .. (tostring(BanListHistory[i].sourceplayername)) .. " , " .. (tostring(BanListHistory[i].reason)) .. " , " .. calcul2 .. _U('days')

							TriggerEvent('bansql:sendMessage', source, (i .." : ".. resultat))
						end
					end
			end
	else
		TriggerEvent('bansql:sendMessage', source, _U('invalid_name'))
	end
  else
	TriggerEvent('bansql:sendMessage', source, _U('add_history'))
  end
end)

TriggerEvent('es:addGroupCommand', 'unban', Config.permission, function (source, args, user)
  if args[1] ~= nil then
    local name = table.concat(args, " ")
     MySQL.Async.fetchScalar('SELECT identifier FROM banlist WHERE targetplayername=@name',
    {
        ['@name'] = name
    }, function(identifier)
        if identifier ~= nil then
            MySQL.Async.execute(
            'DELETE FROM banlist WHERE targetplayername=@name',
            {
              ['@name']  = name
            },
                function ()
                loadBanList()
            end)
			if Config.EnableDiscordLink then
				local sourceplayername = GetPlayerName(source)
				local message = (name .. _U('was_unbanned') .." ".. _U('by') .." ".. sourceplayername)
				sendToDiscord(Config.webhookunban, "BanSql", message, Config.green)
			end
			TriggerEvent('bansql:sendMessage', source, name .. _U('was_unbanned'))
        else
			TriggerEvent('bansql:sendMessage', source, _U('invalid_name'))
        end
    end)
  else
	TriggerEvent('bansql:sendMessage', source, _U('invalid_name'))
  end
end)

TriggerEvent('es:addGroupCommand', 'ban', Config.permission, function (source, args, user)
	local identifier
	local license
	local liveid    = "no info"
	local xblid     = "no info"
	local discord   = "no info"
	local playerip
	local target    = tonumber(args[1])
	local duree     = tonumber(args[2])
	local reason    = table.concat(args, " ",3)
	local permanent = 0
		
		if reason == "" then
			reason = _U('no_reason')
		end
		if target ~= nil and target > 0 then
			local ping = GetPlayerPing(target)
        
			if ping ~= nil and ping > 0 then
				if duree ~= nil and duree < 365 then
					local sourceplayername = GetPlayerName(source)
					local targetplayername = GetPlayerName(target)
						for k,v in ipairs(GetPlayerIdentifiers(target))do
							if string.sub(v, 1, string.len("steam:")) == "steam:" then
								identifier = v
							elseif string.sub(v, 1, string.len("license:")) == "license:" then
								license = v
							elseif string.sub(v, 1, string.len("live:")) == "live:" then
								liveid = v
							elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
								xblid  = v
							elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
								discord = v
							elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
								playerip = v
							end
						end
				
					if duree > 0 then
						ban(source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
						DropPlayer(target, _U('you_have_been_banned') .. reason)
					else
						local permanent = 1
						ban(source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
						DropPlayer(target, _U('you_have_been_permabanned') .. reason)
					end
				
				else
					TriggerEvent('bansql:sendMessage', source, _U('invalid_time'))
				end	
			else
				TriggerEvent('bansql:sendMessage', source, _U('invalid_id'))
			end
		else
			TriggerEvent('bansql:sendMessage', source, _U('invalid_id'))
			TriggerEvent('bansql:sendMessage', source, _U('add'))
		end
end)

TriggerEvent('es:addGroupCommand', 'banoffline', Config.permission, function (source, args, user)
	if args[1] ~= nil then
		lastduree  = tonumber(args[1])
		lasttarget = table.concat(args, " ",2)
		if lastduree ~= "" and lastduree ~= nil then
			if lasttarget ~= "" and lasttarget ~= nil then
				TriggerEvent('bansql:sendMessage', source, (lasttarget .. _U('banned_for') .. lastduree .. _U('banned_for_continued')))
			else
				TriggerEvent('bansql:sendMessage', source, _U('invalid_id'))
			end
		else
			TriggerEvent('bansql:sendMessage', source, _U('invalid_time'))
			TriggerEvent('bansql:sendMessage', source, _U('invalid_id'))
		end
	else
		TriggerEvent('bansql:sendMessage', source, _U('add_offline'))
	end
end)

TriggerEvent('es:addGroupCommand', 'reason', Config.permission, function (source, args, user)
	local duree            = lastduree
	local name             = lasttarget
	local reason           = table.concat(args, " ",1)
	local permanent        = 0
	local playerip         = "0.0.0.0"
	local liveid           = "no info"
	local xblid            = "no info"
	local discord          = "no info"
	local sourceplayername = GetPlayerName(source)

	if name ~= "" then
		if duree ~= nil and duree < 365 then
			if reason == "" then
				reason = _U('no_reason')
			end

			MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE playername = @playername', 
			{
				['@playername'] = name
			}, function(data)

				if data[1] ~= nil then
					if duree > 0 then
						ban(source,data[1].identifier,data[1].license,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,name,sourceplayername,duree,reason,permanent)
						lastduree  = ""
						lasttarget = ""
					else
						local permanent = 1
						ban(source,data[1].identifier,data[1].license,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,name,sourceplayername,duree,reason,permanent)
						lastduree  = ""
						lasttarget = ""
					end
				else
					TriggerEvent('bansql:sendMessage', source, _U('invalid_id'))
				end
			end)
		else
			TriggerEvent('bansql:sendMessage', source, _U('invalid_time'))
		end	
	else
		TriggerEvent('bansql:sendMessage', source, _U('invalid_id'))
	end
end)

-- console / rcon can also utilize es:command events, but breaks since the source isn't a connected player, ending up in error messages
AddEventHandler('bansql:sendMessage', function(source, message)
	if source ~= 0 and source ~= nil then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist', message } } )
	else
		print('SqlBan: ' .. message)
	end
end)

function sendToDiscord (canal, name, message, color)
  -- Modify here your discordWebHook username = name, content = message,embeds = embeds
local DiscordWebHook = canal
local embeds = {
    {
        ["title"]= message,
        ["type"]= "rich",
        ["color"] = color,
        ["footer"]=  {
        ["text"]= "BanSql_logs",
       },
    }
}

  if message == nil or message == '' then return FALSE end
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function ban(source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)

	local expiration = duree * 86400
	local timeat     = os.time()
	local message
	
	if expiration < os.time() then
		expiration = os.time()+expiration
	end
	
		table.insert(BanList, {
			identifier = identifier,
			license    = license,
			liveid     = liveid,
			xblid      = xblid,
			discord    = discord,
			playerip   = playerip,
			reason     = reason,
			expiration = expiration,
			permanent  = permanent
          })




		MySQL.Async.execute(
                'INSERT INTO banlist (identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@license']          = license,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = os.time(),
				['@permanent']        = permanent,
				},
				function ()
		end)

		if permanent == 0 then
			TriggerEvent('bansql:sendMessage', source, (targetplayername .. _U('banned_for') .. duree .. _U('days_for') .. reason))
			message = (targetplayername .. identifier .." | ".. license .." | ".. liveid .." | ".. xblid .." | ".. discord .." | ".. playerip .." " .. _U('banned_for') .. duree .. _U('days_for') .. reason.." ".. _U('by') .." ".. sourceplayername)
		else
			TriggerEvent('bansql:sendMessage', source, (targetplayername .. _U('permabanned_for') .. reason))
			message = (targetplayername .. identifier .. " | " .. license .. " | " .. liveid .. " | " .. xblid .. " | " .. discord .. " | " .. playerip .." " .. _U('permabanned_for') .. reason .. " " .. _U('by') .. " " .. sourceplayername)
		end
		if Config.EnableDiscordLink then
			sendToDiscord(Config.webhookban, "BanSql", message, Config.red)
		end

		MySQL.Async.execute(
                'INSERT INTO banlisthistory (identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@license']          = license,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = os.time(),
				['@permanent']        = permanent,
				},
				function ()
		end)
		
		BanListHistoryLoad = false
end

function loadBanList()
  MySQL.Async.fetchAll(
    'SELECT * FROM banlist',
    {},
    function (data)
      BanList = {}

      for i=1, #data, 1 do
        table.insert(BanList, {
			identifier = data[i].identifier,
			license    = data[i].license,
			liveid     = data[i].liveid,
			xblid      = data[i].xblid,
			discord    = data[i].discord,
			playerip   = data[i].playerip,
			reason     = data[i].reason,
			expiration = data[i].expiration,
			permanent  = data[i].permanent
          })
      end
    end
  )
end

function loadBanListHistory()
  MySQL.Async.fetchAll(
    'SELECT * FROM banlisthistory',
    {},
    function (data)
      BanListHistory = {}

      for i=1, #data, 1 do
        table.insert(BanListHistory, {
			identifier       = data[i].identifier,
			license          = data[i].license,
			liveid           = data[i].liveid,
			xblid            = data[i].xblid,
			discord          = data[i].discord,
			playerip         = data[i].playerip,
			targetplayername = data[i].targetplayername,
			sourceplayername = data[i].sourceplayername,
			reason           = data[i].reason,
			expiration       = data[i].expiration,
			permanent        = data[i].permanent,
			timeat           = data[i].timeat
          })
      end
    end
  )
end


function deletebanned(identifier) 

MySQL.Async.execute(
            'DELETE FROM banlist WHERE identifier=@identifier',
            {
              ['@identifier']  = identifier
            },
                function ()
                loadBanList()
            end)
end



AddEventHandler('playerConnecting', function (playerName,setKickReason)
	local steamID  = "empty"
	local license  = "empty"
	local liveid   = "empty"
	local xblid    = "empty"
	local discord  = "empty"
	local playerip = "empty"

	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end

	--Si Banlist pas chargée
	if (Banlist == {}) then
		Citizen.Wait(1000)
	end

    if steamID == false then
		setKickReason(_U('invalid_steam'))
		CancelEvent()
    end

	for i = 1, #BanList, 1 do
		if 
			((tostring(BanList[i].identifier)) == tostring(steamID) 
			or (tostring(BanList[i].license)) == tostring(license) 
			or (tostring(BanList[i].liveid)) == tostring(liveid) 
			or (tostring(BanList[i].xblid)) == tostring(xblid) 
			or (tostring(BanList[i].discord)) == tostring(discord)) 
		then

			if (tonumber(BanList[i].permanent)) == 1 then

				setKickReason(_U('you_have_been_permabanned') .. BanList[i].reason)
				CancelEvent()
				break

			elseif (tonumber(BanList[i].expiration)) > os.time() then

				local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(_U('you_have_been_banned') .. BanList[i].reason .. _U('time_left') .. txtday .. _U('days') ..txthrs .. _U('hours') ..txtminutes .. _U('minutes'))
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(_U('you_have_been_banned') .. BanList[i].reason .. _U('time_left') .. txtday .. _U('days') .. txthrs .. _U('hours') .. txtminutes .. _U('minutes'))
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason(_U('you_have_been_banned') .. BanList[i].reason .. _U('time_left') .. txtday .. _U('days') .. txthrs .. _U('hours') .. txtminutes .. _U('minutes'))
						CancelEvent()
						break
				end

			elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

				deletebanned(steamID)
				break

			end
		end

	end

end)

AddEventHandler('es:playerLoaded',function(source)
  CreateThread(function()
  Wait(5000)
	local steamID  = "no info"
	local license  = "no info"
	local liveid   = "no info"
	local xblid    = "no info"
	local discord  = "no info"
	local playerip = "no info"
	local playername = GetPlayerName(source)

	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end

		MySQL.Async.fetchAll('SELECT * FROM `baninfo` WHERE `identifier` = @identifier', {
			['@identifier'] = steamID
		}, function(data)
		local found = false
			for i=1, #data, 1 do
				if data[i].identifier == steamID then
					found = true
				end
			end
			if not found then
				MySQL.Async.execute('INSERT INTO baninfo (identifier,license,liveid,xblid,discord,playerip,playername) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@playername)', 
					{ 
					['@identifier'] = steamID,
					['@license']    = license,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername
					},
					function ()
				end)
			else
				MySQL.Async.execute('UPDATE `baninfo` SET `license` = @license, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername WHERE `identifier` = @identifier', 
					{ 
					['@identifier'] = steamID,
					['@license']    = license,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playerip']   = playerip,
					['@playername'] = playername
					},
					function ()
				end)
			end
		end)
  end)
end)

function DajMiPotrebno(ime)
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE name = @imee", {['@imee'] = ime})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			license = identity['license']
		}
	else
		return nil
	end
end

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group']
		}
	else
		return nil
	end
end

function inArray(value, array)
	for _,v in pairs(array) do
		if v == value then
			return true
		end
	end
	return false
end

CreateThread(function()
	while true do
		Wait(1000)
		if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				print(_U('banlist_loaded'))
				BanListLoad = true
			else
				print(_U('banlist_starterror'))
			end
		end
		if BanListHistoryLoad == false then
			loadBanListHistory()
			if BanListHistory ~= {} then
				print(_U('banhistory_loaded'))
				BanListHistoryLoad = true
			else
				print(_U('banlist_starterror'))
			end
		end
	end
end)
ProvjeraResursa()