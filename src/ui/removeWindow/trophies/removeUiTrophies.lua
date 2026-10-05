function removeUITrophies(name, skipRestore)
  if not profileState[name] and not isOpenProfile[name] and #(playerAchievementsImages[name] or {})==0 then return end
  clubhouse.clear(name, "profile")
  isOpenProfile[name] = false

  -- Profile and trophy text areas are all owned by the profile view.
  profileState[name] = nil

  for i = 1, #(playerAchievementsImages[name] or {}) do
    tfm.exec.removeImage(playerAchievementsImages[name][i])
  end

  playerAchievementsImages[name] = {}
  if not skipRestore then clubhouse.restoreLobbyControls(name) end
end
