local _, ns = ...

-- Icons on nameplates and next to the target portrait.
local Display = {}
ns.Display = Display

local STATE = ns.Rules.STATE
local COMBAT_ATLAS = "UI-HUD-UnitFrame-Player-CombatIcon"
local SAP_ICON = "Interface\\Icons\\Ability_Sap"
local CROSS_ATLAS = "UI-LFG-DeclineMark" -- the red X of the ready check
-- Rounded corners, as on Blizzard's nameplate aura icons.
local ROUND_MASK_ATLAS = "UI-HUD-CoolDownManager-Mask"
local ROUND_SWIPE = "Interface\\HUD\\UI-HUD-CoolDownManager-Icon-Swipe"
local SQUARE_SWIPE = "Interface\\Buttons\\WHITE8X8"
local REST_ATLAS = "UI-HUD-UnitFrame-Player-Rest-Flipbook" -- the player frame's Zzz, 7x6 frames

local plateIcons = {}   -- unit token -> icon frame
local pool = {}         -- released nameplate icons
local targetIcon

local function CreateIcon(parent, kind)
    local icon = CreateFrame("Frame", nil, parent)
    icon.kind = kind -- "plate" or "target", each has its own rounded option
    icon:SetFrameStrata("HIGH")
    icon.tex = icon:CreateTexture(nil, "OVERLAY")
    icon.tex:SetAllPoints()
    icon.mask = icon:CreateMaskTexture()
    icon.mask:SetAtlas(ROUND_MASK_ATLAS)
    icon.mask:SetAllPoints()
    icon.cross = icon:CreateTexture(nil, "OVERLAY", nil, 7)
    icon.cross:SetAtlas(CROSS_ATLAS)
    icon.cross:SetAllPoints()
    icon.cross:Hide()

    icon.zzz = icon:CreateTexture(nil, "OVERLAY")
    icon.zzz:SetAtlas(REST_ATLAS)
    icon.zzz:SetAllPoints()
    icon.zzz:Hide()
    icon.zzzAnim = icon:CreateAnimationGroup()
    icon.zzzAnim:SetLooping("REPEAT")
    local flip = icon.zzzAnim:CreateAnimation("FlipBook")
    flip:SetTarget(icon.zzz)
    flip:SetFlipBookRows(7)
    flip:SetFlipBookColumns(6)
    flip:SetFlipBookFrames(42)
    flip:SetDuration(1.5)

    -- Time left on our Sap: clock sweep plus seconds written on top.
    icon.cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
    icon.cd:SetAllPoints()
    icon.cd:SetHideCountdownNumbers(true)
    icon.cd:SetDrawEdge(false)
    icon.cd:Hide()
    icon.timer = icon.cd:CreateFontString(nil, "OVERLAY")
    icon.timer:SetPoint("CENTER", 0, 0)
    icon.timer:SetTextColor(1, 0.9, 0.2)

    icon.rounded = false
    icon.cd:SetSwipeTexture(SQUARE_SWIPE)
    icon.cd:SetSwipeColor(0, 0, 0, 0.6)

    icon:Hide()
    return icon
end

local function ApplyShape(icon)
    local rounded = icon.kind == "plate" and ns.db.roundPlates or ns.db.roundTarget
    if rounded == icon.rounded then return end
    icon.rounded = rounded
    if rounded then
        icon.tex:AddMaskTexture(icon.mask)
    else
        icon.tex:RemoveMaskTexture(icon.mask)
    end
    icon.cd:SetSwipeTexture(rounded and ROUND_SWIPE or SQUARE_SWIPE)
    icon.cd:SetSwipeColor(0, 0, 0, 0.6)
end

local function ShowSapTimer(icon, expires, duration)
    if not expires then
        if icon.cdExpires then
            icon.cdExpires = nil
            icon.cd:Clear()
            icon.cd:Hide()
        end
        return
    end
    if icon.cdExpires ~= expires then
        icon.cdExpires = expires
        icon.cd:Show()
        icon.cd:SetCooldown(expires - duration, duration)
    end
    local left = expires - GetTime()
    icon.timer:SetText(left > 0 and tostring(math.ceil(left)) or "")
end

local function Apply(icon, state, expires, duration)
    ApplyShape(icon)
    ShowSapTimer(icon, state ~= STATE.NONE and expires or nil, duration)
    if state == STATE.NONE then
        icon:Hide()
        return
    end

    local tex = icon.tex
    local resting = state == STATE.PEACE
    icon.cross:SetShown(state == STATE.SAP_NO)
    icon.zzz:SetShown(resting)
    tex:SetShown(not resting)
    if resting then
        if not icon.zzzAnim:IsPlaying() then icon.zzzAnim:Play() end
    else
        icon.zzzAnim:Stop()
    end

    if resting then
        icon:SetAlpha(1)
    elseif state == STATE.COMBAT then
        -- The atlas is silver: tint it red so it never reads as "greyed out".
        tex:SetAtlas(COMBAT_ATLAS)
        tex:SetTexCoord(0, 1, 0, 1)
        tex:SetDesaturated(true)
        tex:SetVertexColor(1, 0.15, 0.15)
        icon:SetAlpha(1)
    else
        tex:SetTexture(SAP_ICON)
        tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        if state == STATE.SAP_READY then
            tex:SetDesaturated(false)
            tex:SetVertexColor(1, 1, 1)
            icon:SetAlpha(1)
        elseif state == STATE.SAP_FAR then
            tex:SetDesaturated(true)
            tex:SetVertexColor(0.8, 0.8, 0.8)
            icon:SetAlpha(0.8)
        else -- SAP_NO: grey Sap under a red X, never mistaken for "too far"
            tex:SetDesaturated(true)
            tex:SetVertexColor(0.6, 0.6, 0.6)
            icon:SetAlpha(1)
        end
    end
    icon:Show()
