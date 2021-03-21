ESX = nil
local Grebalice = {}
local COruzje = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("prodajoruzje:Posalji")
AddEventHandler('prodajoruzje:Posalji', function(id, oruzje, cijena, ammo, pid)
	TriggerClientEvent("prodajoruzje:Saljem", id, oruzje, cijena, ammo, pid)
end)

RegisterNetEvent("prodajoruzje:PosaljiAdmOdgovor")
AddEventHandler('prodajoruzje:PosaljiAdmOdgovor', function(id, odg)
	local xPlayer = ESX.GetPlayerFromId(id)
	if xPlayer ~= nil then
		TriggerClientEvent("prodajoruzje:VratiAdmOdgovor", id, odg)
	else
		TriggerClientEvent('esx:showNotification', source, "Igrac nije online!")
	end
end)

RegisterNetEvent("prodajoruzje:TestSkinaa")
AddEventHandler('prodajoruzje:TestSkinaa', function(id)
	TriggerClientEvent("prodajoruzje:TestSkina", id)
end)

RegisterServerEvent("SpremiLog")
AddEventHandler("SpremiLog", function(tekst)
 filea = io.open("Logovi.txt", "a")
    if filea then
        filea:write(tekst.."\n")
		filea:close()
    end
end)

RegisterNetEvent("prodajoruzje:DajSkin")
AddEventHandler('prodajoruzje:DajSkin', function(id)
	TriggerClientEvent("prodajoruzje:EoTiSkinic", id)
end)

RegisterNetEvent("SaljiTamoSkin")
AddEventHandler('SaljiTamoSkin', function(id, pid)
	TriggerClientEvent("VratiTamoSkin", id, pid)
end)

RegisterNetEvent("ObrisiSociety")
AddEventHandler('ObrisiSociety', function(soc, broj)
	local xPlayer = ESX.GetPlayerFromId(source)
	local societyAccount = nil
	TriggerEvent('esx_addonaccount:getSharedAccount', soc, function(account)
		societyAccount = account
	end)
	if societyAccount ~= nil then
		societyAccount.removeMoney(broj)
		societyAccount.save()
	else
		xPlayer.showNotification("Unesena mafija ne postoji!")
	end
end)

RegisterNetEvent("EoTiSkinara")
AddEventHandler('EoTiSkinara', function(pid, modid, id)
	local retval = NetworkGetEntityFromNetworkId(pid)
	local str = "Server model: "..GetEntityModel(retval).." Mod ID igrac: "..modid
	TriggerClientEvent('chat:addMessage', id, { args = { '[TEST]', str } })
end)

ESX.RegisterUsableItem("petarde", function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem("petarde", 1)
	TriggerClientEvent('prodajoruzje:petarde', _source)
end)

ESX.RegisterUsableItem("ktijelo", function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local kc = xPlayer.getInventoryItem("kcijev").count
	local kk = xPlayer.getInventoryItem("kkundak").count
	local kt = xPlayer.getInventoryItem("ktijelo").count
	local cl = xPlayer.getInventoryItem("clip").count
	if kc > 0 and kk > 0 and kt > 0 and cl > 0 then
		COruzje[_source] = true
		TriggerClientEvent("esx_invh:closeinv", _source)
		TriggerClientEvent('prodajoruzje:SloziOruzje', _source, 0)
	else
		xPlayer.showNotification("Fali vam jedan od dijelova!")
	end
end)

ESX.RegisterUsableItem("ctijelo", function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local kc = xPlayer.getInventoryItem("ccijev").count
	local kk = xPlayer.getInventoryItem("ckundak").count
	local kt = xPlayer.getInventoryItem("ctijelo").count
	local cl = xPlayer.getInventoryItem("clip").count
	if kc > 0 and kk > 0 and kt > 0 and cl > 0 then
		COruzje[_source] = true
		TriggerClientEvent("esx_invh:closeinv", _source)
		TriggerClientEvent('prodajoruzje:SloziOruzje', _source, 1)
	else
		xPlayer.showNotification("Fali vam jedan od dijelova!")
	end
end)

