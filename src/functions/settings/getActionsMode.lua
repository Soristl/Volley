function clubhouse.modeActions()
  local modes = roomConfig.modeNames()

  for i = 1, #modes do
    if roomConfig.settings.mode == modes[i] then
      modes[i] = "<j>" .. modes[i] .. "<n>"
    else
      modes[i] = "<a href='event:setMode" .. i .. "'>" .. modes[i] .. "</a>"
    end
  end

  return modes
end
