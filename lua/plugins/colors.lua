local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
end

return {
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         vim.cmd.colorscheme "tokyonight-night"
    --         -- vim.cmd('hi Directory guibg=NONE')
    --         -- vim.cmd('hi SignColumn guibg=NONE')
    --         enable_transparency()
    --     end
    -- }
    {
        "catppuccin/nvim",
        config = function()
            vim.cmd.colorscheme "catppuccin-mocha"
            -- vim.cmd('hi Directory guibg=NONE')
            -- vim.cmd('hi SignColumn guibg=NONE')
            enable_transparency()
        end
    },
}
