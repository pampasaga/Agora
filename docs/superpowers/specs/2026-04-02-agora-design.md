# Agora — Design Spec
Date : 2026-04-02

## Contexte

GuildForge (deja approuve sur CurseForge, 1 DL) est renomme **Agora**. L'addon garde toute la logique de partage metier en guilde et y ajoute un marche serveur-wide de services de craft verifies. Un seul addon, une seule interface.

Concept : la place publique du royaume. Les crafteurs annoncent leurs services avec des donnees verifiees par l'API WoW — pas un champ texte libre. Fini le spam /2, fini les arnaques aux patrons.

---

## Perimetre v1

**Inclus :**
- Scan des metiers du joueur via API WoW (GetTradeSkillInfo, GetSpellCooldown)
- Partage automatique en guilde (SendAddonMessage GUILD)
- Broadcast opt-in au serveur (canal custom "Agora")
- Verification des CDs vendus (GetSpellCooldown au moment du broadcast)
- Badge "fournis les compos" avec verification en temps reel des sacs
- Affichage des reactifs du patron (icone + nom + quantite)
- UI unifiee : patrons connus, crafteurs guilde prioritaires, crafteurs serveur dessous

**Exclu de v1 :**
- Boosts / aide generale (declaratif, non verifiable)
- Layer detection (API incertaine)
- Scheduling / disponibilite future
- Historique des membres, gestion des rangs (pas dans Agora)

---

## Architecture reseau

### Canal guilde
`SendAddonMessage("AGORA", payload, "GUILD")`
Sync automatique au login. Meme protocole que GuildForge (PREFIX change de GCRAFT vers AGORA).

### Canal serveur-wide
Canal custom WoW : `"Agora"` rejoint automatiquement au login (opt-out possible en settings).

**Protocole :**
| Message | Declencheur | Contenu |
|---------|-------------|---------|
| `HELLO` | Login du joueur | Demande de donnees aux crafteurs actifs |
| `DATA`  | Reception d'un HELLO, ou update du crafteur | Fiche complete (chunked, 200 chars/chunk) |
| `HEARTBEAT` | Toutes les 5 minutes | Signal "je suis la" (pas de donnees) |
| `REMOVE` | Logout, instance, desactivation | Suppression immediate |

Reponse au HELLO : delai aleatoire 0-3s pour eviter le thundering herd.
1 heartbeat manque = fiche retiree cote client.

### Format DATA (serialise)
```
V2|name|realm|class|zone|timestamp|price|provides_mats|PROF|name|lvl|max|REC|name|cd_available|...
```
- `price` : "" | "tips" | montant en copper
- `provides_mats` : "0" ou "1"
- `cd_available` : "0" ou "1" (verifie par GetSpellCooldown)

Chunking conserve de GuildForge : 200 chars/chunk, CHUNK_SEP="\002", 0.05s entre chunks.

---

## Donnees d'une fiche crafteur

```
nom | realm | classe | zone | timestamp | prix | fournit_compos
  metiers[] :
    nom | niveau | max
    recettes[] :
      nom | cd_disponible
```

---

## RecipeDB

Base statique des patrons TBC (heritee de GuildForge, 2191 entrees).
- Flag `important` par recette (statique, pas par phase)
- Items BoP filtres automatiquement du marketplace
- Champs : prof, name, category, spellID, itemID, reagents[], minSkill, expansion, important

---

## Badge "fournis les compos"

Le crafteur active l'option "Je fournis les compos" par patron.

**Validation au moment de l'activation :**
1. L'addon scanne les sacs du joueur (GetContainerItemInfo sur tous les slots)
2. Compare avec les reactifs necessaires (RecipeDB)
3. Si quantites suffisantes : badge active, inclus dans le prochain broadcast
4. Si insuffisant : message au crafteur "Il te manque 3x [Terocone]", badge non active

**Re-validation automatique :**
A chaque heartbeat (5 min), l'addon re-verifie les sacs. Si les reactifs ont disparu (craften entre-temps, vendus), le badge est retire du prochain broadcast. Le badge ne peut pas etre "mens" sans avoir les items reellement en sac.

---

## UI

### Dimensions et structure
Conservees de GuildForge : frame 820x580, split-panel.
- Panel gauche : 305px (liste des patrons + filtres)
- Panel droit : reste (detail du patron selectionne)

### Barre titre
`[Icone Agora] Agora [SearchBox 210px] [X]`

### Barre action (sous le titre)
- "Par patron" (actif par defaut) — seule vue disponible en v1
- Checkbox "Guilde uniquement"
- Checkbox "Inclure Vanilla" (si expansion > Classic)

La vue "Par membre" de GuildForge est supprimee. Agora est entierement recipe-centric.

### Onglets metiers (icones, 36x36)
Meme pattern que GuildForge : "Tous" + icone par metier de craft (gathering exclus).
Gold underline = actif, icone grisee = inactif.

### Filtres de categorie (en dessous des onglets, panel gauche)
Row de petits boutons texte : sous-categories du metier selectionne.
Ex. pour Alchimie : `Flasques | Potions | Elixirs | Transmutations | Huiles | Materiaux`

Le toggle **Importants** est separe et positionne a droite dans la meme zone, toujours visible independamment de la categorie selectionnee.

