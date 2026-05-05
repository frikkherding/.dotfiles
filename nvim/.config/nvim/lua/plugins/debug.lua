-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go', -- Go debugger
    'mrcjkb/rustaceanvim', -- Rust debugger
    --'mxsdev/nvim-dap-vscode-js',
  },
  lazy = true,
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<leader>b<leader>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<leader>bi',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<leader>bo',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<leader>bt',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>bb',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>bB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<leader>bs',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve', -- Go debugger
        'codelldb', -- Rust debugger
        'cpptools', -- C++ debugger
        'js-debug-adapter', -- JS debugger
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Setup JS/TS debugging
    -- require('dap-vscode-js').setup {
    --   --node_path = 'node', -- Path of node, you can customize
    --   debugger_path = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter',
    --   debugger_cmd = { 'js-debug-adapter' }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    --   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
    -- }

    --- Gets a path to a package in the Mason registry.
    --- Prefer this to `get_package`, since the package might not always be
    --- available yet and trigger errors.
    ---@param pkg string
    ---@param path? string
    local function get_pkg_path(pkg, path)
      pcall(require, 'mason')
      local root = vim.env.MASON or (vim.fn.stdpath 'data' .. '/mason')
      path = path or ''
      local ret = root .. '/packages/' .. pkg .. '/' .. path
      return ret
    end

    local exts = {
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'vue',
      'svelte',
    }
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Adapters                                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = { vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
      },
    }

    dap.adapters['pwa-chrome'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = { vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
      },
    }

    for i, ext in ipairs(exts) do
      dap.configurations[ext] = {
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch Chrome with "localhost"',
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:3000' }, function(url)
                if url == nil or url == '' then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          webRoot = '${workspaceFolder}',
          protocol = 'inspector',
          sourceMaps = true,
          userDataDir = false,
          skipFiles = { '<node_internals>/**', 'node_modules/**', '${workspaceFolder}/node_modules/**' },
          resolveSourceMapLocations = {
            '${webRoot}/*',
            '${webRoot}/apps/**/**',
            '${workspaceFolder}/apps/**/**',
            '${webRoot}/packages/**/**',
            '${workspaceFolder}/packages/**/**',
            '${workspaceFolder}/*',
            '!**/node_modules/**',
          },
        },
        {
          name = 'Next.js: debug server-side (pwa-node)',
          type = 'pwa-node',
          request = 'attach',
          port = 9231,
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (pwa-node npm)',
          cwd = vim.fn.getcwd(),
          args = { '${file}' },
          sourceMaps = true,
          protocol = 'inspector',
          runtimeExecutable = 'npm',
          runtimeArgs = {
            'run',
            'dev',
          },
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (pwa-node)',
          cwd = vim.fn.getcwd(),
          args = { '${file}' },
          sourceMaps = true,
          protocol = 'inspector',
          runtimeExecutable = 'pnpm',
          runtimeArgs = {
            'run-script',
            'dev',
          },
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (pwa-node with ts-node)',
          cwd = vim.fn.getcwd(),
          runtimeArgs = { '--loader', 'ts-node/esm' },
          runtimeExecutable = 'node',
          args = { '${file}' },
          sourceMaps = true,
          protocol = 'inspector',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Test Current File (pwa-node with jest)',
          cwd = vim.fn.getcwd(),
          runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest' },
          runtimeExecutable = 'node',
          args = { '${file}', '--coverage', 'false' },
          rootPath = '${workspaceFolder}',
          sourceMaps = true,
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Test Current File (pwa-node with vitest)',
          cwd = vim.fn.getcwd(),
          program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
          args = { '--inspect-brk', '--threads', 'false', 'run', '${file}' },
          autoAttachChildProcesses = true,
          smartStep = true,
          console = 'integratedTerminal',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Test Current File (pwa-node with deno)',
          cwd = vim.fn.getcwd(),
          runtimeArgs = { 'test', '--inspect-brk', '--allow-all', '${file}' },
          runtimeExecutable = 'deno',
          attachSimplePort = 9229,
        },
        {
          type = 'pwa-chrome',
          request = 'attach',
          name = 'Attach Program (pwa-chrome, select port)',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = 'inspector',
          port = function()
            return vim.fn.input('Select port: ', 9222)
          end,
          webRoot = '${workspaceFolder}',
          skipFiles = { '<node_internals>/**', 'node_modules/**', '${workspaceFolder}/node_modules/**' },
          resolveSourceMapLocations = {
            '${webRoot}/*',
            '${webRoot}/apps/**/**',
            '${workspaceFolder}/apps/**/**',
            '${webRoot}/packages/**/**',
            '${workspaceFolder}/packages/**/**',
            '${workspaceFolder}/*',
            '!**/node_modules/**',
          },
        },
        -- {
        --   type = 'pwa-node',
        --   request = 'attach',
        --   name = 'Attach Program (pwa-node, select pid)',
        --   cwd = vim.fn.getcwd(),
        --   processId = dap_utils.pick_process,
        --   skipFiles = { '<node_internals>/**' },
        -- },
      }
    end
    --
    -- -- Register configurations for JS/TS
    -- for _, language in ipairs { 'typescript', 'javascript', 'svelte' } do
    --   dap.configurations[language] = {
    --     {
    --       -- use nvim-dap-vscode-js's pwa-node debug adapter
    --       type = 'pwa-node',
    --       -- attach to an already running node process with --inspect flag
    --       -- default port: 9222
    --       request = 'attach',
    --       -- allows us to pick the process using a picker
    --       processId = require('dap.utils').pick_process,
    --       -- name of the debug action
    --       name = 'Attach debugger to existing `node --inspect` process',
    --       -- for compiled languages like TypeScript or Svelte.js
    --       sourceMaps = true,
    --       port = '${port}',
    --       -- resolve source maps in nested locations while ignoring node_modules
    --       resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
    --       -- path to src in vite based projects (and most other projects as well)
    --       cwd = '${workspaceFolder}/src',
    --       -- we don't want to debug code inside node_modules, so skip it!
    --       skipFiles = { '${workspaceFolder}/node_modules/**/*.js' },
    --     },
    --     {
    --       type = 'pwa-node',
    --       request = 'launch',
    --       host = 'localhost',
    --       name = 'Node Debug Server',
    --       port = '${port}',
    --       executable = {
    --         command = 'node',
    --         args = { '~/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
    --       },
    --     },
    --     {
    --       name = 'Testlol',
    --       type = 'server',
    --       request = 'launch',
    --       host = 'localhost',
    --       port = '${port}',
    --       executable = {
    --         command = 'node',
    --         args = {
    --           get_pkg_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js'),
    --           '${port}',
    --         },
    --       },
    --     },
    --     {
    --       type = 'pwa-node',
    --       request = 'launch',
    --       name = 'Launch file',
    --       program = '${file}',
    --       cwd = vim.fn.getcwd(),
    --       sourceMaps = true,
    --     },
    --     {
    --       type = 'pwa-node',
    --       request = 'attach',
    --       name = 'Attach',
    --       processId = require('dap.utils').pick_process,
    --       cwd = vim.fn.getcwd(),
    --     },
    --     {
    --       type = 'pwa-node',
    --       request = 'launch',
    --       name = 'Run npm dev',
    --       runtimeExecutable = 'npm',
    --       runtimeArgs = { 'run', 'dev' },
    --       cwd = vim.fn.getcwd(),
    --       console = 'integratedTerminal',
    --       internalConsoleOptions = 'neverOpen',
    --     },
    --     {
    --       type = 'pwa-node',
    --       request = 'launch',
    --       name = 'Debug Vitest (all tests)',
    --       runtimeExecutable = 'node',
    --       runtimeArgs = {
    --         './node_modules/vitest/vitest.mjs',
    --         '--runInBand', -- important for debugger to work
    --       },
    --       cwd = vim.fn.getcwd(),
    --       console = 'integratedTerminal',
    --       internalConsoleOptions = 'neverOpen',
    --     },
    --     {
    --       type = 'pwa-node',
    --       request = 'launch',
    --       name = 'Debug Current Test File',
    --       runtimeExecutable = 'node',
    --       runtimeArgs = {
    --         './node_modules/vitest/vitest.mjs',
    --         'run',
    --         '${file}', -- only run tests in the current file
    --         '--runInBand',
    --       },
    --       cwd = vim.fn.getcwd(),
    --       console = 'integratedTerminal',
    --       internalConsoleOptions = 'neverOpen',
    --     },
    --   }
    -- end
  end,
}
