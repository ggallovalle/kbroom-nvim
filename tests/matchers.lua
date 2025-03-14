local s = require("say")
local assert = require("luassert")
local match = require("luassert.match")

local M = {}
local H = {}

function M.setup()
  assert:register("matcher", "satisfies", H.satisfies)
  assert:register("matcher", "tbl_get", H.tbl_get)
end

function M.deactivate()
  assert:unregister("matcher", "test")
  assert:unregister("matcher", "tbl_get")
end

function H.satisfies(_, arguments)
  local test = arguments[1]
  return function(value)
    return test(value) == true
  end
end

function H.tbl_get(_, arguments, level)
  -- match.tbl_get(path: str|list[str], match: any|matcher)
  level = (level or 1) + 1

  local path = arguments[1]
  local path_type = type(path)
  assert(path_type == "table" or path_type == "string",
    s("assertion.internal.badargtype", { 1, "tbl_get", "str | str[]", path_type }), level)

  if type(path) == "string" then
    path = { path }
  end

  local matcher = arguments[2]
  -- default to equal for simplicity
  if not match.is_matcher(matcher) then
    matcher = match.is_equal(matcher)
  end

  assert(match.is_matcher(matcher),
    s("assertion.internal.badargtype", { 1, "tbl_get", "matcher", type(matcher) }), level)

  return function(value)
    local v = vim.tbl_get(value, unpack(path))
    local actual = matcher(v)
    return actual ~= false and actual ~= nil
  end
end

return M
