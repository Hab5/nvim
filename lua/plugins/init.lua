local present, packer = pcall(require, "plugins.packerInit")

if not present then
    return false
end

local use = packer.use

return packer.startup(function()
    local plugin_status = require("core.utils").load_config().plugin_status

    -- this is arranged on the basis of when a plugin starts

    use {
        "Nvchad/extensions",
    }

    use {
        "nvim-lua/plenary.nvim",
    }

    use {
        "wbthomason/packer.nvim",
        event = "VimEnter",
    }

    use {
        "NvChad/base46",
        commit = "528f9d02f0888e3a0b61e52bf13a2a78af938d88",
        as = "nvim-base16.lua",
        after = "packer.nvim",
        config = function()
            require("colors").init()
        end,
    }

    use {
        "kyazdani42/nvim-web-devicons",
        after = "nvim-base16.lua",
        config = function()
            require "plugins.configs.icons"
        end,
    }


    use {
        "famiu/feline.nvim",
        disable = not plugin_status.feline,
        after = "nvim-web-devicons",
        config = function()
            require "plugins.configs.statusline"
        end,
    }

    use {
        "akinsho/bufferline.nvim",
        disable = not plugin_status.bufferline,
        after = "nvim-web-devicons",
        config = function()
            require "plugins.configs.bufferline"
        end,
        setup = function()
            require("core.mappings").bufferline()
        end,
    }

    use {
        "akinsho/toggleterm.nvim",
        disable = not plugin_status.toggleterm,
        after = "nvim-web-devicons",
        config = function()
           require "plugins.configs.toggleterm"
        end,
    }

    use {
        "phaazon/hop.nvim",
        as = "hop",
        event = "BufRead",
        config = function()
            require("plugins.configs.others").hop()
        end,
        setup = function()
            require("core.mappings").hop()
        end,
    }

    use {
        "lukas-reineke/indent-blankline.nvim",
        disable = not plugin_status.blankline,
        event = "BufRead",
        config = function()
            require("plugins.configs.others").blankline()
        end,
    }

    use {
        "norcalli/nvim-colorizer.lua",
        disable = not plugin_status.colorizer,
        event = "BufRead",
        config = function()
            require("plugins.configs.others").colorizer()
        end,
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        config = function()
            require "plugins.configs.treesitter"
        end,
    }

    -- git stuff
    use {
        "lewis6991/gitsigns.nvim",
        disable = not plugin_status.gitsigns,
        opt = true,
        config = function()
            require "plugins.configs.gitsigns"
        end,
        setup = function()
            require("core.utils").packer_lazy_load "gitsigns.nvim"
        end,
    }

    use {
        "p00f/godbolt.nvim",
        disable = not plugin_status.godbolt,
        config = function()
            require("plugins.configs.others").godbolt()
        end,
        setup = function()
            require("core.mappings").godbolt()
        end
    }

    -- smooth scroll
    use {
        "karb94/neoscroll.nvim",
        disable = not plugin_status.neoscroll,
        opt = true,
        config = function()
            require("plugins.configs.others").neoscroll()
        end,
        setup = function()
            require("core.utils").packer_lazy_load "neoscroll.nvim"
        end,
    }

    -- lsp stuff
    use {
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.configs.lspconfig")
        end,
    }

    use {
        "williamboman/nvim-lsp-installer",
        config = function()
            require("plugins.configs.lspinstaller")
        end,
    }


    use {
        "ray-x/lsp_signature.nvim",
        disable = not plugin_status.lspsignature,
        after = "nvim-lspconfig",
        config = function()
            require("plugins.configs.others").signature()
        end,
    }

    use {
        "andymass/vim-matchup",
        disable = not plugin_status.vim_matchup,
        opt = true,
        setup = function()
            require("core.utils").packer_lazy_load "vim-matchup"
        end,
    }

    -- load autosave only if its globally enabled
    use {
        disable = not plugin_status.autosave,
        "Pocco81/AutoSave.nvim",
        config = function()
            require("plugins.configs.others").autosave()
        end,
        cond = function()
            return require("core.utils").load_config().custom.plugin.autosave == true
        end,
    }

    use {
        "jdhao/better-escape.vim",
        disable = not plugin_status.esc_insertmode,
        event = "InsertEnter",
        config = function()
            require("plugins.configs.others").better_escape()
        end,
        setup = function()
            require("core.mappings").better_escape()
        end,
    }

    -- use {
    --     "ms-jpq/coq_nvim",
    --     event = "InsertEnter",
    --     config = function()
    --     end,
    -- }

    -- load luasnips + cmp related in insert mode only
    use {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
    }

    use {
        "hrsh7th/nvim-cmp",
        after = "friendly-snippets",
        config = function()
            require "plugins.configs.cmp"
        end,
    }

    -- use { "tzachar/cmp-tabnine", after="nvim-cmp", run="./install.sh" }

    use {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        after = "nvim-cmp",
        config = function()
            require("plugins.configs.others").luasnip()
        end,
    }

    use {
        "saadparwaiz1/cmp_luasnip",
        after = "LuaSnip",
    }

    use {
        "hrsh7th/cmp-nvim-lua",
        after = "cmp_luasnip",
    }

    use {
        "hrsh7th/cmp-nvim-lsp",
        after = "cmp-nvim-lua",
    }

    use {
        "hrsh7th/cmp-buffer",
        after = "cmp-nvim-lsp",
    }

    -- misc plugins
    use {
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = function()
            require("plugins.configs.others").autopairs()
        end,
    }

    use {
        "glepnir/dashboard-nvim",
        disable = not plugin_status.dashboard,
        config = function()
            require "plugins.configs.dashboard"
        end,
        setup = function()
            require("core.mappings").dashboard()
        end,
    }

    use {
        "anuvyklack/help-vsplit.nvim",
        config = function()
            require("help-vsplit").setup()
        end
    }

    use {
        "sbdchd/neoformat",
        disable = not plugin_status.neoformat,
        cmd = "Neoformat",
        setup = function()
            require("core.mappings").neoformat()
        end,
    }

    --   use "alvan/vim-closetag" -- for html autoclosing tag
    use {
        "terrortylor/nvim-comment",
        disable = not plugin_status.comment,
        cmd = "CommentToggle",
        config = function()
            require("plugins.configs.others").comment()
        end,
        setup = function()
            require("core.mappings").comment()
        end,
    }

    -- file managing , picker etc
    use {
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            require "plugins.configs.nvimtree"
        end,
        setup = function()
            require("core.mappings").nvimtree()
        end,
    }

    use {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        -- because cheatsheet is not activated by a telescope command
        module = "cheatsheet",
        requires = {
            {
                "sudormrfbin/cheatsheet.nvim",
                disable = not plugin_status.cheatsheet,
                after = "telescope.nvim",
                config = function()
                    require "plugins.configs.chadsheet"
                end,
                setup = function()
                    require("core.mappings").chadsheet()
                end,
            },
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make", },
            { "nvim-telescope/telescope-file-browser.nvim" },
            {
                "nvim-telescope/telescope-media-files.nvim",
                disable = not plugin_status.telescope_media,
                setup = function()
                    require("core.mappings").telescope_media()
                end,
            },
        },
        config = function()
            require "plugins.configs.telescope"
        end,
        setup = function()
            require("core.mappings").telescope()
        end,
    }

    use {
        "Pocco81/TrueZen.nvim",
        disable = not plugin_status.truezen,
        cmd = {
            "TZAtaraxis",
            "TZMinimalist",
            "TZFocus",
        },
        config = function()
            require "plugins.configs.zenmode"
        end,
        setup = function()
            require("core.mappings").truezen()
        end,
    }

    use {
        "tpope/vim-fugitive",
        disable = not plugin_status.vim_fugitive,
        cmd = {
            "Git",
            "Gdiff",
            "Gdiffsplit",
            "Gvdiffsplit",
            "Gwrite",
            "Gw",
        },
        setup = function()
            require("core.mappings").vim_fugitive()
        end,
    }

--     use {
--         "hoschi/yode-nvim",
--         config = function()
--             require("yode-nvim").setup({})
--         end
--     }

--     use {
--         "t-troebst/perfanno.nvim",
--         config = function()
--             require("perfanno").setup({})
--         end
--     }
end)
