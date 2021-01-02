--[[

  ESX RP Chat

--]]

AddEventHandler('es:invalidCommandHandler', function(source, command_args, user)
	CancelEvent()
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', _U('unknown_command', command_args[1]) } })
end)

 AddEventHandler('chatMessage', function(source, name, message)
	  CancelEvent()
	  if string.sub(message, 1, string.len("/")) ~= "/" then
		  local playerName = GetPlayerName(source)
		  local msg = message
		  local imee = playerName
		  TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i>(OOC) {0}:<br> {1}</div>',
					args = { imee, msg }
	          })
	  end
  end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
