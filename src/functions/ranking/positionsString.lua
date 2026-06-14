function positionsString(page)
  local positions = {}

  for i = 1, 10 do
    if i == 1 and page == 1 then
      positions[#positions + 1] = "<j>" .. tostring(i + (10 * (page - 1))) .. ".<n>"
    elseif i == 2 and page == 1 then
      positions[#positions + 1] = "<n2>" .. tostring(i + (10 * (page - 1))) .. ".<n>"
    elseif i == 3 and page == 1 then
      positions[#positions + 1] = "<ce>" .. tostring(i + (10 * (page - 1))) .. ".<n>"
    else
      positions[#positions + 1] = "<n>" .. tostring(i + (10 * (page - 1))) .. ".<n>"
    end
  end

  return positions
end
