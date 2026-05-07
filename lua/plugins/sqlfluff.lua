return {
    'michhernand/simple-sqlfluff.nvim',
    keys = {
        { '<leader>Sf', '<cmd>SQLFluffFormat<CR>',  desc = 'Format w/ SQLFluff' },
        { '<leader>St', '<cmd>SQLFluffToggle<CR>',  desc = 'Toggle SQLFluff Linting' },
        { '<leader>Se', '<cmd>SQLFluffEnable<CR>',  desc = 'Enable SQLFluff Linting' },
        { '<leader>Sd', '<cmd>SQLFluffDisable<CR>', desc = 'Disable SQLFluff Linting' },
        vim.keymap.set('n', '<leader>Sx', function()
            local file = vim.fn.shellescape(vim.fn.expand '%:p')
            vim.cmd('silent !sqlfluff fix ' .. file .. ' --force')
            vim.cmd 'edit!' -- перезагружаем файл, чтобы увидеть правки
        end, { desc = 'Fix w/ SQLFluff' }),
    },
    opts = {
        autocommands = {
            enabled = true, -- global on/off switch for linting

            -- An array of events to run sqlfluff lint on - if empty, linting is disabled
            events = {
                'BufReadPost',
                'InsertLeave',
            },

            -- An array of file extensions to run sqlfluff lint on - if empty, linting is disabled
            extensions = {
                '*.sql',
            },
        },
    },
}
