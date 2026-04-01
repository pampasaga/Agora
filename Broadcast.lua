-- GuildForge - Broadcast.lua
-- Serialization, chunking, sending and receiving guild data

local GC = GuildForge

-- TBC Anniversary compatibility: SendAddonMessage is in C_ChatInfo
local SendAddonMsg = (C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage

local SEP        = "\001"   -- internal separator (ASCII 1, never in WoW names)
local CHUNK_SIZE = 200      -- max characters per addon message
local CHUNK_SEP  = "\002"   -- chunk header separator (ASCII 2)

-- Incoming chunks being reassembled: { [senderKey] = { total, count, chunks={} } }
GC.incoming = {}

-- ─── Utility: split a string by a separator ───────────────────────

local function split(str, sep)
    local result = {}
    local pos = 1
    while pos <= #str do
        local found = str:find(sep, pos, true)
        if found then
            table.insert(result, str:sub(pos, found - 1))
            pos = found + #sep
        else
            table.insert(result, str:sub(pos))
            break
        end
    end
    return result
end

-- ─── Serialization ───────────────────────────────────────────────────────────

-- Converts a member's data into a transportable string
-- Format: V1|name|realm|class|timestamp|PROF|name|lvl|max|REC|name|reagent=n|reagent=n|PROF|...
function GC:Serialize(data)
    local p = { "V1", data.name, data.realm, data.class or "", tostring(data.timestamp or 0) }

    for _, prof in ipairs(data.professions or {}) do
        table.insert(p, "PROF")
        table.insert(p, prof.name)
        table.insert(p, tostring(prof.level   or 0))
        table.insert(p, tostring(prof.maxLevel or 0))
        table.insert(p, prof.specialization or "")

        for _, recipe in ipairs(prof.recipes or {}) do
            table.insert(p, "REC")
            table.insert(p, recipe.name)
            for _, reagent in ipairs(recipe.reagents or {}) do
                -- Replace any "=" in names with " " (very rare)
                local rName = reagent.name:gsub("=", " ")
                table.insert(p, rName .. "=" .. tostring(reagent.count or 1))
            end
        end
    end

    return table.concat(p, SEP)
end

-- Reconstructs a member's data from a serialized string
function GC:Deserialize(str)
    local parts = split(str, SEP)
    if not parts[1] or parts[1] ~= "V1" then return nil end

    local data = {
        name        = parts[2] or "",
        realm       = parts[3] or "",
        class       = parts[4] or "",
        timestamp   = tonumber(parts[5]) or 0,
        professions = {},
    }

    local currentProf   = nil
    local currentRecipe = nil
    local i = 6

    while i <= #parts do
        local p = parts[i]

        if p == "PROF" then
            local spec = parts[i + 4]
            currentProf = {
                name           = parts[i + 1] or "",
                level          = tonumber(parts[i + 2]) or 0,
                maxLevel       = tonumber(parts[i + 3]) or 0,
                specialization = (spec and spec ~= "") and spec or nil,
                recipes        = {},
            }
            table.insert(data.professions, currentProf)
            currentRecipe = nil
            i = i + 5

        elseif p == "REC" then
            if currentProf then
                currentRecipe = { name = parts[i + 1] or "", reagents = {} }
                table.insert(currentProf.recipes, currentRecipe)
            end
            i = i + 2

        elseif p ~= "" then
            -- Reagent format: "name=quantity"
            if currentRecipe then
                local rName, rCount = p:match("^(.+)=(%d+)$")
                if rName and rCount then
                    table.insert(currentRecipe.reagents, { name = rName, count = tonumber(rCount) })
                end
            end
            i = i + 1

        else
            i = i + 1
        end
    end

    return data
end

-- ─── Sending ───────────────────────────────────────────────────────────────────

-- Splits a long payload into multiple addon messages of CHUNK_SIZE characters
-- Chunk format: "DATA<CHUNK_SEP>senderKey<CHUNK_SEP>idx<CHUNK_SEP>total<CHUNK_SEP>data"
function GC:SendChunked(senderKey, payload)
    local chunks = {}
    for i = 1, #payload, CHUNK_SIZE do
        table.insert(chunks, payload:sub(i, i + CHUNK_SIZE - 1))
    end

    local total = #chunks
    for idx, chunk in ipairs(chunks) do
        local msg = "DATA" .. CHUNK_SEP .. senderKey .. CHUNK_SEP
                 .. idx .. CHUNK_SEP .. total .. CHUNK_SEP .. chunk
        -- 0.05s delay between each chunk to avoid flooding
        GC:After((idx - 1) * 0.05, function()
            SendAddonMsg(GC.PREFIX, msg, "GUILD")
        end)
    end
end

-- Broadcast own data to the entire guild
function GC:SendMyData()
    if not IsInGuild() or not GuildForgeDB then return end
    local myKey = GC:GetMyKey()
    local data  = GuildForgeDB.members[myKey]
    if not data then return end
    -- Do not broadcast if no profession scanned (avoids overwriting others' data)
    if not data.professions or #data.professions == 0 then return end
    GC:SendChunked(myKey, GC:Serialize(data))
end

-- Send a HELLO: "I am new, please send me everything you have"
function GC:SendHello()
    if not IsInGuild() then return end
    SendAddonMsg(GC.PREFIX, "HELLO" .. CHUNK_SEP .. GC:GetMyKey(), "GUILD")
end

-- Broadcast own version string so guildmates can detect updates
function GC:SendVersion()
    if not IsInGuild() then return end
    SendAddonMsg(GC.PREFIX, "VERSION" .. CHUNK_SEP .. GC.VERSION_STRING, "GUILD")
end

-- Compare two semver strings ("1.2.3"). Returns 1 if a > b, -1 if a < b, 0 if equal.
local function compareVersions(a, b)
    local function parts(v)
        local t = {}
        for n in v:gmatch("%d+") do t[#t + 1] = tonumber(n) end
        return t
    end
    local pa, pb = parts(a), parts(b)
    for i = 1, math.max(#pa, #pb) do
        local va = pa[i] or 0
        local vb = pb[i] or 0
        if va > vb then return  1 end
        if va < vb then return -1 end
    end
    return 0
end

-- Send all stored data (response to a HELLO)
-- Random delay to prevent everyone from responding at the same time
function GC:SendFullGuildData()
    if not GuildForgeDB then return end
    local delay = math.random() * 3  -- 0-3s random
    local extra = 0
    for key, memberData in pairs(GuildForgeDB.members) do
        local k, d = key, memberData
        GC:After(delay + extra, function()
            GC:SendChunked(k, GC:Serialize(d))
        end)
        extra = extra + 0.5  -- 0.5s between each member
    end
end

-- ─── Reception / Receiving ───────────────────────────────────────────────────────────────

function GC:OnMessage(sender, message)
    local parts = split(message, CHUNK_SEP)
    if #parts < 1 then return end

    local msgType = parts[1]

    -- A new member is requesting all guild data
    if msgType == "HELLO" then
        local requester = parts[2]
        -- Do not respond to self
        if requester ~= GC:GetMyKey() then
            GC:SendFullGuildData()
        end

    -- Receiving a member data chunk
    elseif msgType == "DATA" then
        local senderKey = parts[2]
        local idx       = tonumber(parts[3])
        local total     = tonumber(parts[4])
        local data      = parts[5]

        if not senderKey or not idx or not total or not data then return end

        -- Do not process own data
        if senderKey == GC:GetMyKey() then return end

        -- Accumulate chunks
        if not GC.incoming[senderKey] then
            GC.incoming[senderKey] = { total = total, count = 0, chunks = {} }
        end

        local inc = GC.incoming[senderKey]
        if not inc.chunks[idx] then
            inc.chunks[idx] = data
            inc.count = inc.count + 1
        end

        -- All chunks received: reassemble and save
        if inc.count >= inc.total then
            local full = ""
            for i = 1, inc.total do
                full = full .. (inc.chunks[i] or "")
            end
            GC.incoming[senderKey] = nil

            local memberData = GC:Deserialize(full)
            if memberData and memberData.name ~= "" then
                local key = memberData.name .. "-" .. memberData.realm
                local existing = GuildForgeDB.members[key]
                if not existing or memberData.timestamp >= existing.timestamp then
                    GuildForgeDB.members[key] = memberData
                    print("|cff00ccffGuildForge:|r Donnees recues de " .. memberData.name .. ".")
                    if GC.mainFrame and GC.mainFrame:IsShown() then
                        GC:RefreshUI()
                    end
                end
            end
        end

    -- A member is broadcasting their addon version
    elseif msgType == "VERSION" then
        local theirVersion = parts[2]
        if theirVersion and not GC._newerVersionKnown then
            if compareVersions(theirVersion, GC.VERSION_STRING) > 0 then
                GC._newerVersionKnown = true
                GC._newerVersionSeen  = theirVersion
                print("|cff00ccffGuildForge:|r " .. string.format(
                    GuildForge.L["CORE_NewVersion"], theirVersion))
                if GC.UpdateFooterVersion then GC:UpdateFooterVersion() end
            end
        end

    -- A member has left the guild, purge their data
    elseif msgType == "REMOVE" then
        local key = parts[2]
        if key then
            GC:RemoveMember(key)
            if GC.mainFrame and GC.mainFrame:IsShown() then
                GC:RefreshUI()
            end
        end
    end
end
