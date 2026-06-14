function removeButtons(id, name)
  local id = tostring(id)
  local str = "000000000"
  ui.removeTextArea(id, name)
  for i = 10, 14 do
    ui.removeTextArea(id .. "" .. str .. "", name)
    str = "" .. str .. "0"
  end
end
