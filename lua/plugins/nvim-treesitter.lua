return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require 'nvim-treesitter'.setup {
            -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
            install_dir = vim.fn.stdpath('data') .. '/site',
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            autotag = { enable = true },
            require 'nvim-treesitter'.install {
                -- "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "python",
                "javascript",
                "html",
                "sql",

            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    node_incremental = "v",
                    node_decremental = "V",
                },
            },
        }
        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'python', 'rust', 'javascript', 'zig' },
            callback = function()
                -- syntax highlighting, provided by Neovim
                vim.treesitter.start()
                -- folds, provided by Neovim
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.wo.foldmethod = 'expr'
                -- indentation, provided by nvim-treesitter
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
-- return {
--     "nvim-treesitter/nvim-treesitter",
--     -- Run the TSUpdate command every time the plugin is installed or updated
--     build = ":TSUpdate",
--     install_dir = vim.fn.stdpath('data') .. '/site',
--     opts = {
--         -- Enable syntax highlighting
--         highlight = {
--             enable = true,
--         },
--         -- Enable indentation
--         indent = {
--             enable = true,
--         },
--         -- enable autotagging (w/ nvim-ts-autotag plugin)
--         autotag = { enable = true },
--         -- List of languages to install automatically
--         ensure_installed = {
--             "c",
--             "lua",
--             "vim",
--             "vimdoc",
--             "query",
--             "python",
--             "javascript",
--             "html",
--             "sql",
--         },
--         -- Install missing parsers automatically
--         auto_install = true,
--     },
--     -- Configure the plugin after it is loaded
--     config = function(_, opts)
--         require("nvim-treesitter.config").setup(opts)
--         require 'nvim-treesitter'.install { 'sql' }
--     end,
-- }

-- return {
--     "nvim-treesitter/nvim-treesitter",
--     build = ":TSUpdate",
--     -- dependencies = {
--     --     "nvim-treesitter/nvim-treesitter-textobjects",
--     -- },
--     config = function()
--         local configs = require("nvim-treesitter.config")
--         ---@diagnostic disable-next-line: missing-fields
--         configs.setup({
--             textobjects = {
--                 select = {
--                     enable = true,
--                     lookahead = true,
--                     keymaps = {
--                         ["af"] = "@function.outer",
--                         ["if"] = "@function.inner",
--                     },
--                 },
--             },
--             -- enable syntax highlighting
--             highlight = {
--                 enable = true,
--             },
--             -- enable indentation
--             indent = { enable = true },
--             -- enable autotagging (w/ nvim-ts-autotag plugin)
--             autotag = { enable = true },
--             -- ensure these language parsers are installed
--             ensure_installed = {
--                 "json",
--                 "python",
--                 "javascript",
--                 "query",
--                 "typescript",
--                 "tsx",
--                 "php",
--                 "yaml",
--                 "html",
--                 "css",
--                 "markdown",
--                 "markdown_inline",
--                 "bash",
--                 "lua",
--                 "vim",
--                 "vimdoc",
--                 "c",
--                 "dockerfile",
--                 "gitignore",
--                 "astro",
--                 "sql",
--                 "htmldjango",
--             },
--             -- auto install above language parsers
--             auto_install = true,
--         })
--     end
-- }
--     end
-- }
