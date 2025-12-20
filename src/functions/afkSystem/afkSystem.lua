function afkSystem() 
  local timestampNow = os.time()
  local playersAfkList = {}
  local countPlayers = 0

  for name, data in pairs(tfm.get.room.playerList) do
    countPlayers = countPlayers + 1

    local playerAfkTime = timestampNow - playersAfk[name]

    if playerAfkTime >= (10 * 60 * 1000) then
      playersAfkList[#playersAfkList + 1] = { name = name, timestamp = playerAfkTime }
    end
  end

  table.sort(playersAfkList, function(a, b) return a.timestamp > b.timestamp end)

  local maxPlayers = tfm.get.room.maxPlayers

  local countDifference = 0

  local count = 3

  if maxPlayers >= 17 and maxPlayers <= 20 then
    count = 4
  end

  for i = 0, count do
    if (countPlayers + i) == maxPlayers then
      if i == 0 then
        countDifference = count
      elseif i == 1 then
        countDifference = count - 1
        print(countDifference)
      elseif i == 2 then
        countDifference = count - 2
      elseif i == 3 then
        countDifference = count - 3
      elseif i == 4 then
        countDifference = count - 4
      end
    end
  end

  if maxPlayers >= 17 and maxPlayers <= 20 then
    if countDifference <= 4 then
      for i = 1, countDifference do
        if playersAfkList[i] ~= nil then
          print('<bv>You have been kicked out of the room for being inactive for too long.<n>')
          tfm.exec.chatMessage('<bv>You have been kicked out of the room for being inactive for too long.<n>', playersAfkList[i].name)
          tfm.exec.kickPlayer(playersAfkList[i].name)
        end
      end
    end

    return
  end

  if countDifference <= 3 then
    for i = 1, countDifference do
      if playersAfkList[i] ~= nil then
        print('<bv>You have been kicked out of the room for being inactive for too long.<n>')
        tfm.exec.chatMessage('<bv>You have been kicked out of the room for being inactive for too long.<n>', playersAfkList[i].name)
        tfm.exec.kickPlayer(playersAfkList[i].name)
      end
    end
  end
end