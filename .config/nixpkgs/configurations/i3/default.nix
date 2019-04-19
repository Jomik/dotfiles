{ config, pkgs, lib, ... }:

with lib;

let
  i3blocks = pkgs.i3blocks.overrideAttrs (old: {
    version = "20190207";
    src = pkgs.fetchFromGitHub {
      owner = "vivien";
      repo = "i3blocks";
      rev = "ec050e79ad8489a6f8deb37d4c20ab10729c25c3";
      sha256 = "1fx4230lmqa5rpzph68dwnpcjfaaqv5gfkradcr85hd1z8d1qp1b";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.autoreconfHook ];
    postFixup = ":";
  });
  nerdfonts_iosevka = let version = "2.0.0"; in pkgs.fetchzip rec {
    name = "nerdfonts-iosevka";

    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/Iosevka.zip";

    sha256 = "1b8agwll5safqzxcf80sinxwhgqmrh3jh2arvskshvll29dzigp2";

    postFetch = ''
      mkdir -p $out/share/fonts
      unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    '';
  };
  modifier = config.xsession.windowManager.i3.config.modifier;
  powerMenu = with pkgs.nur.repos.jomik; rofi-menu "power-menu" [
    [ "Lock" "${slock}/bin/slock" false ]
    [ "Logout" "exec i3-msg exit" true ]
    [ "Suspend" "systemctl suspend" true ]
    [ "Hibernate" "systemctl hibernate" true ]
    [ "Reboot" "systemctl reboot" true ]
    [ "Shutdown" "systemctl poweroff" true ]
    [ "Halt" "systemctl halt" true ]
  ];
  gruvbox-dark = {
    bg = "#282828";
    bg1 = "#3c3836";
    bg2 = "#504945";
    bg3 = "#665c54";
    bg4 = "#7c6f64";
    fg = "#fbf1c7";
    fg1 = "#ebdbb2";
    fg2 = "#d5c4a1";
    fg3 = "#bdae93";
    fg4 = "#a89984";
    gray = "#928374";
    red = "#fb4934";
    green = "#b8bb26";
    yellow = "#fabd2f";
    blue = "#83a598";
    purple = "#d3869b";
    aqua = "#8ec07c";
    orange = "#fe8019";
  };
  gruvbox-light = {
    bg = "#fbf1c7";
    bg1 = "#ebdbb2";
    bg2 = "#d5c4a1";
    bg3 = "#bdae93";
    bg4 = "#a89984";
    fg = "#282828";
    fg1 = "#3c3836";
    fg2 = "#504945";
    fg3 = "#665c54";
    fg4 = "#7c6f64";
    gray = "#928374";
    red = "#9d0006";
    green = "#79740e";
    yellow = "#b57614";
    blue = "#076678";
    purple = "#8f3f71";
    aqua = "#427b58";
    orange = "#af3a03";
  };

  fonts = [ "Iosevka Regular 11"];
in mkIf config.xsession.windowManager.i3.enable {
  home.packages = with pkgs; [
    nerdfonts_iosevka
  ];

  xdg.configFile."i3blocks/config".text = pkgs.callPackage ./blocks.nix {} gruvbox-dark;

  xsession.windowManager.i3.config = {
    inherit fonts;
    modifier = "Mod4";
    assigns = {
      "9" = [{ class = "^discord$"; } { class = "^Slack$"; }];
    };
    bars = [{
      inherit fonts;
      id = "bottom-bar";
      position = "bottom";
      mode = "hide";
      # statusCommand = "${i3blocks}/bin/i3blocks";
      statusCommand = "2> /tmp/i3blocks.err ${i3blocks}/bin/i3blocks -vvv | tee /tmp/i3blocks.out";
      workspaceButtons = true;
      colors = with gruvbox-dark; {
        background = bg;
        statusline = yellow;
        focusedWorkspace = {
          border = yellow;
          background = bg1;
          text = fg;
        };
        activeWorkspace = {
          border = yellow;
          background = bg;
          text = gray;
        };
        inactiveWorkspace = {
          border = gray;
          background = bg;
          text = gray;
        };
        urgentWorkspace = {
          border = red;
          background = red;
          text = fg;
        };
      };
    }];
    colors = with gruvbox-dark; {
      background = bg;
      focused = {
        border = yellow;
        background = bg1;
        text = fg;
        indicator = purple;
        childBorder = gray;
      };
      focusedInactive = {
        border = gray;
        background = bg;
        text = gray;
        indicator = purple;
        childBorder = gray;
      };
      unfocused = {
        border = gray;
        background = bg;
        text = gray;
        indicator = purple;
        childBorder = gray;
      };
      urgent = {
        border = red;
        background = red;
        text = fg;
        indicator = red;
        childBorder = red;
      };
    };
    keybindings = with pkgs; with nur.repos.jomik; mkOptionDefault {
      "${modifier}+comma" = "focus output left";
      "${modifier}+Shift+comma" = "move workspace to output left";
      "${modifier}+period" = "focus output right";
      "${modifier}+Shift+period" = "move workspace to output right";
      "${modifier}+Shift+q" = "exec ${powerMenu}/bin/power-menu";
      "${modifier}+Shift+p" = "exec ${rofi-pass}/bin/rofi-pass";
      "${modifier}+Shift+l" = "exec ${slock}/bin/slock";
      "${modifier}+p" = "exec ${rofi}/bin/rofi -show drun -show-icons";
      "${modifier}+Shift+c" = "kill";
      "XF86MonBrightnessDown" = "exec ${pkgs.acpilight}/bin/xbacklight -dec 10 && pkill -RTMIN+10 i3blocks";
      "XF86MonBrightnessUp" = "exec ${pkgs.acpilight}/bin/xbacklight -inc 10 && pkill -RTMIN+10 i3blocks";
      "XF86AudioLowerVolume" = "exec amixer -q set Master 5%- unmute && pkill -RTMIN+11 i3blocks";
      "XF86AudioRaiseVolume" = "exec amixer -q set Master 5%+ unmute && pkill -RTMIN+11 i3blocks";
      "XF86AudioMute" = "exec amixer -q set Master toggle && pkill -RTMIN+11 i3blocks";
    };
  };

  xsession.pointerCursor = {
    defaultCursor = "left_ptr";
    package = pkgs.gnome3.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  services.screen-locker.enable = true;
  services.screen-locker.lockCmd = "${pkgs.nur.repos.jomik.slock}/bin/slock";
  services.dunst.enable = true;

  programs.rofi = {
    enable = true;
    terminal = "$TERMINAL";
    separator = "solid";
    theme = "gruvbox-light";
    extraConfig = ''
      rofi.modi: drun,window
    '';
  };
}
