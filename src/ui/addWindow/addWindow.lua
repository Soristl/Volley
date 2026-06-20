function ui.addWindow(id, text, player, x, y, width, height, alpha, corners, closeButton, buttonText, showCornerImage)
  id = tostring(id)
  ui.addTextArea(id .. "0", "", player, x + 1, y + 1, width - 2, height - 2, 0x8a583c, 0x8a583c, alpha, true)
  ui.addTextArea(id .. "00", "", player, x + 3, y + 3, width - 6, height - 6, 0x2b1f19, 0x2b1f19, alpha, true)
  ui.addTextArea(id .. "000", "", player, x + 4, y + 4, width - 8, height - 8, 0xc191c, 0xc191c, alpha, true)
  ui.addTextArea(id .. "0000", "", player, x + 5, y + 5, width - 10, height - 10, 0x2d5a61, 0x2d5a61, alpha, true)
  ui.addTextArea(id .. "00000", text, player, x + 5, y + 6, width - 10, height - 12, 0x142b2e, 0x142b2e, alpha, true)
  local imageId = {}

  if corners then
    if showCornerImage[1] == true then
      table.insert(imageId, tfm.exec.addImage("155cbe97a3f.png", "&1", x - 7, (y + height) - 22, player))
    end

    if showCornerImage[2] == true then
      table.insert(imageId, tfm.exec.addImage("155cbe99c72.png", "&1", x - 7, y - 7, player))
    end

    if showCornerImage[3] == true then
      table.insert(imageId, tfm.exec.addImage("155cbe9bc9b.png", "&1", (x + width) - 20, (y + height) - 22, player))
    end

    if showCornerImage[4] == true then
      table.insert(imageId, tfm.exec.addImage("155cbea943a.png", "&1", (x + width) - 20, y - 7, player))
    end
  end

  if closeButton then
    ui.addTextArea(id .. "000000", "", player, x + 8, y + height - 22, width - 16, 13, 0x7a8d93, 0x7a8d93, alpha, true)
    ui.addTextArea(id .. "0000000", "", player, x + 9, y + height - 21, width - 16, 13, 0xe1619, 0xe1619, alpha, true)
    ui.addTextArea(id .. "00000000", "", player, x + 9, y + height - 21, width - 17, 12, 0x314e57, 0x314e57, alpha, true)
    ui.addTextArea(id .. "", buttonText, player, x + 9, y + height - 24, width - 17, nil, 0x314e57, 0x314e57, 0, true)
  end

  return imageId
end
