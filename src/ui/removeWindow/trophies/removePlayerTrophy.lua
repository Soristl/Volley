function clubhouse.removePlayerTrophy(name)
  timers.remove("trophy" .. name)
  local image = playerState.trophyImage[name]
  playerState.trophyImage[name] = 0
  if image and image ~= 0 then tfm.exec.removeImage(image) end
end
