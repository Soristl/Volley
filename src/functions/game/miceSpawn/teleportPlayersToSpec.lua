function teleportPlayersToSpec()
  for name, data in pairs(tfm.get.room.playerList) do
    if playerInGame[name] == false then
      print(killSpecPermanent)
      if killSpecPermanent then
        tfm.exec.killPlayer(name)
      else
        teleportPlayersToSpecWithSpecificSpawn(name)
      end
    end
  end
end
