-- All three ball slots have one owner: gameState.balls.
-- No scalar aliases or cached lists can drift from this state.
gameBalls = {}

function gameBalls.id(index)
  local slot = gameState.balls[index]
  return slot and slot.id
end

function gameBalls.set(index, id, active)
  local slot = gameState.balls[index]
  if not slot then return false end
  slot.id, slot.active = id, id ~= nil and active == true
  slot.pointPosition = nil
  return true
end

-- Keep successive scoring samples tied to this ball's lifetime. A spawn,
-- activation or map change must never reuse another object's trajectory.
function gameBalls.rememberPointPosition(index, x, y)
  local slot = gameState.balls[index]
  if slot and slot.id then slot.pointPosition = {x=x, y=y, time=os.time()} end
end

function gameBalls.pointPosition(index)
  local slot = gameState.balls[index]
  local previous = slot and slot.pointPosition
  local elapsed = previous and os.time() - previous.time
  -- Do not interpolate across pauses, long host stalls or clock resets.
  if elapsed and elapsed >= 0 and elapsed <= 1000 then return previous end
end

function gameBalls.deactivate(index)
  local slot = gameState.balls[index]
  if not slot then return false end
  slot.active = false
  slot.pointPosition = nil
  return true
end

function gameBalls.deactivateAll()
  for index=1,3 do gameBalls.deactivate(index) end
end

function gameBalls.remove(index)
  if index~=1 and index~=2 and index~=3 then return end
  local id=gameBalls.id(index)
  if type(id)=='number' and id>0 then
    tfm.exec.removeObject(id)
    clubhouse.ballSkins.remove(id)
  end
  gameBalls.set(index,nil,false)
end

function gameBalls.spawn(index,x,y,active)
  if index~=1 and index~=2 and index~=3 then return nil end
  gameBalls.remove(index)
  local skin=gameStats.customBall and balls[gameStats.customBallId] or nil
  local id=tfm.exec.addShamanObject(skin and skin.id or 6,x,y or 50,0,0,-5,true)
  gameBalls.set(index,id,id~=nil and active~=false)
  gameBalls.rememberPointPosition(index,x,y or 50)
  if skin and id then clubhouse.ballSkins.spawn(id,skin) end
  return id
end

function gameBalls.activate(index)
  local id=gameBalls.id(index)
  if id and tfm.get.room.objectList[id] then gameBalls.set(index,id,true);return true end
  return false
end

function gameBalls.quantity()
  if gameStats.realMode then return 1 end
  return (gameStats.threeTeamsMode and gameStats.threeBalls) and 3 or gameStats.twoBalls and 2 or 1
end

function gameBalls.isActive(index)
  local slot = gameState.balls[index]
  return slot ~= nil and slot.active == true and slot.id ~= nil
    and tfm.get.room.objectList[slot.id] ~= nil
end

function gameBalls.forget()
  -- A new map invalidates IDs; they may now belong to native map objects.
  -- Forget old ownership without removing anything from the new map.
  for index=1,3 do gameBalls.set(index,nil,false) end
end

function gameBalls.clear()
  local removed={}
  for i=1,3 do
    local id=gameBalls.id(i)
    if type(id)=='number' and id>0 and not removed[id] then
      tfm.exec.removeObject(id);clubhouse.ballSkins.remove(id);removed[id]=true
    end
  end
  gameBalls.forget()
end
