return {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
        { 'tpope/vim-dadbod', lazy = true },
        -- { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
    },
    init = function()
        -- Your DBUI configuration
        local command = "export SQLCMDINI=~/.local/share/db_ui/init.sql"
        -- local status_code = os.execute("export SQLCMDINI=~/.local/share/db_ui/init.sql")
        local handle = io.popen(command)
        local result = handle:read("*a")
        handle:close()
        vim.g.db_ui_use_nerd_fonts = 1
    end,
}
