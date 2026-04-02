-- Agora - Minimap.lua
-- Structure identique a LibDBIcon-1.0 (copie exacte de createButton)

local GC = Agora
local L  = Agora.L

local button = CreateFrame("Button", "LibDBIcon10_Agora", Minimap)
button:SetFrameStrata("MEDIUM")
button:SetFrameLevel(8)
button:SetSize(31, 31)
button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
button:RegisterForDrag("LeftButton")
button:SetHighlightTexture(136477) -- Interface\Minimap\UI-Minimap-ZoomButton-Highlight

local overlay = button:CreateTexture(nil, "OVERLAY")
overlay:SetSize(53, 53)
overlay:SetTexture(136430) -- Interface\Minimap\MiniMap-TrackingBorder
overlay:SetPoint("TOPLEFT")

local background = button:CreateTexture(nil, "BACKGROUND")
background:SetSize(20, 20)
background:SetTexture(136467) -- Interface\Minimap\UI-Minimap-Background
background:SetPoint("TOPLEFT", 7, -5)

local icon = button:CreateTexture(nil, "ARTWORK")
icon:SetSize(17, 17)
icon:SetTexture("Interface\\AddOns\\Agora\\Agora_icon")
icon:SetTexCoord(0, 1, 0, 1)
icon:SetPoint("TOPLEFT", 7, -6)
button.icon = icon

-- ─── Position autour de la minimap (formule LibDBIcon) ────────────────────────

local rad, cos, sin = math.rad, math.cos, math.sin

local function UpdatePosition()
    local angle  = AgoraDB and AgoraDB.minimapAngle or 45
    local r      = rad(angle)
    local w      = (Minimap:GetWidth()  / 2) + 5
    local h      = (Minimap:GetHeight() / 2) + 5
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", cos(r) * w, sin(r) * h)
end

-- ─── Drag autour de la minimap ────────────────────────────────────────────────

button:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function()
        local mx, my = Minimap:GetCenter()
        local cx, cy = GetCursorPosition()
        local scale  = Minimap:GetEffectiveScale()
        cx, cy = cx / scale, cy / scale
        local newAngle = math.deg(math.atan2(cy - my, cx - mx)) % 360
        if AgoraDB then
            AgoraDB.minimapAngle = newAngle
        end
        UpdatePosition()
    end)
end)

button:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

-- ─── Clics ────────────────────────────────────────────────────────────────────

button:SetScript("OnClick", function(self, btn)
    local ok, err = pcall(function()
        if btn == "LeftButton" then
            GC:ToggleUI()
        elseif btn == "RightButton" then
            GC:ToggleDebug()
        end
    end)
    if not ok then
        print("|cffff0000" .. L["CORE_ErrorPrefix"] .. "|r" .. tostring(err))
    end
end)

-- ─── Tooltip ─────────────────────────────────────────────────────────────────

button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine(L["MINIMAP_Title"])
    GameTooltip:AddLine("|cffaaaaaa" .. L["MINIMAP_TooltipLeft"]  .. "|r", 1, 1, 1)
    GameTooltip:AddLine("|cffaaaaaa" .. L["MINIMAP_TooltipRight"] .. "|r", 1, 1, 1)
    GameTooltip:AddLine("|cffaaaaaa" .. L["MINIMAP_TooltipDrag"]  .. "|r", 1, 1, 1)
    GameTooltip:Show()
end)

button:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- ─── Init after PLAYER_LOGIN ─────────────────────────────────────────────────

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function()
    if AgoraDB and not AgoraDB.minimapAngle then
        AgoraDB.minimapAngle = 45
    end
    UpdatePosition()
end)
