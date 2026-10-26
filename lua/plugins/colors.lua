local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
end

-- return {
--     -- {
--     --     "folke/tokyonight.nvim",
--     --     lazy = false,
--     --     priority = 1000,
--     --     opts = {},
--     --     config = function()
--     --         vim.cmd.colorscheme "tokyonight-night"
--     --         -- vim.cmd('hi Directory guibg=NONE')
--     --         -- vim.cmd('hi SignColumn guibg=NONE')
--     --         enable_transparency()
--     --     end
--     -- }
--     {
--         "catppuccin/nvim",
--         config = function()
--             vim.cmd.colorscheme "catppuccin-mocha"
--             -- vim.cmd('hi Directory guibg=NONE')
--             -- vim.cmd('hi SignColumn guibg=NONE')
--             enable_transparency()
--         end
--     },
-- }
return { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = {
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "soft", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
},
        config = function()
            vim.cmd.colorscheme "gruvbox"
            enable_transparency()
        end
}

