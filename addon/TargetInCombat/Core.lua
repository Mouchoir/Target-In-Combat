local addonName, ns = ...
local L = ns.L

local DEFAULTS = {
    nameplates = true,
    targetFrame = true,
    selfTarget = false,
    iconSize = 20,
    targetAngle = 315,
    cornerTarget = 0,
    cornerPlates = 0,
    enemyPlayers = true,
    enemyNPCs = false,
    friendly = false,
    outOfCombatIcon = 0, -- 0 nothing, 1 Zzz, 2 grey swords
    sapMode = true,
}

ns.DEFAULTS = DEFAULTS

-- Preview of every look on the current target only. Never saved, so a forgotten
-- simulation is gone after the next /reload.
ns.sim = {
    enabled = false,
    combat = 0, -- 0 out of combat, 1 in combat
    sap = 0,    -- 0 no Sap icon, 1 not sappable, 2 sappable, 3 sapped (looping timer)
}

-- Refresh rate for range and combat state. Range has no event, so we poll.
local TICK = 0.2

local function LoadDB()
    if type(TargetInCombatDB) ~= "table" then
        TargetInCombatDB = {}
    end
    -- 0.2.0 had a plain on/off for the out-of-combat icon (always the Zzz).
    local db = TargetInCombatDB
    if db.outOfCombatIcon == nil and db.outOfCombat ~= nil then
        db.outOfCombatIcon = db.outOfCombat and 1 or 0
    end
    db.outOfCombat, db.roundTarget, db.roundPlates = nil, nil, nil

    for key, value in pairs(DEFAULTS) do
        if TargetInCombatDB[key] == nil then
            TargetInCombatDB[key] = value
        end
    end
    ns.db = TargetInCombatDB
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 ~= addonName then return end
        frame:UnregisterEvent("ADDON_LOADED")
        LoadDB()
        ns.Rules:Init()
        ns.Display:Init()
        ns.Options:Init()

        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
        frame:RegisterEvent("PLAYER_TARGET_CHANGED")
        frame:RegisterEvent("UNIT_FLAGS")
        frame:RegisterEvent("UNIT_AURA")
        frame:RegisterEvent("UPDATE_STEALTH")
        frame:RegisterEvent("SPELLS_CHANGED")
        C_Timer.NewTicker(TICK, function() ns.Display:RefreshAll() end)
        print("|cff40c0ff" .. L.TITLE .. "|r " .. L.LOADED)
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        ns.Display:AddNamePlate(arg1)
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        ns.Display:RemoveNamePlate(arg1)
    elseif event == "UNIT_FLAGS" or event == "UNIT_AURA" then
        ns.Display:RefreshUnit(arg1)
    elseif event == "SPELLS_CHANGED" then
        ns.Rules:Init()
        ns.Display:RefreshAll()
    else
        ns.Display:RefreshAll()
    end
end)

SLASH_TARGETINCOMBAT1 = "/tic"
SlashCmdList.TARGETINCOMBAT = function()
    ns.Options:Open()
end
