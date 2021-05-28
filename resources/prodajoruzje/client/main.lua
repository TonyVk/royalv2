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

local Oruzje					= nil
local Cijena 					= 0
local Prodavac					= nil
local Metci 					= 0
local GUI                       = {}
GUI.Time                        = 0

local CijenaDroge 				= 0
local Kolicina 					= 0
local Prodavac2 				= nil
local perm 						= 0

local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

ESX                             = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  while ESX.GetPlayerData().job == nil do
	Citizen.Wait(100)
  end
  ProvjeriPosao()
end)

Citizen.CreateThread(function()
  while	true do
	Citizen.Wait(3600000) --1h
	local porez = 0
	--kuca
	ESX.TriggerServerCallback('loaf_housing:ImalKucu', function(br)
		if br then
			porez = porez+1
		end
	end)
	--trgovine
	ESX.TriggerServerCallback('esx_shops:DajBrojTrgovina', function(br)
		porez = porez+br
	end)
	--Gunshopovi
	ESX.TriggerServerCallback('esx_gun:DajBrojTrgovina', function(br)
		porez = porez+br
	end)
	--Pumpe
	ESX.TriggerServerCallback('pumpe:DajBrojPumpi', function(br)
		porez = porez+br
	end)
	Citizen.Wait(2000)
	if porez > 0 then
		TriggerServerEvent("prodajoruzje:PlatiPorez", porez)
	end
  end
end)

function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
	local model = GetHashKey("a_m_m_beach_01")
    RequestModel(model)
	
    while not HasModelLoaded(model) do
        Wait(1)
    end
	local npc = CreatePed(4, model, 94.828460693359, 3756.8435058594, 39.770915985107, 160.21, false, true)
	SetModelAsNoLongerNeeded(model)
			
	SetEntityHeading(npc, 160.21)
	FreezeEntityPosition(npc, true)
	SetEntityInvincible(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true)
end

AddEventHandler("playerSpawned", function()
	SetPedComponentVariation(PlayerPedId(), 1, 0 ,0, 2)
	--StatSetInt(GetHashKey('MP0_STAMINA'), 20, true)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, 0, 0, 0, true) <= 10.0 then
		SetEntityCoords(PlayerPedId(), -825.510, -440.8749, 35.6722)
	end
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		perm = br
	end)
end)

RegisterNetEvent('es_admin:setPerm')
AddEventHandler('es_admin:setPerm', function()
	ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		perm = br
	end)
end)

--[[AddEventHandler("gameEventTriggered", function(name, data)
	print(name)
	--(targetId, playerId, nezz, jelUmro, hashOruzja, nezz(mijenja se kada se sudaris autom), nezz(mijenja se kada se sudaris autom), nezz, nezz(mijenja se kada headas peda), nezz, mijenja se ovisno o tome koji dio vozila pucas)
	print(json.encode(data))
end)]]

RegisterNetEvent('VratiTamoSkin')
AddEventHandler('VratiTamoSkin', function(pid)
	local retval = NetworkGetNetworkIdFromEntity(PlayerPedId())
	TriggerServerEvent("EoTiSkinara", retval, GetEntityModel(PlayerPedId()), pid)
end)

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

function GearAnim()
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

function DeleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        ESX.Game.DeleteObject(currentGear.mask)
		currentGear.mask = 0
    end
    
	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        ESX.Game.DeleteObject(currentGear.tank)
		currentGear.tank = 0
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
		TriggerServerEvent("minute:SpremiIh")
	end
end)

RegisterNetEvent('ronjenje:PocniRonit')
AddEventHandler('ronjenje:PocniRonit', function()
    if currentGear.enabled == false then
		GearAnim()
		DeleteGear()
		Wait(2000)
		local maskModel = GetHashKey("p_d_scuba_mask_s")
		local tankModel = GetHashKey("p_s_scuba_tank_s")
		
		RequestModel(tankModel)
		while not HasModelLoaded(tankModel) do
			Citizen.Wait(1)
		end
		TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
		local bone1 = GetPedBoneIndex(GetPlayerPed(-1), 24818)
		AttachEntityToEntity(TankObject, GetPlayerPed(-1), bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
		currentGear.tank = TankObject
		
		RequestModel(maskModel)
		while not HasModelLoaded(maskModel) do
			Citizen.Wait(1)
		end
				
		MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
		local bone2 = GetPedBoneIndex(GetPlayerPed(-1), 12844)
		AttachEntityToEntity(MaskObject, GetPlayerPed(-1), bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
		currentGear.mask = MaskObject
		
		SetEnableScuba(GetPlayerPed(-1), true)
		SetPedMaxTimeUnderwater(GetPlayerPed(-1), 2000.00)
		currentGear.enabled = true
		ClearPedTasks(GetPlayerPed(-1))
		ESX.ShowNotification("Obukli ste opremu za ronjenje!")
	else
		GearAnim()
		Wait(2000)
        DeleteGear()
        SetEnableScuba(GetPlayerPed(-1), false)
        SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
        currentGear.enabled = false
        ClearPedTasks(GetPlayerPed(-1))
		ESX.ShowNotification("Skinuli ste opremu za ronjenje!")
	end
end)

local Upaljeno = false

RegisterNetEvent('prodajoruzje:grebalica')
AddEventHandler('prodajoruzje:grebalica', function()
	SendNUIMessage({
		prikazi = true
	})
	SetNuiFocus(true, true)
	Upaljeno = true
	Citizen.CreateThread(function()
		while Upaljeno do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end
	end)
end)

RegisterNUICallback(
    "kraj",
    function(data, cb)
		SetNuiFocus(false)
		TriggerServerEvent("prodajoruzje:KoiKuracJeOvo", data.broj)
    end
)

RegisterNUICallback(
    "vratik",
    function(data, cb)
		Upaljeno = false
    end
)

RegisterNetEvent('prodajoruzje:petarde')
AddEventHandler('prodajoruzje:petarde', function()
			local modele = "prop_cs_dildo_01"
			ESX.Streaming.RequestModel(modele)
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(modele), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 57005)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 145.0, 0.0, true, true, false, true, 1, true)
			local forceTypes = {
				MinForce = 0,
				MaxForceRot = 1,
				MinForce2 = 2,
				MaxForceRot2 = 3,
				ForceNoRot = 4,
				ForceRotPlusForce = 5
			}

			local forceType = forceTypes.MaxForceRot2
			local cor = GetEntityCoords(PlayerPedId())
			local cordsa = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -8.0, 1.0 , -7.0)
			local direction = vector3(cordsa.x-cor.x, cordsa.y-cor.y, cordsa.z-cor.z)
			local rotation = vector3(0.0, 0.0, 0.0)
			RequestAnimDict("weapons@projectile@")
			while not HasAnimDictLoaded("weapons@projectile@") do
				Citizen.Wait(1000)
			end
			Wait(500)
			TaskPlayAnim(PlayerPedId(),"weapons@projectile@", "throw_m_fb_stand", 8.0, -8, -1, 2, 0, 0, 0, 0)
			Wait(400)
			ClearPedTasks(PlayerPedId())
			DetachEntity(prop, true, false)
			ApplyForceToEntity(
				prop,
				forceType,
				direction,
				rotation,
				0,
				false,
				true,
				true,
				false,
				true
			)
			Wait(3000)
			cordsa = GetEntityCoords(prop)
			AddExplosion(
				cordsa.x, 
				cordsa.y, 
				cordsa.z, 
				18, 
				0.0, 
				true, 
				false, 
				false,
				false
			)
			DeleteEntity(prop)
