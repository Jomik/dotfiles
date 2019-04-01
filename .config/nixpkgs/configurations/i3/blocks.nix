{ lib, ...}: colors: 

with lib;

let
  markup = "pango";
in ''
BAR_EMPTY_COLOR=${colors.gray}
BAR_CRITICAL_COLOR=${colors.red}

'' + concatMapStringsSep "\n" (generators.toINI {}) [
  {
    memory = {
      inherit markup;
      command = "${./memory}";
      interval = 1;
      LABEL = "\\uf2db";
    };
  }
  {
    cpu = {
      inherit markup;
      command = "${./cpu}";
      interval = "persist";
      LABEL = "\\uf85a";
    };
  }
  {
    volume = {
      inherit markup;
      command = "${./volume}";
      interval = "once";
      signal = 11;
      LABEL = "\\ufa7d";
      BAR_MUTE_COLOR = colors.red;
    };
  }
  {
    brightness = {
      inherit markup;
      command = "${./brightness}";
      interval = "once";
      signal = 11;
      LABEL = "\\uf5df";
    };
  }
  {
    battery = {
      inherit markup;
      command = "${./battery}";
      interval = 30;
      CHARGING = colors.green;
      LABEL = "\\uf240";
    };
  }
  {
    battery_draw = {
      command = "${./battery_draw}";
      interval = 1;
      LABEL = "\\uf0e7 ";
    };
  }
  {
    ssid = {
      inherit markup;
      command = "${./ssid}";
      interval = 30;
      LABEL = "\\uf1eb";
      NOT_CONNECTED_COLOR = colors.red;
    };
  }
  {
    time = {
      command = "date '+%A, %d. %B %H:%M:%S '";
      interval = 1;
    };
  }
]

