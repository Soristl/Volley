function refletzSyncSystem()
  local lowestSync = 10000
  local bestPlayer = ""

  -- Should use the global copy, since the default tfm list
  -- can be outdated sometimes. @Vit0rg
  for n, data in pairs(tfm.get.room.playerList) do
    if data.averageLatency < lowestSync then
      lowestSync = data.averageLatency
      bestPlayer = n
    end
  end

  if bestPlayer ~= "" then
    tfm.exec.setPlayerSync(bestPlayer)
    tfm.exec.chatMessage("<j>[SYSTEM] Sync set to " .. bestPlayer, nil)
  end
end
