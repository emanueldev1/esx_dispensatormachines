fx_version 'adamant'
games { 'rdr3', 'gta5' }

author 'ΞMΛNUΞL#5620'
description 'Spendor machines'
version '1.0 ALPHA'



client_script {
    '@es_extended/locale.lua',
	"config.lua",
	"client.lua"
}

server_script {
    '@es_extended/locale.lua',
	"config.lua",
	"server.lua"
}

lua54 'yes' 

escrow_ignore {
   "config.lua",
   "readme.md",
}