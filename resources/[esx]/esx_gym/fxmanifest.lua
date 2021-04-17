fx_version 'bodacious'
game 'gta5'

client_scripts {
    'gym_cl.lua',
    'gym_cfg.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'gym_sv.lua'
}