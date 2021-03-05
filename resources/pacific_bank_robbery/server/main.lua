--  ESX Service
local a=nil
local b={}
local Vrijeme = nil
local Banka = nil
local copsConnected 		= 0
TriggerEvent('esx:getSharedObject',function(c)a=c end)

a.RegisterServerCallback("vbanka:getCurrentRobbery",function(source,d)
	d(b)
end)

RegisterNetEvent('esx_pljacke:Broji')
AddEventHandler('esx_pljacke:Broji', function()
	local xPlayer = a.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'sipa' then
		copsConnected = copsConnected+1
	end
end)

a.RegisterServerCallback("vbanka:fetchCops",function(source,d)
	d(copsConnected>=Config.CopsNeeded)
end)


RegisterServerEvent("vbanka:globalEvent")
AddEventHandler("vbanka:globalEvent",function(i)
	if type(i["data"])=="table"then 
		if i["data"]["save"]then 
			b[i["data"]["bank"]]={["started"]=os.time(),["robber"]=source,["trolleys"]=i["data"]["trolleys"]}
		end 
	end
	TriggerClientEvent("vbanka:eventHandler",-1,i["event"]or"none",i["data"]or nil)
end)

RegisterServerEvent("SaljiDelay")
AddEventHandler("SaljiDelay",function(i)
	Vrijeme = 180
	Banka = i
	Citizen.CreateThread(function()
		while true do
			if Vrijeme ~= nil then
				Citizen.Wait(60000)
				Vrijeme = Vrijeme -1
				if Vrijeme <= 0 then
					Vrijeme = nil
					b = {}
					TriggerClientEvent("ZatvoriVrata", -1, Banka)
					Banka = nil
				end
			end
			Citizen.Wait(1)
		end
	end)
end)

RegisterServerEvent("glavnabanka:DajTuljane")
AddEventHandler("glavnabanka:DajTuljane",function()
	local src = source
	local h=a.GetPlayerFromId(src)
	if h then
		local B=GetEntityCoords(GetPlayerPed(src))
		local J=#(B-Config.Bank["Principal Bank"]["start"]["pos"])
		if J<=20.0 then
			local j=math.random(Config.Trolley["cash"][1],Config.Trolley["cash"][2])
			if Config.BlackMoney then 
				h.addAccountMoney('black_money',j)
				TriggerClientEvent("esx:showNotification",source,"You received~r~~n~"..j.."~s~$ ~r~dirty money")
			else 
				h.addMoney(j)
				TriggerClientEvent("esx:showNotification",source,"Uzeli ste~g~ "..j.."~s~$")
				local por = "["..os.date("%X").."] ("..GetCurrentResourceName()..") Igrac "..GetPlayerName(source).."("..h.identifier..") je dobio $"..j
				TriggerEvent("SpremiLog", por)
			end 
		else
			TriggerEvent("DiscordBot:Anticheat", GetPlayerName(src).."["..src.."] je pokusao pozvati event za novac glavne banke, a nije u glavnoj banci!")
			TriggerEvent("AntiCheat:Citer", src)
		end
	end 
end)

RegisterServerEvent('OtvoriVrata')
AddEventHandler('OtvoriVrata',function(k)
	TriggerClientEvent('OtvoriVrataa',-1,k)
end)

RegisterServerEvent('vbanka:bazsho')
AddEventHandler('vbanka:bazsho',function(k,l,m,n,o)
	TriggerClientEvent('vbanka:bazshodan',-1,k,l,m,n,o)
end)


RegisterServerEvent('vbanka:kashtan')
AddEventHandler('vbanka:kashtan',function(p,q)
	local r=a.GetPlayerFromId(source)
	local quantity = r.getInventoryItem('thermite').count
	if quantity >= 1 then
		r.removeInventoryItem("thermite",1)
		TriggerClientEvent('vbanka:terkidan',-1,p,q)
	end
end)


a.RegisterUsableItem('thermite',function(source)
	local r=a.GetPlayerFromId(source)
	local quantity = r.getInventoryItem('thermite').count
	if quantity >= 1 then
		TriggerClientEvent('vbanka:estefade_az_item',source)
	end
end)
