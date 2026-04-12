---@class Effect<T>
---@field context EffectContext The DI context
---@field op string Operation type: "succeed" | "fail" | "sync" | "callback" | "map" | "flatMap" | "mapError" | "service" | "gen"
---@field args any Arguments for the operation

---@class EffectContext
---@field get fun(self: EffectContext, key: string): any
---@field set fun(self: EffectContext, key: string, value: any)

---Create a new effect context
---@return EffectContext
local function new_context()
  local store = {}
  return {
    get = function(_, key)
      return store[key]
    end,
    set = function(_, key, value)
      store[key] = value
    end,
  }
end

local EffectImpl = {}
EffectImpl.__index = EffectImpl

---@class EffectModule
local Effect = {}
Effect.__index = Effect

---Create a succeed effect (always succeeds with value)
---@generic T
---@param value T
---@return Effect<T>
function Effect.succeed(value)
  local self = setmetatable({}, EffectImpl)
  self.context = new_context()
  self.op = "succeed"
  self.args = value
  return self
end

---Create a fail effect (always fails with error)
---@param err string
---@return Effect<any>
function Effect.fail(err)
  local self = setmetatable({}, EffectImpl)
  self.context = new_context()
  self.op = "fail"
  self.args = err
  return self
end

---Create a root effect (empty effect, equivalent to Effect.succeed(nil))
---@return Effect<nil>
function Effect.root()
  local self = setmetatable({}, EffectImpl)
  self.context = new_context()
  self.op = "succeed"
  self.args = nil
  return self
end

---Create a sync effect (runs a synchronous function)
---@generic T
---@param thunk fun(): T
---@return Effect<T>
function Effect.sync(thunk)
  local self = setmetatable({}, EffectImpl)
  self.context = new_context()
  self.op = "sync"
  self.args = thunk
  return self
end

---Create a callback effect (from callback-style async function)
---@generic T
---@param fn fun(callback: fun(err: nil|string, value: T|nil))
---@return Effect<T>
function Effect.callback(fn)
  local self = setmetatable({}, EffectImpl)
  self.context = new_context()
  self.op = "callback"
  self.args = fn
  return self
end

---Map over an effect (static method) - dual API
---@generic A, B
---@param effect Effect<A>
---@param fn fun(a: A): B
---@return Effect<B>
function Effect.map(effect, fn)
  local self = setmetatable({}, EffectImpl)
  self.context = effect.context
  self.op = "map"
  self.args = {
    _effect = effect,
    _fn = fn,
  }
  return self
end

---FlatMap/chain effects (static method) - dual API
---@generic A, B
---@param effect Effect<A>
---@param fn fun(a: A): Effect<B>
---@return Effect<B>
function Effect.flatMap(effect, fn)
  local self = setmetatable({}, EffectImpl)
  self.context = effect.context
  self.op = "flatMap"
  self.args = {
    _effect = effect,
    _fn = fn,
  }
  return self
end

---Map over an effect's error (static method)
---@generic T
---@param fn fun(err: string): string
---@return fun(effect: Effect<T>): Effect<T>
function Effect.mapError(fn)
  return function(effect)
    local self = setmetatable({}, EffectImpl)
    self.context = effect.context
    self.op = "mapError"
    self.args = {
      _effect = effect,
      _fn = fn,
    }
    return self
  end
end

---Yield to an effect (suspend coroutine, run effect, resume with value)
---@generic T
---@param effect Effect<T>
---@return T
function Effect.yield(effect)
  return coroutine.yield(effect)
end

---Create an effect from a generator function (async/await style)
---@generic T
---@param fn fun(): T
---@return Effect<T>
function Effect.gen(fn)
  local co = coroutine.create(fn)
  local steps = {}
  local dependencies = {}

  local function collect()
    local ok, effect_or_value = coroutine.resume(co)
    if not ok or coroutine.status(co) == "dead" then
      return
    end

    if effect_or_value then
      table.insert(steps, effect_or_value)
      if effect_or_value.op == "service" then
        local key = effect_or_value.args._key
        local found = false
        for _, dep in ipairs(dependencies) do
          if dep == key then found = true break end
        end
        if not found then table.insert(dependencies, key) end
      end
      collect()
    else
      collect()
    end
  end
  collect()

  local self = setmetatable({}, EffectImpl)
  self.context = new_context()
  self.op = "gen"
  self.args = {
    _fn = fn,
    _steps = steps,
    _dependencies = dependencies,
  }
  return self
end

---Run an effect and get the result via callback
---@generic T
---@param effect Effect<T>
---@param callback fun(err: nil|string, value: T|nil)
function Effect.run(effect, callback)
  local function run_rec(e, cb)
    if e.op == "succeed" then
      cb(nil, e.args)
    elseif e.op == "fail" then
      cb(e.args, nil)
    elseif e.op == "sync" then
      local ok, result = pcall(e.args)
      if ok then
        cb(nil, result)
      else
        cb(result, nil)
      end
    elseif e.op == "callback" then
      local wrapped_cb = function(err, value)
        vim.schedule(function()
          cb(err, value)
        end)
      end
      e.args(wrapped_cb)
    elseif e.op == "map" then
      run_rec(e.args._effect, function(err, value)
        if err then
          cb(err, nil)
        else
          cb(nil, e.args._fn(value))
        end
      end)
    elseif e.op == "flatMap" then
      run_rec(e.args._effect, function(err, value)
        if err then
          cb(err, nil)
        else
          run_rec(e.args._fn(value), cb)
        end
      end)
    elseif e.op == "mapError" then
      run_rec(e.args._effect, function(err, value)
        if err then
          cb(e.args._fn(err), nil)
        else
          cb(nil, value)
        end
      end)
    elseif e.op == "service" then
      local impl = e.context:get(e.args._key)
      if impl then
        cb(nil, impl)
      else
        cb("service not found: " .. e.args._key, nil)
      end
    elseif e.op == "gen" then
      local co = coroutine.create(e.args._fn)
      local function run_step(err, value)
        if err then
          cb(err, nil)
          return
        end
        local ok, effect_or_value = coroutine.resume(co, value)
        if not ok then
          cb(effect_or_value, nil)
        elseif coroutine.status(co) == "dead" then
          cb(nil, effect_or_value)
        else
          Effect.run(effect_or_value, run_step)
        end
      end
      run_step(nil, nil)
    end
  end

  vim.schedule(function()
    run_rec(effect, callback)
  end)
end

---Set context on an effect (returns new effect with context)
---@generic T
---@param effect Effect<T>
---@param context EffectContext
---@return Effect<T>
function Effect.context(effect, context)
  effect.context = context
  return effect
end

function Effect.service(effect, key)
  local self = setmetatable({}, EffectImpl)
  self.context = effect.context
  self.op = "service"
  self.args = { _key = key }
  return self
end

return Effect
