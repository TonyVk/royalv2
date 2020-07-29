fx_version 'bodacious'
game 'gta5'

description "Queue for FiveM FX Servers"
version "1.1.0"

ui_page 'NUI/index.html'

server_scripts {
"Newtonsoft.Json.dll",
"Server_Queue.net.dll"
}

client_scripts {
"Client_Queue.net.dll"
}

files {
'NUI/index.html',
'NUI/main.css',
'NUI/main.js',
"Newtonsoft.Json.dll"
}