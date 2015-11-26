import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import System.IO

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ defaultConfig
        { terminal = "urxvt"
        , startupHook = setWMName "LG3D" -- For Intellij IDEA
        , manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "#f536e8" "" . shorten 50
            }
        , modMask = mod4Mask	-- Rebind Mod to the Windows key
        } `additionalKeysP` myKeys

myKeys =
  [ ("C-<Print>"              , spawn "sleep 0.2; maim -s -c 1,0,0,1")
  , ("<Print>"                , spawn "maim")
  , ("M-c"                    , spawn "chromium")
  , ("<XF86MonBrightnessDown>", light '-')
  , ("<XF86MonBrightnessUp>"  , light '+')
  , ("<XF86AudioLowerVolume>" , volume '-')
  , ("<XF86AudioRaiseVolume>" , volume '+')
  , ("<XF86AudioMute>", amixer "toggle")
  ]

light :: Char -> X ()
light modifier = spawn $ "light -" ++ (if modifier == '-' then "U" else "A")  ++ " 10"

amixer :: String -> X ()
amixer option = spawn $ "amixer set Master " ++ option ++ " -q"

volume :: Char -> X ()
volume modifier =  amixer $ "2%" ++ [modifier]
