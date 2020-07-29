ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("NaplatiTuljana")
AddEventHandler("NaplatiTuljana", function(chargeAmount)
     local xPlayer        = ESX.GetPlayerFromId(source)
     xPlayer.removeMoney(chargeAmount)
     CancelEvent()
end)