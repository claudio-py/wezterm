--[[local wezterm = require("wezterm")
local M = {}

local appearance = wezterm.gui.get_appearance()

M.is_dark = function()
	return appearance:find("Dark")
end

M.get_random_entry = function(tbl)
	local keys = {}
	for key, _ in ipairs(tbl) do
		table.insert(keys, key)
	end
	local randomKey = keys[math.random(1, #keys)]
	return tbl[randomKey]
end

return M]]
local wezterm = require("wezterm")
local M = {}

local appearance = wezterm.gui.get_appearance()

M.is_dark = function()
  return appearance:find("Dark")
end

M.get_random_entry = function(tbl)
  if #tbl == 0 then
    return nil  -- or handle the empty table case as needed
  end

  local keys = {}
  for key, _ in ipairs(tbl) do
    table.insert(keys, key)
  end

  local randomKey = keys[math.random(1, #keys)]
  return tbl[randomKey]
end

return M
