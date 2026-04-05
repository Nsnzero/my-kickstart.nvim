-- Set up clipboard integration for WSL (outside the plugin spec table)
vim.g.clipboard = {
  name = 'WslClipboard',
  copy = {
    ['+'] = 'clip.exe',
    ['*'] = 'clip.exe',
  },
  paste = {
    ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  },
  cache_enabled = 0,
}

return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        -- You can add more config here if you want
      }
    end,
  },
  {
    'maxmx03/fluoromachine.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local fm = require 'fluoromachine'

      fm.setup {
        glow = true,
        theme = 'retrowave',
        transparent = false,
      }

      --vim.cmd.colorscheme 'fluoromachine'
      vim.cmd [[colorscheme fluoromachine]]
    end,
  },
  {
    'lervag/vimtex',
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = 'zathura'
    end,
  },
  -- Disable LSP formatting for TypeScript servers to avoid auto-formatting
  -- provided by the language server (tsserver / ts_ls). This keeps the
  -- formatting behavior under Conform or other formatters instead.
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()
      local group = vim.api.nvim_create_augroup('custom_disable_ts_format', { clear = true })
      vim.api.nvim_create_autocmd('LspAttach', {
        group = group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          if client.name == 'tsserver' or client.name == 'ts_ls' then
            -- Disable document formatting capability so LSP won't format on save
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        end,
      })
    end,
  },
  {
    'chomosuke/typst-preview.nvim',
    lazy = false, -- or ft = 'typst'
    version = '1.*',
    opts = { dependencies_bin = { tinymist = 'tinymist' } }, -- lazy.nvim will implicitly calls `setup {}`
  },
}
