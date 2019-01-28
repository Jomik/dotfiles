import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Layout.NoBorders (smartBorders)
import qualified XMonad.Util.Brightness as Brightness
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.EZConfig
import XMonad.Util.Cursor
import Packages

myConfig = def
    { modMask = mod4Mask
    , terminal = "alacritty"
    , borderWidth = 1
    , normalBorderColor = "#000000"
    , focusedBorderColor = "#ffff00"
    } `additionalKeysP`
    [ ("M-p", spawn $ rofi "/bin/rofi -show drun -show-icons")
    , ("M-S-p", spawn $ rofiPass "/bin/rofi-pass")
    , ("<XF86MonBrightnessDown>", Brightness.decrease)
    , ("<XF86MonBrightnessUp>", Brightness.increase)
    ]

main =
    xmonad .
    docks .
    ewmh $
    myConfig
    { layoutHook = avoidStruts . smartBorders $ layoutHook def
    }