ESX.RegisterUsableItem("stijelo", function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local kc = xPlayer.getInventoryItem("scijev").count
	local kk = xPlayer.getInventoryItem("skundak").count
	local kt = xPlayer.getInventoryItem("stijelo").count
	local cl = xPlayer.getInventoryItem("clip").count
	if kc > 0 and kk > 0 and kt > 0 and cl > 0 then
		COruzje[_source] = true
		TriggerClientEvent("esx_invh:closeinv", _source)
		TriggerClientEvent('prodajoruzje:SloziOruzje', _source, 2)
	else
		xPlayer.showNotification("Fali vam jedan od dijelova!")
	end
end)

ESX.RegisterUsableItem("smtijelo", function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local kc = xPlayer.getInventoryItem("smcijev").count
	local kk = xPlayer.getInventoryItem("smkundak").count
	local kt = xPlayer.getInventoryItem("smtijelo").count
	local cl = xPlayer.getInventoryItem("clip").count
	if kc > 0 and kk > 0 and kt > 0 and cl > 0 then
		COruzje[_source] = true
		TriggerClientEvent("esx_invh:closeinv", _source)
		TriggerClientEvent('prodajoruzje:SloziOruzje', _source, 3)
	else
		xPlayer.showNotification("Fali vam jedan od dijelova!")
	end
end)

ESX.RegisterUsableItem("grebalica", function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local oprema = xPlayer.getInventoryItem("grebalica").count
	if oprema > 0 then
		TriggerClientEvent("esx_invh:closeinv", _source)
		Grebalice[_source] = true
		xPlayer.removeInventoryItem("grebalica", 1)
		TriggerClientEvent('prodajoruzje:grebalica', _source)
	else
		xPlayer.showNotification("Fali vam jedan od dijelova!")
	end
end)

RegisterNetEvent("prodajoruzje:KoiKuracJeOvo")
AddEventHandler('prodajoruzje:KoiKuracJeOvo', function(br)
	local src = source
	if Grebalice[src] then
		local xPlayer = ESX.GetPlayerFromId(src)
		if br == 19 then
			xPlayer.addMoney(10)
		elseif br == 25 then
			xPlayer.addMoney(5)
		elseif br == 30 then
			xPlayer.addMoney(500)
		elseif br == 35 then
			xPlayer.addMoney(25)
		elseif br == 40 then
			xPlayer.addMoney(50)
		elseif br == 33 then
			xPlayer.addInventoryItem("burek", 1)
		elseif br == 37 then
			xPlayer.addInventoryItem("kola", 1)
		end
		Grebalice[src] = false
	else
		TriggerEvent("DiscordBot:Anticheat", GetPlayerName(src).."["..src.."] je pokusao pozvati event za nagradu grebalice, a nije iskoristio grebalicu!")
	    TriggerEvent("AntiCheat:Citer", src)
	end
end)

