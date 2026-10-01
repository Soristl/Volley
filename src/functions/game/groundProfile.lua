-- Point threshold follows reviewed XML floor geometry, two world pixels below
-- its upper surface. Custom scoring rectangles retain their own semantics.
groundProfile = {}
do
  local segments = {}
  local fields = {'T','X','Y','L','H','P','c'}

  function groundProfile.reset() segments = {} end

  function groundProfile.refresh()
    groundProfile.reset()
    local info = tfm.get.room.xmlMapInfo
    local xml = info and info.xml or ''
    local grounds = xml:match('<S>(.-)</S>') or ''
    for tag in grounds:gmatch('<S%s+([^>]+)>') do
      local a, key = {}, {}
      for k, quote, value in tag:gmatch('([%w_]+)%s*=%s*([\'"])(.-)%2') do a[k] = value end
      for i, field in ipairs(fields) do key[i] = a[field] or '' end
      if volleyGroundSignatures[table.concat(key, '|')] then
        local p = {}
        for value in a.P:gmatch('[^,]+') do p[#p+1] = tonumber(value) or 0 end
        local angle = (p[5] or 0)*math.pi/180
        local c, s = math.cos(angle), math.sin(angle)
        local x, y = tonumber(a.X), tonumber(a.Y)
        local w, h = tonumber(a.L)/2, tonumber(a.H)/2
        local corners = {}
        for i, v in ipairs({{-w,-h},{w,-h},{w,h},{-w,h}}) do
          corners[i] = {x+v[1]*c-v[2]*s, y+v[1]*s+v[2]*c+2}
        end
        -- For clockwise vertices, edges travelling right form the upper hull.
        -- Includes the exposed short side of steeply rotated rectangles.
        for i=1,4 do
          local first, last = corners[i], corners[i%4+1]
          if last[1]-first[1] > 0.000001 then
            segments[#segments+1] = {first[1],last[1],first[2],(last[2]-first[2])/(last[1]-first[1])}
          end
        end
      end
    end
  end

  function groundProfile.height(x)
    local result
    for _, edge in ipairs(segments) do
      if x >= edge[1] and x <= edge[2] then
        local y = edge[3]+(x-edge[1])*edge[4]
        if not result or y < result then result = y end
      end
    end
    -- Holes and maps without a reviewed fixed floor keep their fall threshold.
    return result or GROUND_LINE_Y
  end

  function groundProfile.crossing(previous, x, y)
    if not previous or y < previous.y then return nil end
    local dx, dy = x-previous.x, y-previous.y
    local first, result
    local function check(low, high, startX, startY, slope)
      local distance = previous.y-(startY+(previous.x-startX)*slope)
      local delta = dy-dx*slope
      if distance >= 0 or delta <= 0 then return end
      local t = -distance/delta
      if t < 0 or t > 1 or (first and t >= first) then return end
      local at = previous.x+dx*t
      if at < low or at > high then return end
      -- Ignore buried edges where two grounds overlap, and the legacy line
      -- wherever an actual floor supplies the threshold.
      if math.abs(groundProfile.height(at)-(previous.y+dy*t)) > 0.00001 then return end
      first, result = t, at
    end
    for _, edge in ipairs(segments) do check(edge[1],edge[2],edge[1],edge[3],edge[4]) end
    check(-math.huge,math.huge,0,GROUND_LINE_Y,0)
    return result
  end
end
