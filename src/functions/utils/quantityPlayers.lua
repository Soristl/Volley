function quantityPlayers()
  local counts={red=0,blue=0}
  if gameStats.teamsMode or gameStats.threeTeamsMode then counts.yellow,counts.green=0,0 end
  local rosters=gameTeams.rosters()
  for _,key in ipairs(gameTeams.keys()) do counts[key]=gameTeams.count(rosters[key]) end
  return counts
end
