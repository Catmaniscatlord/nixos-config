{
  plugins.startup = {
    enable = true;

    settings = {

      colors = {
        background = "#ffffff";
        folded_section = "#ffffff";
      };

      parts = [
        "header"
        "body"
      ];

      header = {
        type = "text";
        oldfilesDirectory = false;
        align = "center";
        foldSection = false;
        title = "Header";
        margin = 5;
        content = [
          "███████╗██╗     ██╗   ██╗██████╗ ██████╗  "
          "██╔════╝██║     ██║   ██║██╔══██╗██╔══██╗ "
          "███████╗██║     ██║   ██║██████╔╝██████╔╝ "
          "╚════██║██║     ██║   ██║██╔══██╗██╔═══╝  "
          "███████║███████╗╚██████╔╝██║  ██║██║      "
          "╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝      "
        ];
        highlight = "Statement";
        defaultColor = "";
        oldfilesAmount = 0;
      };

      body = {
        type = "mapping";
        oldfilesDirectory = false;
        align = "center";
        foldSection = false;
        title = "Menu";
        margin = 5;
        content = [
          [
            " Find File"
            "lua Snacks.picker.files()"
            "ff"
          ]
          [
            " Find Word"
            "lua Snacks.picker.grep()"
            "fr"
          ]
          [
            " File Browser"
            "Neotree position=float"
            "fe"
          ]
          [
            " Reload session"
            ''lua require("persistence").load()''
            "l"
          ]
          [
            " last session"
            ''lua require("persistence").load({ last = true })''
            "s"
          ]
        ];
        highlight = "string";
        defaultColor = "";
        oldfilesAmount = 0;

      };

      options = {
        paddings = [
          1
          3
        ];
      };

    };

  };
}
