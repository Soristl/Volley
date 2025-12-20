function showMode(mode, name)
  removeUITrophies(name)
  if mode ~= "4 teams mode" then
    ui.removeTextArea(9999564, name)
    ui.removeTextArea(9999565, name)
  end
  
  local rank = rankMode(mode)
  local page = rankPageMode(mode, name)
  
  local y = 137
  local colorBackground = 0x2d5a61
  local indexPositions = positionsString(page)
  local namesRank = ""
  local matchesRank = ""
  local winsRank = ""
  local winRatioRank = ""
  local winsRed = ""
  local winsBlue = ""
  local winsYellow = ""
  local winsGreen = ""
  
  for i = 9999554, 9999563 do
    local index = (i - 9999553) + (10 * (page - 1))
    
    if rank[index] ~= nil then
      local winRatioString = tostring(rank[index].winRatio)
      
      ui.addTextArea(i, "", name, 135, y, 630, 6, colorBackground, colorBackground, 1, true)
      
      if page == 1 and index == 1 then
        namesRank = ""..namesRank.."<br>"..indexPositions[(i - 9999553)].." <cs>"..string.sub(rank[index].name, 1, #rank[index].name - 5).."<n><bl>"..string.sub(rank[index].name, #rank[index].name - 4).."<n>"
      else
        namesRank = ""..namesRank.."<br>"..indexPositions[(i - 9999553)].." "..string.sub(rank[index].name, 1, #rank[index].name - 5).."<bl>"..string.sub(rank[index].name, #rank[index].name - 4).."<n>"
      end
      matchesRank = ""..matchesRank.."<br>"..rank[index].matches..""
      winsRank = ""..winsRank.."<br>"..rank[index].wins..""
      winRatioRank = ""..winRatioRank.."<br>"..string.sub(winRatioString, 1, 4).."%"
      winsRed = ""..winsRed.."<br>"..rank[index].winsRed..""
      winsBlue = ""..winsBlue.."<br>"..rank[index].winsBlue..""
      
      if mode == "4 teams mode" then
        winsYellow = ""..winsYellow.."<br>"..rank[index].winsYellow..""
        winsGreen = ""..winsGreen.."<br>"..rank[index].winsGreen..""
      elseif mode == "3 teams mode" then
        winsGreen = ""..winsGreen.."<br>"..rank[index].winsGreen..""
      end
      
      if colorBackground == 0x2d5a61 then
        colorBackground = 0x142b2e
      else
        colorBackground = 0x2d5a61
      end
    else
      ui.addTextArea(i, "", name, 135, y, 630, 6, colorBackground, colorBackground, 0, true)
    end
    
    y = y + 16
  end
  
  local findNextIndexValue = 1 + (10 * (page))
  
  ui.addTextArea(9999545, "<p align='center'><font size='11px'>"..playerRankingMode[name].."", name, 390, 85, 120, 20, 0x161616, 0x161616, 0, true)
  if mode == "Normal mode" then
    ui.addTextArea(9999546, "<p align='center'><font size='13px'><n2>«<n>", name, 350, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999547, "<p align='center'><font size='13px'><a href='event:4 teams mode'>»</a>", name, 520, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
  elseif mode == "4 teams mode" then
    ui.addTextArea(9999546, "<p align='center'><font size='13px'><a href='event:Normal mode'>«</a>", name, 350, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999547, "<p align='center'><font size='13px'><a href='event:3 teams mode'>»</a>", name, 520, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
  elseif mode == "3 teams mode" then
    ui.addTextArea(9999546, "<p align='center'><font size='13px'><a href='event:4 teams mode'>«</a>", name, 350, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999547, "<p align='center'><font size='13px'><a href='event:2 teams mode'>»</a>", name, 520, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
  elseif mode == "2 teams mode" then
    ui.addTextArea(9999546, "<p align='center'><font size='13px'><a href='event:3 teams mode'>«</a>", name, 350, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999547, "<p align='center'><font size='13px'><a href='event:Real mode'>»</a>", name, 520, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
  elseif mode == "Real mode" then
    ui.addTextArea(9999546, "<p align='center'><font size='13px'><a href='event:2 teams mode'>«</a>", name, 350, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999547, "<p align='center'><font size='13px'><n2>»</n>", name, 520, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
  end
  ui.addTextArea(9999548, "<textformat leading='3px'><j>Name<n>"..namesRank.."", name, 135, 115, 185, 185, 0x161616, 0x161616, 0, true)
  ui.addTextArea(9999549, "<textformat leading='3px'><j>Matches<n>"..matchesRank.."", name, 335, 115, 50, 185, 0x161616, 0x161616, 0, true)
  ui.addTextArea(9999550, "<textformat leading='3px'><j>Wins<n>"..winsRank.."", name, 400, 115, 50, 185, 0x161616, 0x161616, 0, true)
  ui.addTextArea(9999551, "<textformat leading='3px'><j>Win rate<n>"..winRatioRank.."", name, 465, 115, 55, 185, 0x161616, 0x161616, 0, true)
  if mode == "4 teams mode" then
    ui.addTextArea(9999552, "<textformat leading='3px'><r>WR<n>"..winsRed.."", name, 535, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999553, "<textformat leading='3px'><bv>WB<n>"..winsBlue.."", name, 597, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999564, "<textformat leading='3px'><j>WY<n>"..winsYellow.."", name, 659, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999565, "<textformat leading='3px'><vp>WG<n>"..winsGreen.."", name, 721, 115, 50, 185, 0x161616, 0x161616, 0, true)
  elseif mode == "3 teams mode" then
    ui.addTextArea(9999552, "<textformat leading='3px'><r>WR<n>"..winsRed.."", name, 597, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999553, "<textformat leading='3px'><bv>WB<n>"..winsBlue.."", name, 659, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999565, "<textformat leading='3px'><vp>WG<n>"..winsGreen.."", name, 721, 115, 50, 185, 0x161616, 0x161616, 0, true)
  else
    ui.addTextArea(9999552, "<textformat leading='3px'><r>WR<n>"..winsRed.."", name, 650, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999553, "<textformat leading='3px'><bv>WB<n>"..winsBlue.."", name, 715, 115, 50, 185, 0x161616, 0x161616, 0, true)
  end
  
  if page == 1 then
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.previousMessage.."</n>")
  else
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<a href='event:prevRank"..tostring(page - 1).."'>"..playerLanguage[name].tr.previousMessage.."</a>")
  end
  
  if rank[findNextIndexValue] == nil or findNextIndexValue > 30 then
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.nextMessage.."</n>")
  else
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<a href='event:nextRank"..tostring(page + 1).."'>"..playerLanguage[name].tr.nextMessage.."</a>")
  end
end