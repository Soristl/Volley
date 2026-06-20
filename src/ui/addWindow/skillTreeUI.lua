local SKILLS = {
  root = {
    name = "🌱 Root Growth",
    desc = "Increases ground grip",
    baseCost = 5,
    costPerLevel = 3,
    requires = nil
  },
  branch = {
    name = "🌿 Branch Extend",
    desc = "Shamans: +1 object range/lvl",
    baseCost = 8,
    costPerLevel = 4,
    requires = "root"
  },
  leaf = { name = "🍃 Leaf Armor", desc = "-10% fall damage/lvl", baseCost = 12, costPerLevel = 5, requires = "branch" },
  fruit = { name = "🍎 Fruit Harvest", desc = "+1 pt every 3 rounds", baseCost = 20, costPerLevel = 10, requires = "leaf" },
}

local CONFIG = {
  TEXT_AREA_ID = 900,
  STARTING_POINTS = 10,
  MAX_SKILL_LEVEL = 5,
  UI_POS = { x = 200, y = 100, w = 420, h = 280 },
  COLORS = {
    bg = '#1a1a2e',
    text = '#FFFFFF',
    accent = '#4a4a6a',
    gold = '#FFD700',
    success = '#4CAF50',
    locked = '#666666',
    warning = '#FF9800',
    error = '#FF6B6B'
  },
  DEBUG = false
}

-- Quick lookup table for O(1) ID access where needed
local SKILL_LOOKUP = {}
for i = 1, #SKILLS do
  SKILL_LOOKUP[SKILLS[i].id] = SKILLS[i]
end

-- 🔹 LOCAL DATA STORE (Fully compatible, no restricted APIs)
local PLAYER_DATA = {}

local function initPlayerSkillsData(playerName)
  PLAYER_DATA[playerName] = {
    points = CONFIG.STARTING_POINTS,
    unlocked = {},
    fruitRounds = 0
  }
  for i = 1, #SKILLS do
    local skill = SKILLS[i]
    PLAYER_DATA[playerName].unlocked[skill.id] = { level = 0, unlocked = (skill.requires == nil) }
  end
  if CONFIG.DEBUG then print("[DEBUG] Initialized data for " .. playerName) end
end

local function getData(playerName)
  if not PLAYER_DATA[playerName] then
    initPlayerSkillsData(playerName)
  end
  return PLAYER_DATA[playerName]
end

local function getSkillCost(id, lvl)
  local s = SKILL_LOOKUP[id]
  return s and (s.baseCost + (lvl * s.costPerLevel)) or math.huge
end

--Definition
local function buildUI(playerName)
  local data = getData(playerName)
  local pts = data.points or 0
  local lines = {}

  -- Header
  lines[1] = "<p align='center'><font size='16px'>Skill Tree<br>"


  for i = 1, #SKILLS do
    local skill = SKILLS[i]
    local id = skill.id
    local sData = data.unlocked[id] or { level = 0, unlocked = false }
    local cost = getSkillCost(id, sData.level)
    local canBuy = pts >= cost and not (sData.level >= CONFIG.MAX_SKILL_LEVEL)
    local hasReq = not skill.requires or (data.unlocked[skill.requires]
      and data.unlocked[skill.requires].level > 0)

    local btn
    if not hasReq or not sData.unlocked then
      btn = "<font color='" .. CONFIG.COLORS.locked .. "'>🔒 LOCKED</font>"
    elseif sData.level >= CONFIG.MAX_SKILL_LEVEL then
      btn = "<font color='" .. CONFIG.COLORS.success .. "'>★ MAXED</font>"
    elseif canBuy then
      btn = string.format("<a href='event:buy:%s'><font color='" .. CONFIG.COLORS.success .. "'>[BUY %d]</font></a>", id,
        cost)
    else
      btn = string.format("<font color='" .. CONFIG.COLORS.warning .. "'>[Need %d]</font>", cost - pts)
    end

    --[[
        lines[2] = string.format("%s %s <font size='8' color='#AAA'>(Lv.%d)</font><br/>
                                              <font size='7' color='#CCC'>&nbsp;&nbsp;%s</font><br/>",
                                              btn, skill.name, sData.level, skill.desc)
        ]]
  end

  lines[3] = "<br/><p align='center'><a href='event:refresh'><font color='" ..
      CONFIG.COLORS.accent ..
      "'>[⟳ Refresh]</font></a> | <a href='event:close'><font color='" ..
      toHex(CONFIG.COLORS.error) .. "'>[✕ Close]</font></a></p>"

  ui.addTextArea(CONFIG.TEXT_AREA_ID,
    table.concat(lines),
    playerName,
    CONFIG.UI_POS.x,
    CONFIG.UI_POS.y,
    CONFIG.UI_POS.w,
    CONFIG.UI_POS.h,
    CONFIG.COLORS.bg,
    CONFIG.COLORS.text,
    0.85, true)
end
