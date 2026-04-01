-- GuildCraft - Locales/enUS.lua
-- Base locale (English). All other locale files override keys as needed.

local L = GuildCraft.L

-- Core
L["CORE_ScanComplete"]      = "Scan and broadcast complete."
L["CORE_ErrorPrefix"]       = "GuildCraft error: "
L["CORE_DebugErrorPrefix"]  = "GuildCraft debug error: "

-- UI - Buttons / Tabs
L["UI_TabByRecipe"]         = "By Recipe"
L["UI_TabByMember"]         = "By Member"
L["UI_BtnRefresh"]          = "Refresh"
L["UI_BtnCurrentOnly"]      = "%s only"
L["UI_BtnIncludePrev"]      = "+ %s"

-- UI - Title / Legend
L["UI_SearchHint"]          = "Search for a recipe..."
L["UI_LegendAvailable"]     = "Available"
L["UI_LegendUnknown"]       = "Unknown"
L["UI_SuffixPatrons"]       = " recipe(s)"
L["UI_SuffixRecipes"]       = " recipe(s)"

-- UI - Expansion filter tooltip
L["UI_FilterTitle"]         = "Filter by expansion"
L["UI_FilterShowing"]       = "Showing: %s + %s"
L["UI_FilterShowingOnly"]   = "Showing: %s only"
L["UI_FilterClickOnly"]     = "Click to show %s only"
L["UI_FilterClickInclude"]  = "Click to include %s"

-- UI - Messages
L["UI_NoResults"]           = "No results for \"%s\"."
L["UI_NoData"]              = "No data."
L["UI_OpenTradeSkill"]      = "Open the trade skill window to scan."
L["UI_TooltipComponents"]   = "Components:"
L["UI_HeaderCoverage"]      = "%d/%d available"

-- Debug panel
L["DEBUG_Title"]            = "GuildCraft - Debug"
L["DEBUG_ScanBtn"]          = "Scan my professions"
L["DEBUG_BroadcastBtn"]     = "Broadcast my data"
L["DEBUG_HelloBtn"]         = "Request guild data"
L["DEBUG_ResetDB"]          = "Reset DB"
L["DEBUG_MyDataTitle"]      = "My scanned data"
L["DEBUG_LogTitle"]         = "Event log"
L["DEBUG_NoData"]           = "No data scanned. Open a trade skill window or click Scan."
L["DEBUG_MembersInDB"]      = "Members in database: %d"
L["DEBUG_Timestamp"]        = "Last update: %s"

-- Minimap button tooltip
L["MINIMAP_Title"]          = "GuildCraft"
L["MINIMAP_TooltipLeft"]    = " Left click: Open interface"
L["MINIMAP_TooltipRight"]   = " Right click: Debug"
L["MINIMAP_TooltipDrag"]    = " Drag: Move button"

-- Category filters
L["FILTER_weapon"]          = "Weapon"
L["FILTER_chest"]           = "Chest"
L["FILTER_gloves"]          = "Gloves"
L["FILTER_boots"]           = "Boots"
L["FILTER_bracers"]         = "Bracers"
L["FILTER_back"]            = "Cloak"
L["FILTER_shield"]          = "Shield"
L["FILTER_ring"]            = "Ring"
L["FILTER_head"]            = "Head"
L["FILTER_shoulders"]       = "Shoulders"
L["FILTER_flask"]           = "Flask"
L["FILTER_potion"]          = "Potion"
L["FILTER_elixir"]          = "Elixir"
L["FILTER_transmute"]       = "Transmute"
L["FILTER_armor"]           = "Armor"
L["FILTER_bag"]             = "Bag"
L["FILTER_gem"]             = "Gem"
L["FILTER_drums"]           = "Drums"
L["FILTER_item"]            = "Item"
L["FILTER_helm"]            = "Helm"
L["FILTER_explosive"]       = "Explosive"
L["FILTER_legs"]            = "Legs"
L["FILTER_belt"]            = "Belt"
L["FILTER_cloth"]           = "Cloth"
L["FILTER_spellfire"]       = "Spellfire"
L["FILTER_mooncloth"]       = "Mooncloth"
L["FILTER_shadowweave"]     = "Shadowweave"
L["FILTER_red"]             = "Red"
L["FILTER_blue"]            = "Blue"
L["FILTER_yellow"]          = "Yellow"
L["FILTER_orange"]          = "Orange"
L["FILTER_purple"]          = "Purple"
L["FILTER_green"]           = "Green"
L["FILTER_meta"]            = "Meta"
L["FILTER_food"]            = "Food"

-- UI redesign
L["UI_AllProfs"]            = "All"
L["UI_GuildOnly"]           = "Guild only"
L["UI_SelectRecipe"]        = "Select a recipe"
L["UI_SelectMember"]        = "Select a member"
L["UI_SkillReq"]            = "Recipe"
L["UI_Reagents"]            = "Materials:"
L["UI_Crafters"]            = "Crafters:"
L["UI_Wowhead"]             = "Wowhead:"
L["UI_NoCrafters"]          = "Nobody in the guild has this recipe."
L["UI_Whisper"]             = "Whisper"
L["UI_LastSeen"]            = "Last updated: %s ago"
L["UI_LastSeenNever"]       = "No data yet"
L["UI_StaleWarning"]        = "Data may be outdated"
L["UI_NoRecipes"]           = "Open your trade skill to scan recipes."
L["UI_MemberOnline"]        = "Online"
L["UI_MemberOffline"]       = "Offline"
L["UI_CrafterCount_one"]    = "1 crafter can make this:"
L["UI_CrafterCount_many"]   = "%d crafters can make this:"
L["UI_AHHint"]              = "Install Auctionator or Auctioneer to see current reagent prices."
