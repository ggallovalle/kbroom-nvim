-- local List = require("plenary.collections.py_list")
local stub = require("luassert.stub")
local M = {}
local List = {}

function M.new()
  local this = {}

  local q = {}
  q._len = 0

  function this.after_each()
    after_each(function()
      this.revert()
    end)
  end

  function this.revert()
    while #q > 0 do
      local current = List.pop(q)
      current:revert()
    end
  end

  function this.new(object, key, ...)
    local current = stub.new(object, key, ...)
    List.push(q, current)
    return current
  end

  function this.values(object, overrides)
    local is_mocking = true
    local mutations = {}
    local current = setmetatable({
      revert = function(_)
        is_mocking = false
      end
    }, {
      __index = function(_, key)
        local o = overrides[key]
        if key == "config" then
          P({ key = key, o = o, mutations = mutations })
        end
        if is_mocking and o ~= nil then
          return o
        end

        local m = mutations[key]
        if key == "config" then
          P({ key = key, m = m, mutations = mutations })
        end
        if is_mocking and m ~= nil then
          return m
        end

        local r = object[key]
        if key == "config" then
          P({ key = key, r = r, mutations = mutations })
        end

        return r
      end,
      __newindex = function(_, k, v)
        mutations[k] = v
      end
    })


    List.push(q, current)

    return current
  end

  return this
end

function List.pop(self)
  local result = table.remove(self)
  self._len = self._len - 1
  return result
end

function List.push(self, other)
  self[self._len + 1] = other
  self._len = self._len + 1
end

return M
