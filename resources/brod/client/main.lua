local GUI                       = {}

local Pedare = {}
local Kutije = {
	{x = 3084.095703125, y = -4819.9482421875, z = 2.0384743213654, h = 107.46464538574, Oruzje = "weapon_appistol", Pokupljeno = false}, --kutija1
	{x = 3093.9377441406, y = -4794.96875, z = 6.0781197547913, h = 188.02079772949, Oruzje = "weapon_assaultrifle", Pokupljeno = false}, --kutija2
	{x = 3083.5388183594, y = -4750.5903320313, z = 6.0772519111633, h = 8.8972473144531, Oruzje = "weapon_combatpistol", Pokupljeno = false}, --kutija3
	{x = 3068.3864746094, y = -4748.8935546875, z = 6.0772519111633, h = 100.21411132813, Oruzje = "weapon_pumpshotgun", Pokupljeno = false}, --kutija4
	{x = 3072.4787597656, y = -4725.1831054688, z = 6.0772891044617, h = 230.11392211914, Oruzje = "weapon_smg", Pokupljeno = false}, --kutija5
	{x = 3062.6799316406, y = -4715.380859375, z = 6.077290058136, h = 128.1117401123, Oruzje = "weapon_pistol", Pokupljeno = false}, --kutija6
	{x = 3065.5512695313, y = -4700.1254882813, z = 6.0772886276245, h = 24.891342163086, Oruzje = "weapon_heavypistol", Pokupljeno = false}, --kutija7
	{x = 3065.6208496094, y = -4679.3325195313, z = 6.0772948265076, h = 301.16055297852, Oruzje = "weapon_microsmg", Pokupljeno = false}, --kutija8
	{x = 3040.5329589844, y = -4691.8950195313, z = 6.0772924423218, h = 196.99609375, Oruzje = "weapon_assaultsmg", Pokupljeno = false}, --kutija9
	{x = 3065.5422363281, y = -4640.0776367188, z = 6.0773043632507, h = 19.787281036377, Oruzje = "weapon_minismg", Pokupljeno = false}, --kutija10
	{x = 3089.2673339844, y = -4721.5122070313, z = 15.262617111206, h = 182.93333435059, Oruzje = "weapon_sawnoffshotgun", Pokupljeno = false}, --kutija11
	{x = 3117.3269042969, y = -4775.689453125, z = 15.261615753174, h = 33.346561431885, Oruzje = "weapon_musket", Pokupljeno = false}, --kutija12
	{x = 3120.9765625, y = -4798.8686523438, z = 15.261624336243, h = 268.81658935547, Oruzje = "weapon_carbinerifle", Pokupljeno = false}, --kutija13
	{x = 3072.4504394531, y = -4819.263671875, z = 15.261615753174, h = 178.26501464844, Oruzje = "weapon_advancedrifle", Pokupljeno = false}, --kutija14
	{x = 3062.685546875, y = -4810.1171875, z = 15.261420249939, h = 3.1431562900543, Oruzje = "weapon_specialcarbine", Pokupljeno = false}, --kutija15
	{x = 3061.6647949219, y = -4821.1918945313, z = 15.261610984802, h = 167.3440246582, Oruzje = "weapon_bullpuprifle", Pokupljeno = false}, --kutija16
	{x = 3059.2509765625, y = -4780.3510742188, z = 15.261315345764, h = 136.40548706055, Oruzje = "weapon_compactrifle", Pokupljeno = false}, --kutija17
	{x = 3112.6552734375, y = -4807.3999023438, z = 11.870106697083, h = 25.804889678955, Oruzje = "weapon_gusenberg", Pokupljeno = false}, --kutijasniperakdozvole
	{x = 3086.9794921875, y = -4718.8544921875, z = 27.261281967163, h = 205.22666931152, Oruzje = "weapon_carbinerifle_mk2", Pokupljeno = false}, --kutija18
	{x = 3082.0178222656, y = -4697.6850585938, z = 27.256883621216, h = 3.0207371711731, Oruzje = "weapon_heavypistol", Pokupljeno = false}, --kutija19
	{x = 3092.8835449219, y = -4694.7045898438, z = 27.256885528564, h = 11.456823348999, Oruzje = "weapon_assaultrifle_mk2", Pokupljeno = false}, --kutija20
	{x = 3096.208984375, y = -4722.2626953125, z = 27.256294250488, h = 103.2924118042, Oruzje = "weapon_pistol", Pokupljeno = false} --kutija21

}

