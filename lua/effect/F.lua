local Effect = require("effect.Effect")

---@class F

---Pipe an effect through a mapper (2 args)
---@generic A
---@param effect Effect<A>
---@param mapper fun(e: Effect<A>): Effect<A>
---@return Effect<A>
local function pipe2(effect, mapper)
  return mapper(effect)
end

return {
  pipe2 = pipe2,
}
