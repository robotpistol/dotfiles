Logger = function(id, level)
  id = id or 'base'
  level = level or 'debug'
  l = {
    id = id,
    level = level,
    lastTime = hs.timer.absoluteTime(),
    logger = hs.logger.new(id, level),
  }
  l.tare = function()
    t = (hs.timer.absoluteTime() - l.lastTime) / 1000000
    l.lastTime = hs.timer.absoluteTime()
    return t
  end

  l.df = function(fmt, ...)
    l.logger.df("⏰ %sms " .. fmt, l.tare(), ...)
  end

  l.ef = function(fmt, ...)
    l.logger.ef("⏰ %sms " .. fmt, l.tare(), ...)
  end

  l.d = function(...)
    l.logger.d("⏰ " .. l.tare() .. "ms ", ...)
  end

  l.e = function( ...)
    l.logger.e("⏰ " .. l.tare() .. "ms ", ...)
  end
  return l
end

tprint =  function(...)
  Logger().d(...)
end
