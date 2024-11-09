shared_script '@chester_ped/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Wasabi ESX/QBCore Police Job'
author 'wasabirobby'
version '1.8.1'

ui_page 'ui/index.html'
files { 'ui/*', 'ui/**/*', 'ui/akte.html' }

shared_scripts { 
    '@wasabi_bridge/import.lua', 
    '@ox_lib/init.lua',  -- Hinzufügen von ox_lib in shared_scripts
    'game/configuration/config.lua', 
    'game/configuration/locales/*.lua' 
}

client_scripts { 'game/client/*.lua' }

server_scripts { 
    '@oxmysql/lib/MySQL.lua', 
    'game/server/*.lua' 
}

dependencies { 
    'oxmysql', 
    'wasabi_bridge', 
    'ox_lib'  -- ox_lib als Abhängigkeit hinzufügen
}

provides { 
    'esx_policejob', 
    'qb-policejob' 
}

escrow_ignore {
  'game/configuration/*.lua',
  'game/configuration/locales/*.lua',
  'game/client/client.lua',
  'game/client/cl_customize.lua',
  'game/client/radial.lua',
  'game/server/sv_customize.lua'
}

dependency '/assetpacks'

dependency '/assetpacks'