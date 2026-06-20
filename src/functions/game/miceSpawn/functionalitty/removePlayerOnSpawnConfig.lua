function removePlayerOnSpawnConfig(name)
  for i = 1, #playersSpawn400 do
    for j = 1, #playersSpawn400[i].players do
      if playersSpawn400[i].players[j] == name then
        table.remove(playersSpawn400[i].players, j)

        return
      end
    end
  end

  for i = 1, #playersSpawn800 do
    for j = 1, #playersSpawn800[i].players do
      if playersSpawn800[i].players[j] == name then
        table.remove(playersSpawn800[i].players, j)

        return
      end
    end
  end

  for i = 1, #playersSpawn1200 do
    for j = 1, #playersSpawn1200[i].players do
      if playersSpawn1200[i].players[j] == name then
        table.remove(playersSpawn1200[i].players, j)

        return
      end
    end
  end

  for i = 1, #playersSpawn1600 do
    for j = 1, #playersSpawn1600[i].players do
      if playersSpawn1600[i].players[j] == name then
        table.remove(playersSpawn1600[i].players, j)

        return
      end
    end
  end
end
