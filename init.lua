-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' -- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]

-- Configuring kitty display window on start and close
vim.fn.jobstart { 'kitty', '@', 'set-window-title', 'nvim' }
vim.fn.jobstart { 'kitty', '@', 'set-spacing', 'padding=0' }
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    vim.fn.system { 'kitty', '@', 'set-window-title', 'kitty' }
    vim.fn.system { 'kitty', '@', 'set-spacing', 'padding=default' }
  end,
})

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = false

-- Colors
vim.opt.termguicolors = true

-- Tab Spacing
vim.opt.tabstop = 5
vim.opt.shiftwidth = 5
vim.opt.expandtab = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Fill character
vim.opt.fillchars:append { eob = ' ' }

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Wordwrap 
vim.opt.wrap = false

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 6

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({

  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- View installed color schemes with `:Telescope colorscheme`.
  require 'themes.lushwal',
  require 'themes.rose-pine',
  require 'themes.tokyonight',

  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- notify, alpha, lualine, and completions need further configuring
  require 'plugins.nvim-lspconfig',   -- language server protocol configuration
  require 'plugins.nvim-treesitter',  -- highlighting, editing, and navigating code
  -- require 'plugins.nvim-comment',  -- fast line commenting
  require 'plugins.nvim-notify',      -- clean notification engine
  require 'plugins.telescope',        -- popular fuzzy finder
  require 'plugins.neo-tree',         -- sidebar file explorer
  require 'plugins.blink',            -- autocompletion
  -- require 'plugins.completions',   -- autocompletion
  -- require 'plugins.conform',       -- autoformatting
  require 'plugins.neoscroll',        -- smooth scrolling animations
  require 'plugins.lualine',          -- pretty, configurable status bar
  require 'plugins.alpha',            -- configurable welcome page
  require 'plugins.lazydev',          -- LSP plugins
  require 'plugins.chameleon',        -- match kitty background to nvim
  require 'plugins.autopairs',        -- Autocomplete [], {}, (), etc.
  -- require 'plugins.gitsigns',      -- Shows git changes in the file gutter
  require 'plugins.indent_line',      -- Adds vertical indentation guides 
  -- require 'plugins.lint',          -- Highlights errors, style issues, warnings
  -- require 'plugins.which-key',     -- Informational popup while using keybindings

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
