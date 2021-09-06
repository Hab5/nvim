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

-- Initialize the components table
local components = {
    left = { active = {}, inactive = {} },
    mid = { active = {}, inactive = {} },
    right = { active = {}, inactive = {} },
}

-- neovim mode
components.left.active[1] = {
    left_sep = {
        str = " " .. statusline_style.left,
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
        str = statusline_style.right,
        hi = {
            fg = section_color,
        },
    },

}

components.left.active[2] = {
    left_sep = {
        str = " " .. statusline_style.left,
        hi = {
            fg = section_color,
        },
    },

    provider = function()
        local filename = vim.fn.expand "%:t"
        local extension = vim.fn.expand "%:e"
        local icon = require("nvim-web-devicons").get_icon(filename, extension)

        if icon == nil then
            icon = " "
            return icon
        end

        return icon .. " " .. filename .. " "
    end,

    hl = {
        fg = colors.vibrant_green,
        bg = section_color,
        style = "bold"
    },

    right_sep = { str = "│ ", hl = { fg = colors.statusline_bg, bg = section_color } },
}

components.left.active[3] = {
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

components.left.active[4] = {
    provider = function()
        local git = vim.b.gitsigns_status_dict
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

components.left.active[5] = {
    provider = "git_branch",
    icon = " ",
    hl = {
        fg = colors.vibrant_green,
        bg = section_color,
        style = "bold",
    },
}

-- diffRemove
components.left.active[6] = {
    provider = "git_diff_removed",
    hl = {
        fg = colors.red,
        bg = section_color,
    },
    icon = "  ",
}

-- diffModfified
components.left.active[7] = {
    provider = "git_diff_changed",
    hl = {
        fg = colors.orange,
        bg = section_color,
    },
    icon = "  ",
}

-- diffAdded
components.left.active[8] = {
    provider = "git_diff_added",
    hl = {
        fg = colors.green,
        bg = section_color,
    },
    icon = " 落",
}

components.left.active[9] = {
    provider = function()
        local git = vim.b.gitsigns_status_dict
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

components.mid.active[1] = {
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

components.right.active[1] = {
    provider = statusline_style.left,
    hl = {
        fg = section_color,
    }
}

components.right.active[2] = {
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

components.right.active[3] = {
    provider = "diagnostic_errors",
    enabled = function()
        return lsp.diagnostics_exist "Error"
    end,
    hl = { fg = colors.red, bg = section_color },
    icon = "  "
}

components.right.active[4] = {
    provider = "diagnostic_warnings",
    enabled = function()
        return lsp.diagnostics_exist "Warning"
    end,
    hl = { fg = colors.yellow,  bg = section_color, },
    icon = " 𥉉"
}

components.right.active[5] = {
    provider = "diagnostic_hints",
    enabled = function()
        return lsp.diagnostics_exist "Hint"
    end,
    hl = { fg = colors.nord_blue,  bg = section_color, },
    icon = "  "
}

components.right.active[6] = {
    provider = "diagnostic_info",
    enabled = function()
        return lsp.diagnostics_exist "Information"
    end,
    hl = { fg = colors.green, bg = section_color, },
    icon = "  "
}

components.right.active[7] = {
    provider = statusline_style.right .. " " .. statusline_style.left,
    hl = {
        fg = section_color,
    },
}

components.right.active[8] = {
    provider = " ",
    hl = {
        fg = colors.dark_purple,
        bg = section_color,
    },
}

components.right.active[9] = {
    provider = "line_percentage",

    hl = {
        fg = colors.dark_purple,
        bg = section_color,
        style = "bold"
    },

    right_sep = {
        str = statusline_style.right .. " ",
        fg = section_color,
    }

}

-- same bar for inactive windows
if (hide_inactive) ~= false then
    components.left.inactive = components.left.active
    components.mid.inactive = components.mid.active
    components.right.inactive = components.right.active
end

require("feline").setup {
    default_bg = colors.statusline_bg,
    default_fg = colors.fg,
    components = components,
}
