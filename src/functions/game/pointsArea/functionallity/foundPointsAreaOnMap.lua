function foundPointsAreaOnMap(map)
  local mapXML = ''
  
  if #map > 10 then
    mapXML = map
  else
    mapXML = tfm.get.room.xmlMapInfo.xml
  end

  teamPointsArea1 = {}
  teamPointsArea2 = {}
  teamPointsArea3 = {}
  teamPointsArea4 = {}

  local team1Text = mapXML:match('<C>%s*<P[^>]-team1="([^"]+)"')

  if team1Text ~= nil then
    local count = 1
    local arr = {}

    for value in team1Text:gmatch("%d+") do
      arr[#arr + 1] = tonumber(value)

      if count == 4 then
        count = 1
        teamPointsArea1[#teamPointsArea1 + 1] = arr

        arr = {}
      else
        count = count + 1
      end
    end
  end

  local team2Text = mapXML:match('<C>%s*<P[^>]-team2="([^"]+)"')

  if team2Text ~= nil then
    local count = 1
    local arr = {}

    for value in team2Text:gmatch("%d+") do
      arr[#arr + 1] = tonumber(value)

      if count == 4 then
        count = 1
        teamPointsArea2[#teamPointsArea2 + 1] = arr

        arr = {}
      else
        count = count + 1
      end
    end
  end

  local team3Text = mapXML:match('<C>%s*<P[^>]-team3="([^"]+)"')

  if team3Text ~= nil then
    local count = 1
    local arr = {}

    for value in team3Text:gmatch("%d+") do
      arr[#arr + 1] = tonumber(value)

      if count == 4 then
        count = 1
        teamPointsArea3[#teamPointsArea3 + 1] = arr

        arr = {}
      else
        count = count + 1
      end
    end
  end

  local team4Text = mapXML:match('<C>%s*<P[^>]-team4="([^"]+)"')

  if team4Text ~= nil then
    local count = 1
    local arr = {}

    for value in team4Text:gmatch("%d+") do
      arr[#arr + 1] = tonumber(value)

      if count == 4 then
        count = 1
        teamPointsArea4[#teamPointsArea4 + 1] = arr

        arr = {}
      else
        count = count + 1
      end
    end
  end
end