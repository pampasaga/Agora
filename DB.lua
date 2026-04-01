-- GuildForge - DB.lua
-- Read / write member data in GuildForgeDB (SavedVariables)

local GC = GuildForge

-- Save or update a member
function GC:SaveMember(data)
    if not data or not data.name or not data.realm then return end
    local key = data.name .. "-" .. data.realm
    GuildForgeDB.members[key] = data
end

-- Remove a member by key
function GC:RemoveMember(key)
    if GuildForgeDB and GuildForgeDB.members then
        GuildForgeDB.members[key] = nil
    end
end

-- Returns the set of base names currently in the guild (requires IsInGuild)
function GC:GetCurrentGuildSet()
    local set = {}
    if not IsInGuild() then return set end
    local numMembers = GetNumGuildMembers and GetNumGuildMembers() or 0
    for i = 1, numMembers do
        local name = (GetGuildRosterInfo(i))
        if name then
            local base = name:match("^([^%-]+)") or name
            set[base] = true
        end
    end
    return set
end

-- Returns only members of the current guild (filtered by WoW roster)
-- The current player is always included (to see their own recipes while out of guild)
function GC:GetAllMembers()
    if not GuildForgeDB then return {} end

    local myKey = GC:GetMyKey()

    if not IsInGuild() then
        -- Out of guild: only own data
        local result = {}
        if myKey and GuildForgeDB.members[myKey] then
            result[myKey] = GuildForgeDB.members[myKey]
        end
        return result
    end

    local roster = GC:GetCurrentGuildSet()
    -- If the roster is not yet loaded, return everything (avoids empty UI at boot)
    if next(roster) == nil then
        return GuildForgeDB.members or {}
    end

    local result = {}
    for key, data in pairs(GuildForgeDB.members or {}) do
        local base = key:match("^([^%-]+)") or key
        if roster[base] then
            result[key] = data
        end
    end
    -- Always include the current player even if the roster is partial
    if myKey and GuildForgeDB.members[myKey] then
        result[myKey] = GuildForgeDB.members[myKey]
    end
    return result
end

-- Returns members who have a given profession
function GC:GetMembersWithProfession(profName)
    local result = {}
    for key, member in pairs(GC:GetAllMembers()) do
        for _, prof in ipairs(member.professions or {}) do
            if prof.name == profName then
                table.insert(result, { key = key, member = member, prof = prof })
                break
            end
        end
    end
    -- Sort by profession level descending
    table.sort(result, function(a, b)
        return (a.prof.level or 0) > (b.prof.level or 0)
    end)
    return result
end

-- Returns the list of all professions present in the guild (no duplicates)
function GC:GetAllProfessions()
    local seen = {}
    local list = {}
    for _, member in pairs(GC:GetAllMembers()) do
        for _, prof in ipairs(member.professions or {}) do
            if not seen[prof.name] then
                seen[prof.name] = true
                table.insert(list, prof.name)
            end
        end
    end
    table.sort(list)
    return list
end

-- Purge members who are no longer in the guild
function GC:CleanupDepartedMembers()
    if not IsInGuild() or not GuildForgeDB then return end

    -- Build a set of current members (by base name)
    local current = {}
    local numMembers = GetNumGuildMembers and GetNumGuildMembers() or 0

    -- If the roster is not yet loaded (0 members), do nothing.
    -- Deleting everything on an empty roster would erase valid data.
    if numMembers == 0 then return end

    for i = 1, numMembers do
        local name = (GetGuildRosterInfo(i))
        if name then
            -- Strip the -Realm suffix if present (Cata+)
            local baseName = name:match("^([^%-]+)") or name
            current[baseName] = true
        end
    end

    -- Always keep the current player's data
    local myKey = GC:GetMyKey()
    if myKey then
        local myBase = myKey:match("^([^%-]+)") or myKey
        current[myBase] = true
    end

    -- Remove those who are no longer in the guild
    for key in pairs(GuildForgeDB.members) do
        local baseName = key:match("^([^%-]+)") or key
        if not current[baseName] then
            print("|cff00ccffGuildForge:|r " .. baseName .. " a quitte la guilde, donnees supprimees.")
            GuildForgeDB.members[key] = nil
        end
    end
end
