{ config, lib, pkgs, ... }:

with lib;

let
  nerdfonts_iosevka = let version = "2.0.0"; in pkgs.fetchzip rec {
    name = "nerdfonts-iosevka";
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/Iosevka.zip";

    sha256 = "1b8agwll5safqzxcf80sinxwhgqmrh3jh2arvskshvll29dzigp2";

    postFetch = ''
      mkdir -p $out/share/fonts
      unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    '';
  };
  colors = {
    bg = "#263238";
    fg = "#DFDFDF";
    ac = "#00BCD4";

    bi = "#00BCD4";
    be = "#00BCD4";
    bf = "#43a047";
    bn = "#43a047";
    bm = "#fdd835";
    bd = "#e53935";

    trans = "#00000000";
    white = "#FFFFFF";
    black = "#000000";

    red = "#e53935";
    pink = "#d81b60";
    purple = "#8e24aa";
    deep-purple = "#5e35b1";
    indigo = "#3949ab";
    blue = "#1e88e5";
    light-blue = "#039be5";
    cyan = "#00acc1";
    teal = "#00897b";
    green = "#43a047";
    light-green = "#7cb342";
    lime = "#c0ca33";
    yellow = "#fdd835";
    amber = "#ffb300";
    orange = "#fb8c00";
    deep-orange = "#f4511e";
    brown = "#6d4c41";
    grey = "#757575";
    blue-gray = "#546e7a";
  };

  bar = name: rising:
    let
      attr = if name != "" then "-${name}" else "";
    in {
      "bar${attr}-width" = 10;
      "bar${attr}-gradient" = false;

      "bar${attr}-indicator" = "";
      "bar${attr}-indicator-foreground" = colors.bi;
      "bar${attr}-indicator-font" = 2;

      "bar${attr}-fill" = "━";
      "bar${attr}-foreground-0" = if rising then colors.bn else colors.bd;
      "bar${attr}-foreground-1" = if rising then colors.bn else colors.bd;
      "bar${attr}-foreground-2" = if rising then colors.bn else colors.bm;
      "bar${attr}-foreground-3" = if rising then colors.bn else colors.bm;
      "bar${attr}-foreground-4" = if rising then colors.bm else colors.bm;
      "bar${attr}-foreground-5" = if rising then colors.bm else colors.bn;
      "bar${attr}-foreground-6" = if rising then colors.bm else colors.bn;
      "bar${attr}-foreground-7" = if rising then colors.bd else colors.bn;
      "bar${attr}-foreground-8" = if rising then colors.bd else colors.bn;
      "bar${attr}-fill-font" = 2;

      "bar${attr}-empty" = "┉";
      "bar${attr}-empty-foreground" = colors.be;
      "bar${attr}-empty-font" = 2;
    };

  checkupdates = version: channel: pkgs.writeShellScriptBin "check-updates" ''
    res="$(curl -s https://channels.nix.gsc.io/nixos-${version}/latest)"
    sha=\""$(echo $res | cut -d " " -f 1)"\"
    cur="$(nix-instantiate --eval -E 'with import <${channel}> {}; lib.trivial.revisionWithDefault null')"
    if [[ "$sha" != "$cur" ]]; then
      time="$(echo $res | cut -d " " -f 2)"
      echo "%{F${colors.yellow}} ${channel} outdated $(date --date "@$time" +"%d-%m-%y")%{F-}"
    else
      echo "%{F${colors.green}} ${channel}%{F-}"
    fi
  '';
