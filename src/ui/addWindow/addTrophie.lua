function ui.addTrophie(id, event, player, playerTarget, x, y, width, height, alpha)
  local indexImage = tonumber(string.sub(event, 8))
  id = tostring(id)
  ui.addTextArea(id .. "0", "", player, x + 1, y + 1, width - 2, height - 2, 0x8a583c, 0x8a583c, alpha, true)
  ui.addTextArea(id .. "00", "", player, x + 3, y + 3, width - 6, height - 6, 0x2b1f19, 0x2b1f19, alpha, true)
  ui.addTextArea(id .. "000", "", player, x + 4, y + 4, width - 8, height - 8, 0xc191c, 0xc191c, alpha, true)
  ui.addTextArea(id .. "0000", "", player, x + 5, y + 5, width - 10, height - 10, 0x2d5a61, 0x2d5a61, alpha, true)
  ui.addTextArea(id .. "0000000", "", player, x + 5, y + 6, width - 10, height - 12, 0x142b2e, 0x142b2e, alpha, true)
  table.insert(playerAchievementsImages[player],
    tfm.exec.addImage(playerAchievements[playerTarget][indexImage].image, "~" .. id .. "0000000", x + 5, y + 7, player))
  ui.addTextArea(id .. "00000",
    "<p align='right'><font size='10px'><font color='#000000'>x" ..
    playerAchievements[playerTarget][indexImage].quantity .. "", player, x + 33, y + height - 16, 20, 15, 0x161616,
    0x161616, 0, true)
  ui.addTextArea(id .. "000000",
    "<p align='right'><font size='10px'>x" .. playerAchievements[playerTarget][indexImage].quantity .. "", player, x + 32,
    y + height - 17, 20, 15, 0x161616, 0x161616, 0, true)
  ui.addTextArea(id .. "00000000", "<a href='event:" .. event .. "'><font size='20px'><br> <br> </a>", player, x + 5, y +
    6, width, height, 0x142b2e, 0x142b2e, 0, true)
end
