function messageLog(message)
  for name, data in pairs(tfm.get.room.playerList) do
    if USER_PERMISSIONS[name] > 1 then
      tfm.exec.chatMessage(message, name)
    end
  end
end
