function messageLog(message)
  for name, data in pairs(tfm.get.room.playerList) do
    if admins[name] then
      tfm.exec.chatMessage(message, name)
    end
  end
end
