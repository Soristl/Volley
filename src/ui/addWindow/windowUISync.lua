local function windowUISync(args)
  local name = args[1]
  closeRankingUI(name)
  openRank[name] = false

  -- Another useless loop if the global copy of playersSync state is updated
  -- on the right times: @Vit0rg
  local playersSync = {}
  local list = tfm.get.room.playerList
  for player, data in pairs(list) do
    local latency = data.averageLatency
    playersSync[#playersSync + 1] = { name = player, sync = latency, status = getSyncGrade(latency) }
  end

  table.sort(playersSync, function(a, b) return a.sync < b.sync end)

  local buffer = {}
  local r = 00
  local g = 00

  for i = 1, 5 do
    r = math.min(255, playersSync[i].sync)
    g = math.max(0, (255 - playersSync[i].sync))
    local hexColor = string.format("%02x%02x00", r, g)

    buffer[#buffer + 1] = string.format(
      "<p align='center'><font size='+6' color='#%s'><a href='event:sync%s'>%s</a></p><br>",
      hexColor,
      playersSync[i].name,
      playersSync[i].name
    )
  end

  ui.addWindow(24,
    "<p align='center'> <font size='+6' color = '#babd2f'>Select player sync<br>(click on player name to select the sync)</p><br>" ..
    table.concat(buffer, ''),
    name, 300, 70, 400, 250, 0.8, false, true, playerLanguage[name].tr.closeUIText)
end