end

-- Left of the health bar (Forever puts the level badge on the right). Friendly players
-- can be shown as a name only: the bar is hidden then, so sit left of the name text.
local function AnchorPlateIcon(icon)
    local plate = icon.plate
    local uf = plate.UnitFrame
    local mode, anchor
    if uf and uf.IsShowOnlyName and uf:IsShowOnlyName() and uf.name then
        mode, anchor = "name", uf.name
    elseif uf and uf.HealthBarsContainer and uf.HealthBarsContainer.healthBar then
        mode, anchor = "bar", uf.HealthBarsContainer.healthBar
    elseif plate.unitFrame and plate.unitFrame.healthBar then -- Plater
        mode, anchor = "bar", plate.unitFrame.healthBar
    else
        mode, anchor = "plate", plate
    end

    -- The name string can be wider than its text, so measure the text itself.
    local offset = mode == "name" and anchor:GetStringWidth() or 0
    if icon.anchorMode == mode and icon.anchorOffset == offset then return end
    icon.anchorMode, icon.anchorOffset = mode, offset

    icon:ClearAllPoints()
    if mode == "name" then
        icon:SetPoint("RIGHT", anchor, "CENTER", -offset / 2 - 3, 0)
    else
        icon:SetPoint("RIGHT", anchor, "LEFT", -3, 0)
    end
end

local function RefreshPlate(unit, icon)
    local state, expires, duration = STATE.NONE, nil, nil
    if ns.db.nameplates then
        state, expires, duration = ns.Rules:GetState(unit, true)
    end
    if state ~= STATE.NONE then AnchorPlateIcon(icon) end
    Apply(icon, state, expires, duration)
end

local function RefreshTarget()
    local state, expires, duration = STATE.NONE, nil, nil
    if ns.db.targetFrame then
        state, expires, duration = ns.Rules:GetState("target", false)
    end
    Apply(targetIcon, state, expires, duration)
end

local targetPortrait

function Display:Init()
    local container = TargetFrame and TargetFrame.TargetFrameContainer
    targetPortrait = container and container.Portrait
    if targetPortrait then
        targetIcon = CreateIcon(TargetFrame, "target")
        self:ApplyTargetPosition()
    end
    self:ApplySize()
end

-- The icon sits on the ring around the round portrait. Angle in degrees,
-- 0 at the top, growing clockwise.
function Display:ApplyTargetPosition()
    if not targetIcon then return end
    local radius = targetPortrait:GetWidth() / 2 + 2
    local angle = math.rad(ns.db.targetAngle)
    targetIcon:ClearAllPoints()
    targetIcon:SetPoint("CENTER", targetPortrait, "CENTER",
        radius * math.sin(angle), radius * math.cos(angle))
end

local function Resize(icon, size)
    icon:SetSize(size, size)
    icon.timer:SetFont(STANDARD_TEXT_FONT, math.max(8, math.floor(size * 0.6)), "OUTLINE")
end

function Display:ApplySize()
    local size = ns.db.iconSize
    if targetIcon then Resize(targetIcon, size) end
    for _, icon in pairs(plateIcons) do Resize(icon, size) end
    for _, icon in ipairs(pool) do Resize(icon, size) end
end

function Display:AddNamePlate(unit)
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate then return end -- forbidden plates are out of reach
    local icon = plateIcons[unit] or table.remove(pool) or CreateIcon(plate, "plate")
    icon:SetParent(plate)
    icon:SetFrameStrata("HIGH")
    Resize(icon, ns.db.iconSize)
    icon.plate = plate
    icon.anchorMode = nil
    plateIcons[unit] = icon
    self:RefreshUnit(unit)
end

function Display:RemoveNamePlate(unit)
    local icon = plateIcons[unit]
    if not icon then return end
    icon:Hide()
    icon:ClearAllPoints()
    icon.plate = nil
    plateIcons[unit] = nil
    pool[#pool + 1] = icon
end

function Display:RefreshUnit(unit)
    if not unit then return end
    local icon = plateIcons[unit]
    if icon then RefreshPlate(unit, icon) end
    if targetIcon and (unit == "target" or UnitIsUnit(unit, "target")) then
        RefreshTarget()
    end
end

function Display:RefreshAll()
    for unit, icon in pairs(plateIcons) do
        RefreshPlate(unit, icon)
    end
    if targetIcon then
        RefreshTarget()
    end
end
