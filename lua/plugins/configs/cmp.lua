local present, cmp = pcall(require, "cmp")

if not present then
    return
end

vim.opt.completeopt = "menu,menuone,preview"

-- nvim-cmp setup
cmp.setup {
    completion = {
        keyword_length = 2 -- Trigger cmp popup after N characters
    },

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    formatting = {
        format = function(entry, vim_item)
            -- limit size to 40 character
            vim_item.abbr = string.sub(vim_item.abbr, 1, 40)

            -- load lspkind icons
            vim_item.kind = string.format(
            "%s (%s)",
            require("plugins.configs.lspkind_icons").icons[vim_item.kind],
            vim_item.kind
            )

            -- vim_item.menu = ({
            --    nvim_lsp    = "[LSP]",
            --    nvim_lua    = "[Lua]",
            --    buffer      = "[BUF]",
            --    cmp_tabnine = "[T9]",
            -- })[entry.source.name]

                return vim_item
            end,
    },

    mapping = {
        ["<C-n>"]     = cmp.mapping.select_next_item(),
        ["<C-d>"]     = cmp.mapping.scroll_docs(-4),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"]     = cmp.mapping.close(),
        ["<Up>"]      = cmp.mapping.close(),
        ["<Down>"]    = cmp.mapping.close(),
        ["<Left>"]    = cmp.mapping.close(),
        ["<Right>"]   = cmp.mapping.close(),
        ["<CR>"]      = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },

        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                "<Plug>luasnip-expand-or-jump", true, true, true), "")
            else
                fallback()
            end
        end,

        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                "<Plug>luasnip-jump-prev", true, true, true), "")
            else
                fallback()
            end
        end,
    },

    window = {
        documentation = {
            border = {
                {"╭", "FloatBorder"},
                {"─", "FloatBorder"},
                {"╮", "FloatBorder"},
                {"│", "FloatBorder"},
                {"╯", "FloatBorder"},
                {"─", "FloatBorder"},
                {"╰", "FloatBorder"},
                {"│", "FloatBorder"}
            },
        },
    },

    sources = {
        { name = "nvim_lsp"                },
        { name = "luasnip"                 },
        { name = "buffer"                  },
        { name = "nvim_lua"                },
        { name = "path"                    },
        { name = "cmdline"                 },
        -- { name = "nvim_lsp_signature_help" }
        -- { name = "cmp_tabnine" },
    },
}
