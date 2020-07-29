Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(693292673058078740)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('hugologo')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('https://discord.gg/rAWxYmp')

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)