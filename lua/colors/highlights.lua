local cmd = vim.cmd

local colors = require("colors").get()

local ui = require("core.utils").load_config().ui

-- Define bg color
-- @param group Group
-- @param color Color
local function bg(group, color)
    cmd("hi " .. group .. " guibg=" .. color)
end

-- Define fg color
-- @param group Group
-- @param color Color
local function fg(group, color)
    cmd("hi " .. group .. " guifg=" .. color)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
local function fg_bg(group, fgcol, bgcol)
    cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

-- Comments
if ui.italic_comments then
    fg("Comment", colors.grey_fg .. " gui=italic")
else
    fg("Comment", colors.grey_fg)
end

-- Disable cursor line
-- cmd "hi clear CursorLine"

bg("Normal", colors.black)
bg("CursorLine", colors.one_bg)

-- Line number
fg("cursorlinenr", colors.white)

-- same as bg, so it doesn't appear
fg("EndOfBuffer", colors.black)

-- For floating windows
fg("FloatBorder", colors.line)
bg("NormalFloat", colors.black)

-- Pmenu
bg("Pmenu",      colors.lightbg2)
bg("PmenuSbar",  colors.one_bg2)
bg("PmenuSel",   colors.vibrant_green)
bg("PmenuThumb", colors.red)

-- misc
fg("LineNr", colors.grey)

fg("NvimInternalError", colors.red)

-- inactive statuslines as thin splitlines
if (ui.plugin.statusline.hide_inactive == true) then
    fg("StatusLineNC", colors.one_bg2 .. " gui=underline")
else
    bg("StatusLine",   colors.statusline_bg)
    bg("StatusLineNC", colors.statusline_bg)
end


fg("VertSplit",    colors.one_bg2)

-- selection color
bg("Visual", colors.one_bg3)

if ui.transparency then
    bg("Normal", "NONE")
    bg("Folded", "NONE")
    fg("Folded", "NONE")
    fg("Comment", colors.grey)
end

-- [[ Plugin Highlights

-- Dashboard
fg("DashboardCenter",   colors.grey_fg)
fg("DashboardFooter",   colors.grey_fg)
fg("DashboardHeader",   colors.grey_fg)
fg("DashboardShortcut", colors.grey_fg)

-- Git signs
fg_bg("DiffAdd",       colors.vibrant_green, "none")
fg_bg("DiffChange",    colors.orange,   "none")
fg_bg("DiffModified",  colors.nord_blue, "none")
fg_bg("DiffDelete",    colors.red,       colors.black)

-- Indent blankline plugin
fg("IndentBlanklineChar", colors.line)

-- ]]

-- [[ LspDiagnostics

-- Errors
fg("LspDiagnosticsSignError",          colors.red)
fg("LspDiagnosticsSignWarning",        colors.yellow)
fg("LspDiagnosticsVirtualTextError",   colors.red)
fg("LspDiagnosticsVirtualTextWarning", colors.yellow)

-- Info
fg("LspDiagnosticsSignInformation",        colors.green)
fg("LspDiagnosticsVirtualTextInformation", colors.green)

-- Hints
fg("LspDiagnosticsSignHint",        colors.purple)
fg("LspDiagnosticsVirtualTextHint", colors.purple)

-- ]]

-- NvimTree
fg("NvimTreeEmptyFolderName",  colors.blue)
fg("NvimTreeEndOfBuffer",      colors.darker_black)
fg("NvimTreeFolderIcon",       colors.folder_bg)
fg("NvimTreeFolderName",       colors.folder_bg)
fg("NvimTreeGitDirty",         colors.sun)
fg("NvimTreeIndentMarker",     colors.one_bg2)
bg("NvimTreeNormal",           colors.darker_black)
fg("NvimTreeOpenedFolderName", colors.blue)
fg("NvimTreeRootFolder",       colors.vibrant_green .. " gui=bold,standout")
fg_bg("NvimTreeStatuslineNc",  colors.darker_black, colors.darker_black)
fg("NvimTreeVertSplit",        colors.darker_black)
bg("NvimTreeVertSplit",        colors.darker_black)
fg_bg("NvimTreeWindowPicker",  colors.red, colors.black2)

-- Disable some highlight in nvim tree if transparency enabled
if ui.transparency then
    bg("NvimTreeNormal",       "NONE")
    bg("NvimTreeStatusLineNC", "NONE")
    bg("NvimTreeVertSplit",    "NONE")
    fg("NvimTreeVertSplit",    colors.grey)
end

-- Telescope
fg("TelescopeBorder",        colors.line)
fg("TelescopePreviewBorder", colors.grey)
fg("TelescopePromptBorder",  colors.line)
fg("TelescopeResultsBorder", colors.line)
