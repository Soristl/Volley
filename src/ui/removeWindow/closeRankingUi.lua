function clubhouse.closeRanking(name, skipRestore)
  if not uiState.rankingState[name] and not uiState.openRank[name] then return end
  clubhouse.clear(name, "ranking")
  uiState.rankingState[name] = nil
  uiState.openRank[name] = false
  if not skipRestore then clubhouse.restoreLobbyControls(name) end
end