RegisterNetEvent("prodajoruzje:KoiKuracJeOvo2")
AddEventHandler('prodajoruzje:KoiKuracJeOvo2', function(br)
	local src = source
	if COruzje[src] then
		local xPlayer = ESX.GetPlayerFromId(src)
		if br == 0 then
			xPlayer.removeInventoryItem("kcijev", 1)
			xPlayer.removeInventoryItem("kkundak", 1)
			xPlayer.removeInventoryItem("ktijelo", 1)
			xPlayer.removeInventoryItem("clip", 1)
			xPlayer.addWeapon("weapon_assaultrifle", 250)
		elseif br == 1 then
			xPlayer.removeInventoryItem("ccijev", 1)
			xPlayer.removeInventoryItem("ckundak", 1)
			xPlayer.removeInventoryItem("ctijelo", 1)
			xPlayer.removeInventoryItem("clip", 1)
			xPlayer.addWeapon("weapon_carbinerifle", 250)
		elseif br == 2 then
			xPlayer.removeInventoryItem("scijev", 1)
			xPlayer.removeInventoryItem("skundak", 1)
			xPlayer.removeInventoryItem("stijelo", 1)
			xPlayer.removeInventoryItem("clip", 1)
			xPlayer.addWeapon("weapon_specialcarbine", 250)
		elseif br == 3 then
			xPlayer.removeInventoryItem("smcijev", 1)
			xPlayer.removeInventoryItem("smkundak", 1)
			xPlayer.removeInventoryItem("smtijelo", 1)
			xPlayer.removeInventoryItem("clip", 1)
			xPlayer.addWeapon("weapon_smg", 250)
		end
		COruzje[src] = false
	else
		TriggerEvent("DiscordBot:Anticheat", GetPlayerName(src).."["..src.."] je pokusao pozvati event za craft oruzja, a nije iskoristio dijelove!")
	    TriggerEvent("AntiCheat:Citer", src)
	end
end)

ESX.RegisterServerCallback('kraft:ProvjeriKolicinu', function(source, cb, item)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local morel = false
	if xPlayer.getInventoryItem(item).count+1 <= xPlayer.getInventoryItem(item).limit then
		if item == "kkundak"then
			if xPlayer.getInventoryItem("iron").count >= 5 then
				xPlayer.removeInventoryItem("iron", 5)
				morel = true
				COruzje[src] = true
			end
		elseif item == "ckundak"then
			if xPlayer.getInventoryItem("iron").count >= 10 then
				xPlayer.removeInventoryItem("iron", 10)
				morel = true
				COruzje[src] = true
			end
		elseif item == "skundak"then
			if xPlayer.getInventoryItem("iron").count >= 15 then
				xPlayer.removeInventoryItem("iron", 15)
				morel = true
				COruzje[src] = true
			end
		elseif item == "smkundak"then
			if xPlayer.getInventoryItem("iron").count >= 4 then
				xPlayer.removeInventoryItem("iron", 4)
				morel = true
				COruzje[src] = true
			end
		end
	end
	cb(morel)
end)

ESX.RegisterServerCallback('kraft:ProvjeriKolicinu2', function(source, cb, item)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local morel = false
	if xPlayer.getInventoryItem(item).count+1 <= xPlayer.getInventoryItem(item).limit then
		if item == "kcijev"then
			if xPlayer.getMoney() >= 5000 then
				xPlayer.removeMoney(5000)
				xPlayer.addInventoryItem("kcijev", 1)
				morel = true
			end
		elseif item == "ccijev"then
			if xPlayer.getMoney() >= 6000 then
				xPlayer.removeMoney(6000)
				xPlayer.addInventoryItem("ccijev", 1)
				morel = true
			end
		elseif item == "scijev"then
			if xPlayer.getMoney() >= 7000 then
				xPlayer.removeMoney(7000)
				xPlayer.addInventoryItem("scijev", 1)
				morel = true
			end
		elseif item == "smcijev"then
			if xPlayer.getMoney() >= 4000 then
				xPlayer.removeMoney(4000)
				xPlayer.addInventoryItem("smcijev", 1)
				morel = true
			end
		end
	end
	cb(morel)
end)

local skupljanje = vector3(59.282123565674, -774.98114013672, 17.823108673096)
RegisterNetEvent("kraft:SkupiGa")
AddEventHandler('kraft:SkupiGa', function()
	local src = source
	local koord = GetEntityCoords(GetPlayerPed(src))
	if #(koord-skupljanje) <= 15.0 then
		local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getInventoryItem("iron").count+1 <= xPlayer.getInventoryItem("iron").limit then
		     xPlayer.addInventoryItem("iron", 1)
        else
			xPlayer.showNotification("Ne stane vam vise u inventory")
		end
	else
		TriggerEvent("DiscordBot:Anticheat", GetPlayerName(src).."["..src.."] je pokusao pozvati event za dobijanje zeljeza, a nije blizu lokacije skupljanja!")
	    TriggerEvent("AntiCheat:Citer", src)
	end
end)

