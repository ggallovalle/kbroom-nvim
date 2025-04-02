local M = {}

local H = {}
H.trim_newline = function(s)
    return s:gsub("%s+$", "")
end

M.config_get = function(key)
    local value = vim.system({ "npm", "config", "get", key }, { text = true }):wait()
    return H.trim_newline(value.stdout)
end

M.root = function (opts)
    local do_global = opts and opts.global or false
    local cmd_args = { "npm", "root" }
    if do_global then
        table.insert(cmd_args, "-g")
    end
    local value = vim.system(cmd_args, { text = true }):wait()
    return H.trim_newline(value.stdout)
end

M.install = function (package, opts)
    local do_global = opts and opts.global or false
    local cmd_args = { "npm", "install", package }
    if do_global then
        table.insert(cmd_args, "-g")
    end
    local value = vim.system(cmd_args, { text = true }):wait()
    return value.code == 0
end

M.package_path = function (package, opts)
    local do_global = opts and opts.global or false
    local root = M.root({ global = do_global })
    return root .. "/" .. package
end

return M
