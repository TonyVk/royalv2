

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




RegisterServerEvent("KCoke:get")
AddEventHandler("KCoke:get", function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	
		
				if xPlayer.getInventoryItem('coke').count < 20 then
					local randa = math.random(1,2)
					if xPlayer.getInventoryItem('coke').count+randa > 20 then
						xPlayer.addInventoryItem("coke", 1)
					else
						xPlayer.addInventoryItem("coke", randa)
					end
				else
					TriggerClientEvent('esx:showNotification', source, '~r~Ne mozete imati vise listova koke')
				end

			
end)

ESX.RegisterUsableItem('cocaine', function(source)
		--local xPlayer = ESX.GetPlayerFromId(source)
		--xPlayer.removeInventoryItem('cocaine', 1)
	
		TriggerClientEvent('esx_drogica:useItem', source, 'cocaine')

		Citizen.Wait(1000)
end)

ESX.RegisterServerCallback('esx_drogica:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_drogica:removeItem')
AddEventHandler('esx_drogica:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)
end)

function CancelProcessing(id)
	TriggerClientEvent('esx_drogica:removeEffect', id)
end

RegisterNetEvent('kokain:ProdajKoku')
AddEventHandler('kokain:ProdajKoku', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local naso = 0
	local cokecount = xPlayer.getInventoryItem('cocaine').count
	if cokecount > 0 then
		local cijena = cokecount*400
		xPlayer.removeInventoryItem('cocaine', cokecount)
		xPlayer.addMoney(cijena)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Prodali ste "..cokecount.."g kokaina za $"..cijena..".")
		naso = 1
	end
	if naso == 0 then
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Nemate kokaina za prodati!")
	end
end)

ESX.RegisterServerCallback('KCoke:process', function (source, cb)
	
	local _source = source
	
	local xPlayer  = ESX.GetPlayerFromId(_source)
			
			
				if xPlayer.getInventoryItem('coke').count >= 2 then
					xPlayer.removeInventoryItem('coke', 2) 
					xPlayer.addInventoryItem('cocaine', 1) 
					cb(true)
				else
				TriggerClientEvent('esx:showNotification', source, '~r~Nemate dosta listova')
				cb(false)
				end
			

end)



