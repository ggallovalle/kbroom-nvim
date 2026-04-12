--- Inspired by effect.ts
--- https://github.com/Effect-TS/effect-smol


---@class effect.Effect
---@field get fun(self: effect.Effect, key: string, callback: fun(value: any))
---@field set fun(self: effect.Effect, key: string, value: any)

--- @return effect.Effect
local function Effect()
    local store = {}
    return {
        set = function(_self, key, value)
            store[key] = value
        end,
        get = function(_self, key, callback)
            callback(store[key])
        end
    }
end


return {
    new = Effect,
}
