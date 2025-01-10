if vim.fn.has('nvim-0.8') == 0 then
  error('Need Neovim 0.8+ in order to use this config')
end

for _, cmd in ipairs({ "git", "rg", { "fd", "fdfind" } }) do
  local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
  local commands = type(cmd) == "string" and { cmd } or cmd
  ---@cast commands string[]
  local found = false

  for _, c in ipairs(commands) do
    if vim.fn.executable(c) == 1 then
      name = c
      found = true
    end
  end

  if not found then
    error(("`%s` is not installed"):format(name))
  end
end

-- Load main config
require("config")

vim.opt.number = false
-- Disable autocomplete windows
require('cmp').setup.buffer { enabled = false }
-- Disable 'inline' warnings
vim.diagnostic.config({ virtual_text = false })
-- Disable 'inline' flags
vim.diagnostic.config({ signs = false })
vim.opt.signcolumn = "auto"

-- restore cursor to previous position on reload
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.api.nvim_exec("normal! g'\"", false)
    end
  end
})
-- disable mouse support
vim.opt.mouse = ""
