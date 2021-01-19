ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_lov:dajtuljana')
AddEventHandler('esx_lov:dajtuljana', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	
	local AnimalWeight = math.random(10, 160) / 10

	xPlayer.showNotification('Raskomadali ste zivotinju i dobili ' ..AnimalWeight.. 'kg mesa!')
	
    if Weight >= 1 then
        xPlayer.addInventoryItem('meso', 1)
    elseif Weight >= 9 then
        xPlayer.addInventoryItem('meso', 2)
    elseif Weight >= 15 then
        xPlayer.addInventoryItem('meso', 3)
    end

    xPlayer.addInventoryItem('koza', math.random(1, 4))
end)

RegisterServerEvent('esx_lov:prodajtuljana')
AddEventHandler('esx_lov:prodajtuljana', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local MeatPrice = 125
    local LeatherPrice = 25

    local MeatQuantity = xPlayer.getInventoryItem('meso').count
    local LeatherQuantity = xPlayer.getInventoryItem('koza').count

    if MeatQuantity > 0 or LeatherQuantity > 0 then
        xPlayer.addMoney(MeatQuantity * MeatPrice)
        xPlayer.addMoney(LeatherQuantity * LeatherPrice)

        xPlayer.removeInventoryItem('meso', MeatQuantity)
        xPlayer.removeInventoryItem('koza', LeatherQuantity)
		xPlayer.showNotification('Prodali ste '..LeatherQuantity..'kg kože i '..MeatQuantity..'kg mesa, te zaradili $'..LeatherPrice * LeatherQuantity + MeatPrice * MeatQuantity..'!')
    else
		xPlayer.showNotification('Nemate kože i mesa!')
    end  
end)

ESX.RegisterServerCallback('ex_lov:ImasLiLove', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 250 then
		xPlayer.removeMoney(250)
		cb(true)
	else
		cb(false)
	end
end)