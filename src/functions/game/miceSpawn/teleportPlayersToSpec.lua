function gameTeams.placeSpectators(onlyDead)
  for name, data in pairs(tfm.get.room.playerList) do
    if playerState.inGame[name] == false and not playerState.ban[name] and not playerState.left[name]
      and (not onlyDead or data.isDead) then
      if roomConfig.killSpectators then
        tfm.exec.killPlayer(name)
      else
        if data.isDead then tfm.exec.respawnPlayer(name) end
        gameTeams.placeSpectator(name)
      end
    end
  end
end
