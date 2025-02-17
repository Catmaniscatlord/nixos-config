{
  # Having issues with this and which-key
  # plugins.snacks = {
  #   enable = true;
  #   settings = {
  #     toggle = {
  #       enabled = true;
  #       which_key = true;
  #       icon = {
  #         enabled = " ";
  #         disabled = " ";
  #       };
  #       color = {
  #         enabled = "green";
  #         disabled = "yellow";
  #       };
  #     };
  #   };
  # };
  #
  # autoCmd = [
  #   {
  #     desc = "Pre init Function";
  #     event = [ "VimEnter" ];
  #     callback.__raw = ''
  #       -- Taken from https://github.com/folke/snacks.nvim?tab=readme-ov-file#-usage
  #       function()
  #         -- Setup some globals for debugging (lazy-loaded)
  #         _G.dd = function(...)
  #           Snacks.debug.inspect(...)
  #         end
  #         _G.bt = function()
  #           Snacks.debug.backtrace()
  #         end
  #         vim.print = _G.dd -- Override print to use snacks for `:=` command
  #
  #         -- Create some toggle mappings
  #         Snacks.toggle.diagnostics():map("<leader>ud")
  #         Snacks.toggle.line_number():map("<leader>ul")
  #         Snacks.toggle.inlay_hints():map("<leader>uh")
  #         Snacks.toggle.treesitter():map("<leader>uT")
  #         Snacks.toggle.option("spell",
  #           { name = "Spelling" }):map("<leader>us")
  #         Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  #         Snacks.toggle.option("relativenumber",
  #           { name = "Relative Number" }):map("<leader>uL")
  #         Snacks.toggle.option("conceallevel",
  #           { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
  #         Snacks.toggle.option("background",
  #           { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
  #       end
  #     '';
  #   }
  # ];
}