RegisterNetEvent("kraft:DajKundak")
AddEventHandler('kraft:DajKundak', function(item)
	local src = source
	if COruzje[src] then
		local xPlayer = ESX.GetPlayerFromId(src)
		xPlayer.addInventoryItem(item, 1)
		COruzje[src] = false
	else
		TriggerEvent("DiscordBot:Anticheat", GetPlayerName(src).."["..src.."] je pokusao pozvati event za preradu zeljeza u kundak, a nije zapoceo sa preradom!")
	    --TriggerEvent("AntiCheat:Citer", src)
	end
end)

ESX.RegisterUsableItem("petarda", function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem("petarda", 1)
	TriggerClientEvent('prodajoruzje:petarde', _source)
end)

ESX.RegisterServerCallback('prodajoruzje:DajNovac', function(source, cb, target)
	local tar = ESX.GetPlayerFromId(target)
	local missingMoney = tar.getMoney()
	cb(missingMoney)
end)

function mTOh(mins)
    return {sat = math.floor(mins/60), minuta = (mins%60)}
end

ESX.RegisterServerCallback('minute:DohvatiSate', function(source, cb)
	local elements = {}
	MySQL.Async.fetchAll('SELECT identifier, minute FROM minute ORDER BY minute DESC', {}, function(result)
		MySQL.Async.fetchAll('SELECT identifier, name FROM users', {}, function(result2)
			for i=1, #result, 1 do
				for j=1, #result2, 1 do
					if result[i].identifier == result2[j].identifier then
						local str
						local ime = "Glupo ime"
						if result[i].minute < 60 then
							if result2[j].name ~= nil then
								str = result2[j].name.." ("..result[i].minute.." minuta)"
							else
								str = ime.." ("..result[i].minute.." minuta)"
							end
						else
							if result2[j].name ~= nil then
								str = result2[j].name.." ("..mTOh(result[i].minute).sat.."h i "..mTOh(result[i].minute).minuta.."min)"
							else
								str = ime.." ("..mTOh(result[i].minute).sat.."h i "..mTOh(result[i].minute).minuta.."min)"
							end
						end
						table.insert(elements, { label = str, value = "nema" })
					end
				end
			end
			cb(elements)
		end)
	end)
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
			
		}
	else
		return nil
	end
end

function CronTask(d, h, m)
	local dan = os.date("%d")
	if dan == "01" then
		MySQL.Async.execute('DELETE FROM minute', {})
	end
end
TriggerEvent('cron:runAt', 0, 0, CronTask)

RegisterNetEvent("minute:SpremiIh")
AddEventHandler('minute:SpremiIh', function(minute)
	local src = source
	local identifier = GetPlayerIdentifiers(src)[1]
	MySQL.Async.fetchAll('SELECT minute FROM minute WHERE identifier = @identifier', {['@identifier'] = identifier}, function(result)
		if result[1] == nil then
			MySQL.Async.execute('INSERT INTO minute (identifier, minute) VALUES (@ident, @mina)',
			{
				['@ident'] = identifier,
				['@mina']  = 5
			})
		else
			MySQL.Async.execute('UPDATE minute SET minute = @minute WHERE identifier = @ident', {
				['@ident'] = identifier,
				['@minute'] = result[1].minute+5
			})
		end
	end)
end)

--[[ESX.RegisterUsableItem('ronjenje', function(source)
	print(GetPlayerPed(source))
	local xPlayer = ESX.GetPlayerFromId(source)
	local oprema = xPlayer.getInventoryItem("ronjenje").count
	if oprema > 0 then
		TriggerClientEvent('ronjenje:PocniRonit', source)
	else
		xPlayer.showNotification("Nemate opremu za ronjenje!")
	end
end)]]
	
