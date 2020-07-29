RegisterCommand("youtube", function(source, args, rawCommandString)
	local test = rawCommandString
	test = string.gsub(test, "youtube ", "")
    TriggerClientEvent("playradio", source, test)
end, false)

RegisterCommand("twitch", function(source, args, rawCommandString)
	if args[1] ~= nil then
		local test = rawCommandString
		test = string.gsub(test, "twitch ", "")
		TriggerClientEvent("playtwitch", source, test)
	else
		TriggerClientEvent('chat:addMessage', source, {
		  color = { 255, 0, 0},
		  multiline = true,
		  args = {"SYSTEM", " /twitch [Ime kanala]"}
		})
	end
end, false)

RegisterCommand("youtubeall", function(source, args, rawCommandString)
	local Source = source
	local Vrati = 0
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available or user.getGroup() == "admin" then
				Vrati = 1
			else
				Vrati = 0
			end
		end)
	end)
	if Vrati == 1 then
		local test = rawCommandString
		test = string.gsub(test, "youtubeall ", "")
		TriggerClientEvent("playradio", -1, test)
	end
end, false)

RegisterCommand("twitchall", function(source, args, rawCommandString)
	local Source = source
	local Vrati = 0
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available or user.getGroup() == "admin" then
				Vrati = 1
			else
				Vrati = 0
			end
		end)
	end)
	if Vrati == 1 then
		local test = rawCommandString
		test = string.gsub(test, "twitchall ", "")
		TriggerClientEvent("playtwitch", -1, test)
	end
end, false)

RegisterCommand("youtubeoffall", function(source, args, rawCommandString)
    TriggerClientEvent("stopradio", -1)
end, false)

RegisterCommand("twitchoffall", function(source, args, rawCommandString)
    TriggerClientEvent("stoptwitch", -1)
end, false)

RegisterCommand("youtubeoff", function(source, args, rawCommandString)
    TriggerClientEvent("stopradio", source)
end, false)

RegisterCommand("twitchoff", function(source, args, rawCommandString)
    TriggerClientEvent("stoptwitch", source)
end, false)

RegisterCommand("youtubesakrij", function(source, args, rawCommandString)
    TriggerClientEvent("sakrijyoutube", source)
end, false)

RegisterCommand("youtubeprikazi", function(source, args, rawCommandString)
    TriggerClientEvent("prikaziyoutube", source)
end, false)

RegisterCommand("mp3", function(source, args, rawCommandString)
	local test = rawCommandString
	test = string.gsub(test, "mp3 ", "")
    TriggerClientEvent("playmp3", source, test)
end, false)

RegisterCommand("mp3all", function(source, args, rawCommandString)
	local Source = source
	local Vrati = 0
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available or user.getGroup() == "admin" then
				Vrati = 1
			else
				Vrati = 0
			end
		end)
	end)
	if Vrati == 1 then
		local test = rawCommandString
		test = string.gsub(test, "mp3all ", "")
		TriggerClientEvent("playmp3", -1, test)
	end
end, false)

RegisterCommand("twitchvol", function(source, args, rawCommandString)
	if args[1] ~= nil then
    TriggerClientEvent("voltwitch", source, args[1])
	else
	TriggerClientEvent('chat:addMessage', source, {
	  color = { 255, 0, 0},
	  multiline = true,
	  args = {"SYSTEM", " /voltwitch [0.0 - 1.0]"}
	})
	end
end, false)

RegisterCommand("mp3vol", function(source, args, rawCommandString)
	if args[1] ~= nil then
    TriggerClientEvent("volmp3", source, args[1])
	else
	TriggerClientEvent('chat:addMessage', source, {
	  color = { 255, 0, 0},
	  multiline = true,
	  args = {"SYSTEM", " /volmp3 [0.0 - 1.0]"}
	})
	end
end, false)

RegisterCommand("mp3offall", function(source, args, rawCommandString)
    TriggerClientEvent("stopmp3", -1)
end, false)

RegisterCommand("mp3off", function(source, args, rawCommandString)
    TriggerClientEvent("stopmp3", source)
end, false)