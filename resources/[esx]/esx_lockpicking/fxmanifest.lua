fx_version 'bodacious'
game 'gta5'


description 'ESX Lockpicking'

version '1.0.0'

ui_page "index.html"

files {
	"index.html",
	"assets/plugins/jquery/jquery-3.2.1.min.js",
	"slike/*.png"
}

server_scripts {
  'server/main.lua'
}

client_scripts {
  'client/main.lua'
}
