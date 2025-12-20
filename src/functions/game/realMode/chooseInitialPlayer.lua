function chooseInitialPlayer()
  local teams = {"red", "blue"}

  local chooseTeam = teams[math.random(1, #teams)]

  if chooseTeam == "red" then
    gameStats.redServeIndex = math.random(1, 6)
    if gameStats.redServeIndex == 6 then
      for i = 1, 6 do
        if playersRed[i].name ~= "" then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    else
      for i = gameStats.redServeIndex, 6 do
        if playersRed[i].name ~= "" and gameStats.redServeIndex ~= i then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end

      for i = 1, gameStats.redServeIndex do
        if playersRed[i].name ~= "" then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    end
    gameStats.redServe = true
  elseif chooseTeam == "blue" then
    gameStats.blueServeIndex = math.random(1, 6)
    if gameStats.blueServeIndex == 6 then
      for i = 1, 6 do
        if playersBlue[i].name ~= "" then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          tfm.exec.movePlayer(playersBlue[i], name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    else
      for i = gameStats.blueServeIndex, 6 do
        if playersBlue[i].name ~= "" and gameStats.blueServeIndex ~= i then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end

      for i = 1, gameStats.redServeIndex do
        if playersBlue[i].name ~= "" and gameStats.blueServeIndex ~= i then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    end
    gameStats.blueServe = true
  end

  return chooseTeam

end