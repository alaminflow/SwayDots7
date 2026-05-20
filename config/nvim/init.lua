-- =============================================================================
--  Neovim Configuration — Catppuccin Mocha
-- =============================================================================

-- ── Leader key (set FIRST) ────────────────────────────────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- ── Options ───────────────────────────────────────────────────────────────────
local opt = vim.opt

opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.colorcolumn    = "80"

opt.tabstop        = 2
opt.shiftwidth     = 2
opt.expandtab      = true
opt.smartindent    = true
opt.autoindent     = true

opt.wrap           = false
opt.linebreak      = true
opt.scrolloff      = 8
opt.sidescrolloff  = 8

opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = true
opt.incsearch      = true

opt.splitbelow     = true
opt.splitright     = true

opt.termguicolors  = true
opt.background     = "dark"
opt.showmode       = false       -- handled by lualine
opt.pumheight      = 10
opt.conceallevel   = 0

opt.undofile       = true
opt.swapfile       = false
opt.backup         = false
opt.writebackup    = false

opt.updatetime     = 250
opt.timeoutlen     = 300
opt.completeopt    = { "menuone", "noinsert", "noselect" }
opt.fileencoding   = "utf-8"
opt.clipboard      = "unnamedplus"
opt.mouse          = "a"

opt.list           = true
opt.listchars      = { tab = "→ ", trail = "·", nbsp = "⎵" }

-- ── Bootstrap packer ──────────────────────────────────────────────────────────
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system({
    "git", "clone", "--depth", "1",
    "https://github.com/wbthomason/packer.nvim", install_path,
  })
  vim.cmd [[packadd packer.nvim]]
end

-- ── Plugins ───────────────────────────────────────────────────────────────────
require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  -- Theme
  use { "catppuccin/nvim", as = "catppuccin" }

  -- UI
  use "nvim-lualine/lualine.nvim"
  use "nvim-tree/nvim-web-devicons"
  use "nvim-tree/nvim-tree.lua"
  use { "akinsho/bufferline.nvim", tag = "*" }
  use "lukas-reineke/indent-blankline.nvim"
  use "lewis6991/gitsigns.nvim"
  use "folke/which-key.nvim"
  use { "folke/noice.nvim",
    requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }
  }

  -- Telescope
  use { "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" }
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use "nvim-treesitter/nvim-treesitter-context"

  -- LSP
  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "nvimtools/none-ls.nvim"

  -- Completion
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "L3MON4D3/LuaSnip"
  use "saadparwaiz1/cmp_luasnip"
  use "rafamadriz/friendly-snippets"

  -- Editor utils
  use "windwp/nvim-autopairs"
  use "numToStr/Comment.nvim"
  use { "kylechui/nvim-surround", tag = "*" }
  use "mg979/vim-visual-multi"
  use "ggandor/leap.nvim"
  use "max397574/better-escape.nvim"

  -- Markdown / writing
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install" }

  -- Terminal
  use { "akinsho/toggleterm.nvim", tag = "*" }

  -- Misc
  use "folke/todo-comments.nvim"
  use { "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons" }
  use "norcalli/nvim-colorizer.lua"
  use { "akinsho/git-conflict.nvim", tag = "*" }

  if PACKER_BOOTSTRAP then require("packer").sync() end
end)

-- ── Load module configs ────────────────────────────────────────────────────────
local ok_load, _ = pcall(require, "plugins")
if not ok_load then
  -- Inline minimal config if modules not yet set up
  vim.cmd.colorscheme("catppuccin")
end

-- ── Core keymaps ──────────────────────────────────────────────────────────────
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
map("n", "<C-Up>",    ":resize -2<CR>",          opts)
map("n", "<C-Down>",  ":resize +2<CR>",           opts)
map("n", "<C-Left>",  ":vertical resize -2<CR>",  opts)
map("n", "<C-Right>", ":vertical resize +2<CR>",  opts)

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>",     opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Better paste (don't yank replaced text)
map("v", "p", '"_dP', opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- File tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Explorer" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",   { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    { desc = "Recent files" })

-- LSP
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",      { desc = "Go to definition" })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",      { desc = "References" })
map("n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>",           { desc = "Hover docs" })
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",  { desc = "Rename" })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code action" })
map("n", "<leader>f",  "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Format" })

