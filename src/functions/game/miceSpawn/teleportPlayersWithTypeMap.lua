function teleportPlayersWithTypeMap(islargeMode)
  teleportPlayersToSpec()

  local sideToTeleport = {}
  local teleportX = {}
  local teamsToTeleport = {teamsLifes[1].yellow, teamsLifes[2].red, teamsLifes[3].blue, teamsLifes[4].green}
  local teamsPlayers = {playersYellow, playersRed, playersBlue, playersGreen}
  local teamsColors = {0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267}
  local spawnTeleport = { playersSpawn400, playersSpawn800, playersSpawn1200 }

  if islargeMode then
    sideToTeleport = { true, true, true }
    if gameStats.threeTeamsMode then
      teleportX = { 300, 900 }
    else
      teleportX = { 200, 600, 1000 }
    end
    
    messageTeamsLifes = {}
    messageTeamsLostOneLife = {}
    messageTeamsLifesTextChat = {}
    messageWinners = {}
  else
    teamsPlayers = {}
    sideToTeleport = { true, true }
    teleportX = { 200, 600 }
    teamsToTeleport = {getTeamsLifes[1], getTeamsLifes[2]}
    for i = 1, #teamsPlayersOnGame do
      teamsPlayers[#teamsPlayers + 1] = teamsPlayersOnGame[i]
    end
  end

  local teamsColorsText = {"<j>", "<r>", "<bv>", "<vp>"}
  local mapCoords = {gameStats.yellowX, gameStats.redX, gameStats.blueX, gameStats.greenX}
  local mapCoordsX = {399, 799, 801}
  local messageLostAllLifes = {"<j>Yellow team lost all their lives<n>", "<r>Red team lost all their lives<n>", "<bv>Blue team lost all their lives<n>", "<vp>Green team lost all their lives<n>"}
  local messageLostOneLife = {"<j>Yellow team lost a life<n>", "<r>Red team lost a life<n>", "<bv>Blue team lost a life<n>", "<vp>Green team lost a life<n>"}
  local messageTeamsLifesText = {"<j>Team Yellow<n>", "<r>Team Red<n>", "<bv>Team Blue<n>", "<vp>Team Green<n>"}
  local messageWinnersText = {"<j>Team Yellow won!<n>", "<r>Team Red won!<n>", "<bv>Team Blue won!<n>", "<vp>Team Green won!<n>"}

  if gameStats.threeTeamsMode then
    teamsToTeleport = {teamsLifes[2].red, teamsLifes[3].blue, teamsLifes[4].green}
    teamsPlayers = {playersRed, playersBlue, playersGreen}
    teamsColors = {0xEF4444, 0x3B82F6, 0x109267}
    spawnTeleport = {playersSpawn400, playersSpawn800 }

    teamsColorsText = {"<r>", "<bv>", "<vp>"}
    mapCoords = {gameStats.redX, gameStats.blueX, gameStats.greenX}
    mapCoordsX = {599, 601}
    messageLostAllLifes = {"<r>Red team lost all their lives<n>", "<bv>Blue team lost all their lives<n>", "<vp>Green team lost all their lives<n>"}
    messageLostOneLife = {"<r>Red team lost a life<n>", "<bv>Blue team lost a life<n>", "<vp>Green team lost a life<n>"}
    messageTeamsLifesText = {"<r>Team Red<n>", "<bv>Team Blue<n>", "<vp>Team Green<n>"}
    messageWinnersText = {"<r>Team Red won!<n>", "<bv>Team Blue won!<n>", "<vp>Team Green won!<n>"}
  end

  mapCoordsTeams = {}
  getTeamsLifes = {}

  if gameStats.typeMap == "large3v3" or gameStats.typeMap == "small" then
    for i = 1, #teamsToTeleport do
      if teamsToTeleport[i] >= 1 then
        if gameStats.typeMap == "large3v3" then
          teamsPlayersOnGame[#teamsPlayersOnGame + 1] = teamsPlayers[i]
          getTeamsColors[#getTeamsColors + 1] = teamsColorsText[i]
          messageTeamsLifes[#messageTeamsLifes + 1] = messageLostAllLifes[i]
          messageTeamsLostOneLife[#messageTeamsLostOneLife + 1] = messageLostOneLife[i]
          messageTeamsLifesTextChat[#messageTeamsLifesTextChat + 1] = messageTeamsLifesText[i]
          messageWinners[#messageWinners + 1] = messageWinnersText[i]
        end
        getTeamsLifes[#getTeamsLifes + 1] = teamsToTeleport[i]
        for j = 1, #sideToTeleport do
          mapCoords[i] = mapCoordsX[j]
          mapCoordsTeams[#mapCoordsTeams + 1] = mapCoords[i]
          if sideToTeleport[j] then
            sideToTeleport[j] = false
            for h = 1, #teamsPlayers[i] do
              if teamsPlayers[i][h].name ~= '' then
                if #spawnTeleport[j] > 0 then
                  teleportPlayerWithSpecificSpawn(spawnTeleport[j], teamsPlayers[i][h].name)
                else
                  tfm.exec.movePlayer(teamsPlayers[i][h].name, teleportX[j], 334)
                end
                
                if gameStats.typeMap == "large3v3" then
                  tfm.exec.setNameColor(teamsPlayers[i][h].name, teamsColors[i])
                else
                  tfm.exec.setNameColor(teamsPlayers[i][h].name, getTeamsColorsName[i])
                end
                
              end
            end
            break
          end
        end
      end
    end
  end
end