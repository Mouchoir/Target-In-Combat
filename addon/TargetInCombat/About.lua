-- "About" page: links to the author's other addons that run on this game version.
-- Self-contained and identical in every addon of the family; the master copy
-- lives in TargetInCombat.
-- To add an addon, add one row to ADDONS below.
local addonName, ns = ...
ns = ns or {}

local About = {}
ns.About = About

local fr = GetLocale() == "frFR"
local T = fr and {
    TITLE = "À propos",
    HEADER = "Autres addons de Mouchoir",
    SUB = "Ceux qui fonctionnent sur cette version du jeu.",
    INSTALLED = "Installé",
    THIS = "Cet addon",
    COPY = "Copier le lien",
    COPY_TT = "Ctrl+C pour copier, puis collez le lien dans votre navigateur.",
    POPUP = "Copiez ce lien (Ctrl+C) :",
} or {
    TITLE = "About",
    HEADER = "More addons by Mouchoir",
    SUB = "The ones that run on this version of the game.",
    INSTALLED = "Installed",
    THIS = "This addon",
    COPY = "Copy link",
    COPY_TT = "Ctrl+C to copy, then paste the link in your browser.",
    POPUP = "Copy this link (Ctrl+C):",
}

-- flavors: forever, mists, era, retail (see Flavor()).
local ADDONS = {
    {
        folder = "TargetInCombat", slug = "target-in-combat-can-i-sap-it",
        name = "Target In Combat - TIC", flavors = { forever = true },
        desc = "Shows whether a unit is in combat, and who a rogue can sap.",
        descFR = "Indique si une unité est en combat, et qui un voleur peut assommer.",
    },
    {
        folder = "TimelessQuestion", slug = "timeless-question-autocomplete",
        name = "Timeless Question Autocomplete", flavors = { mists = true, retail = true },
        desc = "Answers Evelyna's daily question for you.",
        descFR = "Répond à la question quotidienne d'Evelyna à votre place.",
    },
    {
        folder = "DarkmoonFaireBuff", slug = "darkmoon-faire-buff-dfb",
        name = "Darkmoon Faire Buff (DFB)", flavors = { era = true, mists = true },
        desc = "Pick Sayge's buff once, then just talk to him.",
        descFR = "Choisissez une fois le buff de Sayge, ensuite parlez-lui simplement.",
    },
    {
        folder = "HardcoreCongrats", slug = "hardcore-congrats",
        name = "Hardcore Congrats", flavors = { era = true },
        desc = "Congratulates players on your realm who reach level 60 in Hardcore.",
        descFR = "Félicite les joueurs de votre royaume qui atteignent le niveau 60 en Hardcore.",
    },
    {
        folder = "PartyRoleIcons", slug = "party-role-icons-display-group-roles",
        name = "Party Role Icons", flavors = { era = true, mists = true },
        desc = "Shows group roles on the party and raid frames.",
        descFR = "Affiche les rôles de groupe sur les cadres de groupe et de raid.",
    },
    {
        folder = "MogWhere", slug = "mogwhere-find-transmog-appearance-sources-and",
        name = "MogWhere", flavors = { mists = true },
        desc = "Vendor, cost, reputation and waypoint in the Appearances tab.",
        descFR = "Vendeur, coût, réputation et point de passage dans l'onglet Apparences.",
    },
}

local function Flavor()
    local build = select(4, GetBuildInfo())
    if build >= 100000 then return "retail" end
    if build >= 50000 then return "mists" end
    if build >= 15000 then return "forever" end
    return "era"
end

local function IsInstalled(folder)
    local getInfo = C_AddOns and C_AddOns.GetAddOnInfo or GetAddOnInfo
    local ok, found = pcall(getInfo, folder)
    return ok and found ~= nil
end

local function Url(entry)
    return "https://www.curseforge.com/wow/addons/" .. entry.slug
end

-- One popup per addon of the family, so the dialogs never clash.
local POPUP = "MOUCHOIR_ABOUT_LINK_" .. addonName
StaticPopupDialogs[POPUP] = {
    text = T.POPUP,
    button1 = CLOSE,
    hasEditBox = true,
    editBoxWidth = 320,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnShow = function(self, url)
        local box = self.GetEditBox and self:GetEditBox() or self.editBox
        box:SetText(url or "")
        box:HighlightText()
        box:SetFocus()
    end,
    EditBoxOnEscapePressed = function(box) box:GetParent():Hide() end,
}

local ROW_HEIGHT = 46

local function BuildRow(parent, entry, previous)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(ROW_HEIGHT)
    row:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -4)
    row:SetPoint("RIGHT", parent, "RIGHT", -16, 0)

    local name = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    name:SetPoint("TOPLEFT", 0, 0)
    name:SetText(entry.name)

    local desc = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    desc:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -3)
    desc:SetPoint("RIGHT", row, "RIGHT", -150, 0)
    desc:SetJustifyH("LEFT")
    desc:SetText(fr and entry.descFR or entry.desc)

    if IsInstalled(entry.folder) then
        local status = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        status:SetPoint("RIGHT", row, "RIGHT", 0, 0)
        status:SetText(entry.folder == addonName and T.THIS or T.INSTALLED)
    else
        local button = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        button:SetSize(130, 24)
        button:SetPoint("RIGHT", row, "RIGHT", 0, 0)
        button:SetText(T.COPY)
        button:SetScript("OnClick", function()
            StaticPopup_Show(POPUP, nil, nil, Url(entry))
        end)
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(Url(entry), 1, 1, 1)
            GameTooltip:AddLine(T.COPY_TT, nil, nil, nil, true)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", GameTooltip_Hide)
    end
    return row
end

local function BuildPanel()
    local panel = CreateFrame("Frame")
    panel.name = T.TITLE

    local header = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    header:SetPoint("TOPLEFT", 16, -16)
    header:SetText(T.HEADER)

    local sub = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    sub:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -6)
    sub:SetText(T.SUB)

    local flavor, previous, others = Flavor(), sub, 0
    for _, entry in ipairs(ADDONS) do
        if entry.flavors[flavor] then
            previous = BuildRow(panel, entry, previous)
            if entry.folder ~= addonName then others = others + 1 end
        end
    end
    return panel, others
end

-- Registers the page under the addon's main settings category.
function About:Register(parentCategory)
    if not (Settings and Settings.RegisterCanvasLayoutSubcategory) then return end
    local panel, others = BuildPanel()
    if others == 0 then return end -- nothing else for this game version: no page
    Settings.RegisterCanvasLayoutSubcategory(parentCategory, panel, T.TITLE)
end
