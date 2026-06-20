function removePlayerTrophyImage(name)
  local removeImage = addTimer(function(i)
    if i == 1 then
      if playerTrophyImage[name] ~= 0 then
        tfm.exec.removeImage(playerTrophyImage[name])
        playerTrophyImage[name] = 0
      end
    end
  end, 10000, 1, "trophy" .. name .. "")
end
