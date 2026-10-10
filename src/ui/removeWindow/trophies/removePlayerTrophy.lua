function removePlayerTrophy(name)
  removeTimer("trophy" .. name)
  local image = playerTrophyImage[name]
  playerTrophyImage[name] = 0
  if image and image ~= 0 then tfm.exec.removeImage(image) end
end
