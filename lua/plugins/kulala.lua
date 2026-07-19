return {
    "mistweaverco/kulala.nvim",
    config = function()
        require("kulala").setup({
            -- Sane default configs
            display_mode = "split", -- Open responses in a split window
            default_view = "body", -- Show only the body initially
        })

        -- Practical Keymaps
        vim.keymap.set("n", "<leader>R", "", { desc = "+Rest Client" })
        vim.keymap.set("n", "<leader>Rr", function() require("kulala").run() end, { desc = "Run current request" })
        vim.keymap.set("n", "<leader>Rt", function() require("kulala").toggle_view() end,
            { desc = "Toggle headers/body" })
        vim.keymap.set("n", "<leader>Rj", function() require("kulala").jump_next() end, { desc = "Jump to next request" })
        vim.keymap.set("n", "<leader>Rk", function() require("kulala").jump_prev() end, { desc = "Jump to prev request" })
    end,
}
