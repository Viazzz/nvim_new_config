return {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
        },
        settings = {
            -- tsserver_max_memory = "auto",
            tsserver_plugins = {
                "@vue/typescript-plugin",
            },
            -- tsserver_file_preferences = {
            --     "javascript",
            --     "javascriptreact",
            --     "javascript.jsx",
            --     "typescript",
            --     "typescriptreact",
            --     "typescript.tsx",
            --     "vue",
            -- includeInlayParameterNameHints = "all",
            -- includeCompletionsForModuleExports = true,
            -- quotePreference = "auto",
            -- },
            -- tsserver_preferences = {},
            -- expose_as_code_action = "all",
        },
    },
}
