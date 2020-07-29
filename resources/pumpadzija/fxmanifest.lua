fx_version 'bodacious'
game 'gta5'


name 'TaerAttO LegacyFuel'
description 'Legacy Fuel version modifier By TaerAttO'
author 'InZidiuZ modifier By TaerAttO'
version '1.3.0'
url 'https://discord.io/secretTH'


server_scripts {
	'config.lua',
	'source/fuel_server.lua'
}

client_scripts {
	'config.lua',
	'functions/functions_client.lua',
	'source/fuel_client.lua'
}

exports {
	'GetFuel',
	'SetFuel'
}
