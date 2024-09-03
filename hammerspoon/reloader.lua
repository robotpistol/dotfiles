local watcherInstance

startReloader = function()
  basename = function(str) return string.gsub(str, "(.*/)([^/].+)", "%2") end
  endsWith = function(str, ext) return str:match(".*%." .. ext) end

  reloadOnChange = function(paths, flags)
    for i, path in pairs(paths) do
      if endsWith(basename(path), 'lua') then
        hs.reload()
      end
    end
  end

  watcherInstance = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon", reloadOnChange):start()
end

startReloader()
