-- Luacheck config for WoW Forever addon Lua (Lua 5.1 runtime, 12.x API).
std = "lua51"
max_line_length = false   -- localization tables have long string lines
unused_args = false       -- WoW callbacks pass self/event args we often ignore

read_globals = {
    -- Lua helpers the game adds
    "wipe", "print", "issecretvalue",

    -- Frames, timers, client
    "CreateFrame", "C_Timer", "GetTime", "GetLocale", "TargetFrame", "C_NamePlate", "STANDARD_TEXT_FONT",

    -- Units, spells, auras
    "UnitClass", "UnitExists", "UnitIsDeadOrGhost", "UnitIsUnit", "UnitIsPlayer", "UnitCanAttack",
    "UnitAffectingCombat", "UnitCreatureType", "IsStealthed", "C_Spell", "C_UnitAuras", "C_Secrets",

    -- Settings panel
    "Settings", "CreateSettingsListSectionHeaderInitializer", "MinimalSliderWithSteppersMixin",
}

globals = {
    -- SavedVariable and slash handlers (globals WoW reads/writes)
    "TargetInCombatDB", "SLASH_TARGETINCOMBAT1", "SlashCmdList",
}
