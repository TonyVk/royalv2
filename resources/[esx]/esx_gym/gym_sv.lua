ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_gym:DodajVjezbu')
AddEventHandler('esx_gym:DodajVjezbu', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	MySQL.Async.fetchAll(
      'SELECT vjezbanje, stamina FROM users WHERE identifier = @id',
      { ['@id'] = xPlayer.identifier },
      function(result)
		if result[1].vjezbanje+1 >= 30 then
			if result[1].stamina+1 <= 90 then
				MySQL.Async.execute('UPDATE users SET stamina = stamina+1, vjezbanje = 0 WHERE identifier = @id', {
					['@id'] = xPlayer.identifier
				})
				TriggerClientEvent("esx_gym:PovecajStaminu", _source, result[1].stamina+1)
			end
		else
			MySQL.Async.execute('UPDATE users SET vjezbanje = vjezbanje+1 WHERE identifier = @id', {
				['@id'] = xPlayer.identifier
			})
		end
      end
    )
end)

RegisterServerEvent('esx_gym:SpucajRouting')
AddEventHandler('esx_gym:SpucajRouting', function(br)
	local _source = source
	if br then
		SetPlayerRoutingBucket(_source, _source)
	else
		SetPlayerRoutingBucket(_source, 0)
	end
end)

ESX.RegisterServerCallback('esx_gym:DohvatiStaminu', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll(
		'SELECT stamina FROM users WHERE identifier = @id',
		{
		  ['@id'] = xPlayer.identifier
		},
		function(kurac)
		  cb(kurac[1].stamina)
		end
	)
end)