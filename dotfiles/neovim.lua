-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General options
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.hidden = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- No bells
vim.opt.errorbells = false
vim.opt.visualbell = false

-- Appearance
vim.opt.laststatus = 2
vim.opt.colorcolumn = "80"
vim.opt.showbreak = "↳"
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,sbr"

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- No swap, persistent undo
vim.opt.swapfile = false
vim.opt.undofile = true

-- Show problematic characters
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "-", extends = ">", precedes = "<", nbsp = "+" }

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Fold
vim.opt.foldlevelstart = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Diff
vim.opt.diffopt:append("vertical")

-- Relative numbers toggle on insert/leave
vim.api.nvim_create_autocmd("InsertEnter", { callback = function() vim.opt.relativenumber = false end })
vim.api.nvim_create_autocmd("InsertLeave", { callback = function() vim.opt.relativenumber = true end })

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Typo helpers
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Q", "q", {})

-- Navigate display lines not physical lines
vim.keymap.set("n", "<Down>", "gj")
vim.keymap.set("n", "<Up>", "gk")

-- Center on search
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "G", "Gzz")

-- Clear search highlight
vim.keymap.set("n", "<C-L>", ":nohlsearch<CR><C-L>", { silent = true })

-- Split navigation
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- cd to current file's directory
vim.keymap.set("n", "<Leader>cd", ":cd %:p:h<CR>:pwd<CR>")

-- Open vimrc
vim.keymap.set("n", ";v", ":next $MYVIMRC<CR>", { silent = true })

-------------------------------------------------------------------------------
-- Plugin configs
-------------------------------------------------------------------------------

-- Telescope
local telescope = require("telescope")
local builtin = require("telescope.builtin")
telescope.setup({
  defaults = {
    layout_strategy = "flex",
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "top" },
  },
})
vim.keymap.set("n", "<Leader><Leader>", builtin.find_files)
vim.keymap.set("n", "<Leader>fg", builtin.live_grep)
vim.keymap.set("n", "<Leader>fb", builtin.buffers)
vim.keymap.set("n", "<Leader>fh", builtin.help_tags)
vim.keymap.set("n", "<Leader>a", builtin.grep_string)

-- Treesitter (grammars installed via nix, just enable features)
vim.treesitter.start = vim.treesitter.start or function() end
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- LSP (nvim 0.11+ native API)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = { "lua_ls", "rust_analyzer", "ts_ls", "pyright", "nil_ls" }
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
  })
end
vim.lsp.enable(servers)

-- LSP keymaps (on attach)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end
    map("gd", builtin.lsp_definitions, "Go to definition")
    map("gr", builtin.lsp_references, "References")
    map("gi", builtin.lsp_implementations, "Implementations")
    map("K", vim.lsp.buf.hover, "Hover")
    map("<Leader>rn", vim.lsp.buf.rename, "Rename")
    map("<Leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<Leader>D", builtin.lsp_type_definitions, "Type definition")
    map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
  end,
})

-- nvim-cmp (completion)
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
  },
})

-- Conform (formatting)
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    nix = { "nixfmt" },
    rust = { "rustfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- Lualine
require("lualine").setup({
  options = { theme = "auto" },
})

-- Gitsigns
require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr })
    vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr })
    vim.keymap.set("n", "<Leader>hp", gs.preview_hunk, { buffer = bufnr })
    vim.keymap.set("n", "<Leader>hb", function() gs.blame_line({ full = true }) end, { buffer = bufnr })
  end,
})

-- indent-blankline
require("ibl").setup()

-- Oil (file browser)
require("oil").setup()
vim.keymap.set("n", "<F2>", "<CMD>Oil<CR>")
vim.keymap.set("n", "-", "<CMD>Oil<CR>")

-- Zen mode + Twilight
require("zen-mode").setup()
require("twilight").setup()
vim.keymap.set("n", "<Leader>z", "<CMD>ZenMode<CR>")

-- Rainbow delimiters
local rainbow_delimiters = require("rainbow-delimiters")
vim.g.rainbow_delimiters = {
  strategy = { [""] = rainbow_delimiters.strategy["global"] },
  query = { [""] = "rainbow-delimiters" },
}

-- Fugitive
vim.keymap.set("n", "<F5>", ":Git<CR>")
