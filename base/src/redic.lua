local null = nil
if type(ngx) == "table" then
  null = ngx.null
end

-- Normalize results
local _n = function(res, err)
  if res == null then res = nil end
  return res, err
end

local resty_call = function(self, cmd, ...)
  return _n(self._db[string.lower(cmd)](self._db, ...))
end

local resty_queue = function(self, cmd, ...)
  self._queue[#self._queue + 1] = {cmd = cmd, args = {...}}
end

local resty_commit = function(self)
  self._db:init_pipeline()
  for _, command in ipairs(self._queue) do
    self._db[string.lower(command.cmd)](self._db, unpack(command.args))
  end
  self._queue = {}
  return _n(self._db:commit_pipeline())
end

local _wrap_in_pcall = function(...)
  local success, res = pcall(...)
  if success then
    return res, nil
  else
    return nil, res
  end
end

local resp_call = function(self, ...)
  return _wrap_in_pcall(self._db.call, self._db, ...)
end

local resp_queue = function(self, ...)
  return _wrap_in_pcall(self._db.queue, self._db, ...)
end

local resp_commit = function(self, ...)
  return _wrap_in_pcall(self._db.commit, self._db, ...)
end

local providers = setmetatable({}, {
    __index = function (t, k)
      error("provider '" .. k .. "' is unimplemented")
    end
})

providers["lua-resty-redis"] = {
  call = resty_call,
  queue = resty_queue,
  commit = resty_commit
}

providers["resp"] = {
  call = resp_call,
  queue = resp_queue,
  commit = resp_commit
}

local deduct_provider = function(db, provider)
  if provider then return provider end
  if type(db.init_pipeline) == "function" then
    return "lua-resty-redis"
  elseif type(db.call) == "function" and type(db.queue) == "function" then
    return "resp"
  end
end

local new = function(db, provider)
  provider = deduct_provider(db, provider)
  if not provider then return "", "No provider is specified!" end

  local self = {}
  self._db = db
  self._queue = {}
  setmetatable(self, {__index = providers[provider]})
  return self
end

return {
  new = new
}
