function buttonNextOrPrev(id, name, x, y, width, height, alpha, text)
  id = tostring(id)
  ui.addTextArea(id .. "0000000000", "", name, x + 8, y + height - 22, width - 16, 13, 0x7a8d93, 0x7a8d93, alpha, true)
  ui.addTextArea(id .. "00000000000", "", name, x + 9, y + height - 21, width - 16, 13, 0xe1619, 0xe1619, alpha, true)
  ui.addTextArea(id .. "000000000000", "", name, x + 9, y + height - 21, width - 17, 12, 0x314e57, 0x314e57, alpha, true)
  ui.addTextArea(id .. "0000000000000", text, name, x + 9, y + height - 24, width - 17, nil, 0x314e57, 0x314e57, 0, true)
end
