fx_version 'bodacious'
game 'gta5'

client_scripts {
	'config.lua',
  'utils.lua',
	'client.lua',
}

server_scripts {	
  '@mysql-async/lib/MySQL.lua',
	'config.lua',
  'utils.lua',
	'server.lua',
}

files {
  'LockPick1.png',
  'LockPick2.png',
  'LockPick3.png',
}