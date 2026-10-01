function getSyncLatency(value)
  if type(value) == 'number' and value >= 0 and value < math.huge then return value end
end

function requestPlayerSync(target, requester)
  if not tfm.get.room.playerList[target] or target:find('*',1,true)
    or playerBan[target] or playerLeft[target] then
    tfm.exec.chatMessage('<j>This player is not available for sync.<n>', requester)
    return false
  end
  local ok = pcall(tfm.exec.setPlayerSync, target)
  if not ok then
    tfm.exec.chatMessage('<r>Unable to change sync in this room.<n>', requester)
    return false
  end
  return true
end

function refletzSyncSystem(requester)
  local lowestSync = math.huge
  local bestPlayer

  for n, data in pairs(tfm.get.room.playerList) do
    local latency = getSyncLatency(data.averageLatency)
    if not n:find('*', 1, true) and not playerBan[n] and not playerLeft[n]
      and latency ~= nil then
      if latency < lowestSync or (latency == lowestSync and (not bestPlayer or n < bestPlayer)) then
        lowestSync = latency
        bestPlayer = n
      end
    end
  end

  if bestPlayer then
    local ok = pcall(tfm.exec.setPlayerSync, bestPlayer)
    if not ok then
      if requester then tfm.exec.chatMessage('<r>Unable to change sync in this room.<n>', requester) end
      return nil
    end
    tfm.exec.chatMessage("<j>[SYSTEM] Sync set to " .. bestPlayer, nil)
    return bestPlayer
  end
  if requester then tfm.exec.chatMessage('<j>No eligible player with a valid latency is available.<n>', requester) end
end
