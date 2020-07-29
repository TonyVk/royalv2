RegisterCommand("cam", function(source, args, raw)
    local src = source
    TriggerClientEvent("Cam:ToggleCam", src)
end)

RegisterCommand("bmic", function(source, args, raw)
    local src = source
    TriggerClientEvent("Mic:ToggleBMic", src)
end)

RegisterCommand("mic", function(source, args, raw)
    local src = source
    TriggerClientEvent("Mic:ToggleMic", src)
end)

RegisterNetEvent("PrebaciIDKamere")
AddEventHandler("PrebaciIDKamere", function(id)
    TriggerClientEvent("EoTiIDKamere", -1, id)
end)

RegisterNetEvent("PosaljiZoom")
AddEventHandler("PosaljiZoom", function(nest)
    TriggerClientEvent("VratiZoom", -1, nest)
end)

RegisterNetEvent("SaljiRotaciju")
AddEventHandler("SaljiRotaciju", function(x,z)
    TriggerClientEvent("VratiRotaciju", -1, x, z)
end)
