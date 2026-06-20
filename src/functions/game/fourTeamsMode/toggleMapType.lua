function toggleMapType()
  if gameStats.typeMap == "large4v4" then
    gameStats.typeMap = "large3v3"
  elseif gameStats.typeMap == "large3v3" then
    gameStats.typeMap = "small"
  end
end
