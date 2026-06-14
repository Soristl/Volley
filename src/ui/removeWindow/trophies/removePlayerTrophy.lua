function removePlayerTrophy(name)
  if playerTrophyImage[name] ~= 0 then
    tfm.exec.removeImage(playerTrophyImage[name])
    playerTrophyImage[name] = 0
    removeTimer("trophy" .. name .. "")
  end
end
