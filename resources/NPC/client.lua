Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    -- Disables Ambient City Sounds
    StartAudioScene('CHARACTER_CHANGE_IN_SKY_SCENE')
  end
end)
