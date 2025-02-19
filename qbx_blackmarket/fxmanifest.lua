fx_version 'cerulean'
game 'gta5'
lua54 true

author 'tontsa97(BonoboTurbo)'
description 'Advanced Black Market Script for QBX Core'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependencies {
    'qbx-core',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}