function closeWindow(id, name)
  local id = tostring(id)
  local str = "0"
  ui.removeTextArea(id, name)
  for i = 1, 9 do
    ui.removeTextArea(id .. "" .. str .. "", name)
    str = "" .. str .. "0"
  end
end
