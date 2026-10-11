-- from https://www.lua.org/pil/11.4.html
local branch = "production"
--[[

local admins =
{
  ["Refletz#6472"] = true,
  ["Soristl1#0000"] = true,
  ["Axeldoton#0000"] = true,
  ["Nagi#6356"] = true,
  ["Wreft#5240"] = true,
  ["Lylastyla#0000"] = true,
  ["Tanarchosl#4785"] = true,
  ["Sadzia#0000"] = true
}

local permanentAdmins =
{
  "Refletz#6472",
  "Lylastyla#0000",
  "Sadzia#0000"
}

local inactivePermanentAdmins = {
  "Soristl1#0000",
  "Nagi#6356",
  "Wreft#5240",
  "Tanarchosl#4785",
  "Axeldoton#0000",
  "Rowed#4415"
}

local temporaryPermanentAdmins = {
  "Anubis#0186"
}
]]

-- load user perms from map
--[[
local USER_PERMISSIONS = {
  -- permanent admins
  ["Refletz#6472"] = 5,
  ["Wreft#5240"] = 5,
  ["Lylastyla#0000"] = 5,
  -- inactive permanents
  ["Soristl1#0000"] = 4,
  ["Tanarchosl#4785"] = 4,
  ["Nagi#6356"] = 4,
  -- temporary permanents
  ["Anubis#0186"] = 3,
  -- regular admins
  ["Tanatosl#0000"] = 2,
  -- normal player
  ["Tanathree#0000"] = 1
}
]]
roomConfig.permissions = {}

if branch == "test" then
  tfm.exec.chatMessage = print
end

local trad = ""

if tfm.get.room.language == "br" then
  trad = lang.br
elseif tfm.get.room.language == "en" then
  trad = lang.en
elseif tfm.get.room.language == "ar" then
  trad = lang.ar
elseif tfm.get.room.language == "fr" then
  trad = lang.fr
elseif tfm.get.room.language == "pl" then
  trad = lang.pl
else
  trad = lang.en
end

-- Session ownership is separate from the existing permission levels.
roomConfig.creator = { name = nil, adminRevoked = false, selectionClosed = false }

tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disablePhysicalConsumables(true)
tfm.exec.disableAfkDeath(true)
tfm.exec.setRoomMaxPlayers(16)
system.disableChatCommandDisplay(nil, true)
tfm.exec.disableMortCommand(true)

playerState.canTransform = {}
playerState.force = {}
playerState.ban = {}
playerState.banHistory = {}
playerState.inGame = {}
playerState.nextGroundId = 100000 -- Player grounds: separate from XML grounds and 99990..99998 map helpers.
playerState.physicId = {}
playerState.language = {}
roomConfig.killSpectators = false
roomConfig.autoSync = true

roomConfig.lobbySlots.x = { 100, 280, 280, 640, 460, 460, 100, 100, 280, 640, 460, 640 }
roomConfig.lobbySlots.y = { 100, 100, 160, 100, 100, 160, 160, 220, 220, 160, 220, 220 }
playerState.consumables.ready = {}
playerState.consumables.item = {}
playerState.consumables.objects = {}
playerState.lastDirection = {}
playerState.consumables.key = {}
-- Only the current mode exists before the first lobby reset. Other leaves stay nil.
gameState.match = {
    mode = {
      gameMode = ''
    },
    rules = {},
    balls = {},
    maps = {},
    round = {},
    court = {},
    real = {}
  }
-- Per-player interface navigation and presentation state. Keep each field
-- initialized and cleared at its own lifecycle boundary; ranking pages survive rejoin.
local uiState = {}
uiState.pagesList = {}
gameState.voting.counts = {}
gameState.voting.eligible = {}
playerState.outOfCourt = {}
playerState.outOfCourtText = {}
-- Choices retained across rounds; gameState.match holds the active round values.
roomConfig.settings = { mode = 'Normal mode', twoBalls = false, randomBall = false, randomMap = false, mapType = '', consumables = false, threeBalls = false, minimalist = false, minimalistToggleMap = true }
uiState.settings = {}
uiState.settingsMode = {}
-- Session ranking owns statistics, sorted snapshots and match accounting.
-- Statistics retain their identity across rounds; rebuilt ranks replace snapshots.
-- The current crown can retain an older snapshot until the next match.
-- Cache and accounting methods attach later, before init starts the lobby.
local sessionRanking = { stats = {}, ranks = {}, update = {} }
sessionRanking.stats.normal = {}
sessionRanking.ranks.normal = {}
uiState.pageNormalMode = {}
uiState.playerRankingMode = {}
sessionRanking.stats.four = {}
sessionRanking.ranks.four = {}
uiState.pageFourTeamsMode = {}
sessionRanking.ranks.two = {}
sessionRanking.stats.two = {}
uiState.pageTwoTeamsMode = {}
sessionRanking.ranks.real = {}
sessionRanking.stats.real = {}
uiState.pageRealMode = {}
sessionRanking.ranks.three = {}
sessionRanking.stats.three = {}
uiState.pageThreeTeamsMode = {}
uiState.openRank = {}
uiState.rankingState = {}
playerState.left = {}

