-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Enable powershell as your default shell
vim.opt.shell = "pwsh.exe -NoLogo"
vim.opt.shellcmdflag =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.cmd [[
		let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		set shellquote= shellxquote=
  ]]

-- Set a compatible clipboard manager
vim.g.clipboard = {
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
}


-- Enable ignorecase and smartcase
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable incremental search
vim.o.incsearch = true

-- Display line numbers and relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.wrap = true -- wrap lines
vim.opt.scrolloff = 5 -- the amount of lines before and after when moving up and down

-- ToggleTerm mapping
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Terminal",
--   f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
--   v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Split vertical" },
--   h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Split horizontal" },
-- }


lvim.builtin["terminal"] = {
  active = true,
  on_config_done = nil,
  -- size can be a number or function which is passed the current terminal
  size = 30,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  -- direction = 'vertical' | 'horizontal' | 'window' | 'float',
  direction = "float",
  close_on_exit = true, -- close the terminal window when the process exits
  shell = nil, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_win_open'
    -- see :h nvim_win_open for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    border = "single",
    -- width = <value>,
    -- height = <value>,
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  -- Add executables on the config.lua
  -- { cmd, keymap, description, direction, size }
  -- lvim.builtin.terminal.execs = {...} to overwrite
  -- lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs+1] = {"gdb", "tg", "GNU Debugger"}
  -- TODO: pls add mappings in which key and refactor this
  execs = {
    { nil, "<M-1>", "Vertical Terminal", "vertical", 0.25 },
    { nil, "<M-2>", "Horizontal Terminal", "horizontal", 0.3 },
    { nil, "<M-3>", "Float Terminal", "float", nil },
  },
}



-- vim.api.nvim_set_keymap('n', '<C-t>', ':ToggleTerm direction=float<CR>', { noremap = true, silent = true })

-- -- Allows closing the terminal while in insert mode
-- vim.api.nvim_set_keymap('t', '<C-t>', '<esc>:ToggleTerm direction=float<CR>', { noremap = true, silent = true })

-- Remap Ctrl+L to clear terminal
lvim.keys.term_mode = { ["<C-l>"] = false }

-- Exit from insert mode by Esc in Terminal
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])

-- Map <S-j> in visual mode to move selected lines down
vim.api.nvim_set_keymap('v', '<S-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Map <S-k> in visual mode to move selected lines up
vim.api.nvim_set_keymap('v', '<S-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Map Tab and Shift Tab
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

-- vim.opt.shiftwidth = 4
-- vim.opt.tabstop = 4

-- LSP diagnostics settings
vim.diagnostic.config {
  virtual_text = false,
  -- signs = false,
  -- underline = false,
}

-- LSP incremental selection
lvim.builtin.treesitter.incremental_selection = {
  enable = true,
  keymaps = {
    -- init_selection = "<cr>",
    -- node_increment = "<cr>",
    -- scope_incremental = false,
    -- node_decremental = "<bs>",
    init_selection = "v",
    node_incremental = "v",
    node_decremental = "V",
    scope_incremental = "<M-v>",
  },
}

-- https://www.josean.com/posts/nvim-treesitter-and-textobjects
-- lvim.builtin.treesitter.textobjects = {
--   select = {
--     enable = true,

--     -- Automatically jump forward to textobj, similar to targets.vim
--     lookahead = true,

--     keymaps = {
--       -- You can use the capture groups defined in textobjects.scm
--       ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
--       ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
--       ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
--       ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

--       ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
--       ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

--       ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
--       ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

--       ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
--       ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

--       ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
--       ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

--       ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
--       ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

--       ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
--       ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
--     },
--   },
-- }

vim.opt.background = "dark"
lvim.colorscheme = 'oxocarbon'

-- set Transparency
lvim.transparent_window = true
-- also make LineNr transparent
vim.cmd('au ColorScheme * highlight! LineNr guibg=NONE cterm=NONE')
-- set Visual selection background color
vim.cmd('highlight Visual guibg=#3c3c3c guifg=NONE')

-- vim.cmd("au ColorScheme * hi Normal ctermbg=none guibg=none")
-- vim.cmd("au ColorScheme * hi SignColumn ctermbg=none guibg=none")
-- vim.cmd("au ColorScheme * hi NormalNC ctermbg=none guibg=none")
-- vim.cmd("au ColorScheme * hi MsgArea ctermbg=none guibg=none")
-- vim.cmd("au ColorScheme * hi TelescopeBorder ctermbg=none guibg=none")
-- vim.cmd("au ColorScheme * hi NvimTreeNormal ctermbg=none guibg=none")
-- vim.cmd('au ColorScheme * highlight! LineNr guibg=NONE cterm=NONE')
-- vim.cmd("let &fcs='eob: '")

lvim.autocommands = {
    {
        "BufEnter", -- see `:h autocmd-events`
        { -- this table is passed verbatim as `opts` to `nvim_create_autocmd`
            pattern = { "*.py", "*.java" }, -- see `:h autocmd-events`
            command = "setlocal tabstop=4 shiftwidth=4",
        }
    },
}


-- neoscroll config
local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
-- Use the "sine" easing function
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '35', [['sine']]}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '35', [['sine']]}}
-- Use the "circular" easing function
t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '130', [['sine']]}}
t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '130', [['sine']]}}
-- Pass "nil" to disable the easing animation (constant scrolling speed)
t['<C-y>'] = {'scroll', {'-0.10', 'false', '40', nil}}
t['<C-e>'] = {'scroll', { '0.10', 'false', '40', nil}}
-- When no easing function is provided the default easing function (in this case "quadratic") will be used
t['zt']    = {'zt', {'25'}}
t['zz']    = {'zz', {'25'}}
t['zb']    = {'zb', {'25'}}

require('neoscroll.config').set_mappings(t)

-- PLUGINS
lvim.plugins = {
  -- "ChristianChiarulli/swenv.nvim",
  -- "stevearc/dressing.nvim",
  {
    "folke/tokyonight.nvim",
    -- lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "norcalli/nvim-colorizer.lua",
    lazy = true,
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript", "python", "json"}, {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          })
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
    require('neoscroll').setup({
          -- All these keys will be mapped to their corresponding default scrolling animation
          mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
          hide_cursor = false,          -- Hide cursor while scrolling
          stop_eof = true,             -- Stop at <EOF> when scrolling downwards
          use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
          respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
          cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
          easing_function = "sine",        -- Default easing function
          pre_hook = nil,              -- Function to run before the scrolling animation starts
          post_hook = nil,              -- Function to run after the scrolling animation ends
          })
    end
  },
  {
    "rmagatti/goto-preview",
    lazy = true;
    config = function()
    require('goto-preview').setup {
          width = 120; -- Width of the floating window
          height = 25; -- Height of the floating window
          default_mappings = true; -- Bind default mappings
          debug = false; -- Print debug information
          opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
          post_open_hook = nil -- A function taking two arguments, a buffer and a window to be ran as a hook.
          -- You can use "default_mappings = true" setup option
          -- Or explicitly set keybindings
          -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
          -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
          -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
      }
    end
  },
  {
    "ahmedkhalf/lsp-rooter.nvim",
    event = "BufRead",
    config = function()
      require("lsp-rooter").setup()
    end,
  },
}

--lvim.builtin.which_key.mappings["C"] = {
--  name = "Python",
--  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
--}
