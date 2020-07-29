-------------------------------------------------------------------- CREATE PEDS -------------------------------------------------------------------
--PEDS--
--http://ragepluginhook.net/PedModels.aspx--

-- Some Shop & Interior NPCs
Citizen.CreateThread(function()
	local model = GetHashKey("a_m_y_business_03")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableShops then
		for _, item in pairs(Config.Locations1) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			SetEntityHeading(npc, item.heading)
			FreezeEntityPosition(npc, true)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-----------------------------------------------------------------NIGHTCLUB---------------------------------------------------------------------------
--Unicorn
Citizen.CreateThread(function()
	local model = GetHashKey("a_f_y_topless_01")
		
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(10)
	end

	if Config.EnableStripclub then
		for _, item in pairs(Config.Locations24) do
			local npc = CreatePed(1, "a_f_y_topless_01", item.x, item.y, item.z, item.heading, false, true)
			local npc2 = CreatePed(1, "a_f_y_topless_01", item.x, item.y, item.z, item.heading, false, true)
			local ad = "mini@strip_club@lap_dance_2g@ld_2g_p1"
			RequestAnimDict(ad)
			while not HasAnimDictLoaded(ad) do
				Citizen.Wait(1000)
			end
			local netScene = CreateSynchronizedScene(item.x, item.y, item.z, vec3(0.0, 0.0, 0.0), 2)
			TaskSynchronizedScene(npc, netScene, ad, "ld_2g_p1_s1", 1.0, -4.0, 261, 0, 0)
			TaskSynchronizedScene(npc2, netScene, ad, "ld_2g_p1_s2", 1.0, -4.0, 261, 0, 0)
			FreezeEntityPosition(npc, true)	
			FreezeEntityPosition(npc2, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityHeading(npc2, item.heading)
			SetEntityInvincible(npc, true)
			SetEntityInvincible(npc2, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			SetBlockingOfNonTemporaryEvents(npc2, true)
			SetSynchronizedSceneLooped(netScene, 1)
			SetModelAsNoLongerNeeded(model)
		end
	end
end)
-- Nightclub Girls1
Citizen.CreateThread(function()
	local model = GetHashKey("a_f_y_juggalo_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations2) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("mini@strip_club@idles@stripper")
			while not HasAnimDictLoaded("mini@strip_club@idles@stripper") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)	
			TaskPlayAnim(npc,"mini@strip_club@idles@stripper","stripper_idle_01",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
			--TaskPlayAnim(ped, animDictionary, animationName, speed, speedMultiplier, duration, flag, playbackRate, lockX, lockY, lockZ)--
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Girls Cheering
Citizen.CreateThread(function()
	local model = GetHashKey("a_f_y_beach_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations3) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@nightclub@peds@","amb_world_human_cheering_female_c",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Girls Partying
Citizen.CreateThread(function()
	local model = GetHashKey("a_f_y_bevhills_04")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations4) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while (not HasAnimDictLoaded("anim@amb@nightclub@peds@")) do			
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
            TaskPlayAnim(npc,"anim@amb@nightclub@peds@","amb_world_human_partying_female_partying_beer_base",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)	
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Girls Slow
Citizen.CreateThread(function()
	local model = GetHashKey("a_f_y_genhot_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations5) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@nightclub@peds@","mini_strip_club_private_dance_idle_priv_dance_idle",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Girls Tops
Citizen.CreateThread(function()
	local model = GetHashKey("a_f_m_beach_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations6) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@nightclub@peds@","mini_strip_club_lap_dance_ld_girl_a_song_a_p1",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Mens1
Citizen.CreateThread(function()
	local model = GetHashKey("ig_claypain")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations7) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)	
			TaskPlayAnim(npc,"anim@amb@nightclub@peds@","amb_world_human_partying_male_partying_beer_base",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Mens2
Citizen.CreateThread(function()
	local model = GetHashKey("ig_ramp_mex")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations8) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)	
			TaskPlayAnim(npc,"anim@amb@nightclub@peds@","amb_world_human_drinking_beer_male_base",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Mens3
Citizen.CreateThread(function()
	local model = GetHashKey("u_m_y_babyd")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations9) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@nightclub@peds@","amb_world_human_hang_out_street_male_c_base",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Bartender
Citizen.CreateThread(function()
	local model = GetHashKey("s_f_y_bartender_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations10) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			SetPedCanPlayAmbientAnims(npc, true)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Guards
Citizen.CreateThread(function()
	local model = GetHashKey("s_m_m_chemsec_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableNightclubs then
		for _, item in pairs(Config.Locations11) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@nightclub@peds@","amb_world_human_stand_guard_male_base",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Solomun
Citizen.CreateThread(function()
	local model = GetHashKey("CSB_Sol")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableSolomun then
		for _, item in pairs(Config.Locations12) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@djs@solomun@")
			while not HasAnimDictLoaded("anim@amb@nightclub@djs@solomun@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@nightclub@djs@solomun@","sol_dance_a_sol",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Nightclub Dixon
Citizen.CreateThread(function()
	local model = GetHashKey("CSB_Dix")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableDixon then
		for _, item in pairs(Config.Locations13) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@djs@solomun@")
			while not HasAnimDictLoaded("anim@amb@nightclub@djs@solomun@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)	
			TaskPlayAnim(npc,"anim@amb@nightclub@djs@solomun@","sol_dance_a_sol",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-----------------------------------------------------------------NIGHTCLUBEND------------------------------------------------------------------------

-- Biker Guards2 (Druglabors & Points, Biker DLC)
Citizen.CreateThread(function()
	local model = GetHashKey("s_m_m_chemsec_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableDrugs then
		for _, item in pairs(Config.Locations14) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)	
			TaskPlayAnim(npc,"anim@amb@nightclub@peds@","amb_world_human_stand_guard_male_base",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Biker NPC1 MethCook
Citizen.CreateThread(function()
	local model = GetHashKey("g_m_m_chemwork_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableDrugs then
		for _, item in pairs(Config.Locations15) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@business@meth@meth_monitoring_cooking@cooking@")
			while not HasAnimDictLoaded("anim@amb@business@meth@meth_monitoring_cooking@cooking@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@business@meth@meth_monitoring_cooking@cooking@","look_around_v8_cooker",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Biker NPC2 Meth Worker
Citizen.CreateThread(function()
	local model = GetHashKey("g_m_m_chemwork_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableDrugs then
		for _, item in pairs(Config.Locations16) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@business@meth@meth_monitoring_cooking@monitoring@")
			while not HasAnimDictLoaded("anim@amb@business@meth@meth_monitoring_cooking@monitoring@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@business@meth@meth_monitoring_cooking@monitoring@","check_guages_monitor",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Biker NPC3 Coca & Opium Worker
Citizen.CreateThread(function()
	local model = GetHashKey("g_m_m_chemwork_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableDrugs then
		for _, item in pairs(Config.Locations17) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@business@meth@meth_monitoring_cooking@monitoring@")
			while not HasAnimDictLoaded("anim@amb@business@meth@meth_monitoring_cooking@monitoring@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)	
			TaskPlayAnim(npc,"anim@amb@business@meth@meth_monitoring_cooking@monitoring@","check_guages_v1_monitor",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)

-- Biker NPC4 Weed Worker
Citizen.CreateThread(function()
	local model = GetHashKey("a_m_m_farmer_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	
	if Config.EnableDrugs then
		for _, item in pairs(Config.Locations18) do
			local npc = CreatePed(4, model, item.x, item.y, item.z, item.heading, false, true)
			
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
			while not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@") do
			Citizen.Wait(1000)
			end
				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@business@weed@weed_inspecting_lo_med_hi@","weed_stand_checkingleaves_kneeling_01_inspector",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
	end
	SetModelAsNoLongerNeeded(model)
end)