local present, true_zen = pcall(require, "true-zen")
if not present then
    return
end


local colors = require("colors").get()

true_zen.setup {
    ui = {
        bottom = {
            cmdheight = 1,
            laststatus = 0,
            ruler = false,
            showmode = false,
            showcmd = false,
        },
        top = {
            showtabline = 0,
        },
        left = {
            number = false,
            relativenumber = false,
            signcolumn = "no",
        },
    },
    modes = {
        ataraxis = {
            left_padding = 32,
            right_padding = 32,
            top_padding = 1,
            bottom_padding = 1,
            ideal_writing_area_width = { 0 },
            auto_padding = true,
            keep_default_fold_fillchars = true,
            custom_bg = "",
            bg_configuration = true,
            affected_higroups = {
                NonText = {},
                FoldColumn = {},
                ColorColumn = {},
                VertSplit = {},
                StatusLine = true,
                StatusLineNC = true,
                SignColumn = {},
            },
        },
        focus = {
            margin_of_error = 5,
            focus_method = "experimental",
        },
    },
    integrations = {
        feline = true,
        vim_gitgutter = false,
        tmux = false,
        gitsigns = false,
        nvim_bufferline = true,
        limelight = false,
        vim_airline = false,
        vim_powerline = false,
        vim_signify = false,
        express_line = false,
        lualine = false,
    },
    misc = {
        on_off_commands = false,
        ui_elements_commands = false,
        cursor_by_mode = false,
    },
}
