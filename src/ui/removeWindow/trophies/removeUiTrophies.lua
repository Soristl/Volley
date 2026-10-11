function clubhouse.closeProfile(name, skipRestore)
  if not uiState.profileState[name] and not uiState.isOpenProfile[name] and #(uiState.playerAchievementsImages[name] or {})==0 then return end
  clubhouse.clear(name, "profile")
  uiState.isOpenProfile[name] = false

  -- Profile and trophy text areas are all owned by the profile view.
  uiState.profileState[name] = nil

  for i = 1, #(uiState.playerAchievementsImages[name] or {}) do
    tfm.exec.removeImage(uiState.playerAchievementsImages[name][i])
  end

  uiState.playerAchievementsImages[name] = {}
  if not skipRestore then clubhouse.restoreLobbyControls(name) end
end
