fx_version 'bodacious'
game 'gta5'

local function object_entry(data)
	dependency 'object-loader'

	files(data)
	object_file(data)
end

object_entry 'nep.xml'