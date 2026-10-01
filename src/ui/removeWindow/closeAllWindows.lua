function closeAllWindows(name)
  clubhouse.clearPanels(name)
  openRank[name] = false
  selectMapOpen[name] = false
  selectMapPage[name] = 1
  selectBallOpen[name] = false
  selectBallPage[name] = 1
  -- Current panels own their image and textarea handles. clearPanels removes
  -- exactly those handles; legacy ID sweeps only waste host runtime.
  removeUITrophies(name)
  removeSelectUI(name)
  settings[name] = false
  settingsMode[name] = false

  closeRankingUI(name)
end
