{
  plugins.neo-tree = {
    enable = true;
    settings = {
      sources = [
        "filesystem"
        "buffers"
        "git_status"
        "document_symbols"
      ];
      addBlankLineAtTop = false;

      filesystem = {
        bindToCwd = false;
        follow_current_file = {
          enabled = true;
        };
      };

      defaultComponentConfigs = {
        # indent = {
        #   withExpanders = true;
        #   expanderCollapsed = "󰅂";
        #   expanderExpanded = "󰅀";
        #   expanderHighlight = "NeoTreeExpander";
        # };
        #
        # icon = {
        #   folderClosed = "󰉋 ";
        #   folderOpen = "󰝰 ";
        #   folderEmpty = "󰉖 ";
        #   folderEmptyOpen = "󰷏 ";
        #   default = "*";
        #   highlight = "NeoTreeFileIcon";
        # };
        #
        # gitStatus = {
        #   symbols = {
        #     # change type
        #     added = " ";
        #     deleted = " ";
        #     modified = " ";
        #     renamed = " ";
        #
        #     # status type
        #     untracked = " ";
        #     ignored = " ";
        #     unstaged = "";
        #     staged = "";
        #     conflict = " ";
        #   };
        # };
      };

    };
  };
  keymaps = [
    {
      mode = [ "n" ];
      key = "<leader>e";
      action = "<cmd>Neotree toggle<cr>";
      options = {
        desc = "Open/Close Neotree";
      };
    }
  ];
}
