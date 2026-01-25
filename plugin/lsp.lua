local api = vim.api
vim.lsp.config('*', {
    root_markers = { '.git' },
})

vim.diagnostic.config {
    virtual_text = true,
    severity_sort = true,
    float = {
        style = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '▲',
            [vim.diagnostic.severity.HINT] = '⚑',
            [vim.diagnostic.severity.INFO] = '»',
        },
    },
}
-- put early in lsp.lua
local orig = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    opts.max_width = opts.max_width or 80
    opts.max_height = opts.max_height or 24
    opts.wrap = opts.wrap ~= false
    return orig(contents, syntax, opts, ...)
end

-- 4) Per-buffer behavior on LSP attach (keymaps, auto-format, completion)
-- See :help LspAttach for the recommended pattern
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local buf = args.buf
        local map = function(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf })
        end

        -- Keymaps (use builtin LSP buffer functions)
        map('n', 'K', vim.lsp.buf.hover)
        map('n', 'gd', vim.lsp.buf.definition)
        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', 'gi', vim.lsp.buf.implementation)
        map('n', 'go', vim.lsp.buf.type_definition)
        map('n', 'gr', vim.lsp.buf.references)
        map('n', 'gs', vim.lsp.buf.signature_help)
        map('n', 'gl', vim.diagnostic.open_float)
        map('n', '<F2>', vim.lsp.buf.rename)
        map({ 'n', 'x' }, '<F3>', function()
            vim.lsp.buf.format { async = true }
        end)
        map('n', '<F4>', vim.lsp.buf.code_action)

        -- Put near your LSP on_attach
        local excluded_filetypes = { php = true, sql = true }

        -- Auto-format on save (only if server can't do WillSaveWaitUntil)
        if
            not client:supports_method 'textDocument/willSaveWaitUntil'
            and client:supports_method 'textDocument/formatting'
            and not excluded_filetypes[vim.bo[buf].filetype]
        then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
                buffer = buf,
                callback = function()
                    vim.lsp.buf.format { bufnr = buf, id = client.id, timeout_ms = 1000 }
                end,
            })
        end
    end,
})

-- 5) Define the Lua language server config (no mason/lspconfig)
-- See :help lsp-new-config and :help vim.lsp.config()
local caps = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config['luals'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    capabilities = caps,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
            },
            telemetry = { enable = false },
        },
    },
}

local function set_python_path(command)
    local path = command.args
    local clients = vim.lsp.get_clients {
        bufnr = vim.api.nvim_get_current_buf(),
        name = 'pyright',
    }
    for _, client in ipairs(clients) do
        if client.settings then
            client.settings.python = vim.tbl_deep_extend('force', client.settings.python, { pythonPath = path })
        else
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings,
                { python = { pythonPath = path } })
        end
        client:notify('workspace/didChangeConfiguration', { settings = nil })
    end
end

-- vim.lsp.config('ty', {
--   settings = {
--     ty = {
--       -- ty language server settings go here
--     }
--   }
-- })
--
-- -- Required: Enable the language server
-- vim.lsp.enable('ty')

vim.lsp.config['pyright'] = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                typeCheckingMode = 'standard',
                useLibraryCodeForTypes = true,
                -- diagnosticMode = 'openFilesOnly',
            },
        },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
            local params = {
                command = 'pyright.organizeimports',
                arguments = { vim.uri_from_bufnr(bufnr) },
            }

            -- Using client.request() directly because "pyright.organizeimports" is private
            -- (not advertised via capabilities), which client:exec_cmd() refuses to call.
            -- https://github.com/neovim/neovim/blob/c333d64663d3b6e0dd9aa440e433d346af4a3d81/runtime/lua/vim/lsp/client.lua#L1024-L1030
            client.request('workspace/executeCommand', params, nil, bufnr)
        end, {
            desc = 'Organize Imports',
        })
        vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
            desc = 'Reconfigure pyright with the provided python path',
            nargs = 1,
            complete = 'file',
        })
    end,
}

vim.lsp.config['cssls'] = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_markers = { 'package.json', '.git' },
    capabilities = caps,
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
}

