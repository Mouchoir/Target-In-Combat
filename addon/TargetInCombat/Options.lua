local _, ns = ...
local L = ns.L

-- Panel in Options > AddOns, built with the game's Settings API.
local Options = {}
ns.Options = Options

local category

local function AddCheckbox(key, label, tooltip)
    local setting = Settings.RegisterAddOnSetting(category, "TIC_" .. key, key, ns.db,
        "boolean", label, ns.DEFAULTS[key])
    setting:SetValueChangedCallback(function() ns.Display:RefreshAll() end)
    Settings.CreateCheckbox(category, setting, tooltip)
end

function Options:Init()
    local layout
    category, layout = Settings.RegisterVerticalLayoutCategory(L.TITLE)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OPT_DISPLAY))
    AddCheckbox("nameplates", L.OPT_NAMEPLATES, L.OPT_NAMEPLATES_TT)
    AddCheckbox("targetFrame", L.OPT_TARGET, L.OPT_TARGET_TT)

    local size = Settings.RegisterAddOnSetting(category, "TIC_iconSize", "iconSize", ns.db,
        "number", L.OPT_ICON_SIZE, ns.DEFAULTS.iconSize)
    size:SetValueChangedCallback(function() ns.Display:ApplySize() end)
    local sliderOptions = Settings.CreateSliderOptions(12, 40, 1)
    sliderOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, size, sliderOptions)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OPT_UNITS))
    AddCheckbox("enemyPlayers", L.OPT_ENEMY_PLAYERS)
    AddCheckbox("enemyNPCs", L.OPT_ENEMY_NPCS)
    AddCheckbox("friendly", L.OPT_FRIENDLY)
    AddCheckbox("outOfCombat", L.OPT_OUT_OF_COMBAT, L.OPT_OUT_OF_COMBAT_TT)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OPT_ROGUE))
    AddCheckbox("sapMode", L.OPT_SAP, L.OPT_SAP_TT .. "\n\n" .. L.OPT_SAP_NOT_ROGUE)

    Settings.RegisterAddOnCategory(category)
end

function Options:Open()
    Settings.OpenToCategory(category:GetID())
end
