return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main', -- `master` is frozen/EOL and crashes on Neovim 0.12's query API; `main` is the maintained branch
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'
    ts.setup {}

    -- On the `main` branch installation is explicit: the old
    -- `ensure_installed`/`auto_install` opts no longer exist.
    local ensure_installed = {
      'bash',
      'c',
      'diff',
      'go',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'rust',
      'vim',
      'vimdoc',
      'javascript',
      'typescript',
      'svelte',
      'kotlin',
      'yaml',
    }
    ts.install(ensure_installed)

    -- `main` no longer wires up highlighting/indent automatically; start it
    -- per-buffer on FileType via the modern `vim.treesitter.start` API.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then
          return
        end
        -- Only start if a parser for this language is actually available.
        local ok, added = pcall(vim.treesitter.language.add, lang)
        if not (ok and added) then
          return
        end
        pcall(vim.treesitter.start, buf, lang)
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
