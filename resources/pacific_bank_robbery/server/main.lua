--  ESX Service
local a=nil
local b={}
local Vrijeme = nil
local Banka = nil
local copsConnected 		= 0
TriggerEvent('esx:getSharedObject',function(c)a=c end)

a.RegisterServerCallback("pacific_bank_robbery:getCurrentRobbery",function(source,d)
	d(b)
end)

RegisterNetEvent('esx_pljacke:Broji')
AddEventHandler('esx_pljacke:Broji', function()
	local xPlayer = a.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'sipa' then
		copsConnected = copsConnected+1
	end
end)

a.RegisterServerCallback("pacific_bank_robbery:fetchCops",function(source,d)
	d(copsConnected>=Config.CopsNeeded)
end)


RegisterServerEvent("pacific_bank_robbery:globalEvent")
AddEventHandler("pacific_bank_robbery:globalEvent",function(i)
	if type(i["data"])=="table"then 
		if i["data"]["save"]then 
			b[i["data"]["bank"]]={["started"]=os.time(),["robber"]=source,["trolleys"]=i["data"]["trolleys"]}
		end 
	end
	TriggerClientEvent("pacific_bank_robbery:eventHandler",-1,i["event"]or"none",i["data"]or nil)
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
	local h=a.GetPlayerFromId(source)
	if h then 
		local j=math.random(Config.Trolley["cash"][1],Config.Trolley["cash"][2])
		if Config.BlackMoney then 
			h.addAccountMoney('black_money',j)
			TriggerClientEvent("esx:showNotification",source,"You received~r~~n~"..j.."~s~$ ~r~dirty money")
		else 
			h.addMoney(j)
			TriggerClientEvent("esx:showNotification",source,"Uzeli ste~g~ "..j.."~s~$")
		end 
	end 
end)

RegisterServerEvent('OtvoriVrata')
AddEventHandler('OtvoriVrata',function(k)
	TriggerClientEvent('OtvoriVrataa',-1,k)
end)

RegisterServerEvent('pacific_bank_robbery:bazsho')
AddEventHandler('pacific_bank_robbery:bazsho',function(k,l,m,n,o)
	TriggerClientEvent('pacific_bank_robbery:bazshodan',-1,k,l,m,n,o)
end)


RegisterServerEvent('pacific_bank_robbery:kashtan')
AddEventHandler('pacific_bank_robbery:kashtan',function(p,q)
	local r=a.GetPlayerFromId(source)
	r.removeInventoryItem("thermite",1)
	TriggerClientEvent('pacific_bank_robbery:terkidan',-1,p,q)
end)


a.RegisterUsableItem('thermite',function(source)
	TriggerClientEvent('pacific_bank_robbery:estefade_az_item',source)
end)
