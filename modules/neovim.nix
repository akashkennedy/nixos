{
  config,
  pkgs,
  ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # --------------------------------------------------------------------------
    # Appearance
    # --------------------------------------------------------------------------

    colorscheme = "catppuccin";
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      autoindent = true;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      signcolumn = "yes";
      cursorline = true;
      termguicolors = true;
      clipboard = "unnamedplus";
      mouse = "a";
      scrolloff = 8;
      wrap = false;
      splitright = true;
      splitbelow = true;
      laststatus = 3;
      updatetime = 300;
    };

    globals = {
      mapleader = " ";
    };

    # C/C++ use 4-space indentation, clang-format will handle the rest.
    autoCmd = [
      {
        event = [ "FileType" ];
        pattern = [
          "c"
          "cpp"
          "objc"
          "objcpp"
          "cuda"
        ];
        command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4";
      }
    ];

    # --------------------------------------------------------------------------
    # Keymaps (LazyVim-style, <leader> = space)
    # --------------------------------------------------------------------------

    keymaps = [
      # --- general ---
      {
        key = "<leader>w";
        action = "<cmd>write<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>q";
        action = "<cmd>qa<cr>";
      }
      {
        key = "<leader>h";
        action = "<cmd>nohlsearch<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>=";
        action = "<cmd>wincmd =<cr>";
        options = { silent = true; };
      }

      # --- window navigation / resizing ---
      {
        key = "<C-h>";
        action = "<C-w>h";
      }
      {
        key = "<C-j>";
        action = "<C-w>j";
      }
      {
        key = "<C-k>";
        action = "<C-w>k";
      }
      {
        key = "<C-l>";
        action = "<C-w>l";
      }
      {
        key = "<C-Up>";
        action = "<cmd>resize +4<cr>";
        options = { silent = true; };
      }
      {
        key = "<C-Down>";
        action = "<cmd>resize -4<cr>";
        options = { silent = true; };
      }
      {
        key = "<C-Left>";
        action = "<cmd>vertical resize -4<cr>";
        options = { silent = true; };
      }
      {
        key = "<C-Right>";
        action = "<cmd>vertical resize +4<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>_";
        action = "<cmd>split<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>|";
        action = "<cmd>vsplit<cr>";
        options = { silent = true; };
      }

      # --- buffers (LazyVim style) ---
      {
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options = { silent = true; };
      }
      {
        key = "<Tab>";
        mode = "n";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = { silent = true; };
      }
      {
        key = "<S-Tab>";
        mode = "n";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>b]";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>b[";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = { silent = true; };
      }

      # --- find (fuzzy finders) ---
      {
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>fr";
        action = "<cmd>Telescope oldfiles<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
        options = { silent = true; };
      }
      {
        key = "<C-p>";
        action = "<cmd>Telescope find_files<cr>";
        options = { silent = true; };
      }

      # --- explorer ---
      {
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>-";
        action = "<cmd>Neotree reveal<cr>";
        options = { silent = true; };
      }

      # --- code (LSP / LazyVim style) ---
      {
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
      }
      {
        key = "gD";
        action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
      }
      {
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<cr>";
      }
      {
        key = "gi";
        action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
      }
      {
        key = "gt";
        action = "<cmd>lua vim.lsp.buf.type_definition()<cr>";
      }
      {
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
      }
      {
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      }
      {
        key = "<leader>cr";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
      }
      {
        key = "<leader>cf";
        action = "<cmd>lua vim.lsp.buf.format({ async = true })<cr>";
      }
      {
        key = "<leader>cd";
        action = "<cmd>Telescope lsp_document_symbols<cr>";
        options = { silent = true; };
      }

      # --- diagnostics / troubleshooting ---
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>xq";
        action = "<cmd>Telescope quickfix<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>xn";
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>xp";
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
        options = { silent = true; };
      }
      {
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
        options = { silent = true; };
      }
      {
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
        options = { silent = true; };
      }

      # --- git ---
      {
        key = "<leader>gg";
        action = "<cmd>LazyGit<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>gl";
        action = "<cmd>Telescope git_commits<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>gs";
        action = "<cmd>Telescope git_status<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>gd";
        action = "<cmd>Gitsigns diffthis<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame_line<cr>";
        options = { silent = true; };
      }
      {
        key = "]h";
        action = "<cmd>Gitsigns next_hunk<cr>";
        options = { silent = true; };
      }
      {
        key = "[h";
        action = "<cmd>Gitsigns prev_hunk<cr>";
        options = { silent = true; };
      }

      # --- terminal ---
      {
        key = "<C-\\>";
        action = "<cmd>ToggleTerm<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>tt";
        action = "<cmd>ToggleTerm direction=float<cr>";
        options = { silent = true; };
      }
      {
        key = "<leader>ft";
        action = "<cmd>ToggleTerm direction=float<cr>";
        options = { silent = true; };
      }
    ];

    # Which-key group labels shown when pressing <leader> (space)
    plugins.which-key = {
      enable = true;
      settings.spec = [
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "Code";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "Find";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
        }
        {
          __unkeyed-1 = "<leader>x";
          group = "Diagnostics";
        }
      ];
    };

    # --------------------------------------------------------------------------
    # Language servers, formatters, linters (web dev + C/C++)
    # --------------------------------------------------------------------------

    extraPackages = with pkgs; [
      # Formatters
      prettierd
      stylua
      clang-tools
      nixpkgs-fmt
      shfmt
      # Linters
      eslint_d
      luaPackages.luacheck
      shellcheck
      cppcheck
      markdownlint-cli
    ];

    plugins.lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        ts_ls.enable = true;
        html.enable = true;
        cssls.enable = true;
        jsonls.enable = true;
        lua_ls.enable = true;
        nil_ls.enable = true;
      };
    };

    diagnostic.settings = {
      virtual_text = true;
      virtual_lines = false;
      update_in_insert = false;
    };

    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
        c
        cpp
        css
        scss
        html
        javascript
        json
        lua
        bash
        nix
        markdown
        tsx
        typescript
        yaml
        cmake
        make
      ];
    };

    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          javascript = [ "prettierd" ];
          javascriptreact = [ "prettierd" ];
          typescript = [ "prettierd" ];
          typescriptreact = [ "prettierd" ];
          html = [ "prettierd" ];
          css = [ "prettierd" ];
          scss = [ "prettierd" ];
          less = [ "prettierd" ];
          json = [ "prettierd" ];
          jsonc = [ "prettierd" ];
          markdown = [ "prettierd" ];
          yaml = [ "prettierd" ];
          lua = [ "stylua" ];
          c = [ "clang-format" ];
          cpp = [ "clang-format" ];
          objc = [ "clang-format" ];
          objcpp = [ "clang-format" ];
          cuda = [ "clang-format" ];
          nix = [ "nixpkgs_fmt" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
        };
        format_on_save = ''
          function(bufnr)
            return { timeout_ms = 500 }
          end
        '';
        # Deterministic C style: 4-space indent, 100-col limit, so saves always
        # produce the same predictable layout (LLVM-style braces/parens).
        formatters.clang-format.args = [
          "-assume-filename"
          "$FILENAME"
          "-style={BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 100, IndentCaseLabels: true}"
        ];
      };
    };

    plugins.lint = {
      enable = true;
      lintersByFt = {
        javascript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        typescript = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        lua = [ "luacheck" ];
        sh = [ "shellcheck" ];
        bash = [ "shellcheck" ];
        c = [ "cppcheck" ];
        cpp = [ "cppcheck" ];
        markdown = [ "markdownlint" ];
      };
    };

    # --------------------------------------------------------------------------
    # Completion & snippets (Tab to expand)
    # --------------------------------------------------------------------------

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      # VS Code-style: show at most 5 of the most relevant entries in a
      # compact popup instead of dumping every snippet.
      settings.performance.max_view_entries = 5;
      settings.window.completion = {
        max_height = 5;
        border = "rounded";
      };

      settings.snippet.expand = ''
        function(args)
          require("luasnip").lsp_expand(args.body)
        end
      '';
      settings.mapping = {
        # Tab inserts the highlighted suggestion / snippet.
        "<Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif require("luasnip").expand_or_jumpable() then
              require("luasnip").expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        # Cycle through the suggestions with Ctrl+j / Ctrl+k.
        "<C-j>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        "<C-k>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            if require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
      };
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "buffer"; }
        { name = "path"; }
      ];
    };

    plugins.luasnip = {
      enable = true;
      fromVscode = [
        {
          paths = [
            (pkgs.vimPlugins.friendly-snippets)
          ];
        }
      ];
    };

    plugins.friendly-snippets.enable = true;

    # --------------------------------------------------------------------------
    # Dashboard
    # --------------------------------------------------------------------------

    plugins.alpha = {
      enable = true;
      settings.layout = [
        {
          type = "padding";
          val = 4;
        }
        {
          type = "text";
          val = [
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ];
          opts = {
            position = "center";
            hl = "Type";
          };
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "group";
          val = [
            {
              type = "button";
              val = "  New file";
              opts = {
                shortcut = "n";
                align_shortcut = "right";
                width = 50;
                hl = "Normal";
                keymap = [
                  "n"
                  "n"
                  "<cmd>ene<CR>"
                  {
                    noremap = true;
                    silent = true;
                  }
                ];
              };
              on_press.__raw = "function() vim.cmd([[ene]]) end";
            }
            {
              type = "button";
              val = "  Find file";
              opts = {
                shortcut = "f";
                align_shortcut = "right";
                width = 50;
                hl = "Normal";
                keymap = [
                  "n"
                  "f"
                  "<cmd>Telescope find_files<CR>"
                  {
                    noremap = true;
                    silent = true;
                  }
                ];
              };
              on_press.__raw = "function() require('telescope.builtin').find_files() end";
            }
            {
              type = "button";
              val = "  Recent files";
              opts = {
                shortcut = "r";
                align_shortcut = "right";
                width = 50;
                hl = "Normal";
                keymap = [
                  "n"
                  "r"
                  "<cmd>Telescope oldfiles<CR>"
                  {
                    noremap = true;
                    silent = true;
                  }
                ];
              };
              on_press.__raw = "function() require('telescope.builtin').oldfiles() end";
            }
            {
              type = "button";
              val = "  Find text";
              opts = {
                shortcut = "g";
                align_shortcut = "right";
                width = 50;
                hl = "Normal";
                keymap = [
                  "n"
                  "g"
                  "<cmd>Telescope live_grep<CR>"
                  {
                    noremap = true;
                    silent = true;
                  }
                ];
              };
              on_press.__raw = "function() require('telescope.builtin').live_grep() end";
            }
            {
              type = "button";
              val = "  Explorer";
              opts = {
                shortcut = "e";
                align_shortcut = "right";
                width = 50;
                hl = "Normal";
                keymap = [
                  "n"
                  "e"
                  "<cmd>Neotree toggle<CR>"
                  {
                    noremap = true;
                    silent = true;
                  }
                ];
              };
              on_press.__raw = "function() require('neo-tree.command').execute({ action = 'toggle' }) end";
            }
            {
              type = "button";
              val = "  Quit Neovim";
              opts = {
                shortcut = "q";
                align_shortcut = "right";
                width = 50;
                hl = "Normal";
                keymap = [
                  "n"
                  "q"
                  "<cmd>qa<CR>"
                  {
                    noremap = true;
                    silent = true;
                  }
                ];
              };
              on_press.__raw = "function() vim.cmd([[qa]]) end";
            }
          ];
          opts = {
            spacing = 1;
          };
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [ "akash · NixOS 26.05" ];
          opts = {
            position = "center";
            hl = "Keyword";
          };
        }
      ];
    };

    # --------------------------------------------------------------------------
    # IDE extras
    # --------------------------------------------------------------------------

    plugins.neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        enable_git_status = true;
        enable_diagnostics = true;
        default_root = true;
      };
    };

    plugins.telescope = {
      enable = true;
      settings.defaults.sorting_strategy = "ascending";
      settings.defaults.layout_config.prompt_position = "top";
    };

    plugins.lualine = {
      enable = true;
      settings.options.theme = "catppuccin-mocha";
    };

    plugins.gitsigns.enable = true;

    plugins.bufferline = {
      enable = true;
      settings.options.always_show_bufferline = true;
    };

    plugins.nvim-autopairs.enable = true;

    plugins.indent-blankline = {
      enable = true;
      settings.indent = {
        char = "│";
        tab_char = "│";
      };
    };

    plugins.notify.enable = true;

    plugins.trouble.enable = true;

    plugins.toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<c-\\>]]";
        direction = "float";
        float_opts.border = "curved";
      };
    };

    plugins.lazygit.enable = true;

    # Rapid jk / jj to leave insert mode.
    plugins.better-escape.enable = true;

    # GitHub Copilot (free tier): ghost-text inline suggestions, accept with <M-l>.
    plugins.copilot-lua.enable = true;
  };
}