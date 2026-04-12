---@diagnostic disable: param-type-mismatch, missing-fields

local Effect = require("effect.Effect")

---@type effect.FileSystem
local M = {
  service = "effect/FileSystem",
  write_file_string = function(_self, path, data)
    return Effect.callback(function(callback)
      vim.loop.fs_open(path, "w", 438, function(err, fd)
        if err then
          callback(err, nil)
          return
        end

        vim.loop.fs_write(fd, data, function(write_err, bytes)
          if write_err then
            callback(write_err, nil)
          end
          vim.loop.fs_close(fd, function(close_err)
            if close_err then
              callback(close_err, nil)
            else
              callback(nil, bytes)
            end
          end)
        end)
      end)
    end)
  end,
  exist = function(_self, path)
    return Effect.callback(function(callback)
      vim.loop.fs_stat(path, function(err, stat)
        if err then
          callback(nil, false)
        else
          callback(nil, stat and stat.type ~= nil)
        end
      end)
    end)
  end,
}

return M
