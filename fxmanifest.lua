fx_version "adamant"
game "gta5"
use_fxv2_oal "yes"
lua54 "yes"

name "exios-bonusses"
author "Exios: Bonusses"
version "1.0.0"

server_scripts { "shared/**/*.lua", "src/shared/*.lua" ,"@oxmysql/lib/MySQL.lua", "src/server/*.lua" }
shared_scripts { "@es_extended/imports.lua", "@ox_lib/init.lua" }