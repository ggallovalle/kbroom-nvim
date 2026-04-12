local NvimEnv = require("effect-nvim.Env")
local NvimFileSystem = require("effect-nvim.FileSystem")
local NvimJSON = require("effect-nvim.JSON")
local NvimPath = require("effect-nvim.Path")
local NvimXdgDirs = require("effect-nvim.XdgDirs")

local Env = require("effect.Env")
local FileSystem = require("effect.FileSystem")
local JSON = require("effect.JSON")
local Path = require("effect.Path")
local XdgDirs = require("effect.XdgDirs")

---@param effect Effect<any>
return function(effect)
    Env.set(effect, NvimEnv)
    FileSystem.set(effect, NvimFileSystem)
    JSON.set(effect, NvimJSON)
    Path.set(effect, NvimPath)
    XdgDirs.set(effect, NvimXdgDirs)
end
