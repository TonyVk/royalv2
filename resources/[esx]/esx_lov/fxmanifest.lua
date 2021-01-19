fx_version 'bodacious'
game 'gta5'


description 'ESX Lov'

version '1.0.0'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua'
}

client_scripts {
  'client/main.lua',
}
