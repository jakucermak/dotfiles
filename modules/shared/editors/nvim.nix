{ pkgs, ... }:
{
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      lua-language-server
      nil
      marksman
      stylua
      nixfmt
      ripgrep
      fd
    ];

    plugins = with pkgs.vimPlugins; [
      ayu-vim

      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      friendly-snippets

      (nvim-treesitter.withPlugins (
        parsers: with parsers; [
          bash
          json
          lua
          markdown
          markdown_inline
          nix
          toml
          yaml
        ]
      ))

      plenary-nvim
      telescope-nvim
      nvim-web-devicons
      gitsigns-nvim
      render-markdown-nvim
    ];

    initLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      vim.g.have_nerd_font = true

      local opt = vim.opt
      opt.number = true
      opt.relativenumber = true
      opt.cursorline = true
      opt.signcolumn = "yes"
      opt.splitbelow = true
      opt.splitright = true
      opt.clipboard = "unnamedplus"
      opt.expandtab = true
      opt.shiftwidth = 2
      opt.tabstop = 2
      opt.softtabstop = 2
      opt.smartindent = true
      opt.breakindent = true
      opt.wrap = false
      opt.linebreak = true
      opt.ignorecase = true
      opt.smartcase = true
      opt.hlsearch = true
      opt.incsearch = true
      opt.undofile = true
      opt.completeopt = { "menu", "menuone", "noselect" }
      opt.updatetime = 250
      opt.timeoutlen = 400
      opt.termguicolors = true
      opt.scrolloff = 6
      opt.sidescrolloff = 8
      opt.mouse = "a"
      opt.confirm = true
      opt.laststatus = 3
      opt.pumheight = 12
      opt.spelllang = { "en_us" }
      opt.fillchars = { eob = " " }
      opt.list = true
      opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

      if vim.fn.has("nvim-0.11") == 1 then
        opt.winborder = "rounded"
      end

      local function map(mode, lhs, rhs, desc, opts)
        opts = opts or {}
        opts.desc = desc
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")
      map("n", "<leader>w", "<cmd>write<CR>", "Write buffer")
      map("n", "<leader>q", "<cmd>quit<CR>", "Quit window")
      map("n", "<leader>bd", "<cmd>bdelete<CR>", "Delete buffer")
      map("n", "<leader>bn", "<cmd>bnext<CR>", "Next buffer")
      map("n", "<leader>bp", "<cmd>bprevious<CR>", "Previous buffer")
      map("n", "<C-h>", "<C-w>h", "Focus left window")
      map("n", "<C-j>", "<C-w>j", "Focus lower window")
      map("n", "<C-k>", "<C-w>k", "Focus upper window")
      map("n", "<C-l>", "<C-w>l", "Focus right window")
      map("t", "<Esc><Esc>", "<C-\\><C-n>", "Leave terminal mode")

      -- Home Manager puts native packages on packpath; load before Lua requires.
      vim.cmd("packloadall")

      vim.o.background = "dark"
      vim.g.ayucolor = "dark"
      vim.cmd.colorscheme("ayu")

      local ayu = {
        bg = "#10141C",
        bg_alt = "#0F131A",
        bg_float = "#1F2127",
        fg = "#BFBDB6",
        muted = "#8A8986",
        border = "#475266",
        accent = "#E6B450",
        blue = "#59C2FF",
        green = "#AAD94C",
        red = "#F07178",
        orange = "#FFB454",
        cyan = "#95E6CB",
      }

      local set_hl = vim.api.nvim_set_hl
      set_hl(0, "Normal", { fg = ayu.fg, bg = ayu.bg })
      set_hl(0, "NormalFloat", { fg = ayu.fg, bg = ayu.bg_float })
      set_hl(0, "FloatBorder", { fg = ayu.border, bg = ayu.bg_float })
      set_hl(0, "CursorLine", { bg = ayu.bg_float })
      set_hl(0, "LineNr", { fg = ayu.muted })
      set_hl(0, "CursorLineNr", { fg = ayu.accent, bold = true })
      set_hl(0, "SignColumn", { bg = ayu.bg })
      set_hl(0, "Visual", { bg = "#273747" })
      set_hl(0, "Search", { fg = ayu.bg, bg = ayu.orange })
      set_hl(0, "IncSearch", { fg = ayu.bg, bg = ayu.accent })
      set_hl(0, "Pmenu", { fg = ayu.fg, bg = ayu.bg_float })
      set_hl(0, "PmenuSel", { fg = ayu.bg, bg = ayu.blue })
      set_hl(0, "DiagnosticError", { fg = ayu.red })
      set_hl(0, "DiagnosticWarn", { fg = ayu.orange })
      set_hl(0, "DiagnosticInfo", { fg = ayu.blue })
      set_hl(0, "DiagnosticHint", { fg = ayu.cyan })
      set_hl(0, "TelescopeBorder", { fg = ayu.border, bg = ayu.bg_alt })
      set_hl(0, "TelescopeNormal", { fg = ayu.fg, bg = ayu.bg_alt })
      set_hl(0, "TelescopePromptBorder", { fg = ayu.accent, bg = ayu.bg_float })
      set_hl(0, "TelescopePromptNormal", { fg = ayu.fg, bg = ayu.bg_float })

      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = {
          spacing = 2,
          prefix = "●",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌵",
          },
        },
        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.spell = true
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"
        end,
      })

      require("nvim-treesitter").setup()

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash",
          "json",
          "lua",
          "markdown",
          "nix",
          "sh",
          "toml",
          "yaml",
        },
        callback = function(event)
          if pcall(vim.treesitter.start, event.buf) and vim.bo[event.buf].filetype ~= "markdown" then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local function lsp_map(lhs, rhs, desc)
            map("n", lhs, rhs, "LSP: " .. desc, { buffer = event.buf })
          end

          lsp_map("K", vim.lsp.buf.hover, "Hover")
          lsp_map("gd", vim.lsp.buf.definition, "Go to definition")
          lsp_map("gD", vim.lsp.buf.declaration, "Go to declaration")
          lsp_map("gi", vim.lsp.buf.implementation, "Go to implementation")
          lsp_map("gr", vim.lsp.buf.references, "References")
          lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename")
          lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          lsp_map("<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format")
          lsp_map("[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, "Previous diagnostic")
          lsp_map("]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, "Next diagnostic")
        end,
      })

      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".git" },
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("nil_ls", {
        cmd = { "nil" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },
        capabilities = capabilities,
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      })

      vim.lsp.config("marksman", {
        cmd = { "marksman", "server" },
        filetypes = { "markdown", "markdown.mdx" },
        root_markers = { ".marksman.toml", ".git" },
        capabilities = capabilities,
      })

      vim.lsp.enable({ "lua_ls", "nil_ls", "marksman" })

      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          path_display = { "smart" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            width = 0.9,
            height = 0.85,
          },
        },
      })

      local builtin = require("telescope.builtin")
      map("n", "<leader>ff", builtin.find_files, "Find files")
      map("n", "<leader>fg", builtin.live_grep, "Live grep")
      map("n", "<leader>fb", builtin.buffers, "Find buffers")
      map("n", "<leader>fh", builtin.help_tags, "Help tags")
      map("n", "<leader>fs", builtin.lsp_document_symbols, "Document symbols")

      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },
      })

      require("render-markdown").setup({
        file_types = { "markdown" },
      })
      map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", "Toggle rendered Markdown")
    '';
  };
}
