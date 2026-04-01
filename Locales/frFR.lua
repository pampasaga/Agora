-- GuildCraft - Locales/frFR.lua
-- French (frFR) locale overrides.

if GetLocale() ~= "frFR" then return end

local L = GuildCraft.L

-- Core
L["CORE_ScanComplete"]      = "Scan et diffusion effectues."
L["CORE_ErrorPrefix"]       = "GuildCraft erreur : "
L["CORE_DebugErrorPrefix"]  = "GuildCraft debug erreur : "

-- UI - Buttons / Tabs
L["UI_TabByRecipe"]         = "Par Patron"
L["UI_TabByMember"]         = "Par Membre"
L["UI_BtnRefresh"]          = "Actualiser"
L["UI_BtnCurrentOnly"]      = "%s seul."
L["UI_BtnIncludePrev"]      = "+ %s"

-- UI - Title / Legend
L["UI_SearchHint"]          = "Rechercher un patron..."
L["UI_LegendAvailable"]     = "Disponible"
L["UI_LegendUnknown"]       = "Inconnu"
L["UI_SuffixPatrons"]       = " patron(s)"
L["UI_SuffixRecipes"]       = " recette(s)"

-- UI - Expansion filter tooltip
L["UI_FilterTitle"]         = "Filtrer par extension"
L["UI_FilterShowing"]       = "Affiche : %s + %s"
L["UI_FilterShowingOnly"]   = "Affiche : %s uniquement"
L["UI_FilterClickOnly"]     = "Cliquer pour afficher %s uniquement"
L["UI_FilterClickInclude"]  = "Cliquer pour inclure %s"

-- UI - Messages
L["UI_NoResults"]           = "Aucun resultat pour \"%s\"."
L["UI_NoData"]              = "Aucune donnee."
L["UI_OpenTradeSkill"]      = "Ouvrez la fenetre de metier pour scanner."
L["UI_TooltipComponents"]   = "Composants :"
L["UI_HeaderCoverage"]      = "%d/%d disponible(s)"

-- Debug panel
L["DEBUG_Title"]            = "GuildCraft - Debug"
L["DEBUG_ScanBtn"]          = "Scanner mes metiers"
L["DEBUG_BroadcastBtn"]     = "Broadcaster mes data"
L["DEBUG_HelloBtn"]         = "Demander data guilde"
L["DEBUG_ResetDB"]          = "Vider la DB"
L["DEBUG_MyDataTitle"]      = "Mes donnees scannees"
L["DEBUG_LogTitle"]         = "Log evenements"
L["DEBUG_NoData"]           = "Aucune donnee scannee. Ouvrez un metier ou cliquez Scanner."
L["DEBUG_MembersInDB"]      = "Membres en base : %d"
L["DEBUG_Timestamp"]        = "Derniere mise a jour : %s"

-- Minimap button tooltip
L["MINIMAP_Title"]          = "GuildCraft"
L["MINIMAP_TooltipLeft"]    = " Clic gauche : Ouvrir l'interface"
L["MINIMAP_TooltipRight"]   = " Clic droit   : Debug"
L["MINIMAP_TooltipDrag"]    = " Drag          : Deplacer le bouton"

-- Filtres de categories
L["FILTER_weapon"]          = "Arme"
L["FILTER_chest"]           = "Torse"
L["FILTER_gloves"]          = "Gants"
L["FILTER_boots"]           = "Bottes"
L["FILTER_bracers"]         = "Poignets"
L["FILTER_back"]            = "Cape"
L["FILTER_shield"]          = "Bouclier"
L["FILTER_ring"]            = "Anneau"
L["FILTER_head"]            = "Tete"
L["FILTER_shoulders"]       = "Epaules"
L["FILTER_flask"]           = "Flasque"
L["FILTER_potion"]          = "Potion"
L["FILTER_elixir"]          = "Elixir"
L["FILTER_transmute"]       = "Transmutation"
L["FILTER_armor"]           = "Armure"
L["FILTER_bag"]             = "Sac"
L["FILTER_gem"]             = "Gemme"
L["FILTER_drums"]           = "Tambours"
L["FILTER_item"]            = "Objet"
L["FILTER_helm"]            = "Casque"
L["FILTER_explosive"]       = "Explosif"
L["FILTER_legs"]            = "Jambieres"
L["FILTER_belt"]            = "Ceinture"
L["FILTER_cloth"]           = "Etoffe"
L["FILTER_spellfire"]       = "Feu des sorts"
L["FILTER_mooncloth"]       = "Lunaire"
L["FILTER_shadowweave"]     = "Voile d'ombre"
L["FILTER_red"]             = "Rouge"
L["FILTER_blue"]            = "Bleu"
L["FILTER_yellow"]          = "Jaune"
L["FILTER_orange"]          = "Orange"
L["FILTER_purple"]          = "Pourpre"
L["FILTER_green"]           = "Vert"
L["FILTER_meta"]            = "Meta"
L["FILTER_food"]            = "Nourriture"

-- UI redesign
L["UI_AllProfs"]            = "Tous"
L["UI_GuildOnly"]           = "Guilde seul."
L["UI_SelectRecipe"]        = "Selectionnez un patron"
L["UI_SelectMember"]        = "Selectionnez un membre"
L["UI_SkillReq"]            = "Recette"
L["UI_Reagents"]            = "Composants :"
L["UI_Crafters"]            = "Artisans :"
L["UI_Wowhead"]             = "Wowhead :"
L["UI_NoCrafters"]          = "Personne dans la guilde ne possede ce patron."
L["UI_Whisper"]             = "Chuchoter"
L["UI_LastSeen"]            = "Vu il y a %s"
L["UI_LastSeenNever"]       = "Pas encore de donnees"
L["UI_StaleWarning"]        = "Donnees potentiellement obsoletes"
L["UI_NoRecipes"]           = "Ouvrez votre metier pour scanner les patrons."
L["UI_MemberOnline"]        = "Connecte"
L["UI_MemberOffline"]       = "Hors ligne"
L["UI_CrafterCount_one"]    = "1 artisan peut fabriquer cet objet :"
L["UI_CrafterCount_many"]   = "%d artisans peuvent fabriquer cet objet :"
L["UI_AHHint"]              = "Installez Auctionator ou Auctioneer pour voir les prix actuels des composants."
