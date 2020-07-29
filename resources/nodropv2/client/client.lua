-- 		 		LosOceanic_StopWP = Stop Weapon Drops of Peds				--
--						Becasue No one likes free guns						--
--			By DK - 2019			...	Dont forget your Bananas!			--
------------------------------------------------------------------------------

--[ Loading ESX Object Dependancies ]--

ESX = nil

local relationshipTypes = {
  "GANG_1",
  "GANG_2",
  "GANG_9",
  "GANG_10",
  "AMBIENT_GANG_LOST",
  "AMBIENT_GANG_MEXICAN",
  "AMBIENT_GANG_FAMILY",
  "AMBIENT_GANG_BALLAS",
  "AMBIENT_GANG_MARABUNTE",
  "AMBIENT_GANG_CULT",
  "AMBIENT_GANG_SALVA",
  "AMBIENT_GANG_WEICHENG",
  "AMBIENT_GANG_HILLBILLY",
  "DEALER",
  "HATES_PLAYER",
  "NO_RELATIONSHIP",
  "SPECIAL",
  "MISSION2",
  "MISSION3",
  "MISSION4",
  "MISSION5",
  "MISSION6",
  "MISSION7",
  "MISSION8",
} 

Citizen.CreateThread(function()
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(250)
		end
end)

--[ ESX Loaded - Generate Code Below ]--

------------------------------------------------------------------------------
--	Script Locals Variables													--
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--	Functions																--
------------------------------------------------------------------------------

function SetWeaponDrops()
	-- Set Your Player as a Ped Entity to use its Coords in the ESX Function.
	local iPed = GetPlayerPed(-1)
	local iPedx = GetEntityCoords(iPed)
	-- Target Peds as the array and 25 being the distance around the player.
	-- This is not a normal ESX function.
	local Target = ESX.Game.GetPedsInArea(iPedx, Config.Radius, Config.IgnoreList)
	-- For each ped inside the Target array pulled from ESX.
	for _, group in ipairs(relationshipTypes) do
        SetRelationshipBetweenGroups(1, GetHashKey('PLAYER'), GetHashKey(group))
        SetRelationshipBetweenGroups(1, GetHashKey(group), GetHashKey('PLAYER'))
    end
	for i=1, #Target, 1 do
		-- Are we sure its a ped?
		if not IsPedAPlayer(Target[i]) then
			-- If Entity is not dead then...
			if not IsPedDeadOrDying(Target[i]) then
				-- Dont Drop Guns!
				SetPedDropsWeaponsWhenDead(Target[i], false)
					if IsEntityAMissionEntity(Target[i]) then 
						break
					else
						RemovePedElegantly(Target[i])
					end
			else
				-- Now if they are dead, I want to make sure we tell the server they are not needed. "CLEAN UP ISLE 7"
				if IsEntityDead(Target[i]) then
					if IsPedInAnyVehicle(Target[i], false) then
						RemovePedElegantly(Target[i])
					end
				end
			end
		end
	end			
end	

------------------------------------------------------------------------------
--	Threads																	--
------------------------------------------------------------------------------

-- Stop Weapon Drops

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)			-- Every Frame
        SetWeaponDrops()		-- Set all Peds in Config.Radius to not drop guns.
    end
end)

------------------------------------------------------------------------------