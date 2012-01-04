local addonName, addon = ...
addon.config = {}
local config = addon.config

config.timeonleft = true

-- when to show decimals, in seconds
config.decimals = 5 

-- first parameter "nil" means elvui/tukui font
-- else it's a path to a font.
config.fontflags = {nil, 12, "OUTLINE"} 

-- for time text, string escape sequence
config.color = "|cffff0000" 

config.visualstacks = true
config.visualstacksmax = 5
config.visualstackwidth = 10