function roomConfig.applyAccessRules(config)
  config = config or roomConfig.readLobby()
  if not config then return false end
  roomConfig.statisticsCutoff = config.timestamp
  for user in pairs(config.bans) do
    playerState.banHistory[user] = "VOLLEY SYSTEM"
    playerState.ban[user] = true
  end
  for name, data in pairs(tfm.get.room.playerList) do
    if playerState.ban[name] or (roomConfig.statisticsCutoff ~= 0 and (data.registrationDate or 0) > roomConfig.statisticsCutoff) then
      tfm.exec.kickPlayer(name)
    end
  end
  return true
end
