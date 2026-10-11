function clubhouse.closeWindows(name, keepLobbyHidden)
  clubhouse.clearPanels(name, true)
  uiState.openRank[name] = false
  uiState.selectMapOpen[name] = false
  uiState.selectMapPage[name] = 1
  uiState.selectBallOpen[name] = false
  uiState.selectBallPage[name] = 1
  -- Current panels own their image and textarea handles. clearPanels removes
  -- exactly those handles; legacy ID sweeps only waste host runtime.
  clubhouse.closeProfile(name, true)
  clubhouse.clearSelectors(name)
  uiState.settings[name] = false
  uiState.settingsMode[name] = false

  clubhouse.closeRanking(name, true)
  -- Panel replacements keep the lobby hidden until the new panel is drawn.
  -- A real closure still restores the player's controls immediately.
  if not keepLobbyHidden then clubhouse.restoreLobbyControls(name) end
end
