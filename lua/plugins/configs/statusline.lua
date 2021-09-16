local colors = require("colors").get()
local lsp = require "feline.providers.lsp"

local section_color = colors.lightbg

local icon_styles = {
    arrow = {
        left = "█",
        right = "█",
    },

    block = {
        left = "█",
        right = "█",
    },

    round = {
        left = "",
        right = "",
    },

    slant = {
        left = "█",
        right = "█",
    },
}

local hide_inactive = require("core.utils").load_config().ui.plugin.statusline.hide_inactive
local user_statusline_style = require("core.utils").load_config().ui.plugin.statusline.style
local statusline_style = icon_styles[user_statusline_style]

local mode_colors = {
    ["n"]  = { "NORMAL",    colors.red },
    ["no"] = { "N-PENDING", colors.red },
    ["i"]  = { "INSERT",    colors.green },
    ["ic"] = { "INSERT",    colors.green },
    ["t"]  = { "TERMINAL",  colors.dark_purple },
    ["v"]  = { "VISUAL",    colors.cyan },
    ["V"]  = { "V-LINE",    colors.cyan },
    [""] = { "V-BLOCK",   colors.cyan },
    ["R"]  = { "REPLACE",   colors.orange },
    ["Rv"] = { "V-REPLACE", colors.orange },
    ["s"]  = { "SELECT",    colors.nord_blue },
    ["S"]  = { "S-LINE",    colors.nord_blue },
    [""] = { "S-BLOCK",   colors.nord_blue },
    ["c"]  = { "COMMAND",   colors.dark_purple },
    ["cv"] = { "COMMAND",   colors.dark_purple },
    ["ce"] = { "COMMAND",   colors.dark_purple },
    ["r"]  = { "PROMPT",    colors.teal },
    ["rm"] = { "MORE",      colors.teal },
    ["r?"] = { "CONFIRM",   colors.teal },
    ["!"]  = { "SHELL",     colors.green },
}

local vim_mode = {
    left_sep = {
        str = statusline_style.left,
        hi = {
            fg = section_color,
        },
    },

    provider = function()
        return mode_colors[vim.fn.mode()][1]
    end,

    hl = function()
        return {
            fg = mode_colors[vim.fn.mode()][2],
            bg = section_color,
            style = "bold",
        }
    end,

    right_sep = {
        str = statusline_style.right .. " ",
        hi = {
            fg = section_color,
        },
    },
}


local file = {
    left_sep = {
        str = statusline_style.left,
        hi = {
            fg = section_color,
        },
    },

--     provider = function()
--         local filename = vim.fn.expand "%:t"
--         local extension = vim.fn.expand "%:e"
--         local icon = require("nvim-web-devicons").get_icon(filename, extension)
--
--         if icon == nil then
--             icon = ""
--             if filename == "" then
--                 return icon .. " "
--             end
--         end
--
--         return icon .. " " .. filename .. " "
--     end,

    provider = "file_info",
    colored_icon = false,
    file_readonly_icon = '',
    file_modified_icon = '',

    hl = {
        fg = colors.vibrant_green,
        bg = section_color,
        style = "bold"
    },

    right_sep = { str = "│ ", hl = { fg = colors.statusline_bg, bg = section_color } },
}

local directory = {
    provider = function()
        local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        return " " .. dir_name
    end,

    hl = {
        fg = colors.nord_blue,
        bg = section_color,
        style= "bold"
    },

    right_sep = {
        str = statusline_style.right,
        hi = {
            fg = section_color,
        }
    },
}

local git_left_sep = {
    provider = function()
        local git = vim.g.gitsigns_head or vim.b.gitsigns_head
        if git then
            return " " .. statusline_style.left
        else
            return ""
        end
    end,

    hl = {
        fg = section_color,
    },
}

local git_branch = {
    provider = "git_branch",
    icon = " ",
    hl = {
        fg = colors.vibrant_green,
        bg = section_color,
        style = "bold",
    },
}

-- diffRemove
local git_removed = {
    provider = "git_diff_removed",
    hl = {
        fg = colors.red,
        bg = section_color,
    },
    icon = "  ",
}

-- diffModfified
local git_changed = {
    provider = "git_diff_changed",
    hl = {
        fg = colors.orange,
        bg = section_color,
    },
    icon = "  ",
}

-- diffAdded
local git_added = {
    provider = "git_diff_added",
    hl = {
        fg = colors.green,
        bg = section_color,
    },
    icon = " 落",
}

