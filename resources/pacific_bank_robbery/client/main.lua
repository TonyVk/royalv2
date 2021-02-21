--  ESX Service
ESX=nil;
local a=false;
local b=false;
local c=false;
local d=false;
local e=false;
local NeDiraj = true
cachedData={["banks"]={}}


Citizen.CreateThread(function()
	while ESX==nil do 
		TriggerEvent("esx:getSharedObject",function(f)ESX=f end)
		Citizen.Wait(0)
	end;
	ClearPedTasks(PlayerPedId())
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",function(g)
	ESX.PlayerData=g;
	ESX.TriggerServerCallback("vbanka:getCurrentRobbery",function(h)
		if h then 
			for i,j in pairs(h)do 
				cachedData["banks"][i]=j["trolleys"]
				print(i)
				RobberyThread({["bank"]=i,["trolleys"]=j["trolleys"]})
				OtvoriSef(i)
			end 
		end 
	end)
end)


RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(k)
	ESX.PlayerData["job"]=k 
end)

RegisterNetEvent("OtvoriVrataa")
AddEventHandler("OtvoriVrataa",function(g)
	OpenDoor(g)
end)

RegisterNetEvent("vbanka:eventHandler")
AddEventHandler("vbanka:eventHandler",function(l,m)
	if m ~= nil then
		if l=="start_robbery"then 
			RobberyThread(m)
		elseif l=="alarm_police"then 
			if ESX.PlayerData["job"]and ESX.PlayerData["job"]["name"]=="police" then 
				SetAudioFlag("LoadMPData",true)
				PlaySoundFrontend(-1,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
				ESX.ShowNotification("Netko pokusava ~r~hakirati ~s~sef banke - ~g~ "..m..". ~s~Lokacija vam je poslana.")
				local n=Config.Bank[m]
				SetNewWaypoint(n["start"]["pos"]["x"],n["start"]["pos"]["y"])
				local o=AddBlipForCoord(n["start"]["pos"])
				SetBlipSprite(o,161)
				SetBlipScale(o,2.0)
				SetBlipColour(o,8)
				Citizen.CreateThread(function()
					local p=GetGameTimer()
					while GetGameTimer()-p<60000*5 do 
						Citizen.Wait(0)
					end;
					RemoveBlip(o)
				end)
			end
		elseif l=="alarm_fbi"then 
			if ESX.PlayerData["job"]and ESX.PlayerData["job"]["name"]=="sipa" then 
				SetAudioFlag("LoadMPData",true)
				PlaySoundFrontend(-1,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
				ESX.ShowNotification("Netko pokusava ~r~hakirati ~s~sef banke - ~g~ "..m..". ~s~Lokacija vam je poslana.")
				local n=Config.Bank[m]
				SetNewWaypoint(n["start"]["pos"]["x"],n["start"]["pos"]["y"])
				local o=AddBlipForCoord(n["start"]["pos"])
				SetBlipSprite(o,161)
				SetBlipScale(o,2.0)
				SetBlipColour(o,8)
				Citizen.CreateThread(function()
					local p=GetGameTimer()
					while GetGameTimer()-p<60000*5 do 
						Citizen.Wait(0)
					end;
					RemoveBlip(o)
				end)
			end
		end 
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do 
		local q=500;
		local r=PlayerPedId()
		local s=GetEntityCoords(r)
		for i,t in pairs(Config.Bank)do 
			local u=GetDistanceBetweenCoords(s,t["prva"]["pos"],true)
			if u<=5.0 then 
				q=5;
				if u<=1.0 then 
					local v,w=not cachedData["banks"][i],cachedData["hacking2"]and"~r~Hakiranje..."or cachedData["banks"][i]and"~r~Napad~s~ u tijeku . . ."or"~INPUT_CONTEXT~ Pocnite ~r~hakirati~s~ u uredjaj."
					if cachedData["hacking2"] == false or cachedData["hacking2"] == nil then
						ESX.ShowHelpNotification(w)
					end
					if IsControlJustPressed(0,38)then
						if v then 
							if ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"]~="police" and ESX.PlayerData["job"]["name"]~="sipa" then 
								cachedData["hacking2"] = true
								cachedData["bankica"] = t
								TryHackingDevice2(i)
								--TriggerEvent("mhacking:show")
								--TriggerEvent("mhacking:start",Config.PhoneHackDifficulty,Config.PhoneHackTime,phonehack)
							end
						end
					end
				end;
				DrawScriptMarker({["type"]=6,["pos"]=t["prva"]["pos"]-vector3(0.0,0.0,0.985),["r"]=255,["g"]=0,["b"]=0})
			end
		end;
		Citizen.Wait(q)
	end 
end)


Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do 
		local q=500;
		local r=PlayerPedId()
		local s=GetEntityCoords(r)
		for i,t in pairs(Config.Bank)do 
			local u=GetDistanceBetweenCoords(s,t["start"]["pos"],true)
			if u<=5.0 then 
				q=5;
				if u<=1.0 then 
					local v,w=not cachedData["banks"][i],cachedData["hacking"]and"~r~Hakiranje..."or cachedData["banks"][i]and"~r~Napad~s~ u tijeku . . ."or"~INPUT_CONTEXT~ Pocnite ~r~hakirati~s~ u uredjaj."
					ESX.ShowHelpNotification(w)
					if IsControlJustPressed(0,38)then 
						if Config.PhoneHack then 
							TriggerEvent("mhacking:show")
							TriggerEvent("mhacking:start",Config.PhoneHackDifficulty,Config.PhoneHackTime,phonehack)
							while not hacked or not failed do 
								Citizen.Wait(500)
							end;
							if v and hacked then 
								TryHackingDevice(i)
							end;
							hacked=false 
						else
							if v then 
								TryHackingDevice(i)
							end 
						end
					end
				end;
				DrawScriptMarker({["type"]=6,["pos"]=t["start"]["pos"]-vector3(0.0,0.0,0.985),["r"]=255,["g"]=0,["b"]=0})
			end
		end;
		Citizen.Wait(q)
	end 
end)


function phonehack(x,y)
	TriggerEvent('mhacking:hide')
	local f=Config.Bank[cachedData["bank"]]
	local i=GetClosestObjectOfType(f["prva"]["pos"],5.0,f["device"]["model"],false)
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
		print('Success with '..y..'s remaining.')
		--TriggerEvent('mhacking:hide')
		TriggerEvent('Otkljucaj')
		cachedData["hacking2"] = false
	else 
		print('Failure')
		--TriggerEvent('mhacking:hide')
		GlobalFunction("alarm_police", cachedData["bankica"])
		GlobalFunction("alarm_fbi", cachedData["bankica"])
		ESX.ShowNotification("Policija je obavijestena")
		cachedData["bankica"] = nil
		cachedData["hacking2"] = false
		cachedData={["banks"]={}}
	end 
end;


RegisterNetEvent("vbanka:estefade_az_item")
AddEventHandler("vbanka:estefade_az_item",function(z)
	thermite()
end)

RegisterNetEvent("ZatvoriVrata")
AddEventHandler("ZatvoriVrata",function(z)
	cachedData={["banks"]={}}
	CloseDoor(z)
	TriggerEvent("Zakljucaj")
end)

local A=0;
RegisterNetEvent("vbanka:terkidan")
AddEventHandler("vbanka:terkidan",function(B,C)
	A=C;
	terkidan(B)
end)


RegisterNetEvent('vbanka:bazshodan')
AddEventHandler('vbanka:bazshodan',function(D,E,F,G,H)
	local I={D,E,F}
	local J=nil;
	if G==961976194 then 
		doorname='v_ilev_bk_vaultdoor'
		J=H;
		princoordsg=I;
		prinrotationg=J;
		prinDoortypeg=doorname;
		a=true 
	end;
	if G==4072696575 then 
		doorname='hei_v_ilev_bk_gate_pris'
		J=H;
		princoords1=I;
		prinrotation1=J;
		prinDoortype1=doorname;
		b=true 
	end;
	if G==746855201 then 
		doorname='hei_v_ilev_bk_gate2_pris'
		J=H;
		princoords2=I;
		prinrotation2=J;
		prinDoortype2=doorname;
		c=true 
	end;
	if G==1655182495 then 
		doorname='v_ilev_bk_safegate'
		J=H;
		princoords3=I;
		prinrotation3=J;
		prinDoortype3=doorname;
		d=true 
	end;
	if G==2786611474 then
		doorname='hei_v_ilev_bk_safegate_pris'
		J=H;
		princoords4=I;
		prinrotation4=J;
		prinDoortype4=doorname;
		e=true 
	end;
	TriggerEvent('Otkljucaj')
end)