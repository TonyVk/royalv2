local Keys = {["E"] = 38, ["SPACE"] = 22, ["DELETE"] = 178}
local canExercise = false
local exercising = false
local procent = 0
local motionProcent = 0
local doingMotion = false
local motionTimesDone = 0

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local coords = GetEntityCoords(PlayerPedId())
            for i, v in pairs(Config.Locations) do
                local pos = Config.Locations[i]
                local dist = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"] + 0.98, coords, true)
                if dist <= 1.5 and not exercising then
                    sleep = 5
                    DrawText3D(pos["x"], pos["y"], pos["z"] + 0.98, "[E] " .. pos["exercise"])
                    if IsControlJustPressed(0, Keys["E"]) then
						TriggerServerEvent("esx_gym:SpucajRouting", true)
                        startExercise(Config.Exercises[pos["exercise"]], pos, pos["exercise"])
                    end
                    else if dist <= 3.0 and not exercising then
                        sleep = 8
                        DrawText3D(pos["x"], pos["y"], pos["z"] + 0.98, pos["exercise"])
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)

function startExercise(animInfo, pos, ime)
    local playerPed = PlayerPedId()

    LoadDict(animInfo["idleDict"])
    LoadDict(animInfo["enterDict"])
    LoadDict(animInfo["exitDict"])
    LoadDict(animInfo["actionDict"])

    if pos["h"] ~= nil then
        SetEntityCoords(playerPed, pos["x"], pos["y"], pos["z"])
        SetEntityHeading(playerPed, pos["h"])
    end

    TaskPlayAnim(playerPed, animInfo["enterDict"], animInfo["enterAnim"], 8.0, -8.0, animInfo["enterTime"], 0, 0.0, 0, 0, 0)
    Citizen.Wait(animInfo["enterTime"])
    canExercise = true
    exercising = true
	
	local prop
	if ime == "Dizanje utega" then
		local model = GetHashKey("prop_curl_bar_01")
		RequestModel(model)
		
		while not HasModelLoaded(model) do
			Wait(1)
		end
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		prop = CreateObject(model, x, y, z + 0.2, true, true, true)
		local boneIndex = GetPedBoneIndex(playerPed, 18905)
		AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, -0.138, 0.281, 50.0, 90.0, 25.0, true, true, false, true, 1, true)
	end

    Citizen.CreateThread(function()
        while exercising do
            Citizen.Wait(1)
            if procent <= 24.99 then
                color = "~r~"
            elseif procent <= 49.99 then
                color = "~o~"
            elseif procent <= 74.99 then
                color = "~b~"
            elseif procent <= 100 then
                color = "~g~"
            end
            DrawText2D(0.505, 0.925, 1.0,1.0,0.33, "Postotak: " .. color..procent .. "%", 255, 255, 255, 255)
            DrawText2D(0.505, 0.95, 1.0,1.0,0.33, "Pritisci ~g~[SPACE]~w~ da treniras", 255, 255, 255, 255)
            DrawText2D(0.505, 0.975, 1.0,1.0,0.33, "Pritisni ~r~[DELETE]~w~ da prestanes trenirati", 255, 255, 255, 255)
        end
    end)

    Citizen.CreateThread(function()
        while canExercise do
            Citizen.Wait(8)
            local playerCoords = GetEntityCoords(playerPed)
            if procent <= 99 then
                TaskPlayAnim(playerPed, animInfo["idleDict"], animInfo["idleAnim"], 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
                if IsControlJustPressed(0, Keys["SPACE"]) then -- press space to train
                    canExercise = false
                    TaskPlayAnim(playerPed, animInfo["actionDict"], animInfo["actionAnim"], 8.0, -8.0, animInfo["actionTime"], 0, 0.0, 0, 0, 0)
                    AddProcent(animInfo["actionProcent"], animInfo["actionProcentTimes"], animInfo["actionTime"] - 70)
                    canExercise = true
                end
                if IsControlJustPressed(0, Keys["DELETE"]) then -- press delete to exit training
                    ExitTraining(animInfo["exitDict"], animInfo["exitAnim"], animInfo["exitTime"])
					DetachEntity(GetPlayerPed(-1), true, false)
					DetachEntity(prop, true, false)
					DeleteObject(prop)
					DeleteEntity(prop)
					TriggerServerEvent("esx_gym:SpucajRouting", false)
                end
            else
                ExitTraining(animInfo["exitDict"], animInfo["exitAnim"], animInfo["exitTime"])
                -- Here u can put a event to update some sort of skill or something.
                -- this is when u finished your exercise
				TriggerServerEvent("esx_gym:DodajVjezbu")
				DetachEntity(GetPlayerPed(-1), true, false)
				DetachEntity(prop, true, false)
				DeleteObject(prop)
				DeleteEntity(prop)
				TriggerServerEvent("esx_gym:SpucajRouting", false)
            end
        end
    end)
end

function ExitTraining(exitDict, exitAnim, exitTime)
    TaskPlayAnim(PlayerPedId(), exitDict, exitAnim, 8.0, -8.0, exitTime, 0, 0.0, 0, 0, 0)
    Citizen.Wait(exitTime)
    canExercise = false
    exercising = false
    procent = 0
end

function AddProcent(amount, amountTimes, time)
    for i=1, amountTimes do
        Citizen.Wait(time/amountTimes)
        procent = procent + amount
    end
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end
      
function DrawText2D(x, y, width, height, scale, text, r, g, b, a, outline)
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
    for i=1, #Config.Blips, 1 do
        local Blip = Config.Blips[i]
        blip = AddBlipForCoord(Blip["x"], Blip["y"], Blip["z"])
        SetBlipSprite(blip, Blip["id"])
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Blip["scale"])
        SetBlipColour(blip, Blip["color"])
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Blip["text"])
        EndTextCommandSetBlipName(blip)
    end
end)

function Notify(msg)
    SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end
