function configSelectMap()
  local maps
  
  if gameStats.realMode then
    return {}
  end

  if gameStats.threeTeamsMode then
    maps = customMapsThreeTeamsMode

    return maps
  end
  
  if gameStats.teamsMode or gameStats.twoTeamsMode then
    maps = customMapsFourTeamsMode
    return maps
  end
  
  maps = customMaps
  
  return maps
end