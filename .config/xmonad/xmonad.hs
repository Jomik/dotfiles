import XMonad
import XMonad.Actions.Volume
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
    [ ("M-p", spawn $ rofi "rofi -show drun -show-icons")
    , ("M-S-p", spawn $ rofiPass "rofi-pass")
    , ("M-S-l", spawn $ slock "slock")
    , ("M-S-q", spawn $ powerMenu "power-menu")
    , ("<XF86MonBrightnessDown>", Brightness.decrease)
    , ("<XF86MonBrightnessUp>", Brightness.increase)
    , ("<XF86AudioLowerVolume>", lowerVolume 5 >> return ())
    , ("<XF86AudioRaiseVolume>", raiseVolume 5 >> return ())
    , ("<XF86AudioMute>", toggleMute >> return ())
    ]

main =
    xmonad .
    docks .
    ewmh $
    myConfig
    { layoutHook = avoidStruts . smartBorders $ layoutHook def
    }
