fx_version 'bodacious'
game 'gta5'


client_script "client.lua"

server_scripts {
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
    --[[ 
        the "@" references a file from a different resource,
        In this instance, we refernce the mysql library for FiveM.
    ]]
}