end)

local skupljanje = vector3(59.282123565674, -774.98114013672, 17.823108673096)
local cprerada = vector3(2433.5622558594, 4968.9677734375, 42.347618103027)
local cijev = vector3(94.248916625977, 3755.9348144531, 40.77135848999)

Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
		local playerPed = GetPlayerPed(-1)
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil
		local hasExited = false
		if CurrentAction ~= nil then
			waitara = 0
			naso = 1
	  
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then
				if CurrentAction == 'menu_prerada' then
					OpenPreradaMenu()
				elseif CurrentAction == 'menu_skupljanje' then
					TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                    local vrime = GetGameTimer()
					while GetGameTimer()-vrime < 15000 do
						Wait(1)
						DisableAllControlActions()
					end
					ClearPedTasksImmediately(playerPed)
					local kordic = GetEntityCoords(playerPed)
					if not IsEntityDead(playerPed) and #(kordic-skupljanje) <= 5.0 then
						TriggerServerEvent("kraft:SkupiGa")
						ESX.ShowNotification("Dobili ste 1x zeljeza!")
						currentStation = 1
						currentPart    = 'Skupljanje'
						currentPartNum = 1
					end
					isInMarker = false
					HasAlreadyEnteredMarker = false
				elseif CurrentAction == 'menu_cijev' then
					OpenCijevMenu()
				end
				GUI.Time = GetGameTimer()
				CurrentAction = nil
			end
		end
		local coords    = GetEntityCoords(playerPed)
		
		if #(coords-cprerada) < 100.0 then
			waitara = 0
			naso = 1
			DrawMarker(0, cprerada, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if #(coords-cprerada) < 2.5 then
			isInMarker     = true
			currentStation = 1
			currentPart    = 'Prerada'
			currentPartNum = 1
		end
		
		if #(coords-skupljanje) < 100.0 then
			waitara = 0
			naso = 1
			DrawMarker(0, skupljanje, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if #(coords-skupljanje) < 2.5 then
			isInMarker     = true
			currentStation = 1
			currentPart    = 'Skupljanje'
			currentPartNum = 1
		end
		
		if #(coords-cijev) < 100.0 then
			waitara = 0
			naso = 1
			DrawMarker(0, cijev, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 2.0, 1.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
		end
		if #(coords-cijev) < 1.5 then
			isInMarker     = true
			currentStation = 1
			currentPart    = 'Cijev'
			currentPartNum = 1
		end

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
			waitara = 0
			naso = 1
			if
				(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('prodajoruzje:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('prodajoruzje:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			waitara = 0
			naso = 1
			HasAlreadyEnteredMarker = false

			TriggerEvent('prodajoruzje:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end
	
		if naso == 0 then
			waitara = 500
		end
	end
end)

AddEventHandler('prodajoruzje:hasEnteredMarker', function(station, part, partNum)
	if part == 'Prerada' then
		CurrentAction     = 'menu_prerada'
		CurrentActionMsg  = "Pritisnite E da otvorite menu prerade!"
		CurrentActionData = {}
	elseif part == 'Skupljanje' then
		CurrentAction     = 'menu_skupljanje'
		CurrentActionMsg  = "Pritisnite E da pocnete skupljati zeljezo!"
		CurrentActionData = {}
	elseif part == 'Cijev' then
		CurrentAction     = 'menu_cijev'
		CurrentActionMsg  = "Pritisnite E da otvorite menu!"
		CurrentActionData = {}
	end
end)

AddEventHandler('prodajoruzje:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

function OpenPreradaMenu()
    local elements = {}
    table.insert(elements, {label = 'Kundak za assault rifle (5 zeljeza)', value = "kkundak"})
	table.insert(elements, {label = 'Kundak za carbine rifle (10 zeljeza)', value = "ckundak"})
	table.insert(elements, {label = 'Kundak za special carbine (15 zeljeza)', value = "skundak"})
	table.insert(elements, {label = 'Kundak za SMG (4 zeljeza)', value = "smkundak"})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'kraft_prerada',
      {
        title    = "Izaberite koji kundak zelite",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		ESX.TriggerServerCallback('kraft:ProvjeriKolicinu', function(imal)
			  if imal then
					local itemic = data.current.value
					menu.close()
					ESX.ShowNotification("Zapoceli ste preradu zeljeza u kundak!")
					RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
					while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
						Wait(100)
					end
					TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0, 1.0, -1, 17, 1.0, 0, 0, 0)
					local vrime = GetGameTimer()
					while GetGameTimer()-vrime < 15000 do
						Wait(1)
						DisableAllControlActions()
					end
					ClearPedTasksImmediately(PlayerPedId())
					local kordic = GetEntityCoords(PlayerPedId())
					if not IsEntityDead(PlayerPedId()) and #(kordic-cprerada) <= 5.0 then
						TriggerServerEvent("kraft:DajKundak", itemic)
						ESX.ShowNotification("Zavrsili ste preradu zeljeza u kundak!")
					end
					HasAlreadyEnteredMarker = false
			  else
					ESX.ShowNotification("Nemate dovoljno zeljeza ili nemate mjesta u inventoryju za kundak!")
			  end
		end, data.current.value)
      end,
      function(data, menu)
        menu.close()
		CurrentAction     = 'menu_prerada'
		CurrentActionMsg  = "Pritisnite E da otvorite menu prerade!"
		CurrentActionData = {}
      end
    )
end

function OpenCijevMenu()
    local elements = {}
    table.insert(elements, {label = 'Cijev za assault rifle ($5000)', value = "kcijev"})
	table.insert(elements, {label = 'Cijev za carbine rifle ($6000)', value = "ccijev"})
	table.insert(elements, {label = 'Cijev za special carbine ($7000)', value = "scijev"})
	table.insert(elements, {label = 'Cijev za smg ($4000)', value = "smcijev"})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'kraft_cijev',
      {
        title    = "Izaberite koju cijev zelite",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		ESX.TriggerServerCallback('kraft:ProvjeriKolicinu2', function(imal)
			  if imal then
					menu.close()
					CurrentAction     = 'menu_cijev'
					CurrentActionMsg  = "Pritisnite E da otvorite menu!"
					CurrentActionData = {}
					ESX.ShowNotification("Kupili ste cijev!")
			  else
					ESX.ShowNotification("Nemate dovoljno novca ili nemate mjesta u inventoryju za cijev!")
			  end
		end, data.current.value)
      end,
      function(data, menu)
        menu.close()
		CurrentAction     = 'menu_cijev'
		CurrentActionMsg  = "Pritisnite E da otvorite menu!"
		CurrentActionData = {}
      end
    )
end

RegisterNetEvent('prodajoruzje:SloziOruzje')
AddEventHandler('prodajoruzje:SloziOruzje', function(br)
	SendNUIMessage({
		prikazi2 = true,
		broj = br,
		ktijelo = true,
		kkundak = true,
		clip = true,
		kcijev = true
	})
	SetNuiFocus(true, true)
end)

RegisterNetEvent('prodajoruzje:SetajChameSkin')
AddEventHandler('prodajoruzje:SetajChameSkin', function(sk, br)
	if br then
		if sk == 1 then
			local modelHash = GetHashKey("a_m_y_downtown_01")
			ESX.Streaming.RequestModel(modelHash, function()
				SetPlayerModel(PlayerId(), modelHash)
				SetModelAsNoLongerNeeded(modelHash)
				TriggerEvent('esx:restoreLoadout')
			end)
		else
			local modelHash = GetHashKey("csb_sol")
			ESX.Streaming.RequestModel(modelHash, function()
				SetPlayerModel(PlayerId(), modelHash)
				SetModelAsNoLongerNeeded(modelHash)
				TriggerEvent('esx:restoreLoadout')
			end)
		end
	else
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local isMale = skin.sex == 0
			TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end)
	end
end)

RegisterNUICallback(
    "slozi",
    function(data, cb)
		SendNUIMessage({
			prikazi2 = true,
			broj = data.broj
		})
		SetNuiFocus(false)
		TriggerServerEvent("prodajoruzje:KoiKuracJeOvo2", data.broj)
    end
)

RegisterCommand("lc", function(source, args, rawCommandString)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local deri = true
		local veha = GetVehiclePedIsIn(PlayerPedId(), false)
		SetVehicleHandbrake(veha, true)
		while deri do
			if IsControlJustPressed(0, 71) then
				SetVehicleHandbrake(veha, false)
				deri = false
			end
			SetVehicleCurrentRpm(veha, 0.8)
			Wait(1)
		end
	else
		ESX.ShowNotification("Morate biti u vozilu!")
	end
end, false)

RegisterCommand("aduty", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			SetEntityCoords(PlayerPedId(), -889.0873413086, -432.51022338868, 88.263557434082)
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

local beba = false

RegisterCommand("beba", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			if not beba then
				beba = true
				local modelHash = GetHashKey("Baby")
				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			else
				beba = false
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0
					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)
				end)
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("psate", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			ESX.TriggerServerCallback('minute:DohvatiSate', function(elem)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sati_list', {
					title    = "Sati igraca",
					align    = 'top-left',
					elements = elem
				}, function(data, menu)
					menu.close()	
				end, function(data, menu)
					menu.close()
				end)
			end)
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("ndv", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TriggerEvent("esx:deleteVehicle2")
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterNetEvent('esx:deleteVehicle2')
AddEventHandler('esx:deleteVehicle2', function()
    local vehicle   = ESX.Game.GetVehicleInDirection()
    local entity = vehicle
    carModel = GetEntityModel(entity)
    carName = GetDisplayNameFromVehicleModel(carModel)
    NetworkRequestControlOfEntity(entity)
    
    local timeout = 2000
    while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    SetEntityAsMissionEntity(entity, true, true)
    
    local timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
    
    if (DoesEntityExist(entity)) then 
        DeleteEntity(entity)
    end 
end)

RegisterCommand("obrisivatromet", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local NewBin, NewBinDistance = ESX.Game.GetClosestObject("ind_prop_firework_03")
			if NewBinDistance <= 3 then
				ESX.Game.DeleteObject(NewBin)
				SetEntityCoords(NewBin, 0, 0, 0, 1, 0, 0, 1)
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("obrisikontenjer", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_contr_03b_ld")
			if NewBinDistance <= 3 then
				ESX.Game.DeleteObject(NewBin)
				DeleteEntity(NewBin)
				SetEntityCoords(NewBin, 0, 0, 0, 1, 0, 0, 1)
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("obrisikutiju", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_box_wood05a")
			if NewBinDistance <= 3 then
				ESX.Game.DeleteObject(NewBin)
				DeleteEntity(NewBin)
				SetEntityCoords(NewBin, 0, 0, 0, 1, 0, 0, 1)
				print(NewBin)
			end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("aodg", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			--local playerIdx = GetPlayerFromServerId(tonumber(args[1]))
			--if playerIdx ~= -1 then
				if args[1] ~= nil and args[2] ~= nil then
					local razlog = table.concat(args, " ", 2)
					TriggerServerEvent("prodajoruzje:PosaljiAdmOdgovor", args[1], razlog)
					local playerName = GetPlayerName(PlayerId())
					TriggerServerEvent("prodajoruzje:SaljiInfoSvima", razlog, playerName, args[1])
					local komando = "/aodg "..args[1].." "..razlog
					TriggerServerEvent("DiscordBot:RegCmd", GetPlayerServerId(PlayerId()), komando)
				else
					name = "Admin"..":"
					message = "/aodg [ID igraca][Odgovor]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end	
			--else
				--ESX.ShowNotification("Igrac nije online!")
			--end
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("mute", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local id = 0
			local minu = 0
			id = tonumber(args[1])
			minu = tonumber(args[2])
			if id ~= 0 and id ~= nil and minu ~= 0 and minu ~= nil then
				TriggerServerEvent("esx_rpchat:MuteGa", id, minu)
			else
				name = "Admin"..": "
				message = "/mute [id][minute]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("unmute", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local id = 0
			id = tonumber(args[1])
			if id ~= 0 and id ~= nil then
				TriggerServerEvent("esx_rpchat:UnmuteGa", id)
			else
				name = "Admin"..": "
				message = "/unmute [id]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

local kucica = nil

RegisterCommand("testkucu", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			if kucica == nil then
				local cord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 10.0, 0.0)
				local x,y,z = table.unpack(cord)
				local model = GetHashKey("lf_house_11_")
				RequestModel(model)
				kucica = CreateObject(model, x, y, z-1.6, true, true, false)
				FreezeEntityPosition(kucica, true)
				PlaceObjectOnGroundProperly(kucica)
				FreezeEntityPosition(PlayerPedId(), true)
				Citizen.CreateThread(function()
					while kucica ~= nil do
						if IsControlPressed(0, 32) then
							local corde = GetOffsetFromEntityInWorldCoords(kucica, 0.0, 0.1, 0.0)
							SetEntityCoords(kucica, corde)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 33) then
							local corde = GetOffsetFromEntityInWorldCoords(kucica, 0.0, -0.1, 0.0)
							SetEntityCoords(kucica, corde)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 34) then
							local corde = GetOffsetFromEntityInWorldCoords(kucica, 0.1, 0.0, 0.0)
							SetEntityCoords(kucica, corde)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 35) then
							local corde = GetOffsetFromEntityInWorldCoords(kucica, -0.1, 0.0, 0.0)
							SetEntityCoords(kucica, corde)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 52) then
							local head = GetEntityHeading(kucica)
							SetEntityHeading(kucica, head+1.0)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlPressed(0, 51) then
							local head = GetEntityHeading(kucica)
							SetEntityHeading(kucica, head-1.0)
							PlaceObjectOnGroundProperly(kucica)
						end
						if IsControlJustPressed(0, 191) then
							FreezeEntityPosition(PlayerPedId(), false)
							break
						end
						Citizen.Wait(10)
					end
				end)
			else
				ESX.Game.DeleteObject(kucica)
				kucica = nil
				FreezeEntityPosition(PlayerPedId(), false)
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("testumor", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			StatSetInt(GetHashKey('MP0_STAMINA'), tonumber(args[1]), true)
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("testanim", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			RequestAnimDict(args[1])
			while not HasAnimDictLoaded(args[1]) do
				Citizen.Wait(1000)
			end
			TaskPlayAnim(PlayerPedId(),args[1],args[2], 8.0, -8, -1, 2, 0, 0, 0, 0)
			--TaskStartScenarioInPlace(PlayerPedId(), args[1], 0, true)
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("testscenario", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TaskStartScenarioInPlace(PlayerPedId(), args[1], 0, true)
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("dajmuskin", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local id = 0
			id = tonumber(args[1])
			if id ~= 0 and id ~= nil then
				TriggerServerEvent("prodajoruzje:TestSkinaa", id)
			else
				name = "Admin"..":"
				message = "/dajmuskin [id]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("setskin", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local id = 0
			id = tonumber(args[1])
			if id ~= 0 and id ~= nil then
				TriggerServerEvent("prodajoruzje:DajSkin", id)
			else
				name = "Admin"..":"
				message = "/setskin [id]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("oduzmisociety", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local ime = args[1]
			local broj = tonumber(args[2])
			if ime ~= nil and (args[2] ~= nil or args[2] ~= 0) then
				local soc = "society_"..ime
				TriggerServerEvent("ObrisiSociety", soc, broj)
			else
				name = "Admin"..":"
				message = "/oduzmisociety [Ime mafije][Iznos]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerClientEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterCommand("a", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
				if args[1] ~= nil then
					local playerName = GetPlayerName(PlayerId())
					TriggerServerEvent("prodajoruzje:PosaljiRadio2Server", table.concat(args, " "), playerName)
				else
					name = "System"..":"
					message = " /a [Poruka]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end	
		else
			name = "System"..":"
			message = " Nemate pristup ovoj komandi"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })	
		end
	--end)
end, false)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end) 

RegisterNetEvent('prodajoruzje:TestSkina')
AddEventHandler('prodajoruzje:TestSkina', function()
	SetPedComponentVariation(PlayerPedId(), 1, 0 ,0, 2)
end) 

RegisterNetEvent('prodajoruzje:EoTiSkinic')
AddEventHandler('prodajoruzje:EoTiSkinic', function()
	local model = "s_m_m_pilot_01"
	RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
end) 

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

RegisterCommand("sjedi", function(source, args, rawCommandString)
	local ped = PlayerPedId()
	local cord = GetEntityCoords(ped)
	local head = GetEntityHeading(ped)
	--TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_SEAT_BENCH", 0, true)
	
	ESX.Streaming.RequestAnimDict("anim@heists@prison_heistunfinished_biztarget_idle", function()
		TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistunfinished_biztarget_idle", "target_idle", 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
	
	ESX.ShowNotification("Pritisnite X da se ustanete")
end, false)

RegisterCommand("prodajkokain", function(source, args, rawCommandString)
	local kol = args[1]
	local cijena = args[2]
	local t, distance = GetClosestPlayer()
	local igrac = GetPlayerServerId(t)
	if(distance ~= -1 and distance < 5) then
		if kol ~= nil and tonumber(kol) > 0 then
			if cijena ~= nil and tonumber(cijena) > 0 then
				TriggerServerEvent("prodajoruzje:Posalji3", tonumber(igrac), cijena, kol, GetPlayerServerId(PlayerId()))
			else
				name = "System"..":"
				message = " /prodajkokain [Kolicina (min 1)][Cijena (min 1$)]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			name = "System"..":"
			message = " /prodajkokain [Kolicina (min 1)][Cijena (min 1$)]"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
		end
	else
		ESX.ShowNotification("Nema igraca blizu vas!")
	end
end, false)

RegisterCommand("prodajdrogu", function(source, args, rawCommandString)
	if ESX.PlayerData.job.name == "mafia" or ESX.PlayerData.job.name == "yakuza" or ESX.PlayerData.job.name == "cartel" or ESX.PlayerData.job.name == "britvasi" or ESX.PlayerData.job.name == "shelby" or ESX.PlayerData.job.name == "nomads" or ESX.PlayerData.job.name == "camorra" or ESX.PlayerData.job.name == "ballas" or ESX.PlayerData.job.name == "zemunski" then
		local kol = args[1]
		local cijena = args[2]
		local t, distance = GetClosestPlayer()
		local igrac = GetPlayerServerId(t)
		if(distance ~= -1 and distance < 5) then
			if kol ~= nil and tonumber(kol) > 0 then
				if cijena ~= nil and tonumber(cijena) > 0 then
					TriggerServerEvent("prodajoruzje:Posalji2", tonumber(igrac), cijena, kol, GetPlayerServerId(PlayerId()))
				else
					name = "System"..":"
					message = " /prodajdrogu [Kolicina (min 1)][Cijena (min 1$)]"
					TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
				end
			else
				name = "System"..":"
				message = " /prodajdrogu [Kolicina (min 1)][Cijena (min 1$)]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			ESX.ShowNotification("Nema igraca blizu vas!")
		end
	else
		ESX.ShowNotification("Niste clan mafije!")
	end
end, false)

RegisterCommand("prodajoruzje", function(source, args, rawCommandString)
	if ESX.PlayerData.job.name == "mafia" or ESX.PlayerData.job.name == "yakuza" or ESX.PlayerData.job.name == "cartel" or ESX.PlayerData.job.name == "britvasi" or ESX.PlayerData.job.name == "shelby" or ESX.PlayerData.job.name == "nomads" or ESX.PlayerData.job.name == "camorra" then
		local cijena = args[1]
		local t, distance = GetClosestPlayer()
		local igrac = GetPlayerServerId(t)
		if(distance ~= -1 and distance < 5) then
			if cijena ~= nil and tonumber(cijena) > 0 then
				local retval, weaponHash = GetCurrentPedWeapon(PlayerPedId(), 1)
				if retval == 1 then
				local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
				TriggerServerEvent("prodajoruzje:Posalji", tonumber(igrac), weaponHash, cijena, ammo, GetPlayerServerId(PlayerId()))
				ESX.ShowNotification("Ponudili ste igracu oruzje!")
				else
				ESX.ShowNotification("Nemate oruzje u ruci!")
				end
			else
				name = "System"..":"
				message = " /prodajoruzje [Cijena (min 1$)]"
				TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
			end
		else
			ESX.ShowNotification("Nema igraca blizu vas!")
		end
	else
		ESX.ShowNotification("Niste clan mafije!")
	end
end, false)

RegisterCommand("prihvatikokain", function(source, args, rawCommandString)
	if Prodavac2 ~= nil then
		TriggerServerEvent("dajpro:oruzje3", GetPlayerServerId(PlayerId()), CijenaDroge, Kolicina, Prodavac2)
		CijenaDroge = 0
		Kolicina = 0
		Prodavac2 = nil
	else
		ESX.ShowNotification("Nitko vam nije ponudio kokain!")
	end
end, false)

RegisterCommand("prihvatidrogu", function(source, args, rawCommandString)
	if Prodavac2 ~= nil then
		TriggerServerEvent("dajpro:oruzje2", GetPlayerServerId(PlayerId()), CijenaDroge, Kolicina, Prodavac2)
		CijenaDroge = 0
		Kolicina = 0
		Prodavac2 = nil
	else
		ESX.ShowNotification("Nitko vam nije ponudio drogu!")
	end
end, false)

RegisterCommand("vtest", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false) , 1000000000)
			print("doso tu ")
			Citizen.CreateThread(function()
				while true do
					SetVehicleEngineTorqueMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 500.0)
					Wait(0)
				end
			end)
		else
			ESX.ShowNotification("Nemate pristup ovoj komandi!")
		end
	--end)
end, false)

RegisterCommand("prihvatioruzje", function(source, args, rawCommandString)
	if Oruzje ~= nil then
		TriggerServerEvent("dajpro:oruzje", GetPlayerServerId(PlayerId()), DajImeOruzja(Oruzje), Cijena, Metci, Prodavac)
		Oruzje = nil
		Cijena = 0
		Metci = 0
		Prodavac = nil
	else
		ESX.ShowNotification("Nitko vam nije ponudio oruzje!")
	end
end, false)

function DajImeOruzja(hash)
	local ime = "Nema"
	if hash == -102323637 then
		ime = "WEAPON_BOTTLE"
	elseif hash == -1813897027 then
		ime = "WEAPON_GRENADE"
	elseif hash == 741814745 then
		ime = "WEAPON_STICKYBOMB"
	elseif hash == -494615257 then
		ime = "WEAPON_ASSAULTSHOTGUN"
	elseif hash == -1654528753 then
		ime = "WEAPON_BULLPUPSHOTGUN"
	elseif hash == 2017895192 then
		ime = "WEAPON_SAWNOFFSHOTGUN"
	elseif hash == 487013001 then
		ime = "WEAPON_PUMPSHOTGUN"
	elseif hash == 205991906 then
		ime = "WEAPON_HEAVYSNIPER"
	elseif hash == 100416529 then
		ime = "WEAPON_SNIPERRIFLE"
	elseif hash == -1357824103 then
		ime = "WEAPON_ADVANCEDRIFLE"
	elseif hash == -2084633992 then
		ime = "WEAPON_CARBINERIFLE"
	elseif hash == 2144741730 then
		ime = "WEAPON_COMBATMG"
	elseif hash == -1660422300 then
		ime = "WEAPON_MG"
	elseif hash == -270015777 then
		ime = "WEAPON_ASSAULTSMG"
	elseif hash == 736523883 then
		ime = "WEAPON_SMG"
	elseif hash == 324215364 then
		ime = "WEAPON_MICROSMG"
	elseif hash == 911657153 then
		ime = "WEAPON_STUNGUN"
	elseif hash == 584646201 then
		ime = "WEAPON_APPISTOL"
	elseif hash == -1716589765 then
		ime = "WEAPON_PISTOL50"
	elseif hash == 1593441988 then
		ime = "WEAPON_COMBATPISTOL"
	elseif hash == 453432689 then
		ime = "WEAPON_PISTOL"
	elseif hash == -1076751822 then
		ime = "WEAPON_SNSPISTOL"
	elseif hash == -1045183535 then
		ime = "WEAPON_REVOLVER"   
	elseif hash == -538741184 then   
		ime = "WEAPON_SWITCHBLADE"   
	elseif hash == 317205821 then    
		ime = "WEAPON_AUTOSHOTGUN"   
	elseif hash == -853065399 then   
		ime = "WEAPON_BATTLEAXE"   
	elseif hash == 125959754 then    
		ime = "WEAPON_COMPACTLAUNCHER"  
	elseif hash == -1121678507 then   
		ime = "WEAPON_MINISMG"    
	elseif hash == -1169823560 then    
		ime = "WEAPON_PIPEBOMB"    
	elseif hash == -1810795771 then    
		ime = "WEAPON_POOLCUE"    
	elseif hash == 419712736 then    
		ime = "WEAPON_WRENCH"   
	elseif hash == -1420407917 then   
		ime = "WEAPON_PROXMINE"   
	elseif hash == 1672152130 then    
		ime = "WEAPON_HOMINGLAUNCHER"    
	elseif hash == 3219281620 then    
		ime = "WEAPON_PISTOL_MK2"    
	elseif hash == 2024373456 then    
		ime = "WEAPON_SMG_MK2"   
	elseif hash == 961495388 then   
		ime = "WEAPON_ASSAULTRIFLE_MK2"
	elseif hash == -1074790547 then
		ime = "WEAPON_ASSAULTRIFLE"
	elseif hash == 4208062921 then   
		ime = "WEAPON_CARBINERIFLE_MK2"    
	elseif hash == 3686625920 then    
		ime = "WEAPON_COMBATMG_MK2"   
	elseif hash == 177293209 then    
		ime = "WEAPON_HEAVYSNIPER_MK2"    
	elseif hash == -1951375401 then    
		ime = "WEAPON_FLASHLIGHT"   
	elseif hash == 1198879012 then    
		ime = "WEAPON_FLAREGUN"    
	elseif hash == -581044007 then    
		ime = "WEAPON_MACHETE"   
	elseif hash == -619010992 then    
		ime = "WEAPON_MACHINEPISTOL"   
	elseif hash == -275439685 then
		ime = "WEAPON_DBSHOTGUN" 
	elseif hash == 1649403952 then   
		ime = "WEAPON_COMPACTRIFLE"   
	elseif hash == 171789620 then   
		ime = "WEAPON_COMBATPDW"  
	elseif hash == -771403250 then   
		ime = "WEAPON_HEAVYPISTOL"   
	elseif hash == -1063057011 then  
		ime = "WEAPON_SPECIALCARBINE"   
	elseif hash == -656458692 then   
		ime = "WEAPON_KNUCKLE"   
	elseif hash == -598887786 then   
		ime = "WEAPON_MARKSMANPISTOL"    
	elseif hash == 2132975508 then    
		ime = "WEAPON_BULLPUPRIFLE"    
	elseif hash == -1834847097 then   
		ime = "WEAPON_DAGGER"   
	elseif hash == 137902532 then   
		ime = "WEAPON_VINTAGEPISTOL"   
	elseif hash == 2138347493 then    
		ime = "WEAPON_FIREWORK"   
	elseif hash == -1466123874 then   
		ime = "WEAPON_MUSKET"    
	elseif hash == 984333226 then    
		ime = "WEAPON_HEAVYSHOTGUN"  
	elseif hash == -952879014 then   
		ime = "WEAPON_MARKSMANRIFLE"   
	elseif hash == 1627465347 then 
		ime = "WEAPON_GUSENBERG"  
	elseif hash == -102973651 then   
		ime = "WEAPON_HATCHET" 
	elseif hash == 1834241177 then  
		ime = "WEAPON_RAILGUN"  
	elseif hash == 1119849093 then  
		ime = "WEAPON_MINIGUN"   
	elseif hash ==3415619887 then   
		ime = "WEAPON_REVOLVER_MK2"    
	elseif hash == 2548703416 then    
		ime = "WEAPON_DOUBLEACTION"  
	elseif hash ==2526821735 then   
		ime = "WEAPON_SPECIALCARBINE_MK2"    
	elseif hash == 2228681469 then   
		ime = "WEAPON_BULLPUPRIFLE_MK2"    
	elseif hash == 1432025498 then   
		ime = "WEAPON_PUMPSHOTGUN_MK2"
	elseif hash == 1785463520 then 
		ime = "WEAPON_MARKSMANRIFLE_MK2"
	end
	return ime
end

RegisterCommand('rpchat', function(source, args, rawCommand)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TriggerServerEvent("PromjeniGlobal")
		end
	--end)
end, false)
	
