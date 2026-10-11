-- Private service bindings for the assembled Lua chunk. Load this file before
-- timers, callbacks and implementations so earlier functions capture these locals.
-- Each implementation initializes its service at the original point in the build;
-- forward declarations must remain nil until then. Host event callbacks stay global.
local gameState, gameTeams, gameBalls, gameScores, gameLives
local gameMaps, gamePoints, gameRound, groundProfile, lobbyTransition
local mapBackgrounds, floorVisuals, clubhouse, gameCrowns

-- Real serve methods are defined across the leave, serve and ball modules.
local realServe = {}
