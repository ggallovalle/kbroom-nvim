---@diagnostic disable: param-type-mismatch, missing-fields

---@type effect.FileSystem
local M = {
  service = "effect/FileSystem",
  write_file_string = function(_self, path, data, callback)
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
  end,
  exist = function(_self, path, callback)
    vim.loop.fs_stat(path, function(err, stat)
      if err then
        callback(false)
      else
        callback(stat and stat.type ~= nil)
      end
    end)
  end,
}

return M
