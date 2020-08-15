rentalTimer = 10 --How often a player should be charged in Minutes
isBeingCharged = false
autoChargeAmount = 100 -- How much a player should be charged each time
ESX = nil
devMode = false
damageInsurance = false
damageCharge = false
canBeCharged = false
--handCuffed = false
arrestCheckAlreadyRan = false
isInPrison = false
isBlipCreated = false
local RentVehicle = nil


Citizen.CreateThread(function()
	local items = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" }
	local currentItemIndex = 1
	local selectedItemIndex = 1
	local checkBox = true
	
	pickupStation = { --Set the car rental locaitons here
		{x = -1054.6479492188, y = -2650.3547363282, z = 12.83075428009},		--Airport car rental place
		{x = 302.82073974609, y = -1360.2563476563, z = 30.422897338867},        --Bolnica
		{x = 1875.6359863281, y = 2595.2761230469, z = 44.672054290771}        --Zatvor
		--{x = 1677.2429199219, y = 2658.6179199219, z = 45.560031890869}

	}
	
	dropoffStation = { --Set the car dropoff locations here
		{x = -1044.0610351562, y = -2652.0307617188, z = 12.830760002136}, --Airport car rental place
		{x = -914.16, y = -160.85, z = 40.88}, -- PV at Boulevard Del Perro
		{x = -1179.45, y = -731.2, z = 19.5}, -- PV at North Rockford Dr
		{x = -791.74, y = 332.14, z = 84.7}, -- PV at South Mo Milton Dr
		{x = 604.92, y = 105.35, z = 91.89}, -- PV at Vinewood Blvd
		{x = 394.15, y = -1660.44, z = 26.31}, -- PV at Innocence Blvd
		{x = 1459.65, y = 3735.7, z = 32.51}, -- PV at Marina Dr
		{x = 19.39, y = 6334.73, z = 30.24}, -- PV at Great Ocean Hwy
		
	}	
	
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
	
	WarMenu.CreateMenu('carRental', 'Iznajmljivanje auta')
	WarMenu.CreateSubMenu('closeMenu', 'carRental', 'Jeste li sigurni?')
	WarMenu.CreateSubMenu('carPicker', 'carRental', 'Izaberite auto | 1 dan je oko ' .. rentalTimer ..  ' minuta')
	WarMenu.CreateSubMenu('carInsurance', 'carRental', 'Zelite li kupiti auto osiguranje?')
	WarMenu.CreateMenu('carReturn', 'Vracanje auta')
	WarMenu.SetSubTitle('carReturn', 'Zelite li vratiti auto?') 
	WarMenu.CreateMenu('arrestCheck', 'Iznajmljivanje auta')
	WarMenu.SetSubTitle('arrestCheck', 'Jeste li uhiceni?')
	
	while true do
		--Main menu
		if WarMenu.IsMenuOpened('carRental') then
			if WarMenu.MenuButton('Iznajmite auto', 'carPicker') then
			elseif WarMenu.MenuButton('Auto osiguranje', 'carInsurance') then
			--elseif WarMenu.Button('DEV: Return car') then
			--	returnVehicle()
			--elseif WarMenu.Button('DEV: Delete car') then
			--	local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			--	SetEntityAsMissionEntity(currentVehicle, true, true)
			--	DeleteVehicle(currentVehicle)
			--elseif WarMenu.Button('DEV: Add 200k') then		
			--	TriggerServerEvent("devDajTuljanuRePa", 200000)
            --elseif WarMenu.CheckBox('DEV: Dev Mode', checkbox, function(checked)
            --        checkbox = checked
			--		devMode = checked
            --end) then
			--elseif WarMenu.Button('DEV: Spawn intruder') then
			--	SpawnVehicle("intruder")
			--	Citizen.Wait(100)
			--	canBeCharged = false
            --elseif WarMenu.CheckBox('DEV: Handcuffed', checkbox2, function(checked2)
            --        checkbox2 = checked2
			--		handCuffed = not checked2
            --end) then
			--elseif WarMenu.Button('DEV: TP Prison') then
			--	SetEntityCoords(GetPlayerPed(-1), 1677.233, 2658.618, 45.216)
			--elseif WarMenu.Button('DEV: TP Rental') then
			--	SetEntityCoords(GetPlayerPed(-1), -902.26593017578, -2327.3703613281, 5.7090311050415)
			--elseif WarMenu.MenuButton('Exit', 'closeMenu') then
			end
			WarMenu.SetSubTitle('carRental', 'Iznajmite auto')
			
			WarMenu.Display()
			
		--Close menu
		elseif WarMenu.IsMenuOpened('closeMenu') then
			if WarMenu.Button('Da') then
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Ne', 'carRental') then
			end
			
			WarMenu.Display()
		
		
		elseif WarMenu.IsMenuOpened('carPicker') then
			if WarMenu.Button('Yugo | Unaprijed: $100 | Dan: $100') then
				SpawnVehicle("yugo")
				TriggerServerEvent("NaplatiTuljana", 100)
				ESX.ShowNotification("Naplaceno vam je $100 za iznajmljivanje auta.")
				ESX.ShowNotification("Da vratite vozilo upisite /unrent")
				autoChargeAmount = 100
				isBeingCharged = true
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Blista | Unaprijed: $400 | Dan: $200') then
				SpawnVehicle("blista")
				TriggerServerEvent("NaplatiTuljana", 400)
				ESX.ShowNotification("Naplaceno vam je $400 za iznajmljivanje auta.")
				ESX.ShowNotification("Da vratite vozilo upisite /unrent")
				autoChargeAmount = 200
				isBeingCharged = true
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Primo | Unaprijed: $100 | Dan: $100') then
				SpawnVehicle("primo")
				TriggerServerEvent("NaplatiTuljana", 100)
				ESX.ShowNotification("Naplaceno vam je $100 za iznajmljivanje auta.")
				ESX.ShowNotification("Da vratite vozilo upisite /unrent")
				autoChargeAmount = 100
				isBeingCharged = true
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Intruder | Unaprijed: $250 | Dan: $100') then
				SpawnVehicle("intruder")
				TriggerServerEvent("NaplatiTuljana", 250)
				ESX.ShowNotification("Naplaceno vam je $250 za iznajmljivanje auta.")
				ESX.ShowNotification("Da vratite vozilo upisite /unrent")
				autoChargeAmount = 100
				isBeingCharged = true
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Banshee | Unaprijed: $1000 | Dan: $300') then
				SpawnVehicle("banshee")
				TriggerServerEvent("NaplatiTuljana", 1000)
				ESX.ShowNotification("Naplaceno vam je $1000 za iznajmljivanje auta.")
				ESX.ShowNotification("Da vratite vozilo upisite /unrent")
				autoChargeAmount = 300
				isBeingCharged = true
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Nazad', 'carRental') then
			end
			
			WarMenu.Display()
		
		--Return car menu
		elseif WarMenu.IsMenuOpened('carReturn') then
			if WarMenu.Button('Da') then
				returnVehicle()
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Ne') then
				WarMenu.CloseMenu()
			end	
			
			WarMenu.Display()

		--Car insurance menu
		elseif WarMenu.IsMenuOpened('carInsurance') then
			if WarMenu.Button('Da | $200') then
				TriggerServerEvent("NaplatiTuljana", 200)
				damageInsurance = true
				ESX.ShowNotification("Hvala vam za kupovinu auto osiguranja")
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Ne', 'carRental') then
			end
			
			WarMenu.Display()
		
		--Arrest check menu
		elseif WarMenu.IsMenuOpened('arrestCheck') then
			if WarMenu.Button('Da') then
				isBeingCharged = false
				damageInsurance = false
				damageCharge = false
				arrestCheckAlreadyRan = true
				ESX.ShowNotification('Vase iznajmljivanje je zavrseno.')
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Ne') then
				WarMenu.CloseMenu()
				arrestCheckAlreadyRan = true
			end
			
			WarMenu.Display()
			
		--elseif IsControlJustReleased(0, 48) then
		--	WarMenu.OpenMenu('carRental')
		--end
		end
		


		
		Citizen.Wait(0)
	end
	
	
end)
--Draw map blips
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not isBlipCreated then 
			for _, v in pairs(pickupStation) do
				pickupBlip = AddBlipForCoord(v.x, v.y, v.z)
      			SetBlipSprite(pickupBlip, 85)
      			SetBlipDisplay(pickupBlip, 4)
      			SetBlipScale(pickupBlip, 1.0)
      			SetBlipColour(pickupBlip, 2)
      			SetBlipAsShortRange(pickupBlip, true)
	  			BeginTextCommandSetBlipName("STRING")
      			AddTextComponentString("Rent auta")
      			EndTextCommandSetBlipName(pickupBlip)
			end
			for _, v in pairs(dropoffStation) do
				pickupBlip = AddBlipForCoord(v.x, v.y, v.z)
      			SetBlipSprite(pickupBlip, 85)
      			SetBlipDisplay(pickupBlip, 4)
      			SetBlipScale(pickupBlip, 0.60)
      			SetBlipColour(pickupBlip, 1)
      			SetBlipAsShortRange(pickupBlip, true)
	  			BeginTextCommandSetBlipName("STRING")
      			AddTextComponentString("Vracanje rent auta")
      			EndTextCommandSetBlipName(pickupBlip)
			end
			isBlipCreated = true
		end
	end