RegisterCommand("uauto", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
			if closestVehicle ~= nil then
				if Distance <= 8.0 then
					NetworkRequestControlOfEntity(closestVehicle)
					TaskWarpPedIntoVehicle(PlayerPedId(), closestVehicle, -1)	
				end
			end
		else
			ESX.ShowNotification("Nemate ovlasti!")
		end
	--end)
end, false)

RegisterCommand("dvi", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			ObrisiBlizu()
		else
			ESX.ShowNotification("Nemate ovlasti!")
		end
	--end)
end, false)

RegisterCommand("dvu", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			ObrisiUnisten()
		else
			ESX.ShowNotification("Nemate ovlasti!")
		end
	--end)
end, false)


RegisterCommand("brnace", function(source, args, rawCommandString)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			ObrisiBrnace()
		end
	--end)
end, false)

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function ObrisiBlizu()
	local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
	if closestVehicle ~= nil then
		if Distance <= 8.0 then
			local attempt = 0
			while not NetworkHasControlOfEntity(closestVehicle) and attempt < 100 and DoesEntityExist(closestVehicle) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(closestVehicle)
				attempt = attempt + 1
			end

			if DoesEntityExist(closestVehicle) and NetworkHasControlOfEntity(closestVehicle) then
				ESX.TriggerServerCallback('mafije:DohvatiKamion', function(odg)
					if odg ~= false then
						NetworkRequestControlOfEntity(NetToObj(odg.Obj1))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj2))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj3))
						ESX.Game.DeleteObject(NetToObj(odg.Obj1))
						ESX.Game.DeleteObject(NetToObj(odg.Obj2))
						ESX.Game.DeleteObject(NetToObj(odg.Obj3))
						ESX.Game.DeleteVehicle(closestVehicle)
					else
						ESX.Game.DeleteVehicle(closestVehicle)
					end
				end, VehToNet(closestVehicle))
			end
		end
	end
