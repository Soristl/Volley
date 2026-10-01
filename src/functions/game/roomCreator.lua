local function canBecomeRoomCreator(name)
  local data = tfm.get.room.playerList[name]
  return data ~= nil and not name:find("*", 1, true) and not playerBan[name] and not playerLeft[name]
    and (timestamp == 0 or (data.registrationDate or 0) <= timestamp)
end

function assignRoomCreator(name)
  if roomCreator.name or roomCreator.selectionClosed or not canBecomeRoomCreator(name) then
    return
  end

  -- Remember the first arrival while the initial map loads staff and bans.
  if firstRun then
    roomCreator.pendingName = roomCreator.pendingName or name
    return
  end

  roomCreator.name = name
  USER_PERMISSIONS[name] = math.max(USER_PERMISSIONS[name] or 1, 2)
  tfm.exec.chatMessage("<vp>" .. name .. " is the Room Creator.<n>", nil)
  if gameState.phase == "startGame" then
    ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name,
      180, 370, 150, 30, 1, false, false)
  end
end

function initializeRoomCreator()
  local candidate
  for name in pairs(tfm.get.room.playerList) do
    if canBecomeRoomCreator(name) then
      if candidate then
        -- A script loaded into an occupied room has no arrival history.
        -- Do not choose an arbitrary owner from an unordered player list.
        roomCreator.selectionClosed = true
        return
      end
      candidate = name
    end
  end
  if candidate then
    assignRoomCreator(candidate)
  end
end
