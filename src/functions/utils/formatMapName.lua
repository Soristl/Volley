function formatMapName(map)
  if #map > 14 then
    return "" .. string.sub(map, 1, 10) .. "..."
  end

  return map
end
