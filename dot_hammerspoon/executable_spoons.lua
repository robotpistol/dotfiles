hs.loadSpoon("SpoonInstall")

LoadSpoons = function(spoonConfig)
  Tprint(spoonConfig)
  for name, arg in pairs(spoonConfig) do
    Tprint("spoon installing ", name, arg)
    spoon.SpoonInstall.andUse(name, arg)
  end
end