GUI.Time                        = 0

ESX                             = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

AddEventHandler("playerSpawned", function()
	ESX.TriggerServerCallback('prodajoruzje:DajNetID', function(vr)
		Pedare = vr.Net
		if vr.Kut ~= nil then
			Kutije = vr.Kut
		end
	end)
end)

RegisterNetEvent('brod:VratiKutije')
AddEventHandler('brod:VratiKutije', function(kut)
	Kutije = kut
end)

Citizen.CreateThread(function()
	while true do
		for i=1, #Pedare, 1 do
			if Pedare[i] ~= nil then
				if NetworkDoesNetworkIdExist(Pedare[i]) then
					local Pedara = NetToPed(Pedare[i])
					if DoesEntityExist(Pedara) then
						local koord = GetEntityCoords(Pedara)
						local koord2 = GetEntityCoords(PlayerPedId())
						if GetDistanceBetweenCoords(koord, koord2, false) <= 300 then
							TaskCombatPed(Pedara, PlayerPedId(), 0, 16)
							SetPedDropsWeaponsWhenDead(Pedara, false)
						end
						if IsEntityDead(Pedara) then
							DeletePed(Pedara)
							Pedara = nil
							table.remove(Pedare, i)
						end
					end
				end
			end
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	local waitara = 1000
	while true do
		local naso = 0
		local koord = GetEntityCoords(PlayerPedId())
		for i=1, #Kutije, 1 do
			if Kutije[i].Pokupljeno == false then
				if GetDistanceBetweenCoords(koord, Kutije[i].x, Kutije[i].y, Kutije[i].z, true) <= 20 then
					naso = 1
					waitara = 0
					DrawMarker(23, Kutije[i].x, Kutije[i].y, Kutije[i].z-0.9, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, 0, 204, 204, 200, 0, 0, 0, 0)
				end
				if GetDistanceBetweenCoords(koord, Kutije[i].x, Kutije[i].y, Kutije[i].z, true) <= 2.0 then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Pritisnite E da pokupite oruzje!")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
					if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 150 then
						Kutije[i].Pokupljeno = true
						TriggerServerEvent("brod:PosaljiKutije", Kutije)
						GUI.Time = GetGameTimer()
						TriggerServerEvent("prodajoruzje:DajOruzjeItem", Kutije[i].Oruzje)
					end
				end
			end
		end
		if naso == 0 then
			waitara = 1000
		end
		Citizen.Wait(waitara)
	end
end)

