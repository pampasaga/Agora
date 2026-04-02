# Pampasaga Addon Ecosystem — Vision

Date de la session : 2026-04-02

## L'addon : Agora

Un seul addon. GuildForge est renommé Agora.

**Concept :** la place publique du royaume. Les crafteurs annoncent leurs services de façon vérifiée — la donnée vient de l'API WoW, pas d'un champ texte. Fini le spam /2, fini les arnaques aux patrons.

### Ce qu'Agora fait

1. **Scanne les métiers du joueur** via l'API WoW (GetTradeSkillInfo, GetSpellCooldown)
2. **Partage avec la guilde** automatiquement (comme GuildForge faisait)
3. **Propose au serveur** si le joueur clique "proposer mes services" (opt-in)
4. **Vérifie les CDs** — un transmuteur qui vend son CD quotidien : l'addon confirme que le CD est vraiment disponible
5. **Affiche une UI unifiée** : guilde en priorité, serveur en dessous

### Ce qu'Agora ne fait pas (v1)
- Pas de boosts/aide générale (déclaratif, non vérifiable — v2+)
- Pas de layer detection (API incertaine — v2+)
- Pas de scheduling / disponibilité future

### Pourquoi Agora plutôt que deux addons
GuildForge et PampaMarket faisaient la même chose à des échelles différentes. Fusionner évite la duplication de code, simplifie l'expérience utilisateur, et un seul addon à maintenir.

---

## Architecture technique

### Communication réseau
- **Guilde** : SendAddonMessage "GUILD" — sync automatique au login
- **Serveur** : canal custom "Agora" rejoint automatiquement — broadcast opt-in

### Protocole serveur-wide
- `HELLO` au login → crafters actifs répondent avec leurs données (délai aléatoire 0-3s)
- `DATA` : fiche complète d'un crafter (métiers + recettes + CDs + zone)
- `HEARTBEAT` : signal "je suis toujours là" toutes les 5 minutes
- `REMOVE` : suppression immédiate quand le crafter arrête ou entre en instance
- 1 heartbeat manqué = fiche retirée côté client

### Données d'une fiche crafter
```
nom | zone | métiers[] | recettes[] | CDs_disponibles[] | prix_optionnel | timestamp
```

### RecipeDB
Base statique des patrons TBC, interne à Agora. Flag "important" par recette (pas par phase — les items importants le restent toute la durée de TBC). Items BoP exclus automatiquement.

---

## UI

### Structure
- Barre de titre + recherche globale
- Rangée d'icônes de métiers (onglets)
- Sous-filtres par catégorie de métier (Flacons / Potions / Transmutations pour Alchimie, etc.)
- Toggle "Importants" séparé des sous-filtres de catégorie
- Liste des patrons (important en avant, grisé si personne ne propose)
- Panel droite : crafters dispo — guilde en haut, serveur en dessous
- Barre de statut : compteurs + "Proposer mes services"

### Règles d'affichage
- Tous les patrons connus affichés (grisés si aucun crafter actif)
- Items BoP filtrés
- Crafters guilde prioritaires dans le panel
- Zone affichée pour chaque crafter
- Prix affiché si renseigné, sinon "tip libre"

---

## Paysage concurrentiel (recherche 2026-04-02)

- Trade Bulletin Board (316 DL) : filtre le chaos de /2, ne le remplace pas. Approche fondamentalement insuffisante.
- Profession Master (145K DL) : profession sync guild uniquement, pas de marché serveur
- GuildCrafts TBC (24K DL) : recipe book guild uniquement
- Aucun concurrent sur le marché serveur-wide vérifié

## Niches vides confirmées
- Craft queue / request system : 0 résultats
- Marché de services serveur-wide structuré : 0 résultats
- Vérification CD vendables : 0 résultats

## Mécanisme d'adoption
1. Clients adoptent pour éviter les arnaques (données vérifiées)
2. Crafters rejoignent pour accéder aux clients
3. /2 devient progressivement le canal des gens sans l'addon
4. Une arnaque évitée = le client en parle à sa guilde = seed du serveur

## Branding
- Nom de l'addon : **Agora**
- Auteur CurseForge : Pampasaga
- GuildForge (déjà approuvé CF, 1 DL) → renommé Agora, même projet CF
- pampasaga.dev à claim en priorité
