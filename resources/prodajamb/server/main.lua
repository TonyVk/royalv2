local Oruzja = {}
local BrojOruzja = {}
local Brojac = 1
local Cijena = 0
local IDVozila = nil
local DostavaID = 0
local Nemoze = 0
local RutaBr = 0
local PosaoZapoceo = nil
local JednaTamo = 0
local cijene = {
      { name = 'WEAPON_COMBATPISTOL',     price = 2500 },
      { name = 'WEAPON_ASSAULTSMG',       price = 9200 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 5000 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 2500 },
      { name = 'WEAPON_APPISTOL',         price = 2000 },
      { name = 'WEAPON_CARBINERIFLE',     price = 5000 },
      { name = 'WEAPON_REVOLVER',         price = 4500 },
      { name = 'WEAPON_GUSENBERG',        price = 8200 }  
}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function BrojiGa()
	RutaBr = RutaBr+1
	local ruta = RutaBr
	SetTimeout(600000, function()
		print("ruta: "..ruta)
		print("rutabr: "..RutaBr)
		if ruta == RutaBr then
			Cijena = 0
			Nemoze = 0
			JednaTamo = 0
			PosaoZapoceo = nil
			for i=1, 10, 1 do
				Oruzja[i] = nil
				BrojOruzja[i] = 0
			end
			TriggerClientEvent("prodajamb:ResetSve", -1, 1)
		end
    end)
end

RegisterNetEvent('prodajamb:IsplatiSve')
AddEventHandler('prodajamb:IsplatiSve', function(posao)
	local societyAccount = nil
	local sime = "society_"..posao
	TriggerEvent('esx_addonaccount:getSharedAccount', sime, function(account)
		societyAccount = account
	end)
	local cijenica = math.ceil(Cijena)
	local cigracu = 500
	societyAccount.addMoney(cijenica)
	societyAccount.save()
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	sourceXPlayer.addMoney(cigracu)
	Brojac = 1
	JednaTamo = 0
	PosaoZapoceo = nil
	TriggerClientEvent("prodajamb:ResetSve", -1, 0) 
	TriggerClientEvent('esx:showNotification', source, "Zaradili ste "..cigracu.."$, dok je vasa mafija zaradila "..cijenica.."$")
	Cijena = 0
	Nemoze = 0
	for i=1, 10, 1 do
		Oruzja[i] = nil
		BrojOruzja[i] = 0
	end
end)

RegisterNetEvent('prodajamb:SaljiVozilo"')
AddEventHandler('prodajamb:SaljiVozilo"', function(id, did)
	IDVozila = id
	DostavaID = did
end)

RegisterNetEvent('prodajamb:DaliPostoji"')
AddEventHandler('prodajamb:DaliPostoji"', function(posao)
	if Nemoze == 1 then
		TriggerClientEvent("prodajamb:VratiOruzje", source, Oruzja, BrojOruzja)
		TriggerClientEvent("prodajamb:VratiVozilo", source, IDVozila, DostavaID)
	end
end)

ESX.RegisterServerCallback('prodajamb:BrisiOruzja', function(source, cb, weaponName, am, br, posao)
	if Nemoze == 0 or PosaoZapoceo == posao then
		if Brojac ~= 10 then
			Nemoze = 1
			PosaoZapoceo = posao
			local job = "society_"..posao
			TriggerEvent('esx_datastore:getSharedDataStore', job, function(store)
			local weapons = store.get('weapons')
			if weapons == nil then
			  weapons = {}
			end
			if JednaTamo == 0 then
				BrojiGa()
				JednaTamo = 1
				TriggerClientEvent('esx:showNotification', source, "Nakon 10 minuta dostava se obustavlja i gubite oruzje!")
			end

			local foundWeapon = false

			for i=1, #weapons, 1 do
			  if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - br or 0)
				weapons[i].ammo = (weapons[i].ammo > 0 and weapons[i].ammo - am or 0)
				if weapons[i].ammo < 0 then
					weapons[i].ammo = 0
				end
				foundWeapon = true
			  end
			end
			if foundWeapon then
				Oruzja[Brojac] = weaponName
				BrojOruzja[Brojac] = br
				Brojac = Brojac+1
				TriggerClientEvent("prodajamb:VratiOruzje", -1, Oruzja, BrojOruzja)
				for i=1, #cijene, 1 do
					if cijene[i].name == weaponName then
						Cijena = (Cijena+(cijene[i].price*1.20))*br
					end
				end
			end
			
			if not foundWeapon then
			  table.insert(weapons, {
				name  = weaponName,
				count = 0,
				ammo = 0
			  })
			end

			 store.set('weapons', weapons)

			 cb()

			end)
		end
	else
		TriggerClientEvent('esx:showNotification', source, "Vec netko dostavlja!")
	end
end)