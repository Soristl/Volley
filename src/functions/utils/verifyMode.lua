function verifyMode()
  if gameStats.teamsMode then
    return "4 teams mode"
  elseif gameStats.threeTeamsMode then
    return "3 teams mode"
  elseif gameStats.twoTeamsMode then
    return "2 teams mode"
  elseif gameStats.realMode then
    return "Real mode"
  else
    return "Normal mode"
  end
end