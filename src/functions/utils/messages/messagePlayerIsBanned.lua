function roomConfig.sendBanMessage(name)
  if playerState.ban[name] then
    tfm.exec.chatMessage("<bv>You do not have access to this action because you are banned from the room<n>", name)
    return true
  end
  return false
end
