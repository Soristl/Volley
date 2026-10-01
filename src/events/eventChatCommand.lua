-- Dispatcher (Unified Command Table)
COMMANDS = {
  -- Everyone (Level 1)
  {
    ["commands"] = commandHandlers.cmdCommands,
    ["c"] = commandHandlers.cmdCommands,
    ["join"] = commandHandlers.cmdJoin,
    ["j"] = commandHandlers.cmdJoin,
    ["leave"] = commandHandlers.cmdLeave,
    ["l"] = commandHandlers.cmdLeave,
    ["lang"] = commandHandlers.cmdLang,
    ["la"] = commandHandlers.cmdLang,
    ["admins"] = commandHandlers.cmdAdmins,
    ["ads"] = commandHandlers.cmdAdmins,
    ["balls"] = commandHandlers.cmdBalls,
    ["b"] = commandHandlers.cmdBalls,
    ["votemap"] = commandHandlers.cmdVoteMap,
    ["vm"] = commandHandlers.cmdVoteMap,
    ["crown"] = commandHandlers.cmdCrown,
    ["cr"] = commandHandlers.cmdCrown,
    ["profile"] = commandHandlers.cmdProfile,
    ["pr"] = commandHandlers.cmdProfile,
    ["discord"] = commandHandlers.cmdDiscord,
    ["dc"] = commandHandlers.cmdDiscord,
    ["maps"] = commandHandlers.cmdMaps,
    ["m"] = commandHandlers.cmdMaps,
    ["setoffset"] = commandHandlers.cmdDisabledOrUnavailable,
    ["so"] = commandHandlers.cmdDisabledOrUnavailable,
    ["settransformduration"] = commandHandlers.cmdSetTransformDuration,
    ["std"] = commandHandlers.cmdSetTransformDuration,
  },
  -- Admin Commands (Level 2)
  {
    ["bgdiag"] = commandHandlers.cmdBackgroundDiagnostic,
    ["bgrefresh"] = commandHandlers.cmdBackgroundRefresh,
    ["resettimer"] = commandHandlers.cmdResetTimer,
    ["re"] = commandHandlers.cmdResetTimer,
    ["setduration"] = commandHandlers.cmdSetDuration,
    ["sd"] = commandHandlers.cmdSetDuration,
    ["skiptimer"] = commandHandlers.cmdSkipTimer,
    ["skip"] = commandHandlers.cmdSkipTimer,
    ["s"] = commandHandlers.cmdSkipTimer,
    ["stoptimer"] = commandHandlers.cmdStopTimer,
    ["stop"] = commandHandlers.cmdStopTimer,
    ["setmaxplayers"] = commandHandlers.cmdSetMaxPlayers,
    ["smp"] = commandHandlers.cmdSetMaxPlayers,
    ["setmap"] = commandHandlers.cmdSetMap,
    ["sm"] = commandHandlers.cmdSetMap,
    ["winscore"] = commandHandlers.cmdWinScore,
    ["w"] = commandHandlers.cmdWinScore,
    ["password"] = commandHandlers.cmdPassword,
    ["pw"] = commandHandlers.cmdPassword,
    ["randommap"] = commandHandlers.cmdRandomMap,
    ["ra"] = commandHandlers.cmdRandomMap,
    ["custommap"] = commandHandlers.cmdCustomMap,
    ["cm"] = commandHandlers.cmdCustomMap,
    ["setscore"] = commandHandlers.cmdSetScore,
    ["ssc"] = commandHandlers.cmdSetScore,

    ["4teamsmode"] = commandHandlers.cmdSetTeamMode,
    ["fourteamsmode"] = commandHandlers.cmdSetTeamMode,
    ["fom"] = commandHandlers.cmdSetTeamMode,
    ["2teamsmode"] = commandHandlers.cmdSetTeamMode,
    ["twoteamsmode"] = commandHandlers.cmdSetTeamMode,
    ["twm"] = commandHandlers.cmdSetTeamMode,
    ["3teamsmode"] = commandHandlers.cmdSetTeamMode,
    ["threeteamsmode"] = commandHandlers.cmdSetTeamMode,
    ["thm"] = commandHandlers.cmdSetTeamMode,
    ["realmode"] = commandHandlers.cmdSetTeamMode,
    ["rm"] = commandHandlers.cmdSetTeamMode,

    ["admin"] = commandHandlers.cmdAdmin,
    ["a"] = commandHandlers.cmdAdmin,
    ["unadmin"] = commandHandlers.cmdUnadmin,
    ["ua"] = commandHandlers.cmdUnadmin,

    ["randomball"] = commandHandlers.cmdRandomBall,
    ["rb"] = commandHandlers.cmdRandomBall,
    ["customball"] = commandHandlers.cmdCustomBall,
    ["cb"] = commandHandlers.cmdCustomBall,

    ["lobby"] = commandHandlers.cmdLobby,
    ["lo"] = commandHandlers.cmdLobby,

    ["autosyncsys"] = commandHandlers.cmdAutoSyncSystem,
    ["asy"] = commandHandlers.cmdAutoSyncSystem,
    ["sync"] = commandHandlers.cmdSync,
    ["sy"] = commandHandlers.cmdSync,
    ["setsync"] = commandHandlers.cmdSetSync,
    ["ssy"] = commandHandlers.cmdSetSync,
    ["synctfm"] = commandHandlers.cmdSyncTFM,
    ["syt"] = commandHandlers.cmdSyncTFM,

    ["setplayerforce"] = commandHandlers.cmdSetPlayerForce,
    ["spf"] = commandHandlers.cmdSetPlayerForce,
    ["np"] = commandHandlers.cmdNP,
    ["test"] = commandHandlers.cmdTest,
    ["t"] = commandHandlers.cmdTest,

    ["twoballs"] = commandHandlers.cmdTwoBalls,
    ["twb"] = commandHandlers.cmdTwoBalls,
    ["threeballs"] = commandHandlers.cmdThreeBalls,
    ["thb"] = commandHandlers.cmdThreeBalls,

    ["consumables"] = commandHandlers.cmdConsumables,
    ["co"] = commandHandlers.cmdConsumables,

    ["settings"] = commandHandlers.cmdSettings,
    ["se"] = commandHandlers.cmdSettings
  },
  -- Permanent Admins Only (Level 3+)
  {
    ["announcement"] = commandHandlers.cmdBroadcast,
    ["ann"] = commandHandlers.cmdBroadcast,
    ["padmin"] = commandHandlers.cmdPromoteInactivePerm,
    ["pa"] = commandHandlers.cmdPromoteInactivePerm,
    ["pause"] = commandHandlers.cmdPause,
    ["p"] = commandHandlers.cmdPause,
    ["setlifes"] = commandHandlers.cmdSetLifes,
    ["sl"] = commandHandlers.cmdSetLifes,
    ["kick"] = commandHandlers.cmdKick,
    ["ki"] = commandHandlers.cmdKick,
    ["fleave"] = commandHandlers.cmdForceLeave,
    ["fl"] = commandHandlers.cmdForceLeave,
    ["ban"] = commandHandlers.cmdBan,
    ["ba"] = commandHandlers.cmdBan,
    ["unban"] = commandHandlers.cmdUnban,
    ["ub"] = commandHandlers.cmdUnban,
    ["killspec"] = commandHandlers.cmdKillSpec,
    ["ks"] = commandHandlers.cmdKillSpec,
    ["teleport"] = commandHandlers.cmdTeleport,
    ["tp"] = commandHandlers.cmdTeleport,
    ["listsync"] = commandHandlers.cmdListSync,
    ["lsy"] = commandHandlers.cmdListSync
  }
}

-- Main handler
function eventChatCommand(name, c)
  if type(name) ~= "string" or not tfm.get.room.playerList[name] or playerBan[name] or playerLeft[name] or type(c) ~= "string" then return end

  local args = commandHandlers.split(c)
  if not args[1] then return end
  local cmdName = string.lower(args[1])
  args[1] = name

  local userLevel = USER_PERMISSIONS[name] or 1
  local max_depth = math.min(userLevel, 3)


  local handler = nil
  for i = max_depth, 1, -1 do
    if COMMANDS[i] and COMMANDS[i][cmdName] then
      handler = COMMANDS[i][cmdName]
      break
    end
  end

  if not handler then
    commandHandlers.cmdDisabledOrUnavailable(args)
    return false
  end


  args[#args + 1] = cmdName
  if handler==commandHandlers.cmdProfile or handler==commandHandlers.cmdLang or handler==commandHandlers.cmdSettings or handler==commandHandlers.cmdListSync then
    if not clubhouse.allowInput(name,false) then return end
  end
  handler(args)
end
