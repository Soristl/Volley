do
-- Fixed profile metadata stays private; text and player data are read on render.
local roleTags = {[2]="ch", [3]="j", [4]="vi", [5]="vi"}
local trophyIds = {27, 28, 29, 32, 33, 34}

local function profileEscape(text)
  return tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

function getProfileText(name)
  local language = playerLanguage[name] and playerLanguage[name].tr
  return (language and language.profile) or lang.en.profile
end

function resolveProfileTarget(query)
  if type(query) ~= "string" then return nil, "notFound" end
  local lower = query:lower()
  local hasDiscriminator = query:find("#", 1, true)
  local candidate, count = nil, 0
  for target in pairs(playerAchievements) do
    if target:lower() == lower then return target end
    if not hasDiscriminator and target:gsub("#%d+$", ""):lower() == lower then
      candidate, count = target, count + 1
    end
  end
  if count == 1 then return candidate end
  return nil, count > 1 and "ambiguous" or "notFound"
end

local function profileArea(id, text, name, x, y, width, height, color, alpha, border)
  if clubhouse.images[clubhouse.interiors.profile] then alpha = 0 end
  clubhouse.area(name, "profile", id, text, x, y, width, height, color, true, border, alpha or 0)
end

function updateProfileMode(name, index)
  local state = profileState[name]
  if not state or not isOpenProfile[name] or not index or index % 1 ~= 0 or index < 1 or index > 5 then return end
  state.mode = index
  local text = getProfileText(name)
  local sources = { playersNormalMode, playersTwoTeamsMode, playersThreeTeamsMode, playersFourTeamsMode, playersRealMode }
  local stats = sources[index][state.target] or {}
  local matches, wins = stats.matches or 0, stats.wins or 0
  local position = "—"
  rankingCache.ensure(index)
  if matches > 0 then
    local rank = rankingCache.position(index, state.target)
    if rank then position = "#" .. rank end
  end
  profileArea(8707, "", name, 550, 68, 132, 54, 0x102323, 1, 0x795D36)
  profileArea(8705, "<p align='center'><font face='Georgia' size='26' color='#DEC18A'>" .. position .. "</font></p>", name, 556, 68, 120, 33)
  profileArea(8706, "<p align='center'><font size='10' color='#ADAB94'>" .. (matches > 0 and text.rank or text.unranked) .. "</font></p>", name, 556, 100, 120, 17)
  for i, label in ipairs(text.modes) do
    local selected = index == i
    if selected then label = "<b>" .. label .. "</b>" end
    profileArea(8709 + i, "<p align='center'><font size='11' color='" .. (selected and "#F7D99A" or "#C4BAA2") .. "'><a href='event:profileMode" .. i .. "'>" .. label .. "</a></font></p>",
      name, 94 + (i - 1) * 123, 136, 114, 21, selected and 0x29352A or 0x102323, 1, selected and 0xB58A46 or 0x4C4834)
  end
  local labels = { text.matches, text.wins, text.rate }
  local values = { matches, wins, matches > 0 and (math.floor(wins * 100 / matches + 0.5) .. "%") or "—" }
  for i = 1, 3 do
    -- Position the caption and value independently of mixed-font line metrics.
    local x = 100 + (i - 1) * 211
    profileArea(8714 + i, "<p align='center'><font size='10' color='#C4BAA2'>" .. labels[i] .. "</font></p>",
      name, x, 174, 178, 18)
    profileArea(8699 + i, "<p align='center'><font face='Georgia' size='23' color='#F2E5CD'>" .. values[i] .. "</font></p>",
      name, x, 185, 178, 32)
  end
end