-- Diagnostics
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Prev diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })
map("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = "Diagnostics list" })

-- Terminal
map("n", "<leader>t", "<cmd>ToggleTerm direction=float<CR>", { desc = "Float terminal" })
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Trouble" })

-- Save / quit
map("n", "<C-s>", "<cmd>w<CR>",  { desc = "Save" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })

-- ── Catppuccin setup ──────────────────────────────────────────────────────────
local cat_ok, catppuccin = pcall(require, "catppuccin")
if cat_ok then
  catppuccin.setup({
    flavour = "mocha",
    transparent_background = false,
    show_end_of_buffer = false,
    term_colors = true,
    integrations = {
      cmp = true, gitsigns = true, nvimtree = true,
      treesitter = true, telescope = true, which_key = true,
      mason = true, lsp_trouble = true, bufferline = true,
      indent_blankline = { enabled = true },
      noice = true, notify = true, mini = true,
    },
  })
  vim.cmd.colorscheme("catppuccin")
end

-- ── Lualine ───────────────────────────────────────────────────────────────────
local ll_ok, lualine = pcall(require, "lualine")
if ll_ok then
  lualine.setup({
    options = {
      theme = "catppuccin",
      component_separators = { left = "", right = "" },
      section_separators   = { left = "", right = "" },
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end

-- ── Mason + LSP ───────────────────────────────────────────────────────────────
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup({ ui = { border = "rounded" } })
end

local mlsp_ok, mlsp = pcall(require, "mason-lspconfig")
if mlsp_ok then
  mlsp.setup({
    ensure_installed = {
      "lua_ls", "pyright", "ts_ls", "html", "cssls",
      "jsonls", "bashls", "dockerls", "yamlls",
    },
    automatic_installation = true,
  })
end

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if lspconfig_ok and mason_ok then
  local servers = { "lua_ls", "pyright", "ts_ls", "html", "cssls", "bashls" }
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  for _, server in ipairs(servers) do
    lspconfig[server].setup({ capabilities = capabilities })
  end
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  })
end

-- ── nvim-cmp ─────────────────────────────────────────────────────────────────
local cmp_ok, cmp = pcall(require, "cmp")
local snip_ok, luasnip = pcall(require, "luasnip")
if cmp_ok and snip_ok then
  require("luasnip.loaders.from_vscode").lazy_load()
  cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    window = {
      completion    = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"]   = cmp.mapping.select_prev_item(),
      ["<C-j>"]   = cmp.mapping.select_next_item(),
      ["<C-d>"]   = cmp.mapping.scroll_docs(-4),
      ["<C-f>"]   = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"]    = cmp.mapping.confirm({ select = true }),
      ["<Tab>"]   = cmp.mapping(function(fallback)
        if cmp.visible()        then cmp.select_next_item()
        elseif luasnip.jumpable(1) then luasnip.jump(1)
        else fallback() end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" }, { name = "luasnip" },
    }, {
      { name = "buffer" }, { name = "path" },
    }),
  })
end

-- ── Treesitter ────────────────────────────────────────────────────────────────
local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
if ts_ok then
  ts.setup({
    ensure_installed = {
      "lua", "python", "javascript", "typescript", "html", "css",
      "json", "yaml", "toml", "bash", "markdown", "markdown_inline",
      "vim", "vimdoc", "dockerfile", "gitignore",
    },
    auto_install = true,
    highlight    = { enable = true },
    indent       = { enable = true },
  })
end

-- ── NvimTree ─────────────────────────────────────────────────────────────────
local nt_ok, nvimtree = pcall(require, "nvim-tree")
if nt_ok then
  nvimtree.setup({
    view = { width = 30, side = "left" },
    renderer = {
      group_empty = true,
      icons = { show = { file = true, folder = true, folder_arrow = true, git = true } },
    },
    filters = { dotfiles = false },
    git = { enable = true },
  })
end

-- ── Comment.nvim ─────────────────────────────────────────────────────────────
local com_ok, comment = pcall(require, "Comment")
if com_ok then comment.setup() end

-- ── Autopairs ────────────────────────────────────────────────────────────────
local ap_ok, autopairs = pcall(require, "nvim-autopairs")
if ap_ok then autopairs.setup({ check_ts = true }) end

-- ── Gitsigns ─────────────────────────────────────────────────────────────────
local gs_ok, gitsigns = pcall(require, "gitsigns")
if gs_ok then
  gitsigns.setup({
    signs = {
      add          = { text = "│" },
      change       = { text = "│" },
      delete       = { text = "󰍵" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
    },
  })
end

-- ── ToggleTerm ───────────────────────────────────────────────────────────────
local tt_ok, toggleterm = pcall(require, "toggleterm")
if tt_ok then
  toggleterm.setup({
    size = 20,
    open_mapping = [[<c-\>]],
    direction = "float",
    float_opts = { border = "curved" },
  })
end

-- ── Todo Comments ────────────────────────────────────────────────────────────
local td_ok, todo = pcall(require, "todo-comments")
if td_ok then todo.setup() end

-- ── Colorizer ────────────────────────────────────────────────────────────────
local col_ok, colorizer = pcall(require, "colorizer")
if col_ok then colorizer.setup() end

-- ── Which-key ────────────────────────────────────────────────────────────────
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.setup({ preset = "modern" })
  wk.add({
    { "<leader>f", group = "󰍉 Find" },
    { "<leader>g", group = " Git" },
    { "<leader>l", group = " LSP" },
    { "<leader>b", group = "󰓩 Buffer" },
    { "<leader>t", group = " Terminal" },
    { "<leader>x", group = " Trouble" },
  })
end

-- ── Better Escape ───────────────────────────────────────────────────────────
local be_ok, better_escape = pcall(require, "better_escape")
if be_ok then
  better_escape.setup({ mapping = { "jk", "jj" }, timeout = 200 })
end

-- ── Leap.nvim ────────────────────────────────────────────────────────────────
local leap_ok, leap = pcall(require, "leap")
if leap_ok then leap.create_default_mappings() end
