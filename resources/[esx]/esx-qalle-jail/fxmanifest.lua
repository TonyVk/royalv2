fx_version 'bodacious'
game 'gta5'

--	esx-qalle-jail
--		2018
--		Carl "Qalle"
--		2018
--	esx-qalle-jail


description "Jail Script With Working Job"

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/server.lua"
}

client_scripts {
	"config.lua",
	"client/utils.lua",
	"client/client.lua"
}