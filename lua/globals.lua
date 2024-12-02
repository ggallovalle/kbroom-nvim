local LazyLoader = require("lazy.core.loader")
local LazyConfig = require("lazy.core.config")

local M = {}
local H = {}

M.deps = {
  "settings"
}

function M.setup()
  local settings = require("settings")
  _G.S = settings
  _G.P = H.P
  _G.R = H.R
end

function M.deactivate()
  _G.S = nil
  _G.P = nil
  _G.R = nil
end

---Inspect it and return it
function H.P(it)
  return vim.print(it)
end

--- Reload a plugin
---
--- It can be a
--- 1. Lazy registered plugin name
--- 2. a module that returns a `setup(opts)` and a optional `deactivate()` functions
--- 3. a module that would unloaded and required again
--- @param mod string
--- @param opts? table
--- @return any
function H.R(mod, opts)
  local plugin_ref = LazyConfig.plugins[mod]
  if plugin_ref ~= nil then
    LazyLoader.reload(plugin_ref)
    return require(LazyLoader.get_main(plugin_ref))
  end

  local ok, mod_ref = pcall(require, mod)

  if not ok then
    return mod
  end

  local setup_ref = nil
  local cleaned = false

  if type(mod_ref.deps) == "table" then
    for _, dep in ipairs(mod_ref.deps) do
      H.R(dep)
    end

    ok, mod_ref = pcall(require, mod)
    cleaned = true
  end

  if type(mod_ref.setup) ~= "nil" then
    if type(mod_ref.deactivate) ~= "nil" then
      mod_ref.deactivate()
    end

    ok, setup_ref = pcall(mod_ref.setup, opts)
  end

  if not cleaned then
    package.loaded[mod] = nil
    ok, mod_ref = pcall(require, mod)
  end


  if setup_ref ~= nil then
    return setup_ref
  end

  return mod_ref
end

return M
