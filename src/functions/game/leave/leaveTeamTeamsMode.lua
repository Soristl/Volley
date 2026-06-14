function leaveTeamTeamsMode(name)
  playerInGame[name] = false
  tfm.exec.setNameColor(name, 0xD1D5DB)

  leaveTeamTeamsModeConfig(name)
end
