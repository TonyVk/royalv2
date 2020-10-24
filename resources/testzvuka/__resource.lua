resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

files {
	"data/exotic_pack/dat151/nametable/gtr17_game.dat151.nametable",
	"data/exotic_pack/dat151/rel/gtr17_game.dat151.rel",
	"data/exotic_pack/dat54/nametable/gtr17_sounds.dat54.nametable",
	"data/exotic_pack/dat54/rel/gtr17_sounds.dat54.rel",	
	"data/exotic_pack/snd/exotic_snd/gtr17.awc",
	"data/exotic_pack/snd/exotic_snd/gtr17_npc.awc",
	"data/exotic_pack/meta/[ M-1019 L-000 S-000 ] 2017 Nissan GTR/handling.meta",
	"data/exotic_pack/meta/[ M-1019 L-000 S-000 ] 2017 Nissan GTR/vehicles.meta",
	"data/exotic_pack/meta/[ M-1019 L-000 S-000 ] 2017 Nissan GTR/carcols.meta",
	"data/exotic_pack/meta/[ M-1019 L-000 S-000 ] 2017 Nissan GTR/carvariations.meta",
}

data_file "AUDIO_GAMEDATA" "data/exotic_pack/dat151/rel/gtr17_game.dat"
data_file "AUDIO_SOUNDDATA" "data/exotic_pack/dat54/rel/gtr17_sounds.dat"
data_file "AUDIO_WAVEPACK" "data/exotic_pack/snd/exotic_snd"

data_file "HANDLING_FILE" "data/exotic_pack/meta/[ M-1019 L-000 S-000 ] 2017 Nissan GTR/handling.meta"
data_file "VEHICLE_METADATA_FILE" "data/exotic_pack/meta/[ M-1019 L-000 S-000 ] 2017 Nissan GTR/vehicles.meta"
data_file "CARCOLS_FILE" "data/exotic_pack/meta/[ M-1019 L-000 S-000 ] 2017 Nissan GTR/carcols.meta"
data_file "VEHICLE_VARIATION_FILE" "data/exotic_pack/meta/[ M-1019 L-000 S-000 ] 2017 Nissan GTR/carvariations.meta"

client_script "data/exotic_pack/labels.lua"