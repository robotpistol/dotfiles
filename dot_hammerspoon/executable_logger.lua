--[[
Logging Utilities
Provides timing and logging functionality for debugging
--]]

---Creates a new logger instance with timing capabilities
---@param id string Logger identifier
---@param level string Log level (debug, info, warn, error)
---@return table Logger object
function Logger(id, level)
  id = id or 'base'
  local logger = {
    id = id,
    level = level or 'debug',
    lastTime = hs.timer.absoluteTime(),
    logger = hs.logger.new(id, level),
  }

  -- Calculate time difference since last log
  function logger:tare()
    local elapsed = (hs.timer.absoluteTime() - self.lastTime) / 1000000
    self.lastTime = hs.timer.absoluteTime()
    return elapsed
  end

  -- Formatted debug logging
  function logger:df(fmt, ...)
    self.logger.df("⏰ %sms " .. fmt, self:tare(), ...)
  end

  -- Formatted error logging
  function logger:ef(fmt, ...)
    self.logger.ef("⏰ %sms " .. fmt, self:tare(), ...)
  end

  -- Debug logging
  function logger:d(...)
    self.logger.d("⏰ " .. self:tare() .. "ms ", ...)
  end

  -- Error logging
  function logger:e(...)
    self.logger.e("⏰ " .. self:tare() .. "ms ", ...)
  end

  return logger
end

-- Global debug print function
function Tprint(...)
  Logger():d(...)
end
