function profileUI(name, playerTarget)
  isOpenProfile[name] = true
  local images3 = ui.addWindow(26, "<textformat leading='55'><br>" .. playerLanguage[name].tr.msgAchievements .. "", name,
    217, 120, 470, 240, 1, true, true, playerLanguage[name].tr.closeUIText, { true, false, true, false })
  local images1 = ui.addWindow(24,
    "<p align='center'><font size='16px'><textformat leading='-10'><br><v>" ..
    string.sub(playerTarget, 1, #playerTarget - 5) .. "<n><bl>" .. string.sub(playerTarget, #playerTarget - 4) .. "<n>",
    name, 300, 105, 400, 50, 1, true, false, "", { false, false, true, true })
  local images2 = ui.addWindow(25, "<p align='center'><font size='30px'><textformat leading='-10'><br><j>#1<n>", name,
    200, 80, 100, 100, 1, true, false, "", { true, true, true, true })
  ui.addTrophie(27, "trophie1", name, playerTarget, 230, 230, 50, 50, 1)
  ui.addTrophie(28, "trophie2", name, playerTarget, 295, 230, 50, 50, 1)
  ui.addTrophie(29, "trophie3", name, playerTarget, 355, 230, 50, 50, 1)
  ui.addTrophie(32, "trophie4", name, playerTarget, 420, 230, 50, 50, 1)
  ui.addTrophie(33, "trophie5", name, playerTarget, 485, 230, 50, 50, 1)

  appendAchievementsImages(name, images1)
  appendAchievementsImages(name, images2)
  appendAchievementsImages(name, images3)
end
