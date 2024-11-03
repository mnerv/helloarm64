return {
  {
    "echasnovski/mini.indentscope",
    event = "VeryLazy",
    ft = {
      "c",
      "cpp",
      "python",
      "java",
      "javascript",
      "typescript",
      "go",
      "rust",
      "lua"
    }, -- List your source file types here
    config = function()
      require('mini.indentscope').setup({
        draw = {
          animation = require('mini.indentscope').gen_animation.none()
        }
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          globalstatus = true,
          disabled_filetypes = {
            statusline = { 'dashboard', 'alpha', 'neo-tree' }, -- Add the filetype for your dashboard plugin here
            winbar = { 'neo-tree' },
          },
        },
      })
    end,
  },
  {
    "sainnhe/sonokai",
    name = "sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      if vim.fn.has('termguicolors') then
        vim.opt.termguicolors = true
      end

      -- Sonokai color scheme settings
      vim.g['sonokai_style']                   = 'andromeda'
      vim.g['sonokai_enable_italic']           = 1
      vim.g['sonokai_disable_itallic_comment'] = 1
      vim.g['airline_theme']                   = 'sonokai'
      vim.cmd 'colorscheme sonokai'
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
    }
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Function to add a delayed redraw
      local function delayed_redraw(delay)
        vim.defer_fn(function()
          vim.cmd('redraw')
        end, delay or 100) -- default to 100ms delay if not specified
      end

      -- Using ufo provider with delayed redraw for fold actions
      vim.keymap.set('n', 'zR', function()
        require('ufo').openAllFolds()
        delayed_redraw(100) -- redraw after 100ms delay
      end, { desc = "Open all folds with delayed redraw" })

      vim.keymap.set('n', 'zM', function()
        require('ufo').closeAllFolds()
        delayed_redraw(100) -- redraw after 100ms delay
      end, { desc = "Close all folds with delayed redraw" })

      -- Option 1: coc.nvim as LSP client
      require('ufo').setup()
    end
  },
}
