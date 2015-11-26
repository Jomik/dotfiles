Config { font = "xft:inconsolata:size=10:bold"
       , bgColor = "black"
       , fgColor = "grey"
       , position = Top
       , commands = [ Run Cpu ["-t", "Cpu: <total>", "-S", "true", "-p", "3"
                              , "-L", "15", "-H", "50"
                              , "-l", "green", "-h", "red", "-n", "yellow"
                              ] 10
                    , Run Memory ["-t", "Mem: <usedratio>", "-S", "true",  "-p", "3"
                                 , "-L", "25", "-H", "60"
                                 , "-l", "green", "-h", "red", "-n", "yellow"
                                 ] 10
                    , Run BatteryP ["BAT0"]
                                   [ "-t", "<acstatus>", "-S", "true", "-p", "3"
                                   , "-L", "15", "-H", "80"
                                   , "-l", "red", "-h", "green", "-n", "yellow"
                                   , "--", "-O", "<fc=#007fff>Chrg: </fc><left>", "-o", "Batt: <left>"
                                   ] 30
                    , Run Brightness [ "-t", "Bright: <percent>", "-S", "true", "-p", "3"
                                     , "-H", "70", "-L", "25"
                                     , "-h", "red", "-l", "green", "-n", "yellow"
                                     , "--", "-D", "intel_backlight"
                                     ] 10
                    , Run Wireless "wlp2s0" [ "-t", "Wifi: <essid> <quality>", "-S", "true", "-p", "3"
                                            , "-L", "20", "-H", "70"
                                            , "-n", "red", "-h", "green", "-n", "yellow"
                                            ] 10
                    , Run Volume "default" "Master" [ "-t", "Vol: <status>", "-S", "true", "-p", "3"
                                                    , "-H", "70", "-L", "25"
                                                    , "-h", "red", "-l", "green", "-n", "yellow"
                                                    , "--", "-O", "<volume>", "-o", "****"
                                                    ] 10
                    , Run Date "%A %d/%m W:%V %R" "date" 10
                    , Run StdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% } <fc=#f536e8>%date%</fc> {  %cpu% | %memory% | %wlp2s0wi% | %bright% | %default:Master% | %battery% "
       }
