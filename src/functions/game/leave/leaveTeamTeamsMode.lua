function gameTeams.leaveMulti(name)
  playerState.inGame[name] = false
  tfm.exec.setNameColor(name, 0xD1D5DB)

  gameTeams.removeMultiMember(name)
end
