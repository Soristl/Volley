function getMaxPageMap(mapsList)
  local count = math.floor(#mapsList / 5)

  if #mapsList % 5 ~= 0 then
    count = count + 1
  end

  return count
end
