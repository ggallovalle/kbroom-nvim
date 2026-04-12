---@class F

---Pipe an effect through a mapper (2 args)
---@generic A, B
---@param effect Effect<A>
---@param mapper fun(e: Effect<A>): Effect<B>
---@return Effect<B>
local function pipe2(effect, mapper)
    return mapper(effect)
end

---Pipe an effect through 2 mappers (3 args)
---@generic A, B, C
---@param effect Effect<A>
---@param mapper1 fun(e: Effect<A>): Effect<B>
---@param mapper2 fun(e: Effect<B>): Effect<C>
---@return Effect<C>
local function pipe3(effect, mapper1, mapper2)
    return mapper2(mapper1(effect))
end

---Pipe an effect through 3 mappers (4 args)
---@generic A, B, C, D
---@param effect Effect<A>
---@param mapper1 fun(e: Effect<A>): Effect<B>
---@param mapper2 fun(e: Effect<B>): Effect<C>
---@param mapper3 fun(e: Effect<C>): Effect<D>
---@return Effect<D>
local function pipe4(effect, mapper1, mapper2, mapper3)
    return mapper3(mapper2(mapper1(effect)))
end

return {
    pipe2 = pipe2,
    pipe3 = pipe3,
    pipe4 = pipe4,
}