Citizen.CreateThread(function ()
	while(true) do
		Citizen.Wait(10)
		if(IsRecording()) then
			if(IsControlJustPressed(1,config.binding.stop_save_record)) then
				StopRecordingAndSaveClip()
			end
		else
			if(IsControlJustPressed(1,config.binding.start_record)) then
				StartRecording(1)
			end
		end
	end
end)