end

function ObrisiUnisten()
	local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
	NetworkRequestControlOfEntity(closestVehicle)
	if closestVehicle ~= nil then
		if Distance <= 8.0 then
			if GetEntityHealth(closestVehicle) == 0 then
				ESX.TriggerServerCallback('mafije:DohvatiKamion', function(odg)
					if odg ~= false then
						NetworkRequestControlOfEntity(NetToObj(odg.Obj1))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj2))
						NetworkRequestControlOfEntity(NetToObj(odg.Obj3))
						ESX.Game.DeleteObject(NetToObj(odg.Obj1))
						ESX.Game.DeleteObject(NetToObj(odg.Obj2))
						ESX.Game.DeleteObject(NetToObj(odg.Obj3))
						SetEntityAsNoLongerNeeded(closestVehicle)
						ESX.Game.DeleteVehicle(closestVehicle)
					else
						SetEntityAsNoLongerNeeded(closestVehicle)
						ESX.Game.DeleteVehicle(closestVehicle)
					end
				end, VehToNet(closestVehicle))
            end				
		end
	end
end


function ObrisiBrnace()
    local ped = PlayerPedId()
    local coords = GetEntityCoords( ped )
	for veh in EnumerateVehicles() do
            if DoesEntityExist(veh) then
				local vcord = GetEntityCoords(veh)
				if GetDistanceBetweenCoords(coords, vcord, false) <= 5.0 then
					SetEntityAsNoLongerNeeded(veh)
					ESX.Game.DeleteVehicle(veh)
				end
			end
	end
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
    
    local next = true
	local player
    repeat
	  player = false
      for i = 0, 255 do
          if (id == GetPlayerPed(i)) then
            player = true
          end
      end
	  if not player then
        coroutine.yield(id)
	  end
      next, id = moveFunc(iter)
    until not next
    
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
		
