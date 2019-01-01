{ pkgs, ... }:

{
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "Vim";
        publisher = "vscodevim";
        version = "0.17.0";
        sha256 = "013qsq8ms5yw40wc550p0ilalj1575aj6pqmrczzj04pvfywmf7d";
      }
      {
        name = "fish-vscode";
        publisher = "skyapps";
        version = "0.2.1";
        sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
      }
    ];
    userSettings = {
      editor = {
        fontFamily = "Fira Code";
        tabSize = 2;
        fontLigatures = true;
        wordWrap = "bounded";
        wordWrapColumn = 120;
        formatOnSave = true;
        lineNumbers = "off";
      };
    };
  };
}