```
[Flasques] [Potions] [Elixirs] [Transmutations] [Tous]     [⭐ Importants]
```

### Liste des patrons (scroll, panel gauche)
- Tous les patrons connus affiches (RecipeDB + scan guilde)
- Important en premier (etoile doree), puis alphabetique
- Grise + "aucun" si personne ne propose
- Colonne droite : nombre de crafteurs actifs (guilde + serveur)

### Panel droit — detail d'un patron selectionne

**Section haute (fixe) :**
```
[Icone 52x52] [Nom du patron]  [tag qualite]
              [URL spell / URL item]
              [Description du sort si disponible]
```

**Section reactifs :**
```
Materiaux :
[icone] 3x Terocone
[icone] 1x Primal Fire
[icone] 1x Fel Lotus
```
Pas de prix AH en v1 : l'integration Auctionator/Auctioneer est trop fragile sur TBC Anniversary (global `AuctionatorPrices` non garanti). Feature reportee en v2+.

**Section crafteurs guilde :**
```
── Guilde (2) ────────────────
● Pampa     [Shattrath]  [+Compos]   tips
● Zarak     [Ironforge]              5g
```

**Section crafteurs serveur :**
```
── Serveur (3) ───────────────
○ Lyrea     [Shattrath]  [+Compos]   3g
○ Kira      [Dalaran]               tips
○ Aldren    [Ironforge]              8g
```

Dot plein vert = guilde (en ligne confirme par roster).
Cercle vide = serveur (actif = heartbeat recent, pas de notion online/offline).
`[+Compos]` = badge fournis les compos valide.
Prix : vide = gratuit, "tips" = tip libre, montant = prix fixe.
Zone affichee pour chaque crafteur.

### Footer
```
[Proposer mes services]    X guilde | Y serveur | Donnees : 2min    [Pampasaga]  [v1.0.0]
```

"Proposer mes services" ouvre un panneau de configuration : activer le broadcast serveur, definir son prix par metier/patron, activer "fournis les compos" par patron.

---

## Panneau "Proposer mes services"

Frame modale (ou flyout) :
- Toggle global "Proposer sur le serveur" (opt-in)
- Par metier : prix par defaut (vide / tips / montant)
- Par patron (expandable) : override prix + toggle "fournis les compos"
- Bouton "Mettre a jour" : force un nouveau broadcast DATA

---

## Logique de verification des CDs

Au moment du broadcast DATA, pour chaque recette avec cooldown (ex. Transmutation Pierre de Vie) :
```lua
local start, duration, _ = GetSpellCooldown(spellID)
local cd_available = (duration == 0) or (start + duration <= GetTime())
```
Ce flag est inclus dans le payload DATA. Le client affiche une icone distincte si le CD est disponible.

---

## Gestion des prix

Cote crafteur : champ texte libre ou dropdown (vide / tips / montant en gold).
Stocke en copper en interne. Serialise en copper dans le payload.
Cote client : affiche avec `FormatCopper` (herite de GuildForge).

---

## Migration depuis GuildForge

Le PREFIX passe de `GCRAFT` a `AGORA`. Les deux coexistent brievement pendant la transition.
SavedVariables : `AgoraDB` (nouveau). Les donnees GuildForgeDB ne sont pas migrees (scan automatique au login de toute facon).
Nom de l'addon dans le .toc : `Agora`. Interface : meme codebase, fichiers renommes progressivement.

---

## Fichiers

Structure conservee de GuildForge, adaptee :

```
Agora/
  Agora.toc
  Core.lua        -- init, namespace, evenements, timers
  DB.lua          -- SavedVariables AgoraDB, defaults, acces donnees
  Scanner.lua     -- scan metiers, CDs, sacs (badge compos)
  Broadcast.lua   -- protocole AGORA guilde + serveur (HELLO/DATA/HEARTBEAT/REMOVE)
  UI.lua          -- frame principale, onglets, liste, panel droit, "Proposer" flyout
  RecipeDB.lua    -- base statique patrons TBC (2191 entrees, flag important)
  Locales/
    enUS.lua
    frFR.lua
```

Pas de librairie externe separee. Tout dans un seul addon.

---

## Ce qui est reutilise de GuildForge tel quel

- `RecipeDB.lua` complet (ajout colonne `important`)
- `Broadcast.lua` : chunking, delai HELLO, timeout 60s — PREFIX change uniquement
- `UI.lua` : frame, backdrop, palette, PROF_ICONS, PROF_FILTERS, PROF_DISPLAY, row pool, detail panel (haut), FormatCopper, RelativeTime, BuildOnlineCache, ResolveIcon, ShowEntryTooltip, search box, BuildTabs, BuildCatFilters
- `Scanner.lua` : scan metiers, GetSpellCooldown — ajout scan sacs pour badge compos
- `DB.lua` : pattern defaults + merge, adapte pour AgoraDB
- `Core.lua` : pattern init ADDON_LOADED, GC:After timer, GC:GetMyKey — namespace renomme

---

## Non-decisions (v2+)

- Layer detection et tri par layer
- Scheduling / disponibilite future
- Boosts et services non-craft
- Historique des membres ou gestion de guilde
- Estimation cout reactifs via prix AH (integration Auctionator trop fragile en v1)
