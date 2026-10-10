function teleportPlayersToSpec(onlyDead)
  for name, data in pairs(tfm.get.room.playerList) do
    if playerInGame[name] == false and not playerBan[name] and not playerLeft[name]
      and (not onlyDead or data.isDead) then
      if killSpecPermanent then
        tfm.exec.killPlayer(name)
      else
        if data.isDead then tfm.exec.respawnPlayer(name) end
        teleportPlayersToSpecWithSpecificSpawn(name)
      end
    end
  end
end
