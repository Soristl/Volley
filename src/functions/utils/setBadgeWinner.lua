function setBadgeWinner(badge, badgeGrayscale, playersWinner)
  local playersBadgeWinners = {"Jenji#1475", "Ramasevosaff#0000", "Rex#2654", "Raidensnd#0000", "Mulan#5042", "Basker#2338", "Ppoppohaejuseyo#2315", "Djadja#5590", "Lightning#7523", "Nkmk#3180", "Sfjoud#8638", "Raf02#4942", "Axeldoton#0000", "Badmice9#0000", "Nagi#6356"}
  
  for i = 1, #playersWinner do
    if playerAchievements[playersWinner[i].player] == nil then
      playerAchievements[playersWinner[i].player] = {}
    end

    local arrayLength = #playerAchievements[playersWinner[i].player]
    playerAchievements[playersWinner[i].player][arrayLength + 1] = { image = badge, quantity = playersWinner[i].quantity}

    for j = 1, #playersBadgeWinners do
      if playersWinner[i].player == playersBadgeWinners[j] then
        table.remove(playersBadgeWinners, j)

        break
      end
    end
  end

  for i = 1, #playersBadgeWinners do
    if playerAchievements[playersBadgeWinners[i]] == nil then
      playerAchievements[playersBadgeWinners[i]] = {}
    end
    
    local arrayLength = #playerAchievements[playersBadgeWinners[i]]
    playerAchievements[playersBadgeWinners[i]][arrayLength + 1] = { image = badgeGrayscale, quantity = 0 }
  end
end

setBadgeWinner("img@193d675bca7", "img@193d6763c82", { { player = "Jenji#1475", quantity = 1 }, { player = "Ramasevosaff#0000", quantity = 1 }, { player = "Rex#2654", quantity = 1 }, { player = "Raidensnd#0000", quantity = 1 }, { player = "Mulan#5042", quantity = 1 }, { player = "Basker#2338", quantity = 1 }, { player = "Axeldoton#0000", quantity = 1 }, { player = "Badmice9#0000", quantity = 1 }, { player = "Nagi#6356", quantity = 1 } })
setBadgeWinner("19636905a3c.png", "19636907e9e.png", { { player = "Mulan#5042", quantity = 1 }, { player = "Ppoppohaejuseyo#2315", quantity = 1 }, { player = "Djadja#5590", quantity = 1 } })
setBadgeWinner("197d9274460.png", "197d9272515.png", { { player = "Jenji#1475", quantity = 1 }, { player = "Ramasevosaff#0000", quantity = 1 }, { player = "Lightning#7523", quantity = 1 }, { player = "Nkmk#3180", quantity = 1 } })
setBadgeWinner("1984ac7a614.png", "1984ac78d52.png", { { player = "Sfjoud#8638", quantity = 1 }, { player = "Raf02#4942", quantity = 1 } })
setBadgeWinner("1984ac7c1ac.png", "1984ac773d3.png", { { player = "Sfjoud#8638", quantity = 1 }, { player = "Raf02#4942", quantity = 1 } })
