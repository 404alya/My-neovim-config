return {
    "anAcc22/sakura.nvim",
    dependencies = "rktjmp/lush.nvim",
    config = function()
        vim.opt.background = "dark" -- or "light"
        vim.cmd('colorscheme sakura') -- sets the colorscheme
    end
}
