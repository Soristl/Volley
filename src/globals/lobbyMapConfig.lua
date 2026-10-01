function lobbyMapConfig(config)
  config = config or readLobbyConfig()
  if not config then return false end
  timestamp = config.timestamp
  for user in pairs(config.bans) do
    playerBanHistory[user] = "VOLLEY SYSTEM"
    playerBan[user] = true
  end
  for name, data in pairs(tfm.get.room.playerList) do
    if playerBan[name] or (timestamp ~= 0 and (data.registrationDate or 0) > timestamp) then
      tfm.exec.kickPlayer(name)
    end
  end
  return true
end
