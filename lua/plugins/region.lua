return {
  "nicolas-martin/region-folding.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    region_text = { start = "#region", ending = "#endregion" },
    fold_indicator = "▼",
  },
  config = function(_, opts)
    require("region-folding").setup(opts)

    -- The plugin re-closes every region on BufEnter (zx + foldclose), so folds
    -- collapse on each buffer/tab switch. Remember which folds were closed and
    -- restore that state after the plugin's handler has run.
    local saved = {}

    local function capture(bufnr)
      if vim.bo[bufnr].buftype ~= "" or vim.wo.foldmethod ~= "expr" then
        return
      end
      local closed = {}
      local lnum, last = 1, vim.api.nvim_buf_line_count(bufnr)
      while lnum <= last do
        if vim.fn.foldclosed(lnum) == lnum then
          closed[#closed + 1] = lnum
          lnum = vim.fn.foldclosedend(lnum) + 1
        else
          lnum = lnum + 1
        end
      end
      saved[bufnr] = closed
    end

    local function restore(bufnr)
      local closed = saved[bufnr]
      -- No saved state: let the plugin's "close regions by default" stand.
      if not closed or vim.api.nvim_get_current_buf() ~= bufnr then
        return
      end
      vim.cmd("silent! normal! zR")
      for _, lnum in ipairs(closed) do
        vim.cmd(("silent! %dfoldclose"):format(lnum))
      end
    end

    local group = vim.api.nvim_create_augroup("RegionFoldingPersist", { clear = true })

    vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
      group = group,
      callback = function(args)
        capture(args.buf)
      end,
    })

    -- Created after the plugin's autocmd, so this runs (and schedules) last.
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      callback = function(args)
        vim.schedule(function()
          restore(args.buf)
        end)
      end,
    })

    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
      group = group,
      callback = function(args)
        saved[args.buf] = nil
      end,
    })
  end,
}
