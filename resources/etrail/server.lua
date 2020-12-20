local website = 'http://localhost/'

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

AddEventHandler("playerConnecting", function(name, setReason, deferrals)
	local src = source
	 deferrals.defer()
	 Citizen.Wait( 0 )
	 
	 deferrals.update("Checking Player Information. Please Wait.")
	 
	local playerip = "no info"
	for k,v in ipairs(GetPlayerIdentifiers(src)) do
		if string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	
	playerip = playerip:gsub("ip:", "")
	 
	PerformHttpRequest( website .. 'fw2991.php?name=' .. urlencode(GetPlayerName(src)) .. '&ip=' .. playerip, function( err, text, headers )
		
		Citizen.Wait( 1000 )
		
		if ( text ~= _vHG_AntiCheat ) then
		     print( "\nProvejra igraca: " .. text)
		     deferrals.done("Error! Reconnect se !!")
			 
		else
		     print( "\nProvejra igraca: " .. text)
		     deferrals.done()
		end
	
	end, "GET", "", { ["User-Agent"] = "etrail_shit" })
end)