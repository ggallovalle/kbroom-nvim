local assert = require("luassert")
local spy = require("luassert.spy")
local match = require("luassert.match")

describe("satisfies", function()
   local function is_even(value)
      return value % 2 == 0
   end

   local function is_positive(value)
      return value > 0
   end

   it("is", function()
      local s1 = spy.new(function() end)
      s1(10)

      assert.spy(s1).was.called_with(match.does_satisfies(is_even))
      assert.spy(s1).was.called_with(match.does_satisfies(is_positive))
   end)

   it("is_not", function()
      local s1 = spy.new(function() end)
      s1(-11)

      assert.spy(s1).was.called_with(match.does_not_satisfies(is_even))
      assert.spy(s1).was.called_with(match.does_not_satisfies(is_positive))
   end)
end)

describe("tbl_get", function()
   describe("path", function()
      it("can only be a string or a table", function()
         assert.has_error(function()
            local s1 = spy.new(function() end)
            s1({ a = 1 })
            assert.spy(s1).was.called_with(match.tbl_get(1, 1))
         end)
      end)

      it("string", function ()
         local s1 = spy.new(function() end)
         s1({ a = 1 })
         assert.spy(s1).was.called_with(match.tbl_get("a", 1))
      end)

      it("table", function ()
         local s1 = spy.new(function() end)
         s1({ a = { b = 1 } })
         assert.spy(s1).was.called_with(match.tbl_get({ "a", "b" }, 1))
      end)
   end)

   describe("matcher", function ()
      it("defaults to equal when not a matcher", function ()
         local s1 = spy.new(function() end)
         s1({ a = 1 })
         assert.spy(s1).was.called_with(match.tbl_get("a", 1))
      end)

      it("accepts a matcher", function ()
         local s1 = spy.new(function() end)
         s1({ a = 1 })
         assert.spy(s1).was.called_with(match.tbl_get("a", match.is_not_equal(2)))
      end)
   end)
end)
