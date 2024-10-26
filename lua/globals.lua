local LazyLoader = require("lazy.core.loader")
local LazyConfig = require("lazy.core.config")
local settings = require("settings")

_G.S = settings

---Inspect it and return it
---@param it any
function _G.P(it)
  print(vim.inspect(it))
  return it
end

---Reload a plugin
---
---It can be a
---1. Lazy registered plugin name
---2. a module that returns a `setup(opts)` and a optional `deactivate()` functions
---3. a module that would unloaded and required again
---@param mod string
---@param opts table
---@return any
function _G.R(mod, opts)
  local plugin_ref = LazyConfig.plugins[mod]
  if plugin_ref ~= nil then
    -- print("reload with lazy")
    LazyLoader.reload(plugin_ref)
    return require(LazyLoader.get_main(plugin_ref))
    -- return
  end

  local ok, mod_ref = pcall(require, mod)

  if not ok then
    return mod
  end

  local setup_ref = nil

  if type(mod_ref.setup) == "function" then
    if type(mod_ref.deactivate) == "function" then
      mod_ref.deactivate()
    end

    ok, setup_ref = pcall(mod_ref.setup, opts)
  end

  package.loaded[mod] = nil
  ok, mod_ref = pcall(require, mod)

  if setup_ref ~= nil then
    return setup_ref
  end

  return mod_ref
end

local mount_n = 8

return { mount = mount_n }
