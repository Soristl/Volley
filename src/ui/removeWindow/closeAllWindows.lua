function closeAllWindows(name)
  openRank[name] = false
  selectMapOpen[name] = false
  selectMapPage[name] = 1
  local ids = {21, 22, 24, 25, 44}
  for i=1, #ids do
    closeWindow(ids[i], name)
  end
  removeUITrophies(name)
  removeSelectUI(name)
  ui.removeTextArea(99992, name)
  closeWindow(266, name)
  removeButtons(25, name)
  removeButtons(26, name)
  removeButtons(27, name)
  settings[name] = false
  settingsMode[name] = false
  
  closeRankingUI(name)
end