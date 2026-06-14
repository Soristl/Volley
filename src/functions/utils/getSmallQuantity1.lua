function getSmallQuantity1(quantity)
  local smallNumber = 9999
  local index = 0

  for i = 1, #quantity do
    if quantity[i] < smallNumber and quantity[i] > 0 then
      smallNumber = quantity[i]
      index = i
    end
  end

  local smallQuantity = { [1] = smallNumber, [2] = index }
  return smallQuantity
end
