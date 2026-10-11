-- Reduced courts retain the original team identity for lives and colours.
function gameTeams.placeRemaining(isLargeMode)
  if gameState.match.court.typeMap ~= 'large3v3' and gameState.match.court.typeMap ~= 'small' then return end
  gameTeams.placeSpectators()
  if isLargeMode then gameTeams.refreshRemaining() end

  local width = gameState.match.mode.threeTeamsMode and 600 or 400
  local area = 0
  for index, roster in ipairs(gameState.teamLayout.remaining) do
    local lives = gameLives.at(index)
    if lives and lives > 0 then
      area = area + 1
      local key = gameTeams.keyForRoster(roster)
      for _, slot in ipairs(roster) do
        local name = slot.name
        if name ~= '' and tfm.get.room.playerList[name]
          and not playerState.left[name] and not playerState.ban[name] then
          gameTeams.place(name, key, area, width * (area - 0.5))
        end
      end
    end
  end
end