playerState.crownVisible = {}
local redCrown = { '1a078540734.png', '1a078542676.png', '1a078545557.png', '1a078547498.png', '1a0785493dc.png',
  '1a07854baed.png', '1a07854da2f.png', '1a07854f19f.png', '1a078550912.png', '1a078552083.png' }
local blueCrown = { '1a078523255.png', '1a0785249c6.png', '1a078526139.png', '1a0785278ab.png', '1a07852901b.png',
  '1a07852a78c.png', '1a07852befe.png', '1a07852d670.png', '1a07852ede3.png', '1a078530553.png' }
local yellowCrown = { '1a0785537f5.png', '1a078554f67.png', '1a0785566d6.png', '1a078557e46.png', '1a0785595b7.png',
  '1a07855ad29.png', '1a07855c49a.png', '1a07855dc0b.png', '1a07855f37c.png', '1a078560aeb.png' }
local greenCrown = { '1a078531cc4.png', '1a078533435.png', '1a078534ba9.png', '1a07853631b.png', '1a078537a8c.png',
  '1a0785391fd.png', '1a07853a96e.png', '1a07853c0e1.png', '1a07853d852.png', '1a07853efc2.png' }
sessionRanking.crown = {}

playerState.achievements = {}
uiState.playerAchievementsImages = {}
playerState.trophyImage = {}
uiState.isOpenProfile = {}
roomConfig.statisticsCutoff = 0

uiState.selectMapOpen = {}
uiState.selectMapPage = {}
uiState.selectMapImages = {}
uiState.selectBallOpen = {}
uiState.selectBallPage = {}
uiState.customMapCommand = {}

gameState.court.lobbySpawns = {}
gameState.court.playerSpawns[1] = {}
gameState.court.playerSpawns[2] = {}
gameState.court.playerSpawns[3] = {}
gameState.court.playerSpawns[4] = {}
playerState.afk = {}
uiState.pagePlayerSettings = {}
roomConfig.maxSettingsPages = 2
roomConfig.lobbySlots.threeTeams = {id = {1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13}, x = {100, 280, 460, 640, 100, 280, 460, 640, 100, 280, 460, 640}, y = {100, 100, 100, 100, 160, 160, 160, 160, 220, 220, 220, 220}}
playerState.dead = {}
playerState.pressSpace = {}
gameState.court.webY = 460
gameState.court.pointAreas[1] = {}
gameState.court.pointAreas[2] = {}
gameState.court.pointAreas[3] = {}
gameState.court.pointAreas[4] = {}



-- local keys = {32, 0, 1, 2, 3, 49, 50, 51, 52, 55, 56, 57, 48, 77, 76, 80}

gameState.court.groundLineY = 368

-- Player records retain skills and session data across reconnects.
-- Gameplay, UI and ranking tables keep their separate reset lifetimes.

playerState.data = {}
function playerRuntime.initializeData(name)
  local playersList = tfm.get.room.playerList
  if playerState.data[name] then return false end

  playerState.data[name] = {
    playerName = name,

    -- Related to skills:
    skills = { 'Dash', 'Hop', 'Vampire' },
    cooldowns = { 5000, 10000, 15000 },
    skillPoints = 0,
    unlocked = {},
    equipped = { 'Locked', 'Locked', 'Locked' },

    -- Copy from api
    isVampire = false,
    id = playersList[name].id,
    x = playersList[name].x,
    y = playersList[name].y,
    vx = playersList[name].vx,
    vy = playersList[name].vy,
    averageLatency = playersList[name].averageLatency,

    -- utils
    offsets = { x = 15, y = 1 },
    transformDuration = 3
  }

  playerRuntime.bindKeys(name)
  -- This copy makes possible to set custom keybinds
  -- players[name][KEYS] = KEYS
  return true
end

function playerRuntime.createAchievements()
  return {
    [1] = { image = "img@193d6763c82", quantity = 0 },
    [2] = { image = '19636907e9e.png', quantity = 0 },
    [3] = { image = "197d9272515.png", quantity = 0 },
    [4] = { image = "1984ac78d52.png", quantity = 0 },
    [5] = { image = "1984ac773d3.png", quantity = 0 },
    [6] = { image = "19fa0498eb4.png", quantity = 0 }
  }
end