local Pedovi = {
	{x = 3097.6840820313, y = -4800.4282226563, z = 2.0371627807617, h = 163.9309387207}, --ped1
	{x = 3099.01171875, y = -4820.7885742188, z = 7.0263075828552, h = 198.75761413574}, --ped2
	{x = 3088.8098144531, y = -4823.5883789063, z = 7.0263075828552, h = 198.58854675293}, --ped3
	{x = 3090.2492675781, y = -4795.2592773438, z = 2.0353062152863, h = 193.73344421387}, --ped7
	{x = 3080.126953125, y = -4797.97265625, z = 2.0330352783203, h = 206.92115783691}, --ped8
	{x = 3094.20703125, y = -4775.2036132813, z = 6.0772504806519, h = 191.45686340332}, --nped1
	{x = 3087.5122070313, y = -4793.9731445313, z = 6.077684879303, h = 314.13238525391}, --nped2
	{x = 3073.1501464844, y = -4805.224609375, z = 7.0771980285645, h = 305.26715087891}, --nped3
	{x = 3060.05078125, y = -4751.66796875, z = 10.742157936096, h = 283.03997802734}, --nped4
	{x = 3094.1252441406, y = -4753.0014648438, z = 11.574591636658, h = 194.11500549316}, --nped5
	{x = 3082.0703125, y = -4729.9428710938, z = 10.742079734802, h = 114.14613342285}, --nped6
	{x = 3074.7260742188, y = -4702.5327148438, z = 10.742079734802, h = 110.19576263428}, --nped7
	{x = 3065.3645019531, y = -4693.2495117188, z = 6.0772914886475, h = 189.66995239258}, --nped8
	{x = 3051.7507324219, y = -4720.380859375, z = 10.742081642151, h = 281.85003662109}, --nped9
	{x = 3037.9025878906, y = -4683.1987304688, z = 10.742074012756, h = 200.80094909668}, --nped10
	{x = 3033.2819824219, y = -4678.2045898438, z = 6.0772881507874, h = 212.30332946777}, --nped11
	{x = 3067.7556152344, y = -4673.056640625, z = 10.742070198059, h = 30.15424156189}, --nped12
	{x = 3041.3291015625, y = -4628.0375976563, z = 6.077305316925, h = 195.72624206543}, --nped13
	{x = 3096.1640625, y = -4705.3798828125, z = 12.244035720825, h = 55.616683959961}, --nped14
	{x = 3084.0302734375, y = -4702.962890625, z = 15.262312889099, h = 197.80244445801}, --nped15
	{x = 3093.3620605469, y = -4721.00390625, z = 15.262619018555, h = 37.351776123047}, --nped16
	{x = 3070.6037597656, y = -4691.5258789063, z = 15.262335777283, h = 204.85491943359}, --nped17
	{x = 3097.3073730469, y = -4703.4096679688, z = 24.261274337769, h = 282.89080810547}, --nped18
	{x = 3092.3161621094, y = -4703.8627929688, z = 27.261859893799, h = 117.52263641357}, --nped19
	{x = 3086.7351074219, y = -4664.6459960938, z = 15.262313842773, h = 162.44529724121}, --nped20
	{x = 3062.2084960938, y = -4597.6494140625, z = 15.261420249939, h = 135.84211730957}, --nped21
	{x = 3056.0139160156, y = -4778.6938476563, z = 15.261302947998, h = 332.32510375977}, --nped22
	{x = 3067.5161132813, y = -4820.8359375, z = 15.26162147522, h = 337.54202270508}, --nped23
	{x = 3061.5668945313, y = -4813.4243164063, z = 15.261420249939, h = 330.23608398438}, --nped24
	{x = 3119.7290039063, y = -4797.037109375, z = 15.261385917664, h = 78.189170837402}, --nped25
	{x = 3117.4812011719, y = -4777.9970703125, z = 15.261619567871, h = 148.27973937988}, --nped26
}

RegisterCommand("pokrenibrod", function(source, args, rawCommandString)
	ESX.TriggerServerCallback('DajMiPermLevelCall', function(perm)
		if perm == 69 then
			RequestModel(GetHashKey('s_m_y_marine_03'))
			while not HasModelLoaded(GetHashKey('s_m_y_marine_03')) do
				Wait(100)
			end
			for i=1, #Pedovi, 1 do
				local Pedara = CreatePed(29, GetHashKey('s_m_y_marine_03'), Pedovi[i].x, Pedovi[i].y, Pedovi[i].z, Pedovi[i].h, true, true)
				SetPedDropsWeaponsWhenDead(Pedara, false)
				SetPedCanSwitchWeapon(Pedara, true)
				local br = math.random(1,3)
				if br == 1 then
					GiveWeaponToPed(Pedara, GetHashKey('WEAPON_ASSAULTRIFLE'), 9999, 1, 1)
				elseif br == 2 then
					GiveWeaponToPed(Pedara, GetHashKey('WEAPON_PISTOL'), 9999, 1, 1)
				else
					GiveWeaponToPed(Pedara, GetHashKey('WEAPON_SMG'), 9999, 1, 1)
				end
				SetEntityAsMissionEntity(Pedara, true, true)
				NetworkRegisterEntityAsNetworked(Pedara)
				local netID = PedToNet(Pedara)
				NetworkSetNetworkIdDynamic(netID, false)
				SetNetworkIdCanMigrate(netID, true)
				SetNetworkIdExistsOnAllMachines(netID, true)
				table.insert(Pedare, netID)
				TriggerServerEvent("prodajoruzje:SpremiNetID", Pedare)
			end
			SetModelAsNoLongerNeeded(GetHashKey('s_m_y_marine_03'))
		end
	end)
end, false)