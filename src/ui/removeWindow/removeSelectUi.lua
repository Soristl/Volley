function removeSelectUI(name)
  local ids = { 99999, 999999, 9999999, 99999999, 999999999 }

  for i = 1, 5 do
    for j = 1, 5 do
      ui.removeTextArea("" .. tostring(ids[i]) .. "" .. j .. "", name)
    end
  end

  ui.removeTextArea(9999999999, name)

  for i = 1, #selectMapImages[name] do
    tfm.exec.removeImage(selectMapImages[name][i])
  end
end