function playerRuntime.createStats(name, teamCount)
  local stats = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0 }
  if teamCount == 4 then stats.winsYellow = 0 end
  if teamCount == 3 or teamCount == 4 then stats.winsGreen = 0 end
  return stats
end

function playerRuntime.initializeSession()
  local playersList = tfm.get.room.playerList

  for key, _ in pairs(playersList) do
    if type(key) == "string" then
      playerRuntime.initializeData(key)
    end
  end
end

playerRuntime.initializeSession()

for name, data in pairs(tfm.get.room.playerList) do
  uiState.customMapCommand[name] = true
  uiState.selectMapOpen[name] = false
  uiState.selectMapPage[name] = 1
  uiState.selectMapImages[name] = {}
  uiState.selectBallOpen[name] = false
  uiState.selectBallPage[name] = 1

  uiState.isOpenProfile[name] = false
  playerState.trophyImage[name] = 0

  if playerState.achievements[name] == nil then
    playerState.achievements[name] = playerRuntime.createAchievements()
  end

  uiState.pagePlayerSettings[name] = 1
  playerState.afk[name] = os.time()
  uiState.playerAchievementsImages[name] = {}
  playerState.crownVisible[name] = true
  sessionRanking.stats.normal[name] = playerRuntime.createStats(name)
  uiState.pageNormalMode[name] = 1
  sessionRanking.stats.four[name] = playerRuntime.createStats(name, 4)
  uiState.pageFourTeamsMode[name] = 1
  sessionRanking.stats.three[name] = playerRuntime.createStats(name, 3)
  uiState.pageThreeTeamsMode[name] = 1
  sessionRanking.stats.two[name] = playerRuntime.createStats(name)
  uiState.pageTwoTeamsMode[name] = 1
  sessionRanking.stats.real[name] = playerRuntime.createStats(name)
  uiState.pageRealMode[name] = 1
  uiState.playerRankingMode[name] = "Normal mode"
  playerState.left[name] = false
  uiState.openRank[name] = false
  uiState.settings[name] = false
  uiState.settingsMode[name] = false
  playerState.language[name] = { tr = trad, name = name }
  playerState.outOfCourt[name] = false
  playerState.canTransform[name] = true
  playerState.inGame[name] = false
  playerState.physicId[name] = 0
  playerState.ban[name] = false
  playerState.banHistory[name] = ""
  playerState.outOfCourtText[name] = false
  playerState.dead[name] = false
  playerState.pressSpace[name] = false

  tfm.exec.chatMessage(playerState.language[name].tr.welcomeMessage, name)
  tfm.exec.chatMessage("<n>#Volley Version: <j>" .. gameVersion, name)
  tfm.exec.chatMessage("<n>Join our #Volley Discord server: <ce>https://discord.com/invite/pWNTesmNhu<n><br>", name)

  if tfm.get.room.isTribeHouse then
    if tfm.get.room.name:sub(3) == tfm.get.room.playerList[name].tribeName then
      roomConfig.permissions[name] = roomConfig.permissions[name] or 2
    end
  end
end

roomConfig.firstRun = true
local panelInput = {}
do
  local profileKeyTime = {}
  local rankKeyTime = {}
  local panelOpenTime = {}

  -- 2s anti-spam cooldown per panel-opening button (closing stays instant)
  local panelOpening = {menuOpen=true,howToPlay=true,credits=true,realmode=true,
    selectMap=true,selectBall=true,settings=true}
  local function panelOpenBlocked(name, panel)
    local times = panelOpenTime[name]
    local lastOpen = times and times[panel]
    return lastOpen and os.time() - lastOpen < 2000
  end

  function panelInput.consumeProfileOpening(name)
    if profileKeyTime[name] and os.time() - profileKeyTime[name] < 2000 then return false end
    profileKeyTime[name] = os.time()
    return true
  end

  function panelInput.consumeRankingOpening(name)
    if rankKeyTime[name] and os.time() - rankKeyTime[name] < 2000 then return false end
    rankKeyTime[name] = os.time()
    return true
  end

  function panelInput.acceptPanelInput(name, closing, callback)
    -- Check both personal delays before recording an accepted opening.
    -- A rejected retry must not postpone this player's next permitted click.
    if panelOpening[callback] and panelOpenBlocked(name, callback) then return false end
    if not clubhouse.allowInput(name, closing, callback) then return false end
    if panelOpening[callback] then
      panelOpenTime[name] = panelOpenTime[name] or {}
      panelOpenTime[name][callback] = os.time()
    end
    return true
  end

  function panelInput.clearPlayer(name)
    profileKeyTime[name]=nil
    rankKeyTime[name]=nil
    panelOpenTime[name]=nil
  end
end
