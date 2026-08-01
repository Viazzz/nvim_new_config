return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dap.adapters.python = function(cb, config)
                if config.request == 'attach' then
                    ---@diagnostic disable-next-line: undefined-field
                    local port = (config.connect or config).port
                    ---@diagnostic disable-next-line: undefined-field
                    local host = (config.connect or config).host or '127.0.0.1'
                    cb({
                        type = 'server',
                        port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                        host = host,
                        options = { source_filetype = 'python' },
                    })
                else
                    cb({
                        type = 'executable',
                        command = vim.fn.getcwd() .. '/.venv/bin/python',
                        args = { '-m', 'debugpy.adapter' },
                        options = { source_filetype = 'python' },
                    })
                end
            end

            -- Функция для динамического определения пути к Python
            local get_python_path = function()
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                    return cwd .. '/venv/bin/python'
                elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                    return cwd .. '/.venv/bin/python'
                else
                    return '/usr/bin/python'
                end
            end

            -- Теперь здесь ДВЕ конфигурации, поэтому появится всплывающее окно выбора
            dap.configurations.python = {
                {
                    type = 'python',
                    request = 'launch',
                    name = "Make unit-test",
                    module = "pytest",
                    args = { "tests/unit", "-s", "--tb=short" },
                    pythonPath = get_python_path,
                    env_file = vim.fn.getcwd() .. "/.env",
                },
                {
                    type = 'python',
                    request = 'launch',
                    name = "Make test (All tests)",
                    module = "pytest",
                    args = { "--tb=short" },
                    pythonPath = get_python_path,
                    env_file = vim.fn.getcwd() .. "/.env",
                },
                {
                    type = 'python',
                    request = 'launch',
                    name = "Make integration-test",
                    module = "pytest",
                    args = { "tests/integration", "-s", "--tb=short" },
                    pythonPath = get_python_path,
                    env_file = vim.fn.getcwd() .. "/.env",
                },
                {
                    type = 'python',
                    request = 'launch',
                    name = "Debug Current File",
                    program = "${file}",
                    pythonPath = get_python_path,
                    env_file = vim.fn.getcwd() .. "/.env",
                },
                {
                    type = 'python',
                    request = 'launch',
                    name = "Launch file with arguments",
                    program = "${file}",
                    pythonPath = get_python_path,
                    env_file = vim.fn.getcwd() .. "/.env", -- Динамический путь до .env
                    args = function()
                        -- Запросит аргументы строки через встроенный ввод Neovim
                        local argument_string = vim.fn.input('Program arguments: ')
                        return vim.split(argument_string, " +")
                    end,
                },
                {
                    type = 'python',
                    request = 'launch',
                    name = "🚀 Run Custom CLI Command (airflow, pytest, etc.)",
                    program = function()
                        local raw_command = vim.fn.input('Enter full CLI command: ')
                        if raw_command == "" then return nil end

                        local tokens = vim.split(raw_command, " +")
                        local cmd = tokens[1]

                        local cmd_path = vim.fn.exepath(cmd)
                        if cmd_path == "" then
                            vim.notify("Command not found in PATH: " .. cmd, vim.log.levels.ERROR)
                            return nil
                        end

                        table.remove(tokens, 1)
                        _G._dap_dynamic_args = tokens

                        return cmd_path
                    end,
                    args = function()
                        local args = _G._dap_dynamic_args or {}
                        _G._dap_dynamic_args = nil -- Очищаем за собой переменную
                        return args
                    end,
                    pythonPath = get_python_path,
                    env_file = vim.fn.getcwd() .. "/.env",
                    console = "integratedTerminal",
                },
            }

            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

            -- Горячие клавиши
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue / Start" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
            vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
            vim.keymap.set("n", "<leader>dj",
                function()
                    require("dap").set_breakpoint(nil, nil, nil); require("dap").run_to_cursor()
                end, { desc = "Jump to line under cursor" })
            vim.keymap.set("n", "<leader>dr", function() require("dap").restart() end, { desc = "Restart Debug Session" })
            vim.keymap.set({ "n", "v" }, "<leader>de", function() require("dapui").eval() end,
                { desc = "DAP UI: Eval floating window" })
        end,
    },
}
