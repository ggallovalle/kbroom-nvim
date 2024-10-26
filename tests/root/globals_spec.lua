local expect = require("luassert")
local spy = require("luassert.spy")

after_each(function()
  require("globals").deactivate()
  package.loaded["globals"] = nil
end)

describe("globals module", function()
  it("when required then adds to global", function()
    -- given
    expect.is_nil(_G.S)
    expect.is_nil(_G.P)
    expect.is_nil(_G.R)

    -- when
    require("globals")

    -- then
    expect.is_table(_G.S)
    expect.is_function(_G.P)
    expect.is_function(_G.R)
  end)

  it("supports the setup protocol", function()
    -- given
    expect.is_nil(_G.S)
    expect.is_nil(_G.P)
    expect.is_nil(_G.R)

    -- when
    local sut = require("globals")
    sut.deactivate()
    sut.setup()

    -- then
    expect.is_table(_G.S)
    expect.is_function(_G.P)
    expect.is_function(_G.R)
  end)

  it("supports the deactivate protocol", function()
    -- given
    local sut = require("globals")

    -- when
    sut.deactivate()

    -- then
    expect.is_table(sut)
    expect.is_function(sut.deactivate)
    expect.is_nil(_G.S)
    expect.is_nil(_G.P)
    expect.is_nil(_G.R)
  end)
end)

it([[_G.S == require("settings")]], function()
  -- given
  local settings = require("settings")

  -- when
  require("globals")

  -- then
  expect.equals(settings, S)
end)

it("_G.P(it)", function()
  -- given
  local o_vim_inspect = vim.inspect
  local s_vim_inspect = spy.new(function() end)
  vim.inspect = s_vim_inspect
  local o_G_print = print
  local s_G_print = spy.new(function() end)
  _G.print = s_G_print

  local value_to_print = { name = "John", age = 10, speak = function() end }

  -- when
  require("globals")
  expect.is_function(_G.P)
  local actual = _G.P(value_to_print)

  -- then
  expect.spy(s_vim_inspect).was.called_with(value_to_print)
  expect.spy(s_G_print).was.called()
  expect.equals(actual, value_to_print)

  -- cleanup
  vim.inspect = o_vim_inspect
  _G.print = o_G_print
end)
