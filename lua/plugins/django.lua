return {
    "mizisu/django.nvim",
    dependencies = {
        { "folke/snacks.nvim" },
        {
            "saghen/blink.cmp",
            optional = true,
            opts = {
                sources = {
                    default = { "django" },
                    providers = {
                        django = {
                            name = "Django",
                            module = "django.completions.blink",
                            async = true,
                        },
                    },
                },
            },
        },
    },
    config = function()
        require("django").setup({
            -- Default configuration
            -- views = {
            --   auto_refresh = {
            --     on_picker_open = true,
            --     file_watch_patterns = {
            --       "*/urls.py",
            --       "*/views.py",
            --       "*/view.py",
            --       "*/*views.py",
            --       "*/*view.py",
            --       "*/*viewset.py",
            --       "*/*view_set.py",
            --       "*/*api.py",
            --     },
            --   },
            -- },
            -- models = {
            --   auto_refresh = {
            --     on_picker_open = true,
            --     file_watch_patterns = { "*/models.py", "*/models/*.py" },
            --   },
            -- },
            -- shell = {
            --   command = "shell",  -- "shell", "shell_plus", "shell_plus --ipython", etc.
            --   position = "right", -- "bottom", "top", "left", "right", "float"
            --   env = {},           -- { DJANGO_SETTINGS_MODULE = "myproject.settings" }
            -- },
        })
    end,
}
