function showMessageWinner()
  if gameStats.teamsMode or gameStats.threeTeamsMode then
    ui.addTextArea(6, "<p align='center'><font size='30px'><textformat leading='150'><br>"..messageWinners[1].."", nil, 0, 0, 800, 400, 0x161616, 0x161616, 0.8, true)
    return
  end
  if score_red >= gameStats.winscore then
    for name, data in pairs(tfm.get.room.playerList) do
      ui.addTextArea(6, "<p align='center'><font size='30px'><textformat leading='150'><br><r>"..playerLanguage[name].tr.msgRedWinner.."<n>", nil, 0, 0, 800, 400, 0x161616, 0x161616, 0.8, true)
    end
  elseif score_blue >= gameStats.winscore then
    for name, data in pairs(tfm.get.room.playerList) do
      ui.addTextArea(6, "<p align='center'><font size='30px'><textformat leading='150'><br><bv>"..playerLanguage[name].tr.msgBlueWinner.."<n>", nil, 0, 0, 800, 400, 0x161616, 0x161616, 0.8, true)
    end
  end
end