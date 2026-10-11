## 🧪 Technologies

This project was developed with the following technologies:

- [Lua]
- [Javascript]
- [NodeJS]

## 🚀 How to install and run the project

You must have Node JS installed on your machine. Visit the page to download [Node JS Website](https://nodejs.org/en/download/).

Clone the project

```bash
$ git clone https://github.com/Soristl/Volley.git

$ npm i (to install the dependencies)
$ npm run minify (to generate the volley.lua file)
```

With the volley.lua file generated, open Transformice, go to your tribe's house, type the command /lua and paste it into the game's code interface

## Room Creator

The first eligible player in a new room automatically becomes its Room Creator and receives regular admin permissions. The role appears in `!admins` / `!ads`. The Get Admin button and the old admin assignment based on the room name have been removed.

Regular admins cannot remove the Room Creator's admin rights. Temporary permanent and permanent admins (levels 3–5) can use `!unadmin Name#0000`, `!ua Name#0000`, or `!unadmin all`. Higher staff permissions are preserved.

The creator remains the same for the script session, including after leaving and returning. Rights removed by staff stay removed across rounds and reconnects; they can be explicitly granted again with `!admin`. There is no automatic transfer of ownership.

When the script starts with one eligible player already present, that player becomes the creator. If several players are already present, the script cannot reconstruct their arrival order and does not assign a creator. Test room creation in a new room or start the script while alone.

## Player profile

Press `P`, type `!profile` or `!pr` to open your player card. Use `!profile Name#0000` (case-insensitive) to inspect another player's profile from the current room session. A nickname without its discriminator is accepted when it matches exactly one player.

The card shows the player's role, matches, victories, win rate and room rank for Normal, 2 teams, 3 teams, 4 teams and Real mode. Rankings use the same ordering as the existing room leaderboard. Players without matches are unranked. Statistics cover the current script session and are not saved permanently.

Click a trophy to inspect its description and the viewed player's collection count. On your own profile, an earned trophy can still be displayed above your mouse using **Show trophy**. Mode tabs keep the same viewed player and do not reload trophy images. Closing with `P` or **Close**, opening another panel, and leaving the room clean up the profile.

## Room ranking

- Press `L` or use the menu to open the room ranking; press `L` again or click Close to dismiss it.
- Five mode tabs share the profile's visual style and show session matches, victories, win rate and wins by team. Rankings keep the existing order: most wins first, then fewer matches.
- Browse eight players per page in every mode, including 3 teams, without the old 30-player limit. Your position is highlighted and Find my position opens your page.
- Click a player name to view their profile. Only players with matches in the current room session are ranked; no global or persistent ranking is implied.

## Clubhouse interface

The lobby, team slots, menu, settings, map/ball selectors, profile, ranking, help, credits, Real Mode rules, synchronization chooser and victory display use the hosted Clubhouse assets. All 82 pack entries are mapped to 79 uploads by exact decoded image comparison; identical Menu titles reuse their upload. The podium artwork is registered as an available asset but does not add a new gameplay screen.

Map selection retains five cards with selection and voting. Ball selection has its own frame, larger name fields and selection only. Settings retain two pages with separate mode and court-size dropdowns. The five supported languages share a reviewed copy catalog and ten help pages each; player names, scores and actions remain dynamic text.

Images and text areas are tracked per viewer and panel. Closing a panel, switching selectors, changing language, leaving the room and changing maps release their owned images. Modal panels hide the lobby's JOIN controls until they close. The lobby artwork uses a background layer so it does not conceal mice. See the [Atelier801 image-layer documentation](https://atelier801.com/topic?f=5&p=1&t=451587).

Settings callbacks verify permissions and option indexes. The sync chooser handles zero to five candidates without indexing missing players. Existing Room Creator protection, profile lookup, trophies, ranking order and panel-opening cooldowns are preserved.

Click throttles are per player for every control, including Maps / Balls,
Settings, Menu, votes and the page-number chooser. Navigation keeps its 1000 ms
delay, other actions 1500 ms, and reopening the same panel 2000 ms. Closing stays
immediate. Rejected panel-opening retries do not extend the accepted-click clock.

Profile and ranking cleanup removes their registered text areas once. Closing all
panels restores lobby controls once after their state has been cleared, avoiding
redundant removals and restores during the return to the lobby.

Completed matches and `!lobby` use a staged return. During the existing five-second
victory interval, non-match panels are cleaned in batches; the victory, score,
podium, crowns and court remain visible. At its deadline the lobby is requested
immediately. Its confirmed delivery draws the shared artwork, then complete
personal controls are rebuilt for at most four players per 500 ms pass. A batch
also yields after a completed job if three milliseconds of elapsed time have
passed. This is a cooperative elapsed-time hint, not a measurement or guarantee
of Transformice's CPU quota. Existing images, coordinates and click cooldowns
are preserved. The initial script load keeps its existing startup path.

The 25-second lobby countdown starts when all queued controls are ready. Menus
and commands are suspended during this preparation; arrivals and
reconnections join the same queue, and departures invalidate their old jobs.
A new map delivery during drawing restarts preparation with fresh image handles.
Ordinary direct initialization or an explicit gameplay map load cancels old work.
With immediate simulated map delivery and no host-call execution cost, the
additional delay after the victory interval is 1 second for 8 players, 2.5 seconds
for 20 and 4 seconds for 30. Actual map loading and earlier time-budget yields
can extend it. The full transition still needs live server runtime validation.

Switching between Maps, Balls and Settings keeps the lobby controls hidden until
the destination panel is drawn. This avoids 60 temporary native UI/image calls
per tested switch without changing the final panel or its previews. Labels also
reuse their formatted output while their inputs, geometry, language and owned
text area remain unchanged; the cache is discarded with its panel.

Build with `npm run build` or `npm run minify`. Use `npm run watch` while editing the Lua sources.

## Production script

The generated `volley.lua` contains no optional performance profiler or event measurement
wrappers. The temporary regression tests used during development are kept outside this
repository and are never included in the game script. Map commands
`!np` / `!test`, personal background options and background refresh remain
available. Invalid XML warnings are retained to explain unusable map data.

## Maintenance boundaries

When a player hides map backgrounds in Advanced Options, reviewed invisible
floors use fourteen hosted material textures from `ui/floorVisuals.lua`. Native
XML material types keep their appearance; generic types 12/14 use visual
categories based on restitution and friction (trampoline, ice, chocolate, wood).
The artwork follows the XML center, size and rotation, with one image per floor
for that viewer. Physics coefficients and scoring eligibility remain unchanged.
Snowy Mountains slopes have separate rendering eligibility. Unsupported material
types retain the neutral fallback. The texture identifiers and rendering dimensions are embedded in `ui/floorVisuals.lua`.

| Concern | Owner |
| --- | --- |
| Match phases and map readiness | `gameState`, `gameRound`, `gameMaps` |
| Team membership and positions | `gameTeams` |
| Timer membership, label lookup and cancellation | `timer.lua` |
| Statistics and immutable ranking snapshots | `matchStatistics`, `rankingCache` |
| UI ownership and validated callbacks | `clubhouse`, `panels/lifecycle.lua` |

Timer removal must use the scheduler API so its label index and iteration
snapshot stay consistent. Duplicate labels resolve to the earliest live timer;
removing a label removes all its timers. A callback may create/cancel timers or
reenter the loop, so never mutate an iteration snapshot in place.

Rosters retain their table identity when reset. Ranking updates create new
arrays and rows because an active match may still use the previous crown
snapshot. UI-only state can be cleared on departure; session statistics,
permissions and deliberate reconnection guards must not be discarded with it.

Assign a roster slot whenever a player becomes active. Match participation scans
these bounded rosters and checks the gameplay flag, including departures still
pending their callback; it must not scan every player from the session history.
Team changes and reconnects still count once per match.

Map loading keeps the requested target separate from its original published
identity. A minimalist XML reload must preserve that identity for map helpers
and background lookup while matching the XML that was actually requested.
The Real Mode serve lock prevents transformations, but natural deaths still
receive their normal recovery timer while the gameplay map is ready.

Ball scoring, player spawns, court borders and floor artwork intentionally have
different XML eligibility rules. Keep their geometry and collision decisions
separate. A refactor should compare effects with the old implementation and
include the lifecycle transitions it touches, not only the ordinary path.

Scoring samples run every 1000 ms. Consecutive positions remain eligible for
interpolation for at most 2000 ms; ball replacement, pause and map changes still
invalidate the old trajectory. This reduces scoring checks, not every eventLoop
task, and can increase the delay before a point is displayed.

The nine Myzk XL courts now place their invisible ball catcher at Y1100 (top 1095)
with zero ground restitution. All 45 hosted layouts have their new user-provided
map codes registered, including Crystal Rift 3T at @7985453. Static background
aliases preserve the existing art for all 54 prepared XML layouts.

## 💻 Project

Volley is currently a semi-official Transformice module created to bring fun to people.

## 📝 License

This project is licensed under the MIT License. See the file [LICENSE](https://github.com/Soristl/Volley/blob/main/LICENSE) for more details.
