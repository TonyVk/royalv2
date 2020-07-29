fx_version 'bodacious'
game 'gta5'


--dependency 'MenuAPI'

files {
	--'@MenuAPI/MenuAPI.dll',
	'MenuAPI.dll',
	'config.ini'
}

client_scripts {
	'VStancer.Client.net.dll'
}

export 'SetVstancerPreset'
export 'GetVstancerPreset'