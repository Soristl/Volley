function isBallOnGround(objId)
  local obj = tfm.get.room.objectList[objId]

  if obj == nil then return false end

  local vy = obj.vy or 0
  return obj.y >= GROUND_LINE_Y and vy >= 0
end
