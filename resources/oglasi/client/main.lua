local Prikazi = false

RegisterCommand("oglasi", function(source, args, rawCommandString)
	SendNUIMessage({
		prikazi = true
	})
	if Prikazi == false then
		SetNuiFocus(true, true)
		Prikazi = true
	else
		SetNuiFocus(false)
		Prikazi = false
	end
end, false)

RegisterNetEvent("oglasi:PrikaziNui")
AddEventHandler("oglasi:PrikaziNui", function(marka, model, cijena, br)
	SendNUIMessage({
			salji = true,
			marka = marka,
			model = model,
			cijena = cijena,
			broj = br
	})
end)

RegisterNUICallback(
    "zovi",
    function(data, cb)
        TriggerEvent("gcphone:autoCallNumber", { number = data.br })
		SetNuiFocus(false)
		Prikazi = false
		SendNUIMessage({
			prikazi = true
		})
		cb("ok")
    end
)

RegisterNUICallback(
    "zatvori",
    function()
		SetNuiFocus(false)
		Prikazi = false
		SendNUIMessage({
			prikazi = true
		})
    end
)