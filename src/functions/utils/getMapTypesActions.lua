function clubhouse.mapTypeActions()
  local modes = roomConfig.mapTypeNames()

  for i = 1, #modes do
    if roomConfig.settings.mapType == string.lower(modes[i]) then
      modes[i] = "<j>" .. modes[i] .. "<n>"
    else
      modes[i] = "<a href='event:setMapType" .. i .. "'>" .. modes[i] .. "</a>"
    end
  end

  return modes
end
