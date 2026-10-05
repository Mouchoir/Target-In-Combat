# Target In Combat - TIC

**Is your target in combat? Can you Sap it?** One small icon on nameplates and on the target portrait tells you, for WoW Forever.

Built for world PvP: an enemy out of combat can mount, drink, stealth or resurrect. An enemy in combat cannot.

## For every class

- **Red crossed swords**: the unit is in combat.
- **Nothing**: out of combat. Or turn on the optional **Zzz** to see it explicitly.
- Shown on the left of each nameplate (next to the name for friendly players shown as a name only) and on the ring of the target portrait.
- Filters: enemy players (on by default), enemy NPCs, friendly units.

## For rogues: Sap mode

On hostile units out of combat, the icon becomes the Sap icon:

- **Colored**: Sap lands right now. Humanoid, in range, you are stealthed.
- **Grey**: sappable, but out of range or you are not stealthed.
- **Grey with a red X**: cannot be sapped. Not humanoid, shapeshifted (druid forms, Ghost Wolf) or immune (Divine Shield, Ice Block, Blessing of Protection).
- **Sap timer**: once sapped, the icon shows the time left as a clock sweep and in seconds. Read from the real debuff, so it is exact, and it disappears the moment Sap breaks.

Range uses the game's own Sap range check, so range bonuses are included. No guessed distance countdown: the game does not give the exact distance to an enemy, and an approximate number would mislead.

## Screenshots

| | Nameplate | Target portrait |
|---|---|---|
| In combat | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/combat-plate.png) | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/combat-target.png) |
| Out of combat (optional Zzz) | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/zzz-plate.png) | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/zzz-target.png) |
| Sap ready: humanoid, in range, stealthed | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/sap-ready-plate.png) | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/sap-ready-target.png) |
| Sappable, but out of range | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/sap-far-player-plate.png) | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/sap-far-player-target.png) |
| Not sappable: beast | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/sap-no-beast-plate.png) | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/sap-no-beast-target.png) |
| Not sappable: player in cat form | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/sap-no-druid-form-plate.png) | ![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/sap-no-druid-form-target.png) |

Sap timer, seconds left on your Sap:

![](https://raw.githubusercontent.com/Mouchoir/Target-In-Combat/main/docs/screenshots/sap-timer-plate.png)

## Options

Type **/tic** (Options > AddOns):

- Nameplates and target portrait on/off
- Icon size, and a slider to place it anywhere around the target portrait
- Rounded corners, separately for the target portrait and the nameplates
- "Show when targeting yourself" to see the icon while you set it up
- Unit filters, out-of-combat Zzz
- Sap mode on/off

## Languages

English and French.

## Feedback

Bugs and ideas: [GitHub issues](https://github.com/Mouchoir/Target-In-Combat/issues).
