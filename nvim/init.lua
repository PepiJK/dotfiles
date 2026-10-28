-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key
vim.g.mapleader = " "

-- Setup lazy.nvim with plugins
require("lazy").setup({
  -- Theme
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme("vscode")
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Treesitter (syntax highlighting & code understanding)
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local is_windows = vim.fn.has("win32") == 1
      local needs_compiler = not vim.env.CC and vim.fn.executable("cl") == 0
      local has_gcc = vim.fn.executable("gcc") == 1
      if is_windows and needs_compiler and has_gcc then
        vim.env.CC = "gcc"
      end

      local function start_treesitter(buf)
        vim.treesitter.start(buf)
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      -- Set Angular component HTML files to use html filetype
      vim.filetype.add({
        pattern = {
          [".*%.component%.html"] = "html",
          [".*%.container%.html"] = "html",
        },
      })
      -- Enable highlighting and indentation per filetype
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua", "vim", "markdown", "python",
          "javascript", "typescript", "bash",
          "html", "css", "scss", "json",
        },
        callback = function(event)
          local filetype = vim.bo[event.buf].filetype
          local language = vim.treesitter.language.get_lang(filetype)
          if vim.treesitter.language.add(language) then
            start_treesitter(event.buf)
            return
          end

          require("nvim-treesitter").install({ language }):await(function(err, success)
            vim.schedule(function()
              if err or not success then
                vim.notify("Failed to install Tree-sitter parser for " .. language .. ": " .. (err or "see :TSLog"), vim.log.levels.ERROR)
                return
              end
              if not vim.treesitter.language.add(language) then
                vim.notify("Tree-sitter parser for " .. language .. " is unavailable after installation", vim.log.levels.ERROR)
                return
              end
              if vim.api.nvim_buf_is_loaded(event.buf) and vim.bo[event.buf].filetype == filetype then
                start_treesitter(event.buf)
              end
            end)
          end)
        end,
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.enable("angularls")
      vim.lsp.enable("ts_ls")

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Go to definition" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Hover" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf, desc = "Go to implementation" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code action" })
        end,
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if luasnip.jumpable(1) then
          return "<Plug>luasnip-jump-next"
        end
        return "<C-l>"
      end, { expr = true, desc = "Next snippet field" })
      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if luasnip.jumpable(-1) then
          return "<Plug>luasnip-jump-prev"
        end
        return "<C-j>"
      end, { expr = true, desc = "Previous snippet field" })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "luasnip" } },
          { { name = "buffer" } }
        ),
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    end,
  },

  -- Which-key (keybinding discovery)
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Gitsigns (git diff indicators)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Lualine (status line)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "vscode" },
      })
    end,
  },
}, { rocks = { enabled = false } })

-- Core editor settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clear search highlights with Escape in normal mode
vim.keymap.set("n", "<Esc>", ":nohl<CR>", { desc = "Clear search highlights" })

-- Clipboard (works on Windows + Linux)
vim.keymap.set("v", "<leader>y", '"+y',  { desc = "Copy to clipboard" })
vim.keymap.set("v", "<leader>x", '"+d',  { desc = "Cut to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p',  { desc = "Paste after" })
vim.keymap.set("n", "<leader>P", '"+P',  { desc = "Paste before" })
vim.keymap.set("v", "<leader>p", '"+p',  { desc = "Paste (visual)" })

-- Save and quit
vim.keymap.set("n", "<leader>w", ":w<CR>",  { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":q<CR>",  { desc = "Quit" })
vim.keymap.set("n", "<leader>!q", ":q!<CR>",  { desc = "Quit without save" })
vim.keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Save and quit" })

-- Disable unused providers (removes checkhealth warnings)
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
