-- GuildCraft - Locales/ptBR.lua
-- Portuguese Brazil (ptBR) locale overrides.

if GetLocale() ~= "ptBR" then return end

local L = GuildCraft.L

-- Core
L["CORE_ScanComplete"]      = "Escaneamento e transmissão concluídos."
L["CORE_ErrorPrefix"]       = "GuildCraft erro: "
L["CORE_DebugErrorPrefix"]  = "GuildCraft debug erro: "

-- UI - Buttons / Tabs
L["UI_TabByRecipe"]         = "Por Receita"
L["UI_TabByMember"]         = "Por Membro"
L["UI_BtnRefresh"]          = "Atualizar"
L["UI_BtnCurrentOnly"]      = "Só %s"
L["UI_BtnIncludePrev"]      = "+ %s"

-- UI - Title / Legend
L["UI_SearchHint"]          = "Buscar uma receita..."
L["UI_LegendAvailable"]     = "Disponível"
L["UI_LegendUnknown"]       = "Desconhecido"
L["UI_SuffixPatrons"]       = " receita(s)"
L["UI_SuffixRecipes"]       = " receita(s)"

-- UI - Expansion filter tooltip
L["UI_FilterTitle"]         = "Filtrar por expansão"
L["UI_FilterShowing"]       = "Exibindo: %s + %s"
L["UI_FilterShowingOnly"]   = "Exibindo: só %s"
L["UI_FilterClickOnly"]     = "Clique para exibir só %s"
L["UI_FilterClickInclude"]  = "Clique para incluir %s"

-- UI - Messages
L["UI_NoResults"]           = "Sem resultados para \"%s\"."
L["UI_NoData"]              = "Sem dados."
L["UI_OpenTradeSkill"]      = "Abra a janela de profissão para escanear."
L["UI_TooltipComponents"]   = "Componentes:"
L["UI_HeaderCoverage"]      = "%d/%d disponível(is)"

-- Debug panel
L["DEBUG_Title"]            = "GuildCraft - Debug"
L["DEBUG_ScanBtn"]          = "Escanear minhas profissões"
L["DEBUG_BroadcastBtn"]     = "Enviar meus dados"
L["DEBUG_HelloBtn"]         = "Solicitar dados da guilda"
L["DEBUG_ResetDB"]          = "Resetar BD"
L["DEBUG_MyDataTitle"]      = "Meus dados escaneados"
L["DEBUG_LogTitle"]         = "Log de eventos"
L["DEBUG_NoData"]           = "Sem dados escaneados. Abra uma profissão ou clique em Escanear."
L["DEBUG_MembersInDB"]      = "Membros no banco de dados: %d"
L["DEBUG_Timestamp"]        = "Última atualização: %s"

-- Minimap button tooltip
L["MINIMAP_Title"]          = "GuildCraft"
L["MINIMAP_TooltipLeft"]    = " Clique esq: Abrir interface"
L["MINIMAP_TooltipRight"]   = " Clique dir: Debug"
L["MINIMAP_TooltipDrag"]    = " Arrastar: Mover botão"

-- Filtres de categories
L["FILTER_weapon"]          = "Arma"
L["FILTER_chest"]           = "Peito"
L["FILTER_gloves"]          = "Luvas"
L["FILTER_boots"]           = "Botas"
L["FILTER_bracers"]         = "Braçadeiras"
L["FILTER_back"]            = "Capa"
L["FILTER_shield"]          = "Escudo"
L["FILTER_ring"]            = "Anel"
L["FILTER_head"]            = "Cabeça"
L["FILTER_shoulders"]       = "Ombros"
L["FILTER_flask"]           = "Frasco"
L["FILTER_potion"]          = "Poção"
L["FILTER_elixir"]          = "Elixir"
L["FILTER_transmute"]       = "Transmutação"
L["FILTER_armor"]           = "Armadura"
L["FILTER_bag"]             = "Bolsa"
L["FILTER_gem"]             = "Gema"
L["FILTER_drums"]           = "Tambores"
L["FILTER_item"]            = "Item"
L["FILTER_helm"]            = "Elmo"
L["FILTER_explosive"]       = "Explosivo"
L["FILTER_legs"]            = "Pernas"
L["FILTER_belt"]            = "Cinto"
L["FILTER_cloth"]           = "Tecido"
L["FILTER_spellfire"]       = "Fogo Arcano"
L["FILTER_mooncloth"]       = "Tecido Lunar"
L["FILTER_shadowweave"]     = "Trama das Sombras"
L["FILTER_red"]             = "Vermelho"
L["FILTER_blue"]            = "Azul"
L["FILTER_yellow"]          = "Amarelo"
L["FILTER_orange"]          = "Laranja"
L["FILTER_purple"]          = "Roxo"
L["FILTER_green"]           = "Verde"
L["FILTER_meta"]            = "Meta"
L["FILTER_food"]            = "Comida"

-- UI redesign
L["UI_AllProfs"]            = "Todos"
L["UI_GuildOnly"]           = "Só guilda"
L["UI_SelectRecipe"]        = "Selecione uma receita"
L["UI_SelectMember"]        = "Selecione um membro"
L["UI_SkillReq"]            = "Receita"
L["UI_Reagents"]            = "Materiais:"
L["UI_Crafters"]            = "Artesãos:"
L["UI_Wowhead"]             = "Wowhead:"
L["UI_NoCrafters"]          = "Ninguém na guilda tem essa receita."
L["UI_Whisper"]             = "Sussurrar"
L["UI_LastSeen"]            = "Visto há %s"
L["UI_LastSeenNever"]       = "Sem dados ainda"
L["UI_StaleWarning"]        = "Dados podem estar desatualizados"
L["UI_NoRecipes"]           = "Abra sua profissão para escanear as receitas."
L["UI_MemberOnline"]        = "Online"
L["UI_MemberOffline"]       = "Offline"
L["UI_CrafterCount_one"]    = "1 artesão pode fabricar isso:"
L["UI_CrafterCount_many"]   = "%d artesãos podem fabricar isso:"
L["UI_AHHint"]              = "Instale Auctionator ou Auctioneer para ver os preços atuais dos reagentes."
