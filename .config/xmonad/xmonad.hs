import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops (ewmh)
import qualified XMonad.Util.Brightness as Brightness
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.EZConfig
import XMonad.Util.Cursor
import System.Taffybar.Support.PagerHints (pagerHints)
import Packages

myConfig = def
    { modMask = mod4Mask
    , terminal = "alacritty"
    , borderWidth = 0
    , normalBorderColor = "#000000"
    , focusedBorderColor = "#ffff00"
    } `additionalKeysP`
    [ ("M-p", spawn $ rofi "/bin/rofi -show drun -show-icons")
    , ("M-S-p", spawn $ rofiPass "/bin/rofi-pass")
    -- , ("<XF86MonBrightnessDown>", Brightness.decrease)
    -- , ("<XF86MonBrightnessUp>", Brightness.increase)
    ]

main =
    xmonad .
    docks .
    ewmh .
    pagerHints $
    myConfig
    { startupHook = do
        setDefaultCursor xC_left_ptr
        spawnOnce "taffybar"
    , layoutHook = avoidStruts  $  layoutHook def
    }
