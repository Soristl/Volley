-- Private service bindings for the assembled Lua chunk. Load this file before
-- timers, callbacks and implementations so earlier functions capture these locals.
-- Each implementation initializes its service at the original point in the build;
-- forward declarations must remain nil until then. Host event callbacks stay global.
local gameState, gameTeams, gameBalls, gameScores, gameLives
local gameMaps, gamePoints, gameRound, groundProfile, lobbyTransition
local mapBackgrounds, floorVisuals, clubhouse, gameCrowns

-- Real serve methods are defined across the leave, serve and ball modules.
local realServe = {}

-- Internal APIs are private to this assembled chunk. Methods attach at their original load positions.
-- Scheduling API and retained timer handles; active timers remain private to timer.lua.
local timers = { handles = {} }
-- Map requests and readiness confirmation share the scheduler's map state.
local mapLoad = {}
-- Coordinates match completion, court reduction and lobby initialization.
local matchLifecycle = {}
-- Player initialization, cleanup and gameplay actions.
local playerRuntime = {}
-- Persistent room choices, permissions and lobby configuration.
local roomConfig = { lobbySlots = {} }
-- Synchronization selection and latency reporting.
local roomSync = {}
-- Voting operations; round counters live in gameState.voting.
local mapVoting = {}
-- Text formatting helpers without mutable state.
local textUtil = {}
-- Per-player tables. Each leaf keeps its own initialization/reset boundary.
local playerState = { consumables = {} }
