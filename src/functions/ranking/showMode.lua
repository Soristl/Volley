do
local rankingModes = { "Normal mode", "2 teams mode", "3 teams mode", "4 teams mode", "Real mode" }
-- Keep each column's fixed presentation together, outside the render path.
local rankingColumns = {
  {x=55, width=26, color="#ADAB94"},
  {x=86, width=222, color="#F2E5CD"},
  {x=315, width=63, color="#ADAB94"},
  {x=383, width=67, color="#F2E5CD"},
  {x=455, width=80, color="#ADAB94"},
  {x=550, width=43, color="#EF7777"},
  {x=602, width=43, color="#75A8FA"},
  {x=654, width=43, color="#F5C264"},
  {x=706, width=43, color="#69C4A0"},
}
local rankingMedals = {"#F7D99A", "#D6DDD8", "#D3A077"}

local function rankingArea(id, text, name, x, y, width, height, background, border)
  clubhouse.area(name, "ranking", id, text, x, y, width, height, background, true,
    border, background and not clubhouse.images[clubhouse.interiors.ranking] and 1 or 0)
end

local function rankingText(text, color, size)
  return "<font size='" .. (size or 11) .. "' color='" .. (color or "#F2E5CD") .. "'>" .. text .. "</font>"
end

local function rankingSetPage(name, index, page)
  local pages = { pageNormalMode, pageTwoTeamsMode, pageThreeTeamsMode, pageFourTeamsMode, pageRealMode }
  pages[index][name] = page
end

