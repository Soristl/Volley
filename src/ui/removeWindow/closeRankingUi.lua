function closeRankingUI(name, skipRestore)
  if not rankingState[name] and not openRank[name] then return end
  clubhouse.clear(name, "ranking")
  rankingState[name] = nil
  openRank[name] = false
  if not skipRestore then clubhouse.restoreLobbyControls(name) end
end
