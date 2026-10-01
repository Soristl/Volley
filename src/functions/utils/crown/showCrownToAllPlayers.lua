-- Image handles are owned by viewer and ranked player.
do
  local images = {}
  gameCrowns = {}

  function gameCrowns.clearViewer(viewer)
    for _, id in pairs(images[viewer] or {}) do tfm.exec.removeImage(id) end
    images[viewer] = nil
  end

  function gameCrowns.clearSubject(player)
    for _, shown in pairs(images) do
      if shown[player] then tfm.exec.removeImage(shown[player]); shown[player] = nil end
    end
  end

  function gameCrowns.clearPlayer(name)
    gameCrowns.clearViewer(name)
    gameCrowns.clearSubject(name)
  end

  function gameCrowns.reset()
    local viewers = {}
    for viewer in pairs(images) do viewers[#viewers + 1] = viewer end
    for _, viewer in ipairs(viewers) do gameCrowns.clearViewer(viewer) end
  end

  function gameCrowns.refresh(viewer, player)
    if player then gameCrowns.clearSubject(player)
    elseif viewer then gameCrowns.clearViewer(viewer)
    else gameCrowns.reset() end

    local crowns = {red=redCrown, blue=blueCrown, green=greenCrown, yellow=yellowCrown}
    for key, roster in pairs(gameState.teams) do
      for _, slot in ipairs(roster) do
        local subject = slot.name
        if subject ~= '' and (not player or subject == player) and playerInGame[subject]
          and tfm.get.room.playerList[subject] and not playerLeft[subject] and not playerBan[subject] then
          for rank = 1, 10 do
            if rankCrown[rank] and rankCrown[rank].name == subject then
              for recipient in pairs(tfm.get.room.playerList) do
                if (not viewer or recipient == viewer) and showCrownImages[recipient]
                  and not playerLeft[recipient] and not playerBan[recipient] then
                  images[recipient] = images[recipient] or {}
                  if not images[recipient][subject] then
                    images[recipient][subject] = tfm.exec.addImage(crowns[key][rank], '$' .. subject, -20, -93, recipient)
                  end
                end
              end
              break
            end
          end
        end
      end
    end
  end
end

function showCrownToAllPlayers(viewer)
  gameCrowns.refresh(viewer)
end
