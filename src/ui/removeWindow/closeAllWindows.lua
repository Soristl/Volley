function closeAllWindows(name, keepLobbyHidden)
  clubhouse.clearPanels(name, true)
  openRank[name] = false
  selectMapOpen[name] = false
  selectMapPage[name] = 1
  selectBallOpen[name] = false
  selectBallPage[name] = 1
  -- Current panels own their image and textarea handles. clearPanels removes
  -- exactly those handles; legacy ID sweeps only waste host runtime.
  removeUITrophies(name, true)
  removeSelectUI(name)
  settings[name] = false
  settingsMode[name] = false

  closeRankingUI(name, true)
  -- Panel replacements keep the lobby hidden until the new panel is drawn.
  -- A real closure still restores the player's controls immediately.
  if not keepLobbyHidden then clubhouse.restoreLobbyControls(name) end
end
