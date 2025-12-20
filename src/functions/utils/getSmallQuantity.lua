function getSmallQuantity(quantity)
  local quantityNumbers = {quantity.yellow, quantity.red, quantity.blue, quantity.green}

  if gameStats.threeTeamsMode then
    quantityNumbers = {quantity.red, quantity.blue, quantity.green}
  end

  local smallNumber = 9999
  local index = 0
  for i = 1, #quantityNumbers do
    if quantityNumbers[i] < smallNumber and quantityNumbers[i] > 0 then
      smallNumber = quantityNumbers[i]
      index = i
    end
  end

  local smallQuantity = {[1] = smallNumber, [2] = index}
  return smallQuantity
end