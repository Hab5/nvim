-- IMPORTANT NOTE : This is the user config, can be edited. Will be preserved if updated with internal updater

local M = {}
M.ui, M.options, M.plugin_status, M.mappings, M.custom = {}, {}, {}, {}, {}

-- non plugin ui configs, available without any plugins
M.ui = {
    italic_comments = false,

    -- theme to be used, to see all available themes, open the theme switcher by <leader> + th
    theme = "onedark",

    -- theme toggler, toggle between two themes, see theme_toggleer mappings
    theme_toggler = {
        enabled = false,
        fav_themes = {
            "onedark",
            "onenord",
        },
    },

    -- Enable this only if your terminal has the colorscheme set which nvim uses
    -- For Ex : if you have onedark set in nvim , set onedark's bg color on your terminal
    transparency = false,
}

-- plugin related ui options
M.ui.plugin = {
    -- statusline related options
    statusline = {
        hide_inative = true, -- hide statusline on inactive buffers
        -- these are filetypes, not pattern matched
        -- if a filetype is present in shown, it will always show the statusline, irrespective of filetypes in hidden
        hidden = {},
        shown  = {},
        -- round , slant , block , arrow
        style = "round",
    },
}

-- non plugin normal, available without any plugins
M.options = {
    mapleader         = " ",
    clipboard         = "unnamedplus",
    showmode          = false, -- don't show mode in status line (let feline display that)
    cmdheight         = 1,
    copy_cut          = true, -- copy cut text ( x key ), visual and normal mode
    copy_del          = true, -- copy deleted text ( dd key ), visual and normal mode
    expandtab         = true,
    hidden            = true,
    ignorecase        = true,
    insert_nav        = true, -- navigation in insertmode
    mouse             = "a",
    number            = true,
    numberwidth       = 2,
    permanent_undo    = true,
    shiftwidth        = 4,
    smartindent       = true,
    tabstop           = 4, -- Number of spaces that a <Tab> in the file counts for
    timeoutlen        = 400,
    relativenumber    = true,
    ruler             = false,
    updatetime        = 250,
    pumheight         = 10,
    title             = false, -- Window title = active buffer
}

-- these are plugin related options
M.options.plugin = {
    autosave = false, -- autosave on changed text or insert mode leave
    -- timeout to be used for using escape with a key combination, see mappings.plugin.better_escape
    esc_insertmode_timeout = 300,
}

-- enable and disable plugins (false for disable)
M.plugin_status = {
    autosave          = false, -- to autosave files
    blankline         = false, -- beautified blank lines
    bufferline        = true, -- buffer shown as tabs
    cheatsheet        = true, -- fuzzy search your commands/keymappings
    colorizer         = true,
    comment           = true, -- universal commentor
    dashboard         = true, -- a nice looking dashboard
    esc_insertmode    = true, -- escape from insert mode using custom keys
    feline            = true, -- statusline
    gitsigns          = true, -- gitsigns in statusline
    lspkind           = true, -- lsp enhancements
    lspsignature      = true, -- lsp enhancements
    neoformat         = true, -- universal formatter
    neoscroll         = true, -- smooth scroll
    telescope_media   = true, -- see media files in telescope picker
    truezen           = true, -- no distraction mode for nvim
    toggleterm        = true, -- popup/floating terminals
    vim_fugitive      = false, -- git in nvim
    vim_matchup       = true, -- % magic, match it but improved
}

