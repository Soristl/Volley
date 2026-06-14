function getActionsModes()
  local modes = getModesText()

  for i = 1, #modes do
    if globalSettings.mode == modes[i] then
      modes[i] = "<j>" .. modes[i] .. "<n>"
    else
      modes[i] = "<a href='event:setMode" .. i .. "'>" .. modes[i] .. "</a>"
    end
  end

  return modes
end
