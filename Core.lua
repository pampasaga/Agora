-- GuildCraft - Core.lua
-- Namespace, initialization, event management

GuildCraft = {}
local GC = GuildCraft

-- Slash commands first, before any code that could crash
SLASH_GUILDCRAFT1 = "/guildcraft"
SLASH_GUILDCRAFT2 = "/gcr"
SLASH_GUILDCRAFT3 = "/gct"
SlashCmdList["GUILDCRAFT"] = function(msg)
    if GC.ToggleUI then
        local ok, err = pcall(function()
            if msg == "scan" then
                GC:ScanProfessionLevels()
                GC:SendMyData()
                print("|cff00ff00GuildCraft:|r Scan done.")
            elseif msg == "debug" then
                GC:ToggleDebug()
            else
                GC:ToggleUI()
            end
        end)
        if not ok then print("|cffff0000GuildCraft:|r " .. tostring(err)) end
    end
end

GC.PREFIX         = "GCRAFT"
GC.VERSION        = 1
GC.VERSION_STRING = "0.9.0"
GC.devMode        = false

-- Locale string table. Populated by Locales/ files loaded after Core.lua.
-- Falls back to the key itself if a translation is missing.
GC.L = setmetatable({}, {
    __index = function(_, key)
        return key
    end,
})

-- Timer without dependency on C_Timer (compatible TBC/Wrath/Cata)
function GC:After(delay, callback)
    local elapsed = 0
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        if elapsed >= delay then
            self:SetScript("OnUpdate", nil)
            callback()
        end
    end)
end

-- Register addon prefix
if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    C_ChatInfo.RegisterAddonMessagePrefix(GC.PREFIX)
elseif RegisterAddonMessagePrefix then
    RegisterAddonMessagePrefix(GC.PREFIX)
end

-- Immediate DB initialization
if not GuildCraftDB then
    GuildCraftDB = { members = {}, version = GC.VERSION }
end

-- Main event frame
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("CHAT_MSG_ADDON")
eventFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
eventFrame:RegisterEvent("TRADE_SKILL_SHOW")
eventFrame:RegisterEvent("TRADE_SKILL_UPDATE")
eventFrame:RegisterEvent("CRAFT_SHOW")
eventFrame:RegisterEvent("CRAFT_UPDATE")
eventFrame:RegisterEvent("PLAYER_GUILD_UPDATE")
eventFrame:RegisterEvent("TRADE_SKILL_CLOSE")
-- SKILL_LINES_CHANGED : replacement for LEARNED_SPELL_IN_TAB on TBC (tested with pcall)
local ok_slc = pcall(function() eventFrame:RegisterEvent("SKILL_LINES_CHANGED") end)
if not ok_slc then
    GC:Log("[INIT] SKILL_LINES_CHANGED non supporte sur ce client")
