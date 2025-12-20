function quantityPlayers()
  local quantity = {red = 0, blue = 0}
  if gameStats.teamsMode then
    quantity = {red = 0, blue = 0, yellow = 0, green = 0}
  end

  if gameStats.threeTeamsMode then
    quantity = {red = 0, blue = 0, yellow = 0, green = 0}
  end

  for i = 1, #playersRed do
    if playersRed[i].name ~= '' then
      quantity.red = quantity.red + 1
    end
  end
  for i = 1, #playersBlue do
    if playersBlue[i].name ~= '' then
      quantity.blue = quantity.blue + 1
    end
  end

  if gameStats.threeTeamsMode then
    for i = 1, #playersGreen do
      if playersGreen[i].name ~= '' then
        quantity.green = quantity.green + 1
      end
    end
  end

  if gameStats.teamsMode then
    for i = 1, #playersYellow do
      if playersYellow[i].name ~= '' then
        quantity.yellow = quantity.yellow + 1
      end
    end
    for i = 1, #playersGreen do
      if playersGreen[i].name ~= '' then
        quantity.green = quantity.green + 1
      end
    end
  end

  return quantity
end