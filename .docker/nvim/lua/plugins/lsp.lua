return {
  { "junegunn/fzf", build = "./install --bin" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "rust",
        "lua",
      },
      highlight = {
        enable = true
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
    keys = {
      { "gcc", desc = "Comment line", mode = "n" },  -- Normal mode: `gcc` to comment a line
      { "gc", desc = "Comment selection", mode = "v" },  -- Visual mode: `gc` to comment selection
    },
  },
}
