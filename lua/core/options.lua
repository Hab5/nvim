local g = vim.g
local opt = vim.opt

-- export user config as a global varibale
g.user_config = "user_config"

local global = require("core.utils").load_config().global
for key, value in pairs(global) do
    g[key] = value
end

local options = require("core.utils").load_config().options
for key, value in pairs(options) do
    opt[key] = value
end

opt.shortmess:append "Ilncowx" -- :h shortmess for more information
opt.whichwrap:append "<>hl" -- prev/next line with left/right when EOL

-- disable some builtin vim plugins
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end
