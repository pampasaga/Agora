-- GuildCraft - Debug.lua
-- Debug interface: displays scanned data in real time

local GC = GuildCraft
local L  = GuildCraft.L

-- ─── Debug frame ──────────────────────────────────────────────────────────

function GC:CreateDebugUI()
    if GC.debugFrame then return end

    local template = BackdropTemplateMixin and "BackdropTemplate" or nil
    local frame = CreateFrame("Frame", "GuildCraftDebugFrame", UIParent, template)
    frame:SetFrameStrata("DIALOG")
    frame:SetSize(620, 720)
    frame:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop",  frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:Hide()

    if frame.SetBackdrop then frame:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    end

    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", frame, "TOP", 0, -14)
    title:SetText("|cffffff00" .. L["DEBUG_Title"] .. "|r")

    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)

    -- "Scan levels" button
    local scanBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    scanBtn:SetSize(140, 22)
    scanBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -36)
    scanBtn:SetText(L["DEBUG_ScanBtn"])
    scanBtn:SetScript("OnClick", function()
        GC:ScanProfessionLevels()
        GC:RefreshDebug()
        GC:Log("Scan des niveaux effectue.")
    end)

    -- "Scan recipes (open window)" button
    local scanRecBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    scanRecBtn:SetSize(200, 22)
    scanRecBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -62)
    scanRecBtn:SetText("|cff00ff00Scan recettes (fenetre ouverte)|r")
    scanRecBtn:SetScript("OnClick", function()
        local sName, _, _, sRank, _, sMax = GetTradeSkillLine()
        GC:Log("[DIAG] GetTradeSkillLine = " .. tostring(sName)
               .. " rank=" .. tostring(sRank) .. " max=" .. tostring(sMax))
        GC:Log("[DIAG] GetNumTradeSkills = " .. tostring(GetNumTradeSkills()))
        GC:Log("[DIAG] GC._currentTradeSkill = " .. tostring(GC._currentTradeSkill))
        local craftName = GetCraftLine and GetCraftLine() or "N/A"
        local numCrafts = GetNumCrafts and GetNumCrafts() or 0
        GC:Log("[DIAG] GetCraftLine = " .. tostring(craftName) .. "  GetNumCrafts = " .. tostring(numCrafts))

        GC:Log("=== Scan TradeSkill ===")
        GC:ScanTradeSkillRecipes()

        if craftName and craftName ~= "UNKNOWN" and craftName ~= "N/A" then
            GC:Log("=== Scan Craft (" .. craftName .. ") ===")
            GC:ScanCraftRecipes()
        else
            GC:Log("[DIAG] No Craft window open (enchanting closed?)")
        end

        GC:RefreshDebug()
        if GC.mainFrame and GC.mainFrame:IsShown() then
            GC:BuildTabs()
            GC:RefreshUI()
        end
    end)

    -- "Broadcast" button
    local broadBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    broadBtn:SetSize(140, 22)
    broadBtn:SetPoint("LEFT", scanBtn, "RIGHT", 6, 0)
    broadBtn:SetText(L["DEBUG_BroadcastBtn"])
    broadBtn:SetScript("OnClick", function()
        GC:SendMyData()
        GC:Log("Broadcast envoye a la guilde.")
    end)

    -- "Request guild data" button
    local helloBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    helloBtn:SetSize(160, 22)
    helloBtn:SetPoint("LEFT", broadBtn, "RIGHT", 6, 0)
    helloBtn:SetText(L["DEBUG_HelloBtn"])
    helloBtn:SetScript("OnClick", function()
        GC:SendHello()
        GC:Log("HELLO envoye a la guilde.")
    end)

    -- Reset DB button
    local resetBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    resetBtn:SetSize(130, 22)
    resetBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -88)
    resetBtn:SetText("|cffff4444" .. (L["DEBUG_ResetDB"] or "Reset DB") .. "|r")
    resetBtn:SetScript("OnClick", function()
        GuildCraftDB = { members = {}, version = GC.VERSION }
        GC:Log("|cffff4444[RESET]|r Database cleared.")
        GC:RefreshDebug()
        if GC.mainFrame and GC.mainFrame:IsShown() then
            GC:BuildTabs()
            GC:RefreshUI()
        end
    end)

    -- Separator
    local sep = frame:CreateTexture(nil, "BACKGROUND")
    sep:SetSize(590, 1)
    sep:SetPoint("TOP", frame, "TOP", 0, -116)
    sep:SetTexture(0.5, 0.5, 0.5, 0.5)

    -- Scanned data area
    local dataTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dataTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -126)
    dataTitle:SetText("|cff00ccff" .. L["DEBUG_MyDataTitle"] .. "|r")

    local dataScroll = CreateFrame("ScrollFrame", "GCDebugDataScroll", frame, "UIPanelScrollFrameTemplate")
    dataScroll:SetPoint("TOPLEFT",  frame, "TOPLEFT",  14, -142)
    dataScroll:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -126)
    dataScroll:SetHeight(200)

    local dataContent = CreateFrame("Frame", nil, dataScroll)
    dataContent:SetSize(560, 1)
    dataScroll:SetScrollChild(dataContent)
    frame.dataContent = dataContent

    -- Log area
    local logTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    logTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -354)
    logTitle:SetText("|cffff9900" .. L["DEBUG_LogTitle"] .. "|r")

    local clearLogBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    clearLogBtn:SetSize(90, 18)
    clearLogBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 120, -352)
    clearLogBtn:SetText("Clear logs")
    clearLogBtn:SetScript("OnClick", function()
        GC._logLines = {}
        if GC.debugFrame then
            for _, fs in ipairs(GC.debugFrame.logLines) do fs:SetText("") end
            GC.debugFrame.logLines = {}
            GC.debugFrame.logContent:SetHeight(1)
        end
    end)

    local logScroll = CreateFrame("ScrollFrame", "GCDebugLogScroll", frame, "UIPanelScrollFrameTemplate")
    logScroll:SetPoint("TOPLEFT",     frame, "TOPLEFT",     14, -370)
    logScroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 12)

    local logContent = CreateFrame("Frame", nil, logScroll)
    logContent:SetSize(520, 1)
    logScroll:SetScrollChild(logContent)
    frame.logContent  = logContent
    frame.logScroll   = logScroll

    frame.logLines    = {}
    frame.dataLines   = {}

    GC.debugFrame = frame
