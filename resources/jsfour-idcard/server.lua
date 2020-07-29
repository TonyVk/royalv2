local ESX = nil

local LicensePrice = 200

-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Open ID card
RegisterServerEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function(ID, targetID, type)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height, lastdigits FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				if type ~= nil then
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' or licenses[i].type == 'dmv' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								show = true
							end
						elseif type =='osobna' then
							if licenses[i].type == 'osobna' then
								show = true
							end
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('jsfour-idcard:open', _source, array, type)
				else
					TriggerClientEvent('esx:showNotification', _source, "~b~Ti nemas tu dozvolu")
				end
			end)
		end
	end)
end)

RegisterServerEvent('osobna:dajlicencu')
AddEventHandler('osobna:dajlicencu', function ()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local identifier = ESX.GetPlayerFromId(_source).identifier
  local show       = false
  
  MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
		function (licenses)
			for i=1, #licenses, 1 do
				if licenses[i].type == 'osobna' then
					show = true
				end
			end

			if show then
				TriggerClientEvent('esx:showNotification', _source, "~b~Vec imate licnu kartu!")
			else
				if xPlayer.get('money') >= LicensePrice then
					xPlayer.removeMoney(LicensePrice)
					TriggerClientEvent('esx:showNotification', _source, "~b~Kupili ste licnu kartu za "..LicensePrice.."$")
					TriggerEvent('esx_license:addLicense', _source, 'osobna', function ()
					end)
				else
					TriggerClientEvent('esx:showNotification', _source, "Nemate dovoljno novca!")
				end
			end
  end)
end)
