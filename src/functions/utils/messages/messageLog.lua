function roomConfig.logMessage(message)
  for name, data in pairs(tfm.get.room.playerList) do
    if roomConfig.permissions[name] and roomConfig.permissions[name] > 1 then
      tfm.exec.chatMessage(message, name)
    end
  end
end
