return {
    'kndndrj/nvim-dbee',
    dependencies = {
        'MunifTanjim/nui.nvim',
    },
    build = function()
        -- Install tries to automatically detect the install method.
        -- if it fails, try calling it with one of these parameters:
        --    "curl", "wget", "bitsadmin", "go"
        require('dbee').install()
    end,
    config = function()
        require('dbee').setup {
            sources = {
                -- require("dbee.sources").MemorySource:new({
                --     {
                --         name = "...",
                --         type = "...",
                --         url = "...",
                --     },
                -- }),
                require('dbee.sources').EnvSource:new 'DBEE_CONNECTIONS',
                require('dbee.sources').FileSource:new(vim.fn.stdpath 'cache' .. '/dbee/persistence.json'),
            },
            extra_helpers = {
                ["sqlserver"] = {
                    ["List All"] = "select top 10 * from {{ .Schema }}.{{ .Table }}",
                },
            },
        }
    end,
}