RegisterCommand("prebacimodele", function(source, args, rawCommandString)
	MySQL.Async.fetchAll("SELECT vehicle, state, plate FROM owned_vehicles",{}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			MySQL.Async.execute('UPDATE owned_vehicles SET model = @mod WHERE plate = @tab', {
				['@mod']   = vehicle.model,
				['@tab']   = vehicle.plate,
			}, function(rowsChanged)
				print(rowsChanged)
			end)
		end
	end)
end, false)

RegisterCommand("ispisip", function(source, args, rawCommandString)
		local elements = {}
		MySQL.Async.fetchAll('SELECT identifier FROM priority', {}, function(result)
			MySQL.Async.fetchAll('SELECT identifier, name FROM users', {}, function(result2)
				for i=1, #result, 1 do
					for j=1, #result2, 1 do
						if result[i].identifier == result2[j].identifier then
							print("identifier:"..result2[j].identifier.." | Ime:"..result2[j].name)
						end
					end
				end
			end)
		end)
end, false)

RegisterCommand("svilideri", function(source, args, rawCommandString)
		local elements = {}
		MySQL.Async.fetchAll('SELECT name, job, job_grade FROM users', {}, function(result)
			MySQL.Async.fetchAll('SELECT job_name, grade, name FROM job_grades', {}, function(result2)
				for i=1, #result, 1 do
					for j=1, #result2, 1 do
						if result[i].job == result2[j].job_name then
							if result[i].job_grade == result2[j].grade then
								if result2[j].name == "boss" then
									local str = result[i].name.." ["..result[i].job.."]"
									table.insert(elements, { label = str, value = result[i].job })
								end
							end
						end
					end
				end
			end)
		end)
		Wait(3000)
		TriggerClientEvent("prodajoruzje:PokaziSveLidere", source, elements)
end, false)

RegisterCommand("lideri", function(source, args, rawCommandString)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local elements = {}

		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do

		  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		  if xPlayer.job.name ~= nil then
			  local gradeLabel = xPlayer.job.grade_name
			  local job = xPlayer.job.name
			  if gradeLabel == "boss" or gradeLabel == "vlasnik" then
				  local str = xPlayer.getName().." ["..job.."]"
				  table.insert(elements, { label = str, value = gradeLabel })
			  end
		  end
		end
		TriggerClientEvent("prodajoruzje:PokaziLidere", source, elements)
end, false)

RegisterCommand("clanovi", function(source, args, rawCommandString)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local elements = {}

		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do

		  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		  if xPlayer ~= nil then
			  if xPlayer.job.name == sourceXPlayer.job.name then
				local gradeLabel = (xPlayer.job.grade_label == '' and xPlayer.job.label or xPlayer.job.grade_label)
				local ime = "Glupo ime"
				local str
				if xPlayer.getName() == nil then
					str = str.." ["..gradeLabel.."]"
				else
					str = xPlayer.getName().." ["..gradeLabel.."]"
				end
				table.insert(elements, { label = str, value = gradeLabel })
			  end
		  end
		end
		TriggerClientEvent("prodajoruzje:PokaziClanove", source, elements)
end, false)

RegisterCommand("r", function(source, args, rawCommandString)
	local br = 0
	local targetXPlayer = ESX.GetPlayerFromId(source)
	if targetXPlayer.job.name == 'police' or targetXPlayer.job.name == 'mechanic' then
		br = 1
	end
	if br == 1 then
				if args[1] ~= nil then
					local name = getIdentity(source)
		 		 	local fal = name.firstname .. " " .. name.lastname
					TriggerClientEvent("prodajoruzje:PosaljiRadio", -1, table.concat(args, " "), fal, targetXPlayer.job.name)
				else
					name = "System"..":"
					message = "/r [Poruka]"
					TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })
				end	
	else
		name = "System"..":"
		message = " Nemate pristup ovoj komandi"
		TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })	
	end