local git_right_sep = {
    provider = function()
        local git = vim.g.gitsigns_head or vim.b.gitsigns_head
        if git then
            return statusline_style.right .. " "
        else
            return ""
        end
    end,
    hl = {
        fg = section_color,
    },
}

local lsp_message = {
    provider = function()
        local Lsp = vim.lsp.util.get_progress_messages()[1]
        if Lsp then
            local msg = Lsp.message or ""
            local percentage = Lsp.percentage or 0
            local title = Lsp.title or ""

            local spinners = {
                " ",
                " ",
                " ",
            }

            local success_icon = {
                " ",
                " ",
                " ",
            }

            local ms = vim.loop.hrtime() / 1000000
            local frame = math.floor(ms / 120) % #spinners

            if percentage >= 70 then
                return string.format("%%<%s %s %s (%s%%%%) ",
                success_icon[frame + 1], title, msg, percentage)
            else
                return string.format("%%<%s %s %s (%s%%%%) ",
                spinners[frame + 1], title, msg, percentage)
            end
        end
        return ""
    end,

    hl = {
        fg = colors.green,
    },
}

local lsp_left_sep = {
    provider = statusline_style.left,
    hl = {
        fg = section_color,
    }
}

local lsp_connected = {
    provider = function()
        if next(vim.lsp.buf_get_clients()) ~= nil then
            return " LSP"
        else
            return " LSP"
        end
    end,

    hl = function()
        if next(vim.lsp.buf_get_clients()) ~= nil then
            return { fg = colors.vibrant_green, bg = section_color, style = "bold"}
        else
            return { fg = colors.red, bg = section_color, style = "bold"}
        end
     end,
}

local lsp_errors = {
    provider = "diagnostic_errors",
    enabled = function()
        return lsp.diagnostics_exist "Error"
    end,
    hl = { fg = colors.red, bg = section_color },
    icon = "  "
}

local lsp_warnings = {
    provider = "diagnostic_warnings",
    enabled = function()
        return lsp.diagnostics_exist "Warning"
    end,
    hl = { fg = colors.yellow,  bg = section_color, },
    icon = " 𥉉"
}

local lsp_hints = {
    provider = "diagnostic_hints",
    enabled = function()
        return lsp.diagnostics_exist "Hint"
    end,
    hl = { fg = colors.nord_blue,  bg = section_color, },
    icon = "  "
}

local lsp_infos = {
    provider = "diagnostic_info",
    enabled = function()
        return lsp.diagnostics_exist "Information"
    end,
    hl = { fg = colors.green, bg = section_color, },
    icon = "  "
}

local lsp_right_sep = {
    provider = statusline_style.right .. " ",
    hl = {
        fg = section_color,
    },
}

local position_icon = {
    left_sep = { str = statusline_style.left, hi = {fg = section_color}},
    provider = " ",
    hl = {
        fg = colors.dark_purple,
        bg = section_color,
    },
}

local line_percentage = {
    provider = "line_percentage",

    hl = {
        fg = colors.dark_purple,
        bg = section_color,
        style = "bold"
    },

    right_sep = {
        str = statusline_style.right,
        fg = section_color,
    }
}





local components = { active = {}, inactive = {} }

----- ACTIVE ------

-- Left
table.insert(components.active, {
    vim_mode,
    file,
    directory,
    git_left_sep,
    git_branch,
    git_removed,
    git_changed,
    git_added,
    git_right_sep
})

-- Middle
table.insert(components.active, {
    lsp_message
})

-- Right
table.insert(components.active, {
    lsp_left_sep,
    lsp_connected,
    lsp_errors,
    lsp_warnings,
    lsp_hints,
    lsp_infos,
    lsp_right_sep,
    position_icon,
    line_percentage
})

----- INACTIVE ------

if (hide_inactive == false) then

    -- Left
    table.insert(components.inactive, {
        file,
        directory
    })

    -- Middle
    table.insert(components.inactive, {})

    -- Right
    table.insert(components.inactive, {
        position_icon,
        line_percentage
    })

end

---------------------

require("feline").setup {
    components = components,

    colors = {
        fg = colors.fg,
        bg = colors.statusline_bg,
    },

    disable = {
        filetypes = { "NvimTree", "packer" },
        buftypes  = { "terminal" },
        bufnames  = { }
    }
}
