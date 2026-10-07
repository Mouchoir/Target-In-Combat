local _, ns = ...
local L = ns.L

-- Panel in Options > AddOns, built with the game's Settings API.
local Options = {}
ns.Options = Options

local category, layout

local function AddCheckbox(key, label, tooltip)
    local setting = Settings.RegisterAddOnSetting(category, "TIC_" .. key, key, ns.db,
        "boolean", label, ns.DEFAULTS[key])
    setting:SetValueChangedCallback(function() ns.Display:RefreshAll() end)
    Settings.CreateCheckbox(category, setting, tooltip)
end

local function Refresh() ns.Display:RefreshAll() end

local function AddCornerSlider(key, label)
    local setting = Settings.RegisterAddOnSetting(category, "TIC_" .. key, key, ns.db,
        "number", label, ns.DEFAULTS[key])
    setting:SetValueChangedCallback(Refresh)
    local options = Settings.CreateSliderOptions(0, 100, 10)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right,
        function(value) return value .. "%" end)
    Settings.CreateSlider(category, setting, options, L.OPT_CORNER_TT)
end

local function AddSimulation()
    local sim = ns.sim
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OPT_SIM))

    local enabled = Settings.RegisterProxySetting(category, "TIC_simEnabled", "boolean",
        L.OPT_SIM_ENABLE, false,
        function() return sim.enabled end,
        function(value) sim.enabled = value; Refresh() end)
    local parent = Settings.CreateCheckbox(category, enabled, L.OPT_SIM_ENABLE_TT)
    local function IsOn() return sim.enabled end

    -- Combat and Sap exclude each other: picking one resets the other, through the
    -- setting so the dropdown on screen follows.
    local combat, sap
    combat = Settings.RegisterProxySetting(category, "TIC_simCombat", "number",
        L.OPT_SIM_COMBAT, 0,
        function() return sim.combat end,
        function(value)
            sim.combat = value
            if value ~= 0 and sim.sap ~= 0 then sap:SetValue(0) end
            Refresh()
        end)
    Settings.CreateDropdown(category, combat, function()
        local c = Settings.CreateControlTextContainer()
        c:Add(0, L.SIM_OUT_OF_COMBAT)
        c:Add(1, L.SIM_IN_COMBAT)
        return c:GetData()
    end, L.OPT_SIM_COMBAT_TT):SetParentInitializer(parent, IsOn)

    sap = Settings.RegisterProxySetting(category, "TIC_simSap", "number",
        L.OPT_SIM_SAP, 0,
        function() return sim.sap end,
        function(value)
            sim.sap = value
            if value ~= 0 and sim.combat ~= 0 then combat:SetValue(0) end
            Refresh()
        end)
    Settings.CreateDropdown(category, sap, function()
        local c = Settings.CreateControlTextContainer()
        c:Add(0, L.SIM_SAP_NONE)
        c:Add(1, L.SIM_SAP_NO)
        c:Add(2, L.SIM_SAP_READY)
        c:Add(3, L.SIM_SAP_SAPPED)
        return c:GetData()
    end, L.OPT_SIM_SAP_TT):SetParentInitializer(parent, IsOn)
end

function Options:Init()
    category, layout = Settings.RegisterVerticalLayoutCategory(L.TITLE)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OPT_DISPLAY))
    AddCheckbox("nameplates", L.OPT_NAMEPLATES, L.OPT_NAMEPLATES_TT)
    AddCheckbox("targetFrame", L.OPT_TARGET, L.OPT_TARGET_TT)
    AddCheckbox("selfTarget", L.OPT_SELF, L.OPT_SELF_TT)

    local size = Settings.RegisterAddOnSetting(category, "TIC_iconSize", "iconSize", ns.db,
        "number", L.OPT_ICON_SIZE, ns.DEFAULTS.iconSize)
    size:SetValueChangedCallback(function() ns.Display:ApplySize() end)
    local sliderOptions = Settings.CreateSliderOptions(12, 40, 1)
    sliderOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, size, sliderOptions)

    local angle = Settings.RegisterAddOnSetting(category, "TIC_targetAngle", "targetAngle", ns.db,
        "number", L.OPT_TARGET_ANGLE, ns.DEFAULTS.targetAngle)
    angle:SetValueChangedCallback(function() ns.Display:ApplyTargetPosition() end)
    local angleOptions = Settings.CreateSliderOptions(0, 355, 5)
    angleOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, angle, angleOptions, L.OPT_TARGET_ANGLE_TT)

    local side = Settings.RegisterAddOnSetting(category, "TIC_platesSide", "platesSide",
        ns.db, "number", L.OPT_SIDE, ns.DEFAULTS.platesSide)
    side:SetValueChangedCallback(Refresh)
    Settings.CreateDropdown(category, side, function()
        local c = Settings.CreateControlTextContainer()
        c:Add(0, L.SIDE_LEFT)
        c:Add(1, L.SIDE_RIGHT)
        return c:GetData()
    end, L.OPT_SIDE_TT)

    AddCornerSlider("cornerTarget", L.OPT_CORNER_TARGET)
    AddCornerSlider("cornerPlates", L.OPT_CORNER_PLATES)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OPT_UNITS))
    AddCheckbox("enemyPlayers", L.OPT_ENEMY_PLAYERS)
    AddCheckbox("enemyNPCs", L.OPT_ENEMY_NPCS)
    AddCheckbox("friendly", L.OPT_FRIENDLY)
    local ooc = Settings.RegisterAddOnSetting(category, "TIC_outOfCombatIcon", "outOfCombatIcon",
        ns.db, "number", L.OPT_OUT_OF_COMBAT, ns.DEFAULTS.outOfCombatIcon)
    ooc:SetValueChangedCallback(Refresh)
    Settings.CreateDropdown(category, ooc, function()
        local c = Settings.CreateControlTextContainer()
        c:Add(0, L.OOC_NONE)
        c:Add(1, L.OOC_ZZZ)
        c:Add(2, L.OOC_SWORDS)
        return c:GetData()
    end, L.OPT_OUT_OF_COMBAT_TT)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OPT_ROGUE))
    AddCheckbox("sapMode", L.OPT_SAP, L.OPT_SAP_TT .. "\n\n" .. L.OPT_SAP_NOT_ROGUE)

    AddSimulation()

    Settings.RegisterAddOnCategory(category)
end

function Options:Open()
    Settings.OpenToCategory(category:GetID())
end