in mkIf config.services.polybar.enable {
  home.packages = with pkgs; [
    nerdfonts_iosevka
    siji
  ];
  services.polybar = {
    config = {
      bars = {
        top = {
          modules-left = "title";
          modules-center = "workspaces";
          modules-right = "wlan date";

          font-0 = "Siji:style=Regular:size=12;1";
          font-1 = "Iosevka:style=Regular:size=12;1";

          background = colors.bg;
          foreground = colors.fg;

          bottom = false;
          width = "100%";
          height = 20;
          fixed-center = true;

          line-size = 2;
          line-color = colors.ac;
          border-bottom-size = 2;
          border-color = colors.ac;
          padding = 1;
          module-margin-left = 1;
          module-margin-right = 1;
        };
        bottom = {
          modules-left = "updates";
          modules-center = "cpu memory battery";
          modules-right = "brightness volume";

          font-0 = "Siji:style=Regular:size=12;1";
          font-1 = "Iosevka:style=Regular:size=12;1";

          background = colors.bg;
          foreground = colors.fg;

          bottom = true;
          width = "100%";
          height = 20;
          fixed-center = true;

          line-size = 2;
          line-color = colors.ac;
          border-top-size = 2;
          border-color = colors.ac;
          padding = 1;
          module-margin-left = 1;
          module-margin-right = 1;
        };
      };
      modules = {
        workspaces = {
          type = "internal/xworkspaces";
          enable-click = true;
          enable-scroll = true;

          icon-default = "w";

          format = "<label-state>";
          format-padding = 0;

          label-monitor = "%name%";
          label-active = "%name% %icon%";
          label-active-foreground = colors.ac;
          label-active-background = colors.bg;
          label-occupied = "%icon%";
          label-occupied-underline = colors.fg;
          label-urgent = "%icon%";
          label-urgent-foreground = colors.red;
          label-urgent-background = colors.bg;
          label-empty = "%icon%";
          label-empty-foreground = colors.fg;
          label-active-padding = 1;
          label-urgent-padding = 1;
          label-occupied-padding = 1;
          label-empty-padding = 1;
        };
        title = {
          type = "internal/xwindow";
          label-maxlen = 30;
        };
        date = {
          type = "internal/date";
          interval = 1;
          time = " %H:%M";
          time-alt = " %d-%m-%Y%";
          format = "<label>";
          label = "%time%";
        };
        wlan = {
          type = "internal/network";
          interface = "wlp2s0";
          interval = 1;

          format-connected = "<ramp-signal> <label-connected>";
          format-disconnected = "<label-disconnected>";

          label-connected = "%essid% %downspeed:8% %upspeed:8%";
          label-disconnected = " Not Connected";

          ramp-signal-0 = "";
          ramp-signal-1 = "";
          ramp-signal-2 = "";
          ramp-signal-3 = "";
          ramp-signal-4 = "";
        };
        volume = bar "volume" true // {
          type = "internal/alsa";

          format-volume = "<ramp-volume> <bar-volume>";
          label-volume = "%percentage%%";
          format-muted-prefix = "";
          label-muted = " Muted";
          label-muted-foreground = colors.ac;

          ramp-volume-0 = "";
          ramp-volume-1 = "";
          ramp-volume-2 = "";
          ramp-volume-3 = "";
          ramp-volume-4 = "";
        };
        battery = bar "capacity" false //  {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "AC";
          time-format = "%H:%M";

          format-charging = "<bar-capacity>";
          format-charging-prefix = " ";
          format-discharging = "<bar-capacity>";
          format-discharging-prefix = " ";
          label-charging = "%percentage%%;";
          label-discharging = "%percentage%%";
          label-full = "Fully Charged";

          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          ramp-capacity-3 = "";
          ramp-capacity-4 = "";
          ramp-capacity-5 = "";
          ramp-capacity-6 = "";
          ramp-capacity-7 = "";
          ramp-capacity-8 = "";
          ramp-capacity-9 = "";

          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-3 = "";
          animation-charging-4 = "";
          animation-charging-5 = "";
          animation-charging-6 = "";
          animation-charging-7 = "";
          animation-charging-8 = "";

          animation-charging-framerate = 750;
        };
        brightness = bar "" true // {
          type = "internal/backlight";
          card = "intel_backlight";
          format = "<ramp> <bar>";
          label = "%percentage%%";
          ramp-0 = "";
          ramp-1 = "";
          ramp-2 = "";
          ramp-3 = "";
          ramp-4 = "";
        };
        cpu = bar "load" true // {
          type = "internal/cpu";
          format = "<bar-load>";
          format-prefix = " ";
          label = "%percentage%%";
        };
        memory = bar "used" true // {
          type = "internal/memory";
          format = "<bar-used>";
          format-prefix = " ";
        };
        updates = {
          type = "custom/script";
          exec = "${checkupdates "19.03" "nixpkgs"}/bin/check-updates";
          exec-if = "ping -c 1 google.com";
          interval = 30 * 60;
          label-font = 1;
        };
      };
    };
  };
}
