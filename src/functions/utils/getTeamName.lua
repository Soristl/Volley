function getTeamName(text)
  if string.sub(text, 1, 9) == "<j>Yellow" then
    return "Yellow"
  elseif string.sub(text, 1, 6) == "<r>Red" then
    return "Red"
  elseif string.sub(text, 1, 8) == "<bv>Blue" then
    return "Blue"
  elseif string.sub(text, 1, 9) == "<vp>Green" then
    return "Green"
  end
end
