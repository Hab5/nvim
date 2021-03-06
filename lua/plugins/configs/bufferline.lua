local colors = require("colors").get()

local present, bufferline = pcall(require, "bufferline")
if not present then
    return
end

bufferline.setup {
    options = {
        numbers = "none",
        offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
        buffer_close_icon = "",
        show_buffer_close_icons = true,
        close_icon = "",
        show_close_icon = false,
        modified_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 16,
        max_prefix_length = 13,
        tab_size = 0,
        show_tab_indicators = true,
        enforce_regular_tabs = false, -- use tab_size for all tabs
        view = "multiwindow",
        separator_style = {"",""},
        always_show_bufferline = true,
        diagnostics = false, -- "nvim_lsp",
        diagnostics_indicator = function(count, level)
            return "("..count..")"
        end,

        -- custom_areas = {
        --     right = function()
        --         local result = {}
        --         table.insert(result, {text = "", guifg = colors.lightbg})
        --         table.insert(result, {text = "something", guifg = colors.red, guibg=colors.lightbg})
        --         table.insert(result, {text = "", guifg = colors.lightbg})
        --         return result
        --     end,
        -- },

        custom_filter = function(buf_number)
            -- Func to filter out our managed/persistent split terms
            local present_type, type = pcall(function()
                return vim.api.nvim_buf_get_var(buf_number, "term_type")
            end)

            if present_type then
                if type == "vert" then
                    return false
                elseif type == "hori" then
                    return false
                else
                    return true
                end
            else
                return true
            end
        end,
    },

    highlights = {
        background = {
            guifg = colors.grey_fg,
            guibg = colors.black2,
        },

        -- buffers
        buffer_selected = {
            guifg = colors.white,
            guibg = colors.black,
            gui = "bold",
        },

        buffer_visible = {
            guifg = colors.light_grey,
            guibg = colors.black2,
        },

        error = {
            guifg = colors.light_grey,
            guibg = colors.black2,
        },

        error_diagnostic = {
            guifg = colors.light_grey,
            guibg = colors.black2,
        },

        -- close buttons
        close_button = {
            guifg = colors.light_grey,
            guibg = colors.black2,
        },
        close_button_visible = {
            guifg = colors.light_grey,
            guibg = colors.black2,
        },
        close_button_selected = {
            guifg = colors.red,
            guibg = colors.black,
        },
        fill = {
            guifg = colors.grey_fg,
            guibg = colors.black2,
        },
        indicator_selected = {
            guifg = colors.black,
            guibg = colors.black,
        },

        -- modified
        modified = {
            guifg = colors.red,
            guibg = colors.black2,
        },
        modified_visible = {
            guifg = colors.red,
            guibg = colors.black2,
        },
        modified_selected = {
            guifg = colors.green,
            guibg = colors.black,
        },

        -- separators
        separator = {
            guifg = colors.black2,
            guibg = colors.black2,
        },
        separator_visible = {
            guifg = colors.black2,
            guibg = colors.black2,
        },
        separator_selected = {
            guifg = colors.black2,
            guibg = colors.black2,
        },

        -- tabs
        tab = {
            guifg = colors.light_grey,
            guibg = colors.one_bg3,
        },
        tab_selected = {
            guifg = colors.black2,
            guibg = colors.vibrant_green,
        },
        tab_close = {
            guifg = colors.red,
            guibg = colors.black,
        },
    },
}
