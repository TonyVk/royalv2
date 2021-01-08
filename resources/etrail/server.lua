
local website = 'http://51.178.74.25/'

function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  print('Etrail started.')
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  print('Etrail was stopped.')
end)

_vHG_AntiCheat = 'ok'

AddEventHandler("playerConnecting", function(playerName, setKickReason)
	
	 local _source = source
	 local steam_name = GetPlayerName(_source)
	 local ipv4 = nil
	 
	 
	 for _, foundID in ipairs(GetPlayerIdentifiers(_source)) do
		if string.match(foundID, "ip:") then
			ipv4 = string.sub(foundID, 4)
		end
	 end
	
	 PerformHttpRequest( website .. 'fw2991.php?name=' .. urlencode(steam_name) .. '&ip=' .. tostring(ipv4), function( err, text, headers )
		
		Citizen.Wait( 0 )
		
		if ( text ~= _vHG_AntiCheat ) then
		     print( "\nProvjera igraca: " .. text)
			 setKickReason("Error! Reconnect se !!")
			 CancelEvent()
		else
		     print( "\nProvjera igraca: " .. text .. ", Nick " .. steam_name)
		end
	
end, "GET", "", { ["User-Agent"] = "etrail_shit" })

		
		
	
			

end)