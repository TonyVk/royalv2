fx_version 'bodacious'
game 'gta5'


description 'ESX Contract'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/hr.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/hr.lua',
	'config.lua',
	'client/main.lua'
}