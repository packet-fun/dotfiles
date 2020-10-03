import XMonad

import qualified XMonad.StackSet as W

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

import Data.Monoid

myTerminal           = "alacritty"
myBorderWidth        = 5
myNormalBorderColor  = "#1E1E1E"
myFocusedBorderColor = "#AAAAAA"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

myLayout = avoidStruts $ smartBorders $ smartSpacingWithEdge 8 $ tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 3/5

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

-- xmobar

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
    where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
               $ ["dev", "www", "chat", "game", "music", "misc"]
    where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

---
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll

    [ title =? "qutebrowser"    --> doShift ( myWorkspaces !! 1 )
    , className =? "discord"    --> doShift ( myWorkspaces !! 2 )
    ]
--

myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom &"
---

main = do
    xmproc0 <- spawnPipe "xmobar -x 0 /home/www/.config/xmobar/xmobarrc"
    --xmproc1 <- spawnPipe "xmobar -x 1 /home/www/.config/xmobar/xmobarrc"

    xmonad $ docks $ defaultConfig
        { manageHook       = manageDocks <+> manageHook defaultConfig <+> myManageHook,
        workspaces         = myWorkspaces,
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        layoutHook         = myLayout,
        logHook            = dynamicLogWithPP xmobarPP
                               { ppOutput = hPutStrLn xmproc0
                               , ppCurrent = xmobarColor "#FF5555" "" . wrap "[ " " ]" -- Current workspace in xmobar
                               , ppVisible = xmobarColor "#b3afc2" ""                -- Visible but not current workspace
                               , ppHidden = xmobarColor "#f07178" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                               , ppHiddenNoWindows = xmobarColor "#b3afc2" ""        -- Hidden workspaces (no windows)
                               , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
                               , ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"                     -- Separators in xmobar
                               --, ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
                               , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                               , ppExtras  = [windowCount]                           -- # of windows current workspace
                               , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                               },
        modMask            = mod4Mask,     -- Rebind Mod to the Windows key
        startupHook        = myStartupHook
        } `additionalKeys`
          [ ((mod4Mask,               xK_p     ), spawn "exe=`dmenu_path | dmenu -fn 'xos4 Terminus' -sb '#f07178'` && eval \"exec $exe\"")
          , ((0,                      xK_Print ), spawn "scrot ss/screen_%Y-%m-%d-%H-%M-%S.png -q100 -e 'xclip -selection clipboard -target image/png -i $f'")
          , ((mod1Mask,               xK_Print ), spawn "scrot ss/window_%Y-%m-%d-%H-%M-%S.png -q100 -u -e 'xclip -selection clipboard -target image/png -i $f'")
          , ((mod4Mask .|. shiftMask, xK_s     ), spawn "sleep 0.2 && scrot ss/selection_%Y-%m-%d-%H-%M-%S.png -q100 -a $(slop -f '%x,%y,%w,%h') -e 'xclip -selection clipboard -target image/png -i $f'")
          ]
