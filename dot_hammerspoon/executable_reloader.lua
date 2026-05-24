--[[
Configuration Auto-Reloader
Watches for changes in Lua files and reloads Hammerspoon configuration
--]]

local function endsWith(str, ext)
  return str:match("%." .. ext .. "$") ~= nil
end

local function basename(str)
  return string.gsub(str, "(.*/)([^/].+)", "%2")
end

local function reloadOnChange(paths)
  for _, path in ipairs(paths) do
    if endsWith(basename(path), 'lua') then
      hs.reload()
      break
    end
  end
end

-- Initialize and start path watcher
local configPath = os.getenv("HOME") .. "/.hammerspoon"
local Pathwatcher = hs.pathwatcher.new(configPath, reloadOnChange):start()
