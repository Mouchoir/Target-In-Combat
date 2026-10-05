# Target In Combat - TIC

A WoW Forever addon that shows whether a unit is in combat, on nameplates and next to the target portrait. Rogues can switch to a Sap mode that tells at a glance who can be sapped.

## Combat mode (every class)

- A red crossed-swords icon on the left of each nameplate and on the ring of the target portrait when the unit is in combat. A slider moves it around the portrait.
- No icon means out of combat: the player can mount, drink, stealth or resurrect.
- Option: show a faded icon on units out of combat instead of nothing.
- Filters: enemy players (on by default), enemy NPCs, friendly units.

## Sap mode (rogues)

On hostile units out of combat, the combat icon becomes the Sap icon:

| Icon | Meaning |
|---|---|
| Colored | Sap lands right now: humanoid, in range, you are stealthed |
| Grey | Sappable, but out of range or you are not stealthed |
| Red | Cannot be sapped: not humanoid, shapeshifted (druid forms, Ghost Wolf) or immune (Divine Shield, Ice Block, Blessing of Protection) |

Range comes from the game's own Sap range check, so any range bonus is taken into account.

## Options

`/tic` opens the panel in Options > AddOns.

## Development

- `luacheck addon` to lint.
- `scripts\dev.ps1` (or `dev.cmd`) copies the addon into the game. The AddOns path goes in a gitignored `scripts\dev.local.ps1` setting `$WowAddOnsPaths`.

## License

GPL-3.0
