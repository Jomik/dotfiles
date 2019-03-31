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
      LABEL = "";
    };
  }
  {
    cpu = {
      inherit markup;
      command = "${./cpu}";
      interval = "persist";
      LABEL = "";
    };
  }
  {
    volume = {
      inherit markup;
      command = "${./volume}";
      interval = "once";
      signal = 11;
      LABEL = "墳";
    };
  }
  {
    brightness = {
      inherit markup;
      command = "${./brightness}";
      interval = "once";
      signal = 11;
      LABEL = "墳";
    };
  }
  {
    battery = {
      inherit markup;
      command = "${./battery}";
      interval = 30;
      CHARGING = colors.green;
      LABEL = "";
    };
  }
  {
    battery_draw = {
      command = "${./battery_draw}";
      interval = 1;
      label = "";
    };
  }
  {
    ssid = {
      inherit markup;
      command = "${./ssid}";
      interval = 30;
      LABEL = "";
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

