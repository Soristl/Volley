function appendAchievementsImages(name, tableImages)
  for i = 1, #tableImages do
    playerAchievementsImages[name][#playerAchievementsImages[name] + 1] = tableImages[i]
  end
end
