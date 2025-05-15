{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.shells.zsh;
in
{
  options.modules.shells = {
    zsh.enable = lib.mkEnableOption "Use the zsh shell";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      syntaxHighlighting = {
        enable = true;
      };

      autosuggestion = {
        enable = true;
        strategy = [
          "history"
          "completion"
        ];
      };

      oh-my-zsh = {
        enable = true;
        theme = "rkj-repos";
        plugins = [ ]; # TODO find good plugins
      };

      initExtra = ''
        nix() {
          if [[ $1 == "develop" ]]; then
            shift
            command nix develop -c $SHELL "$@"
          else
            command nix "$@"
          fi
        }
      '';

      shellAliases = {
        lg = "lazygit";
        nix-shell = "nix-shell --run $SHELL";
      };
    };
  };

}
