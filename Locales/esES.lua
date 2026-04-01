-- GuildCraft - Locales/esES.lua
-- Spanish (esES / esMX) locale overrides.

local loc = GetLocale()
if loc ~= "esES" and loc ~= "esMX" then return end

local L = GuildCraft.L

-- Core
L["CORE_ScanComplete"]      = "Escaneo y difusión completados."
L["CORE_ErrorPrefix"]       = "GuildCraft error: "
L["CORE_DebugErrorPrefix"]  = "GuildCraft debug error: "

-- UI - Buttons / Tabs
L["UI_TabByRecipe"]         = "Por Receta"
L["UI_TabByMember"]         = "Por Miembro"
L["UI_BtnRefresh"]          = "Actualizar"
L["UI_BtnCurrentOnly"]      = "Solo %s"
L["UI_BtnIncludePrev"]      = "+ %s"

-- UI - Title / Legend
L["UI_SearchHint"]          = "Buscar una receta..."
L["UI_LegendAvailable"]     = "Disponible"
L["UI_LegendUnknown"]       = "Desconocido"
L["UI_SuffixPatrons"]       = " receta(s)"
L["UI_SuffixRecipes"]       = " receta(s)"

-- UI - Expansion filter tooltip
L["UI_FilterTitle"]         = "Filtrar por expansión"
L["UI_FilterShowing"]       = "Mostrando: %s + %s"
L["UI_FilterShowingOnly"]   = "Mostrando: solo %s"
L["UI_FilterClickOnly"]     = "Clic para mostrar solo %s"
L["UI_FilterClickInclude"]  = "Clic para incluir %s"

-- UI - Messages
L["UI_NoResults"]           = "Sin resultados para \"%s\"."
L["UI_NoData"]              = "Sin datos."
L["UI_OpenTradeSkill"]      = "Abre la ventana de profesiones para escanear."
L["UI_TooltipComponents"]   = "Componentes:"
L["UI_HeaderCoverage"]      = "%d/%d disponibles"

-- Debug panel
L["DEBUG_Title"]            = "GuildCraft - Debug"
L["DEBUG_ScanBtn"]          = "Escanear mis profesiones"
L["DEBUG_BroadcastBtn"]     = "Enviar mis datos"
L["DEBUG_HelloBtn"]         = "Solicitar datos del gremio"
L["DEBUG_ResetDB"]          = "Resetear BD"
L["DEBUG_MyDataTitle"]      = "Mis datos escaneados"
L["DEBUG_LogTitle"]         = "Registro de eventos"
L["DEBUG_NoData"]           = "Sin datos escaneados. Abre una profesión o haz clic en Escanear."
L["DEBUG_MembersInDB"]      = "Miembros en la base de datos: %d"
L["DEBUG_Timestamp"]        = "Última actualización: %s"

-- Minimap button tooltip
L["MINIMAP_Title"]          = "GuildCraft"
L["MINIMAP_TooltipLeft"]    = " Clic izq: Abrir interfaz"
L["MINIMAP_TooltipRight"]   = " Clic der: Debug"
L["MINIMAP_TooltipDrag"]    = " Arrastrar: Mover botón"

-- Filtres de categories
L["FILTER_weapon"]          = "Arma"
L["FILTER_chest"]           = "Pecho"
L["FILTER_gloves"]          = "Guantes"
L["FILTER_boots"]           = "Botas"
L["FILTER_bracers"]         = "Muñequeras"
L["FILTER_back"]            = "Capa"
L["FILTER_shield"]          = "Escudo"
L["FILTER_ring"]            = "Anillo"
L["FILTER_head"]            = "Cabeza"
L["FILTER_shoulders"]       = "Hombros"
L["FILTER_flask"]           = "Frasco"
L["FILTER_potion"]          = "Poción"
L["FILTER_elixir"]          = "Elixir"
L["FILTER_transmute"]       = "Transmutación"
L["FILTER_armor"]           = "Armadura"
L["FILTER_bag"]             = "Bolsa"
L["FILTER_gem"]             = "Gema"
L["FILTER_drums"]           = "Tambores"
L["FILTER_item"]            = "Objeto"
L["FILTER_helm"]            = "Yelmo"
L["FILTER_explosive"]       = "Explosivo"
L["FILTER_legs"]            = "Piernas"
L["FILTER_belt"]            = "Cinturón"
L["FILTER_cloth"]           = "Tela"
L["FILTER_spellfire"]       = "Fuego de hechizos"
L["FILTER_mooncloth"]       = "Tela lunar"
L["FILTER_shadowweave"]     = "Tejido de sombras"
L["FILTER_red"]             = "Rojo"
L["FILTER_blue"]            = "Azul"
L["FILTER_yellow"]          = "Amarillo"
L["FILTER_orange"]          = "Naranja"
L["FILTER_purple"]          = "Morado"
L["FILTER_green"]           = "Verde"
L["FILTER_meta"]            = "Meta"
L["FILTER_food"]            = "Comida"

-- UI redesign
L["UI_AllProfs"]            = "Todos"
L["UI_GuildOnly"]           = "Solo gremio"
L["UI_SelectRecipe"]        = "Selecciona una receta"
L["UI_SelectMember"]        = "Selecciona un miembro"
L["UI_SkillReq"]            = "Receta"
L["UI_Reagents"]            = "Materiales:"
L["UI_Crafters"]            = "Artesanos:"
L["UI_Wowhead"]             = "Wowhead:"
L["UI_NoCrafters"]          = "Nadie en el gremio tiene esta receta."
L["UI_Whisper"]             = "Susurrar"
L["UI_LastSeen"]            = "Última vez hace %s"
L["UI_LastSeenNever"]       = "Sin datos aún"
L["UI_StaleWarning"]        = "Los datos pueden estar desactualizados"
L["UI_NoRecipes"]           = "Abre tu profesión para escanear las recetas."
L["UI_MemberOnline"]        = "En línea"
L["UI_MemberOffline"]       = "Desconectado"
L["UI_CrafterCount_one"]    = "1 artesano puede fabricar esto:"
L["UI_CrafterCount_many"]   = "%d artesanos pueden fabricar esto:"
L["UI_AHHint"]              = "Instala Auctionator o Auctioneer para ver los precios actuales de los reactivos."
