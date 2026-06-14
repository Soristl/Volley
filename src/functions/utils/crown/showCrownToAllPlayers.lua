function showCrownToAllPlayers()
  local crowns = { redCrown, blueCrown, greenCrown, yellowCrown }
  local teams = { playersRed, playersBlue, playersGreen, playersYellow }

  for j = 1, #teams do
    for i = 1, #teams[j] do
      local player = teams[j][i].name

      if player ~= '' and playerInGame[player] then
        for i = 1, 10 do
          if rankCrown[i] ~= nil then
            if rankCrown[i].name == player then
              for name1, data in pairs(tfm.get.room.playerList) do
                if showCrownImages[name1] then
                  tfm.exec.addImage(crowns[j][i], "$" .. player, -20, -135, name1)
                end
              end
              break
            end
          end
        end
      end
    end
  end
end
