{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.alacritty;

  mapAttrNamesRecursive' = f: set:
    let
      recurse = set:
        let
          g =
            name: value:
            if isAttrs value
              then nameValuePair (f name) (recurse value)
              else nameValuePair (f name) value;
        in mapAttrs' g set;
    in recurse set;

  toSnakeCase = replaceChars upperChars (map (c: "_${c}") lowerChars);

  animationList = [
    "Ease"
    "EaseOut"
    "EaseOutSine"
    "EaseOutQuad"
    "EaseOutCubic"
    "EaseOutQuart"
    "EaseOutQuint"
    "EaseOutExpo"
    "EaseOutCirc"
    "Linear"
  ];
  actionList = [
    "Paste"
    "PasteSelection"
    "Copy"
    "IncreaseFontSize"
    "DecreaseFontSize"
    "ResetFontSize"
    "ScrollPageUp"
    "ScrollPageDown"
    "ScrollToTop"
    "ScrollToBottom"
    "ClearHistory"
    "Hide"
    "Quit"
    "ClearLogNotice"
  ];
  modList = [
    "Command"
    "Control"
    "Shift"
    "Alt"
  ];
  intOption = default: mkOption {
    inherit default;
    type = types.int;
  };
  floatOption = default: mkOption {
    inherit default;
    type = types.float;
  };
  boolOption = default: mkOption {
    inherit default;
    type = types.bool;
  };
  strOption = default: mkOption {
    inherit default;
    type = types.str;
  };
  nullStrOption = mkOption {
    default = null;
    type = types.nullOr types.str;
  };
in {
  options.programs.alacritty = with types; {
    enable = mkEnableOption "Alacritty terminal";
    window = {
      dimensions = {
        columns = intOption 80;
        lines = intOption 24;
      };
      padding = {
        x = intOption 2;
        y = intOption 2;
      };
      dynamicPadding = boolOption false;
      decorations = mkOption {
        type = enum [ "none" "full" ];
        default = "full";
      };
      startMaximized = boolOption false;
    };
    scrolling = {
      history = intOption 10000;
      multiplier = intOption 3;
      fauxMultiplier = intOption 3;
      autoScroll = boolOption false;
    };
    tabspaces = intOption 8;
    font = let
      fontOption = {
        family = strOption "monospace";
        style = mkOption {
          type = nullOr (enum ["Regular" "Bold" "Italic"]);
          default = null;
        };
      };
    in {
      normal = fontOption;
      bold = fontOption;
      italic = fontOption;
      size = floatOption 11.0;
      offset = {
        x = intOption 0;
        y = intOption 0;
      };
      glyphOffset = {
        x = intOption 0;
        y = intOption 0;
      };
    };
    renderTimer = boolOption false;
    persistentLogging = boolOption false;
    drawBoldTextWithBrightColors = boolOption false;
    colors = {
      primary = {
        background = strOption "0x000000";
        foreground = strOption "0xeaeaea";
        dimForeground = nullStrOption;
        brightForeground = nullStrOption;
      };
      normal = {
        black = strOption "0x000000";
        red = strOption "0xd54e53";
        green = strOption "0xb9ca4a";
        yellow = strOption "0xe6c547";
        blue = strOption "0x7aa6da";
        magenta = strOption "0xc397d8";
        cyan = strOption "0x70c0ba";
        white = strOption "0xffffff";
      };
      bright = {
        black = strOption "0x666666";
        red = strOption "0xff3334";
        green = strOption "0x9ec400";
        yellow = strOption "0xe7c547";
        blue = strOption "0x7aa6da";
        magenta = strOption "0xb77ee0";
        cyan = strOption "0x54ced6";
        white = strOption "0xffffff";
      };
      dim = {
        black = strOption "0x333333";
        red = strOption "0xf2777a";
        green = strOption "0x99cc99";
        yellow = strOption "0xffcc66";
        blue = strOption "0x6699cc";
        magenta = strOption "0xcc99cc";
        cyan = strOption "0x66cccc";
        white = strOption "0xffffff";
      };
      indexedColors = mkOption {
        type = listOf (submodule {
          options = {
            index = mkOption {
              type = int;
            };
            color = mkOption {
              type = str;
            };
          };
        });
        default = [];
      };
    };
    visualBell = {
      animation = mkOption {
        type = enum animationList;
        default = "EaseOutExpo";
      };
      duration = intOption 0;
    };
    backgroundOpacity = floatOption 1.0;
    mouseBindings = mkOption {
      default = [];
      type = listOf (submodule {
        options = {
          mouse = mkOption { type = str; };
          action = mkOption { type = enum actionList; };
        };
      });
    };
    mouse = {
      doubleClick = mkOption {
        type = int;
        default = 300;
        apply = threshold: { inherit threshold; };
      };
      tripleClick = mkOption {
        type = int;
        default = 300;
        apply = threshold: { inherit threshold; };
      };
      hideWhenTyping = boolOption false;
      url = {
        launcher = strOption "xdg-open";
        modifiers = mkOption {
          type = listOf (enum modList);
          default = [];
          apply = lib.concatStringsSep "|";
        };
      };
    };
    selection = {
      semanticEscapeChars = strOption ",│`|:\"' ()[]{}<>";
      saveToClipbord = boolOption false;
    };
    dynamicTitle = boolOption true;
    cursor = {
      style = mkOption {
        type = enum [ "Block" "Underline" "Beam" ];
        default = "Block";
      };
      unfocusedHollow = boolOption true;
    };
    liveConfigReload = boolOption true;
    shell = mkOption {
      default = null;
      type = nullOr (submodule {
        options = {
          program = mkOption {
            type = package;
          };
          args = mkOption {
            type = listOf str;
            default = [];
          };
        };
      });
    };
    keyBindings = let
      base = {
        key = mkOption { type = str; };
        mods = mkOption {
          type = listOf modList;
          default = [];
          apply = lib.concatStringsSep "|";
        };
        mode = mkOption {
          type = nullOr (enum [ "~AppCursor" "AppCursor" "~AppKeypad" "AppKeypad" ]);
          default = null;
        };
      };
      in mkOption {
        default = [];
        type = listOf (either (submodule (base // {
          chars = mkOption {
            type = str;
          };
        })) (either (submodule ( base // {
          action = mkOption {
            type = enum actionList;
          };
        })) (submodule (base // {
          command = subOptions {
            program = mkOption {
              type = package;
            };
            args = mkOption {
              type = listOf str;
              default = [];
            };
          };
        }))));
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.alacritty ];

    xdg.configFile."alacritty/alacritty.yml".text = let
        tmp = filterAttrsRecursive (n: v: v != null && v != "" && v != []) cfg;
        set = mapAttrNamesRecursive' toSnakeCase tmp;
      in builtins.toJSON set;
  };
}

