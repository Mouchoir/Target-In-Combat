local _, ns = ...

-- Decides what a unit shows. Pure logic, no frames.
local Rules = {}
ns.Rules = Rules

local STATE = {
    NONE = 0,       -- nothing to show
    COMBAT = 1,     -- in combat
    PEACE = 2,      -- out of combat (only shown when the option is on)
    SAP_NO = 3,     -- out of combat but Sap cannot land (type, form, immunity)
    SAP_FAR = 4,    -- sappable, but out of range or the rogue cannot cast it now
    SAP_READY = 5,  -- Sap would land right now
}
Rules.STATE = STATE

local SAP_SPELL_ID = 6770 -- rank 1; range and usability checks by name follow the best rank known
local sapIds = { [6770] = true, [2070] = true, [11297] = true }
local HUMANOID = 7         -- UnitCreatureType id, locale independent

-- Auras that make a player unsappable. On Classic content Sap only hits humanoids,
-- and a shapeshifted druid or a Ghost Wolf shaman is a beast.
local BLOCKING_AURAS = {
    768,    -- Cat Form
    5487,   -- Bear Form
    9634,   -- Dire Bear Form
    783,    -- Travel Form
    1066,   -- Aquatic Form
    24858,  -- Moonkin Form
    2645,   -- Ghost Wolf
    642,    -- Divine Shield
    1020,   -- Divine Shield (rank 2)
    498,    -- Divine Protection
    5573,   -- Divine Protection (rank 2)
    1022,   -- Blessing of Protection
    5599,   -- Blessing of Protection (rank 2)
    10278,  -- Blessing of Protection (rank 3)
    11958,  -- Ice Block
    27827,  -- Spirit of Redemption
}

local blockingIds = {}
local blockingNames = {}
local sapName
local isRogue

local function IsSecret(value)
    return issecretvalue ~= nil and issecretvalue(value)
end

function Rules:Init()
    local _, class = UnitClass("player")
    isRogue = class == "ROGUE"
    sapName = C_Spell.GetSpellName(SAP_SPELL_ID)

    -- Match by id and by localized name: Forever may reuse a name with a new spell id.
    wipe(blockingIds)
    wipe(blockingNames)
    for _, id in ipairs(BLOCKING_AURAS) do
        blockingIds[id] = true
        local name = C_Spell.GetSpellName(id)
        if name then
            blockingNames[name] = true
        end
    end
end

-- True when the player is a rogue who knows Sap and has the mode on.
function Rules:SapModeActive()
    return isRogue and ns.db.sapMode and sapName ~= nil and C_Spell.GetSpellInfo(sapName) ~= nil
end

-- Reads aura i, or returns nil, true when the client keeps it secret. While the player
-- is in combat Forever restricts auras, and querying a secret one raises an error
-- instead of returning a secret value, so ask first.
local function ReadAura(unit, i, filter)
    if C_Secrets and C_Secrets.ShouldUnitAuraIndexBeSecret
        and C_Secrets.ShouldUnitAuraIndexBeSecret(unit, i, filter) then
        return nil, true
    end
    local ok, aura = pcall(C_UnitAuras.GetAuraDataByIndex, unit, i, filter)
    if not ok or IsSecret(aura) then return nil, true end
    return aura, false
end

local function HasBlockingAura(unit)
    for i = 1, 40 do
        local aura, secret = ReadAura(unit, i, "HELPFUL")
        if secret then return nil end
        if not aura then return false end
        local id, name = aura.spellId, aura.name
        if IsSecret(id) or IsSecret(name) then return nil end
        if blockingIds[id] or blockingNames[name] then return true end
    end
    return false
end

-- Our own Sap on the unit: expiration time and duration from the real debuff,
-- or nil when there is none or the client hides it.
local function FindMySap(unit)
    for i = 1, 40 do
        local aura, secret = ReadAura(unit, i, "HARMFUL|PLAYER")
        if secret or not aura then return nil end
        local id, name = aura.spellId, aura.name
        if not IsSecret(id) and not IsSecret(name) and (sapIds[id] or name == sapName) then
            local expires, duration = aura.expirationTime, aura.duration
            if IsSecret(expires) or IsSecret(duration) or not duration or duration <= 0 then
                return nil
            end
            return expires, duration
        end
    end
    return nil
end

-- Returns true, false, or nil when the client hides the answer (secret values).
local function CanBeSapped(unit)
    local _, typeId = UnitCreatureType(unit)
    if IsSecret(typeId) or typeId == nil then return nil end
    if typeId ~= HUMANOID then return false end
    local blocked = HasBlockingAura(unit)
    if blocked == nil then return nil end
    return not blocked
end

local function CanSapNow(unit)
    if not IsStealthed() then return false end
    if not C_Spell.IsSpellUsable(sapName) then return false end
    return C_Spell.IsSpellInRange(sapName, unit) == true
end

-- Whether this unit should get an icon at all, based on the unit filters.
-- The target frame shows every target; nameplates follow the filters.
function Rules:Wanted(unit, onNamePlate)
    if not UnitExists(unit) or UnitIsDeadOrGhost(unit) then
        return false
    end
    if UnitIsUnit(unit, "player") then
        return not onNamePlate and ns.db.selfTarget
    end
    if not onNamePlate then return true end
    local db = ns.db
    if UnitCanAttack("player", unit) then
        if UnitIsPlayer(unit) then return db.enemyPlayers end
        return db.enemyNPCs
    end
    return db.friendly
end

-- Returns the state, plus the expiration time and duration of our Sap on the unit if any.
function Rules:GetState(unit, onNamePlate)
    if not self:Wanted(unit, onNamePlate) then return STATE.NONE end

    local inCombat = UnitAffectingCombat(unit)
    if IsSecret(inCombat) then return STATE.NONE end
    if inCombat then return STATE.COMBAT end

    -- Targeting yourself is for setting the icon up: always show something.
    if UnitIsUnit(unit, "player") then return STATE.PEACE end

    if self:SapModeActive() and UnitCanAttack("player", unit) then
        local expires, duration = FindMySap(unit)
        if expires then
            return CanSapNow(unit) and STATE.SAP_READY or STATE.SAP_FAR, expires, duration
        end
        local sappable = CanBeSapped(unit)
        if sappable == false then return STATE.SAP_NO end
        if sappable then
            return CanSapNow(unit) and STATE.SAP_READY or STATE.SAP_FAR
        end
        -- Unknown (secret): fall back to plain combat display.
    end

    return ns.db.outOfCombat and STATE.PEACE or STATE.NONE
end
