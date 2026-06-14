function commandNotAvailable(args)
  local command = args[1]
  local name = args[2]
  tfm.exec.chatMessage("<bv>The " .. command .. " is not available when the mode 4 teams is enabled<n>", name)
end
