return {
  "neovim/nvim-lspconfig", 
  config = function()
    vim.lsp.config('nixd', {})
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    vim.lsp.enable({ 'nixd', 'lua_ls' })
  end,
}
