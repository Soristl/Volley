-- Reduced courts retain the original team identity for lives and colours.
function teleportPlayersWithTypeMap(isLargeMode)
  if gameStats.typeMap ~= 'large3v3' and gameStats.typeMap ~= 'small' then return end
  teleportPlayersToSpec()
  if isLargeMode then refreshRemainingTeams() end

  local width = gameStats.threeTeamsMode and 600 or 400
  local area = 0
  for index, roster in ipairs(teamsPlayersOnGame) do
    local lives = gameLives.at(index)
    if lives and lives > 0 then
      area = area + 1
      local key = gameTeams.keyForRoster(roster)
      for _, slot in ipairs(roster) do
        local name = slot.name
        if name ~= '' and tfm.get.room.playerList[name]
          and not playerLeft[name] and not playerBan[name] then
          gameTeams.place(name, key, area, width * (area - 0.5))
        end
      end
    end
  end
end
