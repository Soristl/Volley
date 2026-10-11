function gameTeams.countRoles(team)
  local quantity = { middle = 0, back = 0 }

  if team == "red" then
    for i = 1, #gameState.teams.red do
      if gameState.teams.red[i].name ~= '' then
        if gameState.teamLayout.roles.red[i] == "middle" then
          quantity.middle = quantity.middle + 1
        elseif gameState.teamLayout.roles.red[i] == "back" then
          quantity.back = quantity.back + 1
        end
      end
    end

    return quantity
  end

  for i = 1, #gameState.teams.blue do
    if gameState.teams.blue[i].name ~= '' then
      if gameState.teamLayout.roles.blue[i] == "middle" then
        quantity.middle = quantity.middle + 1
      elseif gameState.teamLayout.roles.blue[i] == "back" then
        quantity.back = quantity.back + 1
      end
    end
  end

  return quantity
end
