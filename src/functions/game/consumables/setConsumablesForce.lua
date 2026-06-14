function setConsumablesForce(key, playerMove)
  local speedX = 0
  local speedY = 0
  local yCoord = 0

  if key == 55 or key == 48 then
    yCoord = -65
    if playerMove == 0 then
      speedX = -10
    elseif playerMove == 2 then
      speedX = 10
    end
  elseif key == 57 then
    yCoord = -65
    speedY = -5

    if playerMove == 0 then
      speedX = -5
    elseif playerMove == 2 then
      speedX = 5
    end
  end
  return { speedX, speedY, yCoord }
end
