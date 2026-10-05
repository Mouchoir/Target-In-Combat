local _, ns = ...

-- Icons on nameplates and next to the target portrait.
local Display = {}
ns.Display = Display

local STATE = ns.Rules.STATE
local COMBAT_ATLAS = "UI-HUD-UnitFrame-Player-CombatIcon"
local SAP_ICON = "Interface\\Icons\\Ability_Sap"

local plateIcons = {}   -- unit token -> icon frame
local pool = {}         -- released nameplate icons
local targetIcon

local function CreateIcon(parent)
    local icon = CreateFrame("Frame", nil, parent)
    icon:SetFrameStrata("HIGH")
    icon.tex = icon:CreateTexture(nil, "OVERLAY")
    icon.tex:SetAllPoints()
    icon:Hide()
    return icon
end

local function Apply(icon, state)
    if state == STATE.NONE then
        icon:Hide()
        return
    end

    local tex = icon.tex
    if state == STATE.COMBAT or state == STATE.PEACE then
        -- The atlas is silver: tint it red in combat so it never reads as "greyed out".
        tex:SetAtlas(COMBAT_ATLAS)
        tex:SetTexCoord(0, 1, 0, 1)
        tex:SetDesaturated(true)
        if state == STATE.COMBAT then
            tex:SetVertexColor(1, 0.15, 0.15)
            icon:SetAlpha(1)
        else
            tex:SetVertexColor(1, 1, 1)
            icon:SetAlpha(0.4)
        end
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
        else -- SAP_NO
            tex:SetDesaturated(true)
            tex:SetVertexColor(1, 0.25, 0.25)
            icon:SetAlpha(0.9)
        end
    end
    icon:Show()
end

-- Anchor on the health bar when we can find one (Blizzard, then Plater), else on the plate.
local function PlateAnchor(plate)
    local uf = plate.UnitFrame
    if uf and uf.HealthBarsContainer and uf.HealthBarsContainer.healthBar then
        return uf.HealthBarsContainer.healthBar
    end
    if plate.unitFrame and plate.unitFrame.healthBar then
        return plate.unitFrame.healthBar
    end
    return plate
end

local targetPortrait

function Display:Init()
    local container = TargetFrame and TargetFrame.TargetFrameContainer
    targetPortrait = container and container.Portrait
    if targetPortrait then
        targetIcon = CreateIcon(TargetFrame)
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

function Display:ApplySize()
    local size = ns.db.iconSize
    if targetIcon then targetIcon:SetSize(size, size) end
    for _, icon in pairs(plateIcons) do icon:SetSize(size, size) end
    for _, icon in ipairs(pool) do icon:SetSize(size, size) end
end

function Display:AddNamePlate(unit)
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate then return end -- forbidden plates are out of reach
    local icon = plateIcons[unit] or table.remove(pool) or CreateIcon(plate)
    icon:SetParent(plate)
    icon:SetFrameStrata("HIGH")
    icon:SetSize(ns.db.iconSize, ns.db.iconSize)
    icon:ClearAllPoints()
    -- Left of the bar: Forever puts the level badge on the right.
    icon:SetPoint("RIGHT", PlateAnchor(plate), "LEFT", -3, 0)
    plateIcons[unit] = icon
    self:RefreshUnit(unit)
end

function Display:RemoveNamePlate(unit)
    local icon = plateIcons[unit]
    if not icon then return end
    icon:Hide()
    icon:ClearAllPoints()
    plateIcons[unit] = nil
    pool[#pool + 1] = icon
end

function Display:RefreshUnit(unit)
    if not unit then return end
    local icon = plateIcons[unit]
    if icon then
        Apply(icon, ns.db.nameplates and ns.Rules:GetState(unit, true) or STATE.NONE)
    end
    if targetIcon and (unit == "target" or UnitIsUnit(unit, "target")) then
        Apply(targetIcon, ns.db.targetFrame and ns.Rules:GetState("target", false) or STATE.NONE)
    end
end

function Display:RefreshAll()
    for unit, icon in pairs(plateIcons) do
        Apply(icon, ns.db.nameplates and ns.Rules:GetState(unit, true) or STATE.NONE)
    end
    if targetIcon then
        Apply(targetIcon, ns.db.targetFrame and ns.Rules:GetState("target", false) or STATE.NONE)
    end
end
