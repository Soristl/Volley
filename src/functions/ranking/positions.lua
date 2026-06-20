function positions(page)
  local positions = {}

  for i = 1, 10 do
    positions[#positions + 1] = i
  end

  return positions
end
