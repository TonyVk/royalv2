fx_version 'bodacious'
game 'gta5'


description 'MySQL plugin for ES'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

dependencies {
	'essentialmode',
	'mysql-async'
}