function getQuantityPlayers()
  local quantity = {yellow = 0, red = 0, blue = 0, green = 0}
  if gameStats.typeMap == "large4v4" then
    if gameStats.teamsMode then
      for i = 1, #playersYellow do
        if playersYellow[i].name ~= "" then
          quantity.yellow = quantity.yellow + 1
        end
      end
    end
    for i = 1, #playersRed do
      if playersRed[i].name ~= "" then
        quantity.red = quantity.red + 1
      end
    end
    for i = 1, #playersBlue do
      if playersBlue[i].name ~= "" then
        quantity.blue = quantity.blue + 1
      end
    end
    for i = 1, #playersGreen do
      if playersGreen[i].name ~= "" then
        quantity.green = quantity.green + 1
      end
    end
    
    return quantity
  elseif gameStats.typeMap ~= "large4v4" then
    local quantity = {}
    local count = 0
    for i = 1, #teamsPlayersOnGame do
      for j = 1, #teamsPlayersOnGame[i] do
        if teamsPlayersOnGame[i][j].name ~= '' then
          count = count + 1
        end
      end
      if count > 0 then
        quantity[#quantity + 1] = count
      end
      
      count = 0
    end
    return quantity
  end
end