end)

--Draw markers
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local nasosta = 0
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for _, v in pairs(pickupStation) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 100 then
				waitara = 0
				nasosta = 1
				DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.75, 1.75, 1.75, 0, 204, 0, 100, false, true, 2, false, false, false, false)
				--{title="Car Rental", colour=2, id=85, x=v.x, y=v.y, z=v.z, scale=0.75}
			end
		end
		for _, v in pairs(dropoffStation) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 100 then
				waitara = 0
				nasosta = 1
				DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.75, 3.75, 3.75, 255, 0, 0, 100, false, true, 2, false, false, false, false)
			end
		end
		
		local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local plate = GetVehicleNumberPlateText(currentVehicle)
		if plate == " RENTAL " then
			if (IsVehicleDamaged(currentVehicle) and damageInsurance == false and damageCharge == false and canBeCharged == true) then
				damageCharge = true
				TriggerServerEvent("NaplatiTuljana", 500)
				ESX.ShowNotification("Naplaceno vam je $500 zbog ostecivanja auta. Kupovina osiguranja bih vas spasila od placanja.")
			elseif (damageInsurance == true and IsVehicleDamaged(currentVehicle) and damageCharge == false) then
				ESX.ShowNotification("Ostetili ste auto ali zbog osiguranja vam nece biti naplaceno nista.")
				damageCharge = true
			end
		end
		
		if(GetDistanceBetweenCoords(coords, 1799.8345947266, 2489.1350097656, -119.02998352051, true) < 2.75 and isInPrison == false) then
			isInPrison = true
			ESX.ShowNotification("Nasi podaci pokazuju da ste trenutno u zatvoru.")
			ESX.ShowNotification("Uzeli smo auto da vam se ne naplacuje vise.")
			isBeingCharged = false
			damageInsurance = false
			damageCharge = false
			SetEntityAsMissionEntity(RentVehicle, true, true)
			DeleteVehicle(RentVehicle)
			RentVehicle = nil
		end
		
		if nasosta == 0 then
			waitara = 500
		end
	end
