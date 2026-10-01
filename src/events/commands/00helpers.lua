-- Shared command services; handlers are registered by eventChatCommand.lua.
local commandHandlers = {}
-- HELPER FUNCTIONS
function commandHandlers.validateMap(args)
  local name = args[1]
  local map = args[2]
  local index = args[3]

  local regexMap = "^@%d%d%d%d%d%d%d$"

  if not map or not string.match(map, regexMap) then
    tfm.exec.chatMessage(" <bv>Parameter " .. index ..
      " invalid. Use @1234567<n> ", name)
    return false
  end

  return true
end

function commandHandlers.split(str)
  local t = {}
  for word in str:gmatch("%S+") do t[#t + 1] = word end
  return t
end

-- Validate team mode conflicts
function commandHandlers.checkModeConflict(args)
  local name = args[1]
  local modeToEnable = args[2]

  if gameStats.teamsMode and modeToEnable ~= "teamsMode" then
    tfm.exec.chatMessage("<bv>You should disable the 4 teams mode first<n>",
      name)
    return true
  end
  if gameStats.twoTeamsMode and modeToEnable ~= "twoTeamsMode" then
    tfm.exec.chatMessage("<bv>You should disable the 2 teams mode first<n>",
      name)
    return true
  end
  if gameStats.threeTeamsMode and modeToEnable ~= "threeTeamsMode" then
    tfm.exec.chatMessage("<bv>You should disable the 3 teams mode first<n>",
      name)
    return true
  end
  if gameStats.realMode and modeToEnable ~= "realMode" then
    tfm.exec.chatMessage("<bv>You should disable the real mode first<n>",
      name)
    return true
  end
  return false
end

commandHandlers.HELP_TEXTS = {
  { "<bl>settransformduration / std <n2> = transformation duration (3-5s)", "<bl>commands <n2> = commands",    "<bl>c <n2> = commands",   "<bl>join <n2> = join",              "<bl>j <n2> = join",        "<bl>leave <n2> = leave",        "<bl>l <n2> = leave",       "<bl>lang <n2> = lang",          "<bl>la <n2> = lang",       "<bl>admins <n2> = admins",              "<bl>ads <n2> = admins",       "<bl>balls <n2> = balls",  "<bl>b <n2> = balls", "<bl>votemap <n2> = votemap",   "<bl>vm <n2> = votemap",  "<bl>crown <n2> = crown",       "<bl>cr <n2> = crown",           "<bl>profile <n2> = profile",   "<bl>pr <n2> = profile",         "<bl>discord <n2> = discord", "<bl>dc <n2> = discord",       "<bl>maps <n2> = maps",   "<bl>m <n2> = maps" },
  { "<d>resettimer <n2> = resettimer", "<d>re <n2> = resettimer", "<d>setduration <n2> = setduration", "<d>sd <n2> = setduration", "<d>skiptimer <n2> = skiptimer", "<d>skip <n2> = skiptimer", "<d>stoptimer <n2> = stoptimer", "<d>stop <n2> = stoptimer", "<d>setmaxplayers <n2> = setmaxplayers", "<d>smp <n2> = setmaxplayers", "<d>setmap <n2> = setmap", "<d>sm <n2> = setmap", "<d>winscore <n2> = winscore",  "<d>w <n2> = winscore",   "<d>password <n2> = password", "<d>pw <n2> = password",              "<d>randommap <n2> = randommap", "<d>ra <n2> = randommap",       "<d>custommap <n2> = custommap", "<d>cm <n2> = custommap",     "<d>setscore <n2> = setscore", "<d>ssc <n2> = setscore", "<d>4teamsmode <n2> = 4teamsmode", "<d>fom <n2> = 4teamsmode", "<d>2teamsmode <n2> = 2teamsmode", "<d>twm <n2> = 2teamsmode", "<d>3teamsmode <n2> = 3teamsmode", "<d>thm <n2> = 3teamsmode", "<d>realmode <n2> = realmode", "<d>rm <n2> = realmode", "<d>admin <n2> = admin", "<d>a <n2> = admin", "<d>unadmin <n2> = unadmin", "<d>ua <n2> = unadmin", "<d>randomball <n2> = randomball", "<d>rb <n2> = randomball", "<d>customball <n2> = customball", "<d>cb <n2> = customball", "<d>lobby <n2> = lobby", "<d>lo <n2> = lobby", "<d>autosyncsys <n2> = autosyncsystem", "<d>asy <n2> = autosyncsystem", "<d>sync <n2> = sync", "<d>sy <n2> = sync", "<d>setsync <n2> = setsync", "<d>ssy <n2> = setsync", "<d>synctfm <n2> = synctfm", "<d>syt <n2> = synctfm", "<d>setplayerforce <n2> = setplayerforce", "<d>spf <n2> = setplayerforce", "<d>np <n2> = np", "<d>test <n2> = test", "<d>t <n2> = test", "<d>twoballs <n2> = twoballs", "<d>twb <n2> = twoballs", "<d>threeballs <n2> = threeballs", "<d>thb <n2> = threeballs", "<d>consumables <n2> = consumables", "<d>co <n2> = consumables", "<d>settings <n2> = settings", "<d>se <n2> = settings" },
  { "<vi>announcement / ann <n2> = announcement", "<vi>padmin <n2> = padmin",        "<vi>pa <n2> = padmin",    "<vi>pause <n2> = pause",            "<vi>p <n2> = pause",       "<vi>kick <n2> = kick",          "<vi>ki <n2> = kick",       "<vi>fleave <n2> = fleave",      "<vi>fl <n2> = fleave",     "<vi>ban <n2> = ban",                    "<vi>ba <n2> = ban",            "<vi>unban <n2> = unban",  "<vi>ub <n2> = unban", "<vi>killspec <n2> = killspec", "<vi>ks <n2> = killspec", "<vi>teleport <n2> = teleport", "<vi>tp <n2> = teleport",        "<vi>listsync <n2> = listsync", "<vi>lsy <n2> = listsync", "<vi>setlifes <n2> = setlifes", "<vi>sl <n2> = sl" }
}

-- NORMAL COMMANDS
