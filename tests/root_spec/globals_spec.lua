local assert = require("luassert")
local spy = require("luassert.spy")
local match = require("luassert.match")
local stub = require("tests.stubber").new()

before_each(function()
  require("globals").deactivate()
end)

after_each(function ()
  stub.revert()
end)

describe("globals module", function()
  it("supports the setup protocol", function()
    -- given
    assert.is_nil(_G.S)
    assert.is_nil(_G.P)
    assert.is_nil(_G.R)

    -- when
    require("globals").setup()

    -- then
    assert.is_table(_G.S)
    assert.is_function(_G.P)
    assert.is_function(_G.R)
  end)

  it("supports the deactivate protocol", function()
    -- given
    local sut = require("globals")
    sut.setup()
    sut.deactivate()

    -- then
    assert.is_nil(_G.S)
    assert.is_nil(_G.P)
    assert.is_nil(_G.R)
  end)
end)

it([[_G.S == require("settings")]], function()
  -- given
  local settings = require("settings")

  -- when
  require("globals").setup()

  -- then
  assert.equals(settings, S)
end)

describe("_G.R(mod, opts)", function()
  it("when is a lazy.nvim registred plugin it calls config on it", function()
    -- given
    local LazyConfig = require("lazy.core.config")
    local plugin_name = "mini.test"
    local sut = require(plugin_name)
    local s_config = spy.new(function() end)
    local minitest_spec = LazyConfig.plugins[plugin_name]
    local opts = { hello = "world" }
    minitest_spec.opts = opts
    --- NOTE: it needs to be a function because lazy does 
    ---   if type(spec.config) == "function" and the spy
    ---   does not comply that contract
    --- @type any
    minitest_spec.config = function(spec, options)
      s_config(spec, options)
    end
    minitest_spec.lazy = false

    -- when
    require("globals").setup()
    local actual = R(plugin_name)

    -- then
    assert.same(vim.tbl_keys(sut), vim.tbl_keys(actual))
    assert.spy(s_config).called_with(
      match.tbl_get("name", plugin_name),
      match.tbl_get("hello", opts.hello)
    )

    -- cleanup
    minitest_spec.config = nil
    minitest_spec.lazy = true
    minitest_spec.opts = nil
  end)
end)
