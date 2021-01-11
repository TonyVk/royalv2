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

local PlayerData							= {}
local IsRobberyStarted				= false
local isRobberyDone 					= false
local isInRobberyZone					= false
local HasAlreadyEnteredMarker	= false
local LastZone								= nil
local CurrentAction						= nil
local CurrentActionMsg				= ''
local CurrentActionData				= {}

local copsConnected = 0
local blipRobbery 	= nil
local loopAlarm			= false
local isPedArmed		= false
local BlipIgraca = nil
local Hakira = {}
local cachedData = {}
local Banka = nil
local Traje = {}
local KrenilaPljacka = {}
local Mafije = {}

ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	for i,t in pairs(Config.Zones)do
		if Config.Zones[i].Hack ~= nil then
			ResetDoor(i)
		end
	end
	ESX.TriggerServerCallback('mafije:DohvatiMafijev2', function(mafija)
		Mafije = mafija
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('TrajePljackaa')
AddEventHandler('TrajePljackaa', function(zona, br)
	KrenilaPljacka[zona] = br
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do 
		local q=500;
		local r=PlayerPedId()
		local s=GetEntityCoords(r)
		for i,t in pairs(Config.Zones)do 
				if t.Hack ~= nil then
					local u=GetDistanceBetweenCoords(s,t.Hack,true)
					if u<=5.0 then 
						q=5;
						if u<=1.0 then 
							if Hakira[i] == false or Hakira[i] == nil then
								ESX.ShowHelpNotification("~INPUT_CONTEXT~ Pocnite ~r~hakirati~s~ u uredjaj.")
							end
							if IsControlJustPressed(0,38)then
								local naso = 0
								for a=1, #Mafije, 1 do
									if Mafije[a] ~= nil and Mafije[a].Ime == PlayerData.job.name then
										naso = 1
										break
									end
								end
								if naso == 1 then
									if Hakira[i] == false or Hakira[i] == nil then 
										if PlayerData.job and PlayerData.job.name ~="police" and PlayerData.job.name ~="sipa" then
											Hakira[i] = true
											TriggerServerEvent("esx_pljacke:Hakiro", i, true)
											TryHackingDevice3(i)
											--TriggerEvent("mhacking:show")
											--TriggerEvent("mhacking:start",Config.PhoneHackDifficulty,Config.PhoneHackTime,phonehack)
										end
									end
								else
									ESX.ShowNotification("Niste u mafiji!")
								end
							end
						end;
						if t.Hack ~= nil then
							DrawScriptMarker({["type"]=6,["pos"]=t.Hack-vector3(0.0,0.0,0.985),["r"]=255,["g"]=0,["b"]=0})
						end
					end
				end
		end;
		Citizen.Wait(q)
	end 
end)

LoadModels=function(a2)
	for L,a3 in ipairs(a2)do 
		if IsModelValid(a3)then 
			while not HasModelLoaded(a3)do 
				RequestModel(a3)
				Citizen.Wait(10)
			end 
		else 
			while not HasAnimDictLoaded(a3)do
				RequestAnimDict(a3)
				Citizen.Wait(10)
			end 
		end 
	end 
end;

DrawScriptMarker=function(U)
	DrawMarker(U["type"]or 1,U["pos"]or vector3(0.0,0.0,0.0),0.0,0.0,0.0,U["type"]==6 and-90.0 or U["rotate"]and-180.0 or 0.0,0.0,0.0,U["sizeX"]or 1.0,U["sizeY"]or 1.0,U["sizeZ"]or 1.0,U["r"]or 1.0,U["g"]or 1.0,U["b"]or 1.0,100,false,true,2,false,false,false,false)
end;

TryHackingDevice3=function(d)
	ESX.TriggerServerCallback("BrojPolicajacaDuznost",function(e)
		local f=Config.Zones[d]
		if e >= f.PoliceRequired then
			ESX.TriggerServerCallback("banke:JelImasLaptop",function(a)
				if a then
					StartHackingDevice3(d)
				else
					ESX.ShowNotification("Nemate laptop!")
					Hakira[d] = false
				end
			end)
		else 
			ESX.ShowNotification("Nema dovoljno policije.")
			Hakira[d] = false
		end 
	end)
end;
	
	
StartHackingDevice3=function(d)
	Citizen.CreateThread(function()
		local f=Config.Zones[d]
		Banka = d
		local i=GetClosestObjectOfType(f.Hack,5.0,-160937700,false)
		if not DoesEntityExist(i)then return end;
		SetCurrentPedWeapon(PlayerPedId(),GetHashKey("WEAPON_UNARMED"),true)
		LoadModels({GetHashKey("hei_p_m_bag_var22_arm_s"),GetHashKey("hei_prop_hst_laptop"),GetHashKey("hei_prop_heist_card_hack"),"anim@heists@ornate_bank@hack_heels"})
		cachedData["bag"]=CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"),f.Hack-vector3(0.0,0.0,5.0),true,false,false)
		cachedData["laptop"]=CreateObject(GetHashKey("hei_prop_hst_laptop"),f.Hack-vector3(0.0,0.0,3.0),true,false,false)
		cachedData["card"]=CreateObject(GetHashKey("hei_prop_heist_card_hack"),f.Hack-vector3(0.0,0.0,5.0),true,false,false)
		SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
		SetModelAsNoLongerNeeded(GetHashKey("hei_prop_hst_laptop"))
		SetModelAsNoLongerNeeded(GetHashKey("hei_prop_heist_card_hack"))
		local j=GetOffsetFromEntityInWorldCoords(i,0.1,0.8,0.4)
		local k=GetAnimInitialOffsetPosition("anim@heists@ornate_bank@hack_heels","hack_enter",j,0.0,0.0,GetEntityHeading(i),0,2)
		local l=vector3(k["x"],k["y"]-0.03,k["z"]+0.05)
		ToggleBag(false)
		cachedData["scene"]=NetworkCreateSynchronisedScene(l,0.0,0.0,GetEntityHeading(i),2,false,false,1065353216,0,1.3)
		NetworkAddPedToSynchronisedScene(PlayerPedId(),cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_enter",1.5,-4.0,1,16,1148846080,0)
		NetworkAddEntityToSynchronisedScene(cachedData["card"],cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_enter_card",4.0,-8.0,1)
		NetworkAddEntityToSynchronisedScene(cachedData["bag"],cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_enter_suit_bag",4.0,-8.0,1)
		NetworkAddEntityToSynchronisedScene(cachedData["laptop"],cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_enter_laptop",4.0,-8.0,1)
		NetworkStartSynchronisedScene(cachedData["scene"])
		Citizen.Wait(6000)
		cachedData["scene"]=NetworkCreateSynchronisedScene(l,0.0,0.0,GetEntityHeading(i),2,false,true,1065353216,0,1.3)
		NetworkAddPedToSynchronisedScene(PlayerPedId(),cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_loop",1.5,-4.0,1,16,1148846080,0)
		NetworkAddEntityToSynchronisedScene(cachedData["card"],cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_loop_card",4.0,-8.0,1)
		NetworkAddEntityToSynchronisedScene(cachedData["bag"],cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_loop_suit_bag",4.0,-8.0,1)
		NetworkAddEntityToSynchronisedScene(cachedData["laptop"],cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_loop_laptop",4.0,-8.0,1)
		NetworkStartSynchronisedScene(cachedData["scene"])
		--TriggerEvent("mhacking:show")
		--TriggerEvent("mhacking:start",Config.PhoneHackDifficulty,Config.PhoneHackTime,phonehack)
		TriggerEvent("utk_fingerprint:Start", 4, 2, 2, function(outcome, reason)
			if outcome == true then
				phonehack(true, 5)
			else
				phonehack(false, 5)
			end
		end)
	end)
end;

ToggleBag=function(N)
	TriggerEvent("skinchanger:getSkin",function(O)
		if O.sex==0 then 
			local P={["bags_1"]=0,["bags_2"]=0}
			if N then 
				P={["bags_1"]=45,["bags_2"]=0}
			end;
			TriggerEvent("skinchanger:loadClothes",O,P)
		else 
			local P={["bags_1"]=0,["bags_2"]=0}
			TriggerEvent("skinchanger:loadClothes",O,P)
		end 
	end)
end;

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",function(g)
	ESX.TriggerServerCallback("JelTrajePljacka",function(h)
		if h ~= false then 
			KrenilaPljacka[h[1]] = h[2]
			OpenDoor(h[1])
		end 
	end)
	ESX.TriggerServerCallback('mafije:DohvatiMafijev2', function(mafija)
		Mafije = mafija
	end)
end)

function phonehack(x,y)
	--TriggerEvent('mhacking:hide')
	local f=Config.Zones[Banka]
	local i=GetClosestObjectOfType(f.Hack,5.0,-160937700,false)
	if not DoesEntityExist(i)then return end;
	local j=GetOffsetFromEntityInWorldCoords(i,0.1,0.8,0.4)
	local k=GetAnimInitialOffsetPosition("anim@heists@ornate_bank@hack_heels","hack_enter",j,0.0,0.0,GetEntityHeading(i),0,2)
	local l=vector3(k["x"],k["y"]-0.03,k["z"]+0.05)
	cachedData["scene"]=NetworkCreateSynchronisedScene(l,0.0,0.0,GetEntityHeading(i),2,false,false,1065353216,0,1.3)
	NetworkAddPedToSynchronisedScene(PlayerPedId(),cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_exit",1.5,-4.0,1,16,1148846080,0)
	NetworkAddEntityToSynchronisedScene(cachedData["card"],cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_exit_card",4.0,-8.0,1)
	NetworkAddEntityToSynchronisedScene(cachedData["bag"],cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_exit_suit_bag",4.0,-8.0,1)
	NetworkAddEntityToSynchronisedScene(cachedData["laptop"],cachedData["scene"],"anim@heists@ornate_bank@hack_heels","hack_exit_laptop",4.0,-8.0,1)
	NetworkStartSynchronisedScene(cachedData["scene"])
	Citizen.Wait(4500)
	ToggleBag(true)
	DeleteObject(cachedData["bag"])
	DeleteObject(cachedData["card"])
	DeleteObject(cachedData["laptop"])
	if x then 
		OpenDoor(Banka)
		Hakira[Banka] = false
		TriggerServerEvent("esx_pljacke:Hakiro", Banka, false)
	else 
		Hakira[Banka] = false
		TriggerServerEvent("esx_pljacke:Hakiro", Banka, false)
	end 
end;

RegisterNetEvent("VratiVrata")
AddEventHandler("VratiVrata", function(id)
	ResetDoor(id)
end)

function ResetDoor(bankId)
    local Bank = Config.Zones[bankId]
	if Bank['Bank_Vault'] ~= nil then
		local door = GetClosestObjectOfType(Bank['Bank_Vault']['x'], Bank['Bank_Vault']['y'], Bank['Bank_Vault']['z'], 3.0, Bank['Bank_Vault']['model'])
		SetEntityRotation(door, 0.0, 0.0, Bank["Bank_Vault"]["hStart"], 0.0)
	end
end

function OpenDoor(bankId)
	local Bank = Config.Zones[bankId]
	if Bank['Bank_Vault'] ~= nil then
		ResetDoor(bankId)

		local door = GetClosestObjectOfType(Bank['Bank_Vault']['x'], Bank['Bank_Vault']['y'], Bank['Bank_Vault']['z'], 5.0, Bank['Bank_Vault']['model'])
		local rotation = GetEntityRotation(door)["z"]
		RequestScriptAudioBank("vault_door",false)
		while not HasAnimDictLoaded("anim@heists@fleeca_bank@bank_vault_door")do 
			Citizen.Wait(0)
			RequestAnimDict("anim@heists@fleeca_bank@bank_vault_door")
		end;
		local NeDiraj = true
		Citizen.CreateThread(function()
			FreezeEntityPosition(door, false)
			if Bank["Bank_Vault"]["hEnd"] < 0 then
				while rotation >= Bank["Bank_Vault"]["hEnd"] do
					Citizen.Wait(1)

					rotation = rotation - 0.25

					SetEntityRotation(door, 0.0, 0.0, rotation)
				end
			else
				while rotation <= Bank["Bank_Vault"]["hEnd"] do
					Citizen.Wait(1)

					rotation = rotation + 0.25

					SetEntityRotation(door, 0.0, 0.0, rotation)
				end
			end
			NeDiraj = false
			FreezeEntityPosition(door, true)
		end)
		PlaySoundFromCoord(-1,"vault_unlock",Bank['Bank_Vault']['x'], Bank['Bank_Vault']['y'], Bank['Bank_Vault']['z'],"dlc_heist_fleeca_bank_door_sounds",0,0,0)
		Citizen.CreateThread(function()
			while true do  
				if KrenilaPljacka[bankId] == true and NeDiraj == false then
					local pos = vector3(Bank['Bank_Vault']['x'], Bank['Bank_Vault']['y'], Bank['Bank_Vault']['z'])
					local K = GetClosestObjectOfType(Bank['Bank_Vault']['x'], Bank['Bank_Vault']['y'], Bank['Bank_Vault']['z'], 3.0, Bank['Bank_Vault']['model'])
					SetEntityRotation(K, 0.0, 0.0, Bank["Bank_Vault"]["hEnd"])
					FreezeEntityPosition(K, true)
				end
				Wait(2000)
			end
		end)
	end
end

-- Enter / Exit robbery zone events
function RobberyZoneEvents(zone)
	Citizen.CreateThread(function()
		while isInRobberyZone do
			Citizen.Wait(100)

			local playerPed = PlayerPedId()
			local coords 		= GetEntityCoords(playerPed)
			local zoneTable = Config.Zones[zone]

			if GetDistanceBetweenCoords(coords, zoneTable.Pos.x, zoneTable.Pos.y, zoneTable.Pos.z, true) > zoneTable.AreaSize then
				isInRobberyZone	= false
				if not isRobberyDone then
					PlaySoundFrontend(-1, "HACKING_FAILURE", 0, 1)
					TriggerServerEvent('esx_advanced_holdup:robberyCanceled', zone, true)
					Citizen.Wait(20000)
					loopAlarm = false
				end
			end

		end
	end)
end

RegisterNetEvent('HakiraoJu')
AddEventHandler('HakiraoJu', function(bank, br)
	Hakira[bank] = br
end)

RegisterNetEvent('esx_advanced_holdup:robPoliceNotification')
AddEventHandler('esx_advanced_holdup:robPoliceNotification', function(zone)
	--PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	--Citizen.Wait(100)
	--ESX.ShowAdvancedNotification(_U('911_emergency'), _U('notif_zone_name', zone), _U('911_message_alarm'), 'CHAR_CALL911', 1)
	local playerPed = PlayerPedId()
	PedPosition = GetEntityCoords(playerPed)
	
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

	TriggerServerEvent('esx_addons_gcphone:startCall', 'police', _U('911_message_alarm'), PlayerCoords, {

	PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
	})
end)

RegisterNetEvent('PratiPljackasa')
AddEventHandler('PratiPljackasa', function(id)
	if PlayerData.job.name == 'police' or PlayerData.job.name == 'sipa' then
		local ti = 300
		local PedPosition
		Citizen.CreateThread(function()
			while ti > 0 do
			  Citizen.Wait(1000)
			  local playerIdx = GetPlayerFromServerId(tonumber(id))
			  if playerIdx ~= -1 then
				ti = ti - 1
			  else
				ti = 0
				RemoveBlip(BlipIgraca)
			  end
			end
		end)
		Citizen.CreateThread(function()
			while ti > 0 do
				if BlipIgraca ~= nil then
					RemoveBlip(BlipIgraca)
				end
				if ti ~= 1 then
					local playerIdx = GetPlayerFromServerId(tonumber(id))
					if playerIdx ~= -1 then
						local playerPed = GetPlayerPed(playerIdx)
						PedPosition = GetEntityCoords(playerPed)
						BlipIgraca = AddBlipForCoord(PedPosition.x, PedPosition.y, PedPosition.z)
						SetBlipSprite(BlipIgraca, 1)
						SetBlipColour(BlipIgraca, 49)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Pljackas")
						EndTextCommandSetBlipName(BlipIgraca)
						ESX.ShowNotification("Kamere su snimile osobu koja izgleda kao pljackas!")
					else
						ti = 0
						ESX.ShowNotification("Izgubili smo trag pljackasa!")
						if BlipIgraca ~= nil then
							RemoveBlip(BlipIgraca)
						end
					end
				end
				Citizen.Wait(10000)
			end
			ti = 0
			ESX.ShowNotification("Izgubili smo trag pljackasa!")
			if BlipIgraca ~= nil then
				RemoveBlip(BlipIgraca)
			end
		end)
	end
end)

RegisterNetEvent('esx_advanced_holdup:robCompleteNotification2')
AddEventHandler('esx_advanced_holdup:robCompleteNotification2', function()
	isRobberyDone = true
	Citizen.Wait(20000)
	loopAlarm = false
end)

RegisterNetEvent('esx_advanced_holdup:robCompleteNotification')
AddEventHandler('esx_advanced_holdup:robCompleteNotification', function()
	isRobberyDone = true
	PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
	ESX.ShowNotification(_U('robbery_complete'))
	TriggerServerEvent("pljacka:PratiGa", GetPlayerServerId(PlayerId()))
	Citizen.Wait(20000)
	loopAlarm = false
end)

RegisterNetEvent('esx_advanced_holdup:robCompleteAtNotification')
AddEventHandler('esx_advanced_holdup:robCompleteAtNotification', function(zone, complete)
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	Citizen.Wait(100)
	if complete then
		ESX.ShowAdvancedNotification(_U('911_emergency'), _U('notif_zone_name', zone), _U('911_message_complete'), 'CHAR_CALL911', 1)
	else
		ESX.ShowAdvancedNotification(_U('911_emergency'), _U('notif_zone_name', zone), _U('911_message_cancel'), 'CHAR_CALL911', 1)
	end
end)

RegisterNetEvent('esx_advanced_holdup:copsConnected')
AddEventHandler('esx_advanced_holdup:copsConnected', function(copsNumber)
	copsConnected = copsNumber
end)

RegisterNetEvent('esx_advanced_holdup:setBlip')
AddEventHandler('esx_advanced_holdup:setBlip', function(pos)
	blipRobbery = AddBlipForCoord(pos.x, pos.y, pos.z)
	SetBlipSprite(blipRobbery, 161)
	SetBlipScale(blipRobbery, 2.0)
	SetBlipColour(blipRobbery, 1)
	PulseBlip(blipRobbery)
end)

RegisterNetEvent('esx_advanced_holdup:killBlip')
AddEventHandler('esx_advanced_holdup:killBlip', function()
	RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_advanced_holdup:startRobberingTimer')
AddEventHandler('esx_advanced_holdup:startRobberingTimer', function(zone)

	isInRobberyZone = true
	isRobberyDone		= false
	loopAlarm 			= true
	RobberyZoneEvents(zone)
	TriggerEvent('esx_advanced_holdup:loopAlarmTriggered', zone)

	local timer = Config.Zones[zone].TimeToRob
  Citizen.CreateThread(function()
    while timer > 0 and isInRobberyZone do
      Citizen.Wait(1000)
      if(timer > 0)then
        timer = timer - 1
      end
    end
  end)
  Citizen.CreateThread(function()
    while timer > 0 and isInRobberyZone do
      Citizen.Wait(6)
      drawTxt(0.85, 1.4, 1.0,1.0,0.4, _U('robbery_in_progress', zone, timer), 255, 255, 255, 255)
    end
	end)

end)

RegisterNetEvent('esx_advanced_holdup:loopAlarmTriggered')
AddEventHandler('esx_advanced_holdup:loopAlarmTriggered', function(zone)
	while loopAlarm do
		PlaySoundFromCoord(-1, "scanner_alarm_os", Config.Zones[zone].Pos.x, Config.Zones[zone].Pos.y, Config.Zones[zone].Pos.z, "dlc_xm_iaa_player_facility_sounds", 1, 100, 0)
		Citizen.Wait(1000)
	end
end)

AddEventHandler('esx_advanced_holdup:hasEnteredMarker', function(zone)

	CurrentAction     = 'start_robbery'
	CurrentActionMsg  = _U('press_to_rob')
	CurrentActionData = {zone = zone}

end)

AddEventHandler('esx_advanced_holdup:hasExitedMarker', function(zone)

	CurrentAction = nil

end)

-- Display markers
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		local naso = 0
		Citizen.Wait(waitara)

		local playerPed = PlayerPedId()
		local coords 		= GetEntityCoords(playerPed)

		if isPedArmed then
			for _, v in pairs(Config.Zones) do
				if v.PoliceRequired <= copsConnected and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
					naso = 1
					waitara = 1
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)
				end
			end
		end
		if naso == 0 then
			waitara = 500
		end
	end

end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		local playerPed			= PlayerPedId()
		local coords				= GetEntityCoords(playerPed)
		local isInMarker		= false
		local isEnoughCops 	= false
		local currentZone		= nil

		if IsPedArmed(playerPed, 4) then
			isPedArmed 		= true
			local coords	= GetEntityCoords(playerPed)
			for k, v in pairs(Config.Zones) do
				if v.PoliceRequired <= copsConnected and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
					isInMarker		= true
					isEnoughCops	= true
					currentZone 	= k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker and isEnoughCops) or (isInMarker and LastZone ~= currentZone and isEnoughCops) then
				HasAlreadyEnteredMarker = true
				LastZone								= currentZone
				TriggerEvent('esx_advanced_holdup:hasEnteredMarker', currentZone)
			end
		else
			isPedArmed = false
		end

		if (not isInMarker or not isEnoughCops or not isPedArmed) and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_advanced_holdup:hasExitedMarker', LastZone)
			Citizen.Wait(500)
		end

		if not isPedArmed then
			Citizen.Wait(500)
		end

	end
end)

RegisterNetEvent('mafije:UpdateMafije')
AddEventHandler('mafije:UpdateMafije', function(maf)
	Mafije = maf
end)

RegisterNetEvent('esx_pljacke:OdradiLockPick')
AddEventHandler('esx_pljacke:OdradiLockPick', function(mainZone, tip)
	TriggerEvent("lockpick:Start", function(outcome)
		if outcome then
			TriggerServerEvent("pljacka:NastaviDalje", mainZone, tip)
		else
			ESX.ShowNotification("Niste uspjeli obiti sef.")
			local koords = GetEntityCoords(PlayerPedId())
			local PlayerCoords = { x = koords.x, y = koords.y, z = koords.z }
			TriggerServerEvent('esx_addons_gcphone:startCall', 'police', "Pokušaj obijanja sefa u trgovini", PlayerCoords, {
				PlayerCoords = { x = koords.x, y = koords.y, z = koords.z },
			})
		end
	end)
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(8)

		if CurrentAction == nil then
			Citizen.Wait(250)
		else

			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(1,  Keys['E']) and GetLastInputMethod(2) then

				local playerPed = PlayerPedId()
				if IsPedSittingInAnyVehicle(playerPed) then
					ESX.ShowNotification(_U('can_inside_vehicle'))
				else
					local zone = CurrentActionData.zone
					local tip = 0
					for k, v in pairs(Config.Zones) do
						if k == zone then
							tip = v.Tip
						end
					end
					if tip == 1 then
						TriggerServerEvent('pljacka:UTijeku', zone, tip)
					elseif tip == 2 then
						local naso = 0
						for i=1, #Mafije, 1 do
							if Mafije[i] ~= nil and Mafije[i].Ime == PlayerData.job.name then
								naso = 1
								break
							end
						end
						if naso == 1 then
							TriggerServerEvent('pljacka:UTijeku', zone, tip)
						else
							ESX.ShowNotification("Samo mafije mogu pljackat banke!")
						end
					end
				end


				CurrentAction = nil

			end

		end

	end
end)
