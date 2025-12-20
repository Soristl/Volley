function choosePlayerServe(team)
  print(team)
  gameStats.redServe = false
  gameStats.blueServe = false
  gameStats.lastPlayerRed = ""
  gameStats.lastPlayerBlue = ""

  if gameStats.aceRed then
    tfm.exec.movePlayer(gameStats.redPlayerServe, 700, 334)
    tfm.exec.chatMessage("<bv>"..gameStats.redPlayerServe.." will serve the ball<n>", nil)
    print("red condition ace")
    print("<bv>"..gameStats.redPlayerServe.." will serve the ball<n>")
    return chooseTeam
  end

  if gameStats.aceBlue then
    tfm.exec.movePlayer(gameStats.bluePlayerServe, 1900, 334)
    tfm.exec.chatMessage("<bv>"..gameStats.bluePlayerServe.." will serve the ball<n>", nil)
    print("blue condition ace")
    print("<bv>"..gameStats.bluePlayerServe.." will serve the ball<n>")
    return chooseTeam
  end


  if team == "red" then
    if gameStats.redServeIndex == 6 then
      for i = 1, 6 do
        if playersRed[i].name ~= "" then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          gameStats.aceRed = true
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
          gameStats.aceRed = true
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
          gameStats.aceRed = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    end
    gameStats.redServe = true
    gameStats.aceRed = true
  elseif team == "blue" then
    if gameStats.blueServeIndex == 6 then
      for i = 1, 6 do
        if playersBlue[i].name ~= "" then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          gameStats.aceBlue = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
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
          gameStats.aceBlue = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end

      for i = 1, gameStats.blueServeIndex do
        if playersBlue[i].name ~= "" then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          gameStats.aceBlue = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    end

    gameStats.blueServe = true
    gameStats.aceBlue = true
  end
end