vim.lsp.config['sqls'] = {
    cmd = { '/home/viaz/go/bin/sqls', '--config', '/home/viaz/.config/sql/config.yml' },
    filetypes = { 'sql' },
    root_markers = { 'config.yml' },
    commands = {
        executeQuery = function(_, client)
            require('sqls.commands').exec(client.client_id, 'executeQuery')
        end,
        showDatabases = function(_, client)
            require('sqls.commands').exec(client.client_id, 'showDatabases')
        end,
        showSchemas = function(_, client)
            require('sqls.commands').exec(client.client_id, 'showSchemas')
        end,
        showConnections = function(_, client)
            require('sqls.commands').exec(client.client_id, 'showConnections')
        end,
        showTables = function(_, client)
            require('sqls.commands').exec(client.client_id, 'showTables')
        end,
        describeTable = function(_, client)
            require('sqls.commands').exec(client.client_id, 'describeTable')
        end,
        switchConnections = function(_, client)
            require('sqls.commands').switch_connection(client.client_id)
        end,
        switchDatabase = function(_, client)
            require('sqls.commands').switch_database(client.client_id)
        end,
    },
    on_attach = function(client, bufnr)
        local client_id = client.id
        api.nvim_buf_create_user_command(bufnr, 'SqlsExecuteQuery', function(args)
            require('sqls.commands').exec(client_id, 'executeQuery', args.smods, args.range ~= 0, nil, args.line1,
                args.line2)
        end, { range = true })
        api.nvim_buf_create_user_command(bufnr, 'SqlsExecuteQueryVertical', function(args)
            require('sqls.commands').exec(client_id, 'executeQuery', args.smods, args.range ~= 0, '-show-vertical',
                args.line1, args.line2)
        end, { range = true })
        api.nvim_buf_create_user_command(bufnr, 'SqlsShowDatabases', function(args)
            require('sqls.commands').exec(client_id, 'showDatabases', args.smods)
        end, {})
        api.nvim_buf_create_user_command(bufnr, 'SqlsShowSchemas', function(args)
            require('sqls.commands').exec(client_id, 'showSchemas', args.smods)
        end, {})
        api.nvim_buf_create_user_command(bufnr, 'SqlsShowConnections', function(args)
            require('sqls.commands').exec(client_id, 'showConnections', args.smods)
        end, {})
        api.nvim_buf_create_user_command(bufnr, 'SqlsShowTables', function(args)
            require('sqls.commands').exec(client_id, 'showTables', args.smods)
        end, {})
        -- Not yet supported by the language server:
        -- api.nvim_buf_create_user_command(bufnr, 'SqlsDescribeTable', function(args)
        --     require('sqls.commands').exec(client_id, 'describeTable', args.smods)
        -- end, {})
        api.nvim_buf_create_user_command(bufnr, 'SqlsSwitchDatabase', function(args)
            require('sqls.commands').switch_database(client_id, args.args ~= '' and args.args or nil)
        end, { nargs = '?' })
        api.nvim_buf_create_user_command(bufnr, 'SqlsSwitchConnection', function(args)
            require('sqls.commands').switch_connection(client_id, args.args ~= '' and args.args or nil)
        end, { nargs = '?' })

        api.nvim_buf_set_keymap(
            bufnr,
            'n',
            '<Plug>(sqls-execute-query)',
            "<Cmd>let &opfunc='{type -> sqls_nvim#query(type, " .. client_id .. ")}'<CR>g@",
            { silent = true }
        )
        api.nvim_buf_set_keymap(
            bufnr,
            'x',
            '<Plug>(sqls-execute-query)',
            "<Cmd>let &opfunc='{type -> sqls_nvim#query(type, " .. client_id .. ")}'<CR>g@",
            { silent = true }
        )
        api.nvim_buf_set_keymap(
            bufnr,
            'n',
            '<Plug>(sqls-execute-query-vertical)',
            "<Cmd>let &opfunc='{type -> sqls_nvim#query_vertical(type, " .. client_id .. ")}'<CR>g@",
            { silent = true }
        )
        api.nvim_buf_set_keymap(
            bufnr,
            'x',
            '<Plug>(sqls-execute-query-vertical)',
            "<Cmd>let &opfunc='{type -> sqls_nvim#query_vertical(type, " .. client_id .. ")}'<CR>g@",
            { silent = true }
        )
    end,
    -- capabilities = caps,
    settings = {},
}


vim.lsp.config['django-template-lsp'] = {
    cmd = { 'django-template-lsp' },
    filetypes = { 'html', 'htmldjango' },
    -- root_dir = require("lspconfig.util").root_pattern("manage.py", ".git"),
}
vim.lsp.enable 'django-template-lsp'

vim.lsp.config['djlsp'] = {
    cmd = { 'djlsp' },
    filetypes = { 'html', 'htmldjango' },
    -- root_dir = require("lspconfig.util").root_pattern("manage.py", ".git"),
}
vim.lsp.enable 'djlsp'


-- vim.lsp.config['jinja_lsp'] = {
--     name = 'jinja_lsp',
--     cmd = { 'jinja-lsp' },
--     filetypes = { 'jinja', 'htmldjango', 'python', 'rust', 'html', },
--     root_markers = { '.git' },
-- }
-- vim.lsp.enable 'jinja_lsp'

vim.lsp.config['emmet-language-server'] = {
    cmd = { 'emmet-language-server', '--stdio' },
    filetypes = {
        'astro',
        'css',
        'eruby',
        'htmldjango',
        'html',
        'htmlangular',
        'javascriptreact',
        'less',
        'pug',
        'sass',
        'scss',
        'svelte',
        'templ',
        'typescriptreact',
        'vue',
    },
    root_markers = { '.git' },
}

vim.lsp.enable 'emmet-language-server'
vim.lsp.enable 'pyright'
vim.lsp.enable 'luals'
vim.lsp.enable 'cssls'
vim.lsp.enable 'sqls'
