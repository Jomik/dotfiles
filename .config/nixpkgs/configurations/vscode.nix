{ pkgs, ... }:

{
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vim";
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
      {
        name = "better-comments";
        publisher = "aaron-bond";
        version = "2.0.3";
        sha256 = "1v6j1blh00y3wr1lawqacvclh4r99vf8h8vjqw4p2y1mv5kh0xk5";
      }
      {
        name = "bracket-pair-colorizer-2";
        publisher = "CoenraadS";
        version = "0.0.25";
        sha256 = "1v57g9symyqidcsj1cqy43ahi00aw1glbrksh8zd42nsk36cr1yc";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "9.3.0";
        sha256 = "05zwviyr1ja525ifn2a704ykl4pvqjvpppmalwy4z77bn21j2ag7";
      }
      {
        name = "prettier-vscode";
        publisher = "esbenp";
        version = "1.7.3";
        sha256 = "124c5qj4gbhxq0fp1y7p4fl7dd4lw92713253h931rzp53iqww8d";
      }
      {
        name = "dotenv";
        publisher = "mikestead";
        version = "1.0.1";
        sha256 = "0rs57csczwx6wrs99c442qpf6vllv2fby37f3a9rhwc8sg6849vn";
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