-- mappings -- don't use a single keymap twice --
-- non plugin mappings
M.mappings = {
    -- buffer
    close_buffer       = "<leader>bk",
    new_buffer         = "<leader>bn", -- open a new buffer
    copy_whole_file    = "<C-a>", -- copy all contents of the current buffer
    line_number_toggle = "<leader>n", -- show or hide line number
    save_file          = "<C-s>", -- save file using :w

    -- general navigation
    beginning_of_line = "<Home>",
    prev_blank_line   = "<C-Up>",
    next_blank_line   = "<C-Down>",
    move_line_down    = "<M-Down>", -- (Alt + Down)
    move_line_up      = "<M-Up>", -- (Alt + Up)

    -- navigation in insert mode, only if enabled in options
    insert_nav = {
        beginning_of_line = "<Home>", -- First Character of line
        prev_blank_line   = "<C-Up>",
        next_blank_line   = "<C-Down>",
    },

    theme_toggler      = "<leader>tt", -- for theme toggler, see in ui.theme_toggler
    -- new_tab = "<C-t>b", -- open a new vim tab

    -- terminal related mappings
    terminal = {
        -- get out of terminal mode
        esc_termmode      = { "jk" }, -- multiple mappings allowed
        -- get out of terminal mode and hide it
        esc_hide_termmode = { "JK", "<C-t>" }, -- multiple mappings allowed
        pick_term         = "<leader>W", -- Show hidden terminals in Telescope
        toggle_terminal   = "<C-t>",
        new_horizontal    = "<leader>h",
        new_vertical      = "<leader>v",
    },
}

-- all plugins related mappings
-- to get short info about a plugin, see the respective string in plugin_status, if not present, then info here
M.mappings.plugin = {
    bufferline = {
        next_buffer = "<TAB>", -- next buffer
        prev_buffer = "<S-Tab>", -- previous buffer

        --better window movement
        moveLeft    = "<C-h>",
        moveRight   = "<C-l>",
        moveUp      = "<C-k>",
        moveDown    = "<C-j>",
    },

    chadsheet = {
        default_keys = "<leader>dk",
        user_keys    = "<leader>uk",
    },

    comment = {
        toggle       = "<C-_>", -- comment a line (ctrl+/)
    },

    dashboard = {
        open         = "<leader>db", -- open dashboard
        bookmarks    = "<leader>bm",
        new_file     = "<leader>fn", -- basically create a new buffer
        session_load = "<leader>l", -- load a saved session
        session_save = "<leader>s", -- save a session
    },

    -- note: this is an edditional mapping to escape, escape key will still work
    better_escape = {
        esc_insertmode = { "jk" }, -- multiple mappings allowed
    },

    nvimtree = {
        toggle = "<C-n>", -- file manager
    },

    neoformat = {
        format = "<leader>fm",
    },

    telescope = {
        buffers      = "<leader>fb",
        find_files   = "<leader>ff",
        grep_buffer  = "<leader>ss",
        file_browser = "<leader>.",
        git_commits  = "<leader>cm",
        git_status   = "<leader>gt",
        help_tags    = "<leader>fh",
        live_grep    = "<leader>fw",
        oldfiles     = "<leader>fo",
        themes       = "<leader>th",
    },

    telescope_media = {
        media_files = "<leader>fp",
    },

    toggleterm = {
        toggle = "<C-t>",
    },

    truezen = { -- distraction free modes mapping, hide statusline, tabline, line numbers
    ataraxis_mode     = "<leader>zz", -- center
    focus_mode        = "<leader>zf",
    minimalistic_mode = "<leader>zm", -- as it is
},

vim_fugitive = {
    diff_get_2 = "<leader>gh",
    diff_get_3 = "<leader>gl",
    git        = "<leader>gs",
    git_blame  = "<leader>gb",
},
}

-- user custom mappings
-- e.g: name = { "mode" , "keys" , "cmd" , "options"}
-- name: can be empty or something unique with repect to other custom mappings
--    { mode, key, cmd } or name = { mode, key, cmd }
-- mode: usage: mode or { mode1, mode2 }, multiple modes allowed, available modes => :h map-modes,
-- keys: multiple keys allowed, same synxtax as modes
-- cmd:  for vim commands, must use ':' at start and add <CR> at the end if want to execute
-- options: see :h nvim_set_keymap() opts section
M.custom.mappings = {
    -- clear_all = {
        --    "n",
        --    "<leader>cc",
        --    "gg0vG$d",
        -- },
    }

    return M
