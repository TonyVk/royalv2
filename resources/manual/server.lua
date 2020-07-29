ESX              = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('mjenjac:ProvjeriVozilo', function(source, cb, vehicleplate)
    MySQL.Async.fetchAll(
        'SELECT mjenjac FROM owned_vehicles WHERE plate = @pl',
        {
            ['@pl'] = vehicleplate
        },
        function(result)
            if result[1] ~= nil then
                cb(result[1].mjenjac)
			else
				cb(0)
            end
    end)
end)