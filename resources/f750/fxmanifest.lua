fx_version 'bodacious'
game 'gta5'


files {
    'data/vehicles.meta',
    'data/carvariations.meta',
    'data/carcols.meta',
}
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'


client_script {
    'data/vehicle_names.lua'
}