function showProfileTrophy(name, index)
  local state = profileState[name]
  if not state or not isOpenProfile[name] or not index or index % 1 ~= 0 or index < 1 or index > 6 then return end
  local trophy = playerAchievements[state.target] and playerAchievements[state.target][index]
  if not trophy then return end
  state.trophy = index
  local text = getProfileText(name)
  local description = playerLanguage[name].tr.msgsTrophies[index]
  if not description or description == "" then description = text.trophy .. " " .. index end
  local quantity = trophy.quantity or 0
  local detail = quantity > 0 and string.format(text.quantity, quantity) or text.locked
  profileArea(8719, "<font size='10' color='#F2E5CD'>" .. profileEscape(clubhouse.shorten(description, 65)) .. "</font>", name, 103, 306, 456, 17)
  profileArea(8721, "<font size='9' color='#ADAB94'>" .. detail .. "</font>", name, 103, 318, 456, 15)
  if state.target == name and quantity > 0 then
    profileArea(8722, "<p align='center'><font size='11' color='#DEC18A'><a href='event:profileEquipTrophy'>" .. text.show .. "</a></font></p>", name, 589, 312, 112, 24)
  else clubhouse.hideArea(name,"profile",8722) end
end

function equipProfileTrophy(name)
  local state = profileState[name]
  if not state or state.target ~= name or not state.trophy then return end
  local trophy = playerAchievements[name] and playerAchievements[name][state.trophy]
  if not trophy or (trophy.quantity or 0) < 1 then return end
  removePlayerTrophy(name)
  closeAllWindows(name)
  playerTrophyImage[name] = tfm.exec.addImage(trophy.image, "$" .. name, -20, -105, nil)
  tfm.exec.playEmote(name, 0)
  removePlayerTrophyImage(name)
end

function profileUI(name, playerTarget)
  if not playerAchievements[playerTarget] then return end
  local previous = profileState[name]
  local refresh = previous and previous.target==playerTarget and clubhouse.views[name] and clubhouse.views[name].profile
  if not refresh then removeUITrophies(name) end
  isOpenProfile[name] = true
  profileState[name] = refresh and previous or { target = playerTarget }
  local text = getProfileText(name)
  clubhouse.panel(name, "profile")
  clubhouse.closeLabel(name, "profile", "profileClose")
  local nick, tag = playerTarget:match("^(.-)(#%d+)$")
  profileArea(8703, "<font face='Georgia' size='23' color='#F2E5CD'>" .. profileEscape(clubhouse.shorten(nick or playerTarget, 28)) .. "</font><font size='11' color='#ADAB94'>" .. profileEscape(tag or "") .. "</font>", name, 94, 68, 430, 30)
  local level = USER_PERMISSIONS[playerTarget] or 1
  local role = text.roles[level] or text.roles[1]
  local roleColors = tfm.exec.chatMessage_colors
  local roleTag = roleTags[level] or "n"
  local roleLabel = "<font size='10' color='" .. roleColors[roleTag] .. "'>" .. role .. "</font>"
  if roomCreator.name == playerTarget then
    roleLabel = "<font size='10' color='" .. roleColors.vp .. "'>Room Creator · </font>" .. roleLabel
  end
  if playerTarget == "Myzk#5789" or playerTarget == "Tanarchosl#4785" or playerTarget == "Refletz#6472" then
    local developerKey = playerTarget == "Refletz#6472" and "profile.developer_main" or "profile.developer_second"
    roleLabel = "<font size='10' color='#EF4444'>" .. clubhouse.escape(clubhouse.text(name, developerKey)) .. "</font>"
  end
  profileArea(8704, roleLabel, name, 94, 102, 435, 19)
  local collected = 0
  for i = 1, 6 do
    if (playerAchievements[playerTarget][i].quantity or 0) > 0 then collected = collected + 1 end
    ui.addTrophie(trophyIds[i], "trophie" .. i, name, playerTarget, 94 + (i - 1) * 106, 250, 82, 50, 1)
  end
  profileArea(8718, "<font face='Georgia' size='11' color='#DEC18A'>" .. text.trophies .. "</font><font size='10' color='#ADAB94'>   " .. collected .. "/6</font>", name, 109, 228, 576, 18)
  profileArea(8720, "<font size='10' color='#ADAB94'>" .. text.session .. "</font>", name, 94, 333, 610, 18)
  local index = gameStats.twoTeamsMode and 2 or gameStats.threeTeamsMode and 3 or gameStats.teamsMode and 4 or gameStats.realMode and 5 or 1
  updateProfileMode(name, refresh and previous.mode or index)
  showProfileTrophy(name, refresh and previous.trophy or 1)
  clubhouse.endUpdate(name, "profile")
end
end
