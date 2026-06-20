# Changelog - [Volley] - Version 2.3.2v

## Refactor: Core Command System Architecture
*   Implemented a new tiered permission system for commands (`Everyone`, `Admin`, `Permanent Admin`), managed by a `COMMANDS` lookup table within `eventChatCommand.lua`.
*   Refactored the main command dispatcher (`eventChatCommand`) to use the new permission tiers for efficient command resolution.
*   Dynamically generate help messages (`!commands`) based on the user's permission level.
*   Integrated a new, explicit `USER_PERMISSIONS` table for managing admin levels (Regular, Temp Perm, Perm Admin), replacing older methods.
*   Updated numerous command implementations (`!join`, `!leave`, `!admin`, `!unadmin`, `!setteamsmode`, `!setlifes`, `!kick`, `!setduration`, `!setmaxplayers`, `!custommap`, `!randomball`, etc.) to align with the new permission checks and centralized game state variables (`gameStats`).

## Feature: New Permission Levels and Admin Management
*   Defined distinct permission levels: Regular Player (1), Admin (2), Temporary Permanent Admin (3), Inactive Permanent Admin (4), Active Permanent Admin (5).
*   Added logic for inactive permanent admins to reactivate (`!padmin`) and for active permanent admins to grant temporary perm admin status.
*   Refined `!admin` and `!unadmin` commands to respect the new permission hierarchy.

## Feature: Localization Integration
*   Began integrating a new `src/translations.lua` system into command responses and UI elements (like `windowForHelp.lua`), preparing for multi-language support.

## Refactor: Data and Configuration Management
*   Removed the monolithic `src/maps.lua` file.
*   Moved map data and related configurations (like `balls.lua`, `sync.lua`, `maps.lua` - the new file) into the new `src/globals/` directory.
*   Introduced a new configuration system in `src/configuration/`.
*   Introduced a globals management system in `src/globals/`.

## Feature: Initial Skill System Framework
*   Added initial files and UI components (`src/functions/game/skills/`, `src/ui/addWindow/skillTreeUI.lua`, `src/ui/addWindow/keybindsUI.lua`, `src/functions/utils/keybinds.lua`) laying the groundwork for a player skill system (not implemented yet).

## Refactor: UI Synchronization System
*   Refactored and renamed the UI synchronization system from `src/ui/addWindow/windowUiSync.lua` to `src/ui/addWindow/windowUISync.lua`.

## Enhancement: Game Logic Core Mechanics (`verifyIsPoint` suite) - Point Checking
*   Heavily refactored the core scoring/life-loss logic across multiple files (`src/functions/game/verifyIsPoint/*.lua`) to centralize and refine how points/lives are determined.
*   The main verification loop (`verifyIsPoint.lua`) now uses a timer (`verifyBallCoordinates`) and calls `setLostLife()` based on the `gameStats.teamsMode` flag.
*   Centralized life/duration management using the `gameStats` table.
*   Significantly updated `setLostLife.lua` (899+ lines changed) to handle life deduction, team elimination, ball respawning, and UI updates for various game modes (2, 3, 4 teams, small maps). This file now contains the core logic for checking ball positions against boundaries and triggering life loss.
*   Updated mode-specific verification files (`verifyIsPointRealMode.lua`, `verifyIsPointThreeTeamsMode.lua`, `verifyIsPointTwoTeamMode.lua`) to potentially contain unique rules or delegate to `setLostLife` for mode-specific outcomes (e.g., winner determination in Real/Three Teams mode).
*   Updated `isBallOnGround.lua` (16 lines changed) with refined logic for detecting if the ball has stopped moving, crucial for determining valid scoring.
*   Updated `updateBoundariesFromMap.lua` to correctly set the court boundaries (`gameStats.redX`, `gameStats.blueX`, etc.) based on the current map and game mode, ensuring accurate point checks.

## Enhancement: Game Logic and UI Refinements
*   Made significant updates across numerous other game logic modules (`join/`, `leave/`, `miceSpawn/`, `spawnBall/`, `realMode/`, `ranking/`, `selectMap.lua`).
*   Updated lobby UI update logic (`src/ui/addWindow/lobby/updateLobbyTextAreas.lua`) and related callback handling (`eventTextAreaCallback.lua`) to reflect new game mechanics, state management (`gameStats`), and UI interactions (settings, map selection).
*   Added and updated utility functions (e.g., `getModesText.lua`, `getQuantityPlayers.lua`, `isTemporaryPermanentAdmin.lua`, `split.lua`) for improved code clarity and reusability.
*   Integrated keyboard input handling (`eventKeyboard.lua`) with player offsets and transformation logic, preparing for skill system hooks (`handleSkills` placeholder).

## Refactor: Dependency Updates
*   Updated build and asset combination scripts (`build.js`, `combine.js`) to accommodate the new project structure (new directories/files, removed `maps.lua`).

## Other Changes
*   Various UI window management and removal functions (`src/ui/removeWindow/`) were updated, likely reflecting changes in how UI elements are displayed and closed.
*   Added mockup/api abstraction file (`src/tfm_api_mockup.lua`).