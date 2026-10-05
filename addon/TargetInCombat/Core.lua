local addonName, ns = ...
local L = ns.L

local DEFAULTS = {
    nameplates = true,
    targetFrame = true,
    iconSize = 20,
    targetAngle = 315,
    enemyPlayers = true,
    enemyNPCs = false,
    friendly = false,
    outOfCombat = false,
    sapMode = true,
}

ns.DEFAULTS = DEFAULTS

-- Refresh rate for range and combat state. Range has no event, so we poll.
local TICK = 0.2

local function LoadDB()
    if type(TargetInCombatDB) ~= "table" then
        TargetInCombatDB = {}
    end
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
