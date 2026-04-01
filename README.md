# GuildForge

> **Know who can craft what — instantly.**

GuildForge is a World of Warcraft addon that automatically shares your profession recipes with your guildmates. Open a trade skill window, and GuildForge silently scans and broadcasts your known recipes to the guild. Any member can then search who can craft what, see reagents, and get a full picture of the guild's crafting coverage.

No setup. No slash commands required. It just works.

---

## Features

- **Automatic scan and broadcast** when you open a trade skill window
- **By Recipe view** : find who in your guild can craft a specific item, with reagent list and crafter count
- **By Member view** : browse each guildmate's professions and known recipes, with specialization tags
- **Expansion filter** : toggle between current and previous expansion recipes
- **Real-time search** : filter by recipe name across all professions at once
- **Guild specialization summary** : see at a glance which specs (Master Hammersmith, Gnomish Engineer...) exist in your guild
- **Minimap button** : draggable, left-click to open, right-click for the debug panel
- **Localization** : English, French, German, Spanish, Portuguese and Russian built in
- **No external dependencies** : native WoW API only, no libraries required

---

## Installation

### Manual

1. Download the latest release from the [Releases](../../releases) page.
2. Extract and copy the `GuildForge` folder into `World of Warcraft/_classic_era_/Interface/AddOns/`.
3. Reload your UI (`/reload`) or restart the game.

### CurseForge

Search for **GuildForge** by **Pampasaga** on CurseForge and install via the CurseForge app.

---

## Usage

The addon works automatically. When you open a profession window, it scans and broadcasts your recipes to guild members who also have GuildForge installed.

| Command | Action |
|---|---|
| `/gf` or `/guildforge` | Open the main interface |
| `/gf scan` | Rescan professions and broadcast to the guild |
| `/gf debug` | Open the debug panel |

---

## Compatibility

| Client | TOC |
|---|---|
| Classic Era (1.13) | `GuildForge_Classic.toc` |
| The Burning Crusade (2.5) | `GuildForge_BCC.toc` |

---

## Contributing

Pull requests are welcome. For major changes, open an issue first.

Locale files live in `Locales/`. To add a new language, copy `Locales/enUS.lua`, translate the strings, and add the file to all TOC files after `Locales/enUS.lua`.

---

## Support

If GuildForge saves you time, consider supporting development:

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/pampasaga)

---

## License

MIT. See [LICENSE](LICENSE).

---

*Made by [Pampasaga](https://github.com/pampasaga)*
