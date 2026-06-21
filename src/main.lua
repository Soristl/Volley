-- from https://www.lua.org/pil/11.4.html
local branch = "test"
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
USER_PERMISSIONS = {}

tfm.exec.chatMessage = print
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

local regex = "#volley%d+([%+_]*[%w_#]+)"
local getRoomAdmin = string.match(tfm.get.room.name, regex)

if getRoomAdmin ~= nil then
  USER_PERMISSIONS[getRoomAdmin] = 2
else
  getRoomAdmin = ''
end

tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disablePhysicalConsumables(true)
tfm.exec.disableAfkDeath(true)
tfm.exec.setRoomMaxPlayers(16)
system.disableChatCommandDisplay(nil, true)
tfm.exec.disableMortCommand(true)

local playerCanTransform = {}
local playerForce = {}
local playerBan = {}
local playerBanHistory = {}
local playerInGame = {}
local countId = 1
local playerPhysicId = {}
local playerLanguage = {}
local killSpecPermanent = false
local autosync = true

local x = { 100, 280, 280, 640, 460, 460, 100, 100, 280, 640, 460, 640 }
local y = { 100, 100, 160, 100, 100, 160, 160, 220, 220, 160, 220, 220 }
local teamsScores = { ['red'] = 0, ['blue'] = 0 }
-- local teamsScores['red'] = 0
-- local teamsScores['blue'] = 0
local ball_id = 6
local ballOnGame = false
local ballOnGame2 = false
local playerConsumable = {}
local playerConsumableItem = {}
local playerConsumables = {}
local playerLeftRight = {}
local playerConsumableKey = {}
local ballOnGameTwoBalls = {}
local ballsId = {}
local gameStats = { gameMode = '' }
local pagesList = {}
local mapsVotes = {}
local canVote = {}
local playerOutOfCourt = {}
local showOutOfCourtText = {}
local globalSettings = { mode = 'Normal mode', twoBalls = false, randomBall = false, randomMap = false, mapType = '', consumables = false, threeBalls = false, minimalist = false, minimalistToggleMap = true }
local settings = {}
local settingsMode = {}
local playersNormalMode = {}
local rankNormalMode = {}
local playersOnGameHistoric = {}
local pageNormalMode = {}
local playerRankingMode = {}
local playersFourTeamsMode = {}
local rankFourTeamsMode = {}
local pageFourTeamsMode = {}
local rankTwoTeamsMode = {}
local playersTwoTeamsMode = {}
local pageTwoTeamsMode = {}
local rankRealMode = {}
local playersRealMode = {}
local pageRealMode = {}
local rankThreeTeamsMode = {}
local playersThreeTeamsMode = {}
local pageThreeTeamsMode = {}
local openRank = {}
local countMatches = 0
local playerLastMatchCount = {}
local playerLeft = {}

local showCrownImages = {}
local redCrown = { '15296835cdd.png', '1529683757b.png', '15296838f74.png', '1529683a830.png', '1529683c1e0.png',
  '1529655c3e4.png', '1529655df16.png', '1529655fb1b.png', '152965616ff.png', '15296563a9e.png' }
local blueCrown = { '1529682cc1e.png', '1529682e815.png', '15296830d1a.png', '1529683291f.png', '15296834389.png',
  '1529653b65f.png', '1529653d855.png', '1529653fa44.png', '15296541aed.png', '15296543994.png' }
local yellowCrown = { '192e02e0140.png', '192e02e18b0.png', '192e02e3022.png', '192e02e4795.png', '192e02e5f06.png',
  '192e02e767b.png', '192e02e8deb.png', '192e02ea7b1.png', '192e02ebf90.png', '192e02ed701.png' }
local greenCrown = { '192e02d16d0.png', '192e02d2e3f.png', '192e02d45b2.png', '192e02d5d22.png', '192e02d7494.png',
  '192e02d8c06.png', '192e02da37a.png', '192e02dbaea.png', '192e02dd25c.png', '192e02de9ce.png' }
local rankCrown = {}

local playerAchievements = {}
local playerAchievementsImages = {}
local playerTrophyImage = {}
local isOpenProfile = {}

local selectMapOpen = {}
local selectMapPage = {}
local selectMapImages = {}
local customMapCommand = {}

