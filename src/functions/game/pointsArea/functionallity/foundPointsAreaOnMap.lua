function foundPointsAreaOnMap(map)
  local xml = mapXml.source(map)
  local properties = xml:match("<P%s+[^>]*>") or ""
  local function areas(key)
    local text = mapXml.attribute(properties, key)
    if not text or not text:match("%S") then return {} end
    local values, result = {}, {}
    for token in text:gmatch("[^%s,;]+") do
      local number = mapXml.number(token)
      if not number then
        print("[Volley] Invalid point area coordinates: " .. key)
        return {}
      end
      values[#values + 1] = number
    end
    if #values % 4 ~= 0 then
      print("[Volley] Incomplete point area rectangle: " .. key)
      return {}
    end
    for i = 1, #values, 4 do
      local x1, x2, y1, y2 = values[i], values[i + 1], values[i + 2], values[i + 3]
      if x1 > x2 or y1 > y2 then
        print("[Volley] Reversed point area bounds: " .. key)
        return {}
      end
      result[#result + 1] = { x1, x2, y1, y2 }
    end
    return result
  end
  teamPointsArea1 = areas("team1")
  teamPointsArea2 = areas("team2")
  teamPointsArea3 = areas("team3")
  teamPointsArea4 = areas("team4")
end
