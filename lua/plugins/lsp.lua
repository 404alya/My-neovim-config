return {
  -- disable trouble
  { "folke/trouble.nvim", enabled = false },

  {
    "neovim/nvim-lspconfig",
    opts = {
    -- diagnostics = {
    --   virtual_text = false,
    --   signs = false,
    -- },
      inlay_hints = { enabled = false },
      autoformat = false,
      setup = {
        clangd = function(_, opts)
          opts.cmd = { "clangd", "--header-insertion=never" }
        end,
      },
    },
  },
}
