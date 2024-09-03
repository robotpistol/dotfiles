hs.loadSpoon("SpoonInstall")

loadSpoons = function(spoonConfig)
  for name, arg in pairs(spoonConfig) do

    tprint("spoon installing ", name, arg)
    spoon.SpoonInstall.andUse(name, arg)
  end
end
