fx_version 'bodacious'
game 'gta5'


description 'ESX Drugs'

version '3.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'locales/fr.lua',
	'locales/hr.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/es.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/hr.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended'
}
