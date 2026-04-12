---@class Effect<T>
---@field context EffectContext The DI context
---@field op string Operation type: "succeed" | "sync" | "callback" | "map" | "flatMap"
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
---@param fn fun(callback: fun(value: T))
---@return Effect<T>
function Effect.callback(fn)
    local self = setmetatable({}, EffectImpl)
    self.context = new_context()
    self.op = "callback"
    self.args = fn
    return self
end

---Map over an effect (static method)
---@generic A, B
---@param fn fun(a: A): B
---@return fun(e: Effect<A>): Effect<B>
function Effect.map(fn)
    return function(effect)
        local self = setmetatable({}, EffectImpl)
        self.context = effect.context
        self.op = "map"
        self.args = {
            _effect = effect,
            _fn = fn,
        }
        return self
    end
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

---Run an effect and get the result via callback
---@generic T
---@param effect Effect<T>
---@param callback fun(value: T)
function Effect.run(effect, callback)
    local function run_rec(e, cb)
        if e.op == "succeed" then
            cb(e.args)
        elseif e.op == "sync" then
            cb(e.args())
        elseif e.op == "callback" then
            local wrapped_cb = function(value)
                vim.schedule(function()
                    cb(value)
                end)
            end
            e.args(wrapped_cb)
        elseif e.op == "map" then
            run_rec(e.args._effect, function(value)
                cb(e.args._fn(value))
            end)
        elseif e.op == "flatMap" then
            run_rec(e.args._effect, function(inner)
                run_rec(e.args._fn(inner), cb)
            end)
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

return Effect
