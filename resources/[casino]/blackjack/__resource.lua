resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_scripts {
	'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/script.js',
    'client/html/style.css'
})

--[[server_scripts {
	'shared.js',
	'server/server.js'
}]]--