RegisterNetEvent("prodajoruzje:PokaziClanove")
AddEventHandler('prodajoruzje:PokaziClanove', function(elem)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'employee_list', {
		title    = "Online clanovi",
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		menu.close()	
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent("prodajoruzje:PokaziLidere")
AddEventHandler('prodajoruzje:PokaziLidere', function(elem)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'employee_list', {
		title    = "Online lideri",
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		menu.close()	
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent("prodajoruzje:PokaziSveLidere")
AddEventHandler('prodajoruzje:PokaziSveLidere', function(elem)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'employee_list', {
		title    = "Svi lideri",
		align    = 'top-left',
		elements = elem
	}, function(data, menu)
		menu.close()	
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent("prodajoruzje:PosaljiRadio")
AddEventHandler('prodajoruzje:PosaljiRadio', function(odg, ime, posao)
	if ESX ~= nil then
		if ESX.PlayerData.job ~= nil then
			if ESX.PlayerData.job.name == posao then
				if ESX.PlayerData.job.name == "police" then
					TriggerEvent('chat:addMessage', {
								template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 51, 204, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>[Policija] {0}:<br> {1}</div>',
								args = { ime, odg }
					})
				else
					TriggerEvent('chat:addMessage', {
								template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 51, 204, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>[Mehanicari] {0}:<br> {1}</div>',
								args = { ime, odg }
					})
				end
			end
		end
	end
end)

RegisterNetEvent("prodajoruzje:VratiInfoSvima")
AddEventHandler('prodajoruzje:VratiInfoSvima', function(odg, ime, ime2)
	while ESX == nil do
		Wait(0)
	end
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TriggerEvent('chat:addMessage', {
						template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(226, 109, 17, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>[ADMIN ODGOVOR] {0} je odgovorio {1}: <br> {2}</div>',
						args = { ime, ime2, odg }
			})
		end
	--end)
end)

RegisterNetEvent("prodajoruzje:PosaljiRadio2")
AddEventHandler('prodajoruzje:PosaljiRadio2', function(odg, ime)
	--ESX.TriggerServerCallback('esx-races:DohvatiPermisiju', function(br)
		if perm == 1 then
			TriggerEvent('chat:addMessage', {
						template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(51, 153, 255, 0.6); border-radius: 3px;"><i class="fas fa-info-circle"></i>[ADMIN CHAT] {0}:<br> {1}</div>',
						args = { ime, odg }
			})
		end
	--end)
end)

RegisterNetEvent("prodajoruzje:VratiAdmOdgovor")
AddEventHandler('prodajoruzje:VratiAdmOdgovor', function(odg)
	TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 255, 97, 0.6); border-radius: 3px;"><i class="fas fa-user-shield"></i> {0}:<br> {1}</div>',
					args = { "Odgovor admina", odg }
	})
end)

RegisterNetEvent("prodajoruzje:Saljem3")
AddEventHandler('prodajoruzje:Saljem3', function(cijena, kol, pid)
	CijenaDroge = cijena
	Kolicina = kol
	Prodavac2 = pid
	local str = "Ukoliko zelite kupiti "..kol.."g kokaina za "..cijena.."$ upisite /prihvatikokain"
	ESX.ShowNotification(str)
end)

RegisterNetEvent("prodajoruzje:Saljem2")
AddEventHandler('prodajoruzje:Saljem2', function(cijena, kol, pid)
	CijenaDroge = cijena
	Kolicina = kol
	Prodavac2 = pid
	local str = "Ukoliko zelite kupiti "..kol.."g marihuane za "..cijena.."$ upisite /prihvatidrogu"
	ESX.ShowNotification(str)
end)

RegisterNetEvent("prodajoruzje:Saljem")
AddEventHandler('prodajoruzje:Saljem', function(oruzje, cijena, ammo, pid)
    Oruzje = oruzje
	Cijena = cijena
	Metci = ammo
	Prodavac = pid
	local label = ESX.GetWeaponLabel(DajImeOruzja(oruzje))
	local str = "Ukoliko zelite kupiti "..label.." sa "..Metci.." metaka za "..cijena.."$ upisite /prihvatioruzje"
	ESX.ShowNotification(str)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)
