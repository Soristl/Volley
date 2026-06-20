--[[
  skill_tree[1] = {0, 0, 0, 0, 0, 0}
  skill_tree[2] = {0, 0, 0, 0, 0, 0}
  skill_tree[3] = {0, 0, 0, 0, 0, 0}
]]


-- local playersTotalWins[name] = playersNormalMode[name].wins + playersFourTeamsMode[name].wins + playersThreeTeamsMode[name].wins + playersRealMode[name].wins

-- handler called on menu
local function upgrade_skill(tree_index, skill_index)
  return tree_index, skill_index
end

local SKILL_TREE_WINDOW_ID = 7331

local function openSkillTreeUI()
  ui.addTextArea(SKILL_TREE_WINDOW_ID, "<font size = 14px>Debug zone",
    nil, -310, 5, 300, 600,
    0x000000, 0x00ffaa, 0.9,
    true)
  -- menu here
end

local function updateSkillTree()
  return 0
end

local function updateSkillTreeUI(text, target)
  ui.updateTextArea(SKILL_TREE_WINDOW_ID, text, target)
end
