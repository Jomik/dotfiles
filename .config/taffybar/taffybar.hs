{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad.Trans.Reader
import Linear.Vector (lerp)
import System.Taffybar
import System.Taffybar.Hooks
import System.Taffybar.Information.Battery
import System.Taffybar.Information.CPU
import System.Taffybar.Information.Memory
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.Generic.PollingLabel
import System.Taffybar.Widget.Generic.PollingBar
import System.Taffybar.Widget.Util
import System.Taffybar.Widget.Workspaces
import System.Log.Logger

transparent = (0.0, 0.0, 0.0, 0.0)
yellow1 = (0.9453125, 0.63671875, 0.2109375, 1.0)
yellow2 = (0.9921875, 0.796875, 0.32421875, 1.0)
green1 = (0, 1, 0, 1)
green2 = (1, 0, 1, 0.5)
taffyBlue = (0.129, 0.588, 0.953, 1)

myGraphConfig = defaultGraphConfig
    { graphPadding = 0
    , graphBorderWidth = 0
    , graphWidth = 75
    , graphBackgroundColor = transparent
    }

netCfg = myGraphConfig
    { graphDataColors = [yellow1, yellow2]
    , graphLabel = Just "net"
    }

memCfg = myGraphConfig
    { graphDataColors = [taffyBlue]
    , graphLabel = Just "mem"
    }

cpuCfg = myGraphConfig
    { graphDataColors = [green1, green2]
    , graphLabel = Just "cpu"
    }

memCallback :: IO [Double]
memCallback = do
    mi <- parseMeminfo
    return [memoryUsedRatio mi]

cpuCallback = do
    (_, systemLoad, totalLoad) <- cpuLoad
    return [totalLoad, systemLoad]

battCallback ctx = do
    pct <- batteryPercentage <$> runReaderT getDisplayBatteryInfo ctx
    return $ pct / 100

battCfg :: BarConfig
battCfg =
    defaultBarConfig $ toTriple . colorFunc
    where
        colorFunc :: Double -> [Double]
        colorFunc pct
            | pct < 0.5 = lerp (pct * 2) [0.9, 0.6, 0.2] [1, 0, 0]
            | pct == 0.5 = [0.9, 0.6, 0.2]
            | pct < 1 = lerp ((pct - 0.5) * 2) [0, 1, 0] [0.9, 0.6, 0.2]
            | otherwise = [0, 1, 0]
        toTriple :: [Double] -> (Double, Double, Double)
        toTriple rgb =
            case rgb of
                [r,g,b] -> (r, g, b)
                _ -> (0, 1, 0)

battWidget = do
    chan <- getDisplayBatteryChan
    ctx <- ask
    pollingBarNew battCfg 60 $ battCallback ctx

main = do
    let myWorkspacesConfig =
            defaultWorkspacesConfig
            { minIcons = 1
            , widgetGap = 0
            , showWorkspaceFn = hideEmpty
            }
        workspaces = workspacesNew myWorkspacesConfig
        cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
        mem = pollingGraphNew memCfg 1 memCallback
        net = networkGraphNew netCfg Nothing
        clock = textClockNew Nothing "%a %b %_d %X" 1
        layout = layoutNew defaultLayoutConfig
        windows = windowsNew defaultWindowsConfig
        myConfig =
            defaultSimpleTaffyConfig
            { startWidgets =
                workspaces : map (>>= buildContentsBox) [ layout, windows ]
            , centerWidgets = map (>>= buildContentsBox)
            [ clock
            ]
            , endWidgets = map (>>= buildContentsBox)
            [ battWidget
            , cpu
            , mem
            , net
            ]
            , barPosition = Top
            -- , barPadding = 0
            , barHeight = 40
            , widgetSpacing = 0
            }
    dyreTaffybar $
        withLogServer $
        withToggleServer $
        toTaffyConfig myConfig