end)

--Check to see if player is in marker
Citizen.CreateThread(function()
	while true do
		local HasAlreadyEnteredMarker = false
		Citizen.Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker = false
		local isInReturnMarker = false
		
		for _, v in pairs(pickupStation) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.75) then
				isInMarker = true
			end
		end
		
		for _, v in pairs(dropoffStation) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 2.75) then
				isInReturnMarker = true
			end
		end
		
		if (isInReturnMarker and not WarMenu.IsMenuOpened('carReturn')) then
			local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			if plate == " RENTAL " then
				WarMenu.OpenMenu('carReturn')
			end
		end
		
		if (not isInReturnMarker and not devMode and not isInMarker) then
			Citizen.Wait(100)
			WarMenu.CloseMenu()
		end
		
		if (isInMarker and not WarMenu.IsMenuOpened('carRental') and not WarMenu.IsMenuOpened('carPicker') and not WarMenu.IsMenuOpened('closeMenu') and not WarMenu.IsMenuOpened('carInsurance') and not WarMenu.IsMenuOpened('arrestCheck')) then
			WarMenu.OpenMenu('carRental')
		end
		
		if (not isInMarker and not devMode and not isInReturnMarker) then
			Citizen.Wait(100)
			WarMenu.CloseMenu()
		end
	end
end)	

--Auto charge player every 5 minutes
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(rentalTimer*60*1000)
		if isBeingCharged == true then
			TriggerServerEvent("NaplatiTuljana", autoChargeAmount)
			ESX.ShowNotification("Naplaceno vam je $" .. autoChargeAmount .. " za dan iznajmljivanja auta. Vratite vozilo kako bih ste prekinuli placanje.")
		end
	end
end)

--Spawn vehicle function
function SpawnVehicle(request)
			local hash = GetHashKey(request)

			RequestModel(hash)

			while not HasModelLoaded(hash) do
				RequestModel(hash)
				Citizen.Wait(0)
			end

			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
			RentVehicle = CreateVehicle(hash, x + 2, y + 2, z + 1, 0.0, true, false)
			SetModelAsNoLongerNeeded(hash)
			SetVehicleDoorsLocked(RentVehicle, 1)
			SetVehicleNumberPlateText(RentVehicle, "RENTAL")
			canBeCharged = true
			arrestCheckAlreadyRan = false
			isInPrison = false
			TaskWarpPedIntoVehicle(GetPlayerPed(-1),RentVehicle,-1)
end

--Return vehicle script
function returnVehicle()
			isBeingCharged = false
			damageInsurance = false
			damageCharge = false
			ESX.ShowNotification("Hvala vam na vracanju iznajmljenog vozila. Dodite nam opet!")
			local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			SetEntityAsMissionEntity(currentVehicle, true, true)
			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
			SetEntityCoords(GetPlayerPed(-1), x - 2, y, z)
			DeleteVehicle(currentVehicle)
end

RegisterCommand("unrent", function(source, args, rawCommandString)
	if RentVehicle ~= nil then
		VratiRent()
	else
		ESX.ShowNotification("Nemate iznajmljeno vozilo!")
	end
end, false)

function VratiRent()
	isBeingCharged = false
	damageInsurance = false
	damageCharge = false
	ESX.ShowNotification("Hvala vam na vracanju iznajmljenog vozila. Dodite nam opet!")
	SetEntityAsMissionEntity(RentVehicle, true, true)
	DeleteVehicle(RentVehicle)
	RentVehicle = nil
end