end

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" or (event == "PLAYER_ENTERING_WORLD" and not GC._loginDone) then
        GC._loginDone = true
        GC:Log("[EVENT] " .. event .. " -> OnLogin")
        GC:OnLogin()

    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        GC:OnAddonMessage(prefix, message, channel, sender)

    elseif event == "GUILD_ROSTER_UPDATE" then
        GC:OnRosterUpdate()

    elseif event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_UPDATE" then
        if event == "TRADE_SKILL_SHOW" then
            GC._currentTradeSkill = nil
        end

        local function TryResolveName()
            local nameNow = GetTradeSkillLine()
            if (not nameNow or nameNow == "UNKNOWN") and TradeSkillFrame then
                for _, region in pairs({ TradeSkillFrame:GetRegions() }) do
                    if region.GetText then
                        local t = region:GetText()
                        if t and t ~= "" then
                            if not nameNow or nameNow == "UNKNOWN" then
                                nameNow = t
                            end
                        end
                    end
                end
            end
            if nameNow and nameNow ~= "UNKNOWN" then
                local cleaned = nameNow:match("^([^%(]+)") or nameNow
                cleaned = cleaned:match("^%s*(.-)%s*$")
                GC._currentTradeSkill = cleaned
                GC:Log("[EVENT] currentTradeSkill = " .. cleaned)
            end
            return nameNow
        end

        local nameNow = TryResolveName()
        GC:Log("[EVENT] " .. event .. " - GetTradeSkillLine = " .. tostring(nameNow))

        GC:After(1.5, function()
            if not GC._currentTradeSkill then
                TryResolveName()
            end
            GC:ScanTradeSkillRecipes()
            if GetCraftLine then
                local cn = GetCraftLine()
                if cn and cn ~= "UNKNOWN" then
                    GC:ScanCraftRecipes()
                end
            end
        end)

    elseif event == "CRAFT_SHOW" or event == "CRAFT_UPDATE" then
        GC:After(1.5, function()
            GC:ScanCraftRecipes()
        end)

    elseif event == "SKILL_LINES_CHANGED" then
        if GC._initComplete then
            GC:After(0.5, function()
                GC:ScanProfessionLevels()
                GC:SendMyData()
                print("|cff00ccffGuildCraft:|r Nouveau patron appris, sync envoyee.")
            end)
        end

    elseif event == "TRADE_SKILL_CLOSE" then
        if GC._initComplete and IsInGuild() then
            GC:After(0.3, function()
                GC:SendMyData()
            end)
        end

    elseif event == "PLAYER_GUILD_UPDATE" then
        if IsInGuild() then
            if not GC._inGuild then
                GC._inGuild = true
                GC:Log("[EVENT] PLAYER_GUILD_UPDATE -> rejoint une guilde")
                GC:After(3, function()
                    GC:ScanProfessionLevels()
                    GC:SendHello()
                end)
                GC:After(5, function()
                    GC:SendMyData()
                    GC._initComplete = true
                end)
            end
        else
            GC._inGuild = false
            GC._initComplete = false
            GC:Log("[EVENT] PLAYER_GUILD_UPDATE -> quitte la guilde")
        end
    end
end)

-- Fallback init : OnUpdate guaranteed if PLAYER_LOGIN/PLAYER_ENTERING_WORLD do not fire
local initFrame = CreateFrame("Frame")
initFrame:SetScript("OnUpdate", function(self)
    if not GC._loginDone and IsLoggedIn and IsLoggedIn() then
        GC._loginDone = true
        GC:Log("[INIT] OnUpdate fallback -> OnLogin")
        GC:OnLogin()
    end
    -- Disable as soon as init is done
    if GC._loginDone then
        self:SetScript("OnUpdate", nil)
    end
end)

-- Unique key for the current player: "Name-Realm"
function GC:GetMyKey()
    if not GC._myKey then
        local name  = UnitName("player") or "Unknown"
        local realm = GetRealmName and GetRealmName() or ""
        if realm == "" or realm == nil then realm = "Local" end
        GC._myKey = name .. "-" .. realm
    end
    return GC._myKey
end

function GC:OnLogin()
    if not GuildCraftDB then
        GuildCraftDB = { members = {}, version = GC.VERSION }
    end

    -- Scan always runs, in guild or not
    GC:After(3, function()
        GC:ScanProfessionLevels()
        GC._initComplete = true

        if IsInGuild() then
            GC._inGuild = true
            GC:SendHello()
            print("|cff00ccffGuildCraft:|r charge — ouvre tes fenetres de metier pour partager tes recettes.")
        else
            print("|cff00ccffGuildCraft:|r charge (hors guilde) — ouvre tes fenetres de metier pour scanner tes patrons.")
        end
    end)

    if IsInGuild() then
        GC._inGuild = true
        GC:After(5, function()
            GC:SendMyData()
            print("|cff00ccffGuildCraft:|r Donnees broadcaste a la guilde.")
        end)
    end
end

-- Single entry point for addon messages (real or simulated)
function GC:OnAddonMessage(prefix, message, channel, sender)
    if prefix == GC.PREFIX then
        GC:OnMessage(sender, message)
    end
end

function GC:OnRosterUpdate()
    if not GuildCraftDB then return end
    GC:CleanupDepartedMembers()
end
