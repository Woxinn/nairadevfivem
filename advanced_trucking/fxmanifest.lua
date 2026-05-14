fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'advanced_trucking'
author 'Premium Systems'
description 'Advanced Trucking Job - premium logistics career system'
version '1.0.0'

ui_page 'web/index.html'

shared_scripts {
  '@ox_lib/init.lua',
  'shared/config.lua',
  'shared/locales.lua',
  'shared/utils.lua',
  'shared/framework.lua'
}

client_scripts {
  'client/ui.lua',
  'client/target.lua',
  'client/markers.lua',
  'client/vehicles.lua',
  'client/routes.lua',
  'client/events.lua',
  'client/main.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/database.lua',
  'server/logs.lua',
  'server/security.lua',
  'server/contracts.lua',
  'server/payments.lua',
  'server/progression.lua',
  'server/reputation.lua',
  'server/missions.lua',
  'server/leaderboard.lua',
  'server/licenses.lua',
  'server/main.lua'
}

files {
  'web/index.html'
}

escrow_ignore {
  'escrow_ignore/config.lua',
  'escrow_ignore/locales.lua',
  'escrow_ignore/framework.lua'
}
