function leaveTeam(name)
  playerInGame[name] = false
  tfm.exec.setNameColor(name, 0xD1D5DB)
  for i = 1, #playersRed do
    if playersRed[i].name == name then
      playersRed[i].name = ''
      twoTeamsPlayerRedPosition[i] = ""
      removePlayerOnSpawnConfig(name)
      leaveConfigRealMode(name)
      if killSpecPermanent then
        tfm.exec.killPlayer(name)
      else
        tfm.exec.killPlayer(name)

        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)

          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end
    end
    if playersBlue[i].name == name then
      playersBlue[i].name = ''
      twoTeamsPlayerBluePosition[i] = ""
      removePlayerOnSpawnConfig(name)
      leaveConfigRealMode(name)
      if killSpecPermanent then
        tfm.exec.killPlayer(name)
      else
        tfm.exec.killPlayer(name)

        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)

          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end
    end
  end
end
