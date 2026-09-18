return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.routes = opts.routes or {}
    -- Hide pyright's LSP progress messages (the "✔ pyright" popup on every save).
    -- Other servers keep their spinners and done notifications.
    table.insert(opts.routes, {
      filter = { event = "lsp", kind = "progress", find = "pyright" },
      opts = { skip = true },
    })
  end,
}
