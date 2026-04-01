-- GuildCraft - Locales/ruRU.lua
-- Russian (ruRU) locale overrides.

if GetLocale() ~= "ruRU" then return end

local L = GuildCraft.L

-- Core
L["CORE_ScanComplete"]      = "Сканирование и передача завершены."
L["CORE_ErrorPrefix"]       = "Ошибка GuildCraft: "
L["CORE_DebugErrorPrefix"]  = "Ошибка отладки GuildCraft: "

-- UI - Buttons / Tabs
L["UI_TabByRecipe"]         = "По рецепту"
L["UI_TabByMember"]         = "По участнику"
L["UI_BtnRefresh"]          = "Обновить"
L["UI_BtnCurrentOnly"]      = "Только %s"
L["UI_BtnIncludePrev"]      = "+ %s"

-- UI - Title / Legend
L["UI_SearchHint"]          = "Поиск рецепта..."
L["UI_LegendAvailable"]     = "Доступно"
L["UI_LegendUnknown"]       = "Неизвестно"
L["UI_SuffixPatrons"]       = " рецепт(ов)"
L["UI_SuffixRecipes"]       = " рецепт(ов)"

-- UI - Expansion filter tooltip
L["UI_FilterTitle"]         = "Фильтр по дополнению"
L["UI_FilterShowing"]       = "Показано: %s + %s"
L["UI_FilterShowingOnly"]   = "Показано: только %s"
L["UI_FilterClickOnly"]     = "Нажмите для показа только %s"
L["UI_FilterClickInclude"]  = "Нажмите для включения %s"

-- UI - Messages
L["UI_NoResults"]           = "Нет результатов для \"%s\"."
L["UI_NoData"]              = "Нет данных."
L["UI_OpenTradeSkill"]      = "Откройте окно профессии для сканирования."
L["UI_TooltipComponents"]   = "Компоненты:"
L["UI_HeaderCoverage"]      = "%d/%d доступно"

-- Debug panel
L["DEBUG_Title"]            = "GuildCraft - Debug"
L["DEBUG_ScanBtn"]          = "Сканировать профессии"
L["DEBUG_BroadcastBtn"]     = "Отправить данные"
L["DEBUG_HelloBtn"]         = "Запросить данные гильдии"
L["DEBUG_ResetDB"]          = "Сбросить БД"
L["DEBUG_MyDataTitle"]      = "Мои сканированные данные"
L["DEBUG_LogTitle"]         = "Журнал событий"
L["DEBUG_NoData"]           = "Нет данных. Откройте профессию или нажмите Сканировать."
L["DEBUG_MembersInDB"]      = "Участников в базе данных: %d"
L["DEBUG_Timestamp"]        = "Последнее обновление: %s"

-- Minimap button tooltip
L["MINIMAP_Title"]          = "GuildCraft"
L["MINIMAP_TooltipLeft"]    = " Левый клик: Открыть интерфейс"
L["MINIMAP_TooltipRight"]   = " Правый клик: Debug"
L["MINIMAP_TooltipDrag"]    = " Перетащить: Переместить кнопку"

-- Filtres de categories
L["FILTER_weapon"]          = "Оружие"
L["FILTER_chest"]           = "Нагрудник"
L["FILTER_gloves"]          = "Перчатки"
L["FILTER_boots"]           = "Сапоги"
L["FILTER_bracers"]         = "Наручи"
L["FILTER_back"]            = "Плащ"
L["FILTER_shield"]          = "Щит"
L["FILTER_ring"]            = "Кольцо"
L["FILTER_head"]            = "Голова"
L["FILTER_shoulders"]       = "Плечи"
L["FILTER_flask"]           = "Фляга"
L["FILTER_potion"]          = "Зелье"
L["FILTER_elixir"]          = "Эликсир"
L["FILTER_transmute"]       = "Трансмутация"
L["FILTER_armor"]           = "Броня"
L["FILTER_bag"]             = "Сумка"
L["FILTER_gem"]             = "Самоцвет"
L["FILTER_drums"]           = "Барабаны"
L["FILTER_item"]            = "Предмет"
L["FILTER_helm"]            = "Шлем"
L["FILTER_explosive"]       = "Взрывчатка"
L["FILTER_legs"]            = "Ноги"
L["FILTER_belt"]            = "Пояс"
L["FILTER_cloth"]           = "Ткань"
L["FILTER_spellfire"]       = "Огонь заклинаний"
L["FILTER_mooncloth"]       = "Лунная ткань"
L["FILTER_shadowweave"]     = "Теневое плетение"
L["FILTER_red"]             = "Красный"
L["FILTER_blue"]            = "Синий"
L["FILTER_yellow"]          = "Жёлтый"
L["FILTER_orange"]          = "Оранжевый"
L["FILTER_purple"]          = "Фиолетовый"
L["FILTER_green"]           = "Зелёный"
L["FILTER_meta"]            = "Мета"
L["FILTER_food"]            = "Еда"

-- UI redesign
L["UI_AllProfs"]            = "Все"
L["UI_GuildOnly"]           = "Только гильдия"
L["UI_SelectRecipe"]        = "Выберите рецепт"
L["UI_SelectMember"]        = "Выберите участника"
L["UI_SkillReq"]            = "Рецепт"
L["UI_Reagents"]            = "Материалы:"
L["UI_Crafters"]            = "Мастера:"
L["UI_Wowhead"]             = "Wowhead:"
L["UI_NoCrafters"]          = "Никто в гильдии не знает этот рецепт."
L["UI_Whisper"]             = "Шёпот"
L["UI_LastSeen"]            = "Последний раз %s назад"
L["UI_LastSeenNever"]       = "Данных ещё нет"
L["UI_StaleWarning"]        = "Данные могут быть устаревшими"
L["UI_NoRecipes"]           = "Откройте профессию для сканирования рецептов."
L["UI_MemberOnline"]        = "В сети"
L["UI_MemberOffline"]       = "Не в сети"
L["UI_CrafterCount_one"]    = "1 мастер может создать это:"
L["UI_CrafterCount_many"]   = "%d мастеров могут создать это:"
L["UI_AHHint"]              = "Установите Auctionator или Auctioneer для актуальных цен на реагенты."
