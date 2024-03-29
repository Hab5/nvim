local utils = require "core.utils"

local config = utils.load_config()
local map = utils.map

local maps = config.mappings
local plugin_maps = maps.plugin

local cmd = vim.cmd

local M = {}

-- these mappings will only be called during initialization
M.misc = function()
    local function non_config_mappings()
        map({"n", "v"}, maps.beginning_of_line, "^")
        map({"n", "v"}, maps.prev_blank_line, "{")
        map({"n", "v"}, maps.next_blank_line, "}")
        map("i", maps.beginning_of_line, "<ESC>^i")
        map("i", maps.prev_blank_line,   "<ESC>{i")
        map("i", maps.next_blank_line,   "<ESC>}i")

        -- Move line/selection up/down
        map("v", maps.move_line_down, ":'<,'> m '>+1 <CR>gv=gv")
        map("v", maps.move_line_up,   ":'<,'> m '<-2 <CR>gv=gv")
        map("n", maps.move_line_down, ":m +1 <CR>==")
        map("n", maps.move_line_up,   ":m -2 <CR>==")
        map("i", maps.move_line_down, "<Esc>:m +1 <CR>==i")
        map("i", maps.move_line_up,   "<Esc>:m -2 <CR>==i")

        -- Paragraph up and down
        map("n", "J", "}")
        map("n", "K", "{")

        -- Switch to last buffer
        map("n", "<Backspace>", "<C-^>")

        -- Repeat operator over visual selection
        map("v", ".", ":normal . <CR>")

        -- Execute macro in q register over visual selection
        map("v", "Q", ":'<,'>:normal @q <CR>")

        -- Don't copy changed text
        map("n", "c", '"_c')

        -- Don't copy the replaced text after pasting in visual mode
        map("v", "p", '"_dP')

        -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
        -- empty mode is same as using :map
        map("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
        map("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
        map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
        map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

        -- use ESC to turn off search highlighting
        map("n", "<Esc>", ":noh <CR>")
    end

    local function optional_mappings()
        -- don't yank text on cut ( x )
        if not config.custom.options.copy_cut then
            map({ "n", "v" }, "x", '"_x')
        end

        -- don't yank text on delete ( dd )
        if not config.custom.options.copy_del then
            map({ "n", "v" }, "dd", '"_dd')
        end
    end

    local function required_mappings()
        map("n", maps.close_buffer, ":lua require('core.utils').close_buffer() <CR>") -- close  buffer
        map("n", maps.copy_whole_file, ":%y+ <CR>") -- copy whole file content
        map("n", maps.new_buffer, ":enew <CR>") -- new buffer
        -- map("n", maps.new_tab, ":tabnew <CR>") -- new tabs
        map("n", maps.line_number_toggle, ":set nu! <CR>") -- toggle numbers
        map("n", maps.save_file, ":w <CR>") -- ctrl + s to save file
        map("i", maps.save_file, "<Esc>:w <CR>a") -- ctrl + s to save file

        -- terminal mappings --
        -- open a terminal
        local term_maps = maps.terminal
        -- get out of terminal mode
        map("t", term_maps.esc_termmode, "<C-\\><C-n>")
        -- hide a term from within terminal mode
        map("t", term_maps.esc_hide_termmode, "<C-\\><C-n> :lua require('core.utils').close_buffer() <CR>")
        -- pick a hidden term
        map("n", term_maps.pick_term, ":Telescope terms <CR>")
        -- open terminal alts
        -- TODO this opens on top of an existing vert/hori term, fixme
        -- map("n", term_maps.new_terminal, ":ToggleTerm")
        map("n", term_maps.new_horizontal, ":execute 15 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>")
        map("n", term_maps.new_vertical, ":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>")
        -- terminal mappings end --

        -- Add Packer commands because we are not loading it at startup
        cmd "silent! command PackerClean   lua require 'plugins' require('packer').clean()"
        cmd "silent! command PackerCompile lua require 'plugins' require('packer').compile()"
        cmd "silent! command PackerInstall lua require 'plugins' require('packer').install()"
        cmd "silent! command PackerStatus  lua require 'plugins' require('packer').status()"
        cmd "silent! command PackerSync    lua require 'plugins' require('packer').sync()"
        cmd "silent! command PackerUpdate  lua require 'plugins' require('packer').update()"

    end

    local function user_config_mappings()
        local custom_maps = config.custom.mappings or ""
        if type(custom_maps) ~= "table" then
            return
        end

        for _, map_table in pairs(custom_maps) do
            map(unpack(map_table))
        end
    end

    non_config_mappings()
    optional_mappings()
    required_mappings()
    user_config_mappings()
end

-- below are all plugin related mappings

M.better_escape = function()
    vim.g.better_escape_shortcut = plugin_maps.better_escape.esc_insertmode or { "" }
end

M.bufferline = function()
    local m = plugin_maps.bufferline

    map("n", m.next_buffer, ":BufferLineCycleNext <CR>")
    map("n", m.prev_buffer, ":BufferLineCyclePrev <CR>")
    map("n", m.moveLeft,    "<C-w>h")
    map("n", m.moveRight,   "<C-w>l")
    map("n", m.moveUp,      "<C-w>k")
    map("n", m.moveDown,    "<C-w>j")
end

M.chadsheet = function()
    local m = plugin_maps.chadsheet

    map("n", m.default_keys, ":lua require('cheatsheet').show_cheatsheet_telescope() <CR>")
    map(
    "n",
    m.user_keys,
    ":lua require('cheatsheet').show_cheatsheet_telescope{bundled_cheatsheets = false, bundled_plugin_cheatsheets = false } <CR>"
    )
end

M.comment = function()
    local m = plugin_maps.comment.toggle
    map("n", m, ":CommentToggle <CR>")
    map("v", m, ":CommentToggle <CR>")
end

M.dashboard = function()
    local m = plugin_maps.dashboard

    map("n", m.bookmarks,    ":DashboardJumpMarks <CR>")
    map("n", m.new_file,     ":DashboardNewFile <CR>")
    map("n", m.open,         ":Dashboard <CR>")
    map("n", m.session_load, ":SessionLoad <CR>")
    map("n", m.session_save, ":SessionSave <CR>")
end

M.godbolt = function()
    local m = plugin_maps.godbolt
    map("n", m.run, ":Godbolt <CR>")
    map("v", m.run, ":'<,'>:Godbolt <CR>")
end

M.hop = function()
    local m = plugin_maps.hop
    map({"n", "o", "v"}, m.char_one,   "<CMD>HopChar1<CR>",     { silent = true })
    map({"n", "o", "v"}, m.pattern,    "<CMD>HopPattern<CR>",   { silent = true })
    map({"n", "o", "v"}, m.line_start, "<CMD>HopLineStart<CR>", { silent = true })
end

M.nvimtree = function()
    map("n", plugin_maps.nvimtree.toggle, ":NvimTreeToggle <CR>")
end

M.neoformat = function()
    map("n", plugin_maps.neoformat.format, ":Neoformat <CR>")
end

M.telescope = function()
    local m = plugin_maps.telescope
    map("n", m.buffers,         ":Telescope buffers <CR>")
    map("n", m.find_files,      ":Telescope find_files <CR>")
    map("n", m.grep_buffer,     ":Telescope current_buffer_fuzzy_find <CR>")
    map("n", m.file_browser,    ":Telescope file_browser <CR>")
    map("n", m.git_commits,     ":Telescope git_commits <CR>")
    map("n", m.git_status,      ":Telescope git_status <CR>")
    map("n", m.help_tags,       ":Telescope help_tags <CR>")
    map("n", m.live_grep,       ":Telescope live_grep <CR>")
    map("n", m.oldfiles,        ":Telescope oldfiles <CR>")
    map("n", m.themes,          ":Telescope themes <CR>")
    map("n", m.man_pages,       -- section 3 for cppman pages
    ":lua require('telescope.builtin').man_pages({sections={'3',}}) <CR>")
    map("n", m.treesitter,      ":Telescope treesitter <CR>")
    -- lsp related
    map("n", m.references,      ":Telescope lsp_references <CR>")
    map("n", m.code_action,     ":Telescope lsp_code_actions theme=get_cursor <CR>")
    map("v", m.code_action,     ":Telescope lsp_range_code_actions theme=get_cursor <CR>")
    map("n", m.doc_diagnostics, ":Telescope lsp_document_diagnostics <CR>")
    map("n", m.doc_symbols,     ":Telescope lsp_document_symbols <CR>")
    map("n", m.ws_diagnostics,  ":Telescope lsp_workspace_diagnostics <CR>")
    map("n", m.ws_symbols,      ":Telescope lsp_dynamic_workspace_symbols <CR>")
end

M.telescope_media = function()
    local m = plugin_maps.telescope_media

    map("n", m.media_files, ":Telescope media_files <CR>")
end

-- M.toggleterm = function()
--     local m = plugin_maps.toggleterm
-- end

M.truezen = function()
    local m = plugin_maps.truezen

    map("n", m.ataraxis_mode,     ":TZAtaraxis <CR>")
    map("n", m.focus_mode,        ":TZFocus <CR>")
    map("n", m.minimalistic_mode, ":TZMinimalist <CR>")
end

M.vim_fugitive = function()
    local m = plugin_maps.vim_fugitive

    map("n", m.git,        ":Git <CR>")
    map("n", m.git_blame,  ":Git blame <CR>")
    map("n", m.diff_get_2, ":diffget //2 <CR>")
    map("n", m.diff_get_3, ":diffget //3 <CR>")
end

return M
