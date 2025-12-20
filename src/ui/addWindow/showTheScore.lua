function showTheScore()
  if gameStats.realMode then
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 1150, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 1350, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(899899, "<p align='center'><font size='20px'><b><r>"..gameStats.redQuantitySpawn.."/"..gameStats.redLimitSpawn.."<n></b>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, true)
    ui.addTextArea(8998991, "<p align='center'><font size='20px'><b><bv>"..gameStats.blueQuantitySpawn.."/"..gameStats.blueLimitSpawn.."<n></b>", nil, 600, 20, 100, 100, 0x161616, 0x161616, 0, true)
    return
  end
  if gameStats.twoTeamsMode then
    ui.addTextArea(899899, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 550, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 950, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(8998991, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 1300, 20, 100, 100, 0x161616, 0x161616, 0, false)

    return
  end
  if gameStats.threeTeamsMode and gameStats.typeMap == "large4v4" then
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..teamsLifes[2].red.."<n>", nil, 350, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..teamsLifes[3].blue.."<n>", nil, 850, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(8998991, "<p align='center'><font size='40px'><vp>"..teamsLifes[4].green.."<n>", nil, 1350, 20, 100, 100, 0x161616, 0x161616, 0, false)

    return
  elseif gameStats.threeTeamsMode and gameStats.typeMap == "large3v3" then
    if getTeamsLifes[1] == nil or getTeamsLifes[2] == nil then
      return
    end
    if getTeamsColors[1] == nil or getTeamsColors[2] == nil then
      return
    end

    ui.removeTextArea(1)
    ui.removeTextArea(8998991)

    ui.addTextArea(899899, "<p align='center'><font size='40px'>"..getTeamsColors[1]..""..getTeamsLifes[1].."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(0, "<p align='center'><font size='40px'>"..getTeamsColors[2]..""..getTeamsLifes[2].."<n>", nil, 900, 20, 100, 100, 0x161616, 0x161616, 0, false)

    return
  end

  if gameStats.teamsMode and gameStats.typeMap == "large4v4" then
    ui.addTextArea(899899, "<p align='center'><font size='40px'><j>"..teamsLifes[1].yellow.."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..teamsLifes[2].red.."<n>", nil, 550, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..teamsLifes[3].blue.."<n>", nil, 950, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(8998991, "<p align='center'><font size='40px'><vp>"..teamsLifes[4].green.."<n>", nil, 1300, 20, 100, 100, 0x161616, 0x161616, 0, false)
    return
  end

  if gameStats.teamsMode and gameStats.typeMap == "large3v3" then
    if getTeamsLifes[1] == nil or getTeamsLifes[2] == nil or getTeamsLifes[3] == nil then
      return
    end
    if getTeamsColors[1] == nil or getTeamsColors[2] == nil or getTeamsColors[3] == nil then
      return
    end
    ui.addTextArea(899899, "<p align='center'><font size='40px'>"..getTeamsColors[1]..""..getTeamsLifes[1].."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(0, "<p align='center'><font size='40px'>"..getTeamsColors[2]..""..getTeamsLifes[2].."<n>", nil, 550, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'>"..getTeamsColors[3]..""..getTeamsLifes[3].."<n>", nil, 900, 20, 100, 100, 0x161616, 0x161616, 0, false)
    return
  end

  if gameStats.teamsMode and gameStats.typeMap == "small" then
    if getTeamsLifes[1] == nil or getTeamsLifes[2] == nil then
      return
    end
    if getTeamsColors[1] == nil or getTeamsColors[2] == nil then
      return
    end
    ui.addTextArea(0, "<p align='center'><font size='40px'>"..getTeamsColors[1]..""..getTeamsLifes[1].."<n>", nil, 0, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'>"..getTeamsColors[2]..""..getTeamsLifes[2].."<n>", nil, 700, 20, 100, 100, 0x161616, 0x161616, 0, false)
    return
  end

  if gameStats.gameMode == "3v3" then
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 0, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 700, 20, 100, 100, 0x161616, 0x161616, 0, false)
  elseif gameStats.gameMode == "4v4" then
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 900, 20, 100, 100, 0x161616, 0x161616, 0, false)
  else
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 1500, 20, 100, 100, 0x161616, 0x161616, 0, false)
  end
end