local lobbySpawn = {}
local playersSpawn400 = {}
local playersSpawn800 = {}
local playersSpawn1200 = {}
local playersSpawn1600 = {}
local playersAfk = {}
local pagePlayerSettings = {}
local maxPageSettings = 2
local threeTeamsMode = {id = {1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13}, x = {100, 280, 460, 640, 100, 280, 460, 640, 100, 280, 460, 640}, y = {100, 100, 100, 100, 160, 160, 160, 160, 220, 220, 220, 220}}
local isPlayerDead = {}
local playerPressSpace = {}
local webY = 460
local teamPointsArea1 = {}
local teamPointsArea2 = {}
local teamPointsArea3 = {}
local teamPointsArea4 = {}

local gameTimeEnd = os.time() + 5000

-- local keys = {32, 0, 1, 2, 3, 49, 50, 51, 52, 55, 56, 57, 48, 77, 76, 80}

GROUND_LINE_Y = 370

-- Here there is a crucial possible optimization, instead of
-- creating a new dictionary for everything, it will be better
-- to have a single "players" global variable.
-- The new players table has a copy of each player
-- inside the playerList, updated with the NewPlayer and PlayerLeft
-- loops.

local players = {}
local function setPlayerData(name)
  local playersList = tfm.get.room.playerList
  if players[name] then return end

  players[name] = {
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

  bindKeys(name)
  -- This copy makes possible to set custom keybinds
  -- players[name][KEYS] = KEYS
end

local function initPlayersData()
  local playersList = tfm.get.room.playerList

  for key, _ in pairs(playersList) do
    if type(key) == "string" then
      setPlayerData(key)
    end
  end
end

initPlayersData()

for name, data in pairs(tfm.get.room.playerList) do
  customMapCommand[name] = true
  selectMapOpen[name] = false
  selectMapPage[name] = 1
  selectMapImages[name] = {}

  isOpenProfile[name] = false
  playerTrophyImage[name] = 0

  if playerAchievements[name] == nil then
    playerAchievements[name] = {
      [1] = { image = "img@193d6763c82", quantity = 0 },
      [2] = { image = '19636907e9e.png', quantity = 0 },
      [3] = { image = "197d9272515.png", quantity = 0 },
      [4] = { image = "1984ac78d52.png", quantity = 0 },
      [5] = { image = "1984ac773d3.png", quantity = 0 }
    }
  end

  pagePlayerSettings[name] = 1
  playersAfk[name] = os.time()
  playerAchievementsImages[name] = {}
  showCrownImages[name] = true
  playersNormalMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0 }
  pageNormalMode[name] = 1
  playersFourTeamsMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0, winsYellow = 0, winsGreen = 0 }
  pageFourTeamsMode[name] = 1
  playersThreeTeamsMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0, winsGreen = 0 }
  pageThreeTeamsMode[name] = 1
  playersTwoTeamsMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0 }
  pageTwoTeamsMode[name] = 1
  playersRealMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0 }
  pageRealMode[name] = 1
  playerRankingMode[name] = "Normal mode"
  playerLeft[name] = false
  openRank[name] = false
  settings[name] = false
  settingsMode[name] = false
  playerLanguage[name] = { tr = trad, name = name }
  playerOutOfCourt[name] = false
  playerCanTransform[name] = true
  playerInGame[name] = false
  playerPhysicId[name] = 0
  playerBan[name] = false
  playerBanHistory[name] = ""
  showOutOfCourtText[name] = false
  isPlayerDead[name] = false
  playerPressSpace[name] = false

  tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage, name)
  tfm.exec.chatMessage("<n>#Volley Version: <j>" .. gameVersion, name)
  tfm.exec.chatMessage("<n>Join our #Volley Discord server: <ce>https://discord.com/invite/pWNTesmNhu<n><br>", name)

  if tfm.get.room.isTribeHouse then
    if tfm.get.room.name:sub(3) == tfm.get.room.playerList[name].tribeName then
      USER_PERMISSIONS[name] = USER_PERMISSIONS[name] or 2
      if name == "Tonycoolnees#0000" then
        USER_PERMISSIONS["Tonycoolnees#0000"] = 3
      end
    end
  end
end

firstRun = true