function showMode(mode, name, findMe)
  local state = rankingState[name]
  if not state or not openRank[name] then return end
  local selected
  for i, value in ipairs(rankingModes) do if value == mode then selected = i; break end end
  if not selected then return end
  local rank = rankingCache.ensure(selected)
  local ownPosition = rankingCache.position(selected, name)
  local pages = math.max(1, math.ceil(#rank / 8))
  local page = math.max(1, math.min(pages, rankPageMode(mode, name) or 1))
  if findMe and ownPosition then page = math.ceil(ownPosition / 8) end
  rankingSetPage(name, selected, page)
  playerRankingMode[name] = mode
  state.mode, state.page, state.pages, state.targets = selected, page, pages, {}
  local language = playerLanguage[name].tr
  local text = language.ranking or lang.en.ranking
  local profile = getProfileText(name)
  state.ownPosition = ownPosition

  clubhouse.panel(name, "ranking")
  clubhouse.closeLabel(name, "ranking", "rankingClose")
  rankingArea(8806, rankingText(profile.session, "#ADAB94", 9), name, 50, 61, 650, 15)
  for i, label in ipairs(profile.modes) do
    if i == selected then label = "<b>" .. label .. "</b>" end
    rankingArea(8810 + i - 1, "<p align='center'>" .. rankingText("<a href='event:rankingMode" .. i .. "'>" .. label .. "</a>", i == selected and "#F2E5CD" or "#ADAB94"),
      name, 50 + (i - 1) * 142, 87, 131, 22, i == selected and 0x29352A or 0x102323, i == selected and 0xB58A46 or 0x4C4834)
  end
  rankingArea(8815, rankingText(text.you .. "  " .. (ownPosition and ("#" .. ownPosition) or profile.unranked), "#DEC18A"), name, 50, 117, 380, 21)
  rankingArea(8816, "<p align='right'>" .. rankingText(string.format(text.players, #rank), "#ADAB94", 10), name, 433, 117, 317, 21)

  local labels = { "#", text.player, text.matches, profile.wins, text.rate, text.teams[1], text.teams[2], text.teams[3], text.teams[4] }
  rankingArea(8834, "", name, 48, 142, 704, 20, 0x202D26, 0x665135)
  for col, label in ipairs(labels) do
    local column = rankingColumns[col]
    rankingArea(8820 + col - 1, (col > 2 and "<p align='center'>" or "") .. rankingText(label, column.color, 10), name, column.x, 143, column.width, 20)
  end
  for row = 1, 8 do
    local position = (page - 1) * 8 + row
    local player = rank[position]
    if player then
      state.targets[row] = player.name
      local y, id = 166 + (row - 1) * 21, 8840 + (row - 1) * 10
      local own = player.name == name
      local medal = position <= 3 and rankingMedals[position]
      rankingArea(id, "", name, 48, y, 704, 19, own and 0x2B3528 or (row % 2 == 1 and 0x142825 or 0x0D2021), own and 0xA37A3D or 0x263B32)
      local escaped = clubhouse.shorten(player.name, 25):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
      local values = { position, "<a href='event:rankingPlayer" .. row .. "'>" .. escaped .. "</a>", player.matches, player.wins,
        player.matches > 0 and (math.floor(player.wins * 100 / player.matches + 0.5) .. "%") or "—",
        player.winsRed or 0, player.winsBlue or 0,
        selected == 4 and (player.winsYellow or 0) or "—",
        (selected == 3 or selected == 4) and (player.winsGreen or 0) or "—" }
      for col, value in ipairs(values) do
        local column = rankingColumns[col]
        local color = col == 1 and medal or (own and col == 2 and "#F7D99A" or column.color)
        local content = rankingText(value, color, col == 2 and 10 or 11)
        if own and col == 2 then content = "<b>" .. content .. "</b>" end
        if col == 1 then content = "<font face='Georgia' size='12' color='" .. color .. "'><b>" .. value .. "</b></font>" end
        rankingArea(id + col, (col ~= 2 and "<p align='center'>" or "") .. content,
          name, column.x - (col == 1 and 1 or 0), y - (col == 1 and 1 or 0), column.width, 19, col == 1 and (medal and 0x3A3526 or 0x1B3029) or nil)
      end
    end
  end
  local previousLabel = language.previousMessage:gsub("<[^>]+>", "")
  local nextLabel = language.nextMessage:gsub("<[^>]+>", "")
  local previous = page > 1 and ("<a href='event:rankingPage" .. (page - 1) .. "'>‹ " .. previousLabel .. "</a>") or ("‹ " .. previousLabel)
  local nextPage = page < pages and ("<a href='event:rankingPage" .. (page + 1) .. "'>" .. nextLabel .. " ›</a>") or (nextLabel .. " ›")
  rankingArea(8830, "<p align='center'>" .. rankingText(previous, page > 1 and "#F2E5CD" or "#777D70"), name, 54, 342, 127, 19, 0x102323, 0x665135)
  clubhouse.state(name,"ranking").navigation={page=page,pages=pages}
  local pageLabel=page .. " / " .. pages
  if pages>2 then pageLabel="<a href='event:choosePage:ranking'>"..pageLabel.."</a>" end
  rankingArea(8831, "<p align='center'>" .. rankingText(pageLabel, pages>2 and "#DEC18A" or "#ADAB94"), name, 190, 342, 75, 19, 0x102323, 0x665135)
  rankingArea(8832, "<p align='center'>" .. rankingText(ownPosition and ("<a href='event:rankingMe'>" .. text.findMe .. "</a>") or profile.unranked, ownPosition and "#DEC18A" or "#777D70"), name, 280, 342, 230, 19, 0x102323, ownPosition and 0xA37A3D or 0x665135)
  rankingArea(8833, "<p align='center'>" .. rankingText(nextPage, page < pages and "#F2E5CD" or "#777D70"), name, 604, 342, 142, 19, 0x102323, 0x665135)
  clubhouse.endUpdate(name, "ranking")
end

function openRankingUI(name)
  if rankKeyTime[name] and os.time() - rankKeyTime[name] < 2000 then return end
  rankKeyTime[name] = os.time()
  closeAllWindows(name)
  openRank[name] = true
  rankingState[name] = {}
  showMode(playerRankingMode[name] or "Normal mode", name)
end

function rankingCallback(name, callback)
  local state = rankingState[name]
  if not state or not openRank[name] then return end
  if callback == "rankingClose" then closeRankingUI(name); return end
  if callback:sub(1, 11) == "rankingMode" then
    local index = tonumber(callback:sub(12))
    if index and rankingModes[index] then showMode(rankingModes[index], name) end
  elseif callback:sub(1, 11) == "rankingPage" then
    local page = tonumber(callback:sub(12))
    if page and page % 1 == 0 and page >= 1 and page <= state.pages then
      rankingSetPage(name, state.mode, page)
      showMode(rankingModes[state.mode], name)
    end
  elseif callback == "rankingMe" then
    showMode(rankingModes[state.mode], name, true)
  elseif callback:sub(1, 13) == "rankingPlayer" then
    local row = tonumber(callback:sub(14))
    local target = row and state.targets[row]
    if not target or not playerAchievements[target] then return end
    if profileKeyTime[name] and os.time() - profileKeyTime[name] < 2000 then return end
    profileKeyTime[name] = os.time()
    closeAllWindows(name)
    profileUI(name, target)
  end
end
end
