function getQuantityPlayersOnPosition(team)
  local quantity = { middle = 0, back = 0 }

  if team == "red" then
    for i = 1, #gameState.teams.red do
      if gameState.teams.red[i].name ~= '' then
        if twoTeamsPlayerRedPosition[i] == "middle" then
          quantity.middle = quantity.middle + 1
        elseif twoTeamsPlayerRedPosition[i] == "back" then
          quantity.back = quantity.back + 1
        end
      end
    end

    return quantity
  end

  for i = 1, #gameState.teams.blue do
    if gameState.teams.blue[i].name ~= '' then
      if twoTeamsPlayerBluePosition[i] == "middle" then
        quantity.middle = quantity.middle + 1
      elseif twoTeamsPlayerBluePosition[i] == "back" then
        quantity.back = quantity.back + 1
      end
    end
  end

  return quantity
end
