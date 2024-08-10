fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Gatsu'
description 'Atm Robbery System'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
    '@es_extended/imports.lua'
}

server_scripts {
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}