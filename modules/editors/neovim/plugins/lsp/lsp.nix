{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.languages;
in
{
  plugins = {
    lsp-lines = {
      enable = true;
    };
    lsp-format = {
      enable = true;
    };
    helm = {
      enable = true;
    };
    lsp = {
      enable = true;
      inlayHints = true;
      servers = lib.mkMerge [
        {
          html = {
            enable = true;
          };
          lua_ls = {
            enable = true;
          };
          nil_ls = {
            enable = true;
          };
          marksman = {
            enable = true;
          };
          gopls = {
            enable = true;
          };
          # bloat
          jsonls = {
            enable = true;
          };
          yamlls = {
            enable = true;
          };
        }
        (lib.mkIf cfg.c-cpp.enable {
          clangd = {
            enable = cfg.c-cpp.enable;
            cmd = [
              "clangd"
              "--clang-tidy"
            ];
          };
          cmake = {
            enable = true;
          };
        })
        (lib.mkIf cfg.kotlin.enable {
          kotlin_language_server = {
            enable = cfg.kotlin.enable;
          };
        })
        (lib.mkIf cfg.python.enable {
          pyright = {
            enable = cfg.python.enable;
          };
        })
        (lib.mkIf cfg.latex.enable {
          texlab = {
            enable = cfg.latex.enable;
          };
          ltex = {
            enable = true;
            settings = {
              language = "en-US";
            };
          };
        })
      ];

      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cf" = {
            action = "code_action";
            desc = " Quick fix";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };
    };
  };

  extraConfigLua = ''
    local _border = "rounded"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = _border
      }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = _border
      }
    )

    vim.diagnostic.config{
      float={border=_border}
    };

    require('lspconfig.ui.windows').default_options = {
      border = _border
    }
  '';
}
