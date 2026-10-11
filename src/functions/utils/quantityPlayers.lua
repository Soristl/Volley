function gameTeams.countsByTeam()
  local counts={red=0,blue=0}
  if gameState.match.mode.teamsMode or gameState.match.mode.threeTeamsMode then counts.yellow,counts.green=0,0 end
  local rosters=gameTeams.rosters()
  for _,key in ipairs(gameTeams.keys()) do counts[key]=gameTeams.count(rosters[key]) end
  return counts
end
