function clubhouse.drawScores(entries,viewer)
  -- Frames and numbers share map coordinates, so neither follows the camera.
  clubhouse.each(viewer,function(player)
    clubhouse.beginUpdate(player,"score")
    for slot,entry in ipairs(entries) do
      local x = entry.x
      -- Cover the legacy grounds within their layer, below mice and shaman objects.
      clubhouse.image(player,"score","02-score-couverture-100x106.png",x,-8,"score"..slot,"_1000")
      clubhouse.area(player,"score",96100+slot,
        "<p align='center'><font face='Verdana' size='30' color='"..entry.color.."'>"..tostring(entry.value).."</font></p>",
        x+8,29,84,43,nil,false)
      if entry.detail then
        clubhouse.area(player,"score",96200+slot,
          "<p align='center'><font size='20' color='"..entry.color.."'>"..entry.detail.."</font></p>",entry.detailX,20,100,30)
      end
    end
    clubhouse.endUpdate(player,"score")
  end)
end

function clubhouse.winner()
  clubhouse.each(nil,function(name)
    closeAllWindows(name)
    clubhouse.panel(name,"victory")
    local team
    if gameStats.teamsMode or gameStats.threeTeamsMode then
      team = gameTeams.keyAt(1)
    else team=gameState.scores.red>=gameStats.winscore and "red" or "blue" end
    local detail=team and clubhouse.strings["team."..team] and clubhouse.text(name,"victory.winner",{team=clubhouse.text(name,"team."..team)}) or
      ""
    clubhouse.label(name,"victory","detail",detail)
    clubhouse.endUpdate(name,"victory")
  end)
end
