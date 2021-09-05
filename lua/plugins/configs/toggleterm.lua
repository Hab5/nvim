local present, toggleterm = pcall(require, "toggleterm")
if not present then
    return
end

toggleterm.setup {
    direction = 'float',
    open_mapping = "<C-t>",
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 1,
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = true,
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
        -- The border key is *almost* the same as 'nvim_open_win'
        -- see :h nvim_open_win for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = 'curved', -- | 'single' | 'double' | 'shadow' | 'curved' |
        width = 180,
        height = 40,
        winblend = 0,
        highlights = {
            border     = "FloatBorder",
            background = "Normal"
        }
    }
}
