function removeUITrophies(name)
  isOpenProfile[name] = false

  local ids = { 26, 27, 28, 29, 32, 33 }
  for i = 1, #ids do
    closeWindow(ids[i], name)
  end

  for i = 1, #playerAchievementsImages[name] do
    tfm.exec.removeImage(playerAchievementsImages[name][i])
  end

  playerAchievementsImages[name] = {}
end