end, false)

RegisterNetEvent('prodajoruzje:PosaljiRadio2Server')
AddEventHandler('prodajoruzje:PosaljiRadio2Server', function(arg, ime)
	TriggerClientEvent("prodajoruzje:PosaljiRadio2", -1, arg, ime)
end) 

RegisterNetEvent('prodajoruzje:SaljiInfoSvima')
AddEventHandler('prodajoruzje:SaljiInfoSvima', function(arg, ime, id)
	local ime2 = GetPlayerName(id)
	TriggerClientEvent("prodajoruzje:VratiInfoSvima", -1, arg, ime, ime2)
end) 

RegisterNetEvent("prodajoruzje:Posalji2")
AddEventHandler('prodajoruzje:Posalji2', function(id, cijena, kol, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local kola = sourceXPlayer.getInventoryItem("marijuana").count
	if kola >= tonumber(kol) then
		TriggerClientEvent('esx:showNotification', pid, "Ponudili ste igracu drogu!")
		TriggerClientEvent("prodajoruzje:Saljem2", id, cijena, kol, pid)
	else
		TriggerClientEvent('esx:showNotification', pid, "Nemate dovoljnu kolicinu marihuane!")
	end
end)

RegisterNetEvent("prodajoruzje:Posalji3")
AddEventHandler('prodajoruzje:Posalji3', function(id, cijena, kol, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local kola = sourceXPlayer.getInventoryItem("cocaine").count
	if kola >= tonumber(kol) then
		TriggerClientEvent('esx:showNotification', pid, "Ponudili ste igracu kokain!")
		TriggerClientEvent("prodajoruzje:Saljem3", id, cijena, kol, pid)
	else
		TriggerClientEvent('esx:showNotification', pid, "Nemate dovoljnu kolicinu kokaina!")
	end
end)

RegisterNetEvent("dajpro:oruzje")
AddEventHandler('dajpro:oruzje', function(id, oruzje, cijena, ammo, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	if targetXPlayer.getMoney() >= tonumber(cijena) then
	--if not targetXPlayer.hasWeapon(oruzje) then
			sourceXPlayer.removeWeapon(oruzje)
			targetXPlayer.addWeapon(oruzje, ammo)
			sourceXPlayer.addMoney(cijena/2)
			targetXPlayer.removeMoney(cijena)
			ESX.SavePlayer(sourceXPlayer, function()
			end)
			ESX.SavePlayer(targetXPlayer, function()
			end)
			local societyAccount = nil
			local sime = "society_"..sourceXPlayer.getJob().name
			TriggerEvent('esx_addonaccount:getSharedAccount', sime, function(account)
				societyAccount = account
			end)
			societyAccount.addMoney(cijena/2)
			societyAccount.save()

			local weaponLabel = ESX.GetWeaponLabel(oruzje)
			local str = "Uspjesno ste prodali oruzje "..weaponLabel.." sa "..ammo.." metaka!"
			local str2 = "Uspjesno ste kupili oruzje "..weaponLabel.." sa "..ammo.." metaka!"
			local strm = "Uspjesno ste prodali oruzje "..weaponLabel.." bez metaka!"
			local str2m = "Uspjesno ste kupili oruzje "..weaponLabel.." bez metaka!"
			local str3 = "Pola od cijene ste dobili vi, a druga polovica je otisla bandi na racun!"
			if ammo > 0 then
				TriggerClientEvent('esx:showNotification', pid, str)
				TriggerClientEvent('esx:showNotification', id,  str2)
				TriggerClientEvent('esx:showNotification', pid,  str3)
			else
				TriggerClientEvent('esx:showNotification', pid, strm)
				TriggerClientEvent('esx:showNotification', id,  str2m)
				TriggerClientEvent('esx:showNotification', pid,  str3)
			end
	--else
		--TriggerClientEvent('esx:showNotification', pid, "Osoba vec ima to oruzje!")
		--TriggerClientEvent('esx:showNotification', id, "Vec imate to oruzje!")
	--end
	else
		TriggerClientEvent('esx:showNotification', pid, "Osoba nema dovoljno novca!")
		TriggerClientEvent('esx:showNotification', id, "Nemate dovoljno novca!")
	end
end)

RegisterNetEvent("dajpro:oruzje2")
AddEventHandler('dajpro:oruzje2', function(id, cijena, kol, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	local kola = targetXPlayer.getInventoryItem("marijuana").count
	local maximum = tonumber(kol)+kola
	if maximum <= 14 then
		if targetXPlayer.getMoney() >= tonumber(cijena) then
			sourceXPlayer.removeInventoryItem("marijuana", kol)
			targetXPlayer.addInventoryItem("marijuana", kol)
			sourceXPlayer.addMoney(cijena/2)
			targetXPlayer.removeMoney(cijena)
			ESX.SavePlayer(sourceXPlayer, function()
			end)
			ESX.SavePlayer(targetXPlayer, function()
			end)
			
			local societyAccount = nil
			local sime = "society_"..sourceXPlayer.getJob().name
			TriggerEvent('esx_addonaccount:getSharedAccount', sime, function(account)
				societyAccount = account
			end)
			societyAccount.addMoney(cijena/2)
			societyAccount.save()

			local str = "Uspjesno ste prodali "..kol.."g marihuane!"
			local str2 = "Uspjesno ste kupili "..kol.."g marihuane!"
			local str3 = "Pola od cijene ste dobili vi, a druga polovica je otisla bandi na racun!"

			TriggerClientEvent('esx:showNotification', pid, str)
			TriggerClientEvent('esx:showNotification', id,  str2)
			TriggerClientEvent('esx:showNotification', pid,  str3)
		else
			TriggerClientEvent('esx:showNotification', pid, "Osoba nema dovoljno novca!")
			TriggerClientEvent('esx:showNotification', id, "Nemate dovoljno novca!")
		end
	else
		TriggerClientEvent('esx:showNotification', pid, "Osoba ce imati tada vise droge od dozvoljenoga!")
		TriggerClientEvent('esx:showNotification', id, "Imat cete vise droge od dozvoljenoga(max 14g)!")
	end
end)

RegisterNetEvent("dajpro:oruzje3")
AddEventHandler('dajpro:oruzje3', function(id, cijena, kol, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	local kola = targetXPlayer.getInventoryItem("cocaine").count
	local maximum = tonumber(kol)+kola
	if maximum <= 10 then
		if targetXPlayer.getMoney() >= tonumber(cijena) then
			sourceXPlayer.removeInventoryItem("cocaine", kol)
			targetXPlayer.addInventoryItem("cocaine", kol)
			sourceXPlayer.addMoney(cijena)
			targetXPlayer.removeMoney(cijena)
			ESX.SavePlayer(sourceXPlayer, function()
			end)
			ESX.SavePlayer(targetXPlayer, function()
			end)

			local str = "Uspjesno ste prodali "..kol.."g kokaina!"
			local str2 = "Uspjesno ste kupili "..kol.."g kokaina!"

			TriggerClientEvent('esx:showNotification', pid, str)
			TriggerClientEvent('esx:showNotification', id,  str2)
		else
			TriggerClientEvent('esx:showNotification', pid, "Osoba nema dovoljno novca!")
			TriggerClientEvent('esx:showNotification', id, "Nemate dovoljno novca!")
		end
	else
		TriggerClientEvent('esx:showNotification', pid, "Osoba ce tada imati vise kokaina od dozvoljenoga!")
		TriggerClientEvent('esx:showNotification', id, "Imat cete vise kokaina od dozvoljenoga(max 10g)!")
	end
end)
