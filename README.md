# Agora

> **Verified craft marketplace for your guild and realm.**

Agora is a World of Warcraft addon that turns craft trading into something reliable. Open a trade skill window, and Agora scans and shares your known recipes with your guild automatically. Opt in to broadcast server-wide, and anyone on your realm can find you — with verified cooldown availability, not just a /2 spam.

No setup. No manual entry. Data comes from the WoW API, not a text field.

## Features

- **Automatic scan and broadcast** when you open a trade skill window
- **Guild view** : find who in your guild can craft any item, with reagent list and crafter count
- **Member view** : browse each guildmate's professions and known recipes, with specialization tags
- **Server-wide marketplace** (opt-in) : broadcast your services to the whole realm
- **Verified cooldowns** : a transmuter selling their daily CD? Agora confirms it is actually available
- **Guild specialization summary** : see at a glance which specs (Master Hammersmith, Gnomish Engineer, Potion Master...) exist in your guild
- **Expansion filter** : toggle between current and previous expansion recipes
- **Real-time search** : filter by recipe name across all professions at once
- **Whisper button** : contact a crafter directly from the UI
- **Version check** : notified in chat and in the UI when a newer version is available
- **Minimap button** : draggable, left-click to open, right-click for the debug panel
- **Localization** : English, French, German, Spanish, Portuguese, Russian
- **No external dependencies** : native WoW API only, no libraries required

## Installation

### Manual

1. Download the latest release from the [Releases](../../releases) page.
2. Extract and copy the `Agora` folder into `World of Warcraft/_classic_/Interface/AddOns/`.
3. Reload your UI (`/reload`) or restart the game.

### CurseForge

Search for **Agora** by **Pampasaga** on CurseForge and install via the CurseForge app.

## Usage

The addon works automatically. When you open a profession window, it scans and broadcasts your recipes to guild members who also have Agora installed.

| Command | Action |
|---|---|
| `/agora` or `/ag` | Open the main interface |
| `/ag scan` | Rescan professions and broadcast to the guild |
| `/ag debug` | Open the debug panel |

## Compatibility

| Client | TOC |
|---|---|
| Classic Era (1.13) | `Agora_Classic.toc` |
| The Burning Crusade (2.5) | `Agora_BCC.toc` |

## Contributing

Pull requests are welcome. For major changes, open an issue first.

Locale files live in `Locales/`. To add a new language, copy `Locales/enUS.lua`, translate the strings, and add the file to all TOC files after `Locales/enUS.lua`.

## Support

If Agora saves you time, consider supporting development:

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/pampasaga)

## License

MIT. See [LICENSE](LICENSE).

*Made by [Pampasaga](https://github.com/pampasaga)*