end

-- ─── Scanned data display ──────────────────────────────────────────

function GC:RefreshDebug()
    if not GC.debugFrame then return end
    local content = GC.debugFrame.dataContent

    for _, fs in ipairs(GC.debugFrame.dataLines) do fs:SetText("") end
    GC.debugFrame.dataLines = {}

    local function addLine(text, yOffset)
        local fs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetJustifyH("LEFT")
        fs:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
        fs:SetText(text)
        table.insert(GC.debugFrame.dataLines, fs)
        return fs
    end

    local y     = 0
    local lineH = 16
    local playerName = UnitName("player")
    local myKey      = playerName and (playerName .. "-" .. GetRealmName()) or nil
    local member     = myKey and GuildCraftDB and GuildCraftDB.members and GuildCraftDB.members[myKey]

    if not member then
        addLine("|cffff4444" .. L["DEBUG_NoData"] .. "|r", y)
        content:SetHeight(30)
        return
    end

    addLine("|cffffff00Player:|r " .. myKey, y)
    y = y - lineH
    addLine("|cffffff00Class:|r " .. (member.class or "?"), y)
    y = y - lineH
    addLine("|cffffff00Last update:|r " .. date("%H:%M:%S", member.timestamp), y)
    y = y - lineH
    addLine("|cffffff00Professions detected:|r " .. #(member.professions or {}), y)
    y = y - lineH * 1.5

    if #(member.professions or {}) == 0 then
        addLine("|cffff4444No profession detected. Make sure your professions are in the known list.|r", y)
        y = y - lineH
    end

    for _, prof in ipairs(member.professions or {}) do
        local recipeCount = #(prof.recipes or {})
        local color = recipeCount > 0 and "|cff00ff00" or "|cffff9900"
        addLine(color .. prof.name .. "|r  " ..
                "|cffaaaaaa" .. prof.level .. "/" .. prof.maxLevel .. "|r  " ..
                "|cff888888(" .. recipeCount .. L["UI_SuffixRecipes"] .. ")|r", y)
        y = y - lineH

        local shown = 0
        for _, recipe in ipairs(prof.recipes or {}) do
            if shown < 5 then
                addLine("    |cffcccccc" .. recipe.name .. "|r", y)
                y = y - lineH
                shown = shown + 1
            end
        end
        if recipeCount > 5 then
            addLine("    |cff888888... and " .. (recipeCount - 5) .. " more|r", y)
            y = y - lineH
        end
        if recipeCount == 0 then
            addLine("    |cffff9900" .. L["UI_OpenTradeSkill"] .. "|r", y)
            y = y - lineH
        end
        y = y - lineH * 0.5
    end

    local memberCount = 0
    for _ in pairs(GuildCraftDB.members) do memberCount = memberCount + 1 end
    y = y - lineH * 0.5
    addLine("|cffffff00" .. string.format(L["DEBUG_MembersInDB"], memberCount) .. "|r", y)

    content:SetHeight(math.abs(y) + 20)
end

-- ─── Log ─────────────────────────────────────────────────────────────────────


GC._logLines = {}

function GC:Log(msg)
    local frame = GC.debugFrame
    if not frame then return end

    local ts   = date("%H:%M:%S")
    local line = "|cff888888[" .. ts .. "]|r " .. msg
    table.insert(GC._logLines, line)

    while #GC._logLines > 50 do
        table.remove(GC._logLines, 1)
    end

    local content = frame.logContent
    for _, fs in ipairs(frame.logLines) do fs:SetText("") end
    frame.logLines = {}

    local y = 0
    for i = #GC._logLines, 1, -1 do
        local fs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetJustifyH("LEFT")
        fs:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
        fs:SetText(GC._logLines[i])
        table.insert(frame.logLines, fs)
        y = y - 16
    end
    content:SetHeight(math.max(math.abs(y), 1))
end

-- ─── Event hooks to feed the log ─────────────────────────────────────────────

local _origOnLogin = GC.OnLogin
function GC:OnLogin()
    GC:Log("PLAYER_LOGIN - init en cours...")
    _origOnLogin(self)
end

local function debugGetMyKey()
    local n = UnitName and UnitName("player") or "Unknown"
    local r = ""
    if GetRealmName then
        local ok, v = pcall(GetRealmName)
        if ok and v and v ~= "" then r = v end
    end
    if r == "" then r = "Local" end
    return n .. "-" .. r
end

local _origScanLevels = GC.ScanProfessionLevels
function GC:ScanProfessionLevels()
    _origScanLevels(self)
    local member = GuildCraftDB and GuildCraftDB.members and GuildCraftDB.members[debugGetMyKey()]
    if member then
        GC:Log("ScanProfessionLevels - " .. #(member.professions or {}) .. " metier(s) detecte(s)")
    end
    if GC.debugFrame and GC.debugFrame:IsShown() then GC:RefreshDebug() end
end

local _origScanRecipes = GC.ScanTradeSkillRecipes
function GC:ScanTradeSkillRecipes()
    _origScanRecipes(self)
    local member = GuildCraftDB and GuildCraftDB.members and GuildCraftDB.members[debugGetMyKey()]
    if member then
        for _, prof in ipairs(member.professions or {}) do
            GC:Log("Recettes scannees : " .. prof.name .. " (" .. #prof.recipes .. " recettes)")
        end
    end
    if GC.debugFrame and GC.debugFrame:IsShown() then GC:RefreshDebug() end
end

local _origOnMessage = GC.OnMessage
function GC:OnMessage(sender, message)
    local msgType = message:sub(1, 4)
    if msgType == "HELL" then
        GC:Log("HELLO recu de " .. sender)
    elseif msgType == "DATA" then
        GC:Log("DATA chunk recu de " .. sender)
    elseif msgType == "REMO" then
        GC:Log("REMOVE recu : " .. sender)
    end
    _origOnMessage(self, sender, message)
    if GC.debugFrame and GC.debugFrame:IsShown() then GC:RefreshDebug() end
end

local _origSendMyData = GC.SendMyData
function GC:SendMyData()
    GC:Log("Broadcast de mes donnees...")
    _origSendMyData(self)
end

-- ─── Toggle debug ─────────────────────────────────────────────────────────────

function GC:ToggleDebug()
    local ok, err = pcall(function()
        if not GC.debugFrame then
            GC:CreateDebugUI()
        end
        if GC.debugFrame:IsShown() then
            GC.debugFrame:Hide()
        else
            GC:RefreshDebug()
            GC.debugFrame:Show()
        end
    end)
    if not ok then
        print("|cffff0000" .. L["CORE_DebugErrorPrefix"] .. "|r" .. tostring(err))
    end
end
